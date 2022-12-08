import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/features/home/presentation/widgets/cart_item.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../store_books/models/book_model.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  // const Cart({Key? key}) : super(key: key);
  var paymethod = ' ';


  @override
  Widget build(BuildContext context) {
    CollectionReference cart = FirebaseFirestore.instance.collection('Users').doc('960aFXZwepWCzLXkUWAp').collection('Cart').doc('hhh').collection('Cart_Item');
    CollectionReference books = FirebaseFirestore.instance.collection('Books');
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            body: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              SizedBox(
                height: 30.h,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'السلة',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Column(
                children: [
                  Container(
                    height: 413.h,
                    child: SingleChildScrollView(

                      child:  FutureBuilder(
                        future: cart.get(),
                        builder: (context,  snapshot) {
                          return snapshot.connectionState == ConnectionState.done ?

                                Column(
                                 children: [
                                   ...snapshot.data!.docs.map(
                                           (doc) { Map<String, dynamic> data =
                                            doc.data() as Map<String, dynamic>;
                                             // final bookitem = books.doc(data['book_isbn']).get();
                                             // final book = BookModel.fromJson();

                                       return FutureBuilder(
                                         future: books.doc(data['book_isbn']).get(),
                                         builder: (context,  snapshot) {
                                           final book = BookModel.fromJson(snapshot.data!.data()! as Map<String, dynamic>);
                                           return snapshot.connectionState == ConnectionState.done ?

                                             Column(
                                               children: [
                                                 CartItem(book: book, qua: data['quantity']),
                                                 SizedBox(
                                                   width: 26.w,
                                                 ),
                                               ],
                                             )
                                           : const Center(
                                             child: CircularProgressIndicator(),
                                           );

                                         });
                                       }),
                                 ],
                                ): const Center(
                                child: CircularProgressIndicator(),
                          );
                                      }
                                      ),



                      ),


                  ),
                    SizedBox(
                  height: 27.h,
                    ),
                    GestureDetector(
                  onTap: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            // <-- SEE HERE
                            title: const Text('إختر وسيلة الدفع'),
                            children: <Widget>[
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    paymethod = 'عند التوصيل';
                                  });
                                },
                                child: const Text('عند التوصيل'),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    paymethod = 'إلكتروني';
                                  });
                                },
                                child: const Text('إلكتروني'),
                              ),
                            ],
                          );
                        });
                    ;
                  },
                  child: Container(
                    width: 325.w,
                    height: 48.h,
                    margin: EdgeInsets.only(left: 15.w),
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
                          width: 12.w,
                        ),
                        Container(child: Icon(Icons.payment)),
                        SizedBox(
                          width: 21.w,
                        ),
                        Text(
                          'وسيلة الدفع',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                        ),
                        SizedBox(
                          width: 124.w,
                        ),
                        Text(
                          paymethod,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp,
                                  ),
                        ),
                      ],

                    ),
                  ),
                  SizedBox(
                    height: 37.h,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140.h,
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(
                              'المبلغ الإجمالي',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                            ),
                            SizedBox(
                              width: 170.w,
                            ),
                            Text('130د.ل'),
                          ],
                        ),
                        SizedBox(
                          height: 33.h,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 319.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF23311C),
                          ),
                          child: Text(
                            'إجراء الطلب',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ]))));
  }
}
