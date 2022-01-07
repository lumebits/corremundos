import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/create_event/cubit/create_event_cubit.dart';
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
  String title(BuildContext context) => 'Create Trip Event';

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  List<Widget>? actions(BuildContext context) {
    final items = <Widget>[
      IconButton(
        key: const Key('editEvent_save_iconButton'),
        icon: const Icon(Icons.check),
        onPressed: () async {
          /*await context.read<CreateTripCubit>().saveTrip().then((value) {
            showTopSnackBar(
              context,
              const CustomSnackBar.success(
                message: 'Trip event created',
                icon: Icon(null),
                backgroundColor: Color.fromRGBO(90, 23, 238, 1),
              ),
            );
            Navigator.of(context).pop(true);
          });*/
        },
      )
    ];
    return items;
  }

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
              if (eventType == EventType.transportation)
                _TransportationForm(trip, day)
              else
                eventType == EventType.accommodation
                    ? Text('accommodation')
                    : Text('activity'),
            ],
          ),
        ),
      ),
    );
  }
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              '${DateFormat('dd LLL').format(day)}: Add conveyance',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const _GetTripImageButton(),
        const SizedBox(height: 24),
        _TripLocationInput(),
        const SizedBox(height: 8),
        _TripDescriptionInput(),
        const SizedBox(height: 8),
        _TripEventTimePicker(day),
        const SizedBox(height: 8),
        _PickAndUploadFile(),
        const SizedBox(height: 24),
        _SaveTrip(),
      ],
    );
  }
}

class _GetTripImageButton extends StatelessWidget {
  const _GetTripImageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200 * 1.85,
      height: 200,
      child: Card(
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 9,
        child: Ink(
          decoration: _cardDecoration(),
        ),
      ),
    );
  }
}

Decoration _cardDecoration() {
  return const BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.fitWidth,
      image: AssetImage('assets/transportation_placeholder.jpg'),
    ),
  );
}

class _TripLocationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      buildWhen: (previous, current) =>
          previous.tripEvent.location != current.tripEvent.location,
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
            labelText: 'Route',
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

class _TripDescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      buildWhen: (previous, current) =>
          previous.tripEvent.description != current.tripEvent.description,
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          key: const Key('newEventForm_descriptionInput_textField'),
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onChanged: (value) =>
              context.read<CreateEventCubit>().descriptionChanged(value),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            labelText: 'Notes',
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
  const _TripEventTimePicker(this.day);

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      buildWhen: (previous, current) =>
          previous.tripEvent.time != current.tripEvent.time,
      builder: (context, state) {
        final _textController = TextEditingController();
        _textController.text = DateFormat('HH:mm').format(state.tripEvent.time);
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
            labelText: 'Departure time',
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

class _PickAndUploadFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            key: const Key('newEventForm_save_button'),
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
              primary: Colors.white,
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
          buildWhen: (previous, current) =>
              previous.pickedFile != current.pickedFile,
          builder: (context, state) {
            if (state.pickedFile != null) {
              return Text(
                state.pickedFile!.files.first.name,
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
                      .saveEvent(EventType.transportation)
                      .then((value) {
                      showTopSnackBar(
                        context,
                        const CustomSnackBar.success(
                          message: 'Event created',
                          icon: Icon(null),
                          backgroundColor: Color.fromRGBO(90, 23, 238, 1),
                        ),
                      );
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
          }),
    );
  }
}
