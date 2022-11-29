import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/constants.dart';

class BooksColumn extends StatelessWidget {
  const BooksColumn({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/book2.jpg',
          height: 184.h,
          width: 117.w,
        ),
        SizedBox(
          height: 25.h,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              'كتب متداولة',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Constants.secondrayFontColor,
                    fontSize: 12.sp,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
