import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:meta/meta.dart';

import '../../../../utils/constants.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<FavoritesEvent>(
      (event, emit) async {
        emit(FavoritesLoading());
        final user = await Constants.getUser();
        if (user != null) {
          final favoritesSnapshot = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.phoneNumber)
              .collection('Favorites')
              .get();

          final booksSnapShot =
              await FirebaseFirestore.instance.collection('Books').get();

          // TODO: make the call better
          final favorites = favoritesSnapshot.docs.map(
            (favorite) {
              final book =
                  booksSnapShot.docs.firstWhere((doc) => doc.id == favorite.id);
              if (book.exists) {
                return BookModel.fromJson(book.data());
              }
            },
          ).toList();

          return emit(FavoritesLoaded(favorites: favorites));
        }
      },
    );
  }
}
