import 'package:corremundos/calendar/view/calendar_form.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: CalendarPage());

  @override
  Widget build(BuildContext context) {
    return const CalendarForm();
  }
}
