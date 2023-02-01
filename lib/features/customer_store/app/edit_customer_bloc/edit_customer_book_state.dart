part of 'edit_customer_book_bloc.dart';

@immutable
abstract class EditCustomerBookState {}

class EditCustomerBookInitial extends EditCustomerBookState {}

class EditCustomerBookLoading extends EditCustomerBookState {}

class EditCustomerBookAdded extends EditCustomerBookState {}

class EditCustomerBookError extends EditCustomerBookState {}
