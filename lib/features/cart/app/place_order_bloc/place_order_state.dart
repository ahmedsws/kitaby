part of 'place_order_bloc.dart';

@immutable
abstract class PlaceOrderState {}

class PlaceOrderInitial extends PlaceOrderState {}

class PlaceOrderLoading extends PlaceOrderState {}

class OrderPlaced extends PlaceOrderState {}
