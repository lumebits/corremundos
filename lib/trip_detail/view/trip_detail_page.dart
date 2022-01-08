import 'package:corremundos/trip_detail/cubit/trip_detail_cubit.dart';
import 'package:corremundos/trip_detail/view/trip_detail_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

class TripDetailPage extends StatelessWidget {
  const TripDetailPage(this.trip, {Key? key}) : super(key: key);

  final Trip trip;

  static Page page(Trip trip) => MaterialPage<void>(child: TripDetailPage(trip));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TripDetailCubit(trip),
      child: const TripDetailForm(),
    );
  }
}
