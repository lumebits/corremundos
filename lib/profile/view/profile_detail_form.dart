import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/profile/cubit/profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProfileDetailForm extends BasePage {
  const ProfileDetailForm({Key? key}) : super(key, appTab: AppTab.profile);

  @override
  String title(BuildContext context) => 'Your profile';

  @override
  List<BlocListener> listeners(BuildContext context) {
    return [
      BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => previous.error != current.error,
        listener: (context, state) {
          if (state.error) {
            showTopSnackBar(
              context,
              const CustomSnackBar.info(
                message: 'Error loading your profile',
                icon: Icon(null),
                backgroundColor: Color.fromRGBO(90, 23, 238, 1),
              ),
            );
          }
        },
      ),
    ];
  }

  @override
  bool avoidBottomInset() => true;

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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        state.profile.name != null && state.profile.name != ''
                            ? 'Your profile, ${state.profile.name}!'
                            : 'Your profile',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Documents()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Documents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.profile.documents != current.profile.documents,
      builder: (context, state) {
        if (state.profile.documents!.isEmpty) {
          return const Center();
        } else if (state.profile.documents?.length == 1) {
          return const Text('Show one doc');
        } else {
          return const Text('Show multiple doc');
        }
      },
    );
  }
}
