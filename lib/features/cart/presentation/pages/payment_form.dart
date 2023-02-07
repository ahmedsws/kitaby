import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
import 'package:kitaby/features/cart/app/place_order_bloc/place_order_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/presentation/widgets/base_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/presentation/widgets/base_flushbar.dart';
import '../../../../core/presentation/widgets/base_progress_indicator.dart';
import '../../../../core/presentation/widgets/input_box_column.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../app/cart_bloc/cart_bloc.dart';
import '../../models/cart_item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_placed_page.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  final num totalPrice;
  final List<CartItemModel> cartItems;

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController paymentAccountIdController;
  late TextEditingController paymentAccountPasswordController;

  final _formKey = GlobalKey<FormState>();

  bool isLoging = false;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    paymentAccountIdController = TextEditingController();
    paymentAccountPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<PlaceOrderBloc, PlaceOrderState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
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
        },
        child: Scaffold(
          appBar: const BaseAppBar(title: 'بيانات الدفع'),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    InputBoxColumn(
                      label: 'الاسم الأول',
                      hintText: 'أحمد',
                      suffixIconData: Icons.person,
                      controller: firstNameController,
                      validator: (p0) => firstNameController.text.isNotEmpty
                          ? null
                          : 'يجب إدخال الاسم الأول',
                    ),
                    InputBoxColumn(
                      label: 'الاسم الأخير',
                      hintText: 'محمود',
                      suffixIconData: Icons.person,
                      controller: lastNameController,
                      validator: (p0) => lastNameController.text.isNotEmpty
                          ? null
                          : 'يجب إدخال الاسم الأخير',
                    ),
                    InputBoxColumn(
                      label: 'رقم البطاقة',
                      hintText: 'fTvk23dfmnDjenwO',
                      suffixIconData: Icons.payment_rounded,
                      controller: paymentAccountIdController,
                      validator: (p0) =>
                          paymentAccountIdController.text.isNotEmpty
                              ? null
                              : 'يجب إدخال رقم البطاقة',
                    ),
                    InputBoxColumn(
                      label: 'الرقم السري',
                      hintText: '1234',
                      suffixIconData: Icons.password,
                      obscureText: true,
                      controller: paymentAccountPasswordController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      maxLength: 4,
                      validator: (p0) =>
                          paymentAccountPasswordController.text.length == 4
                              ? null
                              : 'يجب أن لا يقل الرقم السري عن 4 أرقام',
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    isLoging
                        ? const BaseProgressIndicator()
                        : BaseButton(
                            text: 'إجراء',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(
                                  () {
                                    isLoging = true;
                                  },
                                );

                                final paymentAccount = await FirebaseFirestore
                                    .instance
                                    .collection('Payment_Accounts')
                                    .doc(paymentAccountIdController.text)
                                    .get();

                                if (paymentAccount.exists) {
                                  // TODO: check exp date balnce first and last name
                                  // exp date

                                  if (paymentAccount.data()!['first_name'] ==
                                          firstNameController.text &&
                                      paymentAccount.data()!['last_name'] ==
                                          lastNameController.text) {
                                    if (paymentAccount.data()!['password'] ==
                                        int.parse(
                                          paymentAccountPasswordController.text,
                                        )) {
                                      final expDate =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              (paymentAccount
                                                          .data()!['exp_date']
                                                      as Timestamp)
                                                  .millisecondsSinceEpoch);

                                      if (DateTime.now().isBefore(expDate)) {
                                        if (widget.totalPrice <=
                                            paymentAccount.data()!['balance']) {
                                          await FirebaseFirestore.instance
                                              .collection('Payment_Accounts')
                                              .doc(paymentAccountIdController
                                                  .text)
                                              .update(
                                            {
                                              'balance': paymentAccount
                                                      .data()!['balance'] -
                                                  widget.totalPrice,
                                            },
                                          );
                                          context.read<PlaceOrderBloc>().add(
                                                PlaceOrderEvent(
                                                  totalPrice: widget.totalPrice,
                                                  paymentMethod: 'إلكتروني',
                                                  cartItems: widget.cartItems,
                                                ),
                                              );
                                        } else {
                                          buildBaseFlushBar(
                                            context: context,
                                            message:
                                                'رصيد البطاقة غير كافي لإجراء الطلب!',
                                          );
                                          setState(
                                            () {
                                              isLoging = false;
                                            },
                                          );
                                        }
                                      } else {
                                        buildBaseFlushBar(
                                          context: context,
                                          message:
                                              'تاريخ صلاحية البطاقة غير ساري المفعول!',
                                        );
                                        setState(
                                          () {
                                            isLoging = false;
                                          },
                                        );
                                      }
                                    } else {
                                      buildBaseFlushBar(
                                        context: context,
                                        message: 'خطأ في بيانات الدفع!',
                                      );
                                      setState(
                                        () {
                                          isLoging = false;
                                        },
                                      );
                                    }
                                  } else {
                                    buildBaseFlushBar(
                                      context: context,
                                      message: 'خطأ في بيانات الدفع!',
                                    );
                                    setState(
                                      () {
                                        isLoging = false;
                                      },
                                    );
                                  }
                                } else {
                                  buildBaseFlushBar(
                                    context: context,
                                    message: 'خطأ في بيانات الدفع!',
                                  );
                                  setState(
                                    () {
                                      isLoging = false;
                                    },
                                  );
                                }
                              } else {
                                buildBaseFlushBar(
                                  context: context,
                                  message: 'خطأ في بيانات الدفع!',
                                );
                                setState(
                                  () {
                                    isLoging = false;
                                  },
                                );
                              }
                            },
                          ),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
