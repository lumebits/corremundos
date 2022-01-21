import 'dart:async';
import 'dart:typed_data';

import 'package:trips_repository/trips_repository.dart';

abstract class TripsRepository {
  Future<void> updateOrCreateTrip(Trip trip, String uid);

  Future<void> addEvents(Trip trip, String uid);

  Future<Trip> getCurrentTrip(String uid);

  Future<Trip> getTripById(String uid, String id);

  Stream<List<Trip>> getMyTrips(String uid);

  Stream<List<Trip>> getSharedWithMeTrips(String uid);

  Future<String?> uploadFileToStorage(Uint8List uint8list, String name);

  Future<void> deleteTrips(String uid);

  Future<void> deleteTrip(String tripId);

  Future<void> deleteTripEvent(String tripId, TripEvent tripEvent);
}
