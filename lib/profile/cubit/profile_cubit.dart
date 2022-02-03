import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:profile_repository/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileRepository, this.authRepository)
      : super(ProfileState());

  final ProfileRepository profileRepository;
  final AuthRepository authRepository;

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));
    await profileRepository
        .getProfile(authRepository.currentUser.id)
        .then((profile) {
      emit(
        state.copyWith(
          profile: profile,
          isLoading: false,
        ),
      );
    }).catchError((dynamic error) {
      emit(state.copyWith(error: true, isLoading: false));
    });
  }

  Future<void> save() async {
    emit(state.copyWith(isLoading: true));
    await uploadFiles().then((val) {
      final profile = Profile(
        uid: authRepository.currentUser.id,
        id: state.profile.id,
        name: state.profile.name,
        documents: state.profile.documents,
      );
      profileRepository.updateOrCreateProfile(
        profile,
        authRepository.currentUser.id,
      );
      emit(state.copyWith(isLoading: false));
    });
  }

  Future<void> uploadFiles() async {
    final existingFiles = state.profile.documents;
    final uploadedFiles = <String>[];
    if (state.pickedFiles.isNotEmpty) {
      for (final file in state.pickedFiles) {
        if (file.bytes != null) {
          await profileRepository
              .uploadFileToStorage(
            file.bytes!,
            file.name,
            authRepository.currentUser.id,
          )
              .then((file) {
            if (file != null) {
              uploadedFiles.add(file);
              final totalFiles = existingFiles! + uploadedFiles;
              final profile = state.profile.copyWith(documents: totalFiles);
              emit(state.copyWith(profile: profile, pickedFiles: []));
            } else {
              emit(state.copyWith(isLoading: false, error: true));
            }
          });
        }
      }
    }
  }

  Future<void> nameChanged(String value) async {
    final profile = state.profile.copyWith(name: value);
    emit(
      state.copyWith(profile: profile),
    );
  }

  Future<void> filesChanged(FilePickerResult? result) async {
    if (result != null) {
      final files = result.files.map<PlatformFile>((file) => file).toList();
      final totalFiles = state.pickedFiles + files;
      emit(
        state.copyWith(
          pickedFiles: totalFiles,
        ),
      );
    }
  }

  Future<void> deleteFile(String fileName) async {
    await profileRepository.deleteFile(authRepository.currentUser.id, fileName);
  }

  Future<void> deleteProfile() async {
    await profileRepository.deleteProfile(authRepository.currentUser.id);
  }
}
