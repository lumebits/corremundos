part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppLogoutRequested extends AppEvent {}

class AppDeleteUserRequested extends AppEvent {}

class AppUserChanged extends AppEvent {
  @visibleForTesting
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class PurchaseChanged extends AppEvent {
  @visibleForTesting
  const PurchaseChanged(this.purchaseStatus);

  final PurchaseStatus purchaseStatus;

  @override
  List<Object> get props => [purchaseStatus];
}

class NavigationRequested extends AppEvent {
  const NavigationRequested(this.appTab);

  final AppTab appTab;

  @override
  List<Object> get props => [appTab];
}
