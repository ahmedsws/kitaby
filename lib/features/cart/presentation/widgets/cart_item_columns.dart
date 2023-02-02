import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/features/cart/app/cart_bloc/cart_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/presentation/widgets/base_progress_indicator.dart';
import '../../../../core/data/models/book_model.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../app/total_price_counter_cubit/total_price_counter_cubit.dart';
import 'cart_details_container.dart';
import 'cart_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemsColumn extends StatelessWidget {
  const CartItemsColumn({
    Key? key,
    required this.payemntMethod,
  }) : super(key: key);

  final ValueNotifier<String> payemntMethod;

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final String? result = prefs.getString('user');

    if (result != null) {
      final value = jsonDecode(result);

      return UserModel.fromJson(value);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            context.read<TotalPriceCounterCubit>().resetTotolPrice();
            return cartState is CartItemsLoaded
                ? cartState.cartItems!.isNotEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height: 360.h,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (cartState.books!.isNotEmpty)
                                    ...cartState.cartItems!.map(
                                      (cartItem) {
                                        final book =
                                            cartState.books!.firstWhere(
                                          (book) =>
                                              book.isbn == cartItem.bookISBN,
                                        );

                                        context
                                            .read<TotalPriceCounterCubit>()
                                            .calcTotalPrice(
                                              totalPrice: book.price! *
                                                  cartItem.quantity,
                                            );

                                        return Column(
                                          children: [
                                            FutureBuilder(
                                              future: getUser(),
                                              builder: (context, snapshot) {
                                                return snapshot
                                                            .connectionState ==
                                                        ConnectionState.done
                                                    ? CartItem(
                                                        cartItem: cartItem,
                                                        book: book,
                                                        user: snapshot.data!,
                                                      )
                                                    : const BaseProgressIndicator();
                                              },
                                            ),
                                            SizedBox(
                                              width: 26.w,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  SizedBox(
                                    height: 27.h,
                                  ),
                                  SizedBox(
                                    height: 37.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CartDetailsContainer(
                            payemntMethod: payemntMethod,
                            cartItems: cartState.cartItems!,
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 150.h,
                        child: Center(
                          child: Text(
                            'لا توجد كتب في السلة حاليا!',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                          ),
                        ),
                      )
                : const BaseProgressIndicator();
          },
        ),
      ],
    );
  }
}
