import 'dart:io';

import 'package:budinoh/src/d_e.dart';
import 'package:process_run/shell.dart';

class DistributionClient {
  final _shell = Shell();

  /// https://firebase.google.com/docs/app-distribution/android/distribute-cli
  Future<void> uploadToFirebase(
    File file, {
    required String appId,
    String releaseNotes = '',
    List<String> groups = const [],
  }) async {
    final command = StringBuffer('firebase appdistribution:distribute ${file.path} --app $appId');

    if (groups.isNotEmpty) {
      command
        ..write(' --groups "')
        ..write(groups.join(', '))
        ..write('"');
    }
    if (releaseNotes.isNotEmpty) {
      command
        ..write(' --release-notes "')
        ..write(releaseNotes.replaceAll('"', '\'').split('\n').join('\\n'))
        ..write('"');
    }

    await _shell.singleRun(command.toString());
  }

  Future<void> uploadToAppleStore(
    File file, {
    required String username,
    required String password,
  }) async {
    await _shell.singleRun('xcrun altool --upload-app -f ${file.path} -u $username -p $password');
  }
}
