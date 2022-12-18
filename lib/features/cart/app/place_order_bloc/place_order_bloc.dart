import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../../utils/constants.dart';

part 'place_order_event.dart';
part 'place_order_state.dart';

class PlaceOrderBloc extends Bloc<PlaceOrderEvent, PlaceOrderState> {
  PlaceOrderBloc() : super(PlaceOrderInitial()) {
    on<PlaceOrderEvent>(
      (event, emit) async {
        try {
          emit(PlaceOrderLoading());
          final user = await Constants.getUser();

          // if (user != null &&
          // paymethod.isNotEmpty &&
          // cart != null &&
          // books != null) {
          final order = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.id)
              .collection('Orders')
              .add(
            {
              // 'id': 1,
              'total_price': event.totalPrice,
              'payment_method': event.paymentMethod,
              'status': 'تحت المراجعة',
              // 'date_created': DateTime.now(),
            },
          );

          final cartItems = await event.cart.get();

          for (var cartItem in cartItems.docs) {
            Map<String, dynamic> data = cartItem.data() as Map<String, dynamic>;

            await order.collection('Order_Items').add(data);

            await cartItem.reference.delete();
          }

          emit(OrderPlaced());
        } catch (e) {
          emit(PlaceOrderLoading());
        }
      },
    );
  }
}
