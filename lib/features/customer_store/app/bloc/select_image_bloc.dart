import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';

part 'select_image_event.dart';
part 'select_image_state.dart';

class SelectImageBloc extends Bloc<SelectImageEvent, SelectImageState> {
  SelectImageBloc() : super(SelectImageInitial()) {
    on<SelectImageEvent>((event, emit) async {
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();

// Create a reference to "mountains.jpg"
      final mountainsRef = storageRef.child("mountains.jpg");

// Create a reference to 'images/mountains.jpg'
      final mountainImagesRef = storageRef.child("images/mountains.jpg");

// While the file names are the same, the references point to different files
      assert(mountainsRef.name == mountainImagesRef.name);
      assert(mountainsRef.fullPath != mountainImagesRef.fullPath);

      final image = await getImage();

      // try {
      //   await mountainsRef.putFile(image!);
      //   await mountainsRef.getDownloadURL();

      //   emit(ImageSelected(image: image));
      // } on FirebaseException catch (e) {
      //   // ...
      //   print('errorrrrrr');
      // }

      emit(ImageSelected(image: image!));
    });
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
