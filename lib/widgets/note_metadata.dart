```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/new_note/new_note_bloc.dart';
import '../bloc/new_note/new_note_event.dart';
import '../bloc/new_note/new_note_state.dart';
import '../core/constants.dart';
import '../core/dialogs.dart';
import '../core/utils.dart';
import '../models/note.dart';
import 'note_icon_button.dart';
import 'note_tag.dart';

class NoteMetadata extends StatelessWidget {
  const NoteMetadata({
    required this.note,
    super.key,
  });

  final Note? note;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewNoteBloc, NewNoteState>(
      builder: (context, state) {
        final tags = state.tags;

        return Column(
          children: [
            if (note != null) ...[
              Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Last Modified',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: gray500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      toLongDate(note!.dateModified),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: gray900,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Created',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: gray500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      toLongDate(note!.dateCreated),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: gray900,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      const Text(
                        'Tags',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: gray500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      NoteIconButton(
                        icon: FontAwesomeIcons.circlePlus,
                        onPressed: () async {
                          final tag =
                              await showNewTagDialog(context: context);

                          if (tag != null) {
                            context
                                .read<NewNoteBloc>()
                                .add(AddTagEvent(tag));
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 5,
                  child: tags.isEmpty
                      ? const Text(
                          'No tags added',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: gray900,
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              tags.length,
                              (index) => NoteTag(
                                label: tags[index],
                                onClosed: () {
                                  context.read<NewNoteBloc>().add(
                                        RemoveTagEvent(index),
                                      );
                                },
                                onTap: () async {
                                  final tag = await showNewTagDialog(
                                    context: context,
                                    tag: tags[index],
                                  );

                                  if (tag != null && tag != tags[index]) {
                                    context.read<NewNoteBloc>().add(
                                          UpdateTagEvent(tag, index),
                                        );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
```
