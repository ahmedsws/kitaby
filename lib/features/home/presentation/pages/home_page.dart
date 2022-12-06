// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: SvgPicture.asset('assets/icons/search.svg'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/features/home/presentation/widgets/books_column.dart';
import 'package:kitaby/utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: PreferredSize(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 25.w,
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          'assets/images/pp.jpg',
                          width: 32.w,
                          height: 33.h,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 17.w,
                  ),
                  Text(
                    'مرحبا أحمد!',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: AppBar().preferredSize,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(right: 25.w),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 43.h,
                ),
                Text(
                  'كتب متداولة',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                ),
                SizedBox(
                  height: 26.h,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        10,
                        (index) => Row(
                          children: [
                            BooksColumn(title: 'معنى الحبتة'),
                            SizedBox(
                              width: 26.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 38.h,),
                Container(
                  margin: EdgeInsets.only(left:16.w , right: 20.w),
                    child: Divider()),
                SizedBox(height: 39.h,),
                Text('جديد',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),),
                SizedBox(height: 22.h,),
                   Column(
                    children: [
                      ...List.generate(
                        10,
                            (index) =>
                      Column(
                        children: [
                          Container(
                            width: 324.w,
                            height: 129.h,
                            margin: EdgeInsets.only(left: 15.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(.1),
                                spreadRadius: 1,
                                blurRadius: 20,
                                offset: Offset(0, 0),
                              ),]
                            ),
                            child:
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 19.w),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset('assets/images/الكتاب1.jpg',
                                  width: 77.w,
                                  height: 111.h,),
                                ),

                                Column(
                                  children: [
                                    SizedBox(height: 19.h,),
                                    Text('معني الحياة',
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),),
                                    SizedBox(height: 11.h,),
                                    Text('عبد الله الوهيبي',
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),),
                                    SizedBox(height: 17.h,),
                                    Row(
                                      children: [
                                        Image.asset('assets/images/Star 4.png',
                                        width: 14.w,
                                        height: 14.h,),
                                        Image.asset('assets/images/Star 4.png',
                                          width: 14.w,
                                          height: 14.h,),
                                        Image.asset('assets/images/Star 4.png',
                                          width: 14.w,
                                          height: 14.h,),
                                        Image.asset('assets/images/Star 4.png',
                                          width: 14.w,
                                          height: 14.h,),
                                        Image.asset('assets/images/Star 4.png',
                                          width: 14.w,
                                          height: 14.h,
                                          color: Color(0xFFEDEDEF),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                                SizedBox(width: 130.w,),
                                Column(
                                  children: [
                                    SizedBox(height: 16.h,),
                                    Image.asset('assets/images/Vector.png'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 9.h,),
                        ],
                      ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
