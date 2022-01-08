import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trips_repository/src/entities/entities.dart';
import 'package:trips_repository/trips_repository.dart';

class FirebaseTripsRepository implements TripsRepository {
  final collection = FirebaseFirestore.instance.collection('trips');

  @override
  Future<void> updateOrCreateTrip(Trip trip, String uid) {
    if (trip.uid.isNotEmpty) {
      return collection.doc(trip.id).update(trip.toEntity().toDocument());
    } else {
      return collection
          .doc(trip.id)
          .set((trip.copyWith(uid: uid).toEntity().toDocument()));
    }
  }

  @override
  Future<Trip> getCurrentTrip(String uid) {
    return collection
        .where('uid', isEqualTo: uid)
        .where('endDate', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('endDate')
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
  Future<Trip> getTripById(String uid, String id) {
    return collection
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .orderBy('endDate')
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
    return collection
        .where('uid', isEqualTo: uid)
        .where('endDate', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map((snapshot) {
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
        .where('endDate', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Trip.fromEntity(TripEntity.fromSnapshot(doc)),
          )
          .toList();
    });
  }

  @override
  Future<String?> uploadFileToStorage(Uint8List uint8list, String name) async {
    String fileName = getRandomString(15) + name;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('/$fileName');

    return firebaseStorageRef
        .putData(uint8list)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL().then((value) {
              print("Done: $value");
              return value;
            }));
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
