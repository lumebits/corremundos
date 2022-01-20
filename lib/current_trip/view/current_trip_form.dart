import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/common/widgets/selected_day_trip_data.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CurrentTripForm extends BasePage {
  const CurrentTripForm({Key? key}) : super(key, appTab: AppTab.current);

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<TripsCubit, TripsState>(
        builder: (context, state) {
          return FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'Trip to ${state.currentTrip.name}',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 24,
              ),
            ),
          );
        },
      ),
      centerTitle: true,
      actions: actions(context),
      elevation: 0,
      backgroundColor: Colors.white10,
      iconTheme: const IconThemeData(color: Colors.black54),
    );
  }

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
  bool avoidBottomInset() => true;

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
            Expanded(
              child: BlocBuilder<TripsCubit, TripsState>(
                builder: (context, state) {
                  if (state.currentTrip.isNotEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.tripDays,
                      itemBuilder: (context, index) {
                        final calendarDay = state.currentTrip.initDate
                            .add(Duration(days: index));
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
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const Color.fromRGBO(90, 23, 238, 1);
                                }
                                return Colors.grey;
                              }),
                            ),
                            child: Text(
                              'Day ${index + 1} - $day',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center();
                  }
                },
              ),
            ),
            Expanded(
              flex: 9,
              child: BlocBuilder<TripsCubit, TripsState>(
                buildWhen: (previous, current) =>
                    previous.currentTrip != current.currentTrip,
                builder: (context, state) {
                  if (state.currentTrip.isNotEmpty) {
                    return SelectedDayTripData(
                      trip: state.currentTrip,
                      index: state.currentDayIndex,
                      initTripDay: state.currentTrip.initDate,
                    );
                  } else {
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage('assets/noevents.png'),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'No current trip!',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color.fromRGBO(90, 23, 238, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
