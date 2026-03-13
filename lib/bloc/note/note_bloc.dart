import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {

  NoteBloc() : super(const NoteState()) {

    on<LoadNote>((event, emit) {
      emit(state.copyWith(
        note: event.note,
        title: event.note.title ?? '',
        content: event.note.contentJson,
        tags: event.note.tags ?? [],
      ));
    });

    on<UpdateTitle>((event, emit) {
      emit(state.copyWith(title: event.title));
    });

    on<UpdateContent>((event, emit) {
      emit(state.copyWith(content: event.content));
    });

    on<AddTag>((event, emit) {
      final updatedTags = List<String>.from(state.tags)..add(event.tag);
      emit(state.copyWith(tags: updatedTags));
    });

  }
}