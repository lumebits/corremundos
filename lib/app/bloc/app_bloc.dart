import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_links/uni_links.dart';
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
    _deepLinkSubscription = linkStream.listen(_onDeepLinkChanged);
    checkInitialLink();
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<String?> _deepLinkSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  void _onDeepLinkChanged(String? link) {
    if (link != null) {
      add(DeepLinkChanged(link));
    }
  }

  Future<void> checkInitialLink() async {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      add(DeepLinkChanged(initialLink));
    }
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppUserChanged) {
      yield _mapUserChangedToState(event, state);
    } else if (event is DeepLinkChanged) {
      yield _mapDeepLinkChangedToState(event, state);
    } else if (event is AppLogoutRequested) {
      unawaited(_authRepository.logOut());
    } else if (event is NavigationRequested) {
      yield _mapNavigationToState(event, state);
    } else if (event is AppDeleteUserRequested) {
      unawaited(_authRepository.deleteUser());
    }
  }

  AppState _mapUserChangedToState(AppUserChanged event, AppState state) {
    return event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated();
  }

  AppState _mapDeepLinkChangedToState(DeepLinkChanged event, AppState state) {
    return state.copyWith(deepLink: event.link);
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
