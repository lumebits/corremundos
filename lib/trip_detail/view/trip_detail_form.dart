import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/common/widgets/selected_day_trip_data.dart';
import 'package:corremundos/trip_detail/cubit/trip_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TripDetailForm extends BasePage {
  const TripDetailForm({Key? key}) : super(key, appTab: AppTab.trips);

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<TripDetailCubit, TripDetailState>(
        builder: (context, state) {
          return FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'Trip to ${state.trip.name}',
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
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  Widget? bottomNavigationBar() => null;

  @override
  Widget widget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<TripDetailCubit, TripDetailState>(
                builder: (context, state) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.trip.duration,
                    itemBuilder: (context, index) {
                      final calendarDay =
                          state.trip.initDate.add(Duration(days: index));
                      final day = DateFormat('dd LLL').format(calendarDay);
                      return Padding(
                        padding: const EdgeInsets.all(6),
                        child: ElevatedButton(
                          onPressed: state.dayIndex == index
                              ? null
                              : () => {
                                    context
                                        .read<TripDetailCubit>()
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
                },
              ),
            ),
            Expanded(
              flex: 9,
              child: BlocBuilder<TripDetailCubit, TripDetailState>(
                buildWhen: (previous, current) =>
                    previous.trip != current.trip ||
                    previous.dayIndex != current.dayIndex,
                builder: (context, state) {
                  return SelectedDayTripData(
                    trip: state.trip,
                    index: state.dayIndex,
                    initTripDay: state.trip.initDate,
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
