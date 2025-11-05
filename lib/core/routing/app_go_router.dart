import 'package:book_app/features/books/presentation/pages/add_edit_book_page.dart';
import 'package:book_app/features/categories/presentation/pages/category_list_page.dart';
import 'package:book_app/features/home/presentation/pages/home_page.dart';
import 'package:book_app/features/users/presentation/pages/user_list_page.dart';
import 'package:flutter/material.dart';
import 'package:book_app/features/home/presentation/pages/home_page.dart';
// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/features/auth/presentation/pages/login_page.dart';
import 'package:book_app/features/auth/presentation/pages/signup_page.dart';
import 'package:book_app/features/books/presentation/pages/book_reader_page.dart';
import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'app_routes.dart';
import 'package:book_app/features/library/presentation/pages/favorite_books_page.dart';
import 'package:book_app/features/library/presentation/pages/reading_history_page.dart';
import 'package:book_app/features/profile/presentation/pages/my_profile_page.dart';
import 'package:book_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:book_app/features/library/presentation/pages/my_collection_page.dart';

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
      GoRoute(path: AppRoutes.addEditBook, builder: (context, state) {
        final book = state.extra as BookEntity?;
        return AddEditBookPage(book: book);
      }),
      GoRoute(path: AppRoutes.users, builder: (context, state) {
        return const UsersScreen();
      }),
      GoRoute(path: AppRoutes.categories, builder: (context, state) {
        return const CategoriesScreen();
      }),
      GoRoute(
        path: AppRoutes.addEditBook,
        builder: (context, state) {
          final book = state.extra as BookEntity?;
          return AddEditBookPage(book: book);
        },
      ),
      GoRoute(
        path: AppRoutes.library,
        builder: (context, state) => const FavoriteBooksPage(),
      ),
      GoRoute(
        path: AppRoutes.libraryFavorites,
        builder: (context, state) => const FavoriteBooksPage(),
      ),
      GoRoute(
        path: AppRoutes.libraryHistory,
        builder: (context, state) => const ReadingHistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const MyProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.collection,
        builder: (context, state) {
          final user = FirebaseAuth.instance.currentUser;
          return MyCollectionPage(
            userName: user?.displayName ?? user?.email ?? 'User',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addEditBook,
        builder: (context, state) {
          final book = state.extra as BookEntity?;
          return AddEditBookPage(book: book);
        },
      ),
    ],
  );
}
