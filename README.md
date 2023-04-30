# Budinoh

Auto build and upload your project build to Firebase, PlayStore and AppStore.

Features:
- [x] Auto build project based on env files
- [x] Deploy builds to Firebase (CLI/API)
- [x] Deploy builds to Google Play Store (API)
- [x] Deploy builds to Apple Store (xcrun altool)
- [x] Support --dart-define-from-file arg

## Using the package via yaml configuration file

### Activate plugin
Activate: `dart pub global activate budinoh`

### Create settings file with your builds

Create a `budinoh.yaml` file in project directory

```yaml
budinoh:
 <content>
```

With your builds

```yaml
builds:
  <name>:
    apk: {} # Optional
    appbundle: {} # Optional
    ipa: # Optional
      export_options: <path/ExportOptions.plist> # Optional
```

### Distribution

You can auto-distribute your app on firebase, google play console (google_store) and apple store

```yaml
firebase_api_credentials:  # Optional. Path to file or Json String
builds:
  <name>:
    <apk|ios>:
       firebase_cli:
        app_id: <firebase_app_id> # Required
        groups: # Optional
          - group-one
          - group-two
    <apk|ios>:
       firebase_api:
          credentials: # Optional. Path to file or Json String. If missing it use credentials in firebase_api_credentials 
          app_id: <firebase_app_id> # Required
          groups: # Optional
             - group-one
             - group-two
    appbundle:
      google_store:
        credentials: ./google_service_account.json # Optional. Path to file or Json String
        package_name: <com.example> # Required
    ios:
      apple_store:
        api_issuer: <APIISSUER> # Required
        api_key_id: <APIKEYID> # Required
        apiKey: '.' # Optional. Path to directory or api key content
```

### Env

Are you using an env? 
Budinoh will search the directory you tell it for an env file with this name '${prefixEnv}${buildKey}${suffixEnv}'.

```yaml
env:
  directory: '.' # Optional. Environments directory
  prefix: <.config.> # Optional. Prefix env file name
  suffix: <.json> # Optional. Suffix env file name
```

Set `env: {}` to enable use of the env with the default parameters

### Launch builds
1. Run `dart pub global run budinoh`
2. See output in `<PROJECT_DIR>/build_output/<ENV_NAME>/<BUILD_FILE>`

### More settings
Run `dart pub global run budinoh --help`

## Using the package via dart code

### Build client

```dart
final client = BuildClient();

client.buildApk(env: , args: );

client.buildAppBundle(env: , args: );

client.buildIpa(exportOptions: , env: , args: );
```

### Distribution client

```dart
final client = DistributionClient();

/// Use the Firebase CLI
client.uploadToFirebaseByCli(buildFile, appId: , releaseNotes: ,groups: );
/// Use the Firebase Rest Api
client.uploadToFirebaseByApi(buildFile, credentials: , appId: , releaseNotes: ,groups: );

/// Use the 'xcrun altool --upload-app' command
client.uploadAppToAppleStore(buildFile, apiIssuer: , apiKeyId: , apiKey: );

/// Use the 'https://www.googleapis.com/auth/androidpublisher' Google REST Api
client.uploadToGoogleStore(buildFile, credentials: , packageName: );
```

## Collect your credentials

### Firebase

1. Open the [Google Cloud](https://console.cloud.google.com/projectselector2/iam-admin/serviceaccounts) Console and select your project.
2. Click Create Service Account and enter service account details.
3. Click Create and Continue.
4. Add the Firebase App Distribution Admin role and click Done.
5. Create a private JSON key and move the key to a location accessible to your build environment. Be sure to keep this file somewhere safe, because it grants administrator access to App Distribution in your Firebase project.

More Info at [this link](https://firebase.google.com/docs/app-distribution/authenticate-service-account)

### Google Store (Google Play Console)

1. Open the [Google Play Console](https://play.google.com/console)
2. Click Account Details, and note the Developer Account ID listed there
3. Click Setup → API access
4. Click the Create new service account button
5. Follow the Google Cloud Platform link in the dialog, which opens a new tab/window:
   1. Click the CREATE SERVICE ACCOUNT button at the top of the Google Cloud Platform Console
   2. Verify that you are on the correct Google Cloud Platform Project by looking for the Developer Account ID from earlier within the light gray text in the second input, preceding .iam.gserviceaccount.com. If not, open the picker in the top navigation bar, and find the one with the ID that contains it.
   3. Provide a Service account name and click Create
   4. Click Select a role, then find and select Service Account User, and proceed
   5. Click the Done button
   6. Click on the Actions vertical three-dot icon of the service account you just created
   7. Select Manage keys on the menu
   8. Click ADD KEY -> Create New Key
   9. Make sure JSON is selected as the Key type, and click CREATE
   10. Save the file on your computer when prompted and remember where it was saved to
6. Return to the Google Play Console tab, and click DONE to close the dialog
7. Click on Grant Access for the newly added service account at the bottom of the screen (you may need to click Refresh service accounts before it shows up)
8. Choose the permissions you'd like this account to have. We recommend Admin (all permissions), but you may want to manually select all checkboxes and leave out some of the Releases permissions such as Release to production
9. Click Invite user to finish

More Info at [this link](https://docs.fastlane.tools/getting-started/android/setup) at `Collect your Google credentials` paragraph.

### Apple Store

1. Create a new App Store Connect API Key in the [Users page](https://appstoreconnect.apple.com/access/api)
   - For more info, go to the App Store Connect API Docs
   - Select the "Keys" tab
   - Give your API Key an appropriate role for the task at hand. You can read more about roles in [Permissions in App Store Connect](https://developer.apple.com/support/roles)
   - Note the *Issuer ID* as you will need it for the configuration steps below
2. Download the newly created API Key file (.p8)
  - This file cannot be downloaded again after the page has been refreshed

More Info at [this link](https://docs.fastlane.tools/app-store-connect-api) at `Creating an App Store Connect API Key` paragraph.

# Use env instead of flavors!
Build your app based on env. You can change the bundle_id or app name according to the env used.
[See documents for more information](ENV_INSTEAD_FLAVOUR.md)
