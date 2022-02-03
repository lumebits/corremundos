import 'dart:async';
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
      return collection.doc(trip.id).update(<String, dynamic>{
        'name': trip.name,
        'initDate': trip.initDate,
        'endDate': trip.endDate,
        'imageUrl': trip.imageUrl
      });
    } else {
      return collection
          .doc(trip.id)
          .set((trip.copyWith(uid: uid).toEntity().toDocument()));
    }
  }

  @override
  Future<void> addEvents(Trip trip, String uid) {
    if (trip.uid.isNotEmpty) {
      return collection.doc(trip.id).update(<String, dynamic>{
        'transportations': trip.transportations,
        'accommodations': trip.accommodations,
        'activities': trip.activities
      });
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
  Future<String?> uploadFileToStorage(
      Uint8List uint8list, String name, String uid) async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('/$uid').child(name);

    return firebaseStorageRef
        .putData(uint8list)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL().then((value) {
              print("Done: $value");
              return value;
            }))
        .onError((error, stackTrace) {
      print(error);
      return '';
    });
  }

  @override
  Future<void> deleteTrips(String uid) async {
    getMyTrips(uid).forEach((elements) {
      for (var trip in elements) {
        deleteTrip(trip, uid);
      }
    });
  }

  @override
  Future<void> deleteTrip(Trip trip, String uid) async {
    if (trip.uid == uid) {
      // TODO: delete file inside uid folder
      trip.transportations.forEach((dynamic element) {
        final file = (element['file'] as String);
        if (file.isNotEmpty) FirebaseStorage.instance.refFromURL(file).delete();
      });
      trip.activities.forEach((dynamic element) {
        final file = (element['file'] as String);
        if (file.isNotEmpty) FirebaseStorage.instance.refFromURL(file).delete();
      });
      trip.accommodations.forEach((dynamic element) {
        final file = (element['file'] as String);
        if (file.isNotEmpty) FirebaseStorage.instance.refFromURL(file).delete();
      });
      return collection.where('id', isEqualTo: trip.id).get().then((value) {
        for (final element in value.docs) {
          collection.doc(element.id).delete();
        }
      });
    } else {
      return collection.doc(trip.id).update(<String, dynamic>{
        'sharedWith': FieldValue.arrayRemove(<dynamic>[uid]),
      });
    }
  }

  @override
  Future<void> shareTrip(String tripId, String uid) async {
    final sharedWith = [uid];
    return collection.doc(tripId).update(<String, dynamic>{
      'sharedWith': FieldValue.arrayUnion(sharedWith),
    });
  }

  @override
  Future<void> deleteTripEvent(String tripId, TripEvent tripEvent) async {
    return collection.where('id', isEqualTo: tripId).get().then((value) {
      // TODO: delete file inside uid folder
      for (final element in value.docs) {
        final trip = collection.doc(element.id);
        switch (tripEvent.type) {
          case EventType.accommodation:
            trip.update(<String, dynamic>{
              'accommodations': FieldValue.arrayRemove(
                  <dynamic>[tripEventToAccommodation(tripEvent)])
            });
            if (tripEvent.fileUrl.isNotEmpty)
              FirebaseStorage.instance.refFromURL(tripEvent.fileUrl).delete();
            break;
          case EventType.activity:
            trip.update(<String, dynamic>{
              'activities': FieldValue.arrayRemove(
                  <dynamic>[tripEventToActivity(tripEvent)])
            });
            if (tripEvent.fileUrl.isNotEmpty)
              FirebaseStorage.instance.refFromURL(tripEvent.fileUrl).delete();
            break;
          case EventType.transport:
            trip.update(<String, dynamic>{
              'transportations': FieldValue.arrayRemove(
                  <dynamic>[tripEventToTransportation(tripEvent)])
            });
            if (tripEvent.fileUrl.isNotEmpty)
              FirebaseStorage.instance.refFromURL(tripEvent.fileUrl).delete();
            break;
          default:
            throw Exception('unknown event type');
        }
      }
    });
  }
}

dynamic tripEventToAccommodation(TripEvent tripEvent) {
  return {
    'name': tripEvent.name,
    'location': tripEvent.location,
    'checkin': tripEvent.time,
    'checkout': tripEvent.endTime,
    'file': tripEvent.fileUrl,
  };
}

dynamic tripEventToActivity(TripEvent tripEvent) {
  return {
    'name': tripEvent.name,
    'location': tripEvent.location,
    'time': tripEvent.time,
    'file': tripEvent.fileUrl,
  };
}

dynamic tripEventToTransportation(TripEvent tripEvent) {
  return {
    'notes': tripEvent.location,
    'location': tripEvent.name,
    'departureTime': tripEvent.time,
    'arrivalTime': tripEvent.endTime,
    'file': tripEvent.fileUrl,
  };
}
