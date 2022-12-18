part of 'favorite_book_bloc.dart';

@immutable
class FavoriteBookEvent {
  final String bookISBN;

  const FavoriteBookEvent({required this.bookISBN});
}
