import '../enums/movie_category.dart';

/// Parse category string từ API thành MovieCategory enum
MovieCategory parseMovieCategory(String? value) {
  print('[parseMovieCategory] Input: "$value" (type: ${value.runtimeType})');

  if (value == null || value.trim().isEmpty) {
    print('[parseMovieCategory] → other (null/empty)');
    return MovieCategory.other;
  }

  final cleanValue = value.trim().toLowerCase();
  print('[parseMovieCategory] Clean: "$cleanValue"');

  // Tìm enum matching với tên (case-insensitive)
  final result = MovieCategory.values.firstWhere(
    (e) {
      final enumName = e.name.toLowerCase();
      print('[parseMovieCategory] Comparing "$cleanValue" with "$enumName"');
      return enumName == cleanValue;
    },
    orElse: () {
      print('[parseMovieCategory] → other (no match found)');
      return MovieCategory.other;
    },
  );

  print('[parseMovieCategory] → ${result.name}');
  return result;
}
