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
    apiKey: 'AIzaSyBhvxS9hLyt0X6ONOUTyxSonj40YGcMLBo',
    appId: '1:777105913510:web:3f2c7df5df7d0b113c6667',
    messagingSenderId: '777105913510',
    projectId: 'cvcv-bc6f0',
    authDomain: 'cvcv-bc6f0.firebaseapp.com',
    databaseURL: 'https://cvcv-bc6f0-default-rtdb.firebaseio.com',
    storageBucket: 'cvcv-bc6f0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAxzN1U5VCaF1PEbET9H4iArUowRMzcCfs',
    appId: '1:777105913510:android:2547196fe400b30e3c6667',
    messagingSenderId: '777105913510',
    projectId: 'cvcv-bc6f0',
    databaseURL: 'https://cvcv-bc6f0-default-rtdb.firebaseio.com',
    storageBucket: 'cvcv-bc6f0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMYoKtL6c-8ihQZNBKzD3xrnUgJtX8M7s',
    appId: '1:777105913510:ios:72352074679875ea3c6667',
    messagingSenderId: '777105913510',
    projectId: 'cvcv-bc6f0',
    databaseURL: 'https://cvcv-bc6f0-default-rtdb.firebaseio.com',
    storageBucket: 'cvcv-bc6f0.appspot.com',
    iosBundleId: 'com.example.grabitEcommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMYoKtL6c-8ihQZNBKzD3xrnUgJtX8M7s',
    appId: '1:777105913510:ios:72352074679875ea3c6667',
    messagingSenderId: '777105913510',
    projectId: 'cvcv-bc6f0',
    databaseURL: 'https://cvcv-bc6f0-default-rtdb.firebaseio.com',
    storageBucket: 'cvcv-bc6f0.appspot.com',
    iosBundleId: 'com.example.grabitEcommerce',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBhvxS9hLyt0X6ONOUTyxSonj40YGcMLBo',
    appId: '1:777105913510:web:03f8ab84b7e063793c6667',
    messagingSenderId: '777105913510',
    projectId: 'cvcv-bc6f0',
    authDomain: 'cvcv-bc6f0.firebaseapp.com',
    databaseURL: 'https://cvcv-bc6f0-default-rtdb.firebaseio.com',
    storageBucket: 'cvcv-bc6f0.appspot.com',
  );
}
