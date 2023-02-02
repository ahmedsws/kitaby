import 'package:flutter/material.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/core/presentation/widgets/base_app_bar.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/order_model.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key? key,
    required this.order,
    required this.books,
  }) : super(key: key);

  final OrderModel order;
  final List<BookModel> books;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'تفاصيل الطلب'),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 325.w,
                height: 131.h,
                // margin: EdgeInsets.only(left: 15.w),
                padding: EdgeInsets.only(top: 22.h),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 17.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'رقم الطلب:',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          'حالة الطلب:',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          'قيمة الطلب:',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 130.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            order.id,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          order.status,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                    color: Color(0xff569750),
                                  ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          '${order.totalPrice} د.ل',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Container(
                height: 413.h,
                width: double.infinity,
                // margin: EdgeInsets.only(left: 15.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.1),
                        spreadRadius: 1,
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                    ]),
                child: SingleChildScrollView(
                  child: Column(children: [
                    ...order.orderItems.map(
                      (orderItem) {
                        final book = books.firstWhere(
                          (book) => book.isbn == orderItem.bookISBN,
                        );
                        return Column(
                          children: [
                            Container(
                              width: 325.w,
                              height: 131.h,
                              padding: EdgeInsets.only(top: 12.h),
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
                                    width: 11.w,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 77.w,
                                        height: 111.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.network(
                                          book.coverImageUrl,
                                          width: 77.w,
                                          height: 106.h,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 19.w,
                                      ),
                                      SizedBox(
                                        width: 130.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            Text(
                                              book.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              book.author,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12.sp,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              '${book.price} د.ل',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 49.h,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 34.h,
                                            width: 66.w,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 20,
                                                    offset: Offset(0, 0),
                                                  ),
                                                ]),
                                            child: Text(
                                              'الكمية: ${orderItem.quantity}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontSize: 13.sp,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        );
                      },
                    ),
                    // ...List.generate(
                    //   10,
                    //   (index) => Column(
                    //     children: [
                    //       Container(
                    //         width: 325.w,
                    //         height: 131.h,
                    //         padding: EdgeInsets.only(top: 12.h),
                    //         decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.circular(8),
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 color: Colors.grey.withOpacity(.1),
                    //                 spreadRadius: 1,
                    //                 blurRadius: 20,
                    //                 offset: Offset(0, 0),
                    //               ),
                    //             ]),
                    //         child: Row(
                    //           children: [
                    //             SizedBox(
                    //               width: 11.w,
                    //             ),
                    //             Row(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Container(
                    //                   width: 77.w,
                    //                   height: 111.h,
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(5),
                    //                   ),
                    //                   clipBehavior: Clip.antiAlias,
                    //                   child: Image.asset(
                    //                     'assets/images/book3.jpg',
                    //                     width: 77.w,
                    //                     height: 106.h,
                    //                   ),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 19.w,
                    //                 ),
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     SizedBox(
                    //                       height: 15.h,
                    //                     ),
                    //                     Text(
                    //                       'معنى الحياة',
                    //                       style: Theme.of(context)
                    //                           .textTheme
                    //                           .bodyLarge!
                    //                           .copyWith(
                    //                             fontWeight: FontWeight.bold,
                    //                             fontSize: 16.sp,
                    //                           ),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 10.h,
                    //                     ),
                    //                     Text(
                    //                       'عبد الله الوهيبي',
                    //                       style: Theme.of(context)
                    //                           .textTheme
                    //                           .bodySmall!
                    //                           .copyWith(
                    //                             fontWeight: FontWeight.normal,
                    //                             fontSize: 12.sp,
                    //                           ),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 10.h,
                    //                     ),
                    //                     Text(
                    //                       '30 د.ل',
                    //                       style: Theme.of(context)
                    //                           .textTheme
                    //                           .bodyLarge!
                    //                           .copyWith(
                    //                             fontWeight: FontWeight.bold,
                    //                             fontSize: 16.sp,
                    //                           ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 SizedBox(
                    //                   width: 72.w,
                    //                 ),
                    //                 Column(
                    //                   children: [
                    //                     SizedBox(
                    //                       height: 49.h,
                    //                     ),
                    //                     Container(
                    //                       alignment: Alignment.center,
                    //                       height: 34.h,
                    //                       width: 66.w,
                    //                       decoration: BoxDecoration(
                    //                           color: Colors.white,
                    //                           borderRadius:
                    //                               BorderRadius.circular(8),
                    //                           boxShadow: [
                    //                             BoxShadow(
                    //                               color: Colors.grey
                    //                                   .withOpacity(.1),
                    //                               spreadRadius: 1,
                    //                               blurRadius: 20,
                    //                               offset: Offset(0, 0),
                    //                             ),
                    //                           ]),
                    //                       child: Text(
                    //                         'الكمية: 2',
                    //                         style: Theme.of(context)
                    //                             .textTheme
                    //                             .bodySmall!
                    //                             .copyWith(
                    //                               fontSize: 13.sp,
                    //                             ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         height: 10.h,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ]),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              BaseButton(
                text: 'العودة',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
