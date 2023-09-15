// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyBeHCCgW7KvSdHEwGszPgaYD9MrByEjrjc',
    appId: '1:176703737429:web:c5c48140e2c32d59594edc',
    messagingSenderId: '176703737429',
    projectId: 'fire-d-demo',
    authDomain: 'fire-d-demo.firebaseapp.com',
    storageBucket: 'fire-d-demo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbBo1D83DvoyceVkbOTd71j8nTIDa_Z78',
    appId: '1:176703737429:android:b7e62d9cfd63ff92594edc',
    messagingSenderId: '176703737429',
    projectId: 'fire-d-demo',
    storageBucket: 'fire-d-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKvwSq8SLaNtTX341QjQE55SjrgsBOoSw',
    appId: '1:176703737429:ios:3f5f0b0214862715594edc',
    messagingSenderId: '176703737429',
    projectId: 'fire-d-demo',
    storageBucket: 'fire-d-demo.appspot.com',
    iosClientId: '176703737429-vc5egpsbsi4sqhh82tgkhau3kpu97bra.apps.googleusercontent.com',
    iosBundleId: 'com.example.myapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKvwSq8SLaNtTX341QjQE55SjrgsBOoSw',
    appId: '1:176703737429:ios:26443f4912d9e51f594edc',
    messagingSenderId: '176703737429',
    projectId: 'fire-d-demo',
    storageBucket: 'fire-d-demo.appspot.com',
    iosClientId: '176703737429-vkordumlq69cqa6gaic37fnsj20v01au.apps.googleusercontent.com',
    iosBundleId: 'com.example.myapp.RunnerTests',
  );
}