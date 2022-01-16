import 'package:cached_network_image/cached_network_image.dart';
import 'package:corremundos/common/blocs/load_pdf/load_pdf_cubit.dart';
import 'package:corremundos/create_event/create_event.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:trips_repository/trips_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectedDayTripData extends StatelessWidget {
  const SelectedDayTripData({
    Key? key,
    required this.trip,
    required this.index,
    required this.initTripDay,
  }) : super(key: key);

  final Trip trip;
  final int index;
  final DateTime initTripDay;

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final events =
        trip.eventMap.containsKey(index) ? trip.eventMap[index] : <dynamic>[];
    final selectedDayDate = initTripDay.add(Duration(days: index));
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: events!.isNotEmpty
          ? ListView.separated(
              itemCount: events.length + 1,
              itemBuilder: (context, i) {
                return buildEvent(events, i, context, selectedDayDate);
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16 / 2),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/noevents.png'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 280,
                      height: 70,
                      child: ElevatedButton.icon(
                        key: const Key('addNewEvent_button'),
                        icon: const Icon(
                          Icons.add_rounded,
                          color: Color.fromRGBO(90, 23, 238, 1),
                          size: 22,
                        ),
                        onPressed: () =>
                            showNewEventDialog(context, trip, selectedDayDate),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(242, 238, 255, 1),
                          shadowColor: Colors.white10,
                          elevation: 1,
                          side: const BorderSide(
                            width: 0.8,
                            color: Color.fromRGBO(225, 220, 251, 1),
                          ),
                        ),
                        label: const Text(
                          'Add new event',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color.fromRGBO(90, 23, 238, 1),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  TimelineTile buildEvent(
    List<dynamic> events,
    int i,
    BuildContext context,
    DateTime selectedDayDate,
  ) {
    if (i < events.length) {
      final event = events[i] as TripEvent;
      final eventType = event.type;
      final icon = eventType == EventType.transport
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
        time: eventType == EventType.transport
            ? '${formatHour(event.time)} - '
                '${formatHour(event.endTime!)}'
            : eventType == EventType.accommodation
                ? event.isCheckIn!
                    ? 'check-in ${formatHour(event.time)}'
                    : 'check-out ${formatHour(event.time)}'
                : DateFormat('dd LLL HH:mm')
                    .format(event.time.add(Duration(days: index))),
        name: event.name,
        location: event.location,
        eventType: event.type,
        day: event.time,
        file: event.fileUrl,
      );
    } else {
      return _buildAddEvent(
        context: context,
        time: selectedDayDate,
      );
    }
  }

  String formatHour(DateTime time) =>
      DateFormat('HH:mm').format(time.add(Duration(days: index)));

  TimelineTile _buildTimelineTile({
    required BuildContext context,
    required _IconIndicator indicator,
    required String time,
    required String name,
    required String location,
    required EventType eventType,
    required DateTime day,
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
        child: Card(
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Ink(
                child: InkWell(
                  onTap: () => file != ''
                      ? showDialog<void>(
                          context: context,
                          builder: (context) =>
                              AttachedFileDialog(fileUrl: file),
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
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 17,
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
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color.fromRGBO(90, 23, 238, 1)
                                .withOpacity(0.6),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    color: const Color.fromRGBO(90, 23, 238, 1),
                    iconSize: 18,
                    onPressed: () {
                      // TODO(palomapiot): pass event
                      // (create trip event and pass it)
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => CreateEventPage(
                              trip,
                              day,
                              eventType),
                        ),
                      );
                    },
                  ),
                  if (location.isNotEmpty && eventType != EventType.transport)
                    IconButton(
                      icon: const Icon(Icons.pin_drop_rounded),
                      color: const Color.fromRGBO(90, 23, 238, 1),
                      iconSize: 18,
                      onPressed: () {
                        _launchURL(
                          'https://www.google.com/maps/search/?api=1&query='
                          '${Uri.encodeFull(location)}',
                        );
                      },
                    )
                  else
                    const Center(),
                  const SizedBox(width: 8),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TimelineTile _buildAddEvent({
    required BuildContext context,
    required DateTime time,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      beforeLineStyle: LineStyle(
        color: const Color.fromRGBO(90, 23, 238, 1).withOpacity(0.7),
      ),
      indicatorStyle: const IndicatorStyle(
        indicatorXY: 0.3,
        drawGap: true,
        width: 30,
        height: 30,
        indicator: _IconIndicator(
          iconData: Icons.add_rounded,
          size: 20,
        ),
      ),
      isLast: true,
      endChild: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 10, top: 10, bottom: 10),
        child: NewEventWidget(trip: trip, selectedTripDay: time),
      ),
    );
  }
}

class NewEventWidget extends StatelessWidget {
  const NewEventWidget({
    Key? key,
    required this.trip,
    required this.selectedTripDay,
  }) : super(key: key);

  final Trip trip;
  final DateTime selectedTripDay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DottedBorder(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        borderType: BorderType.RRect,
        dashPattern: const [10, 7],
        strokeWidth: 2,
        strokeCap: StrokeCap.round,
        padding: const EdgeInsets.all(0.1),
        radius: const Radius.circular(25),
        child: Ink(
          child: InkWell(
            onTap: () => showNewEventDialog(context, trip, selectedTripDay),
            child: Card(
              shadowColor: Colors.white10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Add new event',
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          const Color.fromRGBO(90, 23, 238, 1).withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
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

Future<bool> showNewEventDialog(
  BuildContext context,
  Trip trip,
  DateTime selectedTripDay,
) {
  return showDialog<int>(
    context: context,
    builder: addNewEventDialog,
  ).then((value) {
    if (value != null) {
      var eventType = EventType.transport;
      if (value == 1) {
        eventType = EventType.accommodation;
      } else if (value == 2) {
        eventType = EventType.activity;
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) {
            return CreateEventPage(trip, selectedTripDay, eventType);
          },
        ),
      );
    }
    return true;
  });
}

AlertDialog addNewEventDialog(BuildContext context) {
  var selectedType = 0;
  final selectedList = ['Transport', 'Accommodation', 'Activity'];
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    title: Center(
      child: Text(
        'Select event type',
        style: TextStyle(
          fontSize: 22,
          color: const Color.fromRGBO(90, 23, 238, 1).withOpacity(0.8),
        ),
      ),
    ),
    content: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(3, (int index) {
            return RadioListTile<int>(
              title: Text(
                selectedList[index],
                style: TextStyle(
                  fontSize: 18,
                  color: selectedType == index
                      ? const Color.fromRGBO(90, 23, 238, 1).withOpacity(0.8)
                      : Colors.grey,
                ),
              ),
              value: index,
              activeColor: const Color.fromRGBO(90, 23, 238, 1),
              groupValue: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            );
          }),
        );
      },
    ),
    actions: <Widget>[
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(),
              key: const Key(
                'selectEventType_continue_iconButton',
              ),
              onPressed: () {
                Navigator.of(context).pop(selectedType);
              },
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    ],
  );
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

class AttachedFileDialog extends StatelessWidget {
  const AttachedFileDialog({
    Key? key,
    required this.fileUrl,
  }) : super(key: key);

  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    if (fileUrl.contains('.pdf?') || fileUrl.endsWith('.pdf')) {
      context.read<LoadPdfCubit>().load(fileUrl);
      return Dialog(
        child: BlocBuilder<LoadPdfCubit, LoadPdfState>(
          builder: (context, state) {
            if (state.isLoading) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                ),
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (state.error) {
              return const Center(
                child: Text('Error loading file.'),
              );
            } else {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 440,
                ),
                child: PdfViewer.openFile(
                  state.path,
                  params: const PdfViewerParams(
                    panEnabled: false,
                  ),
                ),
              );
            }
          },
        ),
      );
    } else {
      return Dialog(
        child: InteractiveViewer(
          panEnabled: false,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 440,
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(fileUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
