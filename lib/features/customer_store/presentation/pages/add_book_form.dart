import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/presentation/widgets/base_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/presentation/widgets/base_flushbar.dart';
import '../../../../core/presentation/widgets/base_progress_indicator.dart';
import '../../../../core/presentation/widgets/input_box_column.dart';
import '../../../authentication/data/models/user_model.dart';

class AddBookForm extends StatefulWidget {
  const AddBookForm({super.key});

  @override
  State<AddBookForm> createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  late TextEditingController isbnController;
  late TextEditingController priceController;
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController publisherController;
  late TextEditingController publicationDateController;
  late TextEditingController pageCountController;
  late TextEditingController editionController;
  late TextEditingController descriptionController;
  late TextEditingController editionLanguageController;
  //coverImage
  late TextEditingController quantityController;
  //category

  final _formKey = GlobalKey<FormState>();

  bool isLoging = false;

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

    isbnController = TextEditingController();
    priceController = TextEditingController();
    titleController = TextEditingController();
    authorController = TextEditingController();
    publisherController = TextEditingController();
    publicationDateController = TextEditingController();
    pageCountController = TextEditingController();
    editionController = TextEditingController();
    descriptionController = TextEditingController();
    editionLanguageController = TextEditingController();
    //coverImage
    quantityController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'إضافة كتاب'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  InputBoxColumn(
                    label: 'ردمك',
                    hintText: '9786030199778',
                    suffixIconData: Icons.book,
                    controller: isbnController,
                    maxLength: 13,
                    validator: (p0) => isbnController.text.length == 13
                        ? null
                        : 'يجب أن يتكون ردمك من 13 خانة',
                  ),
                  InputBoxColumn(
                    label: 'العنوان',
                    hintText: 'أساسيات البرمجة',
                    suffixIconData: Icons.title_rounded,
                    controller: titleController,
                    validator: (p0) => titleController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال العنوان',
                  ),
                  InputBoxColumn(
                    label: 'المؤلف',
                    hintText: 'علي القايد',
                    suffixIconData: Icons.person,
                    controller: authorController,
                    validator: (p0) => authorController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال اسم المؤلف',
                  ),
                  InputBoxColumn(
                    label: 'دار النشر',
                    hintText: 'دار الحكمة',
                    suffixIconData: Icons.local_library_rounded,
                    controller: publisherController,
                    validator: (p0) => publisherController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال دار النشر',
                  ),
                  InputBoxColumn(
                    label: 'عدد الصفحات',
                    hintText: '180',
                    suffixIconData: Icons.my_library_books,
                    controller: pageCountController,
                    validator: (p0) => pageCountController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال عدد الصفحات',
                  ),
                  InputBoxColumn(
                    label: 'عدد الطبعة',
                    hintText: 'الثانية',
                    suffixIconData: Icons.mode_edit_outline,
                    controller: editionController,
                    validator: (p0) => editionController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال عدد الطبعة',
                  ),
                  InputBoxColumn(
                    label: 'تاريخ النشر',
                    hintText: '2015/12/10',
                    suffixIconData: Icons.date_range_outlined,
                    controller: publicationDateController,
                    validator: (p0) => publicationDateController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال تاريخ النشر',
                  ),
                  InputBoxColumn(
                    label: 'الوصف',
                    hintText:
                        'كتاب عن أساسيات البرمجة وأهم ما يحتاجه المبرمج المبتدئ',
                    suffixIconData: Icons.description,
                    controller: descriptionController,
                    validator: (p0) => descriptionController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال الوصف',
                  ),
                  InputBoxColumn(
                    label: 'الكمية',
                    hintText: '3',
                    suffixIconData: Icons.production_quantity_limits_rounded,
                    controller: quantityController,
                    validator: (p0) => quantityController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال الكمية',
                  ),
                  InputBoxColumn(
                    label: 'السعر',
                    hintText: '20 دينار',
                    suffixIconData: Icons.attach_money_outlined,
                    controller: priceController,
                    validator: (p0) => priceController.text.isNotEmpty
                        ? null
                        : 'يجب ادخال الكمية',
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  isLoging
                      ? const BaseProgressIndicator()
                      : BaseButton(
                          text: 'إضافة الكتاب',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(
                                () {
                                  isLoging = true;
                                },
                              );

                              final user = await getUser();

                              CollectionReference userBooks = FirebaseFirestore
                                  .instance
                                  .collection('Users')
                                  .doc(user!.id)
                                  .collection('Books');

                              final result = await userBooks
                                  .doc(isbnController.text)
                                  .get();

                              if (result.exists) {
                                buildBaseFlushBar(
                                    context: context,
                                    message:
                                        'الكتاب برقم ردمك: ${isbnController.text} موجود مسبقا!');
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(user.id)
                                    .collection('Books')
                                    .add(
                                      BookModel(
                                        isbn: isbnController.text,
                                        title: titleController.text,
                                        author: authorController.text,
                                        publisher: publisherController.text,
                                        edition: editionController.text,
                                        description: descriptionController.text,
                                        coverImageUrl:
                                            'https://firebasestorage.googleapis.com/v0/b/mybook-f7793.appspot.com/o/Images%2F%D8%A7%D9%84%D9%83%D8%AA%D8%A7%D8%A81.jpg?alt=media&token=ed531fa7-0dc4-4a03-9cbc-b938ad030812',
                                        category: 'فكر',
                                        pageCount:
                                            int.parse(pageCountController.text),
                                        quantity:
                                            int.parse(quantityController.text),
                                        price: num.parse(priceController.text),
                                        status: true,
                                      ).toJson(),
                                    )
                                    .then((value) => Navigator.popUntil(
                                          context,
                                          (route) => route.isFirst,
                                        ));
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
