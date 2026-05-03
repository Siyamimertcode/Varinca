import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/widgets.dart';

/// Konum Ekleme/Düzenleme Ekranı
class AddLocationScreen extends StatefulWidget {
  final Map<String, dynamic>? editLocation;

  const AddLocationScreen({super.key, this.editLocation});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedCategory = 'Diğer';
  bool _isFavorite = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Ev', 'icon': Icons.home_rounded, 'color': AppColors.primaryRed},
    {'name': 'İş', 'icon': Icons.business_rounded, 'color': AppColors.info},
    {
      'name': 'Spor',
      'icon': Icons.fitness_center_rounded,
      'color': AppColors.success,
    },
    {
      'name': 'Alışveriş',
      'icon': Icons.shopping_bag_rounded,
      'color': AppColors.warning,
    },
    {
      'name': 'Aile',
      'icon': Icons.family_restroom_rounded,
      'color': const Color(0xFFE91E63),
    },
    {
      'name': 'Sağlık',
      'icon': Icons.local_hospital_rounded,
      'color': const Color(0xFF9C27B0),
    },
    {
      'name': 'Okul',
      'icon': Icons.school_rounded,
      'color': const Color(0xFF00BCD4),
    },
    {'name': 'Diğer', 'icon': Icons.place_rounded, 'color': AppColors.greyText},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editLocation != null) {
      _nameController.text = widget.editLocation!['name'] ?? '';
      _addressController.text = widget.editLocation!['address'] ?? '';
      _selectedCategory = widget.editLocation!['category'] ?? 'Diğer';
      _isFavorite = widget.editLocation!['isFavorite'] ?? false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveLocation() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name': _nameController.text,
        'address': _addressController.text,
        'category': _selectedCategory,
        'isFavorite': _isFavorite,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.editLocation != null
                ? 'Konum güncellendi!'
                : 'Konum başarıyla kaydedildi!',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Map<String, dynamic> get _currentCategory {
    return _categories.firstWhere(
      (c) => c['name'] == _selectedCategory,
      orElse: () => _categories.last,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: VarincaAppBar(
                title: widget.editLocation != null
                    ? 'Konumu Düzenle'
                    : 'Yeni Konum',
                showBackButton: true,
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Harita Önizleme
                      _buildMapPreview(),

                      const SizedBox(height: 28),

                      // Konum Adı
                      _buildSectionTitle('Konum Adı'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _nameController,
                        hint: 'örn: Evim, Ofis',
                        icon: Icons.label_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen konum adı girin';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Adres
                      _buildSectionTitle('Adres'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _addressController,
                        hint: 'Adres veya koordinat',
                        icon: Icons.location_on_rounded,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen adres girin';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Kategori Seçimi
                      _buildSectionTitle('Kategori'),
                      const SizedBox(height: 12),
                      _buildCategorySelector(),

                      const SizedBox(height: 24),

                      // Favori
                      _buildFavoriteToggle(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Save Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: GestureDetector(
                  onTap: _saveLocation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryRed.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save_rounded,
                          color: AppColors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.editLocation != null
                              ? 'Kaydet'
                              : 'Konumu Kaydet',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Stack(
        children: [
          // Placeholder harita
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.softPink.withValues(alpha: 0.3),
                    AppColors.lightGrey,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppDecorations.mediumShadow,
                      ),
                      child: Icon(
                        Icons.map_rounded,
                        color: AppColors.primaryRed,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Haritadan konum seçmek için dokunun',
                      style: TextStyle(fontSize: 14, color: AppColors.greyText),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Mevcut konum butonu
          Positioned(
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () {
                // Mevcut konumu al
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppDecorations.mediumShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.my_location_rounded,
                      color: AppColors.primaryRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Konumum',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppDecorations.softShadow,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.greyText),
          prefixIcon: Icon(icon, color: AppColors.primaryRed),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Column(
        children: [
          // Seçili kategori göstergesi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (_currentCategory['color'] as Color).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _currentCategory['color'],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _currentCategory['icon'],
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  _currentCategory['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Kategori grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category['name'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (category['color'] as Color).withValues(alpha: 0.15)
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected
                        ? Border.all(color: category['color'], width: 2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        color: isSelected
                            ? category['color']
                            : AppColors.greyText,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? category['color']
                              : AppColors.greyText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppDecorations.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isFavorite
                    ? AppColors.warning.withValues(alpha: 0.15)
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                color: _isFavorite ? AppColors.warning : AppColors.greyText,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Favorilere Ekle',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  Text(
                    'Hızlı erişim için favorilere ekle',
                    style: TextStyle(fontSize: 12, color: AppColors.greyText),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isFavorite,
              onChanged: (value) {
                setState(() {
                  _isFavorite = value;
                });
              },
              activeColor: AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }
}
