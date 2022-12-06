import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/features/home/presentation/widgets/books_column.dart';
import 'package:kitaby/features/authentication/repository/models/user_model.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: PreferredSize(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 25.w,
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          'assets/images/pp.jpg',
                          width: 32.w,
                          height: 33.h,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 17.w,
                  ),
                  Text(
                    'مرحبا أحمد!',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: AppBar().preferredSize,
        ),
        body: Container(
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
                child: Row(
                  children: [
                    ...List.generate(
                      10,
                      (index) => Row(
                        children: [
                          BooksColumn(title: 'معنى الحبتة'),
                          SizedBox(
                            width: 26.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
