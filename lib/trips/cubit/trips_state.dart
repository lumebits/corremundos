part of 'trips_cubit.dart';

class TripsState extends Equatable {
  TripsState({
    List<Trip>? myTrips,
    List<Trip>? sharedWithMeTrips,
    Trip? currentTrip,
    int? currentDayIndex,
    int? tripDays,
    Map<int, List<TripEvent>>? events,
    bool? isLoading,
    bool? isLoadingShared,
    bool? isLoadingCurrent,
    bool? error,
  })  : myTrips = myTrips ?? List.empty(),
        sharedWithMeTrips = sharedWithMeTrips ?? List.empty(),
        currentTrip = currentTrip ?? Trip.empty,
        currentDayIndex = currentDayIndex ?? 0,
        tripDays = tripDays ?? 0,
        events = events ?? {},
        isLoading = isLoading ?? true,
        isLoadingShared = isLoadingShared ?? true,
        isLoadingCurrent = isLoadingCurrent ?? true,
        error = error ?? false;

  final List<Trip> myTrips;
  final List<Trip> sharedWithMeTrips;
  final Trip currentTrip;
  final int currentDayIndex;
  final int tripDays;
  final Map<int, List<TripEvent>> events;
  final bool isLoading;
  final bool isLoadingShared;
  final bool isLoadingCurrent;
  final bool error;

  TripsState copyWith({
    List<Trip>? myTrips,
    List<Trip>? sharedWithMeTrips,
    Trip? currentTrip,
    int? currentDayIndex,
    int? tripDays,
    Map<int, List<TripEvent>>? events,
    bool? isLoading,
    bool? isLoadingShared,
    bool? isLoadingCurrent,
    bool? error,
  }) {
    return TripsState(
      myTrips: myTrips ?? this.myTrips,
      sharedWithMeTrips: sharedWithMeTrips ?? this.sharedWithMeTrips,
      currentTrip: currentTrip ?? this.currentTrip,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      tripDays: tripDays ?? this.tripDays,
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      isLoadingShared: isLoadingShared ?? this.isLoadingShared,
      isLoadingCurrent: isLoadingCurrent ?? this.isLoadingCurrent,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        myTrips,
        sharedWithMeTrips,
        currentTrip,
        currentDayIndex,
        tripDays,
        events,
        isLoading,
        isLoadingShared,
        isLoadingCurrent,
        error
      ];

  @override
  String toString() => 'TripsState { myTrips: ${myTrips.length}, '
      'sharedWithMeTrips: ${sharedWithMeTrips.length}, '
      'currentTrip: $currentTrip, currentDayIndex: $currentDayIndex, '
      'tripDays: $tripDays, events: ${events.length}, isLoading: $isLoading, '
      'isLoadingShared: $isLoadingShared, isLoadingCurrent: $isLoadingCurrent, '
      'error: $error }';
}
