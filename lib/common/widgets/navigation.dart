import 'package:corremundos/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTab { trips, current, addTrip, calendar, settings }

class Navigation extends StatelessWidget {
  const Navigation({Key? key, this.activeTab = AppTab.trips}) : super(key: key);

  final AppTab activeTab;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 7,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.table_rows),
                  onPressed: () {
                    context
                        .read<AppBloc>()
                        .add(const NavigationRequested(AppTab.trips));
                  },
                  color: activeTab == AppTab.trips
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                //Text(l10n.navBarCards),
                const Text('My Trips'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.person),
                  color: activeTab == AppTab.calendar
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  onPressed: () {
                    context
                        .read<AppBloc>()
                        .add(const NavigationRequested(AppTab.calendar));
                  },
                ),
                const Text('Calendar'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
