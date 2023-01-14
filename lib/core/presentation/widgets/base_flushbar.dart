import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Flushbar<dynamic> buildBaseFlushBar(
    {required BuildContext context, required String message}) {
  return Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 3),
    titleText: Text(
      'حدث خطأ!',
      textDirection: TextDirection.rtl,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: 16.sp,
          ),
    ),
    messageText: Text(
      message,
      textDirection: TextDirection.rtl,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: 14.sp,
          ),
    ),
    textDirection: TextDirection.rtl,
  )..show(context);
}
