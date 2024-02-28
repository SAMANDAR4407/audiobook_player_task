import 'dart:async';

import 'package:audiobook_player/core/repository.dart';
import 'package:audiobook_player/util.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/model/audiofile.dart';
import '../../core/model/book.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final _repository = AppRepository();

  bool hasBook = false;

  DetailBloc() : super(const DetailState()) {
    on<DetailEvent>((event, emit) async {
      switch(event){
        case LoadAudioFiles():
          await _onLoadAudio(event, emit);
        case SaveBookToDb():
          await _saveBook(event, emit);
        case CheckBook():
          _checkBook(event, emit);
      }
    });
  }

  Future<void> _onLoadAudio(LoadAudioFiles event, Emitter emit) async {
    if(state.status == EnumStatus.loading) return;
    emit(state.copyWith(status: EnumStatus.loading));
    final response = await _repository.getAudioFiles(event.book!.id);
    try{
      emit(state.copyWith(list: response, status: EnumStatus.success));
    }catch(e){
      emit(state.copyWith(message: 'Error: $e', status: EnumStatus.fail));
    }
  }

  Future<void> _saveBook(SaveBookToDb event, Emitter emit) async {
    try{
      _repository.saveBook(event.book);
      emit(state.copyWith(message: 'Book saved'));
    }catch(e){
      //
    }
  }

  void _checkBook(CheckBook event, Emitter emit) async {
    hasBook = false;
    final list = await _repository.getDbBooks();
    try{
      if(list.isNotEmpty){
        for(var element in list){
          if(element.id == event.book.id){
            hasBook = true;
          }
        }
      }
    }catch(e){
      //
    }
  }
}
