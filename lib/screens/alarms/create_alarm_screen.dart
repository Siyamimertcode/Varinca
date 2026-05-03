import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/widgets.dart';

/// Alarm Oluşturma Ekranı
class CreateAlarmScreen extends StatefulWidget {
  const CreateAlarmScreen({super.key});

  @override
  State<CreateAlarmScreen> createState() => _CreateAlarmScreenState();
}

class _CreateAlarmScreenState extends State<CreateAlarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  String? _selectedLocation;
  int _selectedDistance = 500; // metre
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoMessageEnabled = false;
  String _selectedRingtone = 'Varsayılan';

  final List<int> _distanceOptions = [
    100,
    200,
    300,
    500,
    750,
    1000,
    1500,
    2000,
  ];

  final List<Map<String, dynamic>> _savedLocations = [
    {
      'name': 'Ev',
      'address': 'Kartal Merkez, İstanbul',
      'icon': Icons.home_rounded,
    },
    {
      'name': 'İş',
      'address': 'Kadıköy Business Center',
      'icon': Icons.business_rounded,
    },
    {
      'name': 'Spor Salonu',
      'address': 'Mac Fit, Maltepe',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'name': 'Market',
      'address': 'Migros, Bostancı',
      'icon': Icons.shopping_cart_rounded,
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveAlarm() {
    if (_formKey.currentState!.validate() && _selectedLocation != null) {
      // Alarmı kaydet
      Navigator.pop(context, {
        'title': _titleController.text,
        'location': _selectedLocation,
        'distance': _selectedDistance,
        'sound': _soundEnabled,
        'vibration': _vibrationEnabled,
        'autoMessage': _autoMessageEnabled,
        'note': _noteController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Alarm başarıyla oluşturuldu!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen bir konum seçin'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
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
                title: 'Yeni Alarm',
                showBackButton: true,
                actions: [
                  TextButton(
                    onPressed: _saveAlarm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Kaydet',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
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
                      // Alarm Adı
                      _buildSectionTitle('Alarm Adı'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _titleController,
                        hint: 'örn: İşe Gidiş Alarmı',
                        icon: Icons.edit_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen alarm adı girin';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      // Konum Seçimi
                      _buildSectionTitle('Hedef Konum'),
                      const SizedBox(height: 12),
                      _buildLocationSelector(),

                      const SizedBox(height: 28),

                      // Mesafe Seçimi
                      _buildSectionTitle('Uyarı Mesafesi'),
                      const SizedBox(height: 8),
                      Text(
                        'Hedefe ne kadar yaklaştığında uyarılmak istiyorsun?',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.greyText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDistanceSelector(),

                      const SizedBox(height: 28),

                      // Uyarı Ayarları
                      _buildSectionTitle('Uyarı Ayarları'),
                      const SizedBox(height: 12),
                      _buildSettingsCard(),

                      const SizedBox(height: 28),

                      // Not
                      _buildSectionTitle('Not (İsteğe Bağlı)'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _noteController,
                        hint: 'Alarm için bir not ekle...',
                        icon: Icons.note_rounded,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 40),
                    ],
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

  Widget _buildLocationSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Column(
        children: [
          // Yeni konum ekle butonu
          InkWell(
            onTap: () {
              // Haritadan konum seç
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.softPink.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.add_location_alt_rounded,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Haritadan Konum Seç',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkText,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Yeni bir konum belirle',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.greyText,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // Kayıtlı konumlar
          ..._savedLocations.map((location) => _buildLocationTile(location)),
        ],
      ),
    );
  }

  Widget _buildLocationTile(Map<String, dynamic> location) {
    final isSelected = _selectedLocation == location['name'];
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLocation = location['name'];
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.softPink.withValues(alpha: 0.3) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryRed : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                location['icon'],
                color: isSelected ? AppColors.white : AppColors.greyText,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location['name'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location['address'],
                    style: TextStyle(fontSize: 12, color: AppColors.greyText),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Column(
        children: [
          // Seçili mesafe göstergesi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppDecorations.primaryShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.near_me_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedDistance >= 1000
                      ? '${(_selectedDistance / 1000).toStringAsFixed(1)} km'
                      : '$_selectedDistance m',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const Text(
                  ' kala uyar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Mesafe seçenekleri
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _distanceOptions.map((distance) {
              final isSelected = _selectedDistance == distance;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDistance = distance;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryRed
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? null
                        : Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    distance >= 1000
                        ? '${(distance / 1000).toStringAsFixed(1)} km'
                        : '$distance m',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.darkText,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.volume_up_rounded,
            title: 'Ses',
            subtitle: 'Alarm sesi çal',
            value: _soundEnabled,
            onChanged: (value) => setState(() => _soundEnabled = value),
          ),
          const Divider(height: 1, indent: 70),
          _buildSwitchTile(
            icon: Icons.vibration_rounded,
            title: 'Titreşim',
            subtitle: 'Telefonunu titret',
            value: _vibrationEnabled,
            onChanged: (value) => setState(() => _vibrationEnabled = value),
          ),
          const Divider(height: 1, indent: 70),
          _buildSwitchTile(
            icon: Icons.message_rounded,
            title: 'Otomatik Mesaj',
            subtitle: 'Varınca mesaj gönder',
            value: _autoMessageEnabled,
            onChanged: (value) => setState(() => _autoMessageEnabled = value),
          ),
          const Divider(height: 1, indent: 70),
          _buildNavigationTile(
            icon: Icons.music_note_rounded,
            title: 'Zil Sesi',
            value: _selectedRingtone,
            onTap: () {
              // Zil sesi seçici
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.softPink.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryRed, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: AppColors.greyText),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryRed,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.softPink.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryRed, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkText,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 14, color: AppColors.greyText),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.greyText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
