import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart'; // Navigator 등 context 필요 시

class PostApi {
  static const _baseUrl = 'http://localhost:3000';
  static final Dio _dio = Dio();

  // 토큰 불러오기
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? prefs.getString('token');
  }

  /// 🔍 게시글 목록 조회 (토큰 인증 포함 + 상세 로그)
  static Future<List<dynamic>> fetchPosts() async {
    final token = await _getToken();
    print('글목록 fetchPosts() 시 토큰: $token');

    final url = '$_baseUrl/api/posts';
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('글목록 API 응답 코드: ${response.statusCode}');
      print('글목록 API 응답 데이터: ${response.data}');
      return response.data;
    } catch (e, stack) {
      print('❌ 게시글 목록 조회 실패: $e');
      print('스택 트레이스: $stack');
      return [];
    }
  }

  /// ✍️ 게시글 등록
  static Future<bool> create(String title, String content) async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 로그인 토큰 없음: 글 작성 불가');
      return false;
    }
    try {
      final response = await _dio.post(
        '$_baseUrl/api/posts',
        data: {'title': title, 'content': content},
        options: Options(
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        ),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('❌ 글 등록 요청 실패: $e');
      return false;
    }
  }

  /// 게시글 수정
  static Future<bool> update(String id, String title, String content) async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 수정 요청 실패: 토큰 없음');
      return false;
    }
    try {
      final response = await _dio.put(
        '$_baseUrl/api/posts/$id',
        data: {'title': title, 'content': content},
        options: Options(
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('❌ 게시글 수정 요청 예외: $e');
      return false;
    }
  }

  /// 게시글 삭제
  static Future<bool> delete(String id) async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 삭제 요청 실패: 토큰 없음');
      return false;
    }
    try {
      final response = await _dio.delete(
        '$_baseUrl/api/posts/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('❌ 게시글 삭제 요청 예외: $e');
      return false;
    }
  }

  /// 🟡 이모지 리액션(공감/취소) API
  static Future<Map<String, dynamic>?> reactToPost(String postId, String emojiKey) async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 이모지 리액션 실패: 토큰 없음');
      return null;
    }
    try {
      final response = await _dio.post(
        '$_baseUrl/api/posts/$postId/reactions',
        data: {'emojiKey': emojiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        ),
      );
      print('이모지 리액션 응답: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ 이모지 리액션 실패: $e');
      return null;
    }
  }

  // ---- 아래에 Interceptor setup 함수(필요 시 main.dart 등에서 호출) ----
  static void setupDioInterceptor(BuildContext context) {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioError e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('accessToken');
            await prefs.remove('token');
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }
          return handler.next(e);
        },
      ),
    );
  }
}
