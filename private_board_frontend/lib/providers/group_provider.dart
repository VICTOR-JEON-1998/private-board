import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/group_service.dart';
import 'dio_provider.dart';

final groupServiceProvider = Provider<GroupService>((ref) {
  final dio = ref.watch(dioProvider);
  return GroupService(dio);
});
