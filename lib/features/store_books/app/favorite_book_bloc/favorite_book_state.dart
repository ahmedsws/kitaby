part of 'favorite_book_bloc.dart';

@immutable
abstract class FavoriteBookState {}

class FavoriteBookInitial extends FavoriteBookState {}

class FavoriteBookLoading extends FavoriteBookState {}

class BookFavorited extends FavoriteBookState {}

class FavoriteBookError extends FavoriteBookState {}
