class Movie {
  final String title;
  final String duration;
  final String genre;
  final double rating;
  final String imageUrl;
  final bool isImax;

  Movie({
    required this.title,
    required this.duration,
    required this.genre,
    required this.rating,
    required this.imageUrl,
    this.isImax = false,
  });
}

class UpcomingMovie {
  final String title;
  final String releaseDate;
  final String genre;
  final String description;
  final String imageUrl;

  UpcomingMovie({
    required this.title,
    required this.releaseDate,
    required this.genre,
    required this.description,
    required this.imageUrl,
  });
}
