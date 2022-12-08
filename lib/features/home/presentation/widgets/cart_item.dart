import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../store_books/models/book_model.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.book, required this.qua});

  final BookModel book;
  final qua;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
             book.coverImageUrl,
              width: 77.w,
              height: 111.h,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 19.h,
              ),
              SizedBox(
                width: 120.w,
                child: Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 11.h,
              ),
              Text(
                book.author,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              // Column(
              //   children: [
              //     Container(
              //       width: 325.w,
              //       height: 131.h,
              //       margin: EdgeInsets.only(left: 15.w),
              //       decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(8),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(.1),
              //               spreadRadius: 1,
              //               blurRadius: 20,
              //               offset: Offset(0, 0),
              //             ),
              //           ]),
              //       child: Row(
              //         children: [
              //           Container(
              //             padding: EdgeInsets.only(left: 19.w),
              //             clipBehavior: Clip.antiAlias,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: Image.asset(
              //               'assets/images/الكتاب1.jpg',
              //               width: 77.w,
              //               height: 111.h,
              //             ),
              //           ),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               SizedBox(
              //                 height: 19.h,
              //               ),
              //               Text(
              //                 'معني الحياة',
              //                 style: Theme.of(context)
              //                     .textTheme
              //                     .bodyLarge!
              //                     .copyWith(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 16.sp,
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: 11.h,
              //               ),
              //               Text(
              //                 'عبد الله الوهيبي',
              //                 style: Theme.of(context)
              //                     .textTheme
              //                     .bodyLarge!
              //                     .copyWith(
              //                   fontSize: 12.sp,
              //                   color: Colors.grey,
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: 17.h,
              //               ),
              //               Container(
              //                 child: Text(
              //                   '60 د.ل',
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .bodyLarge!
              //                       .copyWith(
              //                     fontSize: 12.sp,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           SizedBox(
              //             width: 120.w,
              //           ),
              //           Container(
              //             width: 29.w,
              //             height: 90.h,
              //             decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(8),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors.grey.withOpacity(.1),
              //                     spreadRadius: 1,
              //                     blurRadius: 20,
              //                     offset: Offset(0, 0),
              //                   ),
              //                 ]),
              //             child: Column(
              //               children: [
              //                 SizedBox(
              //                   height: 9.h,
              //                 ),
              //                 Stack(alignment: Alignment.center, children: [
              //                   Image.asset('assets/images/Ellipse 1.png'),
              //                   Image.asset(
              //                       'assets/images/Rectangle 24.png'),
              //                   Image.asset(
              //                       'assets/images/Rectangle 25.png'),
              //                 ]),
              //                 SizedBox(
              //                   height: 9.h,
              //                 ),
              //                 Text('2',
              //                     style: Theme.of(context)
              //                         .textTheme
              //                         .bodyLarge!
              //                         .copyWith(
              //                       color: Color(0xFF949494),
              //                     )),
              //                 SizedBox(
              //                   height: 4.h,
              //                 ),
              //                 Stack(alignment: Alignment.center, children: [
              //                   Image.asset('assets/images/Ellipse 1.png'),
              //                   Image.asset(
              //                       'assets/images/Rectangle 25.png'),
              //                 ]),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       height: 10.h,
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 17.h,
              ),
              Container(
                child: Text(
                  book.price.toString(),
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
            width: 70.w,
          ),
          Container(
            width: 29.w,
            height: 90.h,
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
                  height: 9.h,
                ),
                Stack(alignment: Alignment.center, children: [
                  Image.asset('assets/images/Ellipse 1.png'),
                  Image.asset(
                      'assets/images/Rectangle 24.png'),
                  Image.asset(
                      'assets/images/Rectangle 25.png'),
                ]),
                SizedBox(
                  height: 9.h,
                ),
                Text(qua.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(
                      color: Color(0xFF949494),
                    )),
                SizedBox(
                  height: 4.h,
                ),
                Stack(alignment: Alignment.center, children: [
                  Image.asset('assets/images/Ellipse 1.png'),
                  Image.asset(
                      'assets/images/Rectangle 25.png'),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
