part of 'edit_customer_book_bloc.dart';

@immutable
class EditCustomerBookEvent {
  final File? image;
  final String selectedDeal, isbn;
  final String? coverImageUrl;
  final bool status;
  final List<int> ratings;

  const EditCustomerBookEvent({
    this.image,
    this.coverImageUrl,
    required this.status,
    required this.selectedDeal,
    required this.isbn,
    required this.ratings,
  });
}
