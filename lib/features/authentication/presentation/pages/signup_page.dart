import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
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

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  final _formKey = GlobalKey<FormState>();

  bool isRegistiring = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'تسجيل حساب'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InputBoxColumn(
                    label: 'الاسم',
                    hintText: 'أحمد محمود',
                    suffixIconData: Icons.person,
                    controller: nameController,
                    validator: (p0) => nameController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال الاسم',
                  ),
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
                    label: 'العنوان',
                    hintText: 'طرابلس، حي الأندلس',
                    suffixIconData: Icons.place,
                    controller: addressController,
                    validator: (p0) => addressController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال العنوان',
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
                  isRegistiring
                      ? CircularProgressIndicator(
                          color: Theme.of(context).accentColor,
                        )
                      : BaseButton(
                          text: 'تسجيل',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isRegistiring = true;
                              });
                              FirebaseAuth auth = FirebaseAuth.instance;
                              CollectionReference users = FirebaseFirestore
                                  .instance
                                  .collection('Users');

                              final result =
                                  await users.doc(phoneController.text).get();

                              if (result.exists) {
                                buildBaseFlushBar(
                                    context: context,
                                    message: 'الحساب برقم الهاتف موجود مسبقا!');
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
                                        final user = UserModel(
                                          id: value.user!.uid,
                                          name: nameController.text,
                                          username: phoneController.text,
                                          phoneNumber: phoneController.text,
                                          location: addressController.text,
                                          password: passwordController.text,
                                        ).toJson();

                                        users
                                            .doc(phoneController.text)
                                            .set(user)
                                            .then(
                                          (value) async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            prefs.setString(
                                              'user',
                                              jsonEncode(user),
                                            );

                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                              (timeStamp) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NavBarBase(),
                                                  ),
                                                );

                                                buildBaseFlushBar(
                                                  context: context,
                                                  message:
                                                      'تم انشاء حسابك بنجاح!',
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
                                    }
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) async {
                                    // Update the UI - wait for the user to enter the SMS code
                                    late String smsCode;
                                    await showModalBottomSheet(
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
                                            Center(
                                              child: OtpTextField(
                                                numberOfFields: 6,
                                                borderColor: Theme.of(context)
                                                    .accentColor,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                  ),
                                                ),
                                                //set to true to show as box or false to show as dash
                                                showFieldAsBox: true,
                                                //runs when a code is typed in
                                                onCodeChanged: (String code) {
                                                  //handle validation or checks here
                                                },
                                                //runs when every textfield is filled
                                                onSubmit:
                                                    (String verificationCode) {
                                                  setState(
                                                    () {
                                                      smsCode =
                                                          verificationCode;
                                                    },
                                                  );
                                                }, // end onSubmit
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).then((value) async {
                                      // Create a PhoneAuthCredential with the code
                                      PhoneAuthCredential phoneAuthCredential =
                                          PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: smsCode,
                                      );

                                      // Sign the user in (or link) with the credential
                                      await auth
                                          .signInWithCredential(
                                              phoneAuthCredential)
                                          .then(
                                        (value) {
                                          final user = UserModel(
                                            id: value.user!.uid,
                                            name: nameController.text,
                                            username: phoneController.text,
                                            phoneNumber: phoneController.text,
                                            location: addressController.text,
                                            password: passwordController.text,
                                          ).toJson();

                                          users
                                              .doc(phoneController.text)
                                              .set(user)
                                              .then(
                                            (value) async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();

                                              prefs.setString(
                                                'user',
                                                jsonEncode(user),
                                              );

                                              // TODO رد المستخدم للهوم

                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                (timeStamp) {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const NavBarBase(),
                                                    ),
                                                  );

                                                  buildBaseFlushBar(
                                                    context: context,
                                                    message:
                                                        'تم انشاء حسابك بنجاح!',
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    });
                                  },
                                  timeout: const Duration(seconds: 120),
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    buildBaseFlushBar(
                                      message: 'انتهى وقت استرجاع كلمة التحقق',
                                      context: context,
                                    );
                                  },
                                );
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
