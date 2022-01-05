import 'package:corremundos/app/bloc/app_bloc.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/current_trip/view/current_trip_page.dart';
import 'package:corremundos/login/login.dart';
import 'package:corremundos/trips/view/trips_page.dart';
import 'package:flutter/cupertino.dart';

List<Page> onGenerateAppViewPages(AppState state, List<Page<dynamic>> pages) {
  switch (state.status) {
    case AppStatus.authenticated:
      switch (state.appTab) {
        case AppTab.trips:
          return [TripsPage.page()];
        case AppTab.current:
          return [CurrentTripPage.page()];
        case AppTab.calendar:
        //return [Calendar.page()];
        case AppTab.settings:
        //return [Settings.page()];
        case AppTab.addTrip:
        //return [AddTrip.page()];
      }
      return [TripsPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
