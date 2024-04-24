import 'package:flutter/material.dart';
import 'package:stook_database/database_context.dart';

import '../../../common/constants/constants.dart';
import '../bloc/note_scope.dart';

/// Карточка заметки.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Последнее изменение: ${kDateTimeFormat.format(note.lastModifiedDate)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => NoteScope.putNote(
              context,
              noteId: note.id,
              fromScreenIndex: 1,
            ),
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
