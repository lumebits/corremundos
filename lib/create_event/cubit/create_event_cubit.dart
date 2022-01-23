import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:trips_repository/trips_repository.dart';

part 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit(this.tripsRepository, this.authRepository, this.trip)
      : super(CreateEventState());

  final TripsRepository tripsRepository;
  final AuthRepository authRepository;
  final Trip trip;

  void loadEventToEdit(TripEvent event, DateTime day) {
    emit(
      state.copyWith(
        tripEvent: event,
        day: day,
      ),
    );
  }

  void locationChanged(String value) {
    final tripEvent = state.tripEvent.copyWith(location: value);
    emit(
      state.copyWith(
        tripEvent: tripEvent,
        day: state.day,
        pickedFile: state.pickedFile,
      ),
    );
  }

  void nameChanged(String value) {
    final tripEvent = state.tripEvent.copyWith(name: value);
    emit(
      state.copyWith(
        tripEvent: tripEvent,
        day: state.day,
        pickedFile: state.pickedFile,
      ),
    );
  }

  void timeChanged(DateTime value) {
    final tripEvent = state.tripEvent.copyWith(time: value);
    emit(
      state.copyWith(
        tripEvent: tripEvent,
        day: state.day,
        pickedFile: state.pickedFile,
      ),
    );
  }

  void endTimeChanged(DateTime value) {
    final tripEvent = state.tripEvent.copyWith(endTime: value);
    emit(
      state.copyWith(
        tripEvent: tripEvent,
        day: state.day,
        pickedFile: state.pickedFile,
      ),
    );
  }

  void fileChanged(FilePickerResult? result) {
    emit(
      state.copyWith(
        pickedFile: result,
      ),
    );
  }

  DateTime setEndTime(DateTime day) {
    final now = DateTime.now();
    if (state.day == null ||
        now.year == day.year && now.month == day.month && now.day == day.day) {
      return day;
    } else {
      return state.day!;
    }
  }

  Future<String?> uploadFile() async {
    if (state.pickedFile != null) {
      final fileBytes = state.pickedFile!.files.first.bytes;
      final fileName = state.pickedFile!.files.first.name;
      if (fileBytes != null) {
        return tripsRepository.uploadFileToStorage(fileBytes, fileName);
      } else {
        return null;
      }
    }
  }

  Future<Trip?> saveEvent(EventType eventType) async {
    emit(state.copyWith(isLoading: true));
    if (state.pickedFile != null) {
      await uploadFile().then((uploadedFileUrl) async {
        if (uploadedFileUrl != null) {
          if (eventType == EventType.transport) {
            final transportation = <String, dynamic>{
              'file': uploadedFileUrl,
              'location': state.tripEvent.name,
              'notes': state.tripEvent.location,
              'departureTime': state.tripEvent.time,
              'arrivalTime': state.tripEvent.endTime,
            };
            if (state.tripEvent.index != null) {
              trip.transportations[state.tripEvent.index!] = transportation;
            } else {
              trip.transportations.add(transportation);
            }
            final updatedTrip =
                trip.copyWith(transportations: trip.transportations);
            await tripsRepository.addEvents(
              updatedTrip,
              authRepository.currentUser.id,
            );
            return Future.value(updatedTrip.refreshEventMap());
          } else if (eventType == EventType.accommodation) {
            final accommodation = <String, dynamic>{
              'file': uploadedFileUrl,
              'name': state.tripEvent.name,
              'location': state.tripEvent.location,
              'checkin': state.tripEvent.time,
              'checkout': state.tripEvent.endTime,
            };
            if (state.tripEvent.index != null) {
              trip.accommodations[state.tripEvent.index!] = accommodation;
            } else {
              trip.accommodations.add(accommodation);
            }
            final updatedTrip =
                trip.copyWith(accommodations: trip.accommodations);
            await tripsRepository.addEvents(
              updatedTrip,
              authRepository.currentUser.id,
            );
            return Future.value(updatedTrip.refreshEventMap());
          } else if (eventType == EventType.activity) {
            final activity = <String, dynamic>{
              'file': uploadedFileUrl,
              'name': state.tripEvent.name,
              'location': state.tripEvent.location,
              'checkin': state.tripEvent.time,
              'checkout': state.tripEvent.endTime,
            };
            if (state.tripEvent.index != null) {
              trip.activities[state.tripEvent.index!] = activity;
            } else {
              trip.activities.add(activity);
            }
            final updatedTrip = trip.copyWith(activities: trip.activities);
            await tripsRepository.addEvents(
              updatedTrip,
              authRepository.currentUser.id,
            );
            return Future.value(updatedTrip.refreshEventMap());
          }
          emit(state.copyWith(isLoading: false));
        } else {
          emit(state.copyWith(isLoading: false, error: true));
        }
      });
    } else {
      if (eventType == EventType.transport) {
        final transportation = <String, dynamic>{
          'file': '',
          'location': state.tripEvent.name,
          'notes': state.tripEvent.location,
          'departureTime': state.tripEvent.time,
          'arrivalTime': state.tripEvent.endTime,
        };
        if (state.tripEvent.index != null) {
          trip.transportations[state.tripEvent.index!] = transportation;
        } else {
          trip.transportations.add(transportation);
        }
        final updatedTrip =
            trip.copyWith(transportations: trip.transportations);
        await tripsRepository.addEvents(
          updatedTrip,
          authRepository.currentUser.id,
        );
        return Future.value(updatedTrip.refreshEventMap());
      } else if (eventType == EventType.activity) {
        final activity = <String, dynamic>{
          'file': '',
          'name': state.tripEvent.name,
          'location': state.tripEvent.location,
          'time': state.tripEvent.time,
        };
        if (state.tripEvent.index != null) {
          trip.activities[state.tripEvent.index!] = activity;
        } else {
          trip.activities.add(activity);
        }
        final updatedTrip = trip.copyWith(activities: trip.activities);
        await tripsRepository.addEvents(
          updatedTrip,
          authRepository.currentUser.id,
        );
        return Future.value(updatedTrip.refreshEventMap());
      } else if (eventType == EventType.accommodation) {
        final accommodation = <String, dynamic>{
          'file': '',
          'name': state.tripEvent.name,
          'location': state.tripEvent.location,
          'checkin': state.tripEvent.time,
          'checkout': state.tripEvent.endTime,
        };
        if (state.tripEvent.index != null) {
          trip.accommodations[state.tripEvent.index!] = accommodation;
        } else {
          trip.accommodations.add(accommodation);
        }
        final updatedTrip = trip.copyWith(accommodations: trip.accommodations);
        await tripsRepository.addEvents(
          updatedTrip,
          authRepository.currentUser.id,
        );
        return Future.value(updatedTrip.refreshEventMap());
      }
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<Trip?> deleteTripEvent(String tripId) async {
    await tripsRepository.deleteTripEvent(tripId, state.tripEvent);
    if (state.tripEvent.type == EventType.accommodation) {
      final accommodation = tripEventToAccommodation(state.tripEvent);
      trip.accommodations.removeWhere(
        (dynamic e) =>
            (e as Map<String, dynamic>)['file'] == accommodation['file'] &&
            e['name'] == accommodation['name'] &&
            e['location'] == accommodation['location'] &&
            e['checkin'] == accommodation['checkin'] &&
            e['checkout'] == accommodation['checkout'],
      );
    } else if (state.tripEvent.type == EventType.activity) {
      final activity = tripEventToActivity(state.tripEvent);
      trip.activities.removeWhere(
        (dynamic e) =>
            (e as Map<String, dynamic>)['file'] == activity['file'] &&
            e['name'] == activity['name'] &&
            e['location'] == activity['location'] &&
            e['time'] == activity['time'],
      );
    } else if (state.tripEvent.type == EventType.transport) {
      final transport = tripEventToTransportation(state.tripEvent);
      trip.transportations.removeWhere(
        (dynamic e) =>
            (e as Map<String, dynamic>)['file'] == transport['file'] &&
            e['name'] == transport['name'] &&
            e['location'] == transport['location'] &&
            e['departureTime'] == transport['departureTime'] &&
            e['arrivalTime'] == transport['arrivalTime'],
      );
    }
    final updatedTrip = trip.copyWith(
      accommodations: trip.accommodations,
      activities: trip.activities,
      transportations: trip.transportations,
    );
    return Future.value(updatedTrip.refreshEventMap());
  }
}

Map<String, dynamic> tripEventToAccommodation(TripEvent tripEvent) {
  return <String, dynamic>{
    'name': tripEvent.name,
    'location': tripEvent.location,
    'checkin': tripEvent.time,
    'checkout': tripEvent.endTime,
    'file': tripEvent.fileUrl,
  };
}

Map<String, dynamic> tripEventToActivity(TripEvent tripEvent) {
  return <String, dynamic>{
    'name': tripEvent.name,
    'location': tripEvent.location,
    'time': tripEvent.time,
    'file': tripEvent.fileUrl,
  };
}

Map<String, dynamic> tripEventToTransportation(TripEvent tripEvent) {
  return <String, dynamic>{
    'notes': tripEvent.location,
    'location': tripEvent.name,
    'departureTime': tripEvent.time,
    'arrivalTime': tripEvent.endTime,
    'file': tripEvent.fileUrl,
  };
}
