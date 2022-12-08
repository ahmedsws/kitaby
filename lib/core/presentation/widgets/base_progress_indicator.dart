import 'package:flutter/material.dart';

class BaseProgressIndicator extends StatelessWidget {
  const BaseProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: Theme.of(context).accentColor,
    ));
  }
}
