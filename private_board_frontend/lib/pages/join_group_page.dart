import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';

class JoinGroupPage extends ConsumerWidget {
  const JoinGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeController = TextEditingController();

    return Scaffold(
        appBar: AppBar(title: Text('그룹 참여')),
    body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    TextField(
    controller: codeController,
    decoration: InputDecoration(labelText: '초대 코드 입력'),
    ),
    SizedBox(height: 16),
    ElevatedButton(
    onPressed: () async {
    try {
    final message = await ref
        .read(groupServiceProvider)
        .joinGroup(invitationCode: codeController.text.trim());

    showDialog(
    context: context,
    builder: (_) => AlertDialog(
