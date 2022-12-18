part of 'place_order_bloc.dart';

@immutable
class PlaceOrderEvent {
  const PlaceOrderEvent({
    required this.totalPrice,
    required this.paymentMethod,
    required this.cart,
  });

  final num totalPrice;
  final String paymentMethod;
  final CollectionReference cart;
}
