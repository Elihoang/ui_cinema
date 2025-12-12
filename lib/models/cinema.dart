class Cinema {
  final String name;
  final String address;
  final double distance;
  final List<ShowtimeFormat> formats;

  Cinema({
    required this.name,
    required this.address,
    required this.distance,
    required this.formats,
  });
}

class ShowtimeFormat {
  final String format; // "2D", "IMAX", "4DX"
  final String audioType; // "Phụ đề", "Lồng tiếng", "Thuyết minh"
  final List<ShowtimeSlot> showtimes;

  ShowtimeFormat({
    required this.format,
    required this.audioType,
    required this.showtimes,
  });
}

class ShowtimeSlot {
  final String time;
  final bool isAvailable;

  ShowtimeSlot({required this.time, this.isAvailable = true});
}
