import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class GroupService {
  final Dio dio;
  GroupService(this.dio);

  // 공통 옵션: JSON 헤더 + 4xx 본문 읽기
  Options _jsonAuth({String? token, Map<String, String>? extraHeaders}) {
    return Options(
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?extraHeaders,
      },
      validateStatus: (code) => code != null && code < 500,
    );
  }

  String _serverMsg(Response res, {String fallback = '요청에 실패했습니다.'}) {
    try {
      final data = res.data;
      if (data is Map && data['error'] is String) return data['error'] as String;
      if (data is Map && data['message'] is String) return data['message'] as String;
      if (data is String && data.isNotEmpty) return data;
    } catch (_) {}
    return fallback;
  }

  // 🔹 그룹 생성
  Future<Map<String, dynamic>> createGroup({
    required String name,
    required String groupId,
    required String password,
    required String token,
  }) async {
    try {
      final res = await dio.post(
        '/api/groups/create',
        data: {
          'groupId': groupId.trim(),
          'password': password,
          'name': name.trim(),
        },
        options: _jsonAuth(token: token),
      );

      debugPrint('[createGroup] status=${res.statusCode} data=${res.data}');

      if (res.statusCode == 201) {
        if (res.data is Map<String, dynamic>) {
          return {'status': 'success', 'group': res.data as Map<String, dynamic>};
        }
        if (res.data is Map && res.data['group'] is Map) {
          return {
            'status': 'success',
            'group': Map<String, dynamic>.from(res.data['group'] as Map)
          };
        }
        return {'status': 'success', 'group': <String, dynamic>{}};
      }

      if (res.statusCode == 409) return {'status': 'conflict'};
      if (res.statusCode == 400) {
        throw Exception(_serverMsg(res, fallback: '입력값을 확인해주세요.'));
      }

      throw Exception('그룹 생성 실패: (${res.statusCode}) ${_serverMsg(res)}');
    } on DioException catch (e) {
      throw Exception('그룹 생성 실패: ${e.message}');
    }
  }

  // 🔹 그룹ID 중복 확인
  Future<bool> checkGroupId(String groupId) async {
    try {
      final res = await dio.get(
        '/api/groups/check-id',
        queryParameters: {'groupId': groupId.trim()},
        options: _jsonAuth(),
      );
      if (res.statusCode == 200 && res.data is Map) {
        return (res.data['available'] as bool?) ?? false;
      }
      throw Exception(_serverMsg(res, fallback: '중복 확인 실패'));
    } on DioException catch (e) {
      throw Exception('중복 확인 실패: ${e.message}');
    }
  }

  // 🔹 초대 코드로 그룹 참여
  Future<Map<String, dynamic>> joinGroup({
    required String invitationCode,
    required String token,
  }) async {
    try {
      final res = await dio.post(
        '/api/groups/join',
        data: {'invitationCode': invitationCode.trim()},
        options: _jsonAuth(token: token),
      );
      if (res.statusCode == 200) {
        return (res.data is Map<String, dynamic>)
            ? res.data as Map<String, dynamic>
            : {'data': res.data};
      }
      throw Exception(_serverMsg(res, fallback: '그룹 참여 실패'));
    } on DioException catch (e) {
      throw Exception('그룹 참여 실패: ${e.message}');
    }
  }

  // 🔹 groupId + password로 그룹 로그인
  Future<Map<String, dynamic>> joinGroupByCredential({
    required String groupId,
    required String password,
    required String token,
  }) async {
    try {
      final res = await dio.post(
        '/api/groups/login',
        data: {'groupId': groupId.trim(), 'password': password},
        options: _jsonAuth(token: token),
      );

      if (res.statusCode == 200) {
        return (res.data is Map<String, dynamic>)
            ? res.data as Map<String, dynamic>
            : {'data': res.data};
      }
      if (res.statusCode == 401) {
        return {'message': 'Invalid password'};
      }
      throw Exception(_serverMsg(res, fallback: '그룹 로그인 실패'));
    } on DioException catch (e) {
      throw Exception('그룹 로그인 실패: ${e.message}');
    }
  }

  // ✅ 대기 요청 승인
  Future<Map<String, dynamic>> approveJoinRequest({
    required String requestId,
    required String token,
  }) async {
    try {
      final res = await dio.post(
        '/api/groups/approve-request',
        data: {'requestId': requestId},
        options: _jsonAuth(token: token),
      );
      if (res.statusCode == 200) {
        return (res.data is Map<String, dynamic>)
            ? res.data as Map<String, dynamic>
            : {'data': res.data};
      }
      throw Exception(_serverMsg(res, fallback: '참여 승인 실패'));
    } catch (e) {
      throw Exception('참여 승인 실패: $e');
    }
  }

  // ✅ 대기 요청 거절
  Future<Map<String, dynamic>> rejectJoinRequest({
    required String requestId,
    required String token,
  }) async {
    try {
      final res = await dio.post(
        '/api/groups/reject-request',
        data: {'requestId': requestId},
        options: _jsonAuth(token: token),
      );
      if (res.statusCode == 200) {
        return (res.data is Map<String, dynamic>)
            ? res.data as Map<String, dynamic>
            : {'data': res.data};
      }
      throw Exception(_serverMsg(res, fallback: '참여 거절 실패'));
    } catch (e) {
      throw Exception('참여 거절 실패: $e');
    }
  }

  // ✅ 대기 요청 목록 조회
  Future<List<dynamic>> getPendingRequests({
    required String token,
  }) async {
    try {
      final res = await dio.get(
        '/api/groups/pending-requests',
        options: _jsonAuth(token: token),
      );
      if (res.statusCode == 200 && res.data is Map) {
        return List<dynamic>.from(res.data['pendingRequests'] ?? const []);
      }
      throw Exception(_serverMsg(res, fallback: '대기 요청 조회 실패'));
    } catch (e) {
      throw Exception('대기 요청 조회 실패: $e');
    }
  }

  // 🔹 그룹 목록 조회
  Future<List<Map<String, dynamic>>> getGroups(String token) async {
    try {
      final res = await dio.get(
        '/api/groups',
        options: _jsonAuth(token: token),
      );

      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List)
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);
      }

      if (res.statusCode == 200 && res.data is Map && res.data['groups'] is List) {
        return (res.data['groups'] as List)
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);
      }

      throw Exception(_serverMsg(res, fallback: '그룹 목록 조회 실패'));
    } on DioException catch (e) {
      throw Exception('그룹 목록 조회 실패: ${e.message}');
    }
  }
}
