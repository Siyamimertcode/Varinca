import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AutoMessageScreen extends StatefulWidget {
  const AutoMessageScreen({super.key});

  @override
  State<AutoMessageScreen> createState() => _AutoMessageScreenState();
}

class _AutoMessageScreenState extends State<AutoMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? _selectedTrigger;
  final List<String> _presets = [
    'Eve geldim.',
    'Yola çıktım, geliyorum.',
    'Toplantıdayım, sonra döneceğim.',
    'Marketteyim, bir şey lazım mı?',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Otomatik Mesaj'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Kime Gönderilecek?'),
            const SizedBox(height: 12),
            _buildContactInput(),
            const SizedBox(height: 24),
            _buildSectionTitle('Mesaj İçeriği'),
            const SizedBox(height: 12),
            _buildMessageInput(),
            const SizedBox(height: 16),
            _buildPresets(),
            const SizedBox(height: 24),
            _buildSectionTitle('Tetikleyici'),
            const SizedBox(height: 12),
            _buildTriggerSelector(),
            const SizedBox(height: 40),
            _buildSaveButton(),
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
        fontWeight: FontWeight.w700,
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildContactInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _contactController,
        decoration: InputDecoration(
          hintText: 'Kişi seç veya numara gir',
          prefixIcon: const Icon(
            Icons.person_search_rounded,
            color: AppColors.greyText,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.contacts_rounded,
              color: AppColors.primaryRed,
            ),
            onPressed: () {
              // TODO: Open contact picker
            },
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _messageController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Mesajınızı yazın...',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildPresets() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _presets.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(_presets[index]),
            backgroundColor: AppColors.lightPink,
            side: BorderSide.none,
            labelStyle: const TextStyle(
              color: AppColors.primaryRed,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            onPressed: () {
              _messageController.text = _presets[index];
            },
          );
        },
      ),
    );
  }

  Widget _buildTriggerSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildTriggerOption(
            title: 'Konuma Varınca',
            subtitle: 'Seçilen konuma girildiğinde',
            icon: Icons.location_on_outlined,
            isSelected: _selectedTrigger == 'arrive',
            onTap: () => setState(() => _selectedTrigger = 'arrive'),
          ),
          const Divider(height: 1, indent: 56),
          _buildTriggerOption(
            title: 'Konumdan Ayrılınca',
            subtitle: 'Seçilen konumdan çıkıldığında',
            icon: Icons.exit_to_app_rounded,
            isSelected: _selectedTrigger == 'leave',
            onTap: () => setState(() => _selectedTrigger = 'leave'),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryRed.withValues(alpha: 0.1)
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryRed : AppColors.greyText,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primaryRed
                          : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: AppColors.greyText),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryRed,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          shadowColor: AppColors.primaryRed.withValues(alpha: 0.4),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          // TODO: Save automation
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Otomatik mesaj oluşturuldu!')),
          );
        },
        child: const Text(
          'Oluştur',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
