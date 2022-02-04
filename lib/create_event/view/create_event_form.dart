import 'package:auto_size_text/auto_size_text.dart';
import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/date_time_input.dart';
import 'package:corremundos/common/widgets/text_input.dart';
import 'package:corremundos/create_event/cubit/create_event_cubit.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:trips_repository/trips_repository.dart';

final _formKey = GlobalKey<FormState>();

class CreateEventForm extends BasePage {
  const CreateEventForm(this.trip, this.day, this.eventType, {Key? key})
      : super(key);

  final Trip trip;
  final DateTime day;
  final EventType eventType;

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  List<Widget>? actions(BuildContext context) {
    final tripEvent = context.read<CreateEventCubit>().state.tripEvent;
    if (tripEvent.isNotEmpty) {
      return [
        IconButton(
          key: const Key('delete_iconButton'),
          icon: const Icon(
            Icons.delete_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  title: const Text(
                    'Do you want to delete this event?',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                            ),
                            key: const Key('deleteEvent_discard_iconButton'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                            ),
                            key: const Key('deleteEvent_delete_iconButton'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ).then((value) {
              if (value == true) {
                context
                    .read<CreateEventCubit>()
                    .deleteTripEvent(trip.id)
                    .then((value) {
                  showTopSnackBar(
                    context,
                    const CustomSnackBar.success(
                      message: 'Event deleted',
                      icon: Icon(null),
                      backgroundColor: Color.fromRGBO(90, 23, 238, 1),
                    ),
                  );
                  context
                      .read<TripsCubit>()
                      .loadCurrentTrip(resetSelectedDay: false);
                  context
                      .read<TripsCubit>()
                      .loadMyTrips()
                      .then((value2) => Navigator.of(context).pop(value));
                });
              }
              return true;
            });
          },
        )
      ];
    } else {
      return null;
    }
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(220),
      child: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: eventType == EventType.transport
              ? _cardDecoration('assets/transportation_placeholder.jpg')
              : eventType == EventType.accommodation
                  ? _cardDecoration('assets/accommodation_placeholder.jpg')
                  : _cardDecoration('assets/activity_placeholder.jpg'),
        ),
        title: BlocBuilder<CreateEventCubit, CreateEventState>(
          builder: (context, state) {
            return FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                eventType == EventType.transport
                    ? '${formatDay()}: Add transport'
                    : eventType == EventType.accommodation
                        ? '${formatDay()}: Add accommodation'
                        : '${formatDay()}: Add activity',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        actions: actions(context),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  String formatDay() => DateFormat('dd LLL').format(day);

  @override
  Widget widget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (eventType == EventType.transport)
                  _TransportationForm(trip, day)
                else
                  eventType == EventType.accommodation
                      ? _AccommodationForm(trip, day)
                      : _ActivityForm(trip, day),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Decoration _cardDecoration(String file) {
  return BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage(file),
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.35),
        BlendMode.darken,
      ),
    ),
  );
}

class _TransportationForm extends StatelessWidget {
  const _TransportationForm(this.trip, this.day);

  final Trip trip;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const _TripNameInput('Route'),
        const SizedBox(height: 8),
        const _TripLocationInput('Notes'),
        const SizedBox(height: 8),
        _TripEventTimePicker(day, 'Departure time'),
        const SizedBox(height: 8),
        _TripEventEndTimePicker(day, 'Arrival time'),
        const SizedBox(height: 8),
        _PickAndUploadFile(),
        const SizedBox(height: 24),
        const _SaveTripEvent(EventType.transport),
      ],
    );
  }
}

class _AccommodationForm extends StatelessWidget {
  const _AccommodationForm(this.trip, this.day);

  final Trip trip;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const _TripNameInput('Name'),
        const SizedBox(height: 8),
        const _TripLocationInput('Location'),
        const SizedBox(height: 8),
        _TripEventTimePicker(day, 'Check-in'),
        const SizedBox(height: 8),
        _TripEventEndTimePicker(day, 'Check-out'),
        const SizedBox(height: 8),
        _PickAndUploadFile(),
        const SizedBox(height: 24),
        const _SaveTripEvent(EventType.accommodation),
      ],
    );
  }
}

class _ActivityForm extends StatelessWidget {
  const _ActivityForm(this.trip, this.day);

  final Trip trip;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const _TripNameInput('Activity'),
        const SizedBox(height: 8),
        const _TripLocationInput('Location'),
        const SizedBox(height: 8),
        _TripEventTimePicker(day, 'Time'),
        const SizedBox(height: 8),
        _PickAndUploadFile(),
        const SizedBox(height: 24),
        const _SaveTripEvent(EventType.activity),
      ],
    );
  }
}

class _TripLocationInput extends StatelessWidget {
  const _TripLocationInput(this.label);

  final String label;
  @override
  Widget build(BuildContext context) {
    return TextInput(
      key: const Key('newEventForm_locationInput_textField'),
      label: label,
      initialValue: context.read<CreateEventCubit>().state.tripEvent.location,
      iconData: Icons.location_on_rounded,
      onChanged: (newValue) =>
          context.read<CreateEventCubit>().locationChanged(newValue),
    );
  }
}

class _TripNameInput extends StatelessWidget {
  const _TripNameInput(this.label);

