import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:trips_repository/trips_repository.dart';

const double cardBorderRadius = 25;
const double margin = 15;
const double marginInternal = 10;

class PastTripCardWidget extends StatelessWidget {
  const PastTripCardWidget(this.trip, {Key? key}) : super(key: key);

  final Trip trip;

  static const double _cardElevation = 9;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200 * 1.85,
        height: 200,
        child: Card(
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardBorderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: _cardElevation,
          child: Ink(
            decoration: _cardDecoration(trip.imageUrl),
            child: InkWell(
              child: _cardText(trip, context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardText(Trip trip, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: FractionalOffset.topLeft,
                  child: Column(
                    children: const [
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.access_time_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            TextSpan(
                              text: ' hope you enjoyed it!',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.topRight,
                  child: Column(
                    children: [
                      PopupMenuButton<String>(
                        key: const Key('trip_menu_popupMenu'),
                        padding: EdgeInsets.zero,
                        onSelected: (value) =>
                            choiceAction(value, trip, context),
                        itemBuilder: (BuildContext context) {
                          return Constants.choices.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                        child: const SizedBox(
                          height: 20,
                          width: 20,
                          child: Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    '${DateFormat('dd LLL').format(trip.initDate)} - '
                    '${DateFormat('dd LLL').format(trip.endDate)} '
                    '· ${trip.endDate.difference(trip.initDate).inDays + 1} '
                    'days',
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  AutoSizeText(
                    'Trip to ${trip.name}',
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                          // bottomLeft
                          offset: Offset(-1, -1),
                          color: Colors.black26,
                        ),
                        Shadow(
                          // bottomRight
                          offset: Offset(1, -1),
                          color: Colors.black26,
                        ),
                        Shadow(
                          // topRight
                          offset: Offset(1, 1),
                          color: Colors.black26,
                        ),
                        Shadow(
                          // topLeft
                          offset: Offset(-1, 1),
                          color: Colors.black26,
                        ),
                      ],
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Decoration _cardDecoration(String imageUrl) {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: CachedNetworkImageProvider(imageUrl),
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.38),
          BlendMode.darken,
        ),
      ),
    );
  }
}

class Constants {
  static const String delete = 'Delete';

  static const List<String> choices = <String>[
    delete,
  ];
}

void choiceAction(String choice, Trip trip, BuildContext context) {
  if (choice == Constants.delete) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text(
            'Do you want to delete this trip?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    key: const Key('deleteTrip_discard_iconButton'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    key: const Key('deleteTrip_delete_iconButton'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        context.read<TripsCubit>().deleteTrip(trip).then((value) {
          showTopSnackBar(
            context,
            const CustomSnackBar.success(
              message: 'Trip deleted',
              icon: Icon(null),
              backgroundColor: Color.fromRGBO(90, 23, 238, 1),
            ),
          );
        });
      }
      return true;
    });
  }
}
