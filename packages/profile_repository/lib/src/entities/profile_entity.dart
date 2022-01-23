import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.uid,
    this.name,
    this.email,
    this.documents,
  });

  ProfileEntity.fromJson(Map<String, Object> json)
      : id = json['id']! as String,
        uid = json['uid']! as String,
        name = json['name']! as String,
        email = json['email']! as String,
        documents = json['documents'] as List<dynamic>?;

  final String id;
  final String uid;
  final String? name;
  final String? email;
  final List<dynamic>? documents;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'email': email,
      'documents': documents,
    };
  }

  @override
  List<Object?> get props => [
        id,
        uid,
        name,
        email,
        documents,
      ];

  @override
  String toString() {
    return 'ProfileEntity '
        '{ uid: $uid, id: $id, name: $name, email: $email, '
        'documents: $documents }';
  }

  static ProfileEntity fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data();
    if (data == null) throw Exception();
    return ProfileEntity(
      id: snap.id,
      uid: data['uid'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      documents: data['documents'] as List<dynamic>,
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'documents': documents,
    };
  }
}
