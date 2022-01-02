import 'package:bloc/bloc.dart';

class TripsCubit extends Cubit<int> {
  TripsCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
