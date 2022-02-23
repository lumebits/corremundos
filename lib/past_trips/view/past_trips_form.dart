import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/past_trip_card_widget.dart';
import 'package:corremundos/common/widgets/trips_card_skeleton.dart';
import 'package:corremundos/past_trips/cubit/past_trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PastTripsForm extends BasePage {
  const PastTripsForm({Key? key}) : super(key);

  @override
  String title(BuildContext context) => 'Past Trips';

  @override
  List<BlocListener> listeners(BuildContext context) {
    return [
      BlocListener<PastTripsCubit, PastTripsState>(
        listenWhen: (previous, current) => previous.error != current.error,
        listener: (context, state) {
          if (state.error) {
            showTopSnackBar(
              context,
              const CustomSnackBar.info(
                message: 'Error loading past trips',
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
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  List<Widget>? actions(BuildContext context) => null;

  @override
  Widget widget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<PastTripsCubit, PastTripsState>(
                buildWhen: (previous, current) =>
                    previous.isLoading != current.isLoading ||
                    previous.isLoadingShared != current.isLoadingShared,
                builder: (context, state) {
                  if (state.isLoading || state.isLoadingShared) {
                    return ListView.separated(
                      itemCount: 3,
                      itemBuilder: (context, index) =>
                          const TripsCardSkeleton(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16 / 2),
                    );
                  } else {
                    final trips = state.pastTrips + state.sharedWithMePastTrips;
                    trips.sort((b1, b2) => b1.initDate.compareTo(b2.initDate));

                    if (trips.isNotEmpty) {
                      return state.isLoading || state.isLoadingShared
                          ? ListView.separated(
                              itemCount: 3,
                              itemBuilder: (context, index) =>
                                  const TripsCardSkeleton(),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16 / 2),
                            )
                          : ListView.separated(
                              itemCount: trips.length,
                              itemBuilder: (context, index) {
                                return PastTripCardWidget(trips[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16 / 2),
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
                                'No past trips!',
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
