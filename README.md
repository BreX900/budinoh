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
Run `dart pub global run budinoh`

### More settings
Run `dart pub global run budinoh -help`