part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetBooks extends HomeEvent{}

class GetTopBooks extends HomeEvent{}
