import 'package:flutter/material.dart';
import 'package:flutter_markdown_editor/flutter_markdown_editor.dart';
import 'package:stook_database/database_context.dart';

import '../../../common/constants/constants.dart';
import '../../../common/widget/thesis_tab_bar.dart';
import '../bloc/note_scope.dart';

/// Экран добавления/изменения заметки.
class NotePutScreen extends StatefulWidget {
  const NotePutScreen({
    super.key,
    this.note,
    this.fromScreenIndex = 0,
  });

  final Note? note;
  final int fromScreenIndex;

  @override
  State<NotePutScreen> createState() => _NotePutScreenState();
}

class _NotePutScreenState extends State<NotePutScreen> {
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final isFavoriteNotifier = ValueNotifier<bool>(false);
  late final MarkDownEditor markDownEditor;

  @override
  void initState() {
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      textController.text = widget.note!.content;
      isFavoriteNotifier.value = widget.note!.isFavorite;
    }
    markDownEditor = MarkDownEditor(
      controller: textController,
    );
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();
    isFavoriteNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'Добавить заметку' : 'Изменить заметку',
        ),
        centerTitle: false,
        actions: [
          Visibility(
            visible: widget.note != null,
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                final deleted = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Удалить заметку?'),
                      content:
                          const Text('Вы уверены, что хотите удалить заметку?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Да'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Нет'),
                        ),
                      ],
                    );
                  },
                );
                if (deleted != null && deleted) {
                  NoteScope.deleteNote(
                    context,
                    noteId: widget.note!.id,
                    fromScreenIndex: widget.fromScreenIndex,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final title = titleController.text;
              final content = textController.text;

              if (title.isEmpty || content.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Заполните название и текст заметки'),
                  ),
                );
                return;
              }

              final puttedNote = Note(
                id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch,
                title: title,
                content: content,
                createdDate: widget.note?.createdDate ?? DateTime.now(),
                lastModifiedDate: DateTime.now(),
                isFavorite: isFavoriteNotifier.value,
              );
              NoteScope.savePuttedNote(
                context,
                note: puttedNote,
                fromScreenIndex: widget.fromScreenIndex,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintText: 'Название',
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'В избранное',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isFavoriteNotifier,
                          builder: (context, isFavorite, child) {
                            return Checkbox(
                              value: isFavorite,
                              onChanged: (value) {
                                isFavoriteNotifier.value = value!;
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ThesisTabBar(
              tabs: const ['Текст', 'Предпросмотр'],
              tabSpacing: 12,
              children: [
                Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: markDownEditor.field,
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: markDownEditor.preview,
                  ),
                ),
              ],
            ),
            if (widget.note != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Последнее изменение: ${kDateTimeFormat.format(widget.note!.lastModifiedDate)}',
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
