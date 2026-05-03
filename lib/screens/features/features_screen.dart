import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/local_storage_service.dart';
import '../../widgets/widgets.dart';
import '../alarms/alarms_screen.dart';
import '../locations/locations_screen.dart';
import '../automations/automations_screen.dart';
import '../reminders/reminders_screen.dart';

/// Özellikler Ekranı - Modern & Professional
class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  int _alarmsCount = 0;
  int _locationsCount = 0;
  int _automationsCount = 0;
  int _remindersCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = await LocalStorageService.getInstance();
    setState(() {
      _alarmsCount = storage.getAlarms().where((a) => a.isActive).length;
      _locationsCount = storage.getLocations().length;
      _automationsCount = storage
          .getAutomations()
          .where((a) => a.isActive)
          .length;
      _remindersCount = storage
          .getReminders()
          .where((r) => !r.isCompleted)
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: VarincaAppBar(title: 'Özellikler'),
            ),
            const SizedBox(height: 20),

            // 2x2 Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.82,
                  children: [
                    _buildFeatureCard(
                      'Alarmlar',
                      Icons.alarm_rounded,
                      '$_alarmsCount aktif',
                      const Color(0xFFFF6B6B),
                      () => _navigateToFeature(0),
                    ),
                    _buildFeatureCard(
                      'Konumlar',
                      Icons.location_on_rounded,
                      '$_locationsCount kayıtlı',
                      const Color(0xFF4ECDC4),
                      () => _navigateToFeature(1),
                    ),
                    _buildFeatureCard(
                      'Otomasyonlar',
                      Icons.auto_awesome_rounded,
                      '$_automationsCount aktif',
                      const Color(0xFF9B59B6),
                      () => _navigateToFeature(2),
                    ),
                    _buildFeatureCard(
                      'Hatırlatıcılar',
                      Icons.task_alt_rounded,
                      '$_remindersCount bekleyen',
                      const Color(0xFFF39C12),
                      () => _navigateToFeature(3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    IconData icon,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.softPink, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with colored background
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 4),
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.greyText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            // Arrow button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFeature(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = const AlarmsScreen();
        break;
      case 1:
        screen = const LocationsScreen();
        break;
      case 2:
        screen = const AutomationsScreen();
        break;
      case 3:
        screen = const RemindersScreen();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) => _loadData());
  }
}
