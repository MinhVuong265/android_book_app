
import 'package:book_app/core/routing/app_routes.dart';
import 'package:book_app/features/auth/presentation/pages/login_page.dart';
import 'package:book_app/features/auth/presentation/pages/signup_page.dart';
import 'package:book_app/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginPage()),
      GoRoute(path: AppRoutes.signup, builder: (context, state) => const SignupPage()),
      GoRoute(path: AppRoutes.home, builder: (context, state) => const HomePage()),
    ],
  );
}