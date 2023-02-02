import 'package:flutter/material.dart';
import 'package:kitaby/core/presentation/widgets/base_app_bar.dart';
import 'package:kitaby/core/presentation/widgets/base_progress_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/order_bloc/orders_bloc.dart';
import 'order_container.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => OrdersBloc()..add(OrdersEvent()),
        child: Scaffold(
          appBar: const BaseAppBar(
            title: 'الطلبات',
            leading: SizedBox(),
          ),
          body: BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, ordersState) {
              if (ordersState is OrdersLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ...ordersState.orders!.map(
                        (order) {
                          return OrderContainer(
                            order: order,
                            books: ordersState.books!,
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return const BaseProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
