import 'dart:io';

import 'package:budinoh/src/d_e.dart';
import 'package:process_run/shell.dart';
import 'package:pubspec/pubspec.dart';

class ProjectClient {
  final Shell _shell;

  ProjectClient({
    String? directory,
  }) : _shell = Shell(workingDirectory: directory);

  Future<String> readEnv({String file = ''}) async {
    final command = StringBuffer('dart pub global run define_env');
    if (file.isNotEmpty) {
      command.write(' -f $file');
    }

    final res = await _shell.singleRun(command.toString());

    return res.outText;
  }

  Future<Map<String, String>> readReleaseNotes() async {
    final changeLog = await File('CHANGELOG.md').readAsString();

    final _versions = <String, List<String>>{};
    String _version = '';
    for (var line in changeLog.split('\n')) {
      line = line.trim();
      if (line.isEmpty) continue;

      final versionMatch = RegExp(r'## (\d\.\d\.\d)').firstMatch(line);
      if (versionMatch != null) {
        _version = versionMatch.group(1)!;
        _versions[_version] = [];
      }

      _versions[_version]?.add(line);
    }

    return _versions.map((key, value) => MapEntry(key, value.join('\n')));
  }

  Future<String> readVersion() async {
    final pubSpec = await PubSpec.load(Directory(_shell.path));
    final version = pubSpec.version!;
    return '${version.major}.${version.minor}.${version.patch}';
  }
}
