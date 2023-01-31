import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
import 'package:kitaby/features/customer_store/app/add_customer_book_bloc/add_customer_book_bloc.dart';
import 'package:kitaby/features/customer_store/app/select_image_bloc/select_image_bloc.dart';
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
  final List<String> dealTypes = ['بيع', 'تبادل', 'استعارة'];

  String selectedDeal = 'بيع';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<AddCustomerBookBloc, AddCustomerBookState>(
      listener: (context, state) {
        if (state is AddCustomerBookAdded) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pop(context);
          });
        }
      },
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
                              if (state is ImageSelected)
                                ProfileImageContainer(
                                  image: Image.file(
                                    state.image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Container(
                                height: 200.h,
                                width: 200.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
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
                      controller:
                          context.read<AddCustomerBookBloc>().isbnController,
                      maxLength: 13,
                      validator: (p0) => context
                                  .read<AddCustomerBookBloc>()
                                  .isbnController
                                  .text
                                  .length ==
                              13
                          ? null
                          : 'يجب أن يتكون ردمك من 13 خانة',
                    ),
                    InputBoxColumn(
                      label: 'العنوان',
                      hintText: 'أساسيات البرمجة',
                      suffixIconData: Icons.title_rounded,
                      controller:
                          context.read<AddCustomerBookBloc>().titleController,
                      validator: (p0) => context
                              .read<AddCustomerBookBloc>()
                              .titleController
                              .text
                              .isNotEmpty
                          ? null
                          : 'يجب ادخال العنوان',
                    ),
                    InputBoxColumn(
                      label: 'المؤلف',
                      hintText: 'علي القايد',
                      suffixIconData: Icons.person,
                      controller:
                          context.read<AddCustomerBookBloc>().authorController,
                      validator: (p0) => context
                              .read<AddCustomerBookBloc>()
                              .authorController
                              .text
                              .isNotEmpty
                          ? null
                          : 'يجب ادخال اسم المؤلف',
                    ),
                    InputBoxColumn(
                      label: 'دار النشر',
                      hintText: 'دار الحكمة',
                      suffixIconData: Icons.local_library_rounded,
                      controller: context
                          .read<AddCustomerBookBloc>()
                          .publisherController,
                      validator: (p0) => context
                              .read<AddCustomerBookBloc>()
                              .publisherController
                              .text
                              .isNotEmpty
                          ? null
                          : 'يجب ادخال دار النشر',
                    ),
                    InputBoxColumn(
                      label: 'عدد الصفحات',
                      hintText: '180',
                      suffixIconData: Icons.my_library_books,
                      controller: context
                          .read<AddCustomerBookBloc>()
                          .pageCountController,
                      validator: (p0) => context
                              .read<AddCustomerBookBloc>()
                              .pageCountController
                              .text
                              .isNotEmpty
                          ? null
                          : 'يجب ادخال عدد الصفحات',
                    ),
                    InputBoxColumn(
                      label: 'عدد الطبعة',
                      hintText: 'الثانية',
                      suffixIconData: Icons.mode_edit_outline,
                      controller:
                          context.read<AddCustomerBookBloc>().editionController,
                      validator: (p0) => context
                              .read<AddCustomerBookBloc>()
                              .editionController
                              .text
                              .isNotEmpty
                          ? null
                          : 'يجب ادخال عدد الطبعة',
                    ),
                    InputBoxColumn(
                      label: 'الوصف',
                      hintText:
                          'كتاب عن أساسيات البرمجة وأهم ما يحتاجه المبرمج المبتدئ',
                      suffixIconData: Icons.description,
                      controller: context
                          .read<AddCustomerBookBloc>()
                          .descriptionController,
                      maxLines: 7,
                      validator: (p0) => context
                              .read<AddCustomerBookBloc>()
                              .descriptionController
                              .text
                              .isNotEmpty
                          ? null
                          : 'يجب ادخال الوصف',
                    ),
                    InputBoxColumn(
                      label: 'الكمية',
                      hintText: '3',
                      suffixIconData: Icons.production_quantity_limits_rounded,
                      controller: context
                          .read<AddCustomerBookBloc>()
                          .quantityController,
                      validator: (p0) => context
                              .read<AddCustomerBookBloc>()
                              .quantityController
                              .text
                              .isNotEmpty
                          ? null
                          : 'يجب ادخال الكمية',
                    ),
                    if (selectedDeal == 'بيع')
                      InputBoxColumn(
                        label: 'السعر',
                        hintText: '20 دينار',
                        suffixIconData: Icons.attach_money_outlined,
                        controller:
                            context.read<AddCustomerBookBloc>().priceController,
                        validator: (p0) => context
                                .read<AddCustomerBookBloc>()
                                .priceController
                                .text
                                .isNotEmpty
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
                    BlocBuilder<SelectImageBloc, SelectImageState>(
                      builder: (context, imageState) {
                        return BlocConsumer<AddCustomerBookBloc,
                            AddCustomerBookState>(
                          listener: (context, state) {
                            if (state is AddCustomerBookAdded) {
                              // Navigator.popUntil(
                              //   context,
                              //   (route) => route.isFirst,
                              // );
                            }
                            if (state is AddCustomerBookError) {
                              buildBaseFlushBar(
                                  context: context,
                                  message:
                                      'الكتاب برقم ردمك: ${context.read<AddCustomerBookBloc>().isbnController.text} موجود مسبقا!');
                            }
                          },
                          builder: (context, state) {
                            return state is AddCustomerBookInitial
                                ? BaseButton(
                                    text: 'إضافة الكتاب',
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (imageState.image != null) {
                                          // TODO
                                          BlocProvider.of<AddCustomerBookBloc>(
                                                  context)
                                              .add(
                                            AddCustomerBookEvent(
                                              image: imageState.image,
                                              selectedDeal: selectedDeal,
                                            ),
                                          );
                                        }
                                      } else {
                                        buildBaseFlushBar(
                                          context: context,
                                          message:
                                              'يجب تعبئة الحقول بشكل صحيح!',
                                        );
                                      }
                                    },
                                  )
                                : const BaseProgressIndicator();
                          },
                        );
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
