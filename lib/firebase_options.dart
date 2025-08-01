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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDM_M-D3O1rfvGO74vfuLRKS_txg4Gf5yo',
    appId: '1:409329025378:android:8712cc8030e0fb0b9c2c3b',
    messagingSenderId: '409329025378',
    projectId: 'luna-3-7e89c',
    storageBucket: 'luna-3-7e89c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBtxHdJt1k9aC_ld6q444cgOt0RSU9wFYM',
    appId: '1:409329025378:ios:b69a1600b09a6e949c2c3b',
    messagingSenderId: '409329025378',
    projectId: 'luna-3-7e89c',
    storageBucket: 'luna-3-7e89c.firebasestorage.app',
    iosBundleId: 'com.example.luna3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBtxHdJt1k9aC_ld6q444cgOt0RSU9wFYM',
    appId: '1:409329025378:ios:b69a1600b09a6e949c2c3b',
    messagingSenderId: '409329025378',
    projectId: 'luna-3-7e89c',
    storageBucket: 'luna-3-7e89c.firebasestorage.app',
    androidClientId: '409329025378-jpd80tln70d1lq286iiv9mb8l5oki9a2.apps.googleusercontent.com',
    iosClientId: '409329025378-7007m8knuietc4dojl64sr6t9eq6rilu.apps.googleusercontent.com',
    iosBundleId: 'com.example.luna3',
  );

}