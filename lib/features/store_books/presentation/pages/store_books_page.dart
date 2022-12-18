import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/core/presentation/widgets/base_progress_indicator.dart';
import 'package:kitaby/features/authentication/data/models/user_model.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/utils/constants.dart';
import '../../../../core/presentation/widgets/base_app_bar.dart';
import '../widgets/book_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreBooksPage extends StatefulWidget {
  const StoreBooksPage({super.key, this.user});

  final UserModel? user;

  @override
  State<StoreBooksPage> createState() => _StoreBooksPageState();
}

class _StoreBooksPageState extends State<StoreBooksPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    CollectionReference books = FirebaseFirestore.instance.collection('Books')
      ..limit(5);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'كتب المتجر'),
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
                        future: books.get(),
                        builder: (context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1 / 1.8,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.w,
                                  children: [
                                    ...snapshot.data!.docs.map(
                                      (doc) {
                                        Map<String, dynamic> data =
                                            doc.data() as Map<String, dynamic>;
                                        final book = BookModel.fromJson(data);
                                        return BookContainer(
                                          book: book,
                                        );
                                      },
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
