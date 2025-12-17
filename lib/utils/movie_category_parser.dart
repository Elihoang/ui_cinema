import '../enums/movie_category.dart';

MovieCategory parseMovieCategory(String? value) {
  if (value == null) return MovieCategory.other;

  return MovieCategory.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => MovieCategory.other,
  );
}

String getCategoryDisplayName(MovieCategory category) {
  switch (category) {
    case MovieCategory.movie:
      return 'Phim';
    case MovieCategory.series:
      return 'Phim bộ';
    case MovieCategory.documentary:
      return 'Phim tài liệu';
    case MovieCategory.animation:
      return 'Hoạt hình';
    case MovieCategory.action:
      return 'Hành động';
    case MovieCategory.comedy:
      return 'Hài kịch';
    case MovieCategory.drama:
      return 'Chính kịch';
    case MovieCategory.horror:
      return 'Kinh dị';
    case MovieCategory.romance:
      return 'Tình cảm';
    case MovieCategory.sciFi:
      return 'Khoa học viễn tưởng';
    case MovieCategory.thriller:
      return 'Ly kỳ';
    case MovieCategory.war:
      return 'Chiến tranh';
    case MovieCategory.western:
      return 'Viễn Tây';
    case MovieCategory.musical:
      return 'Nhạc kịch';
    case MovieCategory.family:
      return 'Gia đình';
    case MovieCategory.fantasy:
      return 'Thần thoại';
    case MovieCategory.adventure:
      return 'Phiêu lưu';
    case MovieCategory.biography:
      return 'Tiểu sử';
    case MovieCategory.history:
      return 'Lịch sử';
    case MovieCategory.sport:
      return 'Thể thao';
    case MovieCategory.religious:
      return 'Tôn giáo';
    case MovieCategory.other:
      return 'Khác';
  }
}
