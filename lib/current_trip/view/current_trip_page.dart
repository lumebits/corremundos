import 'package:corremundos/current_trip/view/current_trip_form.dart';
import 'package:flutter/material.dart';

class CurrentTripPage extends StatelessWidget {
  const CurrentTripPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: CurrentTripPage());

  @override
  Widget build(BuildContext context) {
    return const CurrentTripForm();
  }
}
