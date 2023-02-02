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
  final priceController = TextEditingController(),
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
      try {
        final user = await Constants.getUser();

        String imageUrl = event.coverImageUrl!;

        if (event.image != null) {
          final ref = firebase_storage.FirebaseStorage.instance
              .ref('book_covers')
              .child(event.isbn);
          await ref.putFile(event.image!);

          final downloadUrl = await ref.getDownloadURL();
          imageUrl = downloadUrl;
        }

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.phoneNumber)
            .collection('Books')
            .doc(event.isbn)
            .update(
              BookModel(
                isbn: event.isbn,
                title: titleController.text,
                author: authorController.text,
                publisher: publisherController.text,
                edition: editionController.text,
                description: descriptionController.text,
                coverImageUrl: imageUrl,
                category: 'فكر', //TODO
                pageCount: int.parse(pageCountController.text),
                quantity: int.parse(quantityController.text),
                price: priceController.text.isNotEmpty
                    ? num.tryParse(priceController.text)
                    : null,
                dealType: event.selectedDeal,
                status: event.status,
                userPhoneNumber: user.phoneNumber,
                ratings: event.ratings,
              ).toJson(),
            );

        emit(EditCustomerBookAdded());
      } catch (e) {
        emit(EditCustomerBookError());
        emit(EditCustomerBookInitial());
      }
    });
  }
}
