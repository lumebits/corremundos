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

  void descriptionChanged(String value) {
    final tripEvent = state.tripEvent.copyWith(description: value);
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

  void fileChanged(FilePickerResult? result) {
    emit(
      state.copyWith(
        pickedFile: result,
      ),
    );
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

  Future<void> saveEvent(EventType eventType) async {
    emit(state.copyWith(isLoading: true));
    await uploadFile().then((uploadedFileUrl) {
      if (uploadedFileUrl != null) {
        if (eventType == EventType.transportation) {
          final transportation = <String, dynamic>{
            'file': uploadedFileUrl,
            'location': state.tripEvent.location,
            'notes': state.tripEvent.description,
            'time': state.tripEvent.time,
          };
          trip.transportations.add(transportation);
          final updatedTrip =
              trip.copyWith(transportations: trip.transportations);
          tripsRepository.updateOrCreateTrip(
            updatedTrip,
            authRepository.currentUser.id,
          );
        }
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, error: true));
      }
    });
  }
}
