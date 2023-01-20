import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/core/presentation/widgets/base_flushbar.dart';
import 'package:kitaby/features/cart/app/cart_bloc/cart_bloc.dart';
import 'package:kitaby/features/cart/models/cart_item_model.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/models/book_model.dart';
import '../../../authentication/data/models/user_model.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.cartItem,
    required this.book,
    required this.user,
  });

  final CartItemModel cartItem;
  final BookModel book;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(book.isbn),
      confirmDismiss: (direction) async {
        return await buildConfirmDeleteDialog(
          context,
          Theme.of(context).accentColor,
        );
      },
      onDismissed: (direction) async {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.phoneNumber)
            .collection('Cart')
            .doc('cartDoc')
            .collection('Cart_Items')
            .doc(cartItem.id)
            .delete()
            .then((value) {
          context.read<CartBloc>().add(CartEvent());
        });

        // buildBaseFlushBar(
        //   context: context,
        //   message: 'تم حذف الكتاب!',
        //   titleText: 'نجحت العملية',
        //   backgroundColor: Colors.green,
        // );
      },
      child: Container(
        width: 325.w,
        height: 131.h,
        margin: EdgeInsets.only(left: 15.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.1),
                spreadRadius: 1,
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ]),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 19.w),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                book.coverImageUrl,
                width: 77.w,
                height: 111.h,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 19.h,
                ),
                SizedBox(
                  width: 120.w,
                  child: Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                Text(
                  book.author,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                ),
                SizedBox(
                  height: 17.h,
                ),
                Text(
                  '${book.price} د.ل',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(
              width: 70.w,
            ),
            Container(
              width: 29.w,
              height: 90.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.1),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 0),
                    ),
                  ]),
              child: Column(
                children: [
                  SizedBox(
                    height: 9.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (cartItem.quantity < book.quantity) {
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(user.phoneNumber)
                            .collection('Cart')
                            .doc('cartDoc')
                            .collection('Cart_Items')
                            .doc(cartItem.id)
                            .update({
                          'quantity': cartItem.quantity + 1,
                        });
                        context.read<CartBloc>().add(CartEvent());
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/Ellipse 1.png'),
                        Image.asset('assets/images/Rectangle 24.png'),
                        Image.asset('assets/images/Rectangle 25.png'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  Text(
                    cartItem.quantity.toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFF949494),
                        ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (cartItem.quantity > 1) {
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(user.phoneNumber)
                            .collection('Cart')
                            .doc('cartDoc')
                            .collection('Cart_Items')
                            .doc(cartItem.id)
                            .update({
                          'quantity': cartItem.quantity - 1,
                        });
                        context.read<CartBloc>().add(CartEvent());
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/Ellipse 1.png'),
                        Image.asset('assets/images/Rectangle 25.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> buildConfirmDeleteDialog(
      BuildContext context, Color accentColor) {
    final textTheme = Theme.of(context).textTheme;
    return showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          contentTextStyle: textTheme.bodyText1,
          title: Text(
            'تأكيد الحذف',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف هذا المنتج',
            style: textTheme.bodyText2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'حذف',
                style: textTheme.bodyText2!.copyWith(
                  color: accentColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'الغاء',
                style: textTheme.bodyText2!.copyWith(
                  color: accentColor.withOpacity(.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
