import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:unsplash_client/unsplash_client.dart';

/// Loads [AppCredentials] from a json file with the given [fileName].
Future<AppCredentials> loadAppCredentialsFromFile({
  String fileName = 'assets/unsplash_credentials.json',
}) async {
  final content = await rootBundle.loadString(fileName);
  final jsonResult = jsonDecode(content) as Map<String, dynamic>;
  return AppCredentials.fromJson(jsonResult);
}