  final String label;
  @override
  Widget build(BuildContext context) {
    return TextInput(
      key: const Key('newEventForm_nameInput_textField'),
      label: label,
      initialValue: context.read<CreateEventCubit>().state.tripEvent.name,
      iconData: Icons.description_rounded,
      onChanged: (newValue) =>
          context.read<CreateEventCubit>().nameChanged(newValue),
    );
  }
}

class _TripEventTimePicker extends StatelessWidget {
  const _TripEventTimePicker(this.day, this.label);

  final DateTime day;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      buildWhen: (previous, current) =>
          previous.tripEvent.time != current.tripEvent.time,
      builder: (context, state) {
        final initDate = DateTime(
          day.year,
          day.month,
          day.day,
          state.tripEvent.time.hour,
          state.tripEvent.time.minute,
        );
        context.read<CreateEventCubit>().timeChanged(initDate);
        return DateTimeInput(
          key: const Key('newTripEventForm_initDate_textField'),
          label: label,
          initialValue: DateFormat('HH:mm').format(initDate),
          iconData: Icons.calendar_today_rounded,
          onPressed: () {
            DatePicker.showTimePicker(
              context,
              showSecondsColumn: false,
              onConfirm: (date) {
                final eventDate = DateTime(
                  day.year,
                  day.month,
                  day.day,
                  date.hour,
                  date.minute,
                );
                context.read<CreateEventCubit>().timeChanged(eventDate);
              },
              currentTime: initDate,
            );
          },
          onSubmitted: (date) => context
              .read<CreateEventCubit>()
              .timeChanged(DateFormat('dd/MM/yyyy').parse(date)),
        );
      },
    );
  }
}

class _TripEventEndTimePicker extends StatelessWidget {
  const _TripEventEndTimePicker(this.day, this.label);

  final DateTime day;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      buildWhen: (previous, current) =>
          previous.tripEvent.endTime != current.tripEvent.endTime,
      builder: (context, state) {
        final endTime = state.tripEvent.endTime ??
            context.read<CreateEventCubit>().setEndTime(day);
        context.read<CreateEventCubit>().endTimeChanged(endTime);
        return DateTimeInput(
          key: const Key('newTripEventForm_endDate_textField'),
          label: label,
          initialValue: DateFormat('dd/MM/yyyy HH:mm').format(endTime),
          iconData: Icons.calendar_today_rounded,
          onPressed: () {
            DatePicker.showDateTimePicker(
              context,
              onConfirm: (date) {
                context.read<CreateEventCubit>().endTimeChanged(date);
              },
              currentTime: state.tripEvent.endTime ?? endTime,
            );
          },
          onSubmitted: (date) => context
              .read<CreateEventCubit>()
              .endTimeChanged(DateFormat('dd/MM/yyyy').parse(date)),
        );
      },
    );
  }
}

class _PickAndUploadFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            key: const Key('newEventForm_pickFile_button'),
            icon: const Icon(
              Icons.cloud_upload_rounded,
              color: Color.fromRGBO(90, 23, 238, 1),
              size: 22,
            ),
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
                withData: true,
              );
              if (result != null &&
                  result.files.where((file) => file.size > 512000).isEmpty) {
                context.read<CreateEventCubit>().fileChanged(result);
              } else {
                // TODO(paloma): max size exceed, tell the user and dont upload
              }
            },
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
              'Attach file',
              style: TextStyle(
                fontSize: 17,
                color: Color.fromRGBO(90, 23, 238, 1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        BlocBuilder<CreateEventCubit, CreateEventState>(
          builder: (context, state) {
            if (state.pickedFile != null) {
              return AutoSizeText(
                state.pickedFile!.files.first.name,
                maxLines: 1,
                minFontSize: 8,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              );
            } else if (state.tripEvent.isNotEmpty &&
                state.tripEvent.fileUrl.isNotEmpty) {
              var fileName = state.tripEvent.fileUrl;
              fileName = fileName.substring(0, fileName.indexOf('?alt'));
              fileName = fileName.split('%2F')[1];
              return AutoSizeText(
                fileName,
                maxLines: 1,
                minFontSize: 8,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              );
            } else {
              return const Center();
            }
          },
        ),
      ],
    );
  }
}

class _SaveTripEvent extends StatelessWidget {
  const _SaveTripEvent(this.eventType);

  final EventType eventType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox(
            height: 20,
            width: 100,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [Color.fromRGBO(90, 23, 238, 1)],
              backgroundColor: Colors.white10,
              pathBackgroundColor: Colors.black,
            ),
          );
        } else {
          return SizedBox(
            width: 210,
            height: 50,
            child: ElevatedButton(
              key: const Key('newEventForm_save_button'),
              onPressed: () {
                if (_formKey.currentState!.validate() && !state.isLoading) {
                  context
                      .read<CreateEventCubit>()
                      .saveEvent(eventType)
                      .then((value) {
                    context
                        .read<TripsCubit>()
                        .loadCurrentTrip(resetSelectedDay: false);
                    context
                        .read<TripsCubit>()
                        .loadMyTrips()
                        .then((value2) => Navigator.of(context).pop(value));
                    showTopSnackBar(
                      context,
                      const CustomSnackBar.success(
                        message: 'Event created',
                        icon: Icon(null),
                        backgroundColor: Color.fromRGBO(90, 23, 238, 1),
                      ),
                    );
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                primary: !state.isLoading
                    ? const Color.fromRGBO(90, 23, 238, 1)
                    : Colors.grey,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
