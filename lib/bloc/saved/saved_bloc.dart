import 'dart:async';

import 'package:audiobook_player/core/repository.dart';
import 'package:audiobook_player/util.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/model/book.dart';

part 'saved_event.dart';
part 'saved_state.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final _repository = AppRepository();

  bool hasReachedMax = false;

  SavedBloc() : super(const SavedState()) {
    on<SavedEvent>((event, emit) async {
      switch(event) {
        case LoadBooks():
          await _loadBooks(event, emit);
      }
    });
  }

  Future<void> _loadBooks(LoadBooks event, Emitter emit) async {
    if (state.status == EnumStatus.loading) return;
    emit(state.copyWith(status: EnumStatus.loading));
    try {
      final response = await _repository.getDbBooks();
      if (response.isEmpty) {
        hasReachedMax = true;
      } else {
        emit(
          state.copyWith(status: EnumStatus.success, books: [...response]),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: EnumStatus.fail, message: 'Error: $e'));
    }
  }
}
