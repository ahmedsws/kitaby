import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/core/presentation/widgets/base_progress_indicator.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/base_button.dart';
import '../../../authentication/presentation/pages/login_page.dart';
import '../../app/favorite_book_bloc/favorite_book_bloc.dart';

class StoreBookDetailsPage extends StatefulWidget {
  const StoreBookDetailsPage({
    super.key,
    required this.book,
  });

  final BookModel book;

  @override
  State<StoreBookDetailsPage> createState() => _StoreBookDetailsPageState();
}

class _StoreBookDetailsPageState extends State<StoreBookDetailsPage> {
  bool isAddingBook = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => FavoriteBookBloc(),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: BlocBuilder<FavoriteBookBloc, FavoriteBookState>(
                  builder: (context, favoriteBookState) {
                    if (favoriteBookState is FavoriteBookLoading) {
                      return const BaseProgressIndicator();
                    }

                    return InkWell(
                      onTap: () {
                        if (favoriteBookState is FavoriteBookInitial) {
                          context.read<FavoriteBookBloc>().add(
                                FavoriteBookEvent(
                                  bookISBN: widget.book.isbn,
                                ),
                              );
                        }
                      },
                      child: favoriteBookState is BookFavorited
                          ? Icon(Icons.bookmark,
                              color: Theme.of(context).accentColor)
                          : Icon(
                              Icons.bookmark_add_outlined,
                              color: Theme.of(context).accentColor,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Stack(
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
                        child: Image.network(widget.book.coverImageUrl),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        widget.book.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        widget.book.author,
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
                          widget.book.description,
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
                  child: isAddingBook
                      ? const BaseProgressIndicator()
                      : BaseButton(
                          onPressed: () async {
                            setState(() {
                              isAddingBook = true;
                            });
                            final user = await Constants.getUser();

                            if (user != null) {
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user.id)
                                  .collection('Cart')
                                  .doc('cartDoc')
                                  .collection('Cart_Items')
                                  .add(
                                {
                                  "book_isbn": widget.book.isbn,
                                  "quantity": 1,
                                },
                              );

                              // buildBaseFlushBar(
                              //     context: context,
                              //     titleText: 'تمت إضافة الكتاب إلى السلة بنجاح!');
                            } else {
                              WidgetsBinding.instance.addPostFrameCallback(
                                (timeStamp) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                              );
                            }
                            setState(
                              () {
                                isAddingBook = false;
                              },
                            );
                          },
                          text: 'إضافة إلى السلة بسعر ${widget.book.price} د.ل',
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
