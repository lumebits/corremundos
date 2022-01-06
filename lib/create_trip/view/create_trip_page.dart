import 'package:corremundos/create_trip/view/create_trip_form.dart';
import 'package:flutter/material.dart';

class CreateTripPage extends StatelessWidget {
  const CreateTripPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: CreateTripPage());

  @override
  Widget build(BuildContext context) {
    return const CreateTripForm();
  }
}
