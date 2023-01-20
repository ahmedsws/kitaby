import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPaymentRow extends StatelessWidget {
  const SelectPaymentRow({
    Key? key,
    required this.payemntMethod,
  }) : super(key: key);

  final ValueNotifier<String> payemntMethod;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SimpleDialog(
                title: const Text('إختر وسيلة الدفع'),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context).pop();

                      payemntMethod.value = 'عند التوصيل';
                    },
                    child: const Text('عند التوصيل'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context).pop();

                      payemntMethod.value = 'إلكتروني';
                    },
                    child: const Text('إلكتروني'),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          height: 50.h,
          margin: EdgeInsets.only(left: 15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.1),
                spreadRadius: 1,
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'اختر وسيلة الدفع',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                  ),
                ],
              ),
              ValueListenableBuilder(
                  valueListenable: payemntMethod,
                  builder: (context, paymentMethodState, _) {
                    return Text(
                      paymentMethodState,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 12.sp),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
