import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:profile_repository/profile_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository, this.profileRepository)
      : super(const LoginState());

  final AuthRepository _authRepository;
  final ProfileRepository profileRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> logInFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> googleLogIn() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.logInWithGoogle().then((value) {
        final uid = _authRepository.currentUser.id;
        profileRepository.getProfile(uid).then((p) {
          if (p.isEmpty) {
            final profile = Profile(
              uid: uid,
              name: '',
              email: _authRepository.currentUser.email,
              documents: const <String>[],
            );
            profileRepository.updateOrCreateProfile(
              profile,
              _authRepository.currentUser.id,
            );
          }
        });
      });
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository
          .signUp(
        email: state.email.value,
        password: state.password.value,
      )
          .then((value) {
        final profile = Profile(
          uid: _authRepository.currentUser.id,
          name: '',
          email: _authRepository.currentUser.email,
          documents: const <String>[],
        );
        profileRepository.updateOrCreateProfile(
          profile,
          _authRepository.currentUser.id,
        );
      });
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
