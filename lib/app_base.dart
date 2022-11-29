import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/features/store_books/presentation/pages/store_books_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/utils/constants.dart';

class AppBase extends StatelessWidget {
  const AppBase({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.white,
            accentColor: const Color(0xFF23311C),
            // colorScheme: ColorScheme(
            //   primary:
            //   secondary:
            // ),
            appBarTheme: AppBarTheme(
              color: Colors.white,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: Constants.mainFontColor,
              ),
              titleTextStyle: GoogleFonts.tajawalTextTheme().headline2,
            ),
            textTheme: GoogleFonts.tajawalTextTheme(),
          ),
          home: const StoreBooksPage(),
        );
      },
    );
  }
}