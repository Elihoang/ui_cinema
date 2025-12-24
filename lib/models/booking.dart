class BookingInfo {
  final String movieTitle;
  final String moviePoster;
  final String cinema;
  final String hall;
  final String showtime;
  final String date;
  final List<String> seats; // Seat names (e.g. "A1", "A2")
  final double ticketPrice;
  final double comboPrice;
  final double discount;

  // Additional fields for API integration
  final String showtimeId;
  final List<String> seatIds; // Seat IDs from backend
  final List<ProductOrderItem> products;

  BookingInfo({
    required this.movieTitle,
    required this.moviePoster,
    required this.cinema,
    required this.hall,
    required this.showtime,
    required this.date,
    required this.seats,
    required this.ticketPrice,
    required this.comboPrice,
    required this.discount,
    required this.showtimeId,
    required this.seatIds,
    this.products = const [],
  });

  double get subtotal => ticketPrice + comboPrice;
  double get total => subtotal - discount;
}

class ProductOrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double unitPrice;

  ProductOrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;
}

enum PaymentMethod { momo, card, applePay }
