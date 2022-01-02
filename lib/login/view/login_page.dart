import 'package:auth_repository/auth_repository.dart';
import 'package:corremundos/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromRGBO(90, 23, 238, 1), // purple
            Color.fromRGBO(0, 177, 219, .8) // blue
          ],),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (_) => LoginCubit(context.read<AuthRepository>()),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
