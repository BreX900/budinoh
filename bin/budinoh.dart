import 'dart:io';

import 'package:args/args.dart';
import 'package:budinoh/budinoh.dart';
import 'package:checked_yaml/checked_yaml.dart';
import 'package:console/console.dart';
import 'package:path/path.dart';
import 'package:queue/queue.dart';

final argsParser = ArgParser()
  ..addFlag('apk', defaultsTo: true, negatable: true, help: 'Disable apk build.')
  ..addFlag('appbundle', defaultsTo: true, negatable: true, help: 'Disable appbundle build.')
  ..addFlag('ipa', defaultsTo: true, negatable: true, help: 'Disable ipa build.')
  ..addFlag('firebase', defaultsTo: true, negatable: true, help: 'Disable firebase deploy.')
  ..addFlag('google-store', defaultsTo: true, negatable: true, help: 'Disable google store deploy.')
  ..addFlag('apple-store', defaultsTo: true, negatable: true, help: 'Disable apple store deploy.')
  ..addOption('settings',
      abbr: 's', defaultsTo: 'budinoh.yaml', valueHelp: 'Define a yaml file path.')
  ..addFlag('verbose', abbr: 'v', defaultsTo: false, help: 'Print more logs')
  ..addFlag('help', abbr: 'h', defaultsTo: false, negatable: false);

void main(List<String> rawArgs) async {
  final args = argsParser.parse(rawArgs);

  if (args['help'] as bool) {
    print('budinoh [env names] Define which env names to process. Default: Process all env files.');
    print(argsParser.usage);
    exit(0);
  }

  Budinoh(
    envNames: args.rest,
    canBuildApk: args['apk'],
    canBuildAppbundle: args['appbundle'],
    canBuildIpa: args['ipa'],
    canDeployFirebase: args['firebase'],
    canDeployGoogleStore: args['google-store'],
    canDeployAppleStore: args['apple-store'],
    settingsPath: args['settings'],
    canVerbose: args['verbose'],
  ).call();
}

class Budinoh {
  final buildClient = BuildClient();
  final projectClient = ProjectClient();
  final distributionClient = DistributionClient();
  final distributionQueue = Queue();

  final List<String> envNames;
  final bool canBuildApk;
  final bool canBuildAppbundle;
  final bool canBuildIpa;
  final bool canDeployFirebase;
  final bool canDeployGoogleStore;
  final bool canDeployAppleStore;
  final String settingsPath;
  final bool canVerbose;

  Budinoh({
    required this.envNames,
    required this.canBuildApk,
    required this.canBuildAppbundle,
    required this.canBuildIpa,
    required this.canDeployFirebase,
    required this.canDeployGoogleStore,
    required this.canDeployAppleStore,
    required this.settingsPath,
    required this.canVerbose,
  });

  Future<void> call() async {
    Print.workInfo('Initializing work space...');
    // Load yaml files
    final settings = await ToolBox.loadYaml(File(settingsPath), PackageSettings.fromYaml);
    if (canVerbose) {
      Print.verbose(Stringifier.minimal(
        identity: ' ',
        lineBreak: '\n',
      ).stringify(settings));
    }

    // Find release notes for this relase
    final allReleaseNotes = await projectClient.readReleaseNotes();
    final projectVersion = await projectClient.readVersion();
    final releaseNotes = allReleaseNotes[projectVersion];
    if (releaseNotes == null) {
      Print.error('Not find Release Notes for "$projectVersion" project version');
      exit(-1);
    }
    Print.spaceInfo('Release notes:\n$releaseNotes');

    // Create output builds directory
    final outputDir = Directory('build_output');
    if (await outputDir.exists()) {
      await outputDir.delete(recursive: true);
    }
    await outputDir.create();
    Print.spaceInfo('Output directory: ${outputDir.path}');

    // Filter builds
    var envBuilds = settings.builds.entries;
    if (envNames.isNotEmpty) {
      envBuilds = envBuilds.where((build) {
        return envNames.contains(envName(basename(build.key)));
      }).toList();
    }

    Print.spaceInfo('Builds: ${envBuilds.map((e) {
      return '${e.key}(${e.value.builds.map((e) => e.name).join(',')})';
    }).join(' - ')}');

    Print.workInfo('Initialized work space!');

    for (final entry in envBuilds) {
      final envFile = entry.key;
      final envBuilds = entry.value;

      Print.workInfo('$envFile: Initializing project...');
      await buildClient.initProject();
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
    await buildClient.disposeProject();

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
      return await buildClient.buildIpa(envFile, env, outputDir,
          exportOptions: build.exportOptions);
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
    Print.workInfo('$envFile ${build.name}: Building...');
    final buildFile = await _build(build, envFile, env, outputDir);
    Print.workInfo('$envFile ${build.name}: Built!!!');

    final firebase = build.firebase;
    if (canDeployFirebase && firebase != null) {
      distributionQueue.add(() async {
        Print.workInfo('$envFile ${build.name}: Uploading to Firebase...');
        await distributionClient.uploadToFirebase(
          buildFile,
          appId: firebase.appId,
          groups: firebase.groups,
          releaseNotes: releaseNotes,
        );
        Print.workInfo('$envFile ${build.name}: Uploaded to Firebase!!!');
      });
    }
    final appleStore = build.appleStore;
    if (canDeployAppleStore && appleStore != null) {
      distributionQueue.add(() async {
        Print.workInfo('$envFile ${build.name}: Uploading to AppleStore...');
        await distributionClient.uploadToAppleStore(
          buildFile,
          username: appleStore.username,
          password: appleStore.password,
        );
        Print.workInfo('$envFile ${build.name}: Uploaded to AppleStore!!!');
      });
    }
    final googleStore = build.googleStore;
    if (canDeployGoogleStore && googleStore != null) {
      // TODO: Upload to play store
    }
  }

  String envName(String env) => env.replaceFirst('.env.', '');
}

class ToolBox {
  final File projectYaml = File('pubspec.yaml');
  final File packageYaml;

  ToolBox({required String name}) : packageYaml = File('$name.yaml');

  Future<File> findYaml(String? path) async {
    if (path != null) return File(path);

    if (await packageYaml.exists()) return packageYaml;

    return projectYaml;
  }

  static Future<T> loadYaml<T>(File file, T Function(Map map) from) async {
    if (!await file.exists()) {
      Print.error('Not find ${file.path} file in this project');
      exit(-1);
    }
    try {
      return checkedYamlDecode(
        await file.readAsString(),
        (map) => from(map!),
        sourceUrl: Uri.file(file.path),
      );
    } on ParsedYamlException catch (error) {
      Print.error(error.formattedMessage!);
      exit(-1);
    }
  }
}

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
