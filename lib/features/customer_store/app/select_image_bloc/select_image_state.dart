part of 'select_image_bloc.dart';

@immutable
abstract class SelectImageState {
  final File? image;

  const SelectImageState({this.image});
}

class SelectImageInitial extends SelectImageState {}

class ImageSelected extends SelectImageState {
  const ImageSelected({required File image}) : super(image: image);
}
