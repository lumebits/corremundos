import 'package:corremundos/app/bloc/app_bloc.dart';
import 'package:corremundos/common/widgets/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SettingsForm extends BasePage {
  const SettingsForm({Key? key}) : super(key);

  @override
  String title(BuildContext context) => 'Settings';

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  Widget widget(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    title: Text('Profile'),
                    leading: const Icon(Icons.edit_rounded),
                    onTap: () {
                      /*Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (context) => const EditProfilePage(),
                      ),);*/
                    },
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    title: Text('Delete account'),
                    leading: const Icon(Icons.warning_rounded),
                    onTap: () => _deleteAllDataConfirmation(context),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LogOutButton(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

Future<bool> _deleteAllDataConfirmation(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        title: Text('Do you want to delete your account and lose all your trips and data?'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: OutlinedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                key: const Key('deleteAccount_discard_iconButton'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              )),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  key: const Key('deleteAccount_save_iconButton'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      );
    },
  ).then((value) {
    if (value == true) {
      // TODO(palomapiot): delete all trips

      context.read<AppBloc>().add(AppDeleteUserRequested());
      Navigator.of(context).pop();
      showTopSnackBar(
        context,
        const CustomSnackBar.success(
          message: 'Account deleted',
          icon: Icon(null),
          backgroundColor: Color.fromRGBO(90, 23, 238, 1),
        ),
      );
    } else {
      showTopSnackBar(
        context,
        const CustomSnackBar.success(
          message: 'Action cancelled',
          icon: Icon(null),
          backgroundColor: Color.fromRGBO(90, 23, 238, 1),
        ),
      );
    }
    return true;
  });
}

class _LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
        key: const Key('homePage_logout_iconButton'),
        onPressed: () => {
          context.read<AppBloc>().add(AppLogoutRequested()),
          Navigator.of(context).pop()
        },
        child: const Text(
          'Log out',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
        ),
      ),
    );
  }
}