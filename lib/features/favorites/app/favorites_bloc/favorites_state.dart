part of 'favorites_bloc.dart';

@immutable
class FavoritesState {
  final List<BookModel?>? favorites;

  const FavoritesState({this.favorites});
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({required List<BookModel?>? favorites})
      : super(
          favorites: favorites,
        );
}

class FavoritesError extends FavoritesState {}
