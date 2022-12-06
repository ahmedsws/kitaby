import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/features/store_books/presentation/pages/store_book_details_page.dart';
import 'package:kitaby/utils/constants.dart';

class BookContainer extends StatelessWidget {
  const BookContainer({
    Key? key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.price,
  }) : super(key: key);

  final String title, author, imageUrl;
  final double price;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => StoreBookDetailsPage(book: ,),
        //   ),
        // );
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE0E0E0).withOpacity(.45),
              blurRadius: 42,
              offset: const Offset(0, 14),
              spreadRadius: 0,
            )
          ],
        ),
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
                  child: Image.asset(imageUrl),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                      author,
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
                      '$price د.ل',
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
