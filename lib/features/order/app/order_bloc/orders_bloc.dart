import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitaby/features/order/models/order_item_model.dart';
import 'package:kitaby/features/order/models/order_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/data/models/book_model.dart';
import '../../../../utils/constants.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {
    on<OrdersEvent>(
      (event, emit) async {
        try {
          emit(OrdersLoading());

          final user = await Constants.getUser();

          final result = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.phoneNumber)
              .collection('Orders')
              .get();

          final booksDocs =
              await FirebaseFirestore.instance.collection('Books').get();

          final books = booksDocs.docs.map(
            (bookDoc) {
              return BookModel.fromJson(bookDoc.data());
            },
          ).toList();

          List<OrderModel> orders = [];
          for (var doc in result.docs) {
            final orderItemsQuery = await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.phoneNumber)
                .collection('Orders')
                .doc(doc.reference.id)
                .collection('Order_Items')
                .get();

            final orderItems = orderItemsQuery.docs
                .map(
                  (doc) => OrderItemModel.fromJson(doc),
                )
                .toList();

            orders.add(
              OrderModel.fromJson(
                json: doc.data(),
                orderId: doc.reference.id,
                orderItems: orderItems,
              ),
            );
          }

          return emit(
            OrdersLoaded(orders: orders, books: books),
          );
        } catch (e) {
          return emit(OrdersError());
        }
      },
    );
  }
}
