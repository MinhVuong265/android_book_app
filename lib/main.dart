import 'package:book_app/core/routing/app_go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // 🕐 Nếu chưa có dữ liệu đăng nhập
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                home: Scaffold(body: Center(child: CircularProgressIndicator())),
              );
            }

            // 🧭 Router chỉ chạy khi FirebaseAuth đã sẵn sàng
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Book App',
              routerConfig: AppGoRouter.router,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
                useMaterial3: true,
              ),
            );
          },
        );
      },
    );
  }
}
