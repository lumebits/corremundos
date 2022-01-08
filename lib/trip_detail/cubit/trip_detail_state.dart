part of 'trip_detail_cubit.dart';

class TripDetailState extends Equatable {
  const TripDetailState(this.trip, this.dayIndex);

  final Trip trip;
  final int dayIndex;

  TripDetailState copyWith({
    int? dayIndex,
  }) {
    return TripDetailState(
      trip,
      dayIndex ?? this.dayIndex,
    );
  }

  @override
  List<Object?> get props => [trip, dayIndex];

  @override
  String toString() => 'TripDetailState { trip: $trip, dayIndex: $dayIndex }';
}
