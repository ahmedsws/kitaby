import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitaby/core/data/models/book_model.dart';

class OrderItemModel {
  final String bookISBN, id;
  final int quantity;

  const OrderItemModel({
    required this.bookISBN,
    required this.quantity,
    required this.id,
  });

  OrderItemModel.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json)
      : bookISBN = json.data()['book_isbn'],
        quantity = json.data()['quantity'],
        id = json.id;

  Map<String, Object?> toJson() => {
        'book_isbn': bookISBN,
        'quantity': quantity,
      };
}
