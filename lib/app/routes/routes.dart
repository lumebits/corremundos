import 'package:corremundos/app/bloc/app_bloc.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/login/login.dart';
import 'package:flutter/cupertino.dart';

List<Page> onGenerateAppViewPages(AppState state, List<Page<dynamic>> pages) {
  switch (state.status) {
    case AppStatus.authenticated:
      switch (state.appTab) {
        case AppTab.trips:
        //return [MyTrips.page()];
        case AppTab.current:
        //return [CurrentTrip.page()];
        case AppTab.calendar:
        //return [Calendar.page()];
        case AppTab.settings:
        //return [Settings.page()];
        case AppTab.addTrip:
        //return [AddTrip.page()];
        // TODO
      }
      return [LoginPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
