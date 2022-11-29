import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/utils/constants.dart';
import '../widgets/book_container.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreBooksPage extends StatelessWidget {
  const StoreBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'كتب المتجر',
            style: textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 32.h,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 45.h,
                  padding: EdgeInsets.only(right: 25.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: const Color(0xFFD9D9D9).withOpacity(.33),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن كتاب بعنوانه',
                      hintStyle: textTheme.bodyText1!.copyWith(
                        color: Constants.secondrayFontColor,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          height: 15.h,
                          width: 15.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40.h,
                ),
              ),
              SliverGrid.count(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.8,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.w,
                children: const [
                  BookContainer(
                    title: 'معنى الحياة في العالم الحديث',
                    author: 'عبدالله الوهيبي',
                    price: 60,
                    imageUrl: 'assets/images/book1.jpg',
                  ),
                  BookContainer(
                    title: 'الفصل بين النفس',
                    author: 'عبدالعزيز الطريفي',
                    price: 30,
                    imageUrl: 'assets/images/book2.jpg',
                  ),
                  BookContainer(
                    title: 'الفصل بين النفس',
                    author: 'عبدالعزيز الطريفي',
                    price: 30,
                    imageUrl: 'assets/images/book2.jpg',
                  ),
                  BookContainer(
                    title: 'معنى الحياة في العالم الحديث',
                    author: 'عبدالله الوهيبي',
                    price: 60,
                    imageUrl: 'assets/images/book1.jpg',
                  ),
                  BookContainer(
                    title: 'معنى الحياة في العالم الحديث',
                    author: 'عبدالله الوهيبي',
                    price: 60,
                    imageUrl: 'assets/images/book1.jpg',
                  ),
                  BookContainer(
                    title: 'الفصل بين النفس',
                    author: 'عبدالعزيز الطريفي',
                    price: 30,
                    imageUrl: 'assets/images/book2.jpg',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
