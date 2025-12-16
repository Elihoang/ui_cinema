import '../enums/movie_category.dart';

extension MovieCategoryVN on MovieCategory {
  String get vi {
    switch (this) {
      case MovieCategory.movie:
        return 'Phim điện ảnh';
      case MovieCategory.series:
        return 'Phim bộ';
      case MovieCategory.documentary:
        return 'Tài liệu';
      case MovieCategory.animation:
        return 'Hoạt hình';
      case MovieCategory.action:
        return 'Hành động';
      case MovieCategory.comedy:
        return 'Hài';
      case MovieCategory.drama:
        return 'Chính kịch';
      case MovieCategory.horror:
        return 'Kinh dị';
      case MovieCategory.romance:
        return 'Lãng mạn';
      case MovieCategory.sciFi:
        return 'Khoa học viễn tưởng';
      case MovieCategory.thriller:
        return 'Giật gân';
      case MovieCategory.war:
        return 'Chiến tranh';
      case MovieCategory.western:
        return 'Viễn Tây';
      case MovieCategory.musical:
        return 'Nhạc kịch';
      case MovieCategory.family:
        return 'Gia đình';
      case MovieCategory.fantasy:
        return 'Giả tưởng';
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
}
