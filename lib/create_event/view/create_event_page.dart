import 'package:auth_repository/auth_repository.dart';
import 'package:corremundos/create_event/cubit/create_event_cubit.dart';
import 'package:corremundos/create_event/view/create_event_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage(
    this.trip,
    this.day,
    this.eventType, {
    this.tripEvent,
    Key? key,
  }) : super(key: key);

  final Trip trip;
  final DateTime day;
  final EventType eventType;
  final TripEvent? tripEvent;

  static Page page(Trip trip, DateTime day, EventType eventType) =>
      MaterialPage<void>(
        child: CreateEventPage(trip, day, eventType),
      );

  @override
  Widget build(BuildContext context) {
    if (tripEvent != null) {
      return BlocProvider(
        create: (context) =>
            CreateEventCubit(FirebaseTripsRepository(), AuthRepository(), trip)
              ..loadEventToEdit(tripEvent!, day),
        child: CreateEventForm(trip, day, eventType),
      );
    }
    return BlocProvider(
      create: (context) =>
          CreateEventCubit(FirebaseTripsRepository(), AuthRepository(), trip),
      child: CreateEventForm(trip, day, eventType),
    );
  }
}
