import 'actor.dart';
import 'movie_review.dart';
import '../enums/movie_category.dart';
import '../utils/movie_category_parser.dart';

class MovieDetail {
  final String id;
  final String title;
  final String slug;
  final int durationMinutes;
  final String? description;
  final int ageLimit;
  final String? posterUrl;
  final String? trailerUrl;
  final DateTime releaseDate;
  final String category;
  final String status;
  final DateTime createdAt;
  final List<Actor> actors;
  final List<MovieReview> reviews;
  final double? averageRating;
  final int? totalReviews;

  MovieDetail({
    required this.id,
    required this.title,
    required this.slug,
    required this.durationMinutes,
    this.description,
    required this.ageLimit,
    this.posterUrl,
    this.trailerUrl,
    required this.releaseDate,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.actors,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      durationMinutes: json['durationMinutes'] as int,
      description: json['description'] as String?,
      ageLimit: json['ageLimit'] as int,
      posterUrl: json['posterUrl'] as String?,
      trailerUrl: json['trailerUrl'] as String?,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      category: json['category'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      actors:
          (json['actors'] as List<dynamic>?)
              ?.map((e) => Actor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => MovieReview.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      averageRating: json['averageRating'] != null
          ? (json['averageRating'] as num).toDouble()
          : null,
      totalReviews: json['totalReviews'] as int?,
    );
  }
}
