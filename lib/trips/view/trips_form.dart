import 'dart:developer';

import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TripsForm extends BasePage {
  const TripsForm({Key? key}) : super(key, appTab: AppTab.trips);

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Future<bool> onWillPop(BuildContext context) => Future.value(false);

  @override
  bool avoidBottomInset() => false;

  @override
  Widget? floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        /*Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (context) => const AddTripPage(),
        ),);*/
        log('add new trip');
      },
      elevation: 2,
      child: const Icon(Icons.add_rounded),
    );
  }

  @override
  Widget widget(BuildContext context) {
    return Center(
      child: Text('1', style: Theme.of(context).textTheme.headline1),
    );
  }
}
