import 'package:book_app/core/routing/app_go_router.dart';
import 'package:book_app/features/home/presentation/pages/home_page.dart';
import 'package:book_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:book_app/features/auth/presentation/pages/login_page.dart';
import 'package:book_app/features/auth/presentation/pages/signup_page.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ✅ Nếu đang kiểm tra trạng thái đăng nhập
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // ✅ Nếu chưa đăng nhập → mở router (GoRouter sẽ tự điều hướng)
        if (!snapshot.hasData) {
          return MaterialApp.router(
            routerConfig: AppGoRouter.router,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
              useMaterial3: true,
            ),
          );
        }

        // ✅ Nếu đã đăng nhập → vào HomePage trực tiếp
        return MaterialApp(
          home: const HomePage(),
        );
      },
    );
  }
}
