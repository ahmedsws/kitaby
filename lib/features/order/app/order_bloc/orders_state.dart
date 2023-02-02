part of 'orders_bloc.dart';

@immutable
class OrdersState {
  final List<OrderModel>? orders;
  final List<BookModel>? books;

  const OrdersState({this.orders, this.books});
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersError extends OrdersState {}

class OrdersLoaded extends OrdersState {
  const OrdersLoaded({
    required List<OrderModel> orders,
    required List<BookModel> books,
  }) : super(
          orders: orders,
          books: books,
        );
}
