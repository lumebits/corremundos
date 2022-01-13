import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum EventType { transport, accommodation, activity }

@immutable
class TripEvent extends Equatable {
  TripEvent(
      {
        DateTime? time,
        this.endTime,
        this.isCheckIn,
        String? fileUrl,
        String? name,
        String? location,
        EventType? type,})
      : time = time ?? DateTime.now(),
        fileUrl = fileUrl ?? '',
        name = name ?? '',
        location = location ?? '',
        type = type ?? EventType.activity;

  final DateTime time;
  final DateTime? endTime;
  final bool? isCheckIn;
  final String fileUrl;
  final String name;
  final String location;
  final EventType type;

  static TripEvent empty = TripEvent();

  bool get isEmpty => this == TripEvent.empty;

  bool get isNotEmpty => this != TripEvent.empty;

  @override
  List<Object?> get props => [
    time,
    endTime,
    isCheckIn,
    fileUrl,
    name,
    location,
    type,
  ];

  TripEvent copyWith(
      {
        DateTime? time,
        DateTime? endTime,
        bool? isCheckIn,
        String? fileUrl,
        String? name,
        String? location,
        EventType? type,
      }) {
    return TripEvent(
      time: time ?? this.time,
      endTime: endTime ?? this.endTime,
      isCheckIn: isCheckIn ?? this.isCheckIn,
      fileUrl: fileUrl ?? this.fileUrl,
      name: name ?? this.name,
      location: location ?? this.location,
      type: type ?? this.type,);
  }

  @override
  String toString() {
    return 'Event '
        '{ time: $time, endTime: $endTime, isCheckIn: $isCheckIn, '
        'fileUrl: $fileUrl, name: $name, location: $location, '
        'type: $type }';
  }

}
