part of 'edit_customer_book_bloc.dart';

@immutable
class EditCustomerBookEvent {
  final File? image;
  final String selectedDeal;

  const EditCustomerBookEvent({
    this.image,
    required this.selectedDeal,
  });
}
