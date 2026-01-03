class Cinema {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? address;
  final String? city;
  final String? phone;
  final String? email;
  final String? website;
  final double? latitude;
  final double? longitude;
  final String? bannerUrl;
  final int totalScreens;
  final List<String>? facilities;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // NEW: Phim đang chiếu
  final List<MovieCurrentlyShowing> currentlyShowingMovies;

  Cinema({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.address,
    this.city,
    this.phone,
    this.email,
    this.website,
    this.latitude,
    this.longitude,
    this.bannerUrl,
    required this.totalScreens,
    this.facilities,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.currentlyShowingMovies,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      bannerUrl: json['bannerUrl'] as String?,
      totalScreens: json['totalScreens'] as int,
      facilities: (json['facilities'] as List<dynamic>?)?.cast<String>(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      currentlyShowingMovies:
          (json['currentlyShowingMovies'] as List<dynamic>?)
              ?.map((m) => MovieCurrentlyShowing.fromJson(m))
              .toList() ??
          [],
    );
  }
}

// Model nhỏ cho phim đang chiếu ở rạp
class MovieCurrentlyShowing {
  final String id;
  final String title;
  final String? posterUrl;

  MovieCurrentlyShowing({
    required this.id,
    required this.title,
    this.posterUrl,
  });

  factory MovieCurrentlyShowing.fromJson(Map<String, dynamic> json) {
    return MovieCurrentlyShowing(
      id: json['id'] as String,
      title: json['title'] as String,
      posterUrl: json['posterUrl'] as String?,
    );
  }

  // Để dùng trong CinemaMovieList
  Map<String, String> toMap() => {'title': title, 'image': posterUrl ?? ''};
}
