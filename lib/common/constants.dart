import 'package:flutter/material.dart';

class Constants {
  // general
  static const Color actionsIconColor = Colors.grey;
  static const Color corremundosColor = Color.fromRGBO(90, 23, 238, 1);
  static const double textFieldFontSize = 20;
  static const double dialogBorderRadius = 25;
  static const double regularPadding = 16;
  static const double attachedFileMaxHeight = 440;

  static const textFieldStyle = TextStyle(
    fontSize: textFieldFontSize,
    color: corremundosColor,
  );

  static const textFieldLabelStyle = TextStyle(
    color: Colors.grey,
  );

  // Trip card
  static const double tripCardWidth = 200 * 1.85;
  static const double tripCardHeight = 200;
  static const double cardBorderRadius = 25;
  static const double margin = 15;
  static const double marginInternal = 10;
  static const double cardElevation = 9;
  static const Color cardShadowColor = Colors.black54;
  static const double cardTextPadding = 16;
  static const double tripCardMessageFontSize = 12;
  static const double tripCardMessageIconFontSize = 14;

  // trip options
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String share = 'Share';

  static const List<String> pastTripsChoices = <String>[
    delete,
  ];

  static const List<String> tripsChoices = <String>[
    edit,
    delete,
    share,
  ];

  // event widget
  static const double eventTimelineIconSize = 20;
}
