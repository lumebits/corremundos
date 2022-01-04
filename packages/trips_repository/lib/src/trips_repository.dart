import 'dart:async';

import 'package:trips_repository/trips_repository.dart';

abstract class TripsRepository {

  Future<void> updateOrCreateTrip(Trip trip, String uid);

  Future<Trip> getCurrentTrip(String uid);

  Stream<List<Trip>> getMyTrips(String uid);

  Stream<List<Trip>> getSharedWithMeTrips(String uid);

}
