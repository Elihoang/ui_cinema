/// Enum định nghĩa các role trong hệ thống
enum UserRole { admin, staff, customer, unknown }

extension UserRoleExtension on UserRole {
  /// Tên hiển thị của role
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Quản trị viên';
      case UserRole.staff:
        return 'Nhân viên';
      case UserRole.customer:
        return 'Khách hàng';
      case UserRole.unknown:
        return 'Không xác định';
    }
  }

  /// Kiểm tra xem role có phải là nhân viên (admin hoặc staff) không
  bool get isStaff => this == UserRole.admin || this == UserRole.staff;

  /// Kiểm tra xem role có phải là khách hàng không
  bool get isCustomer => this == UserRole.customer;
}

/// Parse role từ string (từ JWT token)
UserRole parseUserRole(String? roleStr) {
  if (roleStr == null || roleStr.isEmpty) return UserRole.unknown;

  switch (roleStr.toLowerCase()) {
    case 'admin':
    case 'administrator':
      return UserRole.admin;
    case 'staff':
    case 'employee':
      return UserRole.staff;
    case 'customer':
    case 'user':
      return UserRole.customer;
    default:
      return UserRole.unknown;
  }
}
