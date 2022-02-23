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
    this.purchaseStatus,
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final AppTab appTab;
  final PurchaseStatus? purchaseStatus;

  AppState copyWith({
    AppTab? appTab,
    PurchaseStatus? purchaseStatus,
  }) {
    return AppState._(
      status: status,
      user: user,
      appTab: appTab ?? this.appTab,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
    );
  }

  @override
  List<Object?> get props => [status, user, appTab, purchaseStatus];
}
