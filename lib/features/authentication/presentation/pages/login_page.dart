import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/core/presentation/pages/nav_bar_base.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
import 'package:kitaby/features/authentication/presentation/pages/signup_page.dart';
import 'package:kitaby/features/authentication/data/models/user_model.dart';
import 'package:kitaby/features/home/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/presentation/widgets/base_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/presentation/widgets/base_flushbar.dart';
import '../../../../core/presentation/widgets/base_progress_indicator.dart';
import '../../../../utils/constants.dart';
import '../../../../core/presentation/widgets/input_box_column.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  bool isLoging = false;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'تسجيل دخول'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80.h,
                  ),
                  InputBoxColumn(
                    label: 'رقم الهاتف',
                    hintText: '0912345578',
                    suffixIconData: Icons.phone,
                    controller: phoneController,
                    maxLength: 10,
                    validator: (p0) => phoneController.text.length == 10
                        ? null
                        : 'يجب أن يتكون الرقم من 10 أرقام',
                  ),
                  InputBoxColumn(
                    label: 'كلمة المرور',
                    hintText: '***************',
                    suffixIconData: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                    validator: (p0) => passwordController.text.length >= 8
                        ? null
                        : 'يجب أن لا تقل كلمة المرور عن 8 أحرف',
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  isLoging
                      ? const BaseProgressIndicator()
                      : BaseButton(
                          text: 'تسجيل الدخول',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(
                                () {
                                  isLoging = true;
                                },
                              );
                              final result = await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(phoneController.text)
                                  .get();

                              if (result.exists) {
                                final user = UserModel.fromJson(result.data()!);

                                if (passwordController.text == user.password) {
                                  final prefs =
                                      await SharedPreferences.getInstance();

                                  await prefs.setString(
                                    'user',
                                    jsonEncode(user.toJson()),
                                  );

                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (timeStamp) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NavBarBase(),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  buildBaseFlushBar(
                                      context: context,
                                      message:
                                          'حطأ في رقم الهاتف أو كلمة المرور!');
                                }
                              } else {
                                buildBaseFlushBar(
                                    context: context,
                                    message:
                                        'حطأ في رقم الهاتف أو كلمة المرور!');
                              }
                            } else {
                              buildBaseFlushBar(
                                context: context,
                                message: 'يجب تعبئة الحقول بشكل صحيح!',
                              );
                            }
                          },
                        ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'ليس لديك حساب؟',
                      style: textTheme.bodyText2!.copyWith(
                        color: Constants.secondrayFontColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      children: [
                        TextSpan(
                          text: '  تسجيل حساب',
                          style: textTheme.bodyText2!.copyWith(
                            color: Constants.mainFontColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignupPage(),
                                    ),
                                  )
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
