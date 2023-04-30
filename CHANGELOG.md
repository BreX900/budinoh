
## 1.0.0

- feat: Deploy builds to Firebase API via `firebase_api` option
- feat: Deploy builds to Google Play Store via `google_store` option
- feat: Deploy builds to Apple Store API via `apple_store_app` option
- feat: Support `--dart-define-from-file` arg
- feat: Can pass custom arguments to `flutter build`  via `args` option

*BREAKING CHANGES*
- No longer supported `define_env`, replaced by `--dart-define-from-file` arg
- The `firebase` option has been renamed to `firebase_cli`
- The env option moved inside `env` option
- Small and large changes to client method signatures for better and easier use

## 0.0.6
- Fix reading version on CHANGELOG.md file

## 0.0.5
- Fix for random ordering of builds

## 0.0.4
- Fix distribution queue printing

## 0.0.3
- Added `define_env` in yaml file to pass a define_env settings file 

## 0.0.2
- Added args `firebase`, `google-store`, `apple-store` to disable deploy

## 0.0.1
- Initial version.
