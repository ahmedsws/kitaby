import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../../utils/constants.dart';

part 'favorite_book_event.dart';
part 'favorite_book_state.dart';

class FavoriteBookBloc extends Bloc<FavoriteBookEvent, FavoriteBookState> {
  FavoriteBookBloc() : super(FavoriteBookInitial()) {
    on<CheckFavoritedBook>((event, emit) async {
      try {
        final user = await Constants.getUser();

        if (user != null) {
          emit(FavoriteBookLoading());
          final fav = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.phoneNumber)
              .collection('Favorites')
              .doc(event.bookISBN)
              .get();

          if (fav.exists) {
            return emit(BookFavorited());
          } else {
            return emit(FavoriteBookInitial());
          }
        }
      } catch (e) {
        emit(FavoriteBookError());
      }
    });

    on<FavoriteEvent>((event, emit) async {
      try {
        final user = await Constants.getUser();

        if (user != null) {
          emit(FavoriteBookLoading());

          final fav = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.phoneNumber)
              .collection('Favorites')
              .doc(event.bookISBN)
              .get();

          if (fav.exists) {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.phoneNumber)
                .collection('Favorites')
                .doc(event.bookISBN)
                .delete();
            return emit(FavoriteBookInitial());
          } else {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.phoneNumber)
                .collection('Favorites')
                .doc(event.bookISBN)
                .set(
              {
                'book_isbn': event.bookISBN,
              },
            );
            return emit(BookFavorited());
          }
        }
      } catch (e) {
        emit(FavoriteBookError());
      }
    });
  }
}
