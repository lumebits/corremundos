import 'dart:async';
import 'dart:developer';

import 'package:auth_repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corremundos/app/app.dart';
import 'package:corremundos/bootstrap.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:trips_repository/trips_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  final authRepository = AuthRepository();
  final firebaseProfileRepository = FirebaseProfileRepository();
  final firebaseTripsRepository = FirebaseTripsRepository();
  await authRepository.user.first;
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  await bootstrap(
    () => App(
      authRepository: authRepository,
      firebaseProfileRepository: firebaseProfileRepository,
      firebaseTripsRepository: firebaseTripsRepository,
    ),
  );
}
