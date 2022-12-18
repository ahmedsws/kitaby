class OrderModel {
  final String id, paymentMethod, status;
  final DateTime? dateCreated;
  final num totalPrice;

  const OrderModel(
      {required this.id,
      required this.paymentMethod,
      required this.status,
      this.dateCreated,
      required this.totalPrice});

  OrderModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        paymentMethod = json['payment_method'],
        status = json['status'],
        dateCreated = json['date_created'],
        totalPrice = json['total_price'];
}
