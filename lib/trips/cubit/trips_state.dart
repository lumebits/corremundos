part of 'trips_cubit.dart';

class TripsState extends Equatable {
  TripsState({
    List<Trip>? myTrips,
    List<Trip>? sharedWithMeTrips,
    Trip? newTrip,
    Trip? currentTrip,
    int? currentDayIndex,
    int? tripDays,
    Map<int, List<TripEvent>>? events,
    bool? isLoading,
    bool? error,
  })  : myTrips = myTrips ?? List.empty(),
        sharedWithMeTrips = sharedWithMeTrips ?? List.empty(),
        newTrip = newTrip ?? Trip.empty,
        currentTrip = currentTrip ?? Trip.empty,
        currentDayIndex = currentDayIndex ?? 0,
        tripDays = tripDays ?? 0,
        events = events ?? {},
        isLoading = isLoading ?? true,
        error = error ?? false;

  final List<Trip> myTrips;
  final List<Trip> sharedWithMeTrips;
  final Trip newTrip;
  final Trip currentTrip;
  final int currentDayIndex;
  final int tripDays;
  final Map<int, List<TripEvent>> events;
  final bool isLoading;
  final bool error;

  TripsState copyWith({
    List<Trip>? myTrips,
    List<Trip>? sharedWithMeTrips,
    Trip? newTrip,
    Trip? currentTrip,
    int? currentDayIndex,
    int? tripDays,
    Map<int, List<TripEvent>>? events,
    bool? isLoading,
    bool? error,
  }) {
    return TripsState(
      myTrips: myTrips ?? this.myTrips,
      sharedWithMeTrips: sharedWithMeTrips ?? this.sharedWithMeTrips,
      newTrip: newTrip ?? this.newTrip,
      currentTrip: currentTrip ?? this.currentTrip,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      tripDays: tripDays ?? this.tripDays,
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        myTrips,
        sharedWithMeTrips,
        newTrip,
        currentTrip,
        currentDayIndex,
        tripDays,
        events,
        isLoading,
        error
      ];

  @override
  String toString() => 'TripsState { myTrips: ${myTrips.length}, '
      'sharedWithMeTrips: ${sharedWithMeTrips.length}, newTrip: $newTrip, '
      'currentTrip: $currentTrip, currentDayIndex: $currentDayIndex, '
      'tripDays: $tripDays, events: ${events.length}, isLoading: $isLoading, '
      'error: $error }';
}
