import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/features/cart/app/cart_bloc/cart_bloc.dart';
import 'package:kitaby/features/cart/models/cart_item_model.dart';
import 'package:kitaby/features/cart/presentation/pages/payment_form.dart';
import 'package:kitaby/features/cart/presentation/widgets/select_payment_row.dart';

import '../../../../core/presentation/widgets/base_button.dart';
import '../../../../core/presentation/widgets/base_progress_indicator.dart';
import '../../../../utils/constants.dart';
import '../../app/place_order_bloc/place_order_bloc.dart';
import '../../app/total_price_counter_cubit/total_price_counter_cubit.dart';
import '../pages/cart_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pages/order_placed_page.dart';

class CartDetailsContainer extends StatelessWidget {
  const CartDetailsContainer({
    Key? key,
    required this.payemntMethod,
    required this.cartItems,
  }) : super(key: key);

  final ValueNotifier<String> payemntMethod;
  final List<CartItemModel> cartItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        SelectPaymentRow(payemntMethod: payemntMethod),
        SizedBox(
          height: 10.h,
        ),
        Container(
          height: 140.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.1),
                spreadRadius: 1,
                blurRadius: 20,
              ),
            ],
          ),
          child: BlocBuilder<TotalPriceCounterCubit, num>(
            builder: (context, totalPriceState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المبلغ الإجمالي',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                        ),
                        totalPriceState != 0
                            ? Text(
                                '$totalPriceState د.ل',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                      color: Constants.secondrayFontColor,
                                    ),
                              )
                            : const BaseProgressIndicator()
                      ],
                    ),
                  ),
                  BlocBuilder<PlaceOrderBloc, PlaceOrderState>(
                    builder: (context, state) {
                      if (state is PlaceOrderLoading) {
                        return const BaseProgressIndicator();
                      } else if (state is OrderPlaced) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<CartBloc>(context),
                                  child: const OrderPlacedPage(),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return BaseButton(
                        text: 'إجراء الطلب',
                        onPressed: () async {
                          if (payemntMethod.value == 'إلكتروني') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BlocProvider<PlaceOrderBloc>.value(
                                  value:
                                      BlocProvider.of<PlaceOrderBloc>(context),
                                  child: BlocProvider<CartBloc>.value(
                                    value: BlocProvider.of<CartBloc>(context),
                                    child: PaymentForm(
                                      totalPrice: totalPriceState,
                                      cartItems: cartItems,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            context.read<PlaceOrderBloc>().add(
                                  PlaceOrderEvent(
                                    totalPrice: totalPriceState,
                                    paymentMethod: payemntMethod.value,
                                    cartItems: cartItems,
                                  ),
                                );
                          }
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
