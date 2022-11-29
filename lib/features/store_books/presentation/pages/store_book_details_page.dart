import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreBookDetailsPage extends StatelessWidget {
  const StoreBookDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SvgPicture.asset('assets/icons/save.svg'),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 276.h,
                    width: 204.w,
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/book4.jpg'),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    'السيرة النبوية الصحيحة',
                    style: textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    'أكرم ضياء العمري',
                    style: textTheme.bodyText2!.copyWith(
                      color: Constants.secondrayFontColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(
                    width: 319.w,
                    child: Text(
                      'إن عقول الاصحاء تتفق في خلق الله لها, ولكنه جعل الاختلاف في نفوسهم وميولها ورغباتها, والعقل لم يُخلق ليشتهي, ولكنه خُلق ليدل ويهدي ويتفكر ويري صاحبه',
                      style: textTheme.bodyText2!.copyWith(
                        color: Constants.secondrayFontColor.withOpacity(.7),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30.h,
              child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(319.w, 60.h),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).accentColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'إضافة إلى السلة بسعر 30 د.ل',
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
