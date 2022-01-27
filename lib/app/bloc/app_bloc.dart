import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authRepository, })
      : _authRepository = authRepository,
        super(
          authRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    _userSubscription = _authRepository.user.listen(_onUserChanged);

    // in app purchase
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _purchaseSubscription = purchaseUpdated.listen(
      (dynamic purchaseDetailsList) {
        _onPurchaseChanged(purchaseDetailsList as List<PurchaseDetails>);
      },
      onDone: () {
        _purchaseSubscription.cancel();
      },
      onError: (dynamic error) {
        // handle error here.
      },
    ) as StreamSubscription<List<PurchaseDetails>>;

    on<AppUserChanged>(
      (event, emit) => emit(_mapUserChangedToState(event, state)),
    );
    on<AppLogoutRequested>(
      (event, emit) => unawaited(_authRepository.logOut()),
    );
    on<NavigationRequested>(
      (event, emit) => emit(_mapNavigationToState(event, state)),
    );
    on<AppDeleteUserRequested>(
      (event, emit) => unawaited(_authRepository.deleteUser()),
    );
    on<PurchaseChanged>(
        (event, emit) => emit(_mapPurchaseToState(event, state)),
    );
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User> _userSubscription;
  late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  void _onPurchaseChanged(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      add(PurchaseChanged(purchaseDetails.status));
    }
  }


  AppState _mapUserChangedToState(AppUserChanged event, AppState state) {
    return event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated();
  }

  AppState _mapNavigationToState(NavigationRequested event, AppState state) {
    return state.copyWith(appTab: event.appTab);
  }

  AppState _mapPurchaseToState(PurchaseChanged event, AppState state) {
    // TODO: Pending = pending, error = error, purchased o restored
    //  --> primero verificar y luego otorgar
    // pendingCompletePurchase --> InAppPurchase.instance.completePurchase(purchaseDetails)
    return state.copyWith(purchaseStatus: event.purchaseStatus);
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _purchaseSubscription.cancel();
    return super.close();
  }
}
