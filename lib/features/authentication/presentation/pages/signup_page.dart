import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
import 'package:kitaby/core/presentation/widgets/containers_decoration.dart';
import 'package:kitaby/features/authentication/repository/models/user_model.dart';
import 'package:kitaby/features/store_books/presentation/pages/store_books_page.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/presentation/widgets/base_app_bar.dart';
import '../widgets/input_box_column.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                  BaseButton(
                    text: 'تسجيل',
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        await showDialog(
                          context: context,
                          builder: (context) => Column(
                            children: [
                              OtpTextField(
                                numberOfFields: 6,
                                borderColor: Theme.of(context).accentColor,
                                //set to true to show as box or false to show as dash
                                showFieldAsBox: true,
                                //runs when a code is typed in
                                onCodeChanged: (String code) {
                                  //handle validation or checks here
                                },
                                //runs when every textfield is filled
                                onSubmit: (String verificationCode) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("رمز التحقق"),
                                        content: Text(
                                            'رمز التحقق هو $verificationCode'),
                                      );
                                    },
                                  );
                                }, // end onSubmit
                              ),
                            ],
                          ),
                        );
                      }
                      // if (_formKey.currentState!.validate()) {

                      //   FirebaseAuth auth = FirebaseAuth.instance;
                      //   CollectionReference users =
                      //       FirebaseFirestore.instance.collection('Users');

                      //   final String phoneNumber =
                      //       phoneController.text.substring(1);

                      //   await FirebaseAuth.instance.verifyPhoneNumber(
                      //     phoneNumber: '+218$phoneNumber',
                      //     verificationCompleted:
                      //         (PhoneAuthCredential credential) async {
                      //       await auth.signInWithCredential(credential).then(
                      //         (value) {
                      //           final user = UserModel(
                      //             id: value.user!.uid,
                      //             name: nameController.text,
                      //             username: phoneController.text,
                      //             phoneNumber: phoneController.text,
                      //             location: addressController.text,
                      //             password: passwordController.text,
                      //           ).toJson();

                      //           users.add(user).then(
                      //             (value) async {
                      //               final prefs =
                      //                   await SharedPreferences.getInstance();

                      //               prefs.setString(
                      //                 'user',
                      //                 jsonEncode(user),
                      //               );

                      //               WidgetsBinding.instance
                      //                   .addPostFrameCallback(
                      //                 (timeStamp) {
                      //                   Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           const StoreBooksPage(),
                      //                     ),
                      //                   );
                      //                 },
                      //               );
                      //             },
                      //           );
                      //         },
                      //       );
                      //     },
                      //     verificationFailed: (FirebaseAuthException e) {
                      //       if (e.code == 'invalid-phone-number') {
                      //         print('The provided phone number is not valid.');
                      //       }
                      //     },
                      //     codeSent:
                      //         (String verificationId, int? resendToken) async {
                      //       // Update the UI - wait for the user to enter the SMS code
                      //       late String smsCode;

                      //       await showDialog(
                      //         context: context,
                      //         builder: (context) => Column(
                      //           children: [
                      //             OtpTextField(
                      //               numberOfFields: 6,
                      //               borderColor: Theme.of(context).accentColor,
                      //               //set to true to show as box or false to show as dash
                      //               showFieldAsBox: true,
                      //               //runs when a code is typed in
                      //               onCodeChanged: (String code) {
                      //                 //handle validation or checks here
                      //               },
                      //               //runs when every textfield is filled
                      //               onSubmit: (String verificationCode) {
                      //                 showDialog(
                      //                   context: context,
                      //                   builder: (context) {
                      //                     setState(() {
                      //                       smsCode = verificationCode;
                      //                     });
                      //                     return AlertDialog(
                      //                       title: Text("رمز التحقق"),
                      //                       content: Text(
                      //                           'رمز التحقق هو $verificationCode'),
                      //                     );
                      //                   },
                      //                 );
                      //               }, // end onSubmit
                      //             ),
                      //           ],
                      //         ),
                      //       ).then((value) async {
                      //         // Create a PhoneAuthCredential with the code
                      //         PhoneAuthCredential phoneAuthCredential =
                      //             PhoneAuthProvider.credential(
                      //           verificationId: verificationId,
                      //           smsCode: smsCode,
                      //         );

                      //         // Sign the user in (or link) with the credential
                      //         await auth
                      //             .signInWithCredential(phoneAuthCredential)
                      //             .then(
                      //           (value) {
                      //             final user = UserModel(
                      //               id: value.user!.uid,
                      //               name: nameController.text,
                      //               username: phoneController.text,
                      //               phoneNumber: phoneController.text,
                      //               location: addressController.text,
                      //               password: passwordController.text,
                      //             ).toJson();

                      //             users.add(user).then(
                      //               (value) async {
                      //                 final prefs =
                      //                     await SharedPreferences.getInstance();

                      //                 prefs.setString(
                      //                   'user',
                      //                   jsonEncode(user),
                      //                 );

                      //                 WidgetsBinding.instance
                      //                     .addPostFrameCallback(
                      //                   (timeStamp) {
                      //                     Navigator.push(
                      //                       context,
                      //                       MaterialPageRoute(
                      //                         builder: (context) =>
                      //                             const StoreBooksPage(),
                      //                       ),
                      //                     );
                      //                   },
                      //                 );
                      //               },
                      //             );
                      //           },
                      //         );
                      //       });
                      //     },
                      //     timeout: const Duration(seconds: 60),
                      //     codeAutoRetrievalTimeout: (String verificationId) {},
                      //   );
                      // }
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