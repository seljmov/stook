import 'package:flutter/material.dart';
import 'package:stook_database/database_context.dart';

import 'note_card.dart';

/// Список заметок.
class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
    required this.notes,
  });

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    final sortedNotes = notes.toList()
      ..sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.69,
      child: Visibility(
        visible: notes.isEmpty,
        child: const Center(
          child: Text(
            'Заметок пока нет',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        replacement: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = sortedNotes[index];
            return Padding(
              padding: EdgeInsets.only(top: index != 0 ? 16 : 0).copyWith(
                left: 16,
                right: 8,
                bottom: index == notes.length - 1 ? 64 : 0,
              ),
              child: NoteCard(note: note),
            );
          },
        ),
      ),
    );
  }
}
