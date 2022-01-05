import 'dart:developer';

import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:trips_repository/trips_repository.dart';

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
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.tripDays,
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final calendarDay =
                          state.currentTrip.initDate.add(Duration(days: index));
                      final formattedDay =
                          DateFormat('dd LLL').format(calendarDay);
                      return Padding(
                        padding: const EdgeInsets.all(6),
                        child: ElevatedButton(
                          onPressed: state.currentDayIndex == index
                              ? null
                              : () => {
                                    print('going to day $day'),
                                    context
                                        .read<TripsCubit>()
                                        .refreshSelectedDay(index)
                                  },
                          child: Text(
                              'Day ${state.currentTrip.initDate.day} - $formattedDay'),
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
                  return SelectedDayTripData(
                    trip: state.currentTrip,
                    index: state.currentDayIndex,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedDayTripData extends StatelessWidget {
  const SelectedDayTripData({
    Key? key,
    required this.trip,
    required this.index,
  }) : super(key: key);

  final Trip trip;
  final int index;

  @override
  Widget build(BuildContext context) {
    // TODO: build timeline with activities
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView(
        children: <Widget>[
          _buildTimelineTile(
            indicator: const _IconIndicator(
              iconData: Icons.airplanemode_active_rounded,
              size: 20,
            ),
            time: DateFormat('dd LLL hh:mm')
                .format(trip.initDate.add(Duration(days: index))),
            location: trip.transportations.first['location'] as String,
            description: trip.transportations.first['notes'] as String,
          ),
          _buildTimelineTile(
            indicator: const _IconIndicator(
              iconData: Icons.hotel_rounded,
              size: 20,
            ),
            time: DateFormat('dd LLL hh:mm')
                .format(trip.initDate.add(Duration(days: index))),
            location: trip.accommodations.first['location'] as String,
            description: trip.accommodations.first['notes'] as String,
          ),
        ],
      ),
    );
  }

  TimelineTile _buildTimelineTile({
    required _IconIndicator indicator,
    required String time,
    required String location,
    required String description,
    bool isLast = false,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      beforeLineStyle: LineStyle(
          color: const Color.fromRGBO(90, 23, 238, 1).withOpacity(0.7)),
      indicatorStyle: IndicatorStyle(
        indicatorXY: 0.3,
        drawGap: true,
        width: 30,
        height: 30,
        indicator: indicator,
      ),
      isLast: isLast,
      startChild: Center(
        child: Container(
          alignment: const Alignment(0, -0.50),
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(90, 23, 238, 1),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      endChild: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 10, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              location,
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromRGBO(90, 23, 238, 1).withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromRGBO(90, 23, 238, 1).withOpacity(0.6),
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _IconIndicator extends StatelessWidget {
  const _IconIndicator({
    Key? key,
    required this.iconData,
    required this.size,
  }) : super(key: key);

  final IconData iconData;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromRGBO(90, 23, 238, 1).withOpacity(0.7),
          ),
        ),
        Positioned.fill(
          child: Align(
            child: SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                iconData,
                size: size,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
