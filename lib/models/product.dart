class ProductItem {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final double? originalPrice;
  final String category;
  final bool
  isBestSeller; // Thêm trường này (default false nếu backend không có)

  ProductItem({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.category,
    this.isBestSeller = false, // Default false
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      category: json['category'] as String,
      isBestSeller:
          json['isBestSeller'] as bool? ??
          false, // Nếu backend có thì dùng, không thì false
    );
  }
}
