import 'package:cached_network_image/cached_network_image.dart';
import 'package:corremundos/app/bloc/app_bloc.dart';
import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/date_time_input.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/common/widgets/text_input.dart';
import 'package:corremundos/create_trip/cubit/create_trip_cubit.dart';
import 'package:corremundos/past_trips/cubit/past_trips_cubit.dart';
import 'package:corremundos/profile/cubit/profile_cubit.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

final _formKey = GlobalKey<FormState>();

class CreateTripForm extends BasePage {
  const CreateTripForm({Key? key}) : super(key, appTab: AppTab.addTrip);

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  Widget? bottomNavigationBar() => null;

  @override
  List<Widget>? actions(BuildContext context) => null;

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
  Future<bool> onWillPop(BuildContext context) {
    context.read<AppBloc>().add(const NavigationRequested(AppTab.trips));
    return Future.value(true);
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
                if (context.read<TripsCubit>().state.myTrips.isEmpty &&
                        context
                            .read<PastTripsCubit>()
                            .state
                            .pastTrips
                            .isEmpty ||
                    context.read<ProfileCubit>().state.profile.id ==
                        '1ffb7652-f894-424f-92c6-e0a8744d4582' ||
                    context.read<ProfileCubit>().state.profile.id ==
                        'e7d73b2e-d75d-4d1f-a0d5-a6ff22e35bbc')
                  _SaveTrip()
                else
                  _NoMoreTrips()
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
    return BlocBuilder<CreateTripCubit, CreateTripState>(
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
              key: const Key('newTripForm_save_button'),
              onPressed: () {
                if (context.read<TripsCubit>().state.myTrips.isEmpty &&
                    _formKey.currentState!.validate()) {
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
      },
    );
  }
}

class _NoMoreTrips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTripCubit, CreateTripState>(
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
          return Column(
            children: [
              SizedBox(
                width: 210,
                height: 50,
                child: ElevatedButton(
                  key: const Key('newTripForm_noMoreTrips_button'),
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'You are only allowed to have one trip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                child: Text(
                  "If you don't have a future trip, go to Settings "
                  'and delete your past trip in order to add a new one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
