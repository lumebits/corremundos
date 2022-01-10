import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/profile/cubit/profile_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileForm extends BasePage {
  const ProfileForm({Key? key}) : super(key);

  @override
  String title(BuildContext context) => 'Your profile';

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  Widget widget(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
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
                        'Your profile',
                        style: TextStyle(fontSize: 24, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _NameInput(),
                  const SizedBox(height: 8),
                  _PickAndUploadFile(),
                  const SizedBox(height: 24),
                  _SaveProfile(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.profile.name != current.profile.name,
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          key: const Key('profileForm_nameInput_textField'),
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onChanged: (name) => context.read<ProfileCubit>().nameChanged(name),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            labelText: 'Name',
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
            prefixIcon: const Icon(
              Icons.person_rounded,
              color: Color.fromRGBO(90, 23, 238, 1),
            ),
          ),
        );
      },
    );
  }
}

class _PickAndUploadFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            key: const Key('profileForm_pickFiles_button'),
            icon: const Icon(
              Icons.cloud_upload_rounded,
              color: Color.fromRGBO(90, 23, 238, 1),
              size: 22,
            ),
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
                withData: true,
              );
              context.read<ProfileCubit>().filesChanged(result);
            },
            style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(242, 238, 255, 1),
              shadowColor: Colors.white10,
              elevation: 1,
              side: const BorderSide(
                width: 0.8,
                color: Color.fromRGBO(225, 220, 251, 1),
              ),
            ),
            label: const Text(
              'Attach documents',
              style: TextStyle(
                fontSize: 17,
                color: Color.fromRGBO(90, 23, 238, 1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.pickedFiles.isNotEmpty) {
              final files = <Text>[];
              for (final file in state.pickedFiles) {
                files.add(
                  Text(
                    '\u{2611} ${file.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: files,
              );
            } else {
              return const Center();
            }
          },
        ),
      ],
    );
  }
}

class _SaveProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 50,
      child: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return ElevatedButton(
            key: const Key('profileForm_save_button'),
            onPressed: () => !state.isLoading
                ? context.read<ProfileCubit>().save().then((value) {
                    showTopSnackBar(
                      context,
                      const CustomSnackBar.success(
                        message: 'Profile updated',
                        icon: Icon(null),
                        backgroundColor: Color.fromRGBO(90, 23, 238, 1),
                      ),
                    );
                    context.read<ProfileCubit>().loadProfile();
                    Navigator.of(context).pop(true);
                  })
                : null,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              primary: !state.isLoading
                  ? const Color.fromRGBO(90, 23, 238, 1)
                  : Colors.grey,
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}