import 'package:book_app/features/books/presentation/pages/add_edit_book_page.dart';
import 'package:book_app/features/home/presentation/pages/home_page.dart';
// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/features/auth/presentation/pages/login_page.dart';
import 'package:book_app/features/auth/presentation/pages/signup_page.dart';
import 'package:book_app/features/books/presentation/pages/book_reader_page.dart';
import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'app_routes.dart';
import 'package:book_app/features/profile/presentation/pages/my_profile_page.dart';
import 'package:book_app/features/profile/presentation/pages/edit_profile_page.dart';

class AppGoRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggingIn = state.matchedLocation == AppRoutes.login;

      // 🔒 Chưa đăng nhập → luôn về login
      if (user == null && !loggingIn) return AppRoutes.login;

      // 🔓 Đã đăng nhập mà vẫn ở login → chuyển về home
      if (user != null && loggingIn) return AppRoutes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.readBook,
        builder: (context, state) {
          final book = state.extra as BookEntity;
          return BookReaderPage(book: book);
        },
      ),
      GoRoute(
        path: AppRoutes.addEditBook,
        builder: (context, state) {
          final book = state.extra as BookEntity?;
          return AddEditBookPage(book: book);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const MyProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
  );
}
