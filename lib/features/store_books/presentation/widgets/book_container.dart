import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/features/store_books/presentation/pages/store_book_details_page.dart';
import 'package:kitaby/utils/constants.dart';

import '../../../../core/presentation/widgets/containers_decoration.dart';

class BookContainer extends StatelessWidget {
  const BookContainer({
    Key? key,
    required this.book,
  }) : super(key: key);

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreBookDetailsPage(
              book: book,
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        decoration: containersDecoration(context),
        width: 159.w,
        // height: 294.h,
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 184.h,
                  width: 117.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Image.network(book.coverImageUrl),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Column(
                  children: [
                    Text(
                      book.title,
                      style: textTheme.bodyText1!.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      book.author,
                      style: textTheme.bodyText2!.copyWith(
                        color: Constants.secondrayFontColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      '${book.price} د.ل',
                      style: textTheme.bodyText1!.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
