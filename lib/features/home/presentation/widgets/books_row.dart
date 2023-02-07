import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/features/home/presentation/pages/home_page.dart';

import '../../../../utils/constants.dart';
import '../../../../core/data/models/book_model.dart';

class BooksRow extends StatelessWidget {
  const BooksRow({Key? key, required this.book}) : super(key: key);

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final bookRating = book.ratings.isNotEmpty
        ? book.ratings.reduce((rating, nextRating) => rating + nextRating) /
            book.ratings.length
        : 0;
    return Container(
      width: 324.w,
      height: 129.h,
      margin: EdgeInsets.only(left: 15.w),
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
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
          ),
          Container(
            padding: EdgeInsets.only(left: 19.w),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            width: 77.w,
            height: 111.h,
            child: book.coverImageUrl != "" && book.coverImageUrl.isNotEmpty
                ? Image.network(
                    book.coverImageUrl,
                    width: 77.w,
                    height: 111.h,
                  )
                : Icon(
                    Icons.book_outlined,
                    size: 70.sp,
                    color: Theme.of(context).accentColor.withOpacity(.8),
                  ),
          ),
          SizedBox(
            width: 120.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 29.h,
                ),
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                Text(
                  book.author,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                ),
                SizedBox(
                  height: 17.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      5,
                      (index) {
                        return Icon(
                          Icons.star,
                          size: 18.w,
                          color: ++index <= bookRating
                              ? const Color(0xFFFFC41F)
                              : const Color(0xFFEDEDEF),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Spacer(),
          // Column(
          //   children: [
          //     SizedBox(
          //       height: 16.h,
          //     ),
          //     Image.asset('assets/images/Vector.png'),
          //   ],
          // ),
          // SizedBox(
          //   width: 20.w,
          // ),
        ],
      ),
    );
  }
}
