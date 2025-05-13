import 'package:flutter/material.dart';

class EmojiReactionRow extends StatelessWidget {
  final List<Map<String, dynamic>> emojiList;
  final String? selectedEmojiKey;
  final void Function(String emojiKey) onTap;

  const EmojiReactionRow({
    super.key,
    required this.emojiList,
    required this.selectedEmojiKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: emojiList.map((e) {
        final isSelected = selectedEmojiKey == e['key'];
        return GestureDetector(
          onTap: () => onTap(e['key']),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber[200] : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Text(e['emoji'], style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 4),
                Text('${e['count']}', style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
