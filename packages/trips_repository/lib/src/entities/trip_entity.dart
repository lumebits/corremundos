import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class TripEntity extends Equatable {
  const TripEntity(
      {required this.id,
        required this.uid,
        required this.name,
        this.initDate,
        this.endDate,
        this.imageUrl,
        this.accommodations,
        this.activities,
        this.transportations,
        this.sharedWith,});

  TripEntity.fromJson(Map<String, Object> json)
      : id = json['id']! as String,
        uid = json['uid']! as String,
        name = json['name']! as String,
        initDate = json['initDate'] as DateTime?,
        endDate = json['endDate'] as DateTime?,
        imageUrl = json['imageUrl'] as String?,
        accommodations = json['accommodations'] as List<dynamic>?,
        activities = json['activities'] as List<dynamic>?,
        transportations = json['transportations'] as List<dynamic>?,
        sharedWith = json['sharedWith'] as List<dynamic>?;

  final String id;
  final String uid;
  final String name;
  final DateTime? initDate;
  final DateTime? endDate;
  final String? imageUrl;
  final List<dynamic>? accommodations;
  final List<dynamic>? activities;
  final List<dynamic>? transportations;
  final List<dynamic>? sharedWith;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'initDate': initDate,
      'endDate': endDate,
      'imageUrl': imageUrl,
      'accommodations': accommodations,
      'activities': activities,
      'transportations': transportations,
      'sharedWith': sharedWith,
    };
  }

  @override
  List<Object?> get props => [
    id,
    uid,
    name,
    initDate,
    endDate,
    imageUrl,
    accommodations,
    activities,
    transportations,
    sharedWith
  ];

  @override
  String toString() {
    return 'TripEntity '
        '{ uid: $uid, id: $id, name: $name, initDate: $initDate, '
        'endDate: $endDate, imageUrl: $imageUrl, '
        'accommodations: $accommodations, activities: $activities, '
        'transportations: $transportations, sharedWith: $sharedWith }';
  }

  static TripEntity fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data();
    if (data == null) throw Exception();
    final initDate = data['initDate'] as Timestamp;
    final endDate = data['endDate'] as Timestamp;
    return TripEntity(
      id: snap.id,
      uid: data['uid'] as String,
      name: data['name'] as String,
      initDate: initDate.toDate(),
      endDate: endDate.toDate(),
      imageUrl: data['imageUrl'] as String,
      accommodations: data['accommodations'] as List<dynamic>,
      activities: data['activities'] as List<dynamic>,
      transportations: data['transportations'] as List<dynamic>,
      sharedWith: data['sharedWith'] as List<dynamic>,
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'initDate': initDate,
      'endDate': endDate,
      'imageUrl': imageUrl,
      'accommodations': accommodations,
      'activities': activities,
      'transportations': transportations,
      'sharedWith': sharedWith,
    };
  }
}
