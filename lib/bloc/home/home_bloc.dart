import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../core/model/book.dart';
import '../../core/repository.dart';
import '../../util.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  bool hasReachedMax = false;

  final _repository = AppRepository();

  HomeBloc() : super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
      switch (event) {
        case GetBooks():
          await _onGetBooks(event, emit);
        case GetTopBooks():
          await _onTopBooks(event, emit);
      }
    });
  }

  Future<void> _onTopBooks(GetTopBooks event, Emitter emit) async {
    try {
      emit(state.copyWith(topBooks: await _repository.getTopBooks()));
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> _onGetBooks(GetBooks event, Emitter emit) async {
    if (state.status == EnumStatus.loading) return;
    emit(state.copyWith(status: EnumStatus.loading));
    try {
      final response = await _repository.getApiBooks(state.books!.length, 20);
      if (response.isEmpty) {
        hasReachedMax = true;
      } else {
        emit(
          state.copyWith(status: EnumStatus.success, books: [...state.books as List<Book>, ...response]),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: EnumStatus.fail, message: 'Error: $e'));
    }
  }
}
