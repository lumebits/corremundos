import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum EventType { transportation, accommodation, activity }

@immutable
class TripEvent extends Equatable {
  TripEvent(
      {
        DateTime? time,
        String? fileUrl,
        String? location,
        String? description,
        EventType? type,})
      : time = time ?? DateTime.now(),
        fileUrl = fileUrl ?? '',
        location = location ?? '',
        description = description ?? '',
        type = type ?? EventType.activity;

  final DateTime time;
  final String fileUrl;
  final String location;
  final String description;
  final EventType type;

  static TripEvent empty = TripEvent();

  bool get isEmpty => this == TripEvent.empty;

  bool get isNotEmpty => this != TripEvent.empty;

  @override
  List<Object?> get props => [
    time,
    fileUrl,
    location,
    description,
    type,
  ];

  TripEvent copyWith(
      {
        DateTime? time,
        String? fileUrl,
        String? location,
        String? description,
        EventType? type,
      }) {
    return TripEvent(
      time: time ?? this.time,
      fileUrl: fileUrl ?? this.fileUrl,
      location: location ?? this.location,
      description: description ?? this.description,
      type: type ?? this.type,);
  }

  @override
  String toString() {
    return 'Event '
        '{ time: $time, fileUrl: $fileUrl, location: $location, '
        'description: $description, type: $type }';
  }

}