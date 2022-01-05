part of 'trips_cubit.dart';

class TripsState extends Equatable {
  // TODO: add list of "activities" with hour, file, location, notes and type (trans, accom, attrac) for selected current day index, order by hour asc
  // this new field will be shown
  TripsState({
    List<Trip>? myTrips,
    List<Trip>? sharedWithMeTrips,
    Trip? currentTrip,
    int? currentDayIndex,
    int? tripDays,
    bool? isLoading,
    bool? error,
  })  : myTrips = myTrips ?? List.empty(),
        sharedWithMeTrips = sharedWithMeTrips ?? List.empty(),
        currentTrip = currentTrip ?? Trip.empty,
        currentDayIndex = currentDayIndex ?? 0,
        tripDays = tripDays ?? 0,
        isLoading = isLoading ?? true,
        error = error ?? false;

  final List<Trip> myTrips;
  final List<Trip> sharedWithMeTrips;
  final Trip currentTrip;
  final int currentDayIndex;
  final int tripDays;
  final bool isLoading;
  final bool error;

  TripsState copyWith({
    List<Trip>? myTrips,
    List<Trip>? sharedWithMeTrips,
    Trip? currentTrip,
    int? currentDayIndex,
    int? tripDays,
    bool? isLoading,
    bool? error,
  }) {
    return TripsState(
      myTrips: myTrips ?? this.myTrips,
      sharedWithMeTrips: sharedWithMeTrips ?? this.sharedWithMeTrips,
      currentTrip: currentTrip ?? this.currentTrip,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      tripDays: tripDays ?? this.tripDays,
      isLoading: isLoading ?? this.isLoading,
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
        isLoading,
        error
      ];

  @override
  String toString() => 'TripsState { myTrips: ${myTrips.length}, '
      'sharedWithMeTrips: ${sharedWithMeTrips.length}, '
      'currentTrip: $currentTrip, currentDayIndex: $currentDayIndex, '
      'tripDays: $tripDays, isLoading: $isLoading, error: $error }';
}
