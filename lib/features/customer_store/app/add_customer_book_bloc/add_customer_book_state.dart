part of 'add_customer_book_bloc.dart';

@immutable
abstract class AddCustomerBookState {}

class AddCustomerBookInitial extends AddCustomerBookState {}

class AddCustomerBookLoading extends AddCustomerBookState {}

class AddCustomerBookAdded extends AddCustomerBookState {}

class AddCustomerBookError extends AddCustomerBookState {}
