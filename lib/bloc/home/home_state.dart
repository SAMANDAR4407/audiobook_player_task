part of 'home_bloc.dart';

@immutable
class HomeState {
  final List<Book>? books;
  final List<Book>? topBooks;
  final EnumStatus? status;
  final String? message;

  const HomeState({
    this.books = const [],
    this.topBooks = const [],
    this.status = EnumStatus.initial,
    this.message = '',
  });

  HomeState copyWith({
    List<Book>? books,
    List<Book>? topBooks,
    EnumStatus? status,
    String? message,
  }) => HomeState(
    books: books ?? this.books,
    topBooks: topBooks ?? this.topBooks,
    status: status ?? this.status,
    message: message ?? this.message
  );
}
