import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:flutter/cupertino.dart';

class CalendarForm extends BasePage {
  const CalendarForm({Key? key}) : super(key, appTab: AppTab.calendar);

  @override
  String title(BuildContext context) => 'Calendar';

  @override
  bool avoidBottomInset() => false;

  @override
  Widget widget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Center(
              child: Text(
                'Coming soon!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Color.fromRGBO(90, 23, 238, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
