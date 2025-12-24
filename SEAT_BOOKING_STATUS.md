# Seat Booking Status Implementation

## Overview
This document describes the implementation of seat booking status display in the seat selection screen. The system now shows which seats are already booked by other users in real-time.

## Changes Made

### 1. Updated Seat Model (`lib/models/seat.dart`)
The model now supports both API responses:
- **Seats API** (`SeatResponseDto`): Includes `screenId`, `qrOrderingCode`, `isActive`
- **Showtimes API** (`SeatWithStatusDto`): Includes `status`, `price`, `heldByUserId`

Added fields:
- `status` (int?): Seat status from backend `SeatStatus` enum
  - `0` = Available
  - `1` = Sold (confirmed order exists in OrderTickets)
  - `2` = Holding (pending order exists and not expired)
- `price` (double?): Calculated seat price (base price × surcharge rate)
- `heldByUserId` (String?): User ID who is holding/has booked this seat

Made nullable:
- `screenId`, `qrOrderingCode`: Only present in Seats API response
- `isActive`: Defaults to `true` when not provided

Added helper getters:
- `isBooked`: Returns true if seat status is Sold or Holding
- `isAvailable`: Returns true if seat is active AND available (status = 0 or null)

### 2. Added New API Method (`lib/services/seat_service.dart`)
Created `getSeatsByShowtimeId(String showtimeId)` method that:
- Calls the Showtimes API endpoint: `GET /api/Showtimes/{showtimeId}/seats`
- Returns seats with their current booking status for the specific showtime
- Parses the response structure: `{data: {seats: [...], showtimeId, screenId, ...}}`

**Backend Logic** (in `ShowtimeService.GetSeatsWithStatusAsync`):
1. Gets all seats for the screen
2. Queries `OrderTickets` table to find:
   - **Sold seats**: Orders with status `Confirmed`
   - **Holding seats**: Orders with status `Pending` and not expired
3. Checks Redis cache for temporarily held seats (via `SeatHoldService`)
4. Calculates price based on showtime base price and seat type surcharge
5. Returns seats with status, price, and holder information


### 3. Updated Seat Selection Screen (`lib/screens/seat_selection_screen.dart`)
Changed seat fetching logic:
- **Before**: Used `SeatService.getActiveSeatsByScreenId()` - only showed active seats
- **After**: Uses `SeatService.getSeatsByShowtimeId()` - shows seats with booking status

### 4. Enhanced Seat Widget (`lib/widgets/seat/seat_widget.dart`)
Updated visual representation:
- **Booked seats**: Display with gray color and large "X" icon (size 16)
- **Inactive seats**: Display with gray color and small "X" icon (size 12)  
- **Selected seats**: Display with red color and seat code
- **VIP seats**: Display with gold color and star icon
- **Couple seats**: Display with pink color and heart icon
- **Normal available seats**: Display with light color, no icon

Tap behavior:
- Only `isAvailable` seats (active AND not booked) can be tapped
- Booked and inactive seats are not selectable

## API Response Structure

The Showtimes seats endpoint returns:

```json
{
  "data": {
    "showtimeId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "screenId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "screenName": "string",
    "showDateTime": "2025-12-24T08:43:38.832Z",
    "seats": [
      {
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "seatRow": "string",
        "seatNumber": 0,
        "seatCode": "string",
        "seatTypeCode": "string",
        "status": 0,
        "price": 0,
        "heldByUserId": "string"
      }
    ]
  }
}
```

## Seat Status Values

Backend uses `SeatStatus` enum with 3 possible values:

| Status Value | Enum Name | Condition | Description |
|--------------|-----------|-----------|-------------|
| `0` | Available | No order exists OR order cancelled/expired | Seat is **available** for booking |
| `1` | Sold | OrderTicket exists with Order.Status = `Confirmed` | Seat is **sold** (payment confirmed) |
| `2` | Holding | OrderTicket exists with Order.Status = `Pending` AND not expired | Seat is **temporarily held** (payment pending) |

### How Backend Determines Status

The `ShowtimeService.GetSeatsWithStatusAsync` method determines seat status by:

1. **Checking Sold Seats**:
   ```csharp
   // Query OrderTickets table
   var soldSeatIds = await _context.OrderTickets
       .Where(ot => ot.ShowtimeId == showtimeId && 
                    ot.Order.Status == OrderStatus.Confirmed)
       .Select(ot => ot.SeatId)
       .ToListAsync();
   ```

2. **Checking Holding Seats**:
   ```csharp
   // Check both database (pending orders) and Redis cache (temp holds)
   var now = DateTime.UtcNow;
   var pendingOrders = await _context.OrderTickets
       .Where(ot => ot.ShowtimeId == showtimeId &&
                    ot.Order.Status == OrderStatus.Pending &&
                    ot.Order.ExpireAt > now)
       .Select(ot => ot.SeatId)
       .ToListAsync();
   
   var heldSeats = await _seatHoldService.GetHeldSeatsAsync(...);
   ```

3. **Default to Available**: If seat is not in sold or holding lists, status = Available


## Visual Legend

The legend at the bottom of the seat selection screen shows:

| Status | Color | Icon | Description |
|--------|-------|------|-------------|
| Trống (Available) | Light beige | - | Can be selected |
| Đã đặt (Booked) | Gray | X | Already booked by another user |
| Đang chọn (Selected) | Red | Seat code | Currently selected by you |
| VIP | Gold | ★ | Available VIP seat |
| Couple | Pink | ♥ | Available couple seat |

## Testing

To test the feature:
1. Navigate to a showtime's seat selection screen
2. Verify that seats booked by other users show with gray color and "X" icon
3. Verify that booked seats cannot be tapped/selected
4. Verify that available seats can be selected normally
5. Verify that the seat status updates when refreshing the screen

## Backend Dependency

This feature requires the backend API endpoint:
- `GET /api/Showtimes/{id}/seats`

Make sure this endpoint is properly configured and returns the correct seat status information.
