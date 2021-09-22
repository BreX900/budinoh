import 'dart:io';

import 'package:args/args.dart';
import 'package:budinoh/budinoh.dart';
import 'package:checked_yaml/checked_yaml.dart';
import 'package:console/console.dart';
import 'package:path/path.dart';
import 'package:queue/queue.dart';

final argsParser = ArgParser()
  ..addOption('settings',
      abbr: 's', defaultsTo: 'dispenser.yaml', valueHelp: 'Define a yaml file path.')
  ..addFlag('verbose', abbr: 'v', defaultsTo: false, help: 'Print more logs')
  ..addFlag('apk', defaultsTo: true, negatable: true, help: 'Disable apk build.')
  ..addFlag('appbundle', defaultsTo: true, negatable: true, help: 'Disable appbundle build.')
  ..addFlag('ipa', defaultsTo: true, negatable: true, help: 'Disable ipa build.')
  ..addFlag('help', abbr: 'h', defaultsTo: false, negatable: false);

final buildClient = BuildClient();
final projectClient = ProjectClient();
final distributionClient = DistributionClient();
final distributionQueue = Queue();

void main(List<String> rawArgs) async {
  final args = argsParser.parse(rawArgs);
  final canVerbose = args['verbose'] as bool;
  final settingsPath = args['settings'] as String;
  final envNames = args.rest;
  final canBuildApk = args['apk'] as bool;
  final canBuildAppbundle = args['appbundle'] as bool;
  final canBuildIpa = args['ipa'] as bool;
  final askHelp = args['help'] as bool;

  if (askHelp) {
    print('budinoh [env names] Define which env names to process. Default: Process all env files.');
    print(argsParser.usage);
    exit(0);
  }

  Print.workInfo('Initializing work space...');

  final settings = await loadSettings(settingsPath);
  if (canVerbose) {
    Print.verbose(MinimalStringifier(
      identity: ' ',
      lineBreak: '\n',
    ).stringify(settings));
  }
  final allReleaseNotes = await projectClient.readReleaseNotes();
  final projectVersion = await projectClient.readVersion();
  final releaseNotes = allReleaseNotes[projectVersion];
  if (releaseNotes == null) {
    Print.error('Not find Release Notes for "$projectVersion" project version');
    exit(-1);
  }
  Print.spaceInfo('Release notes:\n$releaseNotes');

  final outputDir = Directory('build_output');
  if (await outputDir.exists()) {
    await outputDir.delete(recursive: true);
  }
  await outputDir.create();
  Print.spaceInfo('Output directory: ${outputDir.path}');

  var envBuilds = settings.builds.entries;
  if (envNames.isNotEmpty) {
    envBuilds = envBuilds.where((build) {
      return envNames.contains(envName(basename(build.key)));
    }).toList();
  }

  Print.spaceInfo('Builds: ${envBuilds.map((e) {
    return '${e.key}${e.value.builds.map((e) => e.name).join(',')}';
  }).join(' ')}');

  Print.workInfo('Initialized work space!');

  for (final entry in envBuilds) {
    final envFile = entry.key;
    final envBuilds = entry.value;

    Print.workInfo('$envFile: Initializing project...');
    await buildClient.init();
    final env = await projectClient.readEnv(file: envFile);

    final outputEnvDir = Directory(join(outputDir.path, envName(envFile)));
    await outputEnvDir.create();

    final builds = [
      if (canBuildApk && envBuilds.apk != null) envBuilds.apk!,
      if (canBuildAppbundle && envBuilds.appbundle != null) envBuilds.appbundle!,
      if (canBuildIpa && envBuilds.ipa != null) envBuilds.ipa!,
    ];

    await Future.wait(builds.map((build) async {
      return await _buildAndUpload(build, envFile, env, outputEnvDir, releaseNotes);
    }));
  }

  Print.workInfo('Builds Completed! Cleaning project...');
  await buildClient.dispose();

  Print.workInfo('Wait Distribution...');
  await distributionQueue.onComplete;
  Print.workInfo('Distribution Completed!');
}

Future<File> _build(BuildSettings build, String envFile, String env, Directory outputDir) async {
  if (build is ApkSettings) {
    return await buildClient.buildApk(envFile, env, outputDir);
  } else if (build is AppBundleSettings) {
    return await buildClient.buildAppBundle(envFile, env, outputDir);
  } else if (build is IpaSettings) {
    return await buildClient.buildIpa(envFile, env, outputDir, exportOptions: build.exportOptions);
  }
  throw 'Not support';
}

Future<void> _buildAndUpload(
  BuildSettings build,
  String envFile,
  String env,
  Directory outputDir,
  String releaseNotes,
) async {
  Print.workInfo('${build.runtimeType}-$envFile: Building...');
  final buildFile = await _build(build, envFile, env, outputDir);
  Print.workInfo('${build.runtimeType}-$envFile: Built!!!');

  final firebase = build.firebase;
  if (firebase != null) {
    distributionQueue.add(() async {
      Print.workInfo('${build.runtimeType}-$envFile: Uploading to Firebase...');
      await distributionClient.uploadToFirebase(
        buildFile,
        appId: firebase.appId,
        groups: firebase.groups,
        releaseNotes: releaseNotes,
      );
      Print.workInfo('${build.runtimeType}-$envFile: Uploaded to Firebase!!!');
    });
  }
  final appleStore = build.appleStore;
  if (appleStore != null) {
    distributionQueue.add(() async {
      Print.workInfo('${build.runtimeType}-$envFile: Uploading to AppleStore...');
      await distributionClient.uploadToAppleStore(
        buildFile,
        username: appleStore.username,
        password: appleStore.password,
      );
      Print.workInfo('${build.runtimeType}-$envFile: Uploaded to AppleStore!!!');
    });
  }
  final googleStore = build.googleStore;
  if (googleStore != null) {
    // TODO: Upload to play store
  }
}

Future<DispenserSettings> loadSettings(String settingsPath) async {
  try {
    final settingsFile = File(settingsPath);

    return checkedYamlDecode(
      await settingsFile.readAsString(),
      _constructEnvSettingsFromYaml,
      sourceUrl: Uri.file(settingsPath),
    );
  } on ParsedYamlException catch (error) {
    Print.error(error.formattedMessage!);
    exit(-1);
  }
}

DispenserSettings _constructEnvSettingsFromYaml(Map? yamlMap) {
  return DispenserSettings.fromJson(yamlMap!);
}

String envName(String env) => env.replaceFirst('.env.', '');

class Print {
  static void verbose(Object message) {
    Console.setTextColor(Color.YELLOW.id);
    Console.write('$message\n');
    Console.resetTextColor();
  }

  static void workInfo(Object message) {
    Console.setTextColor(Color.GREEN.id);
    Console.write('$message\n');
    Console.resetTextColor();
  }

  static void spaceInfo(Object message) {
    Console.setTextColor(Color.DARK_BLUE.id);
    Console.write('$message\n');
    Console.resetTextColor();
  }

  static void error(Object message) {
    Console.setTextColor(Color.RED.id);
    Console.write('$message\n');
    Console.resetTextColor();
  }
}
