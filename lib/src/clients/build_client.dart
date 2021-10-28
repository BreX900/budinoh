import 'dart:async';
import 'dart:io';

import 'package:budinoh/src/d_e.dart';
import 'package:path/path.dart';
import 'package:process_run/shell.dart';

class BuildClient {
  final shell = Shell();

  /// Call it every time it starts a build series with all different types
  Future<void> initProject() async {
    await _flutterClean();
    await _flutterPubGet();
  }

  /// Build apk
  Future<File> buildApk(String envName, String env, Directory outputDir) async {
    await shell.singleRun('flutter build apk --no-pub $env');

    // Move android build into output dir
    final buildFile = File('build/app/outputs/flutter-apk/app-release.apk');
    final buildFile1 = await buildFile.rename('${outputDir.path}/${basename(buildFile.path)}');
    return File(buildFile1.path);
  }

  /// Build appbundle
  Future<File> buildAppBundle(String envName, String env, Directory outputDir) async {
    await shell.singleRun('flutter build appbundle --no-pub $env');

    // Move android build into output dir
    final buildFile = File('build/app/outputs/bundle/release/app-release.aab');
    return await buildFile.rename('${outputDir.path}/${basename(buildFile.path)}');
  }

  /// Build ipa
  Future<File> buildIpa(
    String envName,
    String env,
    Directory outputDir, {
    required String exportOptions,
  }) async {
    await shell.singleRun('flutter build ipa --no-pub --export-options-plist=$exportOptions $env');

    // Move ios build into output dir
    final buildDir = await Directory('build/ios/ipa').list().toList();
    final buildFile = buildDir.singleWhere((file) => file.path.endsWith('ipa'));
    final buildFile1 = await buildFile.rename('${outputDir.path}/${basename(buildFile.path)}');
    return File(buildFile1.path);
  }

  /// Call when all builds is completed
  Future<void> disposeProject() async {
    await _flutterClean();
    await _flutterPubGet();
  }

  Future<void> _flutterClean() async => await shell.singleRun('flutter clean');

  Future<void> _flutterPubGet() async => await shell.singleRun('flutter pub get');
}
