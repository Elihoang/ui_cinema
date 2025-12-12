class BookingInfo {
  final String movieTitle;
  final String moviePoster;
  final String cinema;
  final String hall;
  final String showtime;
  final String date;
  final List<String> seats;
  final double ticketPrice;
  final double comboPrice;
  final double discount;

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
  });

  double get subtotal => ticketPrice + comboPrice;
  double get total => subtotal - discount;
}

enum PaymentMethod { momo, card, applePay }
