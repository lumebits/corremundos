import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:corremundos/create_trip/create_trip.dart';
import 'package:corremundos/trip_detail/trip_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trips_repository/trips_repository.dart';

const double cardBorderRadius = 25;
const double margin = 15;
const double marginInternal = 10;

class TripCardWidget extends StatelessWidget {
  const TripCardWidget(this.trip, {Key? key}) : super(key: key);

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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) {
                      return TripDetailPage(trip);
                    },
                  ),
                );
              },
              onLongPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => CreateTripPage(trip: trip),
                  ),
                );
              },
              child: _cardText(trip),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardText(Trip trip) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: FractionalOffset.topLeft,
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      children: [
                        const WidgetSpan(
                          child: Icon(
                            Icons.access_time_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        TextSpan(
                          text: trip.initDate.difference(now).inDays > 0
                              ? ' ${trip.initDate.difference(now).inDays} '
                                  'days until take-off!'
                              : 'enjoy your trip!',
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
