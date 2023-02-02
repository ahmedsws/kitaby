part of 'favorite_book_bloc.dart';

@immutable
abstract class FavoriteBookEvent {}

class FavoriteEvent implements FavoriteBookEvent {
  final String bookISBN;

  const FavoriteEvent({required this.bookISBN});
}

class CheckFavoritedBook implements FavoriteBookEvent {
  final String bookISBN;

  const CheckFavoritedBook({required this.bookISBN});
}
