part of 'orders_bloc.dart';

@immutable
class OrdersState {
  final List<OrderModel>? orders;

  const OrdersState({this.orders});
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersError extends OrdersState {}

class OrdersLoaded extends OrdersState {
  const OrdersLoaded({required List<OrderModel> orders})
      : super(orders: orders);
}
