import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../shared/widgets/error_page.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
        
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
        
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );
        
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(title: 'CineMatch'),
          settings: settings,
        );
        
      default:
        return MaterialPageRoute(
          builder: (context) => ErrorPage(
            error: 'Route not found: ${settings.name}',
            onRetry: () => Navigator.of(context).pushReplacementNamed(AppRoutes.home),
          ),
          settings: settings,
        );
    }
  }
}
