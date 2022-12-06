import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitaby/features/store_books/models/book_model.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/presentation/widgets/base_button.dart';

class StoreBookDetailsPage extends StatelessWidget {
  const StoreBookDetailsPage({
    super.key,
    required this.book,
  });

  final BookModel book;

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
                    child: Image.network(book.coverImageUrl),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    book.title,
                    style: textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    book.author,
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
                      book.description,
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
              child: BaseButton(
                text: 'إضافة إلى السلة بسعر ${book.price} د.ل',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
