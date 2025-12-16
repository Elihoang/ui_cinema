import '../enums/movie_category.dart';

MovieCategory parseMovieCategory(String? value) {
  if (value == null) return MovieCategory.other;

  return MovieCategory.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => MovieCategory.other,
  );
}
