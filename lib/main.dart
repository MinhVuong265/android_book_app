import 'package:book_app/core/routing/app_go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 👈 thêm dòng này
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // nếu bạn có file này (tự tạo từ Firebase)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 👇 Bọc ứng dụng trong ProviderScope
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
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

