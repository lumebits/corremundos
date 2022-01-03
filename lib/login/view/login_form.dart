import 'package:corremundos/login/login.dart';
import 'package:corremundos/trips/view/trips_page.dart';
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
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) {
                return const TripsPage();
              },
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: Column(
                  children: const [
                    SizedBox(height: 24),
                    Text(
                      'Corremundos',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                //color: Colors.redAccent,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _EmailInput(),
                        const SizedBox(height: 8),
                        _PasswordInput(),
                        const SizedBox(height: 24),
                        _LoginButton(),
                        const SizedBox(height: 12),
                        const Divider(
                          color: Colors.grey,
                          height: 20,
                          thickness: 0.2,
                          indent: 15,
                          endIndent: 15,
                        ),
                        const SizedBox(height: 12),
                        _GoogleLoginButton(),
                        const SizedBox(height: 24),
                        _SignUpButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
            color: Color.fromRGBO(90, 23, 238, 1),
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
            prefixIcon: const Icon(
              Icons.email_rounded,
              color: Color.fromRGBO(90, 23, 238, 1),
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
            color: Color.fromRGBO(90, 23, 238, 1),
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
            prefixIcon: const Icon(
              Icons.vpn_key_rounded,
              color: Color.fromRGBO(90, 23, 238, 1),
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
        return state.status.isSubmissionInProgress || !state.status.isValidated
            ? SizedBox(
                width: 210,
                height: 50,
                child: ElevatedButton(
                  key: const Key('loginForm_login_raisedButton'),
                  onPressed: null,
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white70,
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
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    primary: const Color.fromRGBO(90, 23, 238, 1),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
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
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    size: 17,
                    color: Colors.white70,
                  ),
                  key: const Key('loginForm_googleLogin_raisedButton'),
                  onPressed: null,
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  label: const Text(
                    'Sign In with Google',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white70,
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    size: 17,
                    color: Color.fromRGBO(90, 23, 238, 1),
                  ),
                  key: const Key('loginForm_googleLogin_raisedButton'),
                  onPressed: () => context.read<LoginCubit>().googleLogIn(),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    primary: Colors.white,
                  ),
                  label: const Text(
                    'Sign In with Google',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(
          child: Text(
            'Don' 't have an account?',
            textScaleFactor: 0.85,
          ),
        ),
        Flexible(
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(left: 5),
              minimumSize: const Size(50, 30),
              alignment: Alignment.center,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => Navigator.of(context).push(
              PageRouteBuilder<void>(
                pageBuilder: (context, animation, anotherAnimation) {
                  return const RegistrationPage();
                },
                transitionsBuilder:
                    (context, animation, anotherAnimation, child) {
                  animation = CurvedAnimation(
                    curve: Curves.linear,
                    parent: animation,
                  );
                  return SlideTransition(
                    position: Tween(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            ),
            child: const Text(
              'Sign Up',
              textScaleFactor: 0.85,
            ),
          ),
        )
      ],
    );
  }
}
