//import 'package:book_app/features/categories/presentation/pages/category_list_page.dart';
import 'package:book_app/features/users/presentation/pages/user_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root application widget.
///
/// This widget is intended to be used with a `ProviderScope` wrapper in
/// `main()` (for example: `runApp(ProviderScope(child: const MyApp()))`).
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Book App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white, // Thêm màu nền trắng
        colorScheme: ColorScheme.light(
          primary: Colors.blue, // Màu chủ đạo
          background: Colors.white, // Màu nền
        ),
      ),
      // home: const Scaffold(
      //   body: Center(
      //     child: Text('Welcome to Book App'),
      //   ),
      // ),
      home: const UsersScreen(),
      // home: const CategoriesScreen(),
    );
  }
}
