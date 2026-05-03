import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/local_storage_service.dart';
import '../../widgets/widgets.dart';

/// Ayarlar Ekranı - Geliştirilmiş
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoStartEnabled = true;
  bool _locationTrackingEnabled = true;
  bool _batteryOptimizationEnabled = true;

  String _selectedLanguage = 'Türkçe';
  String _selectedDistance = 'Metre';

  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final storage = await LocalStorageService.getInstance();
    setState(() {
      _userProfile = storage.getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // App Bar - Arama yok
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: VarincaAppBar(title: 'Ayarlar'),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Card
                    _buildProfileCard(),

                    const SizedBox(height: 24),

                    // Personal Info Section
                    _buildSectionTitle('Kişisel Bilgiler'),
                    const SizedBox(height: 12),
                    _buildPersonalInfoCard(),

                    const SizedBox(height: 24),

                    // Notification Settings
                    _buildSectionTitle('Bildirimler'),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSwitchTile(
                        icon: Icons.notifications_rounded,
                        title: 'Bildirimler',
                        subtitle: 'Uygulama bildirimlerini aç/kapat',
                        value: _notificationsEnabled,
                        onChanged: (value) =>
                            setState(() => _notificationsEnabled = value),
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.volume_up_rounded,
                        title: 'Ses',
                        subtitle: 'Bildirim sesleri',
                        value: _soundEnabled,
                        onChanged: (value) =>
                            setState(() => _soundEnabled = value),
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.vibration_rounded,
                        title: 'Titreşim',
                        subtitle: 'Bildirim titreşimi',
                        value: _vibrationEnabled,
                        onChanged: (value) =>
                            setState(() => _vibrationEnabled = value),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Location Settings
                    _buildSectionTitle('Konum'),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSwitchTile(
                        icon: Icons.location_on_rounded,
                        title: 'Konum Takibi',
                        subtitle: 'Arka planda konum izleme',
                        value: _locationTrackingEnabled,
                        onChanged: (value) =>
                            setState(() => _locationTrackingEnabled = value),
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.battery_charging_full_rounded,
                        title: 'Pil Optimizasyonu',
                        subtitle: 'Akıllı güç yönetimi',
                        value: _batteryOptimizationEnabled,
                        onChanged: (value) =>
                            setState(() => _batteryOptimizationEnabled = value),
                      ),
                      _buildDivider(),
                      _buildDropdownTile(
                        icon: Icons.straighten_rounded,
                        title: 'Mesafe Birimi',
                        subtitle: 'Tercih edilen mesafe birimi',
                        value: _selectedDistance,
                        options: ['Metre', 'Kilometre', 'Mil'],
                        onChanged: (value) =>
                            setState(() => _selectedDistance = value!),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // App Settings
                    _buildSectionTitle('Uygulama'),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSwitchTile(
                        icon: Icons.dark_mode_rounded,
                        title: 'Karanlık Mod',
                        subtitle: 'Koyu tema kullan',
                        value: _darkModeEnabled,
                        onChanged: (value) =>
                            setState(() => _darkModeEnabled = value),
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.play_circle_rounded,
                        title: 'Otomatik Başlat',
                        subtitle: 'Cihaz açıldığında başlat',
                        value: _autoStartEnabled,
                        onChanged: (value) =>
                            setState(() => _autoStartEnabled = value),
                      ),
                      _buildDivider(),
                      _buildDropdownTile(
                        icon: Icons.language_rounded,
                        title: 'Dil',
                        subtitle: 'Uygulama dili',
                        value: _selectedLanguage,
                        options: ['Türkçe', 'English', 'Deutsch'],
                        onChanged: (value) =>
                            setState(() => _selectedLanguage = value!),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Support
                    _buildSectionTitle('Destek'),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildNavigationTile(
                        icon: Icons.help_rounded,
                        title: 'Yardım Merkezi',
                        subtitle: 'SSS ve rehberler',
                        onTap: () => _showHelpCenter(),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.feedback_rounded,
                        title: 'Geri Bildirim',
                        subtitle: 'Fikirlerinizi paylaşın',
                        onTap: () => _showFeedbackDialog(),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.star_rounded,
                        title: 'Uygulamayı Değerlendir',
                        subtitle: 'Mağazada değerlendirin',
                        onTap: () => _showRatingDialog(),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // About
                    _buildSectionTitle('Hakkında'),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildNavigationTile(
                        icon: Icons.info_rounded,
                        title: 'Uygulama Hakkında',
                        subtitle: 'Versiyon 1.0.0',
                        onTap: () => _showAboutDialog(),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.privacy_tip_rounded,
                        title: 'Gizlilik Politikası',
                        subtitle: 'Veri kullanımı hakkında',
                        onTap: () => _showPrivacyPolicy(),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.description_rounded,
                        title: 'Kullanım Koşulları',
                        subtitle: 'Hizmet şartları',
                        onTap: () => _showTermsOfService(),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Logout
                    _buildSettingsCard([
                      _buildDangerTile(
                        icon: Icons.logout_rounded,
                        title: 'Çıkış Yap',
                        subtitle: 'Hesabından çıkış yap',
                        onTap: () => _showLogoutConfirmation(),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Danger Zone
                    _buildSettingsCard([
                      _buildDangerTile(
                        icon: Icons.delete_forever_rounded,
                        title: 'Tüm Verileri Sil',
                        subtitle: 'Tüm verileriniz silinecek',
                        onTap: () {
                          _showDeleteConfirmation();
                        },
                      ),
                    ]),

                    const SizedBox(height: 32),

                    // Footer
                    Center(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/varincalogo.png',
                              width: 48,
                              height: 48,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Varınca',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Akıllı Konum Asistanın',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.greyText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'v1.0.0 © 2026',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.greyText.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final name = _userProfile?.name ?? 'Kullanıcı';
    final surname = _userProfile?.surname ?? '';
    final email = _userProfile?.email;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppDecorations.primaryShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.person_outline_rounded,
                color: AppColors.white,
                size: 36,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name ${surname.isNotEmpty ? surname : ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                if (email != null && email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showEditProfileSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Düzenle',
                style: TextStyle(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.person_rounded,
            title: 'Ad',
            value: _userProfile?.name ?? '-',
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.person_outline_rounded,
            title: 'Soyad',
            value: _userProfile?.surname ?? '-',
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.email_rounded,
            title: 'E-posta',
            value: _userProfile?.email ?? '-',
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.phone_rounded,
            title: 'Telefon',
            value: _userProfile?.phone ?? '-',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softPink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryRed, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14, color: AppColors.greyText),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: AppColors.border, indent: 56);
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softPink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryRed, size: 20),
          ),
          const SizedBox(width: 16),
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

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softPink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryRed, size: 20),
          ),
          const SizedBox(width: 16),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.softPink,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: value,
              items: options.map((option) {
                return DropdownMenuItem(value: option, child: Text(option));
              }).toList(),
              onChanged: onChanged,
              underline: const SizedBox(),
              isDense: true,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryRed,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryRed,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.softPink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryRed, size: 20),
              ),
              const SizedBox(width: 16),
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
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.greyText,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.error, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: AppColors.greyText),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.error,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileSheet() {
    final nameController = TextEditingController(
      text: _userProfile?.name ?? '',
    );
    final surnameController = TextEditingController(
      text: _userProfile?.surname ?? '',
    );
    final emailController = TextEditingController(
      text: _userProfile?.email ?? '',
    );
    final phoneController = TextEditingController(
      text: _userProfile?.phone ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Profili Düzenle',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 24),
                _buildEditField(nameController, 'Ad', Icons.person_rounded),
                const SizedBox(height: 16),
                _buildEditField(
                  surnameController,
                  'Soyad',
                  Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),
                _buildEditField(
                  emailController,
                  'E-posta',
                  Icons.email_rounded,
                ),
                const SizedBox(height: 16),
                _buildEditField(
                  phoneController,
                  'Telefon',
                  Icons.phone_rounded,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final storage = await LocalStorageService.getInstance();
                      final updatedProfile =
                          (_userProfile ?? UserProfile(name: '')).copyWith(
                            name: nameController.text.trim(),
                            surname: surnameController.text.trim(),
                            email: emailController.text.trim(),
                            phone: phoneController.text.trim(),
                          );
                      await storage.saveUserProfile(updatedProfile);
                      if (mounted) {
                        Navigator.pop(context);
                        _loadProfile();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profil güncellendi'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Kaydet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryRed),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Tüm Verileri Sil'),
          content: const Text(
            'Bu işlem geri alınamaz. Tüm alarmlar, konumlar, otomasyonlar ve hatırlatıcılar silinecek.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final storage = await LocalStorageService.getInstance();
                await storage.clearAllData();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tüm veriler silindi'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  _loadProfile();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text(
                'Sil',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showHelpCenter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Yardım Merkezi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildFaqItem(
                    'Nasıl alarm oluşturabilirim?',
                    'Özellikler sekmesinden Alarmlar\'a gidin ve sağ üstteki + butonuna tıklayın. Konum seçin, mesafe belirleyin ve kaydedin.',
                  ),
                  _buildFaqItem(
                    'Otomasyon nedir?',
                    'Otomasyonlar, belirli bir konuma yaklaştığınızda veya uzaklaştığınızda otomatik olarak tetiklenen eylemlerdir. Örneğin işe vardığınızda telefonunuz otomatik olarak sessiz moda geçebilir.',
                  ),
                  _buildFaqItem(
                    'Konum izleme pil tüketir mi?',
                    'Uygulama akıllı pil yönetimi kullanır. Arka planda minimum güç tüketimi ile çalışır.',
                  ),
                  _buildFaqItem(
                    'Hatırlatıcılar nasıl çalışır?',
                    'Hatırlatıcılar, belirli bir konuma yaklaştığınızda size bildirim gönderir. Market yakınında "alışveriş listesi" hatırlatması gibi.',
                  ),
                  _buildFaqItem(
                    'Verilerim güvende mi?',
                    'Tüm verileriniz cihazınızda yerel olarak saklanır. Sunucuya herhangi bir veri gönderilmez.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: AppColors.primaryRed,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.greyText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Geri Bildirim'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Fikirlerinizi bizimle paylaşın. Her türlü öneri ve şikayetinizi dinliyoruz.',
              style: TextStyle(fontSize: 14, color: AppColors.greyText),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Mesajınızı yazın...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Geri bildiriminiz için teşekkürler!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
            ),
            child: const Text(
              'Gönder',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    int selectedRating = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Uygulamayı Değerlendir'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Varınca\'yı nasıl buldunuz?',
                style: TextStyle(fontSize: 14, color: AppColors.greyText),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () =>
                        setDialogState(() => selectedRating = index + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < selectedRating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: index < selectedRating
                            ? Colors.amber
                            : AppColors.greyText,
                        size: 40,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: selectedRating > 0
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$selectedRating yıldız için teşekkürler!',
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
              ),
              child: const Text(
                'Değerlendir',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/varincalogo.png',
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Varınca',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Akıllı Konum Asistanın',
              style: TextStyle(fontSize: 14, color: AppColors.greyText),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.softPink,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Versiyon 1.0.0',
                style: TextStyle(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '© 2026 Varınca. Tüm hakları saklıdır.',
              style: TextStyle(fontSize: 12, color: AppColors.greyText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Gizlilik Politikası',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''Son güncelleme: 28 Ocak 2026

1. Veri Toplama
Varınca uygulaması, hizmetlerini sağlamak için aşağıdaki verileri toplar:
• Konum bilgileri (yalnızca uygulama kullanımdayken veya arka planda izin verildiğinde)
• Kullanıcı tarafından girilen kişisel bilgiler (ad, e-posta vb.)
• Uygulama kullanım verileri

2. Veri Kullanımı
Topladığımız veriler şu amaçlarla kullanılır:
• Konum tabanlı alarm ve hatırlatıcı servisleri
• Uygulama deneyiminin kişiselleştirilmesi
• Hata ayıklama ve performans iyileştirme

3. Veri Saklama
Tüm verileriniz cihazınızda yerel olarak saklanır. Sunucularımıza herhangi bir kişisel veri aktarılmaz.

4. Veri Güvenliği
Verilerinizin güvenliği bizim için önemlidir. Cihazınızdaki veriler şifrelenmiş olarak saklanır.

5. Üçüncü Taraflar
Verileriniz hiçbir üçüncü tarafla paylaşılmaz.

6. Haklarınız
• Verilerinize erişim hakkı
• Verilerinizin silinmesini talep etme hakkı
• Veri taşınabilirliği hakkı

7. İletişim
Sorularınız için: destek@varinca.app''',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumText,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsOfService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Kullanım Koşulları',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''Son güncelleme: 28 Ocak 2026

1. Kabul
Bu uygulamayı kullanarak aşağıdaki koşulları kabul etmiş olursunuz.

2. Hizmet Tanımı
Varınca, konum tabanlı alarm, otomasyon ve hatırlatıcı hizmetleri sunan bir mobil uygulamadır.

3. Kullanıcı Sorumlulukları
• Doğru ve güncel bilgi sağlamak
• Uygulamayı yasal amaçlarla kullanmak
• Cihaz izinlerini uygun şekilde yönetmek

4. Konum Servisleri
Uygulama, konum servislerine erişim gerektirir. Konum izni olmadan bazı özellikler çalışmayabilir.

5. Sorumluluk Reddi
Uygulama "olduğu gibi" sunulmaktadır. Kesintisiz veya hatasız çalışma garantisi verilmemektedir.

6. Fikri Mülkiyet
Uygulama ve içeriği telif hakkı ile korunmaktadır.

7. Değişiklikler
Bu koşullar önceden haber vermeksizin değiştirilebilir.

8. İletişim
Sorularınız için: destek@varinca.app''',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumText,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Çıkış Yap'),
        content: const Text(
          'Hesabınızdan çıkış yapmak istediğinize emin misiniz? Tüm verileriniz cihazda kalacaktır.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final storage = await LocalStorageService.getInstance();
              await storage.setFirstTimeNotDone();
              if (mounted) {
                Navigator.pop(context);
                // Uygulamayı yeniden başlat - onboarding'e git
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text(
              'Çıkış Yap',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
