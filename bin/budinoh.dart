import 'dart:async';
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
  ..addOption('build-number',
      help: 'An identifier used as an internal version number.\n'
          'Each build must have a unique identifier to differentiate it from previous builds.\n'
          'It is used to determine whether one build is more recent than another, with higher numbers indicating more recent build.\n'
          'On Android it is used as "versionCode".\n'
          'On Xcode builds it is used as "CFBundleVersion".\n'
          'On Windows it is used as the build suffix for the product and file versions.')
  ..addOption('build-name',
      help: 'A "x.y.z" string used as the version number shown to users.\n'
          'For each new version of your app, you will provide a version number to differentiate it from previous versions.\n'
          'On Android it is used as "versionName".\n'
          'On Xcode builds it is used as "CFBundleShortVersionString".')
  ..addFlag('changelog', defaultsTo: false, help: 'Read release version from changelog.')
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
    buildNames: args.rest,
    canBuildApk: args['apk'],
    canBuildAppbundle: args['appbundle'],
    canBuildIpa: args['ipa'],
    canDeployFirebase: args['firebase'],
    canDeployGoogleStore: args['google-store'],
    canDeployAppleStore: args['apple-store'],
    buildNumber: args['build-number'],
    buildName: args['build-name'],
    canUseChangelog: args['changelog'],
    settingsPath: args['settings'],
    canVerbose: args['verbose'],
  ).call();
}

class Budinoh {
  final projectClient = ProjectClient();
  final distributionClient = DistributionClient();
  final distributionQueue = Queue();
  late final StreamSubscription remainingItemsSub;
  int remainingItems = 0;

  final List<String> buildNames;
  final bool canBuildApk;
  final bool canBuildAppbundle;
  final bool canBuildIpa;
  final bool canDeployFirebase;
  final bool canDeployGoogleStore;
  final bool canDeployAppleStore;
  final bool canUseChangelog;
  final String settingsPath;
  final bool canVerbose;

  final BuildClient buildClient;

  Budinoh({
    required this.buildNames,
    required this.canBuildApk,
    required this.canBuildAppbundle,
    required this.canBuildIpa,
    required this.canDeployFirebase,
    required this.canDeployGoogleStore,
    required this.canDeployAppleStore,
    required String? buildNumber,
    required String? buildName,
    required this.canUseChangelog,
    required this.settingsPath,
    required this.canVerbose,
  }) : buildClient = BuildClient(buildName: buildName, buildNumber: buildNumber) {
    remainingItemsSub = distributionQueue.remainingItems.listen((event) {
      remainingItems = event;
    });
  }

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
    final projectVersion = buildClient.buildNumber ?? await projectClient.readVersion();
    final releaseNotes = await _readReleaseNotes(projectVersion: projectVersion);

    // Create output builds directory
    final outputDir = Directory('build_output');
    if (await outputDir.exists()) {
      await outputDir.delete(recursive: true);
    }
    await outputDir.create();
    Print.spaceInfo('Output directory: ${outputDir.path}');

    // Filter builds
    final builds =
        Map.fromEntries((buildNames.isEmpty ? settings.builds.keys : buildNames).map((name) {
      final buildsSettings = settings.builds[name];
      if (buildsSettings == null) throw StateError('Unknown build key: $name');

      final builds = buildsSettings.getBuilds(
        apk: canBuildApk,
        appbundle: canBuildAppbundle,
        ipa: canBuildIpa,
      );
      return MapEntry(name, builds);
    }));

