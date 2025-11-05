<<<<<<< Updated upstream
import 'package:book_app/app.dart';
=======
import 'package:book_app/core/routing/app_go_router.dart';
>>>>>>> Stashed changes
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/config_env.dart';
<<<<<<< Updated upstream
=======
// nếu bạn có file này (tự tạo từ Firebase)
>>>>>>> Stashed changes

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env file
  await dotenv.load(fileName: ".env");
  
  // Initialize Firebase with config from .env
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: ConfigEnv.apiKey,
      appId: ConfigEnv.appId,
      messagingSenderId: ConfigEnv.messagingSenderId,
      projectId: ConfigEnv.projectId,
      authDomain: ConfigEnv.authDomain,
      storageBucket: ConfigEnv.storageBucket,
      measurementId: ConfigEnv.measurementId,
    ),
  );

  // Use ProviderScope to enable providers (e.g. firebase and datasource)
  runApp(const ProviderScope(child: MyApp()));
}
