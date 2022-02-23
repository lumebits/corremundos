import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:trips_repository/trips_repository.dart';

part 'past_trips_state.dart';

class PastTripsCubit extends Cubit<PastTripsState> {
  PastTripsCubit(
    this.tripsRepository,
    this.authRepository,
    this.profileRepository,
  ) : super(PastTripsState());

  final TripsRepository tripsRepository;
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  Future<void> loadPastTrips() async {
    emit(state.copyWith(isLoading: true, isLoadingShared: true));
    await tripsRepository
        .getSharedWithMePastTrips(authRepository.currentUser.id)
        .first
        .then((sharedWithMePastTrips) {
      sharedWithMePastTrips
          .sort((b1, b2) => b1.initDate.compareTo(b2.initDate));
      emit(
        state.copyWith(
          sharedWithMePastTrips: sharedWithMePastTrips,
          isLoadingShared: false,
        ),
      );
    }).catchError((dynamic error) {
      emit(state.copyWith(error: true, isLoadingShared: false));
    });

    await tripsRepository
        .getPastTrips(authRepository.currentUser.id)
        .first
        .then((pastTrips) {
      pastTrips.sort((b1, b2) => b1.initDate.compareTo(b2.initDate));
      emit(
        state.copyWith(
          pastTrips: pastTrips,
          isLoading: false,
        ),
      );
    }).catchError((dynamic error) {
      emit(state.copyWith(error: true, isLoading: false));
    });
  }

  Future<void> deleteTrip(Trip trip) async {
    emit(state.copyWith(isLoading: true));
    await tripsRepository
        .deleteTrip(trip, authRepository.currentUser.id)
        .then((value) {
      loadPastTrips();
    });
  }
}
