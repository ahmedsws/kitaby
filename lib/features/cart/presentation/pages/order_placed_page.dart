import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/base_button.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          BaseButton(
            text: 'text',
            onPressed: () {
              setState(() {});
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
