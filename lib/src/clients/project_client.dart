import 'dart:io';

import 'package:process_run/shell.dart';
import 'package:pubspec/pubspec.dart';

class ProjectClient {
  final Shell _shell;

  ProjectClient({
    String? directory,
  }) : _shell = Shell(workingDirectory: directory);

  Future<String> readDartDefineFile({required String filePath}) async {
    if (!await File(filePath).exists()) throw StateError('Env file not exist $filePath');
    return '--dart-define-from-file=$filePath';
  }

  Future<Map<String, String>> readReleaseNotes() async {
    final changeLog = await File('CHANGELOG.md').readAsString();

    final versions = <String, List<String>>{};
    String version = '';
    for (var line in changeLog.split('\n')) {
      line = line.trim();
      if (line.isEmpty) continue;

      final versionMatch = RegExp(r'## (\d+\.\d+\.\d+)').firstMatch(line);
      if (versionMatch != null) {
        version = versionMatch.group(1)!;
        versions[version] = [];
      }

      versions[version]?.add(line);
    }

    return versions.map((key, value) => MapEntry(key, value.join('\n')));
  }

  Future<String> readVersion() async {
    final pubSpec = await PubSpec.load(Directory(_shell.path));
    final version = pubSpec.version!;
    return '${version.major}.${version.minor}.${version.patch}';
  }
}
