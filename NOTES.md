# NOTES

- [Flutter Navigator 2.0 and Deep Links](https://www.raywenderlich.com/19457817-flutter-navigator-2-0-and-deep-links)

## Fix : Error Build failed due to use of deprecated Android v1
embedding.

- starter/android/app/src/main/AndroidManifest.xml
- final/android/app/src/main/AndroidManifest.xml

replace `android:name="io.flutter.app.FlutterApplication"` with
`android:name="${applicationName}`

## Fix : Your project requires a newer version of the Kotlin Gradle plugin.

- starter/android/build.gradle
- final/android/build.gradle

bump gradle version

```
buildscript {
    // ext.kotlin_version = '1.3.50'
    ext.kotlin_version = '1.6.10'
```

## Failed to apply plugin [id 'kotlin-android']

- [Fixing &#x60;Module was compiled with an incompatible version of Kotlin.&#x60;](http://blog.wafrat.com/fixing-module-was-compiled-with-an-incompatible-version-of-kotlin/)

```
A problem occurred evaluating project ':app'.
> Failed to apply plugin [id 'kotlin-android']
   > The current Gradle version 5.6.2 is not compatible with the Kotlin Gradle plugin. Please use Gradle 6.1.1 or newer, or the previous version of the Kotlin plugin.
```

- starter/android/gradle/wrapper/gradle-wrapper.properties
- final/android/gradle/wrapper/gradle-wrapper.properties

change

```
// distributionUrl=https\://services.gradle.org/distributions/gradle-5.6.2-all.zip
distributionUrl=https\://services.gradle.org/distributions/gradle-6.1.1-all.zip
```

## Test DeepLinks

```shell
# settings
$ adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "navapp://deeplinks/settings"'
# details/1
$ adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "navapp://deeplinks/details/1"'
# cart
$ adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "navapp://deeplinks/cart"'
```
