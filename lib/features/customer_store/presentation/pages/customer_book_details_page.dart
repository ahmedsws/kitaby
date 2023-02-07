import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/core/presentation/widgets/base_progress_indicator.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/features/authentication/data/models/user_model.dart';
import 'package:kitaby/features/customer_store/presentation/pages/customer_books_page.dart';
import 'package:kitaby/features/customer_store/presentation/pages/edit_book_form.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/base_button.dart';
import '../../../../core/presentation/widgets/base_flushbar.dart';
import '../../../authentication/presentation/pages/login_page.dart';
import '../../../store_books/app/favorite_book_bloc/favorite_book_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/edit_customer_bloc/edit_customer_book_bloc.dart';
import '../../app/select_image_bloc/select_image_bloc.dart';

class CustomerBookDetailsPage extends StatefulWidget {
  const CustomerBookDetailsPage({
    super.key,
    required this.book,
  });

  final BookModel book;

  @override
  State<CustomerBookDetailsPage> createState() =>
      _CustomerBookDetailsPageState();
}

class _CustomerBookDetailsPageState extends State<CustomerBookDetailsPage> {
  bool isAddingBook = false;
  int starRatePressed = 0;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bookRating = widget.book.ratings.isNotEmpty
        ? widget.book.ratings
                .reduce((rating, nextRating) => rating + nextRating) /
            widget.book.ratings.length
        : 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: SimpleDialog(
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 10,
                            ),
                            child: Text(
                              'بلاغ',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          onTap: () async {
                            final user = await Constants.getUser();
                            if (user != null) {
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(widget.book.userPhoneNumber)
                                  .collection('Reports')
                                  .doc(user.phoneNumber)
                                  .set(
                                {
                                  'ReportFrom': user.phoneNumber,
                                },
                              );
                            }

                            Navigator.pop(context);
                            buildBaseFlushBar(
                              context: context,
                              message: 'تم البلاغ',
                              titleText: 'نجحت العملية!',
                              backgroundColor: Colors.green,
                            );
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 10,
                            ),
                            child: Text(
                              'تقييم مسوق الكتاب',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                children: [
                                  FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(widget.book.userPhoneNumber)
                                        .get(),
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
                                                            final userRated =
                                                                UserModel
                                                                    .fromJson(
                                                              snapshot.data!
                                                                  .data()!,
                                                            );
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Users')
                                                                .doc(widget.book
                                                                    .userPhoneNumber)
                                                                .update(
                                                              {
                                                                'Ratings':
                                                                    userRated
                                                                        .ratings
                                                                      ..add(
                                                                          index),
                                                              },
                                                            ).then(
                                                              (value) {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                                buildBaseFlushBar(
                                                                    context:
                                                                        context,
                                                                    message:
                                                                        'تم تقييم مسوق الكتاب',
                                                                    titleText:
                                                                        'تمت العملية بنجاح!',
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green);
                                                              },
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.star,
                                                            color:
                                                                // ++index <=
                                                                //         starRatePressed
                                                                //     ? Colors.amber
                                                                //     :
                                                                const Color(
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
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        FutureBuilder(
                          future: Constants.getUser(),
                          builder: (context, snapshot) {
                            return snapshot.connectionState ==
                                    ConnectionState.done
                                ? snapshot.data!.phoneNumber ==
                                        widget.book.userPhoneNumber
                                    ? GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16.h,
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            'تعديل الكتاب',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MultiBlocProvider(
                                                providers: [
                                                  BlocProvider(
                                                    create: (context) =>
                                                        EditCustomerBookBloc(),
                                                  ),
                                                  BlocProvider(
                                                    create: (context) =>
                                                        SelectImageBloc(),
                                                  ),
                                                ],
                                                child: EditBookForm(
                                                  book: widget.book,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox()
                                : const SizedBox();
                          },
                        ),
                        FutureBuilder(
                          future: Constants.getUser(),
                          builder: (context, snapshot) {
                            return snapshot.connectionState ==
                                    ConnectionState.done
                                ? snapshot.data!.phoneNumber ==
                                        widget.book.userPhoneNumber
                                    ? GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16.h,
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            widget.book.status
                                                ? 'إلغاء تفعيل الكتاب'
                                                : 'تفعيل الكتاب',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        onTap: () async {
                                          buildConfirmDialog(
                                            context,
                                            Theme.of(context).accentColor,
                                            widget.book.status,
                                          );
                                        },
                                      )
                                    : const SizedBox()
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.more_horiz,
              ),
            )
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
                              textAlign: TextAlign.center,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                textAlign: TextAlign.center,
                                style: textTheme.bodyText2!.copyWith(
                                  color: Constants.secondrayFontColor
                                      .withOpacity(.7),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 80,
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
                                                      padding: EdgeInsets.zero,
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
                                                                    'Users')
                                                                .doc(user
                                                                    .phoneNumber)
                                                                .collection(
                                                                    'Books')
                                                                .doc(widget
                                                                    .book.isbn)
                                                                .update(
                                                              {
                                                                'Ratings':
                                                                    widget.book
                                                                        .ratings
                                                                      ..removeAt(
                                                                        widget.book.ratings.length -
                                                                            1,
                                                                      ),
                                                              },
                                                            );
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Users')
                                                                .doc(user
                                                                    .phoneNumber)
                                                                .collection(
                                                                    'Books')
                                                                .doc(widget
                                                                    .book.isbn)
                                                                .update(
                                                              {
                                                                'Ratings': widget
                                                                    .book
                                                                    .ratings
                                                                  ..add(index),
                                                              },
                                                            ).then(
                                                              (value) {
                                                                setState(
                                                                  () {
                                                                    starRatePressed =
                                                                        index;
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Users')
                                                                .doc(user
                                                                    .phoneNumber)
                                                                .collection(
                                                                    'Books')
                                                                .doc(widget
                                                                    .book.isbn)
                                                                .update(
                                                              {
                                                                'Ratings': widget
                                                                    .book
                                                                    .ratings
                                                                  ..add(index),
                                                              },
                                                            );
                                                            setState(
                                                              () {
                                                                starRatePressed =
                                                                    index;
                                                              },
                                                            );
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
                                          style: textTheme.bodyText2!.copyWith(
                                            color: Constants.secondrayFontColor,
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
                                          style: textTheme.bodyText2!.copyWith(
                                            color: Constants.secondrayFontColor,
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
                                          style: textTheme.bodyText2!.copyWith(
                                            color: Constants.secondrayFontColor,
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
                                          text:
                                              widget.book.pageCount.toString(),
                                          style: textTheme.bodyText2!.copyWith(
                                            color: Constants.secondrayFontColor,
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
                                  Text(
                                    'نوع المعاملة:',
                                    style: textTheme.bodyText2!.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Center(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        color: const Color(0xFF18C814)
                                            .withOpacity(.5),
                                      ),
                                      child: Text(
                                        widget.book.dealType,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: 20.sp,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(widget.book.userPhoneNumber)
                                        .get(),
                                    builder: (context, snapshot) {
                                      late final num userRating;
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        final userRated = UserModel.fromJson(
                                          snapshot.data!.data()!,
                                        );
                                        userRating = userRated
                                                .ratings.isNotEmpty
                                            ? userRated.ratings.reduce(
                                                    (rating, nextRating) =>
                                                        rating + nextRating) /
                                                userRated.ratings.length
                                            : 0;
                                      }
                                      return snapshot.connectionState ==
                                              ConnectionState.done
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'التقييمات على الزبون:',
                                                      style: textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Constants
                                                            .secondrayFontColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 25.w,
                                                    ),
                                                    ...List.generate(
                                                      5,
                                                      (index) {
                                                        return Icon(
                                                          Icons.star,
                                                          color: ++index <=
                                                                  userRating
                                                              ? const Color(
                                                                  0xFFFFC41F)
                                                              : const Color(
                                                                  0xFFEDEDEF),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : const SizedBox();
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.h,
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
              Positioned(
                bottom: 25.h,
                child: isAddingBook
                    ? const BaseProgressIndicator()
                    : Builder(builder: (context) {
                        return BaseButton(
                          onPressed: () async {
                            launch("tel://214324234");
                          },
                          text: 'تواصل ${widget.book.userPhoneNumber ?? ''}',
                        );
                      }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> buildConfirmDialog(
      BuildContext context, Color accentColor, bool status) {
    final textTheme = Theme.of(context).textTheme;
    return showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          contentTextStyle: textTheme.bodyText1,
          title: Text(
            status ? 'تأكيد إلغاء التفعيل' : 'تأكيد التفعيل',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
          content: Text(
            status
                ? 'هل أنت متأكد من إلغاء تفعيل هذا الكتاب؟'
                : 'هل أنت متأكد من تفعيل هذا الكتاب؟',
            style: textTheme.bodyText2,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.book.userPhoneNumber)
                    .collection('Books')
                    .doc(widget.book.isbn)
                    .update(
                  {
                    'Status': !status,
                  },
                );
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerBooksPage(),
                    ));
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => CustomerBookDetailsPage(
                //       book: widget.book.copywith(
                //         author: widget.book.author,
                //         category: widget.book.category,
                //         coverImageUrl: widget.book.coverImageUrl,
                //         dealType: widget.book.dealType,
                //         description: widget.book.description,
                //         edition: widget.book.edition,
                //         isbn: widget.book.isbn,
                //         pageCount: widget.book.pageCount,
                //         price: widget.book.price,
                //         publisher: widget.book.publisher,
                //         quantity: widget.book.quantity,
                //         ratings: widget.book.ratings,
                //         title: widget.book.title,
                //         userPhoneNumber: widget.book.userPhoneNumber,
                //         status: !status,
                //       ),
                //     ),
                //   ),
                // );

                buildBaseFlushBar(
                  context: context,
                  message: status ? 'تم إلغاء تفعيل الكتاب' : 'تم تفعيل الكتاب',
                  titleText: 'تمت العملية بنجاح!',
                  backgroundColor: Colors.green,
                );
              },
              child: Text(
                'تأكيد',
                style: textTheme.bodyText2!.copyWith(
                  color: accentColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'الغاء',
                style: textTheme.bodyText2!.copyWith(
                  color: accentColor.withOpacity(.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
