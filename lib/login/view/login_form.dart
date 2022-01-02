import 'package:corremundos/counter/counter.dart';
import 'package:corremundos/login/cubit/login_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          showTopSnackBar(
            context,
            const CustomSnackBar.info(
              message: 'Authentication failed',
              icon: Icon(null),
              backgroundColor: Color.fromRGBO(90, 23, 238, 1),
            ),
          );
        } else if (state.status.isSubmissionSuccess) {
          /*Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const CounterPage();
              },
            ),
          );*/
          showTopSnackBar(
            context,
            const CustomSnackBar.info(
              message: 'OK',
              icon: Icon(null),
              backgroundColor: Color.fromRGBO(90, 23, 238, 1),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Corremundos',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 24),
                _EmailInput(),
                const SizedBox(height: 8),
                _PasswordInput(),
                const SizedBox(height: 24),
                _LoginButton(),
                const SizedBox(height: 24),
                _GoogleLoginButton(),
                const SizedBox(height: 24),
                _SignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          key: const Key('loginForm_emailInput_textField'),
          style: const TextStyle(
            fontSize: 20,
          ),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            labelText: 'Email',
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          key: const Key('loginForm_passwordInput_textField'),
          style: const TextStyle(
            fontSize: 20,
          ),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          keyboardType: TextInputType.text,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            labelText: 'Password',
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? SizedBox(
                width: 210,
                height: 50,
                child: ElevatedButton(
                  key: const Key('loginForm_login_raisedButton'),
                  onPressed: null,
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: 210,
                height: 50,
                child: ElevatedButton(
                  key: const Key('loginForm_login_raisedButton'),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInFormSubmitted()
                      : null,
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? SizedBox(
                width: 210,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    size: 17,
                  ),
                  key: const Key('loginForm_googleLogin_raisedButton'),
                  onPressed: null,
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  label: const Text(
                    'Log in with Google',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: 210,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    size: 17,
                  ),
                  key: const Key('loginForm_googleLogin_raisedButton'),
                  onPressed: state.status.isValidated
                      ? () =>
                          context.read<LoginCubit>().googleLogInFormSubmitted()
                      : null,
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  label: const Text(
                    'Log in with Google',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  key: const Key('loginForm_signUp_raisedButton'),
                  onPressed: null,
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  key: const Key('loginForm_signUp_raisedButton'),
                  onPressed: () => print('go to sign up'),
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
