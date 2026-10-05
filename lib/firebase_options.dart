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
      default:
        throw UnsupportedError(
          'Fitenne supports Android and iOS only.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDfBQXd3L8fR6sAwt9Jl19ebte7zcSbLIY',
    appId: '1:745072329051:android:de668e633122d3a80e5a7e',
    messagingSenderId: '745072329051',
    projectId: 'fitness-app-60844',
    authDomain: 'fitness-app-60844.firebaseapp.com',
    storageBucket: 'fitness-app-60844.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfBQXd3L8fR6sAwt9Jl19ebte7zcSbLIY',
    appId: '1:745072329051:android:de668e633122d3a80e5a7e',
    messagingSenderId: '745072329051',
    projectId: 'fitness-app-60844',
    storageBucket: 'fitness-app-60844.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDE7pu3BoLBtYgAJqRsbYn1i3Orshliqsw',
    appId: '1:745072329051:ios:e614b498b1f6c6f20e5a7e',
    messagingSenderId: '745072329051',
    projectId: 'fitness-app-60844',
    storageBucket: 'fitness-app-60844.firebasestorage.app',
    iosBundleId: 'fitness-app-60844',
  );
}
