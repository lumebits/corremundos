import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../profile_repository.dart';
import 'entities/entities.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final collection = FirebaseFirestore.instance.collection('profiles');

  @override
  Future<Profile> getProfile(String uid) {
    return collection
        .where('uid', isEqualTo: uid)
        .limit(1)
        .snapshots()
        .first
        .asStream()
        .map(
          (snapshot) => Profile.fromEntity(
            ProfileEntity.fromSnapshot(snapshot.docs.first),
          ),
        )
        .first
        .onError((error, stackTrace) {
      return Future.value(Profile.empty);
    });
  }

}
