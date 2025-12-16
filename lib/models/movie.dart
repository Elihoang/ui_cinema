import '../enums/movie_category.dart';
import '../utils/movie_category_parser.dart';

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
  final MovieCategory category;
  final int agelimit;

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
    required this.category,
    this.agelimit = 0,
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
      category: parseMovieCategory(json['category'] as String?),
      agelimit: json['agelimit'] as int? ?? 0,
    );
  }
}
