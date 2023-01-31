import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitaby/features/order/models/order_model.dart';
import 'package:meta/meta.dart';

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

          final orders = result.docs.map((order) {
            return OrderModel.fromJson(order.data(), order.reference.id);
          }).toList();

          return emit(
            OrdersLoaded(orders: orders),
          );
        } catch (e) {
          return emit(OrdersError());
        }
      },
    );
  }
}
