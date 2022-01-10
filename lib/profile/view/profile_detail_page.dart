import 'package:corremundos/profile/view/profile_detail_form.dart';
import 'package:corremundos/profile/view/profile_form.dart';
import 'package:flutter/material.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProfileDetailPage());

  @override
  Widget build(BuildContext context) {
    return const ProfileDetailForm();
  }
}
