import 'dart:async';

import 'package:profile_repository/profile_repository.dart';

abstract class ProfileRepository {

  Future<Profile> getProfile(String uid);

}
