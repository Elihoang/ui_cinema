class Movie {
  final String id;
  final String title;
  final String slug;
  final int durationMinutes;
  final String? description;
  final String? posterUrl;
  final String? trailerUrl;
  final DateTime releaseDate;
  final String? status;
  final String? category;

  Movie({
    required this.id,
    required this.title,
    required this.slug,
    required this.durationMinutes,
    this.description,
    this.posterUrl,
    this.trailerUrl,
    required this.releaseDate,
    this.status,
    this.category,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      durationMinutes: json['durationMinutes'] as int,
      description: json['description'] as String?,
      posterUrl: json['posterUrl'] as String?,
      trailerUrl: json['trailerUrl'] as String?,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      status: json['status'] as String?,
      category: json['category'] as String?,
    );
  }
}
