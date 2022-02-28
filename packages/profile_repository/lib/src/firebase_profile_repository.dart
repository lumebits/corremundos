import 'dart:async';
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
  Future<Profile> getProfileByEmail(String email) {
    return collection
        .where('email', isEqualTo: email)
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
  Future<void> deleteFile(String uid, String fileName) async {
    collection.where('uid', isEqualTo: uid).get().then((value) {
      for (final element in value.docs) {
        final profile = collection.doc(element.id);
        profile.update(<String, dynamic>{
          'documents': FieldValue.arrayRemove(<dynamic>[fileName])
        });
        FirebaseStorage.instance.refFromURL(fileName).delete();
      }
    });
  }

  @override
  Future<void> deleteProfile(String uid) async {
    _deleteAllFiles(uid);
    return collection.where('uid', isEqualTo: uid).get().then((value) {
      for (var element in value.docs) {
        collection.doc(element.id).delete();
      }
    });
  }

  Future<void> _deleteAllFiles(String uid) async {
    FirebaseStorage.instance.ref().child('/$uid').listAll().then((files) {
      for (final f in files.items) {
        f.delete();
      }
    });
  }
}
