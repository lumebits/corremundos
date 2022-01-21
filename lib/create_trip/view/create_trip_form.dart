import 'package:cached_network_image/cached_network_image.dart';
import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/date_time_input.dart';
import 'package:corremundos/common/widgets/text_input.dart';
import 'package:corremundos/create_trip/cubit/create_trip_cubit.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

final _formKey = GlobalKey<FormState>();

class CreateTripForm extends BasePage {
  const CreateTripForm({Key? key}) : super(key);

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  List<Widget>? actions(BuildContext context) {
    final tripId = context.read<CreateTripCubit>().state.id;
    if (tripId != null && tripId != '') {
      return [
        IconButton(
          key: const Key('delete_iconButton'),
          icon: const Icon(
            Icons.delete_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            context.read<CreateTripCubit>().deleteTrip(tripId).then((value) {
              showTopSnackBar(
                context,
                const CustomSnackBar.success(
                  message: 'Trip deleted',
                  icon: Icon(null),
                  backgroundColor: Color.fromRGBO(90, 23, 238, 1),
                ),
              );
              context
                  .read<TripsCubit>()
                  .loadMyTrips()
                  .then((value) => Navigator.of(context).pop());
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
    final image = context.read<CreateTripCubit>().state.name.isNotEmpty
        ? context.read<CreateTripCubit>().state.imageUrl
        : '';
    return PreferredSize(
      preferredSize: const Size.fromHeight(220),
      child: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: _cardDecoration(image),
        ),
        title: const Text(
          'Your new trip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        actions: actions(context),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

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
                const SizedBox(height: 24),
                _TripNameInput(),
                const SizedBox(height: 8),
                _TripInitDatePicker(),
                const SizedBox(height: 8),
                _TripEndDatePicker(),
                const SizedBox(height: 24),
                _SaveTrip(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Decoration _cardDecoration(String imageUrl) {
  if (imageUrl.isNotEmpty) {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: CachedNetworkImageProvider(imageUrl),
        colorFilter: const ColorFilter.mode(
          Colors.black26,
          BlendMode.darken,
        ),
      ),
    );
  }
  return const BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage('assets/trip_placeholder.jpg'),
      colorFilter: ColorFilter.mode(
        Colors.black26,
        BlendMode.darken,
      ),
    ),
  );
}

class _TripNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextInput(
      key: const Key('newTripForm_nameInput_textField'),
      label: 'Trip name',
      initialValue: context.read<CreateTripCubit>().state.name,
      iconData: Icons.description_rounded,
      onChanged: (newValue) =>
          context.read<CreateTripCubit>().nameChanged(newValue),
    );
  }
}

class _TripInitDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTripCubit, CreateTripState>(
      buildWhen: (previous, current) => previous.initDate != current.initDate,
      builder: (context, state) {
        return DateTimeInput(
          key: const Key('newTripForm_initDate_textField'),
          label: 'Init date',
          initialValue: DateFormat('dd/MM/yyyy').format(state.initDate),
          iconData: Icons.calendar_today_rounded,
          onPressed: () {
            DatePicker.showDatePicker(
              context,
              onConfirm: (date) {
                context.read<CreateTripCubit>().initDateChanged(date);
              },
              currentTime: state.initDate,
            );
          },
          onSubmitted: (date) => context
              .read<CreateTripCubit>()
              .initDateChanged(DateFormat('dd/MM/yyyy').parse(date)),
        );
      },
    );
  }
}

class _TripEndDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTripCubit, CreateTripState>(
      buildWhen: (previous, current) => previous.endDate != current.endDate,
      builder: (context, state) {
        return DateTimeInput(
          key: const Key('newTripForm_endDate_textField'),
          label: 'End date',
          initialValue: DateFormat('dd/MM/yyyy').format(state.endDate),
          iconData: Icons.calendar_today_rounded,
          onPressed: () {
            DatePicker.showDatePicker(
              context,
              onConfirm: (date) {
                context.read<CreateTripCubit>().endDateChanged(date);
              },
              currentTime: state.endDate,
            );
          },
          onSubmitted: (date) => context
              .read<CreateTripCubit>()
              .endDateChanged(DateFormat('dd/MM/yyyy').parse(date)),
        );
      },
    );
  }
}

class _SaveTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 50,
      child: ElevatedButton(
        key: const Key('newTripForm_save_button'),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<CreateTripCubit>().saveTrip().then((value) {
              showTopSnackBar(
                context,
                const CustomSnackBar.success(
                  message: 'Trip created',
                  icon: Icon(null),
                  backgroundColor: Color.fromRGBO(90, 23, 238, 1),
                ),
              );
              context.read<TripsCubit>().loadMyTrips();
              Navigator.of(context).pop(true);
            });
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: const Color.fromRGBO(90, 23, 238, 1),
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
}
