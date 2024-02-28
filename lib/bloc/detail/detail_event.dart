part of 'detail_bloc.dart';

@immutable
abstract class DetailEvent {}

class LoadAudioFiles extends DetailEvent {
  final Book? book;

  LoadAudioFiles({required this.book});
}

class SaveBookToDb extends DetailEvent{
  final Book book;

  SaveBookToDb({required this.book});
}

class CheckBook extends DetailEvent{
  final Book book;

  CheckBook({required this.book});
}
