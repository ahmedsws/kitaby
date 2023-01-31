part of 'add_customer_book_bloc.dart';

@immutable
class AddCustomerBookEvent {
  final File? image;
  final String selectedDeal;

  const AddCustomerBookEvent({
    this.image,
    required this.selectedDeal,
  });
}
