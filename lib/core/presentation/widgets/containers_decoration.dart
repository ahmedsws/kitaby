import 'package:flutter/material.dart';

BoxDecoration containersDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).primaryColor,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFFE0E0E0).withOpacity(.45),
        blurRadius: 42,
        offset: const Offset(0, 14),
        spreadRadius: 0,
      )
    ],
  );
}
