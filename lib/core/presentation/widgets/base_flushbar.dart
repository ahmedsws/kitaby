import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Flushbar<dynamic> buildBaseFlushBar(
    {required BuildContext context, required String titleText}) {
  return Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 3),
    titleText: Text(
      titleText,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: 20.sp,
          ),
    ),
  )..show(context);
}
