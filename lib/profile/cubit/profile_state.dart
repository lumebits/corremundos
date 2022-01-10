part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  ProfileState({
    Profile? profile,
    List<PlatformFile>? pickedFiles,
    bool? isLoading,
    bool? error,
  })  : profile = profile ?? Profile.empty,
        pickedFiles = pickedFiles ?? List.empty(),
        isLoading = isLoading ?? true,
        error = error ?? false;

  final Profile profile;
  final List<PlatformFile> pickedFiles;
  final bool isLoading;
  final bool error;

  ProfileState copyWith({
    Profile? profile,
    List<PlatformFile>? pickedFiles,
    bool? isLoading,
    bool? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      pickedFiles: pickedFiles ?? this.pickedFiles,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [profile, pickedFiles, isLoading, error];

  @override
  String toString() => 'TripsState { profile: $profile, '
      'pickedFiles: $pickedFiles isLoading: $isLoading, error: $error }';
}
