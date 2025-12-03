plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'dev.flutter.flutter-gradle-plugin'
}

android {
    namespace 'com.example.studyplanner'
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.example.studyplanner"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
                targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:34.5.0')
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-firestore'
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-crashlytics'
}

apply plugin: 'com.google.gms.google-services'
