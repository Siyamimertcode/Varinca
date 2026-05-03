import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'core/services/local_storage_service.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/profile_setup_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VarincaApp());
}

class VarincaApp extends StatelessWidget {
  const VarincaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Varınca',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppStartup(),
    );
  }
}

/// App Startup - İlk açılış kontrolü
class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    await Future.delayed(const Duration(milliseconds: 100));

    final storage = await LocalStorageService.getInstance();
    final isFirstTime = storage.isFirstTime();
    final userProfile = storage.getUserProfile();

    if (!mounted) return;

    Widget nextScreen;

    if (isFirstTime || userProfile == null) {
      // İlk kez açılıyor - Splash -> Onboarding -> Profile Setup
      nextScreen = const SplashScreen();
    } else {
      // Kullanıcı var - Direkt ana ekran
      nextScreen = const MainScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Center(child: CircularProgressIndicator(color: Color(0xFFEA2630))),
    );
  }
}
