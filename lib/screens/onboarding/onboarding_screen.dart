import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../auth/profile_setup_screen.dart';

/// Onboarding Screen - Kırmızı Tema
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.alarm_on_rounded,
      title: 'Doğru Yerde,\nDoğru Anda Uyan',
      description:
          'Konuma duyarlı akıllı alarm, varmak istediğin noktaya yaklaştığında seni zamanında uyarır.',
    ),
    OnboardingData(
      icon: Icons.auto_awesome_rounded,
      title: 'Vardığın Anda\nOtomatik Aksiyon',
      description:
          'Belirlediğin konuma ulaştığında telefonun otomatik olarak sessize alınır veya rutin çalışır.',
    ),
    OnboardingData(
      icon: Icons.people_alt_rounded,
      title: 'Sevdiklerine\nAnında Bilgi Gitsin',
      description:
          'Varınca, belirlediğin kişilere otomatik mesaj gönderir. Sen yolda odaklanırken, onlar haberdar olur.',
    ),
    OnboardingData(
      icon: Icons.task_alt_rounded,
      title: 'Unutma, Atlama\nZaman Kaybetme Yok',
      description:
          'Konuma bağlı hatırlatmalar sayesinde durağı kaçırmaz, önemli noktaları atlamazsın.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ProfileSetupScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    data: _pages[index],
                    pageIndex: index,
                    isActive: index == _currentPage,
                  );
                },
              ),
            ),

            // Bottom Section
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppDecorations.softShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/varincalogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Varınca',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          // Skip
          TextButton(
            onPressed: _finishOnboarding,
            child: Text(
              'Atla',
              style: TextStyle(
                color: AppColors.greyText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == _currentPage ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: index == _currentPage
                      ? AppColors.primaryRed
                      : AppColors.softPink,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Buttons
          Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: _buildOutlinedButton('Geri', onPressed: _previousPage),
                ),
              if (_currentPage > 0) const SizedBox(width: 16),
              Expanded(
                flex: _currentPage == 0 ? 1 : 1,
                child: _buildPrimaryButton(
                  _currentPage == _pages.length - 1 ? 'Başla' : 'İleri',
                  onPressed: _nextPage,
                  showArrow: _currentPage < _pages.length - 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(
    String text, {
    required VoidCallback onPressed,
    bool showArrow = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppDecorations.primaryShadow,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(String text, {required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        side: BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      ),
    );
  }
}

/// Onboarding Page Widget
class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final int pageIndex;
  final bool isActive;

  const _OnboardingPage({
    required this.data,
    required this.pageIndex,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with red theme
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: isActive ? value : 0.8,
                child: child,
              );
            },
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.softPink.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: AppDecorations.primaryShadow,
                  ),
                  child: Icon(data.icon, size: 50, color: AppColors.white),
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Title
          AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Description
          AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.greyText,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Onboarding Data Model
class OnboardingData {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
