import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/local_storage_service.dart';
import '../../widgets/widgets.dart';
import 'create_reminder_screen.dart';

/// Hatırlatıcılar Ekranı
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<ReminderData> _reminders = [];
  String _selectedFilter = 'Bekleyen';

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
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final storage = await LocalStorageService.getInstance();
    setState(() {
      _reminders = storage.getReminders();
    });

    // Demo verisi ekle eğer boşsa
    if (_reminders.isEmpty) {
      _addDemoData();
    }
  }

  void _addDemoData() {
    _reminders = [
      ReminderData(
        id: '1',
        title: 'Market alışverişi yap',
        note: 'Süt, ekmek, peynir al',
        locationId: 'loc1',
        locationName: 'Migros',
        distanceMeters: 200,
        isActive: true,
        isCompleted: false,
      ),
      ReminderData(
        id: '2',
        title: 'Kargo al',
        note: 'PTT şubesinden',
        locationId: 'loc2',
        locationName: 'PTT',
        distanceMeters: 100,
        isActive: true,
        isCompleted: false,
      ),
      ReminderData(
        id: '3',
        title: 'Fatura öde',
        note: 'Elektrik faturası',
        locationId: 'loc3',
        locationName: 'Banka',
        distanceMeters: 150,
        isActive: true,
        isCompleted: true,
      ),
      ReminderData(
        id: '4',
        title: 'Araç yıkat',
        locationId: 'loc4',
        locationName: 'Oto Yıkama',
        distanceMeters: 300,
        isActive: true,
        isCompleted: false,
      ),
    ];
  }

  List<ReminderData> get filteredReminders {
    switch (_selectedFilter) {
      case 'Bekleyen':
        return _reminders.where((r) => !r.isCompleted).toList();
      case 'Tamamlanan':
        return _reminders.where((r) => r.isCompleted).toList();
      default:
        return _reminders;
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
                  title: 'Hatırlatıcılar',
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

              // Reminders List
              Expanded(
                child: filteredReminders.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredReminders.length,
                        itemBuilder: (context, index) {
                          return _buildReminderCard(
                            filteredReminders[index],
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
      MaterialPageRoute(builder: (_) => const CreateReminderScreen()),
    ).then((_) => _loadReminders());
  }

  Widget _buildFilterChips() {
    final filters = ['Bekleyen', 'Tamamlanan', 'Tümü'];
    return Row(
      children: filters.map((filter) {
        final isSelected = _selectedFilter == filter;
        return GestureDetector(
          onTap: () => setState(() => _selectedFilter = filter),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF39C12) : AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFFF39C12) : AppColors.border,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFF39C12).withValues(alpha: 0.3),
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

  Widget _buildInfoCard() {
    final pendingCount = _reminders.where((r) => !r.isCompleted).length;
    final completedCount = _reminders.where((r) => r.isCompleted).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF39C12), Color(0xFFE67E22)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF39C12).withValues(alpha: 0.3),
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
              Icons.task_alt_rounded,
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
                  'Konum Hatırlatıcıları',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pendingCount bekleyen · $completedCount tamamlanan',
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
    final isShowingCompleted = _selectedFilter == 'Tamamlanan';
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
            child: Icon(
              isShowingCompleted
                  ? Icons.check_circle_outline_rounded
                  : Icons.task_outlined,
              color: const Color(0xFFF39C12),
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isShowingCompleted
                ? 'Tamamlanan Hatırlatıcı Yok'
                : 'Hatırlatıcı Bulunamadı',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isShowingCompleted
                ? 'Henüz tamamlanan görev yok'
                : 'İlk hatırlatıcınızı oluşturun',
            style: TextStyle(fontSize: 14, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(ReminderData reminder, int index) {
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
              // Edit reminder
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        final idx = _reminders.indexOf(reminder);
                        _reminders[idx] = reminder.copyWith(
                          isCompleted: !reminder.isCompleted,
                        );
                      });
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: reminder.isCompleted
                            ? AppColors.success
                            : Colors.transparent,
                        border: Border.all(
                          color: reminder.isCompleted
                              ? AppColors.success
                              : AppColors.border,
                          width: 2,
                        ),
                      ),
                      child: reminder.isCompleted
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.white,
                              size: 18,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: reminder.isCompleted
                                ? AppColors.greyText
                                : AppColors.darkText,
                            decoration: reminder.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (reminder.note != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            reminder.note!,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.greyText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildTag(
                              reminder.locationName,
                              const Color(0xFFF39C12).withValues(alpha: 0.1),
                              const Color(0xFFF39C12),
                              Icons.location_on_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildTag(
                              '${reminder.distanceMeters}m',
                              AppColors.info.withValues(alpha: 0.1),
                              AppColors.info,
                              Icons.straighten_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // More button
                  IconButton(
                    onPressed: () => _showOptions(reminder),
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.greyText,
                    ),
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

  void _showOptions(ReminderData reminder) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                icon: reminder.isCompleted
                    ? Icons.undo_rounded
                    : Icons.check_circle_rounded,
                title: reminder.isCompleted ? 'Tamamlanmadı' : 'Tamamlandı',
                color: AppColors.success,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    final idx = _reminders.indexOf(reminder);
                    _reminders[idx] = reminder.copyWith(
                      isCompleted: !reminder.isCompleted,
                    );
                  });
                },
              ),
              _buildOptionTile(
                icon: Icons.edit_rounded,
                title: 'Düzenle',
                color: const Color(0xFFF39C12),
                onTap: () {
                  Navigator.pop(context);
                  // Edit
                },
              ),
              _buildOptionTile(
                icon: Icons.delete_rounded,
                title: 'Sil',
                color: AppColors.error,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _reminders.removeWhere((r) => r.id == reminder.id);
                  });
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkText,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: AppColors.greyText,
      ),
    );
  }
}
