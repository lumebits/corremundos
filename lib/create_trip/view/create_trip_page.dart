import 'package:auth_repository/auth_repository.dart';
import 'package:corremundos/create_trip/cubit/create_trip_cubit.dart';
import 'package:corremundos/create_trip/view/create_trip_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

class CreateTripPage extends StatelessWidget {
  const CreateTripPage({this.trip, Key? key}) : super(key: key);

  final Trip? trip;

  static Page page() => const MaterialPage<void>(child: CreateTripPage());

  @override
  Widget build(BuildContext context) {
    if (trip != null) {
      return BlocProvider(
        create: (context) =>
            CreateTripCubit(FirebaseTripsRepository(), AuthRepository())
              ..loadTripToEdit(trip!),
        child: const CreateTripForm(),
      );
    }

    return BlocProvider(
      create: (context) =>
          CreateTripCubit(FirebaseTripsRepository(), AuthRepository()),
      child: const CreateTripForm(),
    );
  }
}
