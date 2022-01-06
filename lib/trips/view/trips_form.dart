import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/common/widgets/skeleton.dart';
import 'package:corremundos/common/widgets/trip_card_widget.dart';
import 'package:corremundos/create_trip/view/create_trip_page.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TripsForm extends BasePage {
  const TripsForm({Key? key}) : super(key, appTab: AppTab.trips);

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
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Future<bool> onWillPop(BuildContext context) => Future.value(false);

  @override
  bool avoidBottomInset() => false;

  @override
  Widget? floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const CreateTripPage(),
          ),
        );
      },
      elevation: 2,
      child: const Icon(Icons.add_rounded),
    );
  }

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
            Center(
              child: Text(
                'My Trips',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: BlocBuilder<TripsCubit, TripsState>(
                builder: (context, state) {
                  final trips = state.myTrips + state.sharedWithMeTrips;
                  return state.isLoading
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripsCardSkeleton extends StatelessWidget {
  const TripsCardSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Skeleton(height: 200, width: 170),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 16 / 2),
              Skeleton(width: 120),
              SizedBox(height: 100),
              Skeleton(width: 120),
              SizedBox(height: 16 / 2),
              Skeleton(width: 180),
              SizedBox(height: 16 / 2),
            ],
          ),
        )
      ],
    );
  }
}
