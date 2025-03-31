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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyB_Gd8yVpt6iFzJier8R7dQfEnVC-WuES8',
    appId: '1:293962542264:web:22a58bdfe8c0ea8492d84d',
    messagingSenderId: '293962542264',
    projectId: 'grp3-578bd',
    authDomain: 'grp3-578bd.firebaseapp.com',
    storageBucket: 'grp3-578bd.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAm2ubvhRR5hm-Q1e9XqxhS-Sq5lzxDSRA',
    appId: '1:293962542264:android:1fb162b516fc824392d84d',
    messagingSenderId: '293962542264',
    projectId: 'grp3-578bd',
    storageBucket: 'grp3-578bd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtLovz90KoudtErFIMi-A3Go2o3CBPnRs',
    appId: '1:293962542264:ios:235cf513749e45ac92d84d',
    messagingSenderId: '293962542264',
    projectId: 'grp3-578bd',
    storageBucket: 'grp3-578bd.firebasestorage.app',
    iosBundleId: 'com.example.grp3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtLovz90KoudtErFIMi-A3Go2o3CBPnRs',
    appId: '1:293962542264:ios:235cf513749e45ac92d84d',
    messagingSenderId: '293962542264',
    projectId: 'grp3-578bd',
    storageBucket: 'grp3-578bd.firebasestorage.app',
    iosBundleId: 'com.example.grp3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB_Gd8yVpt6iFzJier8R7dQfEnVC-WuES8',
    appId: '1:293962542264:web:564bf9a37f39aa9192d84d',
    messagingSenderId: '293962542264',
    projectId: 'grp3-578bd',
    authDomain: 'grp3-578bd.firebaseapp.com',
    storageBucket: 'grp3-578bd.firebasestorage.app',
  );
}
