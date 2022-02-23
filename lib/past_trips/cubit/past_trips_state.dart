part of 'past_trips_cubit.dart';

class PastTripsState extends Equatable {
  PastTripsState({
    List<Trip>? pastTrips,
    List<Trip>? sharedWithMePastTrips,
    bool? isLoading,
    bool? isLoadingShared,
    bool? error,
  })  : pastTrips = pastTrips ?? List.empty(),
        sharedWithMePastTrips = sharedWithMePastTrips ?? List.empty(),
        isLoading = isLoading ?? true,
        isLoadingShared = isLoadingShared ?? true,
        error = error ?? false;

  final List<Trip> pastTrips;
  final List<Trip> sharedWithMePastTrips;
  final bool isLoading;
  final bool isLoadingShared;
  final bool error;

  PastTripsState copyWith({
    List<Trip>? pastTrips,
    List<Trip>? sharedWithMePastTrips,
    bool? isLoading,
    bool? isLoadingShared,
    bool? error,
  }) {
    return PastTripsState(
      pastTrips: pastTrips ?? this.pastTrips,
      sharedWithMePastTrips:
          sharedWithMePastTrips ?? this.sharedWithMePastTrips,
      isLoading: isLoading ?? this.isLoading,
      isLoadingShared: isLoadingShared ?? this.isLoadingShared,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [pastTrips, sharedWithMePastTrips, isLoading, isLoadingShared, error];

  @override
  String toString() => 'PastTripsState { pastTrips: ${pastTrips.length}, '
      'sharedWithMePastTrips: ${sharedWithMePastTrips.length}, '
      'isLoading: $isLoading, isLoadingShared: $isLoadingShared, '
      'error: $error }';
}
