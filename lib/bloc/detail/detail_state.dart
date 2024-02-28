part of 'detail_bloc.dart';

@immutable
class DetailState {
  final List<AudioFile> list;
  final String message;
  final EnumStatus status;

  const DetailState({this.list = const [], this.message = '', this.status = EnumStatus.initial});

  DetailState copyWith({
    List<AudioFile>? list,
    String? message,
    EnumStatus? status,
  }) => DetailState(
    list: list ?? this.list,
    message: message ?? this.message,
    status: status ?? this.status,
  );
}