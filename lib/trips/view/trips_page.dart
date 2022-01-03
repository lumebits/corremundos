import 'package:corremundos/trips/trips.dart';
import 'package:corremundos/trips/view/trips_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripsCubit(),
      child: const TripsForm(),
    );
  }
}
