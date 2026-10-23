import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") apply false
}

// Native Firebase startup/background delivery needs resources generated from
// the environment-specific, ignored configuration supplied by the developer.
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
}

// The Android Maps SDK key is a client key restricted to this package and signing certificate. It is read
// from the ignored android/secrets.properties or the build environment and never committed.
val secretProperties = Properties().apply {
    val file = rootProject.file("secrets.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val mapsAndroidApiKey: String = secretProperties.getProperty("MAPS_ANDROID_API_KEY")
    ?: System.getenv("MAPS_ANDROID_API_KEY")
    ?: ""

val releaseProperties = Properties().apply {
    val propertiesFile = rootProject.file("key.properties")
    if (propertiesFile.exists()) propertiesFile.inputStream().use { load(it) }
}
val releaseRequested = gradle.startParameter.taskNames.any { it.contains("release", ignoreCase = true) }
fun signingValue(name: String): String = releaseProperties.getProperty(name)
    ?: throw GradleException("Configure protected Android signing: $name")
fun signingPassword(name: String): String = System.getenv(signingValue(name))
    ?.takeIf { it.isNotBlank() }
    ?: throw GradleException("Supply the protected Android signing environment variable for $name")

android {
    namespace = "ph.materyal.buyer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "ph.materyal.buyer"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["mapsAndroidApiKey"] = mapsAndroidApiKey
    }

    signingConfigs {
        if (releaseRequested) {
            create("protectedRelease") {
                storeFile = file(signingValue("storeFile"))
                keyAlias = signingValue("keyAlias")
                storePassword = signingPassword("storePasswordEnv")
                keyPassword = signingPassword("keyPasswordEnv")
            }
        }
    }
    buildTypes {
        release {
            if (releaseRequested) signingConfig = signingConfigs.getByName("protectedRelease")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
