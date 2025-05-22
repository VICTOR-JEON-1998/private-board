// ✅ GroupService - lib/services/group_service.dart
import 'package:dio/dio.dart';

class GroupService {
  final Dio dio;
  GroupService(this.dio);

  Future<Map<String, dynamic>> createGroup({
    required String name,
    required bool hasAdmin,
  }) async {
    try {
      final response = await dio.post('/api/groups/create', data: {
        'name': name,
        'hasAdmin': hasAdmin,
      });
      return response.data;
    } catch (e) {
      throw Exception('그룹 생성 실패: $e');
    }
  }

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
}
