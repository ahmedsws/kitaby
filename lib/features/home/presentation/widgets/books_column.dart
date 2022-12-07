import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/features/home/presentation/pages/home_page.dart';

import '../../../../utils/constants.dart';
import '../../../store_books/models/book_model.dart';

class BooksColumn extends StatelessWidget {
  const BooksColumn({super.key, required this.book});

  final BookModel book;


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 117.w,
      child: Column(
        children: [
          book.coverImageUrl != "" && book.coverImageUrl.isNotEmpty ?
          Image.network(
            book.coverImageUrl,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.book),
            height: 184.h,
            width: 117.w,
          ):
          Icon(Icons.book),
          SizedBox(
            height: 25.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                height: 8.h,
              ),
              Text(
                book.author,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Constants.secondrayFontColor,
                      fontSize: 12.sp,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
