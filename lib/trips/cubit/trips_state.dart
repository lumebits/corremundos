part of 'trips_cubit.dart';

class TripsState extends Equatable {
  TripsState({
    List<Trip>? myTrips,
    List<Trip>? sharedWithMeTrips,
    Trip? currentTrip,
    bool? isLoading,
    bool? error,
  })  : myTrips = myTrips ?? List.empty(),
        sharedWithMeTrips = sharedWithMeTrips ?? List.empty(),
        currentTrip = currentTrip ?? Trip.empty,
        isLoading = isLoading ?? true,
        error = error ?? false;

  final List<Trip> myTrips;
  final List<Trip> sharedWithMeTrips;
  final Trip currentTrip;
  final bool isLoading;
  final bool error;

  TripsState copyWith({
    List<Trip>? myTrips,
    List<Trip>? sharedWithMeTrips,
    Trip? currentTrip,
    bool? isLoading,
    bool? error,
  }) {
    return TripsState(
      myTrips: myTrips ?? this.myTrips,
      sharedWithMeTrips: sharedWithMeTrips ?? this.sharedWithMeTrips,
      currentTrip: currentTrip ?? this.currentTrip,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props =>
      [myTrips, sharedWithMeTrips, currentTrip, isLoading, error];

  @override
  String toString() => 'TripsState { myTrips: ${myTrips.length}, '
      'sharedWithMeTrips: ${sharedWithMeTrips.length}, '
      'currentTrip: $currentTrip, isLoading: $isLoading, '
      'error: $error }';
}
