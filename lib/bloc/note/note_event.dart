abstract class NoteEvent {}

class LoadNote extends NoteEvent {
  final Note note;

  LoadNote(this.note);
}

class UpdateTitle extends NoteEvent {
  final String title;

  UpdateTitle(this.title);
}

class UpdateContent extends NoteEvent {
  final String content;

  UpdateContent(this.content);
}

class AddTag extends NoteEvent {
  final String tag;

  AddTag(this.tag);
}