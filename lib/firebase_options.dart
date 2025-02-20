// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC-_xuM0eJw61Kh0pqZWwvi4UIEk3_q4Kc',
    appId: '1:69348377635:web:a51d76f59952e0ffc55d96',
    messagingSenderId: '69348377635',
    projectId: 'elice-flutter-team2',
    authDomain: 'elice-flutter-team2.firebaseapp.com',
    storageBucket: 'elice-flutter-team2.appspot.com',
    measurementId: 'G-KC64647WM4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqL9aMkNE13VDXhPc4v2Na1EPQxgSnIwk',
    appId: '1:69348377635:android:07f79e2b29fe7e65c55d96',
    messagingSenderId: '69348377635',
    projectId: 'elice-flutter-team2',
    storageBucket: 'elice-flutter-team2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD74tZQtfRJHtb8pL6YwHCVxt0stRDXzf4',
    appId: '1:69348377635:ios:f2febdb25e9d9600c55d96',
    messagingSenderId: '69348377635',
    projectId: 'elice-flutter-team2',
    storageBucket: 'elice-flutter-team2.appspot.com',
    iosBundleId: 'com.appteam2.appTeam2',
  );

}