import '../product/product.dart';

/// Model chứa thông tin đơn hàng sản phẩm (chỉ sản phẩm, không có vé)
class ProductOrderInfo {
  final List<ProductCartItem> items;
  final double discount;

  ProductOrderInfo({required this.items, this.discount = 0});

  /// Tổng tiền trước giảm giá
  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Tổng tiền gốc (nếu có khuyến mãi)
  double? get originalTotal {
    double? total;
    for (var item in items) {
      if (item.product.originalPrice != null) {
        total = (total ?? 0) + (item.product.originalPrice! * item.quantity);
      } else {
        total = (total ?? 0) + item.totalPrice;
      }
    }
    return total != null && total > subtotal ? total : null;
  }

  /// Tổng tiền sau giảm giá
  double get total => subtotal - discount;

  /// Tổng số lượng sản phẩm
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
}

/// Item trong giỏ hàng
class ProductCartItem {
  final ProductItem product;
  final int quantity;

  ProductCartItem({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;
  double? get originalPrice =>
      product.originalPrice != null ? product.originalPrice! * quantity : null;
}
