import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/services/theme_service.dart';
import 'core/services/api_service.dart';
import 'core/services/keep_alive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API service
  ApiService.init();

  // Start keep-alive service to prevent backend from sleeping
  KeepAliveService.start();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Stop keep-alive service when app is disposed
    KeepAliveService.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Ping server when app comes to foreground to wake it up if it was sleeping
    if (state == AppLifecycleState.resumed) {
      KeepAliveService.forcePing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'CineMatch - Movie Suggestions',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRoutes.splash,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
