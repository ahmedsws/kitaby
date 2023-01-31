import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';

part 'select_image_event.dart';
part 'select_image_state.dart';

class SelectImageBloc extends Bloc<SelectImageEvent, SelectImageState> {
  SelectImageBloc() : super(SelectImageInitial()) {
    on<SelectImageEvent>(
      (event, emit) async {
        final image = await getImage();
        emit(
          ImageSelected(image: image!),
        );
      },
    );
  }

  Future<File?> getImage() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}
