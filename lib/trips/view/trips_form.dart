import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/common/widgets/trip_card_widget.dart';
import 'package:corremundos/common/widgets/trips_card_skeleton.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TripsForm extends BasePage {
  const TripsForm({Key? key}) : super(key, appTab: AppTab.trips);

  @override
  String title(BuildContext context) => 'My Trips';

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
                message: 'Error loading trips',
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
  bool avoidBottomInset() => false;

  @override
  Widget widget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<TripsCubit, TripsState>(
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
                    final trips = state.myTrips + state.sharedWithMeTrips;
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
                                return TripCardWidget(trips[index]);
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
                                'No future trips!',
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
