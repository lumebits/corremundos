import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trips_repository/src/entities/entities.dart';
import 'package:trips_repository/trips_repository.dart';

class FirebaseTripsRepository implements TripsRepository {
  final collection = FirebaseFirestore.instance.collection('trips');

  @override
  Future<void> updateOrCreateTrip(Trip trip, String uid) {
    throw UnimplementedError();
  }

  @override
  Future<Trip> getCurrentTrip(String uid) {
    return collection
        .where('uid', isEqualTo: uid)
        .orderBy('initDate', descending: true)
        .limit(1)
        .snapshots()
        .first
        .asStream()
        .map(
          (snapshot) => Trip.fromEntity(
            TripEntity.fromSnapshot(snapshot.docs.first),
          ),
        )
        .first
        .onError((error, stackTrace) {
      return Future.value(Trip.empty);
    });
  }

  @override
  Stream<List<Trip>> getMyTrips(String uid) {
    return collection.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Trip.fromEntity(TripEntity.fromSnapshot(doc)),
          )
          .toList();
    });
  }

  @override
  Stream<List<Trip>> getSharedWithMeTrips(String uid) {
    return collection
        .where('sharedWith', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Trip.fromEntity(TripEntity.fromSnapshot(doc)),
          )
          .toList();
    });
  }
}
