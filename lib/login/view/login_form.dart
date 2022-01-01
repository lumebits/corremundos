import 'package:corremundos/login/cubit/login_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          print('error');
        } else if (state.status.isSubmissionSuccess) {
          /*Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return MainPage();
            },
          ));*/
          print('go to main page');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
