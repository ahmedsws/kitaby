import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/features/cart/models/cart_item_model.dart';
import 'package:meta/meta.dart';

import '../../../../utils/constants.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartEvent>(
      (event, emit) async {
        emit(CartItemsLoading());
        final user = await Constants.getUser();

        if (user != null) {
          final cartItemsDocs = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.phoneNumber)
              .collection('Cart')
              .doc('cartDoc')
              .collection('Cart_Items')
              .get();
          final booksDocs =
              await FirebaseFirestore.instance.collection('Books').get();

          final cartItems = cartItemsDocs.docs.map(
            (cartItemDoc) {
              return CartItemModel.fromJson(cartItemDoc);
            },
          ).toList();

          final books = booksDocs.docs.map(
            (bookDoc) {
              return BookModel.fromJson(bookDoc.data());
            },
          ).toList();

          emit(
            CartItemsLoaded(
              cartItems: cartItems,
              books: books,
            ),
          );
        }
      },
    );
  }
}
