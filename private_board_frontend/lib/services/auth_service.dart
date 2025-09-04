import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _baseUrl = 'http://localhost:3000';

  /// 🔐 회원가입
  static Future<String> register(String email, String password) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$_baseUrl/api/auth/register',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 201) return 'success';
      if (response.statusCode == 409) return 'conflict'; // 이미 존재
      return 'error';
    } catch (e) {
      print('❌ 회원가입 실패: $e');
      return 'error';
    }
  }

  /// 🔑 로그인 및 토큰 저장
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$_baseUrl/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('로그인 응답 코드: ${response.statusCode}');
      print('로그인 응답 데이터: ${response.data}');

      final token = response.data['accessToken'] ?? response.data['token'];
      final userEmail = response.data['user']?['email'];

      if (token != null && userEmail != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', token);
        await prefs.setString('userEmail', userEmail);
        return response.data; // 전체 response 반환
      }
    } catch (e) {
      print('❌ 로그인 실패: $e');
    }
    return null;
  }

  /// 현재 저장된 토큰 가져오기
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  /// 현재 저장된 유저 이메일 가져오기
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  /// 로그아웃 (토큰 + 유저이메일 삭제)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userEmail');
  }

  /// (선택) 토큰 유효성 검사 예시 (추가로 활용 가능)
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
