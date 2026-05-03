import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/widgets.dart';

/// Konumlar Ekranı
class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<LocationItem> _locations = [
    LocationItem(
      id: '1',
      name: 'Ev',
      address: 'Kartal Merkez, İstanbul',
      category: LocationCategory.home,
      isFavorite: true,
      alarmsCount: 2,
    ),
    LocationItem(
      id: '2',
      name: 'Ofis',
      address: 'Kadıköy Business Center, İstanbul',
      category: LocationCategory.work,
      isFavorite: true,
      alarmsCount: 1,
    ),
    LocationItem(
      id: '3',
      name: 'Spor Salonu',
      address: 'Mac Fit, Maltepe, İstanbul',
      category: LocationCategory.sport,
      isFavorite: false,
      alarmsCount: 1,
    ),
    LocationItem(
      id: '4',
      name: 'Market',
      address: 'Migros, Bostancı, İstanbul',
      category: LocationCategory.shopping,
      isFavorite: false,
      alarmsCount: 1,
    ),
    LocationItem(
      id: '5',
      name: 'Anne Evi',
      address: 'Pendik, İstanbul',
      category: LocationCategory.family,
      isFavorite: true,
      alarmsCount: 0,
    ),
    LocationItem(
      id: '6',
      name: 'Hastane',
      address: 'Memorial Hospital, Ataşehir',
      category: LocationCategory.health,
      isFavorite: false,
      alarmsCount: 1,
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

  @override
  Widget build(BuildContext context) {
    final favoriteLocations = _locations.where((l) => l.isFavorite).toList();
    final recentLocations = _locations.where((l) => !l.isFavorite).toList();

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
                child: VarincaAppBar(title: 'Konumlarım', showBackButton: true),
              ),

              const SizedBox(height: 20),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Add Section
                      _buildQuickAddSection(),

                      const SizedBox(height: 24),

                      // Favorites Section
                      if (favoriteLocations.isNotEmpty) ...[
                        _buildSectionHeader(
                          'Favoriler',
                          Icons.star_rounded,
                          AppColors.warning,
                        ),
                        const SizedBox(height: 12),
                        ...favoriteLocations.map(
                          (loc) => _buildLocationCard(loc),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // All Locations Section
                      _buildSectionHeader(
                        'Diğer Konumlar',
                        Icons.location_on_rounded,
                        AppColors.info,
                      ),
                      const SizedBox(height: 12),
                      ...recentLocations.map((loc) => _buildLocationCard(loc)),

                      const SizedBox(height: 100), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAddSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_location_alt_rounded,
                  color: AppColors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yeni Konum Ekle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Haritadan veya adres arayarak ekle',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickButton(
                  'Haritadan Seç',
                  Icons.map_outlined,
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickButton(
                  'Mevcut Konum',
                  Icons.my_location_rounded,
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(LocationItem location) {
    return Container(
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
            // TODO: Open location detail
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Category Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: location.category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    location.category.icon,
                    color: location.category.color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            location.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkText,
                            ),
                          ),
                          if (location.isFavorite) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warning,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.greyText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            '${location.alarmsCount} Alarm',
                            Icons.alarm_rounded,
                            location.alarmsCount > 0
                                ? AppColors.primaryRed
                                : AppColors.greyText,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            location.category.label,
                            location.category.icon,
                            location.category.color,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          location.isFavorite = !location.isFavorite;
                        });
                      },
                      icon: Icon(
                        location.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: location.isFavorite
                            ? AppColors.warning
                            : AppColors.greyText,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.greyText,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Location category enum
enum LocationCategory {
  home,
  work,
  sport,
  shopping,
  family,
  health,
  other;

  String get label {
    switch (this) {
      case LocationCategory.home:
        return 'Ev';
      case LocationCategory.work:
        return 'İş';
      case LocationCategory.sport:
        return 'Spor';
      case LocationCategory.shopping:
        return 'Alışveriş';
      case LocationCategory.family:
        return 'Aile';
      case LocationCategory.health:
        return 'Sağlık';
      case LocationCategory.other:
        return 'Diğer';
    }
  }

  IconData get icon {
    switch (this) {
      case LocationCategory.home:
        return Icons.home_rounded;
      case LocationCategory.work:
        return Icons.business_rounded;
      case LocationCategory.sport:
        return Icons.fitness_center_rounded;
      case LocationCategory.shopping:
        return Icons.shopping_bag_rounded;
      case LocationCategory.family:
        return Icons.family_restroom_rounded;
      case LocationCategory.health:
        return Icons.local_hospital_rounded;
      case LocationCategory.other:
        return Icons.place_rounded;
    }
  }

  Color get color {
    switch (this) {
      case LocationCategory.home:
        return AppColors.primaryRed;
      case LocationCategory.work:
        return AppColors.info;
      case LocationCategory.sport:
        return AppColors.success;
      case LocationCategory.shopping:
        return AppColors.warning;
      case LocationCategory.family:
        return const Color(0xFFE91E63);
      case LocationCategory.health:
        return const Color(0xFF9C27B0);
      case LocationCategory.other:
        return AppColors.greyText;
    }
  }
}

/// Location data model
class LocationItem {
  final String id;
  final String name;
  final String address;
  final LocationCategory category;
  bool isFavorite;
  final int alarmsCount;

  LocationItem({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.isFavorite,
    required this.alarmsCount,
  });
}
