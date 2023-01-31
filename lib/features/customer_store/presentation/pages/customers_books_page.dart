import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/features/store_books/presentation/widgets/book_container.dart';
import '../../../../core/data/models/book_model.dart';
import '../../../../core/presentation/widgets/base_app_bar.dart';
import '../../../../core/presentation/widgets/base_progress_indicator.dart';
import '../../../../utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/customer_book_container.dart';

class CustomersBooksPage extends StatefulWidget {
  const CustomersBooksPage({super.key});

  @override
  State<CustomersBooksPage> createState() => _CustomersBooksPageState();
}

class _CustomersBooksPageState extends State<CustomersBooksPage> {
  String searchText = '';
  Future<List<BookModel>> getCustomersBooks() async {
    final users = await FirebaseFirestore.instance.collection('Users').get();

    final List<BookModel> customersBooks = [];

    for (var user in users.docs) {
      final books = await user.reference.collection('Books').get();
      for (var book in books.docs) {
        customersBooks.add(BookModel.fromJson(book.data()));
      }
    }

    return customersBooks;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'كتب الزبائن'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 32.h,
              ),
              Container(
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
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: FutureBuilder(
                        future: getCustomersBooks(),
                        builder: (context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1 / 1.8,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.w,
                                  children: [
                                    ...snapshot.data!
                                        .map(
                                          (doc) {
                                            return CustomerBookContainer(
                                              book: doc,
                                            );
                                          },
                                        )
                                        .where((doc) =>
                                            doc.book.status == true &&
                                            doc.book.quantity > 0)
                                        .where(
                                          (doc) => doc.book.title
                                              .contains(searchText),
                                        ),
                                  ],
                                )
                              : const BaseProgressIndicator();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
