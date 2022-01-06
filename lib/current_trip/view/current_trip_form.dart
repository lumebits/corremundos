import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                      final calendarDay =
                          state.currentTrip.initDate.add(Duration(days: index));
                      final day = DateFormat('dd LLL').format(calendarDay);
                      return Padding(
                        padding: const EdgeInsets.all(6),
                        child: ElevatedButton(
                          onPressed: state.currentDayIndex == index
                              ? null
                              : () => {
                                    context
                                        .read<TripsCubit>()
                                        .refreshSelectedDay(index)
                                  },
                          child: Text(
                            'Day ${state.currentTrip.initDate.day} - $day',
                          ),
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
    final events =
        trip.eventMap.containsKey(index) ? trip.eventMap[index] : <dynamic>[];

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: events!.isNotEmpty
          ? ListView.separated(
              itemCount: events.length,
              itemBuilder: (context, i) {
                final event = events[i] as TripEvent;
                final eventType = event.type;
                final icon = eventType == EventType.transportation
                    ? Icons.airplanemode_active_rounded
                    : eventType == EventType.accommodation
                        ? Icons.hotel_rounded
                        : Icons.local_activity_rounded;
                return _buildTimelineTile(
                  context: context,
                  indicator: _IconIndicator(
                    iconData: icon,
                    size: 20,
                  ),
                  time: event.time,
                  location: event.location,
                  description: event.description,
                  file: event.fileUrl,
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16 / 2),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage('assets/noevents.png'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No events today!',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  TimelineTile _buildTimelineTile({
    required BuildContext context,
    required _IconIndicator indicator,
    required DateTime time,
    required String location,
    required String description,
    String file = '',
    bool isLast = false,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      beforeLineStyle: LineStyle(
        color: const Color.fromRGBO(90, 23, 238, 1).withOpacity(0.7),
      ),
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
            DateFormat('dd LLL HH:mm').format(time.add(Duration(days: index))),
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
        child: SizedBox(
          width: 150,
          height: 110,
          child: Card(
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 9,
            child: Ink(
              child: InkWell(
                onTap: () => file != ''
                    ? showDialog<void>(
                        context: context,
                        builder: (context) => ImageDialog(file: file),
                      )
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: AutoSizeText(
                              location,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromRGBO(90, 23, 238, 1)
                                    .withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (file == '')
                            const Center()
                          else
                            const Expanded(
                              child: Icon(
                                Icons.attach_file_rounded,
                                color: Color.fromRGBO(90, 23, 238, 1),
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AutoSizeText(
                        description,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromRGBO(90, 23, 238, 1)
                              .withOpacity(0.6),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
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

class ImageDialog extends StatelessWidget {
  const ImageDialog({
    Key? key,
    required this.file,
  }) : super(key: key);

  final String file;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: InteractiveViewer(
        panEnabled: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(file),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
