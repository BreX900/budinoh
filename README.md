# Budinoh

Auto build and upload your project build to Firebase, PlayStore and AppStore.
This project is based to [define_env](https://pub.dev/packages/define_env)

Features:
- [x] Auto build project based on env files
- [x] Deploy builds to Firebase
- [ ] Deploy builds to PlayStore
- [ ] Deploy builds to AppStore

## Activate plugin
Activate: `dart pub global activate budinoh`

## Create settings file
Create a `budinoh.yaml` file in project directory
```yaml
builds:
  <env.name>:
    apk:
      firebase:
        app_id: firebase_app_id
        groups:
          - group-one
          - group-two
    appbundle:
    ipa:
      export_options: path/ExportOptions.plist
```

## Launch builds
1. Run `dart pub global run budinoh`
2. See output in `<PROJECT_DIR>/build_output/<ENV_NAME>/<BUILD_FILE>`

## More settings
Run `dart pub global run budinoh -help`

# Use env instead of flavors!
Build your app based on env. You can change the bundle_id or app name according to the env used.
[See documents for more information](ENV_INSTEAD_FLAVOUR.md)
