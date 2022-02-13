import 'package:auto_size_text/auto_size_text.dart';
import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/text_input.dart';
import 'package:corremundos/profile/cubit/profile_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

final _formKey = GlobalKey<FormState>();

class ProfileForm extends BasePage {
  const ProfileForm({Key? key}) : super(key);

  @override
  String title(BuildContext context) => 'Your profile';

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  Widget widget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
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
                const SizedBox(height: 24),
                _PickAndUploadFile(),
                const SizedBox(height: 24),
                _SaveProfile(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextInput(
      key: const Key('profileForm_nameInput_textField'),
      label: 'Name',
      initialValue: context.read<ProfileCubit>().state.profile.name!,
      iconData: Icons.person_rounded,
      onChanged: (newValue) async {
        await context.read<ProfileCubit>().nameChanged(newValue);
      },
      keyboardType: TextInputType.name,
    );
  }
}

class _PickAndUploadFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (previous, current) =>
              previous.profile.documents != current.profile.documents,
          builder: (context, state) {
            if (state.profile.documents != null &&
                state.profile.documents != <dynamic>[]) {
              final files = <Card>[];
              for (final file in state.profile.documents!) {
                var fileName = file as String;
                fileName = fileName.substring(0, fileName.indexOf('?alt'));
                fileName = fileName.split('%2F')[1];
                files.add(
                  Card(
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    elevation: 9,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 14,
                            child: AutoSizeText(
                              fileName,
                              maxLines: 1,
                              minFontSize: 8,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                              ),
                              color: Colors.grey,
                              onPressed: () {
                                showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      title: const Text(
                                        'Do you want to permanently'
                                        ' delete this file?',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: OutlinedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: const StadiumBorder(),
                                                ),
                                                key: const Key(
                                                  'deleteProfileFile_discard_B',
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: const StadiumBorder(),
                                                ),
                                                key: const Key(
                                                  'deleteProfileFile_delete_B',
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ).then((value) async {
                                  if (value == true) {
                                    await context
                                        .read<ProfileCubit>()
                                        .deleteFile(file)
                                        .then((value) {
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        context
                                            .read<ProfileCubit>()
                                            .loadProfile();
                                        showTopSnackBar(
                                          context,
                                          const CustomSnackBar.success(
                                            message: 'File deleted',
                                            icon: Icon(null),
                                            backgroundColor:
                                                Color.fromRGBO(90, 23, 238, 1),
                                          ),
                                        );
                                      });
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
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
        const SizedBox(
          height: 20,
        ),
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
              if (result != null &&
                  result.files.where((file) => file.size > 512000).isEmpty) {
                await context.read<ProfileCubit>().filesChanged(result);
              } else {
                return showTopSnackBar(
                  context,
                  const CustomSnackBar.error(
                    message: 'File size exceeded',
                    icon: Icon(null),
                    backgroundColor: Color.fromRGBO(90, 23, 238, 1),
                  ),
                );
              }
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
              final files = <AutoSizeText>[];
              for (final file in state.pickedFiles) {
                files.add(
                  AutoSizeText(
                    file.name,
                    maxLines: 1,
                    minFontSize: 8,
                    style: const TextStyle(
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox(
            height: 20,
            width: 100,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [Color.fromRGBO(90, 23, 238, 1)],
              backgroundColor: Colors.white10,
              pathBackgroundColor: Colors.black,
            ),
          );
        } else {
          return SizedBox(
            width: 210,
            height: 50,
            child: ElevatedButton(
              key: const Key('profileForm_save_button'),
              onPressed: () {
                if (_formKey.currentState!.validate() && !state.isLoading) {
                  context.read<ProfileCubit>().save().then((value) async {
                    showTopSnackBar(
                      context,
                      const CustomSnackBar.success(
                        message: 'Profile updated',
                        icon: Icon(null),
                        backgroundColor: Color.fromRGBO(90, 23, 238, 1),
                      ),
                    );
                    await context.read<ProfileCubit>().loadProfile();
                    Navigator.of(context).pop(true);
                  });
                }
              },
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
            ),
          );
        }
      },
    );
  }
}
