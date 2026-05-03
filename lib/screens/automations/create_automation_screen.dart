import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/local_storage_service.dart';
import '../../widgets/widgets.dart';

/// Otomasyon Oluşturma Ekranı
class CreateAutomationScreen extends StatefulWidget {
  final AutomationData? automation;

  const CreateAutomationScreen({super.key, this.automation});

  @override
  State<CreateAutomationScreen> createState() => _CreateAutomationScreenState();
}

class _CreateAutomationScreenState extends State<CreateAutomationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  String? _selectedLocationId;
  String _selectedLocationName = '';
  int _selectedDistance = 100;
  AutomationTrigger _selectedTrigger = AutomationTrigger.entering;
  List<AutomationActionType> _selectedActions = [];

  bool _isLoading = false;

  final List<int> _distanceOptions = [50, 100, 200, 300, 500, 750, 1000];

  // Demo konumlar
  final List<LocationData> _locations = [
    LocationData(
      id: 'loc1',
      name: 'Ev',
      address: 'Kartal, İstanbul',
      latitude: 40.9,
      longitude: 29.2,
      category: 'home',
    ),
    LocationData(
      id: 'loc2',
      name: 'Ofis',
      address: 'Kadıköy, İstanbul',
      latitude: 40.98,
      longitude: 29.03,
      category: 'work',
    ),
    LocationData(
      id: 'loc3',
      name: 'Spor Salonu',
      address: 'Maltepe, İstanbul',
      latitude: 40.93,
      longitude: 29.13,
      category: 'sport',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.automation != null) {
      _titleController.text = widget.automation!.title;
      _selectedLocationId = widget.automation!.locationId;
      _selectedLocationName = widget.automation!.locationName;
      _selectedDistance = widget.automation!.distanceMeters;
      _selectedTrigger = widget.automation!.trigger;
      _selectedActions = widget.automation!.actions.map((a) => a.type).toList();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveAutomation() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocationId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen bir konum seçin')));
      return;
    }
    if (_selectedActions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir aksiyon seçin')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final storage = await LocalStorageService.getInstance();
      final automations = storage.getAutomations();

      final automation = AutomationData(
        id:
            widget.automation?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        locationId: _selectedLocationId!,
        locationName: _selectedLocationName,
        distanceMeters: _selectedDistance,
        trigger: _selectedTrigger,
        actions: _selectedActions
            .map((type) => AutomationAction(type: type))
            .toList(),
      );

      if (widget.automation != null) {
        final index = automations.indexWhere((a) => a.id == automation.id);
        if (index >= 0) {
          automations[index] = automation;
        }
      } else {
        automations.add(automation);
      }

      await storage.saveAutomations(automations);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.automation != null
                  ? 'Otomasyon güncellendi'
                  : 'Otomasyon oluşturuldu',
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
                  title: widget.automation != null
                      ? 'Otomasyon Düzenle'
                      : 'Yeni Otomasyon',
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
                      _buildSectionTitle('Otomasyon Adı'),
                      const SizedBox(height: 12),
                      _buildTitleField(),

                      const SizedBox(height: 28),

                      // Location Selection
                      _buildSectionTitle('Konum Seçin'),
                      const SizedBox(height: 12),
                      _buildLocationSelector(),

                      const SizedBox(height: 28),

                      // Trigger Selection
                      _buildSectionTitle('Tetikleyici'),
                      const SizedBox(height: 12),
                      _buildTriggerSelector(),

                      const SizedBox(height: 28),

                      // Distance Selection
                      _buildSectionTitle('Mesafe'),
                      const SizedBox(height: 12),
                      _buildDistanceSelector(),

                      const SizedBox(height: 28),

                      // Actions Selection
                      _buildSectionTitle('Aksiyonlar'),
                      const SizedBox(height: 4),
                      Text(
                        'Koşul sağlandığında yapılacak işlemler',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.greyText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildActionsSelector(),

                      const SizedBox(height: 32),

                      // Preview Card
                      if (_selectedLocationId != null &&
                          _selectedActions.isNotEmpty)
                        _buildPreviewCard(),

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
          return 'Lütfen bir ad girin';
        }
        return null;
      },
      style: const TextStyle(fontSize: 16, color: AppColors.darkText),
      decoration: InputDecoration(
        hintText: 'Örn: İşe Gelince Sessiz Mod',
        hintStyle: TextStyle(color: AppColors.greyText),
        prefixIcon: const Icon(Icons.edit_rounded, color: Color(0xFF9B59B6)),
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
          borderSide: const BorderSide(color: Color(0xFF9B59B6), width: 2),
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
                  index == 0
                      ? 16
                      : isLast
                      ? 16
                      : 0,
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
                              ? const Color(0xFF9B59B6).withValues(alpha: 0.1)
                              : AppColors.softPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(location.category),
                          color: isSelected
                              ? const Color(0xFF9B59B6)
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
                                ? const Color(0xFF9B59B6)
                                : AppColors.border,
                            width: 2,
                          ),
                          color: isSelected
                              ? const Color(0xFF9B59B6)
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
      case 'home':
        return Icons.home_rounded;
      case 'work':
        return Icons.business_rounded;
      case 'sport':
        return Icons.fitness_center_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  Widget _buildTriggerSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildTriggerOption(
            AutomationTrigger.entering,
            'Girerken',
            Icons.login_rounded,
            'Konuma yaklaştığında',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTriggerOption(
            AutomationTrigger.leaving,
            'Çıkarken',
            Icons.logout_rounded,
            'Konumdan uzaklaştığında',
          ),
        ),
      ],
    );
  }

  Widget _buildTriggerOption(
    AutomationTrigger trigger,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = _selectedTrigger == trigger;
    return GestureDetector(
      onTap: () => setState(() => _selectedTrigger = trigger),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF9B59B6).withValues(alpha: 0.1)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF9B59B6) : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF9B59B6) : AppColors.greyText,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF9B59B6)
                    : AppColors.darkText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: AppColors.greyText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
              color: isSelected ? const Color(0xFF9B59B6) : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF9B59B6) : AppColors.border,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF9B59B6).withValues(alpha: 0.3),
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

  Widget _buildActionsSelector() {
    final actionGroups = [
      (
        'Ses & Bildirim',
        [
          AutomationActionType.silentMode,
          AutomationActionType.vibrationMode,
          AutomationActionType.normalMode,
          AutomationActionType.dndOn,
          AutomationActionType.dndOff,
        ],
      ),
      (
        'Bağlantı',
        [
          AutomationActionType.wifiOn,
          AutomationActionType.wifiOff,
          AutomationActionType.bluetoothOn,
          AutomationActionType.bluetoothOff,
          AutomationActionType.airplaneOn,
          AutomationActionType.airplaneOff,
        ],
      ),
      (
        'Diğer',
        [
          AutomationActionType.notification,
          AutomationActionType.brightness,
          AutomationActionType.volume,
        ],
      ),
    ];

    return Column(
      children: actionGroups.map((group) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: AppDecorations.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  group.$1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: group.$2.map((action) {
                  return _buildActionChip(action);
                }).toList(),
              ).paddingAll(12),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionChip(AutomationActionType action) {
    final isSelected = _selectedActions.contains(action);
    final info = _getActionInfo(action);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedActions.remove(action);
          } else {
            _selectedActions.add(action);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF9B59B6).withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF9B59B6) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              info.$1,
              size: 18,
              color: isSelected ? const Color(0xFF9B59B6) : AppColors.greyText,
            ),
            const SizedBox(width: 6),
            Text(
              info.$2,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF9B59B6)
                    : AppColors.darkText,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: const Color(0xFF9B59B6),
              ),
            ],
          ],
        ),
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
        return (Icons.volume_off_rounded, 'Sessiz');
      case AutomationActionType.vibrationMode:
        return (Icons.vibration_rounded, 'Titreşim');
      case AutomationActionType.normalMode:
        return (Icons.volume_up_rounded, 'Normal');
      case AutomationActionType.airplaneOn:
        return (Icons.airplanemode_active_rounded, 'Uçak Modu');
      case AutomationActionType.airplaneOff:
        return (Icons.airplanemode_inactive_rounded, 'Uçak Modu Kapat');
      case AutomationActionType.dndOn:
        return (Icons.do_not_disturb_on_rounded, 'Rahatsız Etmeyin');
      case AutomationActionType.dndOff:
        return (Icons.do_not_disturb_off_rounded, 'DND Kapat');
      case AutomationActionType.brightness:
        return (Icons.brightness_6_rounded, 'Parlaklık');
      case AutomationActionType.volume:
        return (Icons.volume_down_rounded, 'Ses');
    }
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9B59B6).withValues(alpha: 0.1),
            const Color(0xFF8E44AD).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF9B59B6).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.preview_rounded,
                color: const Color(0xFF9B59B6),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Önizleme',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9B59B6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"$_selectedLocationName" konumuna ${_selectedTrigger == AutomationTrigger.entering ? 'girerken' : 'çıkarken'} ($_selectedDistance metre)',
            style: const TextStyle(fontSize: 15, color: AppColors.darkText),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedActions.map((action) {
              final info = _getActionInfo(action);
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(info.$1, size: 14, color: AppColors.white),
                    const SizedBox(width: 4),
                    Text(
                      info.$2,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
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
          onPressed: _isLoading ? null : _saveAutomation,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9B59B6),
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
                  widget.automation != null ? 'Güncelle' : 'Otomasyon Oluştur',
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

extension on Widget {
  Widget paddingAll(double value) {
    return Padding(padding: EdgeInsets.all(value), child: this);
  }
}
