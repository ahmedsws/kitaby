import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitaby/features/cart/models/cart_item_model.dart';
import 'package:kitaby/features/cart/presentation/widgets/cart_item.dart';
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

          final order = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.phoneNumber)
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

          for (var cartItem in event.cartItems) {
            await order.collection('Order_Items').add(cartItem.toJson());

            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.phoneNumber)
                .collection('Cart')
                .doc('cartDoc')
                .collection('Cart_Items')
                .doc(cartItem.id)
                .delete();
          }

          emit(OrderPlaced());
        } catch (e) {
          emit(PlaceOrderLoading());
        }
      },
    );
  }
}
