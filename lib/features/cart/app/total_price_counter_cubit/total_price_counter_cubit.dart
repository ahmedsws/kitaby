import 'package:flutter_bloc/flutter_bloc.dart';

class TotalPriceCounterCubit extends Cubit<num> {
  TotalPriceCounterCubit() : super(0);

  void calcTotalPrice({required num totalPrice}) {
    return emit(totalPrice += state);
  }

  void resetTotolPrice() {
    return emit(0);
  }
}
