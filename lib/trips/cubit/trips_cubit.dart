import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trips_repository/trips_repository.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit(this.tripsRepository, this.authRepository) : super(TripsState());

  final TripsRepository tripsRepository;
  final AuthRepository authRepository;

  Future<void> loadMyTrips() async {
    emit(state.copyWith(isLoading: true));
    await tripsRepository
        .getSharedWithMeTrips(authRepository.currentUser.id)
        .first
        .then((sharedWithMeTrips) {
      sharedWithMeTrips.sort((b1, b2) => b1.initDate.compareTo(b2.initDate));
      emit(
        state.copyWith(
          sharedWithMeTrips: sharedWithMeTrips,
          isLoading: false,
        ),
      );
    }).catchError((dynamic error) {
      emit(state.copyWith(error: true, isLoading: false));
    });

    await tripsRepository
        .getMyTrips(authRepository.currentUser.id)
        .first
        .then((myTrips) {
      myTrips.sort((b1, b2) => b1.initDate.compareTo(b2.initDate));
      emit(
        state.copyWith(
          myTrips: myTrips,
          isLoading: false,
        ),
      );
    }).catchError((dynamic error) {
      emit(state.copyWith(error: true, isLoading: false));
    });
  }

  Future<void> loadCurrentTrip() async {
    emit(state.copyWith(isLoading: true));
    await tripsRepository
        .getCurrentTrip(authRepository.currentUser.id)
        .then((currentTrip) {
      emit(state.copyWith(currentTrip: currentTrip, isLoading: false));
    }).catchError((dynamic error) {
      emit(state.copyWith(error: true, isLoading: false));
    });
  }
}
