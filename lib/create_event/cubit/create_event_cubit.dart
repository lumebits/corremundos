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
}
