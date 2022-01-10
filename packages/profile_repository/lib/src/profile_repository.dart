import 'dart:async';
import 'dart:typed_data';

import 'package:profile_repository/profile_repository.dart';

abstract class ProfileRepository {

  Future<Profile> getProfile(String uid);

  Future<void> updateOrCreateProfile(Profile profile, String uid);

  Future<String?> uploadFileToStorage(Uint8List uint8list, String name);

}
