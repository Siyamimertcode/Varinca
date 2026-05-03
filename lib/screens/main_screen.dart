import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/widgets.dart';
import 'home/home_screen.dart';
import 'features/features_screen.dart';
import 'locations/locations_screen.dart';
import 'settings/settings_screen.dart';

/// Ana Ekran - Bottom Navigation ile Sayfa Yönetimi
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScale;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FeaturesScreen(),
    const LocationsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fabScale = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    // Index 2 merkez buton için ayrılmış, diğerleri için sayfa değiştir
    int pageIndex = index;
    if (index >= 2) {
      pageIndex = index;
    }

    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPink,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: VarincaBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
