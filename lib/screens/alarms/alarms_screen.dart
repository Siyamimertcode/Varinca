import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/widgets.dart';
import 'create_alarm_screen.dart';

/// Alarmlar Ekranı
class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({super.key});

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _selectedFilter = 'Tümü';

  final List<AlarmItem> _alarms = [
    AlarmItem(
      id: '1',
      title: 'İşe Gidiş',
      location: 'Ofis Binası, Kadıköy',
      distance: '500m',
      isActive: true,
      icon: Icons.business_rounded,
      time: '08:30',
    ),
    AlarmItem(
      id: '2',
      title: 'Market Alışverişi',
      location: 'Migros, Bostancı',
      distance: '200m',
      isActive: true,
      icon: Icons.shopping_cart_rounded,
      time: null,
    ),
    AlarmItem(
      id: '3',
      title: 'Spor Salonu',
      location: 'Mac Fit, Maltepe',
      distance: '100m',
      isActive: false,
      icon: Icons.fitness_center_rounded,
      time: '18:00',
    ),
    AlarmItem(
      id: '4',
      title: 'Ev',
      location: 'Kartal Merkez',
      distance: '1km',
      isActive: true,
      icon: Icons.home_rounded,
      time: null,
    ),
    AlarmItem(
      id: '5',
      title: 'Doktor Randevusu',
      location: 'Memorial Hastanesi',
      distance: '300m',
      isActive: false,
      icon: Icons.local_hospital_rounded,
      time: '14:30',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<AlarmItem> get filteredAlarms {
    switch (_selectedFilter) {
      case 'Aktif':
        return _alarms.where((a) => a.isActive).toList();
      case 'Pasif':
        return _alarms.where((a) => !a.isActive).toList();
      default:
        return _alarms;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: VarincaAppBar(
                  title: 'Alarmlarım',
                  showBackButton: true,
                  actions: [
                    AppBarActionButton(
                      icon: Icons.add_rounded,
                      onTap: () => _navigateToCreate(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildFilterChips(),
              ),

              const SizedBox(height: 16),

              // Alarm Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildAlarmStats(),
              ),

              const SizedBox(height: 20),

              // Alarms List
              Expanded(
                child: filteredAlarms.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredAlarms.length,
                        itemBuilder: (context, index) {
                          return _buildAlarmTile(filteredAlarms[index], index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAlarmScreen()),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Tümü', 'Aktif', 'Pasif'];
    return Row(
      children: filters.map((filter) {
        final isSelected = _selectedFilter == filter;
        return GestureDetector(
          onTap: () => setState(() => _selectedFilter = filter),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryRed : AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryRed.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              filter,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.greyText,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlarmStats() {
    final activeCount = _alarms.where((a) => a.isActive).length;
    final inactiveCount = _alarms.length - activeCount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Toplam',
              '${_alarms.length}',
              AppColors.primaryRed,
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.lightGrey),
          Expanded(
            child: _buildStatItem('Aktif', '$activeCount', AppColors.success),
          ),
          Container(width: 1, height: 40, color: AppColors.lightGrey),
          Expanded(
            child: _buildStatItem(
              'Pasif',
              '$inactiveCount',
              AppColors.greyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.darkText.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
              boxShadow: AppDecorations.softShadow,
            ),
            child: Icon(
              Icons.alarm_off_rounded,
              color: AppColors.softPink,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Alarm Bulunamadı',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bu kategoride henüz alarm yok',
            style: TextStyle(fontSize: 14, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmTile(AlarmItem alarm, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: AppDecorations.softShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // TODO: Open alarm detail
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: alarm.isActive
                          ? AppColors.softPink
                          : AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      alarm.icon,
                      color: alarm.isActive
                          ? AppColors.primaryRed
                          : AppColors.greyText,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alarm.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: AppColors.greyText,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                alarm.location,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _buildTag(
                              '${alarm.distance} kala',
                              AppColors.info.withValues(alpha: 0.1),
                              AppColors.info,
                            ),
                            if (alarm.time != null) ...[
                              const SizedBox(width: 8),
                              _buildTag(
                                alarm.time!,
                                AppColors.warning.withValues(alpha: 0.1),
                                AppColors.warning,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Toggle
                  Switch(
                    value: alarm.isActive,
                    onChanged: (value) {
                      setState(() {
                        alarm.isActive = value;
                      });
                    },
                    activeColor: AppColors.primaryRed,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

/// Alarm data model
class AlarmItem {
  final String id;
  final String title;
  final String location;
  final String distance;
  bool isActive;
  final IconData icon;
  final String? time;

  AlarmItem({
    required this.id,
    required this.title,
    required this.location,
    required this.distance,
    required this.isActive,
    required this.icon,
    this.time,
  });
}
