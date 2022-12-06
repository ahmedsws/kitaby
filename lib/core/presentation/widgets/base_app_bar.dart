import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      title: Text(
        title,
        style: textTheme.headline5!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
