import 'package:corremundos/login/cubit/login_cubit.dart';
import 'package:corremundos/login/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          showTopSnackBar(
            context,
            const CustomSnackBar.info(
              message: 'Registration failed',
              icon: Icon(null),
              backgroundColor: Color.fromRGBO(90, 23, 238, 1),
            ),
          );
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).popUntil((route) => route.isFirst);
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
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Corremundos',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: GoogleFonts.sedgwickAve().fontFamily,
                      ),
                    ),
                    const Image(
                      image: AssetImage('assets/corremundos_logo.png'),
                      height: 150,
                    ),
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
                              'Create an account',
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
                        _SignUpButton(),
                        const SizedBox(height: 24),
                        _LogInButton(),
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
          key: const Key('registrationForm_emailInput_textField'),
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
          key: const Key('registrationForm_passwordInput_textField'),
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

class _SignUpButton extends StatelessWidget {
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
                  key: const Key('registrationForm_signup_raisedButton'),
                  onPressed: null,
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text(
                    'Sign Up',
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
                  key: const Key('registrationForm_signup_raisedButton'),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().signUpFormSubmitted()
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    primary: const Color.fromRGBO(90, 23, 238, 1),
                  ),
                  child: const Text(
                    'Sign Up',
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

class _LogInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(
          child: Text(
            'Already have an account?',
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
                  return const LoginPage();
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
              'Sign In',
              textScaleFactor: 0.85,
            ),
          ),
        )
      ],
    );
  }
}
