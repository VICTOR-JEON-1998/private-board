import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostApi {
  static const _baseUrl = 'http://localhost:3000'; // 에뮬레이터는 10.0.2.2로 변경

  static final Dio _dio = Dio();

  /// 🔍 게시글 목록 조회
  static Future<List<dynamic>> fetchPosts() async {
    final url = '$_baseUrl/api/posts';

    try {
      final response = await _dio.get(url);
      return response.data;
    } catch (e) {
      print('❌ 게시글 목록 조회 실패: $e');
      return [];
    }
  }

  /// ✍️ 게시글 등록
  static Future<bool> create(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? prefs.getString('token');

    if (token == null) {
      print('❌ 로그인 토큰 없음: 글 작성 불가');
      return false;
    }

    try {
      final response = await _dio.post(
        '$_baseUrl/api/posts',
        data: {
          'title': title,
          'content': content,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('✅ 글 작성 성공');
        return true;
      } else {
        print('⚠️ 예상치 못한 응답 코드: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ 글 등록 요청 실패: $e');
      return false;
    }
  }

  static Future<bool> update(String id, String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? prefs.getString('token');

    if (token == null) {
      print('❌ 수정 요청 실패: 토큰 없음');
      return false;
    }

    try {
      final response = await _dio.put(
        '$_baseUrl/api/posts/$id',
        data: {
          'title': title,
          'content': content,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ 게시글 수정 성공');
        return true;
      } else {
        print('⚠️ 게시글 수정 실패 - 응답 코드: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ 게시글 수정 요청 예외: $e');
      return false;
    }
  }

  static Future<bool> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? prefs.getString('token');

    if (token == null) {
      print('❌ 삭제 요청 실패: 토큰 없음');
      return false;
    }

    try {
      final response = await _dio.delete(
        '$_baseUrl/api/posts/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ 게시글 삭제 성공');
        return true;
      } else {
        print('⚠️ 게시글 삭제 실패 - 응답 코드: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ 게시글 삭제 요청 예외: $e');
      return false;
    }
  }

}
