import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) return ""; // hoặc "Unknown" tùy nhu cầu
  final DateFormat formatter = DateFormat(
    'dd/MM/yyyy',
  ); // bạn muốn định dạng khác cũng được
  return formatter.format(date);
}
