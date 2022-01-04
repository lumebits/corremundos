import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trips_repository/src/entities/entities.dart';
import 'package:uuid/uuid.dart';

@immutable
class Trip extends Equatable {
  Trip(
      {required this.uid,
        required this.name,
        String? id,
        DateTime? initDate,
        DateTime? endDate,
        String? imageUrl,
        List<dynamic>? accommodations,
        List<dynamic>? activities,
        List<dynamic>? transportations,
        List<dynamic>? sharedWith,})
      : id = id ?? const Uuid().v4(),
        initDate = initDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now(),
        imageUrl = imageUrl ?? '',
        accommodations = accommodations ?? <dynamic>[],
        activities = activities ?? <dynamic>[],
        transportations = transportations ?? <dynamic>[],
        sharedWith = sharedWith ?? <dynamic>[];

  Trip.fromEntity(TripEntity entity) : id = entity.id,
        uid = entity.uid,
        name = entity.name,
        initDate = entity.initDate!,
        endDate = entity.endDate!,
        imageUrl = entity.imageUrl!,
        accommodations = entity.accommodations!,
        activities = entity.activities!,
        transportations = entity.transportations!,
        sharedWith = entity.sharedWith!;

  final String id;
  final String uid;
  final String name;
  final DateTime initDate;
  final DateTime endDate;
  final String imageUrl;
  final List<dynamic> accommodations;
  final List<dynamic> activities;
  final List<dynamic> transportations;
  final List<dynamic> sharedWith;

  static Trip empty = Trip(uid: '', name: '');

  bool get isEmpty => this == Trip.empty;

  bool get isNotEmpty => this != Trip.empty;

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
    sharedWith,
  ];

  Trip copyWith(
      {String? uid,
        String? name,
        DateTime? initDate,
        DateTime? endDate,
        String? imageUrl,
        List<dynamic>? accommodations,
        List<dynamic>? activities,
        List<dynamic>? transportations,
        List<dynamic>? sharedWith,}) {
    return Trip(
      id: id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      initDate: initDate ?? this.initDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
      accommodations: accommodations ?? this.accommodations,
      activities: activities ?? this.activities,
      transportations: transportations ?? this.transportations,
      sharedWith: sharedWith ?? this.sharedWith,);
  }

  @override
  String toString() {
    return 'Trip '
        '{ uid: $uid, id: $id, name: $name, initDate: $initDate, '
        'endDate: $endDate, imageUrl: $imageUrl, '
        'accommodations: $accommodations, activities: $activities, '
        'transportations: $transportations, sharedWith: $sharedWith }';
  }

  TripEntity toEntity() {
    return TripEntity(
      id: id,
      uid: uid,
      name: name,
      initDate: initDate,
      endDate: endDate,
      imageUrl: imageUrl,
      accommodations: accommodations,
      activities: activities,
      transportations: transportations,
      sharedWith: sharedWith,
    );
  }

}
