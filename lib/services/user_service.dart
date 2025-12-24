import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../enums/user_role.dart';

/// Service quản lý thông tin người dùng từ JWT token
class UserService {
  static const _storage = FlutterSecureStorage();
  static const _kAccessToken = 'access_token';

  /// Lấy payload từ JWT token
  static Map<String, dynamic>? _decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return payload as Map<String, dynamic>;
    } catch (e) {
      print('Lỗi decode token: $e');
      return null;
    }
  }

  /// Lấy user ID từ token
  static Future<String?> getUserId() async {
    final token = await _storage.read(key: _kAccessToken);
    if (token == null || token.isEmpty) return null;

    final payload = _decodeToken(token);
    if (payload == null) return null;

    return payload['sub']?.toString() ??
        payload['nameidentifier']?.toString() ??
        payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']
            ?.toString();
  }

  /// Lấy email của user từ token
  static Future<String?> getEmail() async {
    final token = await _storage.read(key: _kAccessToken);
    if (token == null || token.isEmpty) return null;

    final payload = _decodeToken(token);
    if (payload == null) return null;

    return payload['email']?.toString() ??
        payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress']
            ?.toString();
  }

  /// Lấy tên của user từ token
  static Future<String?> getName() async {
    final token = await _storage.read(key: _kAccessToken);
    if (token == null || token.isEmpty) return null;

    final payload = _decodeToken(token);
    if (payload == null) return null;

    return payload['name']?.toString() ??
        payload['fullName']?.toString() ??
        payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name']
            ?.toString();
  }

  /// Lấy role của user từ token
  static Future<UserRole> getUserRole() async {
    final token = await _storage.read(key: _kAccessToken);
    if (token == null || token.isEmpty) return UserRole.unknown;

    final payload = _decodeToken(token);
    if (payload == null) return UserRole.unknown;

    // Thử các claim key phổ biến cho role
    final roleStr =
        payload['role']?.toString() ??
        payload['roles']?.toString() ??
        payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
            ?.toString();

    return parseUserRole(roleStr);
  }

  /// Kiểm tra user có phải là staff không (bao gồm admin)
  static Future<bool> isStaff() async {
    final role = await getUserRole();
    return role.isStaff;
  }

  /// Kiểm tra user có phải là customer không
  static Future<bool> isCustomer() async {
    final role = await getUserRole();
    return role.isCustomer;
  }

  /// Kiểm tra user đã đăng nhập chưa
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _kAccessToken);
    return token != null && token.isNotEmpty;
  }

  /// Lấy toàn bộ thông tin user
  static Future<UserInfo?> getUserInfo() async {
    final token = await _storage.read(key: _kAccessToken);
    if (token == null || token.isEmpty) return null;

    final payload = _decodeToken(token);
    if (payload == null) return null;

    final userId =
        payload['sub']?.toString() ??
        payload['nameidentifier']?.toString() ??
        payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']
            ?.toString();

    final email =
        payload['email']?.toString() ??
        payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress']
            ?.toString();

    final name =
        payload['name']?.toString() ??
        payload['fullName']?.toString() ??
        payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name']
            ?.toString();

    final roleStr =
        payload['role']?.toString() ??
        payload['roles']?.toString() ??
        payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
            ?.toString();

    return UserInfo(
      id: userId ?? '',
      email: email ?? '',
      name: name ?? '',
      role: parseUserRole(roleStr),
    );
  }
}

/// Model chứa thông tin user
class UserInfo {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  UserInfo({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  /// Kiểm tra user có phải là staff không
  bool get isStaff => role.isStaff;

  /// Kiểm tra user có phải là customer không
  bool get isCustomer => role.isCustomer;
}
