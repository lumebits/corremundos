import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trips_repository/trips_repository.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

String formatHour(DateTime time, int index) =>
    DateFormat('HH:mm').format(time.add(Duration(days: index)));

IconData iconByEventType(EventType eventType) {
  return eventType == EventType.transport
      ? Icons.airplanemode_active_rounded
      : eventType == EventType.accommodation
          ? Icons.hotel_rounded
          : Icons.local_activity_rounded;
}

String buildEventTimelineTimeText(
  EventType eventType,
  TripEvent event,
  int index,
) {
  return eventType == EventType.transport
      ? '${formatHour(event.time, index)} - '
          '${formatHour(event.endTime!, index)}'
      : eventType == EventType.accommodation
          ? event.isCheckIn!
              ? 'check-in ${formatHour(event.time, index)}'
              : 'check-out ${formatHour(event.time, index)}'
          : DateFormat('dd LLL HH:mm')
              .format(event.time.add(Duration(days: index)));
}
