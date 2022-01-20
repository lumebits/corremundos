import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trips_repository/src/entities/entities.dart';
import 'package:uuid/uuid.dart';

import '../../trips_repository.dart';

@immutable
class Trip extends Equatable {
  Trip({
    required this.uid,
    required this.name,
    String? id,
    DateTime? initDate,
    DateTime? endDate,
    String? imageUrl,
    List<dynamic>? accommodations,
    List<dynamic>? activities,
    List<dynamic>? transportations,
    List<dynamic>? sharedWith,
    Map<int, List<TripEvent>>? eventMap,
  })  : id = id ?? const Uuid().v4(),
        initDate = initDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now(),
        imageUrl = imageUrl ?? '',
        accommodations = accommodations ?? <dynamic>[],
        activities = activities ?? <dynamic>[],
        transportations = transportations ?? <dynamic>[],
        sharedWith = sharedWith ?? <dynamic>[],
        eventMap = eventMap ?? {};

  Trip.fromEntity(TripEntity entity)
      : id = entity.id,
        uid = entity.uid,
        name = entity.name,
        initDate = entity.initDate!,
        endDate = entity.endDate!,
        imageUrl = entity.imageUrl!,
        accommodations = entity.accommodations!,
        activities = entity.activities!,
        transportations = entity.transportations!,
        sharedWith = entity.sharedWith!,
        eventMap = createEventMap(entity);

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
  final Map<int, List<TripEvent>> eventMap;

  static Trip empty = Trip(uid: '', name: '');

  bool get isEmpty => this == Trip.empty;

  bool get isNotEmpty => this != Trip.empty;

  int get duration => daysBetween(initDate, endDate) + 1;

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
        eventMap,
      ];

  Trip refreshEventMap() {
    return this.copyWith(eventMap: createEventMap(this.toEntity()));
  }

  Trip copyWith(
      {String? uid,
      String? name,
      DateTime? initDate,
      DateTime? endDate,
      String? imageUrl,
      List<dynamic>? accommodations,
      List<dynamic>? activities,
      List<dynamic>? transportations,
      List<dynamic>? sharedWith,
      Map<int, List<TripEvent>>? eventMap}) {
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
      sharedWith: sharedWith ?? this.sharedWith,
      eventMap: eventMap ?? this.eventMap,
    );
  }

  @override
  String toString() {
    return 'Trip '
        '{ uid: $uid, id: $id, name: $name, initDate: $initDate, '
        'endDate: $endDate, imageUrl: $imageUrl, '
        'accommodations: $accommodations, activities: $activities, '
        'transportations: $transportations, sharedWith: $sharedWith,'
        'event: ${eventMap.length} }';
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

Map<int, List<TripEvent>> createEventMap(TripEntity entity) {
  var events = <int, List<TripEvent>>{};
  var dbIndex = 0;
  entity.accommodations!.forEach((dynamic a) {
    var checkin = a['checkin'] is Timestamp
        ? a['checkin'].toDate() as DateTime
        : a['checkin'] as DateTime;
    var checkout = a['checkout'] is Timestamp
        ? a['checkout'].toDate() as DateTime
        : a['checkout'] as DateTime;

    var checkinEvent = TripEvent(
        index: dbIndex,
        time: a['checkin'] is Timestamp
            ? a['checkin'].toDate() as DateTime
            : a['checkin'] as DateTime,
        isCheckIn: true,
        fileUrl: a['file'] as String,
        name: a['name'] as String,
        location: a['location'] as String,
        type: EventType.accommodation);
    var checkoutEvent = TripEvent(
        index: dbIndex,
        time: a['checkout'] is Timestamp
            ? a['checkout'].toDate() as DateTime
            : a['checkout'] as DateTime,
        isCheckIn: false,
        fileUrl: a['file'] as String,
        name: a['name'] as String,
        location: a['location'] as String,
        type: EventType.accommodation);

    var checkinIndex = daysBetween(entity.initDate!, checkin);
    var checkoutIndex = daysBetween(entity.initDate!, checkout);
    if (events.containsKey(checkinIndex)) {
      events[checkinIndex]!.add(checkinEvent);
    } else {
      events[checkinIndex] = [checkinEvent];
    }
    if (events.containsKey(checkoutIndex)) {
      events[checkoutIndex]!.add(checkoutEvent);
    } else {
      events[checkoutIndex] = [checkoutEvent];
    }
    dbIndex++;
  });

  dbIndex = 0;
  entity.transportations!.forEach((dynamic t) {
    var event = TripEvent(
        index: dbIndex,
        time: t['departureTime'] is Timestamp
            ? t['departureTime'].toDate() as DateTime
            : t['departureTime'] as DateTime,
        endTime: t['arrivalTime'] is Timestamp
            ? t['arrivalTime'].toDate() as DateTime
            : t['arrivalTime'] as DateTime,
        fileUrl: t['file'] as String,
        name: t['location'] as String,
        location: t['notes'] as String,
        type: EventType.transport);
    var index = daysBetween(entity.initDate!, event.time);
    if (events.containsKey(index)) {
      events[index]!.add(event);
    } else {
      events[index] = [event];
    }
    dbIndex++;
  });

  dbIndex = 0;
  entity.activities!.forEach((dynamic t) {
    var time = t['time'] is Timestamp
        ? t['time'].toDate() as DateTime
        : t['time'] as DateTime;
    var event = TripEvent(
        index: dbIndex,
        time: time,
        fileUrl: t['file'] as String,
        name: t['name'] as String,
        location: t['location'] as String,
        type: EventType.activity);
    var index = daysBetween(entity.initDate!, time);
    if (events.containsKey(index)) {
      events[index]!.add(event);
    } else {
      events[index] = [event];
    }
    dbIndex++;
  });
  events.forEach((key, value) {
    events[key]!.sort((a, b) => a.time.compareTo(b.time));
  });
  return events;
}

int daysBetween(DateTime from, DateTime to) {
  return (DateTime(to.year, to.month, to.day)
              .difference(DateTime(from.year, from.month, from.day))
              .inHours /
          24)
      .round();
}
