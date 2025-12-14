// screens/product_screen.dart (thay thế toàn bộ file cũ)
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart'; // Đổi đường dẫn nếu cần
import '../widgets/product/product_header.dart';
import '../widgets/product/product_category_chips.dart';
import '../widgets/product/product_item_card.dart';
import '../widgets/product/product_bottom_bar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<ProductItem>> futureProducts;

  String selectedCategory =
      'Combo Hot'; // Có thể thay bằng category đầu tiên sau khi load
  final Map<String, int> cart = {};

  List<ProductItem> allProducts = [];
  List<String> categories = [];

  List<ProductItem> get filteredItems {
    if (allProducts.isEmpty) return [];
    return allProducts
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  double get totalAmount {
    double total = 0;
    for (var entry in cart.entries) {
      final item = allProducts.firstWhere(
        (i) => i.id == entry.key,
        orElse: () => ProductItem(id: '', name: '', price: 0, category: ''),
      );
      total += item.price * entry.value;
    }
    return total;
  }

  double? get originalTotalAmount {
    double? total;
    for (var entry in cart.entries) {
      final item = allProducts.firstWhere(
        (i) => i.id == entry.key,
        orElse: () => ProductItem(id: '', name: '', price: 0, category: ''),
      );
      if (item.originalPrice != null) {
        total = (total ?? 0) + (item.originalPrice! * entry.value);
      } else {
        total = (total ?? 0) + (item.price * entry.value);
      }
    }
    return total != null && total > totalAmount ? total : null;
  }

  void _updateQuantity(String itemId, int quantity) {
    setState(() {
      if (quantity <= 0) {
        cart.remove(itemId);
      } else {
        cart[itemId] = quantity;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService.fetchProducts();
    futureProducts.then((products) {
      setState(() {
        allProducts = products;
        // Lấy categories động, unique và sort nếu cần
        categories = products.map((p) => p.category).toSet().toList();
        if (categories.isNotEmpty && !categories.contains(selectedCategory)) {
          selectedCategory = categories.first;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221013),
      body: Stack(
        children: [
          FutureBuilder<List<ProductItem>>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFEC1337)),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Lỗi tải dữ liệu: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              // Dữ liệu đã sẵn sàng
              return Column(
                children: [
                  ProductHeader(
                    onBack: () => Navigator.pop(context),
                    onSkip: () => Navigator.pop(context),
                  ),
                  ProductCategoryChips(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? const Center(
                            child: Text(
                              'Không có sản phẩm trong danh mục này',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(
                              16,
                            ).copyWith(bottom: 180),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final quantity = cart[item.id] ?? 0;
                              return ProductItemCard(
                                item: item,
                                quantity: quantity,
                                onQuantityChanged: (newQuantity) =>
                                    _updateQuantity(item.id, newQuantity),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ProductBottomBar(
              totalAmount: totalAmount,
              originalAmount: originalTotalAmount,
              onCheckout: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang xử lý thanh toán...'),
                    backgroundColor: Color(0xFFEC1337),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
