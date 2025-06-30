import 'package:dio/dio.dart';

class GroupService {
  final Dio dio;

  GroupService(this.dio);

  // 🔹 그룹 생성 (JWT 토큰 기반 인증)
  Future<Map<String, dynamic>> createGroup({
    required String name,
    required bool hasAdmin,
    required String token,
  }) async {
    try {
      final response = await dio.post(
        '/api/groups/create',
        data: {
          'name': name,
          'hasAdmin': hasAdmin,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } on DioError catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('그룹 생성 실패: $e');
    }
  }

  // 🔹 초대 코드로 그룹 참여
  Future<Map<String, dynamic>> joinGroup({
    required String invitationCode,
    required String userId,
  }) async {
    try {
      final response = await dio.post(
        '/api/groups/join',
        data: {'invitationCode': invitationCode},
        options: Options(headers: {'x-user-id': userId}),
      );
      return response.data;
    } catch (e) {
      throw Exception('그룹 참여 실패: $e');
    }
  }

  // ✅ 그룹 참여 요청 (승인 대기)
  Future<Map<String, dynamic>> sendJoinRequest({
    required String groupId,
    required String userId,
    required String message,
  }) async {
    try {
      final response = await dio.post(
        '/api/groups/join-request',
        data: {
          'groupId': groupId,
          'userId': userId,
          'message': message,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('참여 요청 실패: $e');
    }
  }

  // ✅ 대기 요청 승인
  Future<Map<String, dynamic>> approveJoinRequest({
    required String requestId,
    required String adminUserId,
  }) async {
    try {
      final response = await dio.post(
        '/api/groups/approve-request',
        data: {'requestId': requestId},
        options: Options(headers: {'x-user-id': adminUserId}),
      );
      return response.data;
    } catch (e) {
      throw Exception('참여 승인 실패: $e');
    }
  }

  // ✅ 대기 요청 거절
  Future<Map<String, dynamic>> rejectJoinRequest({
    required String requestId,
    required String adminUserId,
  }) async {
    try {
      final response = await dio.post(
        '/api/groups/reject-request',
        data: {'requestId': requestId},
        options: Options(headers: {'x-user-id': adminUserId}),
      );
      return response.data;
    } catch (e) {
      throw Exception('참여 거절 실패: $e');
    }
  }

  // ✅ 대기 중 요청 목록 조회
  Future<List<dynamic>> getPendingRequests({
    required String adminUserId,
  }) async {
    try {
      final response = await dio.get(
        '/api/groups/pending-requests',
        options: Options(headers: {'x-user-id': adminUserId}),
      );
      return response.data['pendingRequests'];
    } catch (e) {
      throw Exception('대기 요청 조회 실패: $e');
    }
  }
}