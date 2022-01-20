import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trips_repository/trips_repository.dart';

part 'trip_detail_state.dart';

class TripDetailCubit extends Cubit<TripDetailState> {
  TripDetailCubit(Trip trip) : super(TripDetailState(trip, 0));

  Future<void> refreshSelectedDay(int index) async {
    emit(state.copyWith(dayIndex: index));
  }

  Future<Trip?> refreshTrip(Trip? trip) async {
    emit(state.copyWith(trip: trip));
    return trip;
  }
}
