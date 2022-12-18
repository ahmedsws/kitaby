import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../../utils/constants.dart';

part 'favorite_book_event.dart';
part 'favorite_book_state.dart';

class FavoriteBookBloc extends Bloc<FavoriteBookEvent, FavoriteBookState> {
  FavoriteBookBloc() : super(FavoriteBookInitial()) {
    on<FavoriteBookEvent>((event, emit) async {
      try {
        final user = await Constants.getUser();
        if (user != null) {
          emit(FavoriteBookLoading());
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.id)
              .collection('Favorites')
              .doc(event.bookISBN)
              .set(
            {
              'book_isbn': event.bookISBN,
            },
          );

          return emit(BookFavorited());
        }
      } catch (e) {
        emit(FavoriteBookError());
      }
    });
  }
}
