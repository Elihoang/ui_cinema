class MovieReview {
  final String id;
  final String userId;
  final String? userName;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  MovieReview({
    required this.id,
    required this.userId,
    this.userName,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory MovieReview.fromJson(Map<String, dynamic> json) {
    return MovieReview(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
