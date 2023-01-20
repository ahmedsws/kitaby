import 'package:flutter/material.dart';

import 'containers_decoration.dart';
import '../../../utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputBoxColumn extends StatelessWidget {
  const InputBoxColumn({
    Key? key,
    required this.label,
    required this.hintText,
    required this.suffixIconData,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.maxLength,
    this.keyboardType,
  }) : super(key: key);

  final String hintText, label;
  final IconData suffixIconData;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          label,
          style: textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Container(
          decoration: containersDecoration(context),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Constants.secondrayFontColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Icon(
                suffixIconData,
                color: Constants.secondrayFontColor,
              ),
            ),
            maxLength: maxLength,
            obscureText: obscureText,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
