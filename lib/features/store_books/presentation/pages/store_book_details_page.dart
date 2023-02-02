import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/core/presentation/widgets/base_progress_indicator.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/base_button.dart';
import '../../../../core/presentation/widgets/base_flushbar.dart';
import '../../../authentication/presentation/pages/login_page.dart';
import '../../../cart/app/cart_bloc/cart_bloc.dart';
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
  int starRatePressed = 0;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bookRating = widget.book.ratings
            .reduce((rating, nextRating) => rating + nextRating) /
        widget.book.ratings.length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => FavoriteBookBloc()
          ..add(CheckFavoritedBook(bookISBN: widget.book.isbn)),
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
                        context.read<FavoriteBookBloc>().add(
                              FavoriteEvent(
                                bookISBN: widget.book.isbn,
                              ),
                            );
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
              fit: StackFit.expand,
              children: [
                Column(
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
                    SizedBox(
                      height: 276.h,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                textBaseline: TextBaseline.ideographic,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ...List.generate(
                                        5,
                                        (index) {
                                          return Icon(
                                            Icons.star,
                                            color: ++index <= bookRating
                                                ? const Color(0xFFFFC41F)
                                                : const Color(0xFFEDEDEF),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    bookRating.round().toString(),
                                    style: textTheme.bodyMedium!.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.secondrayFontColor,
                                    ),
                                  ),
                                  Text(
                                    '${widget.book.ratings.length}  تقييمات',
                                    style: textTheme.bodyMedium!.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.secondrayFontColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              SizedBox(
                                width: 319.w,
                                child: Text(
                                  widget.book.description,
                                  style: textTheme.bodyText2!.copyWith(
                                    color: Constants.secondrayFontColor
                                        .withOpacity(.7),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 4,
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              FutureBuilder(
                                  future: Constants.getUser(),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.done
                                        ? snapshot.data != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ...List.generate(
                                                    5,
                                                    (index) {
                                                      return IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        onPressed: () async {
                                                          final user =
                                                              await Constants
                                                                  .getUser();

                                                          if (user != null) {
                                                            if (starRatePressed !=
                                                                0) {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Books')
                                                                  .doc(widget
                                                                      .book
                                                                      .isbn)
                                                                  .update(
                                                                {
                                                                  'Ratings': widget
                                                                      .book
                                                                      .ratings
                                                                    ..removeAt(widget
                                                                            .book
                                                                            .ratings
                                                                            .length -
                                                                        1),
                                                                },
                                                              );
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Books')
                                                                  .doc(widget
                                                                      .book
                                                                      .isbn)
                                                                  .update(
                                                                {
                                                                  'Ratings': widget
                                                                      .book
                                                                      .ratings
                                                                    ..add(
                                                                        index),
                                                                },
                                                              ).then((value) {
                                                                setState(() {
                                                                  starRatePressed =
                                                                      index;
                                                                });
                                                              });
                                                            } else {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Books')
                                                                  .doc(widget
                                                                      .book
                                                                      .isbn)
                                                                  .update(
                                                                {
                                                                  'Ratings': widget
                                                                      .book
                                                                      .ratings
                                                                    ..add(
                                                                        index),
                                                                },
                                                              );
                                                              setState(() {
                                                                starRatePressed =
                                                                    index;
                                                              });
                                                            }
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.star,
                                                          color: ++index <=
                                                                  starRatePressed
                                                              ? Colors.amber
                                                              : const Color(
                                                                  0xFFEDEDEF),
                                                          size: 40.sp,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            : const SizedBox()
                                        : const SizedBox();
                                  }),
                              SizedBox(
                                height: 25.h,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: 'دار النشر:     ',
                                        style: textTheme.bodyText2!.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.book.publisher,
                                            style:
                                                textTheme.bodyText2!.copyWith(
                                              color:
                                                  Constants.secondrayFontColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: 'الطبعة:     ',
                                        style: textTheme.bodyText2!.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.book.edition,
                                            style:
                                                textTheme.bodyText2!.copyWith(
                                              color:
                                                  Constants.secondrayFontColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: 'الصنف:     ',
                                        style: textTheme.bodyText2!.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.book.category,
                                            style:
                                                textTheme.bodyText2!.copyWith(
                                              color:
                                                  Constants.secondrayFontColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: 'عدد الصفحات:     ',
                                        style: textTheme.bodyText2!.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.book.pageCount
                                                .toString(),
                                            style:
                                                textTheme.bodyText2!.copyWith(
                                              color:
                                                  Constants.secondrayFontColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BlocProvider(
                  create: (context) => CartBloc()..add(CartEvent()),
                  child: Positioned(
                    bottom: 25.h,
                    child: isAddingBook
                        ? const BaseProgressIndicator()
                        : BlocBuilder<CartBloc, CartState>(
                            builder: (context, cartState) {
                              if (cartState is CartItemsLoaded) {
                                final checkItemInItems = cartState.cartItems!
                                    .where((item) =>
                                        item.bookISBN == widget.book.isbn);

                                return BaseButton(
                                  onPressed: () async {
                                    if (checkItemInItems.isEmpty) {
                                      setState(() {
                                        isAddingBook = true;
                                      });
                                      final user = await Constants.getUser();

                                      if (user != null) {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(user.phoneNumber)
                                            .collection('Cart')
                                            .doc('cartDoc')
                                            .collection('Cart_Items')
                                            .add(
                                          {
                                            "book_isbn": widget.book.isbn,
                                            "quantity": 1,
                                          },
                                        ).then((value) {
                                          Navigator.pop(context);

                                          buildBaseFlushBar(
                                            context: context,
                                            titleText: 'نجحت العملية',
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 103, 228, 107),
                                            message:
                                                'تمت إضافة الكتاب إلى السلة بنجاح!',
                                          );
                                        });
                                      } else {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (timeStamp) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage(),
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
                                    }
                                  },
                                  text: checkItemInItems.isEmpty
                                      ? 'إضافة إلى السلة بسعر ${widget.book.price} د.ل'
                                      : 'هذا الكتاب موجود في السلة',
                                  bgColor: checkItemInItems.isNotEmpty
                                      ? Colors.grey
                                      : null,
                                );
                              } else {
                                return const BaseProgressIndicator();
                              }
                            },
                          ),
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
