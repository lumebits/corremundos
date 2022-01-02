import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(
          authRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    _userSubscription = _authRepository.user.listen(_onUserChanged);
    on<AppUserChanged>(
        (event, emit) => emit(_mapUserChangedToState(event, state)),);
    on<AppLogoutRequested>(
          (event, emit) => unawaited(_authRepository.logOut()),);
    on<NavigationRequested>(
          (event, emit) => emit(_mapNavigationToState(event, state)),);
    on<AppDeleteUserRequested>(
          (event, emit) => unawaited(_authRepository.deleteUser()),);
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<String?> _deepLinkSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  AppState _mapUserChangedToState(AppUserChanged event, AppState state) {
    return event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated();
  }

  AppState _mapNavigationToState(NavigationRequested event, AppState state) {
    return state.copyWith(appTab: event.appTab);
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _deepLinkSubscription.cancel();
    return super.close();
  }
}
