// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyAK3wQil8YJpW-XWu49-IQcZfHxAfRlTUo',
    appId: '1:1088592232162:web:e6290170a06823010468bb',
    messagingSenderId: '1088592232162',
    projectId: 'eventease-38aca',
    authDomain: 'eventease-38aca.firebaseapp.com',
    storageBucket: 'eventease-38aca.firebasestorage.app',
    measurementId: 'G-LNW2HHCRKP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVFbPtwtxMCdyi_QO5S6HrwBW4wD_N6kM',
    appId: '1:1088592232162:android:e5cdc1a5644327880468bb',
    messagingSenderId: '1088592232162',
    projectId: 'eventease-38aca',
    storageBucket: 'eventease-38aca.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAp0XamqaxXDVFFpQtZuWKC7w3mWb2r2vE',
    appId: '1:1088592232162:ios:10f6a3d2cc1db6a30468bb',
    messagingSenderId: '1088592232162',
    projectId: 'eventease-38aca',
    storageBucket: 'eventease-38aca.firebasestorage.app',
    iosBundleId: 'com.example.eventease1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAK3wQil8YJpW-XWu49-IQcZfHxAfRlTUo',
    appId: '1:1088592232162:web:c2a5b571bda143470468bb',
    messagingSenderId: '1088592232162',
    projectId: 'eventease-38aca',
    authDomain: 'eventease-38aca.firebaseapp.com',
    storageBucket: 'eventease-38aca.firebasestorage.app',
    measurementId: 'G-WM983N9VXH',
  );
}
