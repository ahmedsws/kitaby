import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/core/presentation/widgets/base_progress_indicator.dart';
import 'package:kitaby/features/customer_store/presentation/pages/add_book_form.dart';
import 'package:kitaby/features/home/presentation/widgets/books_column.dart';
import 'package:kitaby/features/authentication/data/models/user_model.dart';
import 'package:kitaby/features/home/presentation/widgets/books_row.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/features/store_books/presentation/pages/store_book_details_page.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../authentication/presentation/pages/login_page.dart';
import '../../../customer_store/presentation/pages/customers_books_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final String? result = prefs.getString('user');

    if (result != null) {
      final value = jsonDecode(result);

      return UserModel.fromJson(value);
    }
  }

  @override
  void initState() {
    super.initState();
    FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          print(snapshot.data!.name);
          return SizedBox();
        } else {
          print('not found user');

          return SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference books = FirebaseFirestore.instance.collection('Books');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
                child: const SizedBox(),
              ),
              ListTile(
                title: Text(
                  'كتب الزبائن',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomersBooksPage(),
                    ),
                  );
                },
              ),
              FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? ListTile(
                          title: Text(
                            'إضافة كتاب وتسويقه',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddBookForm(),
                              ),
                            );
                          },
                        )
                      : const SizedBox();
                },
              ),
              FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? ListTile(
                          title: Text(
                            'تسجيل خروج',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                          ),
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();

                            await prefs.remove('user');

                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                Navigator.pop(context);
                              },
                            );
                          },
                        )
                      : ListTile(
                          title: Text(
                            'تسجيل دخول',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(right: 25.w),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 43.h,
                ),
                Text(
                  'كتب متداولة',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                ),
                SizedBox(
                  height: 26.h,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FutureBuilder(
                      future: books.orderBy('ISBN').get(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState == ConnectionState.done
                            ? Row(
                                children: [
                                  ...snapshot.data!.docs.map(
                                    (doc) {
                                      Map<String, dynamic> data =
                                          doc.data() as Map<String, dynamic>;
                                      final book = BookModel.fromJson(data);
                                      return Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        StoreBookDetailsPage(
                                                            book: book),
                                                  ),
                                                );
                                              },
                                              child: BooksColumn(book: book)),
                                          SizedBox(
                                            width: 26.w,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              )
                            : const BaseProgressIndicator();
                      }),
                ),
                SizedBox(
                  height: 38.h,
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.w, right: 20.w),
                  child: const Divider(),
                ),
                SizedBox(
                  height: 39.h,
                ),
                Text(
                  'جديد',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                ),
                SizedBox(
                  height: 22.h,
                ),
                Column(
                  children: [
                    FutureBuilder(
                      future: books.orderBy('ISBN', descending: true).get(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState == ConnectionState.done
                            ? Column(
                                children: [
                                  ...snapshot.data!.docs.map((doc) {
                                    Map<String, dynamic> data =
                                        doc.data() as Map<String, dynamic>;
                                    final book = BookModel.fromJson(data);
                                    return Column(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoreBookDetailsPage(
                                                          book: book),
                                                ),
                                              );
                                            },
                                            child: BooksRow(book: book)),
                                        SizedBox(
                                          height: 9.h,
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              )
                            : const BaseProgressIndicator();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
