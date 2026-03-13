import '../../models/note.dart';

class NoteState {
  final Note? note;
  final String title;
  final String content;
  final List<String> tags;

  const NoteState({
    this.note,
    this.title = '',
    this.content = '',
    this.tags = const [],
  });

  NoteState copyWith({
    Note? note,
    String? title,
    String? content,
    List<String>? tags,
  }) {
    return NoteState(
      note: note ?? this.note,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
    );
  }
}