    Print.spaceInfo('($projectVersion) Builds: ${builds.entries.map((e) {
      return '${e.key}(${e.value.map((e) => e.type).join(',')})';
    }).join(' - ')}');

    await buildClient.cleanAndPubGet();

    Print.workInfo('Initialized work space!');

    for (final entry in builds.entries) {
      final buildKey = entry.key;
      final buildsSettings = entry.value;

      Print.workInfo('Initializing project...');

      final env = await _readEnv(settings, settings.env, buildKey);

      final outputEnvDir = Directory(join(outputDir.path, buildKey));
      await outputEnvDir.create();

      for (final buildSettings in buildsSettings) {
        await _buildAndUpload(
          settings: settings,
          env: env,
          buildKey: buildKey,
          buildSettings: buildSettings,
          outputDir: outputEnvDir,
          releaseNotes: releaseNotes,
        );
      }
    }

    Print.workInfo('Builds Completed!\nCleaning project...');
    await buildClient.cleanAndPubGet();

    Print.workInfo('Project clean!');

    if (remainingItems > 0) {
      Print.workInfo('Wait Distribution...');
      await distributionQueue.onComplete;
      Print.workInfo('Distribution Completed!');
    }
  }

  Future<String?> _readEnv(
    PackageSettings settings,
    EnvSettings? envSettings,
    String buildKey,
  ) async {
    if (envSettings == null) return null;

    final envFilePath =
        '${envSettings.directory}/${envSettings.prefix ?? ''}$buildKey${envSettings.suffix ?? ''}';

    return await projectClient.readDartDefineFile(filePath: envFilePath);
  }

  Future<String> _readReleaseNotes({required String projectVersion}) async {
    if (!canUseChangelog) return '';

    final allReleaseNotes = await projectClient.readReleaseNotes();
    final releaseNotes = allReleaseNotes[projectVersion];
    if (releaseNotes == null) {
      Print.error('Not find Release Notes for "$projectVersion" project version');
      exit(-1);
    }
    Print.spaceInfo('Release notes:\n$releaseNotes');
    return releaseNotes;
  }

  Future<File> _build({
    required String buildKey,
    required BuildSettings buildSettings,
    required String? env,
  }) async {
    if (buildSettings is ApkSettings) {
      return await buildClient.buildApk(env: env, args: buildSettings.args);
    } else if (buildSettings is AppBundleSettings) {
      return await buildClient.buildAppBundle(env: env, args: buildSettings.args);
    } else if (buildSettings is IpaSettings) {
      return await buildClient.buildIpa(
        env: env,
        exportOptions: buildSettings.exportOptions,
        args: buildSettings.args,
      );
    }
    throw 'Not support $buildSettings';
  }

  Future<void> _buildAndUpload({
    required PackageSettings settings,
    required String buildKey,
    required BuildSettings buildSettings,
    required String? env,
    required Directory outputDir,
    required String releaseNotes,
  }) async {
    Print.workInfo('$buildKey.${buildSettings.type}: Building...');

    final tmpBuildFile = await _build(
      env: env,
      buildKey: buildKey,
      buildSettings: buildSettings,
    );
    final buildFile = await tmpBuildFile.rename('${outputDir.path}/${basename(tmpBuildFile.path)}');

    Print.workInfo('$buildKey.${buildSettings.type}: Built!!!');

    void distribuite(String name, Future<void> Function() task) {
      distributionQueue.add(() async {
        Print.workInfo('$buildKey.${buildSettings.type}: Uploading to $name...');
        await task();
        Print.workInfo('$buildKey.${buildSettings.type}: Uploaded to $name!!!');
      });
    }

    String getGoogleCredentials(String? credentials) {
      if (credentials != null) return credentials;
      final googleCredentials = settings.firebaseApiCredentials;
      if (googleCredentials != null) return googleCredentials;
      throw StateError(
          'Place declare a global `googleCredentials` key or credentials key in distribution client option');
    }

    final firebaseCli = buildSettings.firebaseCli;
    if (canDeployFirebase && firebaseCli != null) {
      distribuite('Firebase - Cli', () async {
        await distributionClient.uploadToFirebaseByCli(
          buildFile,
          appId: firebaseCli.appId,
          groups: firebaseCli.groups,
          releaseNotes: releaseNotes,
        );
      });
    }
    final firebaseApi = buildSettings.firebaseApi;
    if (canDeployFirebase && firebaseApi != null) {
      distribuite('Firebase - Api', () async {
        await distributionClient.uploadToFirebaseByApi(
          buildFile,
          credentials: getGoogleCredentials(firebaseApi.credentials),
          appId: firebaseApi.appId,
          groups: firebaseApi.groups,
          releaseNotes: releaseNotes,
        );
      });
    }
    final googleStore = buildSettings.googleStore;
    if (canDeployGoogleStore && googleStore != null) {
      distribuite('Google Store', () async {
        await distributionClient.uploadToGoogleStore(
          buildFile,
          credentials: getGoogleCredentials(googleStore.credentials),
          packageName: googleStore.packageName,
        );
      });
    }
    final appleStoreApp = buildSettings.appleStoreApp;
    if (canDeployAppleStore && appleStoreApp != null) {
      distribuite('Apple Store - App', () async {
        await distributionClient.uploadAppToAppleStore(
          buildFile,
          apiKeyId: appleStoreApp.apiKeyId,
          apiIssuer: appleStoreApp.apiIssuer,
          apiKey: appleStoreApp.apiKey,
        );
      });
    }
  }
}

class ToolBox {
  static final File projectYaml = File('pubspec.yaml');
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
        (map) {
          try {
            return from(map!);
          } catch (error) {
            print(error);
            rethrow;
          }
        },
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
