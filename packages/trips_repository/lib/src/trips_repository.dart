import 'dart:async';
import 'dart:typed_data';

import 'package:trips_repository/trips_repository.dart';

abstract class TripsRepository {
  Future<void> updateOrCreateTrip(Trip trip, String uid);

  Future<void> addEvents(Trip trip, String uid);

  Future<Trip> getCurrentTrip(String uid);

  Future<Trip> getTripById(String uid, String id);

  Stream<List<Trip>> getMyTrips(String uid);

  Stream<List<Trip>> getPastTrips(String uid);

  Stream<List<Trip>> getSharedWithMeTrips(String uid);

  Stream<List<Trip>> getSharedWithMePastTrips(String uid);

  Future<String?> uploadFileToStorage(Uint8List uint8list, String name, String uid);

  Future<void> deleteTrips(String uid);

  Future<void> deleteTrip(Trip trip, String uid);

  Future<void> shareTrip(String tripId, String uid);

  Future<void> deleteTripEvent(String tripId, TripEvent tripEvent);
}
