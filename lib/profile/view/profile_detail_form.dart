import 'package:cached_network_image/cached_network_image.dart';
import 'package:corremundos/common/blocs/load_pdf/load_pdf_cubit.dart';
import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/common/widgets/navigation.dart';
import 'package:corremundos/profile/cubit/profile_cubit.dart';
import 'package:corremundos/profile/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!state.isLoading)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.profile.name != null && state.profile.name != ''
                        ? 'Welcome, ${state.profile.name}!'
                        : 'Welcome!',
                    style: const TextStyle(fontSize: 24),
                  ),
                )
              else
                const Center(),
              _Documents()
            ],
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
          previous.profile.documents != current.profile.documents ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox(
            height: 500,
            child: Center(
              child: SizedBox(
                height: 20,
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: [Color.fromRGBO(90, 23, 238, 1)],
                  backgroundColor: Colors.white10,
                  pathBackgroundColor: Colors.black,
                ),
              ),
            ),
          );
        } else if (state.profile.documents!.isEmpty) {
          return SizedBox(
            height: 500,
            child: Center(
              child: SizedBox(
                width: 280,
                height: 70,
                child: ElevatedButton.icon(
                  key: const Key('updateProfile_button'),
                  icon: const Icon(
                    Icons.person_rounded,
                    color: Color.fromRGBO(90, 23, 238, 1),
                    size: 22,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
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
                    'Update profile',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromRGBO(90, 23, 238, 1),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 500,
            child: ListView.builder(
              itemExtent: MediaQuery.of(context).size.width - (20 * 2),
              scrollDirection: Axis.horizontal,
              itemCount: state.profile.documents?.length,
              itemBuilder: (context, index) {
                return OtherDocuments(
                  fileUrl: state.profile.documents![index] as String,
                );
              },
            ),
          );
        }
      },
    );
  }
}

class OtherDocuments extends StatelessWidget {
  const OtherDocuments({
    Key? key,
    required this.fileUrl,
  }) : super(key: key);

  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    if (fileUrl.contains('.pdf?') || fileUrl.endsWith('.pdf')) {
      context.read<LoadPdfCubit>().load(fileUrl);
      return BlocBuilder<LoadPdfCubit, LoadPdfState>(
        builder: (context, state) {
          if (state.isLoading) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 100,
              ),
              child: const Center(
                child: SizedBox(
                  height: 20,
                  width: 100,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: [Color.fromRGBO(90, 23, 238, 1)],
                    backgroundColor: Colors.white10,
                    pathBackgroundColor: Colors.black,
                  ),
                ),
              ),
            );
          } else if (state.error) {
            return const Center(
              child: Text('Error loading file.'),
            );
          } else {
            return PdfViewer.openFile(
              state.path,
              params: const PdfViewerParams(
                panEnabled: false,
                maxScale: 30,
              ),
            );
          }
        },
      );
    } else {
      return InteractiveViewer(
        panEnabled: false,
        maxScale: 30,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(fileUrl),
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }
  }
}
