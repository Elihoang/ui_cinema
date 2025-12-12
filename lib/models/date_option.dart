// lib/models/date_option.dart
class DateOption {
  final String label;
  final int day;
  final bool isToday;

  const DateOption({
    required this.label,
    required this.day,
    this.isToday = false,
  });
}
