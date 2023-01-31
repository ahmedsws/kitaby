class OrderModel {
  final String paymentMethod, status, id;
  final DateTime? dateCreated;
  final num totalPrice;

  const OrderModel({
    required this.id,
    required this.paymentMethod,
    required this.status,
    this.dateCreated,
    required this.totalPrice,
  });

  OrderModel.fromJson(Map<String, dynamic> json, String orderId)
      : id = orderId,
        paymentMethod = json['payment_method'],
        status = json['status'],
        dateCreated = json['date_created'],
        totalPrice = json['total_price'];
}
