import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitaby/core/presentation/widgets/base_progress_indicator.dart';
import 'package:kitaby/features/authentication/data/models/user_model.dart';
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/utils/constants.dart';
import '../../../../core/presentation/widgets/base_app_bar.dart';
import '../widgets/book_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreBooksPage extends StatefulWidget {
  const StoreBooksPage({super.key});

  @override
  State<StoreBooksPage> createState() => _StoreBooksPageState();
}

class _StoreBooksPageState extends State<StoreBooksPage> {
  String searchText = '';
  List<String> filter = [];
  List<String> searchFilters = [
    'شريعة',
    'اقتصاد',
    'علوم حاسب',
    'طب',
    'هندسة',
    'تاريخ',
    'فكر',
    'روايات',
    'رياضة',
  ];

  bool? sortByLowerPrice;
  bool? sortByHighRate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    CollectionReference books = FirebaseFirestore.instance.collection('Books');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: BaseAppBar(
          title: 'كتب المتجر',
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       showDialog(
          //         context: context,
          //         builder: (context) => Directionality(
          //           textDirection: TextDirection.rtl,
          //           child: SimpleDialog(
          //             title: Center(
          //               child: Text(
          //                 'تصنيف',
          //                 style: textTheme.bodyText1!.copyWith(
          //                   fontSize: 24.sp,
          //                   fontWeight: FontWeight.bold,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //             ),
          //             children: [
          //               Wrap(
          //                 children: [
          //                   InkWell(
          //                     onTap: () {
          //                       // setState(() {
          //                       //   if(sortByLowerPrice != null)
          //                       //    {   sortByLowerPrice = !sortByLowerPrice}
          //                       //       else{sortByLowerPrice= true}
          //                       // });

          //                       Navigator.pop(context);
          //                     },
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                         border: Border.all(
          //                           color: Theme.of(context).accentColor,
          //                         ),
          //                         borderRadius: BorderRadius.circular(
          //                           10.r,
          //                         ),
          //                         color: sortByLowerPrice != null
          //                             ? const Color.fromARGB(255, 135, 226, 138)
          //                             : null,
          //                       ),
          //                       margin: EdgeInsets.all(10),
          //                       padding: EdgeInsets.all(10),
          //                       child: Text(
          //                         'الأقل سعرا',
          //                         style: textTheme.bodyText1!.copyWith(
          //                           fontSize: 16.sp,
          //                           fontWeight: FontWeight.bold,
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //     icon: Icon(
          //       Icons.sort_by_alpha_rounded,
          //     ),
          //   )
          // ],
          leading: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: SimpleDialog(
                      title: Center(
                        child: Text(
                          'فلترة',
                          style: textTheme.bodyText1!.copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      children: [
                        Wrap(
                          children: [
                            ...searchFilters.map(
                              (searchFilter) => InkWell(
                                onTap: () {
                                  filter.contains(searchFilter)
                                      ? setState(() {
                                          filter.remove(searchFilter);
                                        })
                                      : setState(() {
                                          filter.add(searchFilter);
                                        });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).accentColor,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      10.r,
                                    ),
                                    color: filter.contains(searchFilter)
                                        ? const Color.fromARGB(
                                            255, 135, 226, 138)
                                        : null,
                                  ),
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    searchFilter,
                                    style: textTheme.bodyText1!.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(
                filter.isEmpty
                    ? Icons.filter_alt_outlined
                    : Icons.filter_alt_rounded,
              )),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 32.h,
              ),
              Container(
                height: 45.h,
                padding: EdgeInsets.only(right: 25.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: const Color(0xFFD9D9D9).withOpacity(.33),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن كتاب بعنوانه',
                    hintStyle: textTheme.bodyText1!.copyWith(
                      color: Constants.secondrayFontColor,
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        height: 15.h,
                        width: 15.w,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: FutureBuilder(
                        future: books.get(),
                        builder: (context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1 / 1.8,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.w,
                                  children: [
                                    ...snapshot.data!.docs
                                        .map(
                                          (doc) {
                                            Map<String, dynamic> data = doc
                                                .data() as Map<String, dynamic>;
                                            final book =
                                                BookModel.fromJson(data);
                                            return BookContainer(
                                              book: book,
                                            );
                                          },
                                        )
                                        .where((doc) =>
                                            doc.book.status == true &&
                                            doc.book.quantity > 0)
                                        .where(
                                          (doc) => doc.book.title
                                              .toLowerCase()
                                              .contains(
                                                  searchText.toLowerCase()),
                                        )
                                        .where(
                                          (doc) {
                                            return filter.isNotEmpty
                                                ? filter
                                                    .contains(doc.book.category)
                                                : true;
                                          },
                                        ),
                                  ],
                                )
                              : const BaseProgressIndicator();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
