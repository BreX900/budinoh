import 'dart:convert';
import 'dart:io';

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart';
import 'package:budinoh/src/dto/upload_status_response.dart';
import 'package:budinoh/src/shell_extensions.dart';
import "package:googleapis/androidpublisher/v3.dart";
import 'package:googleapis/firebaseappdistribution/v1.dart';
// ignore: implementation_imports
import 'package:googleapis/src/user_agent.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:process_run/shell.dart';

class DistributionClient {
  final _shell = Shell();

  /// https://firebase.google.com/docs/app-distribution/android/distribute-cli
  Future<void> uploadToFirebaseByCli(
    File buildFile, {
    required String appId,
    String releaseNotes = '',
    List<String> groups = const [],
  }) async {
    final command =
        StringBuffer('firebase appdistribution:distribute ${buildFile.path} --app $appId');

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

  /// https://firebase.google.com/docs/reference/app-distribution
  Future<void> uploadToFirebaseByApi(
    File buildFile, {
    required String credentials,
    required String appId,
    String releaseNotes = '',
    List<String> groups = const [],
  }) async {
    return await _runWithGoogleClient(
      credentials: credentials,
      scopes: [FirebaseAppDistributionApi.cloudPlatformScope],
      handler: (client) async {
        final api = FirebaseAppDistributionApi(client);

        final releaseResponse = await _uploadBinaryToFirebaseViaApi(
          client: client,
          api: api,
          appId: appId,
          buildFile: buildFile,
        );

        if (releaseNotes.isNotEmpty) {
          await api.projects.apps.releases.patch(
            GoogleFirebaseAppdistroV1Release(
              releaseNotes: GoogleFirebaseAppdistroV1ReleaseNotes(
                text: releaseNotes,
              ),
            ),
            releaseResponse.name!,
          );
        }
        if (groups.isNotEmpty) {
          await api.projects.apps.releases.distribute(
            GoogleFirebaseAppdistroV1DistributeReleaseRequest(
              groupAliases: groups,
            ),
            releaseResponse.name!,
          );
        }
      },
    );
  }

  Future<void> uploadAppToAppleStore(
    File buildFile, {
    required String apiKeyId,
    required String apiIssuer,
    String? apiKey,
  }) async {
    var shell = _shell;

    if (apiKey != null) {
      if (apiKey.startsWith('-----BEGIN PRIVATE KEY-----') &&
          apiKey.endsWith('-----END PRIVATE KEY-----')) {
        final privateKeysDir = Directory('./private_keys');
        if (!await privateKeysDir.exists()) await privateKeysDir.create();

        final privateKeyFile = File('${privateKeysDir.path}/AuthKey_$apiKeyId.p8');
        await privateKeyFile.writeAsString(apiKey);
      } else {
        shell = _shell.cloneWithOptions(_shell.options.clone(
          shellEnvironment: ShellEnvironment.fromJson({
            ..._shell.options.environment,
            'API_PRIVATE_KEYS_DIR': apiKey,
          }),
        ));
      }
    }

    await shell.singleRun('xcrun altool --upload-app '
        '--type ios '
        '-f ${buildFile.path} '
        '--apiKey $apiKeyId '
        '--apiIssuer $apiIssuer');
  }

  Future<void> uploadToGoogleStore(
    File buildFile, {
    required String credentials,
    required String packageName,
  }) async {
    await _runWithGoogleClient(
      credentials: credentials,
      scopes: [AndroidPublisherApi.androidpublisherScope],
      handler: (client) async {
        final api = AndroidPublisherApi(client);

        var appEdit = await api.edits.insert(AppEdit(), packageName);

        await api.edits.bundles.upload(
          packageName,
          appEdit.id!,
          uploadMedia: Media(buildFile.openRead(), await buildFile.length()),
        );

        appEdit = await api.edits.commit(packageName, appEdit.id!, changesNotSentForReview: true);
      },
    );
  }

  Future<T> _runWithGoogleClient<T>({
    required String credentials,
    required List<String> scopes,
    required Future<T> Function(AutoRefreshingAuthClient client) handler,
  }) async {
    final String serviceCredentialsRaw;
    if (credentials.endsWith('.json')) {
      serviceCredentialsRaw = File(credentials).readAsStringSync();
    } else {
      serviceCredentialsRaw = credentials;
    }
    final serviceCredentialsJson = jsonDecode(serviceCredentialsRaw);
    final serviceCredentials = ServiceAccountCredentials.fromJson(serviceCredentialsJson);

    AutoRefreshingAuthClient? client_;
    try {
      client_ = await clientViaServiceAccount(serviceCredentials, scopes);

      return await handler(client_);
    } finally {
      client_?.close();
    }
  }

  Future<GoogleFirebaseAppdistroV1Release> _uploadBinaryToFirebaseViaApi({
    required Client client,
    required FirebaseAppDistributionApi api,
    required String appId,
    required File buildFile,
  }) async {
    final projectId = int.parse(appId.split(':')[1]);

    final uploadResponse = await api.media.uploadV2(
      client,
      null,
      'projects/$projectId/apps/$appId',
      uploadMedia: Media(buildFile.openRead(), await buildFile.length()),
      uploadMediaName: basename(buildFile.path),
    );
    final operationName = uploadResponse.name!;

    for (var retryCount = 0; retryCount < 60; retryCount++) {
      final operationResponse = await api.projects.apps.releases.operations.get(operationName);

      if (operationResponse.done != true) {
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }

      if (operationResponse.error != null) throw operationResponse.error!.toJson();

      final uploadStatusResponse = UploadStatusResponse.fromJson(operationResponse.response!);
      final releaseResponse = uploadStatusResponse.release;

      switch (uploadStatusResponse.result) {
        case UploadResult.releaseUpdated:
          print(
              '✅ Uploaded #{binary_type} successfully; updated provisioning profile of existing release #{upload_status_response.release_version}.');
          break;
        case UploadResult.releaseUnmodified:
          print(
              '✅ The same #{binary_type} was found in release ${releaseResponse.version} with no changes, skipping.');
          break;
        case UploadResult.releaseCreated:
        default:
          print(
              '✅ Uploaded #{binary_type} successfully and created release ${releaseResponse.version}.');
      }

      return releaseResponse;
    }

    throw StateError('Max retry count!');
  }
}

extension on MediaResource {
  ApiRequester _requester(Client client, {String? uploadFileName}) =>
      ApiRequester(client, 'https://firebaseappdistribution.googleapis.com/', '', {
        ...requestHeaders,
        if (uploadFileName != null) 'X-Goog-Upload-File-Name': uploadFileName,
        if (uploadFileName != null) 'X-Goog-Upload-Protocol': 'raw',
      });

