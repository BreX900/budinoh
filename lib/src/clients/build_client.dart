import 'dart:async';
import 'dart:io';

import 'package:budinoh/src/shell_extensions.dart';
import 'package:process_run/shell.dart';

class BuildClient {
  final shell = Shell();

  final String? env;
  final String? buildNumber;
  final String? buildName;

  BuildClient({
    this.env,
    this.buildNumber,
    this.buildName,
  });

  /// Call it every time it starts a build series with all different types
  Future<void> cleanAndPubGet() async {
    await _flutterClean();
    await _flutterPubGet();
  }

  Future<File> buildApk({String? env, String? args}) async {
    await shell.singleRun('flutter build apk --no-pub', _buildArgs(env: env, args: args));

    return File('build/app/outputs/flutter-apk/app-release.apk');
  }

  Future<File> buildAppBundle({String? env, String? args}) async {
    await shell.singleRun('flutter build appbundle --no-pub', _buildArgs(env: env, args: args));

    return File('build/app/outputs/bundle/release/app-release.aab');
  }

  Future<File> buildIpa({
    String? exportOptions,
    String? env,
    String? args,
  }) async {
    await shell.singleRun('flutter build ipa --no-pub', [
      if (exportOptions != null) '--export-options-plist=$exportOptions',
      ..._buildArgs(env: env, args: args),
    ]);

    final buildDir = await Directory('build/ios/ipa').list().toList();
    return File(buildDir.singleWhere((file) => file.path.endsWith('.ipa')).path);
  }

  Future<void> _flutterClean() async => await shell.singleRun('flutter clean');

  Future<void> _flutterPubGet() async => await shell.singleRun('flutter pub get');

  Iterable<String> _buildArgs({String? env, String? args}) {
    env ??= this.env;
    return [
      if (buildNumber != null) '--build-number=${buildNumber!}',
      if (buildName != null) '--build-name=${buildName!}',
      if (env != null) env,
      if (args != null) args,
    ];
  }
}
