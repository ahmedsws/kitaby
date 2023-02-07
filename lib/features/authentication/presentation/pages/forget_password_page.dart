import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
import 'package:kitaby/core/presentation/widgets/base_progress_indicator.dart';
import 'package:kitaby/core/presentation/widgets/containers_decoration.dart';
import 'package:kitaby/features/authentication/data/models/user_model.dart';
import 'package:kitaby/features/store_books/presentation/pages/store_books_page.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/presentation/pages/nav_bar_base.dart';
import '../../../../core/presentation/widgets/base_app_bar.dart';
import '../../../../core/presentation/widgets/base_flushbar.dart';
import '../../../../core/presentation/widgets/input_box_column.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  final _formKey = GlobalKey<FormState>();

  bool isResettingPass = false;
  bool isSubmittingOtp = false;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   isResettingPass = false;
    // });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'استرجاع حساب'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InputBoxColumn(
                    label: 'رقم الهاتف',
                    hintText: '0918005031',
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
                  InputBoxColumn(
                    label: 'تأكيد كلمة المرور',
                    hintText: '***************',
                    suffixIconData: Icons.lock,
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (p0) {
                      if (confirmPasswordController.text ==
                          passwordController.text) {
                        return null;
                      } else {
                        return 'يجب أن يكون تأكيد كلمة المرور مطابقا لكلمة المرور';
                      }
                    },
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  isResettingPass
                      ? CircularProgressIndicator(
                          color: Theme.of(context).accentColor,
                        )
                      : BaseButton(
                          text: 'استرجاع',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isResettingPass = true;
                              });
                              FirebaseAuth auth = FirebaseAuth.instance;
                              CollectionReference users = FirebaseFirestore
                                  .instance
                                  .collection('Users');

                              final result =
                                  await users.doc(phoneController.text).get();

                              if (!result.exists) {
                                buildBaseFlushBar(
                                    context: context,
                                    message:
                                        'الحساب برقم الهاتف غير موجود مسبقا!');
                                setState(() {
                                  isResettingPass = false;
                                });
                              } else {
                                final String phoneNumber =
                                    phoneController.text.substring(1);

                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: '+218$phoneNumber',
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    await auth
                                        .signInWithCredential(credential)
                                        .then(
                                      (value) {
                                        users.doc(phoneController.text).update({
                                          'password': passwordController.text,
                                        }).then(
                                          (value) async {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                              (timeStamp) {
                                                Navigator.pop(context);
                                                Navigator.pop(context);

                                                buildBaseFlushBar(
                                                  context: context,
                                                  titleText:
                                                      'تمت العملية بنجاح!',
                                                  backgroundColor: Colors.green,
                                                  message:
                                                      'تم تغيير كلمة المرور',
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    if (e.code == 'invalid-phone-number') {
                                      buildBaseFlushBar(
                                        context: context,
                                        message: 'خطأ في رقم الهاتف',
                                      );
                                      setState(() {
                                        isResettingPass = false;
                                      });
                                    }
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) async {
                                    // Update the UI - wait for the user to enter the SMS code
                                    late String smsCode;
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => Container(
                                        height: 500.h,
                                        color: Theme.of(context).primaryColor,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            Text(
                                              'ادخل رمز التحقق',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            isSubmittingOtp
                                                ? const BaseProgressIndicator()
                                                : Center(
                                                    child: OtpTextField(
                                                      numberOfFields: 6,

                                                      borderColor:
                                                          Theme.of(context)
                                                              .accentColor,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                          ),
                                                        ),
                                                      ),
                                                      //set to true to show as box or false to show as dash
                                                      showFieldAsBox: true,
                                                      //runs when a code is typed in
                                                      onCodeChanged:
                                                          (String code) {
                                                        //handle validation or checks here
                                                      },
                                                      //runs when every textfield is filled
                                                      onSubmit: (String
                                                          verificationCode) async {
                                                        isSubmittingOtp = true;
                                                        smsCode =
                                                            verificationCode;
                                                        // Create a PhoneAuthCredential with the code
                                                        PhoneAuthCredential
                                                            phoneAuthCredential =
                                                            PhoneAuthProvider
                                                                .credential(
                                                          verificationId:
                                                              verificationId,
                                                          smsCode: smsCode,
                                                        );

                                                        // Sign the user in (or link) with the credential
                                                        await auth
                                                            .signInWithCredential(
                                                                phoneAuthCredential)
                                                            .then(
                                                          (value) {
                                                            users
                                                                .doc(
                                                                    phoneController
                                                                        .text)
                                                                .update({
                                                              'password':
                                                                  passwordController
                                                                      .text,
                                                            }).then(
                                                              (value) async {
                                                                WidgetsBinding
                                                                    .instance
                                                                    .addPostFrameCallback(
                                                                  (timeStamp) {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);

                                                                    buildBaseFlushBar(
                                                                      context:
                                                                          context,
                                                                      titleText:
                                                                          'تمت العملية بنجاح!',
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                      message:
                                                                          'تم تغيير كلمة المرور',
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      }, // end onSubmit
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  timeout: const Duration(seconds: 120),
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    buildBaseFlushBar(
                                      message: 'انتهى وقت استرجاع كلمة التحقق',
                                      context: context,
                                    );
                                    setState(() {
                                      isResettingPass = false;
                                    });
                                  },
                                );
                              }
                            } else {
                              buildBaseFlushBar(
                                context: context,
                                message: 'يجب تعبئة الحقول بشكل صحيح!',
                              );
                              setState(() {
                                isResettingPass = false;
                              });
                            }
                          },
                        ),
                  SizedBox(
                    height: 40.h,
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
