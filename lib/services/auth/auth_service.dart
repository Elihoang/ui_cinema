import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromAny(dynamic json) {
    dynamic obj = json;
    if (obj is Map && obj['result'] != null) obj = obj['result'];
    if (obj is Map && obj['data'] != null) obj = obj['data'];

    final map = (obj is Map) ? obj : <String, dynamic>{};

    final access = (map['accessToken'] ?? map['access_token'] ?? map['token'])
        ?.toString();
    final refresh = (map['refreshToken'] ?? map['refresh_token'])?.toString();

    if (access == null ||
        access.isEmpty ||
        refresh == null ||
        refresh.isEmpty) {
      throw Exception('Không đọc được accessToken/refreshToken từ response.');
    }

    return AuthTokens(accessToken: access, refreshToken: refresh);
  }
}

class AuthService {
  late final Dio _dio;

  AuthService() {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    if (baseUrl.isEmpty) {
      throw Exception('Thiếu BASE_URL trong .env');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl, // ví dụ: http://localhost:5081/api
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      '/Auth/login', // ✅ không lặp /api
      data: {'email': email, 'password': password},
    );
    return AuthTokens.fromAny(res.data);
  }

  Future<AuthTokens> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final res = await _dio.post(
      '/Auth/register', // ✅ không lặp /api
      data: {'email': email, 'password': password, 'fullName': fullName},
    );
    return AuthTokens.fromAny(res.data);
  }

  Future<void> logout({required String refreshToken}) async {
    await _dio.post(
      '/Auth/logout', // ✅ không lặp /api
      data: {'refreshToken': refreshToken},
    );
  }
}
