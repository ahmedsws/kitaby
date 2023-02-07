import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kitaby/core/data/models/book_model.dart';
import 'package:kitaby/core/presentation/widgets/base_app_bar.dart';
import 'package:kitaby/core/presentation/widgets/base_button.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/order_model.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key? key,
    required this.order,
    required this.books,
  }) : super(key: key);

  final OrderModel order;
  final List<BookModel> books;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: BaseAppBar(
          title: 'تفاصيل الطلب',
          actions: [
            IconButton(
              onPressed: () async {
                final user = await Constants.getUser();
                final pdf = pw.Document();

                var arabicFont = pw.Font.ttf(
                  await rootBundle.load('assets/fonts/HacenTunisia.ttf'),
                );

                pdf.addPage(
                  pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Center(
                              child: pw.Text(
                                'فاتورة طلب',
                                style: pw.TextStyle(
                                  fontSize: 40,
                                  font: arabicFont,
                                  color: PdfColor.fromHex('06070D'),
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 20.h),
                            pw.Expanded(
                              child: pw.Table(
                                children: [
                                  pw.TableRow(
                                    children: [
                                      pw.Text(
                                        user!.name,
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        'الاسم:',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Text(
                                        user.phoneNumber,
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        'رقم الهاتف:',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Text(
                                        user.location,
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        'المنطقة:',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            pw.Divider(
                              height: 50.h,
                              thickness: 2,
                              color: PdfColors.grey,
                            ),
                            pw.Expanded(
                              child: pw.Table(
                                children: [
                                  pw.TableRow(
                                    children: [
                                      pw.Text(
                                        'الإجمالي:',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        'تاريخ الانشاء:',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        'الحالة:',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        'المعاملة:',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      // pw.Text(
                                      //   'الرقم:',
                                      //   style: pw.TextStyle(
                                      //     fontSize: 25,
                                      //     font: arabicFont,
                                      //     color: PdfColor.fromHex('06070D'),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Text(
                                        '${order.totalPrice} د.ل',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        intl.DateFormat('MM/dd/yyyy')
                                            .format(order.dateCreated!),
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        order.status,
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        order.paymentMethod,
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      // pw.Text(
                                      //   '#2', //order.id
                                      //   style: pw.TextStyle(
                                      //     fontSize: 25,
                                      //     font: arabicFont,
                                      //     color: PdfColor.fromHex('06070D'),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // pw.SizedBox(height: 50.h),
                            pw.Divider(
                              height: 45.h,
                              thickness: 1,
                              color: PdfColors.grey,
                            ),
                            pw.Expanded(
                              child: pw.Table(
                                children: [
                                  pw.TableRow(
                                    children: [
                                      pw.Text(
                                        'الكمية',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        'القيمة',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                      pw.Text(
                                        'العنوان',
                                        style: pw.TextStyle(
                                          fontSize: 25,
                                          font: arabicFont,
                                          color: PdfColor.fromHex('06070D'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ...order.orderItems.map(
                                    (orderItem) {
                                      final book = books.firstWhere(
                                        (book) =>
                                            book.isbn == orderItem.bookISBN,
                                      );
                                      return pw.TableRow(
                                        children: [
                                          pw.Text(
                                            orderItem.quantity.toString(),
                                            style: pw.TextStyle(
                                              fontSize: 25,
                                              font: arabicFont,
                                              color: PdfColor.fromHex('06070D'),
                                            ),
                                          ),
                                          pw.Text(
                                            '${book.price} د.ل',
                                            style: pw.TextStyle(
                                              fontSize: 25,
                                              font: arabicFont,
                                              color: PdfColor.fromHex('06070D'),
                                            ),
                                          ),
                                          pw.SizedBox(
                                            width: 80.w,
                                            child: pw.Text(
                                              book.title,
                                              maxLines: 1,
                                              style: pw.TextStyle(
                                                fontSize: 25,
                                                font: arabicFont,
                                                color:
                                                    PdfColor.fromHex('06070D'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ); // Center
                    },
                  ),
                );

                final output = await getTemporaryDirectory();
                final file = File('${output.path}/order_${order.id}.pdf');

                await file.writeAsBytes(await pdf.save());

                OpenFile.open(file.path);
              },
              icon: const Icon(Icons.print_rounded),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 325.w,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 22.h, bottom: 22.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.1),
                        spreadRadius: 1,
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 17.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text(
                        //   'رقم الطلب:',
                        //   style:
                        //       Theme.of(context).textTheme.bodyLarge!.copyWith(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 14.sp,
                        //           ),
                        // ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          'حالة الطلب:',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          'قيمة الطلب:',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          'نوع المعاملة:',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          'تاريخ الطلب',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 130.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   // width: 100.w,
                        //   child: Text(
                        //     '#$number',
                        //     style:
                        //         Theme.of(context).textTheme.bodyLarge!.copyWith(
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 14.sp,
                        //             ),
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          order.status,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                    color: Color(0xff569750),
                                  ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          '${order.totalPrice} د.ل',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          order.paymentMethod,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(
                          height: 13.06.h,
                        ),
                        Text(
                          intl.DateFormat('MM/dd/yyyy')
                              .format(order.dateCreated!),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Container(
                height: 413.h,
                width: double.infinity,
                // margin: EdgeInsets.only(left: 15.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.1),
                        spreadRadius: 1,
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                    ]),
                child: SingleChildScrollView(
                  child: Column(children: [
                    ...order.orderItems.map(
                      (orderItem) {
                        final book = books.firstWhere(
                          (book) => book.isbn == orderItem.bookISBN,
                        );
                        return Column(
                          children: [
                            Container(
                              width: 325.w,
                              height: 131.h,
                              padding: EdgeInsets.only(top: 12.h),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.1),
                                      spreadRadius: 1,
                                      blurRadius: 20,
                                      offset: Offset(0, 0),
                                    ),
                                  ]),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 11.w,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 77.w,
                                        height: 111.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.network(
                                          book.coverImageUrl,
                                          width: 77.w,
                                          height: 106.h,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 19.w,
                                      ),
                                      SizedBox(
                                        width: 130.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            Text(
                                              book.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              book.author,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12.sp,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              '${book.price} د.ل',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 49.h,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 34.h,
                                            width: 66.w,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 20,
                                                    offset: Offset(0, 0),
                                                  ),
                                                ]),
                                            child: Text(
                                              'الكمية: ${orderItem.quantity}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontSize: 13.sp,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        );
                      },
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              BaseButton(
                text: 'العودة',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buildPDF() async {
    final user = await Constants.getUser();
    final pdf = pw.Document();

    var arabicFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/HacenTunisia.ttf'),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'فاتورة',
                    style: pw.TextStyle(
                      fontSize: 40,
                      font: arabicFont,
                      color: PdfColor.fromHex('06070D'),
                    ),
                  ),
                ),
                pw.SizedBox(height: 20.h),
                pw.Table(
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text(
                          user!.name,
                          style: pw.TextStyle(
                            fontSize: 25,
                            font: arabicFont,
                            color: PdfColor.fromHex('06070D'),
                          ),
                        ),
                        pw.Text(
                          'الاسم:',
                          style: pw.TextStyle(
                            fontSize: 25,
                            font: arabicFont,
                            color: PdfColor.fromHex('06070D'),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Text(
                          user.phoneNumber,
                          style: pw.TextStyle(
                            fontSize: 25,
                            font: arabicFont,
                            color: PdfColor.fromHex('06070D'),
                          ),
                        ),
                        pw.Text(
                          'رقم الهاتف:',
                          style: pw.TextStyle(
                            fontSize: 25,
                            font: arabicFont,
                            color: PdfColor.fromHex('06070D'),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Text(
                          user.location,
                          style: pw.TextStyle(
                            fontSize: 25,
                            font: arabicFont,
                            color: PdfColor.fromHex('06070D'),
                          ),
                        ),
                        pw.Text(
                          'المنطقة:',
                          style: pw.TextStyle(
                            fontSize: 25,
                            font: arabicFont,
                            color: PdfColor.fromHex('06070D'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ); // Center
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/order_${order.id}.pdf');

    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }
}
