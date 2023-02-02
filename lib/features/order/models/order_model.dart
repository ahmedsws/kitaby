import 'order_item_model.dart';

class OrderModel {
  final String paymentMethod, status, id;
  final DateTime? dateCreated;
  final num totalPrice;
  final List<OrderItemModel> orderItems;

  const OrderModel({
    required this.id,
    required this.paymentMethod,
    required this.status,
    this.dateCreated,
    required this.totalPrice,
    required this.orderItems,
  });

  OrderModel.fromJson({
    required Map<String, dynamic> json,
    required String orderId,
    required List<OrderItemModel> orderItems,
  })  : id = orderId,
        paymentMethod = json['payment_method'],
        status = json['status'],
        dateCreated = json['date_created'],
        totalPrice = json['total_price'],
        orderItems = orderItems;
}
