import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          Size(319.w, 60.h),
        ),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).accentColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
