import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/local_storage_service.dart';
import '../../widgets/widgets.dart';

/// Hatırlatıcı Oluşturma Ekranı
class CreateReminderScreen extends StatefulWidget {
  final ReminderData? reminder;

  const CreateReminderScreen({super.key, this.reminder});

  @override
  State<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  String? _selectedLocationId;
  String _selectedLocationName = '';
  int _selectedDistance = 200;
  DateTime? _dueDate;
  bool _isLoading = false;

  final List<int> _distanceOptions = [50, 100, 200, 300, 500, 750, 1000];

  // Demo konumlar
  final List<LocationData> _locations = [
    LocationData(
      id: 'loc1',
      name: 'Migros',
      address: 'Bostancı, İstanbul',
      latitude: 40.96,
      longitude: 29.1,
      category: 'shopping',
    ),
    LocationData(
      id: 'loc2',
      name: 'PTT',
      address: 'Kadıköy, İstanbul',
      latitude: 40.98,
      longitude: 29.03,
      category: 'other',
    ),
    LocationData(
      id: 'loc3',
      name: 'Banka',
      address: 'Maltepe, İstanbul',
      latitude: 40.93,
      longitude: 29.13,
      category: 'other',
    ),
    LocationData(
      id: 'loc4',
      name: 'Oto Yıkama',
      address: 'Kartal, İstanbul',
      latitude: 40.9,
      longitude: 29.2,
      category: 'other',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      _titleController.text = widget.reminder!.title;
      _noteController.text = widget.reminder!.note ?? '';
      _selectedLocationId = widget.reminder!.locationId;
      _selectedLocationName = widget.reminder!.locationName;
      _selectedDistance = widget.reminder!.distanceMeters;
      _dueDate = widget.reminder!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocationId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen bir konum seçin')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final storage = await LocalStorageService.getInstance();
      final reminders = storage.getReminders();

      final reminder = ReminderData(
        id:
            widget.reminder?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        locationId: _selectedLocationId!,
        locationName: _selectedLocationName,
        distanceMeters: _selectedDistance,
        dueDate: _dueDate,
      );

      if (widget.reminder != null) {
        final index = reminders.indexWhere((r) => r.id == reminder.id);
        if (index >= 0) {
          reminders[index] = reminder;
        }
      } else {
        reminders.add(reminder);
      }

      await storage.saveReminders(reminders);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.reminder != null
                  ? 'Hatırlatıcı güncellendi'
                  : 'Hatırlatıcı oluşturuldu',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF39C12),
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.darkText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 8),

              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: VarincaAppBar(
                  title: widget.reminder != null
                      ? 'Hatırlatıcı Düzenle'
                      : 'Yeni Hatırlatıcı',
                  showBackButton: true,
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Field
                      _buildSectionTitle('Ne hatırlatayım?'),
                      const SizedBox(height: 12),
                      _buildTitleField(),

                      const SizedBox(height: 20),

                      // Note Field
                      _buildSectionTitle('Not (isteğe bağlı)'),
                      const SizedBox(height: 12),
                      _buildNoteField(),

                      const SizedBox(height: 28),

                      // Location Selection
                      _buildSectionTitle('Hangi konumda?'),
                      const SizedBox(height: 12),
                      _buildLocationSelector(),

                      const SizedBox(height: 28),

                      // Distance Selection
                      _buildSectionTitle('Kaç metre kala hatırlat?'),
                      const SizedBox(height: 12),
                      _buildDistanceSelector(),

                      const SizedBox(height: 28),

                      // Due Date
                      _buildSectionTitle('Son tarih (isteğe bağlı)'),
                      const SizedBox(height: 12),
                      _buildDueDateField(),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
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

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Lütfen bir görev girin';
        }
        return null;
      },
      style: const TextStyle(fontSize: 16, color: AppColors.darkText),
      decoration: InputDecoration(
        hintText: 'Örn: Market alışverişi yap',
        hintStyle: TextStyle(color: AppColors.greyText),
        prefixIcon: const Icon(
          Icons.task_alt_rounded,
          color: Color(0xFFF39C12),
        ),
        filled: true,
        fillColor: AppColors.white,
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
          borderSide: const BorderSide(color: Color(0xFFF39C12), width: 2),
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteController,
      maxLines: 3,
      style: const TextStyle(fontSize: 16, color: AppColors.darkText),
      decoration: InputDecoration(
        hintText: 'Detay ekleyin...',
        hintStyle: TextStyle(color: AppColors.greyText),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 44),
          child: const Icon(Icons.notes_rounded, color: Color(0xFFF39C12)),
        ),
        filled: true,
        fillColor: AppColors.white,
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
          borderSide: const BorderSide(color: Color(0xFFF39C12), width: 2),
        ),
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Column(
        children: _locations.asMap().entries.map((entry) {
          final index = entry.key;
          final location = entry.value;
          final isSelected = _selectedLocationId == location.id;
          final isLast = index == _locations.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedLocationId = location.id;
                    _selectedLocationName = location.name;
                  });
                },
                borderRadius: BorderRadius.circular(
                  index == 0 || isLast ? 16 : 0,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF39C12).withValues(alpha: 0.1)
                              : AppColors.softPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(location.category),
                          color: isSelected
                              ? const Color(0xFFF39C12)
                              : AppColors.primaryRed,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            ),
                            Text(
                              location.address,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.greyText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFF39C12)
                                : AppColors.border,
                            width: 2,
                          ),
                          color: isSelected
                              ? const Color(0xFFF39C12)
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: AppColors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast) const Divider(height: 1, indent: 74),
            ],
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'shopping':
        return Icons.shopping_cart_rounded;
      case 'work':
        return Icons.business_rounded;
      case 'home':
        return Icons.home_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  Widget _buildDistanceSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _distanceOptions.map((distance) {
        final isSelected = _selectedDistance == distance;
        final label = distance >= 1000
            ? '${distance ~/ 1000}km'
            : '${distance}m';
        return GestureDetector(
          onTap: () => setState(() => _selectedDistance = distance),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF39C12) : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFFF39C12) : AppColors.border,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFF39C12).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.darkText,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDueDateField() {
    return GestureDetector(
      onTap: _selectDueDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: Color(0xFFF39C12)),
            const SizedBox(width: 12),
            Text(
              _dueDate != null ? _formatDate(_dueDate!) : 'Son tarih seçin',
              style: TextStyle(
                fontSize: 16,
                color: _dueDate != null
                    ? AppColors.darkText
                    : AppColors.greyText,
              ),
            ),
            const Spacer(),
            if (_dueDate != null)
              GestureDetector(
                onTap: () => setState(() => _dueDate = null),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.greyText,
                  size: 20,
                ),
              )
            else
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildBottomBar() {
    return Container(
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
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveReminder,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF39C12),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  widget.reminder != null ? 'Güncelle' : 'Hatırlatıcı Oluştur',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
