part of 'place_order_bloc.dart';

@immutable
class PlaceOrderEvent {
  const PlaceOrderEvent({
    required this.totalPrice,
    required this.paymentMethod,
    required this.cartItems,
  });

  final num totalPrice;
  final String paymentMethod;

  final List<CartItemModel> cartItems;
}
