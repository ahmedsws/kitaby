import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'الطلبات',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Container(
                height: 513.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(
                        10,
                        (index) => Column(
                          children: [
                            Container(
                              width: 325.w,
                              height: 227.h,
                              margin: EdgeInsets.only(left: 15.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.1),
                                      spreadRadius: 1,
                                      blurRadius: 20,
                                      offset: Offset(0, 0),
                                    ),
                                  ]),
                              child: Column(
                                children: [
                                  SizedBox(height: 30.h,),
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 41.w,),
                                        Container(
                                          width: 77.w,
                                          height: 111.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Stack(
                                            alignment: Alignment.topLeft,
                                            children: [
                                              Image.asset('assets/images/book3.jpg', width: 77.w, height: 100.h,),
                                              // Image.asset('assets/images/book2.jpg',width: 67.w, height: 111.h,),
                                              // Image.asset('assets/images/book1.jpg',width: 57.w, height: 111.h,),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 52.w,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('طلب: 187254',
                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp,
                                            ),),
                                            SizedBox(height: 8.32.h,),
                                            Text('قيد التوصيل',
                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                                color: Color(0xff569750),
                                              ),),
                                            SizedBox(height: 9.h,),
                                            Text('130 د.ل',
                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                              ),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 43.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: 216.w,
                                        height: 33.h,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xff23311C)),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('تفاصيل الطلب',
                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                color: Color(0xff23311C),
                                                fontSize: 12.sp,
                                              ),),
                                            SizedBox(width: 10.w,),
                                            Icon(Icons.arrow_forward_ios, size: 12),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 30.h,),
                          ],
                        ),
                      ),
                      ]
                  ),
                ),
              ),
                  SizedBox(height: 90,),
                  Container(
                    alignment: Alignment.center,
                    width: 319.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF23311C),
                    ),
                    child: Text(
                      'التسوق',
                      style:
                      Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),

          ),
        ),

    );
  }
}
