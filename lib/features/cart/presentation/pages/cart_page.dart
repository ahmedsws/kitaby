import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/core/presentation/widgets/base_app_bar.dart';
import 'package:kitaby/features/authentication/data/models/user_model.dart';
import 'package:kitaby/features/cart/app/cart_bloc/cart_bloc.dart';
import 'package:kitaby/features/cart/app/place_order_bloc/place_order_bloc.dart';
import 'package:kitaby/features/cart/app/total_price_counter_cubit/total_price_counter_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/cart_item_columns.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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

  ValueNotifier<String> payemntMethod = ValueNotifier('عند التوصيل');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await getUser();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc()..add(CartEvent()),
        ),
        BlocProvider(
          create: (context) => TotalPriceCounterCubit(),
        ),
        BlocProvider(
          create: (context) => PlaceOrderBloc(),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: const BaseAppBar(
            title: 'السلة',
            leading: SizedBox(),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                CartItemsColumn(
                  payemntMethod: payemntMethod,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
