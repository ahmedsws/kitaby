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

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key, required this.user});

  final UserModel user;

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  final _formKey = GlobalKey<FormState>();

  ValueNotifier<bool> isSaving = ValueNotifier(false);

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
        appBar: const BaseAppBar(title: 'تعديل حساب'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: Constants.getUser(),
                builder: (context, snap) {
                  return snap.connectionState == ConnectionState.done
                      ? Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputBoxColumn(
                                label: 'الاسم',
                                hintText: 'أحمد محمود',
                                suffixIconData: Icons.person,
                                controller: nameController
                                  ..text = snap.data!.name,
                                validator: (p0) =>
                                    nameController.text.isNotEmpty
                                        ? null
                                        : 'يجب ادخال الاسم',
                              ),
                              InputBoxColumn(
                                label: 'العنوان',
                                hintText: 'طرابلس، حي الأندلس',
                                suffixIconData: Icons.place,
                                controller: addressController
                                  ..text = snap.data!.location,
                                validator: (p0) =>
                                    addressController.text.isNotEmpty
                                        ? null
                                        : 'يجب ادخال العنوان',
                              ),
                              InputBoxColumn(
                                label: 'كلمة المرور',
                                hintText: '***************',
                                suffixIconData: Icons.lock,
                                obscureText: true,
                                controller: passwordController
                                  ..text = snap.data!.password,
                                validator: (p0) =>
                                    passwordController.text.length >= 8
                                        ? null
                                        : 'يجب أن لا تقل كلمة المرور عن 8 أحرف',
                              ),
                              InputBoxColumn(
                                label: 'تأكيد كلمة المرور',
                                hintText: '***************',
                                suffixIconData: Icons.lock,
                                obscureText: true,
                                controller: confirmPasswordController
                                  ..text = snap.data!.password,
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
                              ValueListenableBuilder(
                                  valueListenable: isSaving,
                                  builder: (context, snapshot, widget) {
                                    return !snapshot
                                        ? BaseButton(
                                            text: 'حفظ',
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                isSaving.value = true;

                                                try {
                                                  final user = UserModel(
                                                    id: snap.data!.id,
                                                    name: nameController.text,
                                                    username:
                                                        phoneController.text,
                                                    phoneNumber:
                                                        snap.data!.phoneNumber,
                                                    location:
                                                        addressController.text,
                                                    password:
                                                        passwordController.text,
                                                  ).toJson();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Users')
                                                      .doc(snap
                                                          .data!.phoneNumber)
                                                      .update(
                                                        user,
                                                      );

                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  await prefs.setString(
                                                    'user',
                                                    jsonEncode(user),
                                                  );

                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  buildBaseFlushBar(
                                                    context: context,
                                                    message:
                                                        'يجب تعبئة الحقول بشكل صحيح!',
                                                  );
                                                  isSaving.value = false;
                                                }
                                              } else {
                                                buildBaseFlushBar(
                                                  context: context,
                                                  message:
                                                      'يجب تعبئة الحقول بشكل صحيح!',
                                                );
                                                isSaving.value = false;
                                              }
                                            },
                                          )
                                        : CircularProgressIndicator(
                                            color:
                                                Theme.of(context).accentColor,
                                          );
                                  }),
                              SizedBox(
                                height: 40.h,
                              ),
                            ],
                          ),
                        )
                      : const BaseProgressIndicator();
                }),
          ),
        ),
      ),
    );
  }
}
