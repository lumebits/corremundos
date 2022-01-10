import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  @override
  Future<void> updateOrCreateProfile(Profile profile, String uid) {
    if (profile.name != '' || profile.documents!.isNotEmpty) {
      return collection.doc(profile.id).update(profile.toEntity().toDocument());
    } else {
      return collection
          .doc(profile.id)
          .set((profile.copyWith(uid: uid).toEntity().toDocument()));
    }
  }

  @override
  Future<String?> uploadFileToStorage(Uint8List uint8list, String name) {
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

  @override
  Future<void> deleteProfile(String uid) async {
    return collection
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        collection.doc(element.id).delete();
      }
    });
  }

}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

