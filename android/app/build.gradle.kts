import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Upload key for Google Play. Kept out of the repo (see .gitignore): losing it
// means never being able to update the app again. Absent on a fresh clone, so
// the release build must not hard-fail without it.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}
val hasUploadKey = keystoreProperties.containsKey("storeFile")

android {
    namespace = "com.olivierd.budgie"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Required by flutter_local_notifications.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Play identity — permanent once published: it can never be changed.
        applicationId = "com.olivierd.budgie"
        // Android 8.0+. Nothing in the app needs 31: dynamic colour degrades to
        // the seed palette on its own, and every plugin here supports 21+.
        // Flutter's own floor is 24, so 26 keeps a margin while adding back the
        // whole Android 8–11 catalogue (decision D1, revised twice).
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasUploadKey) {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Falls back to the debug key so `flutter run --release` still works
            // without a keystore. A bundle signed this way is NOT uploadable to
            // Play — check the Gradle log line below if an upload is rejected.
            signingConfig = if (hasUploadKey) {
                signingConfigs.getByName("release")
            } else {
                logger.warn(
                    "AVERTISSEMENT : pas de android/key.properties — build release " +
                        "signé avec la clé de DEBUG, non publiable sur Play.",
                )
                signingConfigs.getByName("debug")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
