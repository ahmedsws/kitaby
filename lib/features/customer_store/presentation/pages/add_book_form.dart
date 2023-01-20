import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
import 'package:kitaby/features/customer_store/app/bloc/select_image_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/presentation/widgets/base_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/presentation/widgets/base_flushbar.dart';
import '../../../../core/presentation/widgets/base_progress_indicator.dart';
import '../../../../core/presentation/widgets/containers_decoration.dart';
import '../../../../core/presentation/widgets/input_box_column.dart';
import '../../../../utils/constants.dart';
import '../../../authentication/data/models/user_model.dart';
import '../widgets/profile_image_container.dart';

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

  final List<String> dealTypes = ['بيع', 'تبادل', 'استعارة'];

  String selectedDeal = 'بيع';

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
    return BlocProvider(
      create: (context) => SelectImageBloc(),
      child: Directionality(
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
                    BlocBuilder<SelectImageBloc, SelectImageState>(
                      builder: (context, state) {
                        return GestureDetector(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (state
                                  is ImageSelected) // && state.image != null
                                ProfileImageContainer(
                                  image: Image.file(
                                    state.image!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              // else if (widget.userData.user.image != null)
                              //   ProfileImageContainer(
                              //     imagePath: widget.userData.user.image,
                              //   ),
                              ,
                              Container(
                                height: 100.h,
                                width: 100.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.r),
                                  color: Colors.black.withOpacity(.43),
                                ),
                                child: Icon(
                                  Icons.cloud_upload_rounded,
                                  color: Theme.of(context).primaryColor,
                                  size: 32.w,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            context
                                .read<SelectImageBloc>()
                                .add(SelectImageEvent());
                          },
                        );
                      },
                    ),
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
                      validator: (p0) =>
                          publicationDateController.text.isNotEmpty
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'نوع المعاملة',
                          style: textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          decoration: containersDecoration(context),
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: DropdownButton(
                            underline: const SizedBox(),

                            isExpanded: true,

                            // Initial Value
                            value: selectedDeal,

                            // Down Arrow Icon
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Constants.secondrayFontColor,
                            ),

                            // Array list of items
                            items: dealTypes.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  items,
                                  style: textTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: Constants.secondrayFontColor,
                                  ),
                                ),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDeal = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
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

                                CollectionReference userBooks =
                                    FirebaseFirestore.instance
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
                                          description:
                                              descriptionController.text,
                                          coverImageUrl:
                                              'https://firebasestorage.googleapis.com/v0/b/mybook-f7793.appspot.com/o/Images%2F%D8%A7%D9%84%D9%83%D8%AA%D8%A7%D8%A81.jpg?alt=media&token=ed531fa7-0dc4-4a03-9cbc-b938ad030812',
                                          category: 'فكر',
                                          pageCount: int.parse(
                                              pageCountController.text),
                                          quantity: int.parse(
                                              quantityController.text),
                                          price:
                                              num.parse(priceController.text),
                                          dealType: selectedDeal,
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
      ),
    );
  }
}
