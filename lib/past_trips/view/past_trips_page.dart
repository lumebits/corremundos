import 'package:corremundos/past_trips/view/past_trips_form.dart';
import 'package:flutter/material.dart';

class PastTripsPage extends StatelessWidget {
  const PastTripsPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: PastTripsPage());

  @override
  Widget build(BuildContext context) {
    return const PastTripsForm();
  }
}
