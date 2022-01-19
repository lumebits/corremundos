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
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:trips_repository/trips_repository.dart';

class CreateEventForm extends BasePage {
  const CreateEventForm(this.trip, this.day, this.eventType, {Key? key})
      : super(key);

  final Trip trip;
  final DateTime day;
  final EventType eventType;

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  List<Widget>? actions(BuildContext context) => null;

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
    return Padding(
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

// TODO(palomapiot): edit accommodation -> one accommodation has 2 trip events
// we need to load the checkout
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
        return DateTimeInput(
          key: const Key('newTripEventForm_initDate_textField'),
          label: label,
          initialValue: DateFormat('HH:mm').format(state.tripEvent.time),
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
              currentTime: state.tripEvent.time,
            );
          },
          onSubmitted: (date) => context
              .read<CreateEventCubit>()
              .timeChanged(DateFormat('dd/MM/yyyy').parse(date)),
          keyboardType: TextInputType.datetime,
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
          keyboardType: TextInputType.datetime,
        );
      },
    );
  }
}

// TODO(palomapiot): edit files - adding a new one replaces the old one
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
              context.read<CreateEventCubit>().fileChanged(result);
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
              return Text(
                '\u{2611} ${state.pickedFile!.files.first.name}',
                style: const TextStyle(
                  fontSize: 18,
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
    return SizedBox(
      width: 210,
      height: 50,
      child: BlocBuilder<CreateEventCubit, CreateEventState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return ElevatedButton(
            key: const Key('newEventForm_save_button'),
            onPressed: () => !state.isLoading
                ? context
                    .read<CreateEventCubit>()
                    .saveEvent(eventType)
                    .then((value) {
                    showTopSnackBar(
                      context,
                      const CustomSnackBar.success(
                        message: 'Event created',
                        icon: Icon(null),
                        backgroundColor: Color.fromRGBO(90, 23, 238, 1),
                      ),
                    );
                    context
                        .read<TripsCubit>()
                        .loadCurrentTrip(resetSelectedDay: false);
                    context.read<TripsCubit>().loadMyTrips();
                    // TODO(palomapiot): Reload selected trip with new event
                    Navigator.of(context).pop(true);
                  })
                : null,
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
          );
        },
      ),
    );
  }
}
