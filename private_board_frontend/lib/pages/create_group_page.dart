import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';
import '../providers/auth_provider.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _hasAdmin = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('그룹 이름을 입력해주세요')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final token = ref.read(tokenProvider);
      final result = await ref.read(groupServiceProvider).createGroup(
        name: name,
        hasAdmin: _hasAdmin,
        token: token,
      );

      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('그룹 생성 완료'),
          content: Text('초대코드: ${result['invitationCode']}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            )
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('그룹 생성')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '그룹 이름'),
            ),
            Row(
              children: [
                Checkbox(
                  value: _hasAdmin,
                  onChanged: (value) => setState(() => _hasAdmin = value ?? false),
                ),
                const Text('관리자 있음'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleCreate,
              child: Text(_isLoading ? '생성 중...' : '생성'),
            ),
          ],
        ),
      ),
    );
  }
}
