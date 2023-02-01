import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:kitaby/utils/constants.dart';
import 'package:meta/meta.dart';

import '../../../../core/data/models/book_model.dart';

part 'edit_customer_book_event.dart';
part 'edit_customer_book_state.dart';

class EditCustomerBookBloc
    extends Bloc<EditCustomerBookEvent, EditCustomerBookState> {
  final isbnController = TextEditingController(),
      priceController = TextEditingController(),
      titleController = TextEditingController(),
      authorController = TextEditingController(),
      publisherController = TextEditingController(),
      publicationDateController = TextEditingController(),
      pageCountController = TextEditingController(),
      editionController = TextEditingController(),
      descriptionController = TextEditingController(),
      editionLanguageController = TextEditingController(),
      quantityController = TextEditingController();

  EditCustomerBookBloc() : super(EditCustomerBookInitial()) {
    on<EditCustomerBookEvent>((event, emit) async {
      emit(EditCustomerBookLoading());

      final user = await Constants.getUser();

      CollectionReference userBooks = FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.id)
          .collection('Books');

      final result = await userBooks.doc(isbnController.text).get();

      if (result.exists) {
        emit(EditCustomerBookError());
      } else {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref('book_covers')
            .child(isbnController.text);
        await ref.putFile(event.image!);

        final downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.phoneNumber)
            .collection('Books')
            .doc(isbnController.text)
            .update(
              BookModel(
                isbn: isbnController.text,
                title: titleController.text,
                author: authorController.text,
                publisher: publisherController.text,
                edition: editionController.text,
                description: descriptionController.text,
                coverImageUrl: downloadUrl,
                category: 'فكر',
                pageCount: int.parse(pageCountController.text),
                quantity: int.parse(quantityController.text),
                price: num.parse(priceController.text),
                dealType: event.selectedDeal,
                status: true,
                userPhoneNumber: user.phoneNumber,
              ).toJson(),
            );

        emit(EditCustomerBookAdded());
      }
    });
  }
}
