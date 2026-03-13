```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/note/note_bloc.dart';
import '../bloc/note/note_event.dart';
import '../bloc/note/note_state.dart';
import '../core/constants.dart';
import '../core/dialogs.dart';
import '../widgets/note_back_button.dart';
import '../widgets/note_icon_button_outlined.dart';
import '../widgets/note_metadata.dart';
import '../widgets/note_toolbar.dart';

class NewOrEditNotePage extends StatefulWidget {
  const NewOrEditNotePage({
    required this.isNewNote,
    super.key,
  });

  final bool isNewNote;

  @override
  State<NewOrEditNotePage> createState() => _NewOrEditNotePageState();
}

class _NewOrEditNotePageState extends State<NewOrEditNotePage> {
  late final TextEditingController titleController;
  late final QuillController quillController;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();

    quillController = QuillController.basic()
      ..addListener(() {
        context.read<NoteBloc>().add(
              UpdateContent(quillController.document),
            );
      });

    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isNewNote) {
        focusNode.requestFocus();
        context.read<NoteBloc>().add(SetReadOnly(false));
      } else {
        context.read<NoteBloc>().add(SetReadOnly(true));
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    quillController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        titleController.text = state.title;

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;

            if (!state.canSaveNote) {
              Navigator.pop(context);
              return;
            }

            final bool? shouldSave = await showConfirmationDialog(
              context: context,
              title: 'Do you want to save the note?',
            );

            if (shouldSave == null) return;

            if (shouldSave) {
              context.read<NoteBloc>().add(SaveNote());
            }

            if (context.mounted) Navigator.pop(context);
          },
          child: Scaffold(
            appBar: AppBar(
              leading: const NoteBackButton(),
              title: Text(widget.isNewNote ? 'New Note' : 'Edit Note'),
              actions: [
                NoteIconButtonOutlined(
                  icon: state.readOnly
                      ? FontAwesomeIcons.pen
                      : FontAwesomeIcons.bookOpen,
                  onPressed: () {
                    context
                        .read<NoteBloc>()
                        .add(SetReadOnly(!state.readOnly));

                    if (state.readOnly) {
                      focusNode.requestFocus();
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                  },
                ),
                NoteIconButtonOutlined(
                  icon: FontAwesomeIcons.check,
                  onPressed: state.canSaveNote
                      ? () {
                          context.read<NoteBloc>().add(SaveNote());
                          Navigator.pop(context);
                        }
                      : null,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title here',
                      hintStyle: TextStyle(
                        color: gray300,
                      ),
                      border: InputBorder.none,
                    ),
                    canRequestFocus: !state.readOnly,
                    onChanged: (value) {
                      context.read<NoteBloc>().add(UpdateTitle(value));
                    },
                  ),

                  NoteMetadata(
                    note: state.note,
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(color: gray500, thickness: 2),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: QuillEditor.basic(
                            configurations: QuillEditorConfigurations(
                              controller: quillController,
                              placeholder: 'Note here...',
                              expands: true,
                              readOnly: state.readOnly,
                            ),
                            focusNode: focusNode,
                          ),
                        ),
                        if (!state.readOnly)
                          NoteToolbar(controller: quillController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
```
