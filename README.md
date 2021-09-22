# Budinoh

### Activate plugin
Activate: `dart pub global activate budinoh`

### Create settings file
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

### Launch builds
1. Run `dart pub global run budinoh`
2. See output in `<PROJECT_DIR>/build_output/<ENV_NAME>/<BUILD_FILE>`

### More settings
Run `dart pub global run budinoh -help`