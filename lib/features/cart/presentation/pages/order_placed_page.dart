import 'package:flutter/material.dart';
import 'package:kitaby/utils/constants.dart';

import '../../../../core/presentation/widgets/base_button.dart';
import '../../app/cart_bloc/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPlacedPage extends StatefulWidget {
  const OrderPlacedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderPlacedPage> createState() => _OrderPlacedPageState();
}

class _OrderPlacedPageState extends State<OrderPlacedPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.celebration,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'تم الطلب بنجاح!',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Constants.mainFontColor.withOpacity(.7),
                    ),
              ),
              const SizedBox(
                height: 80,
              ),
              BaseButton(
                text: 'العودة',
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      context.read<CartBloc>().add(CartEvent());
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
