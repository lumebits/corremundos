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

class DeepLinkChanged extends AppEvent {
  @visibleForTesting
  const DeepLinkChanged(this.link);

  final String? link;

  @override
  List<Object?> get props => [link];
}

class NavigationRequested extends AppEvent {
  const NavigationRequested(this.appTab);

  final AppTab appTab;

  @override
  List<Object> get props => [appTab];
}
