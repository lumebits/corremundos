part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.appTab = AppTab.trips,
    this.deepLink,
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final AppTab appTab;
  final String? deepLink;

  AppState copyWith({
    AppTab? appTab,
    String? deepLink,
  }) {
    return AppState._(
      status: status,
      user: user,
      appTab: appTab ?? this.appTab,
      deepLink: deepLink ?? this.deepLink,
    );
  }

  @override
  List<Object?> get props => [status, user, appTab, deepLink];
}
