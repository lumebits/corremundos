import 'package:corremundos/common/widgets/base_page.dart';
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
        const _TripLocationInput('Route'),
        const SizedBox(height: 8),
        const _TripNameInput('Notes'),
        const SizedBox(height: 8),
        _TripEventTimePicker(day, 'Departure time'),
        const SizedBox(height: 8),
        _TripEventEndTimePicker(day, 'Arrival time'),
        const SizedBox(height: 8),
        _PickAndUploadFile(),
        const SizedBox(height: 24),
        const _SaveTrip(EventType.transport),
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
        const _SaveTrip(EventType.accommodation),
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
        const SizedBox(height: 24),
        const _SaveTrip(EventType.activity),
      ],
    );
  }
}

class _TripLocationInput extends StatelessWidget {
  const _TripLocationInput(this.label);

  final String label;
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      buildWhen: (previous, current) =>
          previous.tripEvent.name != current.tripEvent.name,
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          key: const Key('newEventForm_locationInput_textField'),
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onChanged: (value) =>
              context.read<CreateEventCubit>().locationChanged(value),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            labelText: label,
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
            prefixIcon: const Icon(
              Icons.location_on_rounded,
              color: Color.fromRGBO(90, 23, 238, 1),
            ),
          ),
        );
      },
    );
  }
}

class _TripNameInput extends StatelessWidget {
  const _TripNameInput(this.label);

  final String label;
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      buildWhen: (previous, current) =>
          previous.tripEvent.location != current.tripEvent.location,
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          key: const Key('newEventForm_descriptionInput_textField'),
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onChanged: (value) =>
              context.read<CreateEventCubit>().nameChanged(value),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            labelText: label,
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
            prefixIcon: const Icon(
              Icons.description_rounded,
              color: Color.fromRGBO(90, 23, 238, 1),
            ),
          ),
        );
      },
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
        final _textController = TextEditingController(
          text: DateFormat('HH:mm').format(state.tripEvent.time),
        );
        return TextField(
          onTap: () {
            FocusScope.of(context).unfocus();
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
              currentTime: DateTime.now(),
            );
            FocusScope.of(context).unfocus();
          },
          readOnly: true,
          controller: _textController,
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onSubmitted: (date) => context
              .read<CreateEventCubit>()
              .timeChanged(DateFormat('dd/MM/yyyy').parse(date)),
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.grey,
            ),
            labelText: label,
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_rounded),
              color: const Color.fromRGBO(90, 23, 238, 1),
              onPressed: () {
                FocusScope.of(context).unfocus();
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
                  currentTime: DateTime.now(),
                );
                FocusScope.of(context).unfocus();
              },
            ),
            hintText: 'dd/MM/yyyy',
          ),
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
        final _textController = TextEditingController(
          text: DateFormat('dd/MM/yyyy HH:mm').format(endTime),
        );
        return TextField(
          onTap: () {
            FocusScope.of(context).unfocus();
            DatePicker.showDateTimePicker(
              context,
              onConfirm: (date) {
                context.read<CreateEventCubit>().endTimeChanged(date);
              },
              currentTime: state.tripEvent.endTime ?? endTime,
            );
            FocusScope.of(context).unfocus();
          },
          readOnly: true,
          controller: _textController,
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onSubmitted: (date) => context
              .read<CreateEventCubit>()
              .endTimeChanged(DateFormat('dd/MM/yyyy HH:mm').parse(date)),
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.grey,
            ),
            labelText: label,
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_rounded),
              color: const Color.fromRGBO(90, 23, 238, 1),
              onPressed: () {
                FocusScope.of(context).unfocus();
                DatePicker.showDateTimePicker(
                  context,
                  onConfirm: (date) {
                    context.read<CreateEventCubit>().endTimeChanged(date);
                  },
                  currentTime: state.tripEvent.endTime,
                );
                FocusScope.of(context).unfocus();
              },
            ),
            hintText: 'dd/MM/yyyy',
          ),
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

class _SaveTrip extends StatelessWidget {
  const _SaveTrip(this.eventType);

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
