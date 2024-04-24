import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../common/widget/thesis_tab_bar.dart';
import 'bloc/note_bloc.dart';
import 'bloc/note_scope.dart';
import 'note_put/note_put_screen.dart';
import 'widget/note_list.dart';

/// Страница экрана заметок.
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final tabIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    tabIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<INoteBloc, NoteState>(
      bloc: NoteScope.of(context)..add(const NoteEvent.load()),
      listener: (context, state) {
        state.mapOrNull(
          loaderShow: (_) => context.loaderOverlay.show(),
          loaderHide: (_) => context.loaderOverlay.hide(),
          openPutNoteScreen: (state) => Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => NotePutScreen(
                        note: state.note,
                        fromScreenIndex: tabIndexNotifier.value,
                      )))
              .whenComplete(() => NoteScope.load(context)),
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Заметки'),
            centerTitle: false,
            surfaceTintColor: Colors.transparent,
          ),
          floatingActionButton: ValueListenableBuilder<int>(
            valueListenable: tabIndexNotifier,
            builder: (context, tabIndex, child) {
              return FloatingActionButton(
                onPressed: () => NoteScope.putNote(
                  context,
                  fromScreenIndex: tabIndex,
                ),
                child: const Icon(Icons.add),
              );
            },
          ),
          body: Center(
            child: state.whenOrNull(
              loaded: (notes) => Visibility(
                visible: notes.isEmpty,
                child: const Text('Заметок нет'),
                replacement: ThesisTabBar(
                  initialScreenIndex: tabIndexNotifier.value,
                  tabs: const ['Все', 'Избранные'],
                  onTap: (index) => tabIndexNotifier.value = index,
                  children: [
                    NoteList(notes: notes),
                    NoteList(
                      notes: notes.where((note) => note.isFavorite).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
