import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/base_progress_indicator.dart';
import '../../../../core/data/models/book_model.dart';
import '../../app/total_price_counter_cubit/total_price_counter_cubit.dart';
import 'cart_details_container.dart';
import 'cart_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemsColumn extends StatelessWidget {
  const CartItemsColumn({
    Key? key,
    required this.cart,
    required this.books,
    required this.payemntMethod,
  }) : super(key: key);

  final CollectionReference<Object?>? cart;
  final CollectionReference<Object?>? books;
  final ValueNotifier<String> payemntMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (cart != null)
          FutureBuilder(
            future: cart!.get(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? snapshot.data!.docs.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 360.h,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    if (books != null)
                                      ...snapshot.data!.docs.map(
                                        (doc) {
                                          Map<String, dynamic> data = doc.data()
                                              as Map<String, dynamic>;
                                          // final bookitem = books.doc(data['book_isbn']).get();
                                          // final book = BookModel.fromJson();
                                          return FutureBuilder(
                                            future: books!
                                                .doc(data['book_isbn'])
                                                .get(),
                                            builder: (context, snapshot) {
                                              // TODO 'quantity']
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                final book = BookModel.fromJson(
                                                    snapshot.data!.data()!
                                                        as Map<String,
                                                            dynamic>);

                                                context
                                                    .read<
                                                        TotalPriceCounterCubit>()
                                                    .calcTotalPrice(
                                                        totalPrice: book.price);

                                                return Column(
                                                  children: [
                                                    CartItem(
                                                      book: book,
                                                      qua: data['quantity'],
                                                    ),
                                                    SizedBox(
                                                      width: 26.w,
                                                    ),
                                                  ],
                                                );
                                              }
                                              return const SizedBox();
                                            },
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
                                payemntMethod: payemntMethod, cart: cart),
                          ],
                        )
                      : SizedBox(
                          height: 150.h,
                          child: Center(
                            child: Text(
                              'لا توجد كتب في السلة حاليا!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
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
