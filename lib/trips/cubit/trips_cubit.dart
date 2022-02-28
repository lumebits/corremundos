import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:corremundos/notification/notification_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:trips_repository/trips_repository.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit(this.tripsRepository, this.authRepository, this.profileRepository)
      : super(TripsState());

  final TripsRepository tripsRepository;
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  Future<void> loadMyTrips() async {
    emit(state.copyWith(isLoading: true, isLoadingShared: true));
    await tripsRepository
        .getSharedWithMeTrips(authRepository.currentUser.id)
        .first
        .then((sharedWithMeTrips) {
      sharedWithMeTrips.sort((b1, b2) => b1.initDate.compareTo(b2.initDate));
      emit(
        state.copyWith(
          sharedWithMeTrips: sharedWithMeTrips,
          isLoadingShared: false,
        ),
      );
    }).catchError((dynamic error) {
      emit(state.copyWith(error: true, isLoadingShared: false));
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

  Future<void> loadCurrentTrip({bool resetSelectedDay = true}) async {
    emit(state.copyWith(isLoadingCurrent: true));
    await tripsRepository
        .getCurrentTrip(authRepository.currentUser.id)
        .then((currentTrip) {
      final selectedDay = currentTrip.endDate.day < DateTime.now().day ||
              DateTime.now().day <= currentTrip.initDate.day
          ? 0
          : daysBetween(currentTrip.initDate, DateTime.now());

      final tripDays = currentTrip.duration;
      emit(
        state.copyWith(
          currentTrip: currentTrip,
          currentDayIndex:
              resetSelectedDay ? selectedDay : state.currentDayIndex,
          tripDays: tripDays,
          events: currentTrip.eventMap,
          isLoadingCurrent: false,
        ),
      );
    }).catchError((dynamic error) {
      emit(state.copyWith(error: true, isLoadingCurrent: false));
    });
    if (state.currentTrip.isNotEmpty) {
      await NotificationsHelper.setNotification(
        state.currentTrip.initDate.subtract(const Duration(days: 7)),
        'Your next trip is in 7 days!',
        0,
      );
      await NotificationsHelper.setNotification(
        state.currentTrip.initDate.subtract(const Duration(days: 1)),
        'Are you ready for your trip tomorrow?',
        0,
      );
      await NotificationsHelper.setNotification(
        state.currentTrip.initDate,
        'Enjoy your trip!',
        0,
      );
    }
  }

  Future<void> changeSelectedTrip(Trip trip) async {
    emit(state.copyWith(currentTrip: trip, isLoading: false));
  }

  Future<void> refreshSelectedDay(int index) async {
    emit(state.copyWith(currentDayIndex: index, isLoading: false));
  }

  Future<void> deleteTrips() async {
    await tripsRepository.deleteTrips(authRepository.currentUser.id);
  }

  Future<void> deleteTrip(Trip trip) async {
    emit(state.copyWith(isLoading: true));
    await tripsRepository
        .deleteTrip(trip, authRepository.currentUser.id)
        .then((value) {
      loadMyTrips();
    });
  }

  Future<void> emailChanged(String value) async {
    emit(state.copyWith(sharedWithEmail: value));
  }

  Future<void> shareTrip(String tripId, String email) async {
    await profileRepository.getProfileByEmail(email).then((profile) {
      if (profile.isNotEmpty) {
        tripsRepository.shareTrip(tripId, profile.uid);
      } else {
        return throw Exception('Error sharing trip');
      }
    });
  }

  int daysBetween(DateTime from, DateTime to) {
    return (DateTime(to.year, to.month, to.day)
                .difference(DateTime(from.year, from.month, from.day))
                .inHours /
            24)
        .round();
  }
}
