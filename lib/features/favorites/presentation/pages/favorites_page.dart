import 'package:flutter/material.dart';
import 'package:kitaby/core/presentation/widgets/base_progress_indicator.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/features/store_books/presentation/pages/store_book_details_page.dart';

import '../../../../core/presentation/widgets/base_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/favorites_bloc/favorites_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => FavoritesBloc()..add(FavoritesEvent()),
        child: Scaffold(
          appBar: const BaseAppBar(
            title: 'المفضلة',
            leading: SizedBox(),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, favoritesState) {
                    return favoritesState is FavoritesLoaded
                        ? Column(
                            children: [
                              ...favoritesState.favorites!.map((favorite) {
                                if (favorite != null) {
                                  return FavoriteContainer(book: favorite);
                                } else {
                                  return SizedBox(
                                    height: 150.h,
                                    child: Center(
                                      child: Text(
                                        'لا توجد كتب في المفضلة حاليا!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp,
                                            ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ],
                          )
                        : const BaseProgressIndicator();
                  },
                ),
                SizedBox(
                  width: 26.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteContainer extends StatelessWidget {
  const FavoriteContainer({
    Key? key,
    required this.book,
  }) : super(key: key);

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreBookDetailsPage(book: book),
          ),
        );
      },
      child: Container(
        width: 325.w,
        height: 131.h,
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
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                book.coverImageUrl,
                width: 77.w,
                height: 111.h,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 19.h,
                ),
                SizedBox(
                  width: 120.w,
                  child: Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
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
                Text(
                  '${book.price} د.ل',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
