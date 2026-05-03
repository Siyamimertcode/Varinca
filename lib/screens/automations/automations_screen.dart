import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/local_storage_service.dart';
import '../../widgets/widgets.dart';
import 'create_automation_screen.dart';

/// Otomasyonlar Ekranı
class AutomationsScreen extends StatefulWidget {
  const AutomationsScreen({super.key});

  @override
  State<AutomationsScreen> createState() => _AutomationsScreenState();
}

class _AutomationsScreenState extends State<AutomationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<AutomationData> _automations = [];
  String _selectedFilter = 'Tümü';

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
    _loadAutomations();
  }

  Future<void> _loadAutomations() async {
    final storage = await LocalStorageService.getInstance();
    setState(() {
      _automations = storage.getAutomations();
    });

    // Demo verisi ekle eğer boşsa
    if (_automations.isEmpty) {
      _addDemoData();
    }
  }

  void _addDemoData() {
    _automations = [
      AutomationData(
        id: '1',
        title: 'İş Sessiz Modu',
        locationId: 'loc1',
        locationName: 'Ofis',
        distanceMeters: 100,
        trigger: AutomationTrigger.entering,
        actions: [
          AutomationAction(type: AutomationActionType.silentMode),
          AutomationAction(type: AutomationActionType.wifiOn),
        ],
        isActive: true,
      ),
      AutomationData(
        id: '2',
        title: 'Eve Gelince',
        locationId: 'loc2',
        locationName: 'Ev',
        distanceMeters: 200,
        trigger: AutomationTrigger.entering,
        actions: [
          AutomationAction(type: AutomationActionType.wifiOn),
          AutomationAction(type: AutomationActionType.normalMode),
        ],
        isActive: true,
      ),
      AutomationData(
        id: '3',
        title: 'Toplantı Modu',
        locationId: 'loc3',
        locationName: 'Toplantı Odası',
        distanceMeters: 50,
        trigger: AutomationTrigger.entering,
        actions: [
          AutomationAction(type: AutomationActionType.dndOn),
          AutomationAction(type: AutomationActionType.silentMode),
        ],
        isActive: false,
      ),
    ];
  }

  List<AutomationData> get filteredAutomations {
    switch (_selectedFilter) {
      case 'Aktif':
        return _automations.where((a) => a.isActive).toList();
      case 'Pasif':
        return _automations.where((a) => !a.isActive).toList();
      default:
        return _automations;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                  title: 'Otomasyonlar',
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

              // Info Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildInfoCard(),
              ),

              const SizedBox(height: 20),

              // Automations List
              Expanded(
                child: filteredAutomations.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredAutomations.length,
                        itemBuilder: (context, index) {
                          return _buildAutomationCard(
                            filteredAutomations[index],
                            index,
                          );
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
      MaterialPageRoute(builder: (_) => const CreateAutomationScreen()),
    ).then((_) => _loadAutomations());
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
              border: Border.all(
                color: isSelected ? AppColors.primaryRed : AppColors.border,
              ),
              boxShadow: isSelected ? AppDecorations.primaryShadow : null,
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

  Widget _buildInfoCard() {
    final activeCount = _automations.where((a) => a.isActive).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF9B59B6), const Color(0xFF8E44AD)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B59B6).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Akıllı Otomasyonlar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$activeCount otomasyon aktif çalışıyor',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.border),
              boxShadow: AppDecorations.softShadow,
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              color: Color(0xFF9B59B6),
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Otomasyon Bulunamadı',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk otomasyonunuzu oluşturun',
            style: TextStyle(fontSize: 14, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationCard(AutomationData automation, int index) {
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
        margin: const EdgeInsets.only(bottom: 16),
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
              // Edit automation
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: automation.isActive
                              ? const Color(0xFF9B59B6).withValues(alpha: 0.1)
                              : AppColors.border.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: automation.isActive
                              ? const Color(0xFF9B59B6)
                              : AppColors.greyText,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              automation.title,
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
                                Text(
                                  automation.locationName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.greyText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Toggle
                      Switch(
                        value: automation.isActive,
                        onChanged: (value) {
                          setState(() {
                            final index = _automations.indexOf(automation);
                            _automations[index] = automation.copyWith(
                              isActive: value,
                            );
                          });
                        },
                        activeColor: const Color(0xFF9B59B6),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Trigger & Actions
                  Row(
                    children: [
                      _buildTag(
                        automation.trigger == AutomationTrigger.entering
                            ? 'Girerken'
                            : 'Çıkarken',
                        const Color(0xFF9B59B6).withValues(alpha: 0.1),
                        const Color(0xFF9B59B6),
                        Icons.login_rounded,
                      ),
                      const SizedBox(width: 8),
                      _buildTag(
                        '${automation.distanceMeters}m',
                        AppColors.info.withValues(alpha: 0.1),
                        AppColors.info,
                        Icons.straighten_rounded,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Actions
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: automation.actions.map((action) {
                      return _buildActionChip(action);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(AutomationAction action) {
    final actionInfo = _getActionInfo(action.type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.softPink,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(actionInfo.$1, size: 14, color: AppColors.primaryRed),
          const SizedBox(width: 4),
          Text(
            actionInfo.$2,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }

  (IconData, String) _getActionInfo(AutomationActionType type) {
    switch (type) {
      case AutomationActionType.notification:
        return (Icons.notifications_rounded, 'Bildirim');
      case AutomationActionType.wifiOff:
        return (Icons.wifi_off_rounded, 'WiFi Kapat');
      case AutomationActionType.wifiOn:
        return (Icons.wifi_rounded, 'WiFi Aç');
      case AutomationActionType.bluetoothOff:
        return (Icons.bluetooth_disabled_rounded, 'Bluetooth Kapat');
      case AutomationActionType.bluetoothOn:
        return (Icons.bluetooth_rounded, 'Bluetooth Aç');
      case AutomationActionType.silentMode:
        return (Icons.volume_off_rounded, 'Sessiz Mod');
      case AutomationActionType.vibrationMode:
        return (Icons.vibration_rounded, 'Titreşim');
      case AutomationActionType.normalMode:
        return (Icons.volume_up_rounded, 'Normal Mod');
      case AutomationActionType.airplaneOn:
        return (Icons.airplanemode_active_rounded, 'Uçak Modu Aç');
      case AutomationActionType.airplaneOff:
        return (Icons.airplanemode_inactive_rounded, 'Uçak Modu Kapat');
      case AutomationActionType.dndOn:
        return (Icons.do_not_disturb_on_rounded, 'Rahatsız Etmeyin');
      case AutomationActionType.dndOff:
        return (Icons.do_not_disturb_off_rounded, 'Rahatsız Etmeyin Kapat');
      case AutomationActionType.brightness:
        return (Icons.brightness_6_rounded, 'Parlaklık');
      case AutomationActionType.volume:
        return (Icons.volume_down_rounded, 'Ses Seviyesi');
    }
  }
}
