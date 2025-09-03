// lib/models/group_dto.dart
class GroupDto {
  final String id;
  final String groupId;   // ← camelCase
  final String name;
  final DateTime createdAt;

  GroupDto({
    required this.id,
    required this.groupId,
    required this.name,
    required this.createdAt,
  });

  factory GroupDto.fromJson(Map<String, dynamic> json) {
    return GroupDto(
      id: json['id'] as String,
      groupId: json['groupId'] as String,   // ← 여기 수정
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
