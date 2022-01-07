part of 'create_event_cubit.dart';

class CreateEventState extends Equatable {
  CreateEventState({
    TripEvent? tripEvent,
    DateTime? day,
    bool? isLoading,
    bool? error,
  })  : tripEvent = tripEvent ?? TripEvent.empty,
        day = day,
        isLoading = isLoading ?? true,
        error = error ?? false;

  final TripEvent tripEvent;
  final DateTime? day;
  final bool isLoading;
  final bool error;

  CreateEventState copyWith({
    TripEvent? tripEvent,
    DateTime? day,
    bool? isLoading,
    bool? error,
  }) {
    return CreateEventState(
      tripEvent: tripEvent ?? this.tripEvent,
      day: day ?? this.day,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [tripEvent, day, isLoading, error];

  @override
  String toString() => 'TripsState { tripEvent: $tripEvent, day: $day, '
      'isLoading: $isLoading, error: $error }';
}
