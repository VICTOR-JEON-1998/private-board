import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';
import 'create_group_page.dart';
import 'join_group_page.dart';

class GroupHomePage extends ConsumerStatefulWidget {
  final String userId;
  const GroupHomePage({required this.userId, Key? key}) : super(key: key);

  @override
  ConsumerState<GroupHomePage> createState() => _GroupHomePageState();
}

class _GroupHomePageState extends ConsumerState<GroupHomePage> {
  List<dynamic> groups = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final service = ref.read(groupServiceProvider);
    try {
      final data = await service.getGroups(userId: widget.userId);
      setState(() {
        groups = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('그룹 목록')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: groups.isEmpty
                      ? const Center(child: Text('참여한 그룹이 없습니다.'))
                      : ListView.builder(
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            final group = groups[index];
                            return ListTile(
                              title: Text(group['name'] ?? ''),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CreateGroupPage()),
                          );
                        },
                        child: const Text('그룹 생성'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => JoinGroupPage(userId: widget.userId)),
                          );
                        },
                        child: const Text('그룹 참여'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
