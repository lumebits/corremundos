part of 'create_event_cubit.dart';

class CreateEventState extends Equatable {
  CreateEventState({
    TripEvent? tripEvent,
    this.day,
    bool? isLoading,
    bool? error,
    this.pickedFile,
  })  : tripEvent = tripEvent ?? TripEvent.empty,
        isLoading = isLoading ?? false,
        error = error ?? false;

  final TripEvent tripEvent;
  final DateTime? day;
  final bool isLoading;
  final bool error;
  final FilePickerResult? pickedFile;

  CreateEventState copyWith({
    TripEvent? tripEvent,
    DateTime? day,
    bool? isLoading,
    bool? error,
    FilePickerResult? pickedFile,
  }) {
    return CreateEventState(
      tripEvent: tripEvent ?? this.tripEvent,
      day: day ?? this.day,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      pickedFile: pickedFile ?? this.pickedFile,
    );
  }

  @override
  List<Object?> get props => [tripEvent, day, isLoading, error, pickedFile];

  @override
  String toString() => 'TripsState { tripEvent: $tripEvent, day: $day, '
      'isLoading: $isLoading, error: $error,  pickedFile: $pickedFile }';
}
