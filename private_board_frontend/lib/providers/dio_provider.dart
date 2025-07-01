import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // Backend base URL
      // 로컬 개발 시 Next.js API 서버 주소를 사용합니다.
      // API 경로는 서비스에서 '/api/...' 형태로 호출하므로
      // 여기서는 서버 루트 URL만 지정합니다.
      baseUrl: 'http://localhost:3000',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: const {
        'Content-Type': 'application/json',
      },
    ),
  );
  return dio;
});
