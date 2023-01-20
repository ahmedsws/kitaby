part of 'cart_bloc.dart';

@immutable
class CartState {
  const CartState({
    this.cartItems,
    this.books,
  });

  final List<CartItemModel>? cartItems;
  final List<BookModel>? books;
}

class CartInitial extends CartState {}

class CartItemsLoading extends CartState {}

class CartItemsLoaded extends CartState {
  const CartItemsLoaded({
    required List<CartItemModel> cartItems,
    required List<BookModel> books,
  }) : super(cartItems: cartItems, books: books);
}
