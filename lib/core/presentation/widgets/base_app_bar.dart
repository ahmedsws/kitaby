import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.actions,
  }) : super(key: key);

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

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
      actions: actions,
      elevation: 0,
      centerTitle: true,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
