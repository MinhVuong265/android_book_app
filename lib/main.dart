import 'package:book_app/app.dart';
import 'package:book_app/core/routing/app_go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/config_env.dart';
import 'firebase_options.dart'; // nếu bạn có file này (tự tạo từ Firebase)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
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

  // Run app with Riverpod provider scope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp.router(
          title: 'Book App',
          routerConfig: AppGoRouter.router,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}



// CÁI MAIN.DART DƯỚI LỖI KHÔNG CHẠY ĐƯỢC

// import 'package:book_app/core/routing/app_go_router.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart'; // nếu bạn có file này (tự tạo từ Firebase)

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const MaterialApp(
//             home: Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             ),
//           );
//         }

//         // ✅ DÙ đăng nhập hay chưa, ta chỉ dùng MỘT MaterialApp.router duy nhất
//         return MaterialApp.router(
//           title: 'Book App',
//           routerConfig: AppGoRouter.router,
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
//             useMaterial3: true,
//           ),
//         );
//       },
//     );
//   }
// }
