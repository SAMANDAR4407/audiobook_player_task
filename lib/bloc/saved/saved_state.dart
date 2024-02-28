part of 'saved_bloc.dart';

@immutable
class SavedState {
  final List<Book> books;
  final EnumStatus status;
  final String message;

  const SavedState({this.books = const [], this.status = EnumStatus.initial, this.message = ''});

  SavedState copyWith({
    List<Book>? books,
    EnumStatus? status,
    String? message,
  }) => SavedState(books: books ?? this.books, status: status ?? this.status, message: message ?? this.message);
}
