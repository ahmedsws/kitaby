import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String payMethod = 'إلكتروني';

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
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'السلة',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Column(
                children: [
                  Container(
                    height: 413.h,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(
                            10,
                            (index) => Column(
                              children: [
                                Container(
                                  width: 325.w,
                                  height: 131.h,
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
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 19.w),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/images/الكتاب1.jpg',
                                          width: 77.w,
                                          height: 111.h,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 19.h,
                                          ),
                                          Text(
                                            'معني الحياة',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp,
                                                ),
                                          ),
                                          SizedBox(
                                            height: 11.h,
                                          ),
                                          Text(
                                            'عبد الله الوهيبي',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey,
                                                ),
                                          ),
                                          SizedBox(
                                            height: 17.h,
                                          ),
                                          Container(
                                            child: Text(
                                              '60 د.ل',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 120.w,
                                      ),
                                      Container(
                                        width: 29.w,
                                        height: 90.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.grey.withOpacity(.1),
                                                spreadRadius: 1,
                                                blurRadius: 20,
                                                offset: Offset(0, 0),
                                              ),
                                            ]),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 9.h,
                                            ),
                                            Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/Ellipse 1.png'),
                                                  Image.asset(
                                                      'assets/images/Rectangle 24.png'),
                                                  Image.asset(
                                                      'assets/images/Rectangle 25.png'),
                                                ]),
                                            SizedBox(
                                              height: 9.h,
                                            ),
                                            Text('2',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color: Color(0xFF949494),
                                                    )),
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/Ellipse 1.png'),
                                                  Image.asset(
                                                      'assets/images/Rectangle 25.png'),
                                                ]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 27.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              // <-- SEE HERE
                              title: const Text('إختر وسيلة الدفع'),
                              children: <Widget>[
                                SimpleDialogOption(
                                  onPressed: () {
                                    setState(() {
                                      payMethod = 'عند التوصيل';
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('عند التوصيل'),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    setState(() {
                                      payMethod = 'إلكتروني';
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('إلكتروني'),
                                ),
                              ],
                            );
                          });
                      ;
                    },
                    child: Container(
                      width: 325.w,
                      height: 48.h,
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
                      child: Row(
                        children: [
                          SizedBox(
                            width: 12.w,
                          ),
                          Container(child: Icon(Icons.payment)),
                          SizedBox(
                            width: 21.w,
                          ),
                          Text(
                            'وسيلة الدفع',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                          ),
                          SizedBox(
                            width: 144.w,
                          ),
                          Text(
                            payMethod,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 12.sp,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 37.h,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140.h,
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
                        SizedBox(
                          height: 24.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(
                              'المبلغ الإجمالي',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                            ),
                            SizedBox(
                              width: 170.w,
                            ),
                            Text('130د.ل'),
                          ],
                        ),
                        SizedBox(
                          height: 33.h,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 319.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF23311C),
                          ),
                          child: Text(
                            'إجراء الطلب',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ]))));
  }
}
