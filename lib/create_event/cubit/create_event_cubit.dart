import 'dart:typed_data';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trips_repository/trips_repository.dart';

part 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit(this.tripsRepository, this.authRepository)
      : super(CreateEventState());

  final TripsRepository tripsRepository;
  final AuthRepository authRepository;

  void locationChanged(String value) {
    final tripEvent = state.tripEvent.copyWith(location: value);
    emit(
      state.copyWith(
        tripEvent: tripEvent,
      ),
    );
  }

  void descriptionChanged(String value) {
    final tripEvent = state.tripEvent.copyWith(description: value);
    emit(
      state.copyWith(
        tripEvent: tripEvent,
      ),
    );
  }

  void timeChanged(DateTime value) {
    final tripEvent = state.tripEvent.copyWith(time: value);
    emit(
      state.copyWith(
        tripEvent: tripEvent,
      ),
    );
  }

  void fileChanged(String value) {
    final tripEvent = state.tripEvent.copyWith(fileUrl: value);
    emit(
      state.copyWith(
        tripEvent: tripEvent,
      ),
    );
  }

  Future<void> saveEvent(Trip trip, EventType eventType) async {
    if (eventType == EventType.transportation) {
      final transportation = <String, dynamic>{
        'file': state.tripEvent.fileUrl,
        'location': state.tripEvent.location,
        'notes': state.tripEvent.description,
        'time': state.tripEvent.time,
      };
      trip.transportations.add(transportation);
      final updatedTrip = trip.copyWith(transportations: trip.transportations);
      await tripsRepository.updateOrCreateTrip(
        updatedTrip,
        authRepository.currentUser.id,
      );
    }
  }

  Future<String?> uploadFile(Uint8List uint8list, String fileName) async {
    return tripsRepository.uploadFileToStorage(
      uint8list,
      fileName,
    );
  }
}
