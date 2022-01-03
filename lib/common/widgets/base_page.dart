import 'dart:developer';

import 'package:corremundos/common/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage(Key? key, {this.appTab}) : super(key: key);

  final AppTab? appTab;

  String title(BuildContext context) => 'Corremundos';

  Widget? bottomNavigationBar() =>
      appTab != null ? Navigation(activeTab: appTab!) : null;

  List<Widget>? actions(BuildContext context) => null;

  Widget? floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        /*Navigator.of(context).push<Route>(
          MaterialPageRoute(
            builder: (context) => const AddTripPage(),
          ),
        );*/
        log('add new trip');
      },
      elevation: 2,
      child: const Icon(Icons.add_rounded),
    );
  }

  List<BlocListener>? listeners(BuildContext context) => null;

  Widget widget(BuildContext context);

  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: Text(title(context)),
      actions: actions(context),
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
    );
  }

  Future<bool> onWillPop(BuildContext context) => Future.value(true);

  bool avoidBottomInset() => true;

  Widget scaffoldWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: appBar(context),
        //extendBody: true,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  widget(context),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: floatingActionButton(context),
        bottomNavigationBar: bottomNavigationBar(),
        resizeToAvoidBottomInset: avoidBottomInset(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = listeners(context);
    return list != null
        ? MultiBlocListener(listeners: list, child: scaffoldWidget(context))
        : scaffoldWidget(context);
  }
}