  Future<GoogleLongrunningOperation> uploadV2(
    Client client,
    GoogleFirebaseAppdistroV1UploadReleaseRequest? request,
    String app, {
    String? $fields,
    Media? uploadMedia,
    String? uploadMediaName,
  }) async {
    final body_ = request != null ? json.encode(request) : null;
    final queryParams_ = <String, List<String>>{
      if ($fields != null) 'fields': [$fields],
    };
    print(app);
    String url_;
    if (uploadMedia == null) {
      url_ = 'v1/${Uri.encodeFull(app)}/releases:upload';
    } else {
      url_ = '/upload/v1/${Uri.encodeFull(app)}/releases:upload';
    }

    final response_ = await _requester(client, uploadFileName: uploadMediaName).request(
      url_,
      'POST',
      body: body_,
      queryParams: queryParams_,
      uploadMedia: uploadMedia,
      uploadOptions: UploadOptions.defaultOptions,
    );
    return GoogleLongrunningOperation.fromJson(response_ as Map<String, dynamic>);
  }
}

extension on GoogleFirebaseAppdistroV1Release {
  String get version {
    if (displayVersion != null && buildVersion != null) {
      return '$displayVersion ($buildVersion)';
    }
    return displayVersion ?? buildVersion ?? '?.?.?';
  }
}
