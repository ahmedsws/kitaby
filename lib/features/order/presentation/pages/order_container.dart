import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/features/order/models/order_model.dart';

class OrderContainer extends StatelessWidget {
  const OrderContainer({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;
    return Column(
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
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 41.w,
                    ),
                    Container(
                      width: 90.w,
                      height: 111.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.loose,
                        textDirection: TextDirection.rtl,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: -40,
                            child: Image.asset(
                              'assets/images/book3.jpg',
                              fit: BoxFit.fill,
                              width: 67.w,
                              height: 111.h,
                            ),
                          ),
                          Positioned(
                            right: -1,
                            child: Image.asset(
                              'assets/images/book2.jpg',
                              fit: BoxFit.fill,
                              width: 67.w,
                              height: 111.h,
                            ),
                          ),
                          Positioned(
                            child: Image.asset(
                              'assets/images/book1.jpg',
                              fit: BoxFit.fill,
                              width: 67.w,
                              height: 111.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 52.w,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Text(
                          //   'طلب: ${order.id}',
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodyLarge!
                          //       .copyWith(
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 16.sp,
                          //           overflow: TextOverflow.ellipsis),
                          // ),
                          // SizedBox(
                          //   height: 8.32.h,
                          // ),
                          Text(
                            order.status,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                      color: const Color(0xff569750),
                                    ),
                          ),
                          SizedBox(
                            height: 9.h,
                          ),
                          Text(
                            '${order.totalPrice} د.ل',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 43.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 216.w,
                    height: 33.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: accentColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تفاصيل الطلب',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: accentColor,
                                    fontSize: 12.sp,
                                  ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Icon(Icons.arrow_forward_ios, size: 12.sp),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }
}
