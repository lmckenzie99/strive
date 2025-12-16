import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDdIjTIrJk6Ic3j-R6Sx79WQtr4ABTy9QY",
            authDomain: "strive-sandbox-1fmtgy.firebaseapp.com",
            projectId: "strive-sandbox-1fmtgy",
            storageBucket: "strive-sandbox-1fmtgy.firebasestorage.app",
            messagingSenderId: "77709272191",
            appId: "1:77709272191:web:0872f9820185f72dd7cb4a",
            measurementId: "G-2654D2QX4L"));
  } else {
    await Firebase.initializeApp();
  }
}
