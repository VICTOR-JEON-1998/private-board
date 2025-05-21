import 'package:dio/dio.dart';

class GroupService {
  final Dio dio;

  GroupService(this.dio);

  Future<Map<String, dynamic>> createGroup({
    required String name,
    required bool hasAdmin,
  }) async {
    final response = await dio.post('/groups/create', data: {
      'name': name,
      'hasAdmin': hasAdmin,
    });

    return response.data;
  }

  Future<String> joinGroup({
    required String invitationCode,
  }) async {
    final response = await dio.post('/groups/join', data: {
      'invitationCode': invitationCode,
    });

    return response.data['message'];
  }
}
