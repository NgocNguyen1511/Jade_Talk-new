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
    apiKey: 'AIzaSyCwSIRMZc3akxXxK5dj8YY9_znHJW66Pds',
    appId: '1:832892368467:web:0164aa676f0a26810178a6',
    messagingSenderId: '832892368467',
    projectId: 'jadetalk-86eed',
    authDomain: 'jadetalk-86eed.firebaseapp.com',
    storageBucket: 'jadetalk-86eed.firebasestorage.app',
    measurementId: 'G-8H9STW1RYB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBHr2SpGtivUs9iucsfU3XymItSOcOWKRI',
    appId: '1:832892368467:android:ddcedc534ec356e60178a6',
    messagingSenderId: '832892368467',
    projectId: 'jadetalk-86eed',
    storageBucket: 'jadetalk-86eed.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKMV5CJYE6s8-FP-yuzC5loHLavqn4Qbs',
    appId: '1:832892368467:ios:bdac60f1433a97520178a6',
    messagingSenderId: '832892368467',
    projectId: 'jadetalk-86eed',
    storageBucket: 'jadetalk-86eed.firebasestorage.app',
    iosBundleId: 'com.example.jadeTalk',
  );
}
