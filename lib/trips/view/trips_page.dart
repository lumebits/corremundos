import 'package:corremundos/trips/view/trips_form.dart';
import 'package:flutter/material.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: TripsPage());

  @override
  Widget build(BuildContext context) {
    return const TripsForm();
  }
}
