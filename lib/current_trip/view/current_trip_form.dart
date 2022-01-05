import 'dart:developer';

import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CurrentTripForm extends BasePage {
  const CurrentTripForm({Key? key}) : super(key, appTab: AppTab.current);

  @override
  List<BlocListener> listeners(BuildContext context) {
    return [
      BlocListener<TripsCubit, TripsState>(
        listenWhen: (previous, current) => previous.error != current.error,
        listener: (context, state) {
          if (state.error) {
            showTopSnackBar(
              context,
              const CustomSnackBar.info(
                message: 'Error loading current trip',
                icon: Icon(null),
                backgroundColor: Color.fromRGBO(90, 23, 238, 1),
              ),
            );
          }
        },
      ),
    ];
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Future<bool> onWillPop(BuildContext context) => Future.value(false);

  @override
  bool avoidBottomInset() => true;

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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                'Current Trip',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: BlocBuilder<TripsCubit, TripsState>(
                builder: (context, state) {
                  final tripDays = state.currentTrip.initDate
                          .difference(DateTime.now())
                          .inDays +
                      1;
                  var isSelected = List.filled(tripDays, false);
                  var calendarDay = state.currentTrip.initDate;
                  isSelected[0] = true; // TODO: set current day index
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tripDays,
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      calendarDay = calendarDay.add(const Duration(days: 1));
                      final formattedDay =
                          DateFormat('dd LLL').format(calendarDay);
                      return Padding(
                        padding: const EdgeInsets.all(6),
                        child: ElevatedButton(
                          onPressed: isSelected[index]
                              ? null
                              : () => {
                                    print('going to day $day'),
                                    isSelected = List.filled(10, false),
                                    isSelected[index] = true,
                                    print(isSelected)
                                  },
                          child: Text('Day $day - $formattedDay'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 9,
              child: BlocBuilder<TripsCubit, TripsState>(
                builder: (context, state) {
                  return const Text('Day content');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
