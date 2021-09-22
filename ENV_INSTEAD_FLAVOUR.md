- Add to your `.env` file
```dotenv
NAME = "Env name"

APP_NAME = "App Name"

ANDROID_BUNDLE_ID = "com.android.bundle.id"

IOS_BUNDLE_ID = "com.ios.bundle.id"
IOS_PROVISIONING_PROFILE = "Ios_provisioning_profile_file_name"
```

- Update your `.gitignore`
````gitignore
# Budinoh
build_output/
ios/Flutter/Define-env.xcconfig
# TODO: Remove if you don't use firebase
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
````

- If you are using firebase update to your project by adding these files
1. `_more/android/<envName>/google-service.json`
2. `_more/ios/<envName>/GoogleService-Info.plist`


## Android
- Open and edit `android/app/build.gradle` file
```gradle
// ...

def dartEnvironmentVariables = [
        NAME: null,
        APP_NAME: "App name",
        ANDROID_BUNDLE_ID: null,
]

if (project.hasProperty('dart-defines')) {
    dartEnvironmentVariables = dartEnvironmentVariables + project.property('dart-defines')
            .split(',')
            .collectEntries { entry ->
                def pair = new String(entry.decodeBase64(), 'UTF-8').split('=')
                [(pair.first()): pair.last()]
            }
}

android {
    // TODO: Remove if your app doesn't use google services
    if (dartEnvironmentVariables.NAME) {
        copy {
            from '../../_more/android/' + dartEnvironmentVariables.NAME + '/google-services.json'
            include '*.json'
            into '.'
        }
    }

    // ...
    
    defaultConfig {
        applicationId dartEnvironmentVariables.ANDROID_BUNDLE_ID
        manifestPlaceholders = [ applicationName: dartEnvironmentVariables.APP_NAME ]
        // ...
    }
    
    buildTypes {
        release {
            // TODO: Enable app signing only for envs that need to be published on stores
            if (dartEnvironmentVariables.NAME != 'prod') {
                signingConfig signingConfigs.debug
            } else {
                signingConfig signingConfigs.release
            }
        }
    }
}
```

- Open and edit `android/app/src/main/AndroidManifest.xml` file
```xml
<manifest>
    <!-- ... -->
    <application 
            android:label="${applicationName}">
        <!-- ... -->
    </application>
    <!-- ... -->
</manifest>
```

## Ios
- Open xcode and go to `Runner -> Edit Scheme -> <Build & Run> -> Pre-actions -> Run Script`
```shell
# Script used in xcode to translate the dart environment into an xcconfig file
# Also copy the google services file of the specific env in the build folder

function entry_decode() { echo "${*}" | base64 --decode; }

IFS=',' read -r -a define_items <<< "$DART_DEFINES"

for index in "${!define_items[@]}"
do
    define_items[$index]=$(entry_decode "${define_items[$index]}");
done

# Write a xxconfig file with env variables
printf "%s\n" "${define_items[@]}" | grep -v '^\w*\.' > "${SRCROOT}/Flutter/Define-env.xcconfig"

# TODO: Remove if your app doesn't use google services

# Find environment name
name=$(printf -- '%s\n' "${define_items[@]}" | grep "^NAME=" | cut -d= -f2)

# Copy a google services file to local ios path for build
if [ -n "$name" ]; then
  relative_file_path="../_more/ios/$name/GoogleService-Info.plist"

  cp "${SRCROOT}/$relative_file_path" "${SRCROOT}/Runner/GoogleService-Info.plist"
fi
```

- Update `ios/Flutter/Debug.xcconfig` and `ios/Flutter/Release.xcconfig`
````xcconfig
// ...
#include "Define-env.xcconfig"
````

- Update `ios/Runner/Info.plist`
```xml
<dict>
    <key>CFBundleIdentifier</key>
	<string>$(IOS_BUNDLE_ID)</string>
    <key>CFBundleName</key>
    <string>$(APP_NAME)</string>
</dict>
```

- Update this fields on `ios/Runner.xcodeproj/project.pbxproj` 
```pbxproj
    PRODUCT_BUNDLE_IDENTIFIER = "$(IOS_BUNDLE_ID)";
    PROVISIONING_PROFILE_SPECIFIER = "$(IOS_PROVISIONING_PROFILE)";
```