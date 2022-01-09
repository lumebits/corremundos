import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/create_trip/view/create_trip_page.dart';
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
        Navigator.of(context).push<Route>(
          MaterialPageRoute(
            builder: (context) => const CreateTripPage(),
          ),
        );
      },
      elevation: 2,
      child: const Icon(Icons.add_rounded),
    );
  }

  List<BlocListener>? listeners(BuildContext context) => null;

  Widget widget(BuildContext context);

  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: Text(
        title(context),
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      actions: actions(context),
      elevation: 0,
      backgroundColor: Colors.white10,
      iconTheme: const IconThemeData(color: Colors.black54),
    );
  }

  Future<bool> onWillPop(BuildContext context) => Future.value(true);

  bool avoidBottomInset() => true;

  Widget scaffoldWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop(context),
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
