import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Local Storage Service - Kullanıcı verilerini yerel olarak saklar
class LocalStorageService {
  static const String _userKey = 'user_profile';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _alarmsKey = 'alarms';
  static const String _locationsKey = 'locations';
  static const String _automationsKey = 'automations';
  static const String _remindersKey = 'reminders';

  static LocalStorageService? _instance;
  static SharedPreferences? _prefs;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // ==================== User Profile ====================

  Future<void> saveUserProfile(UserProfile profile) async {
    await _prefs?.setString(_userKey, jsonEncode(profile.toJson()));
  }

  UserProfile? getUserProfile() {
    final data = _prefs?.getString(_userKey);
    if (data != null) {
      return UserProfile.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> clearUserProfile() async {
    await _prefs?.remove(_userKey);
  }

  // ==================== First Time Check ====================

  bool isFirstTime() {
    return _prefs?.getBool(_isFirstTimeKey) ?? true;
  }

  Future<void> setFirstTimeDone() async {
    await _prefs?.setBool(_isFirstTimeKey, false);
  }

  // ==================== Alarms ====================

  Future<void> saveAlarms(List<AlarmData> alarms) async {
    final data = alarms.map((a) => a.toJson()).toList();
    await _prefs?.setString(_alarmsKey, jsonEncode(data));
  }

  List<AlarmData> getAlarms() {
    final data = _prefs?.getString(_alarmsKey);
    if (data != null) {
      final list = jsonDecode(data) as List;
      return list.map((e) => AlarmData.fromJson(e)).toList();
    }
    return [];
  }

  // ==================== Locations ====================

  Future<void> saveLocations(List<LocationData> locations) async {
    final data = locations.map((l) => l.toJson()).toList();
    await _prefs?.setString(_locationsKey, jsonEncode(data));
  }

  List<LocationData> getLocations() {
    final data = _prefs?.getString(_locationsKey);
    if (data != null) {
      final list = jsonDecode(data) as List;
      return list.map((e) => LocationData.fromJson(e)).toList();
    }
    return [];
  }

  // ==================== Automations ====================

  Future<void> saveAutomations(List<AutomationData> automations) async {
    final data = automations.map((a) => a.toJson()).toList();
    await _prefs?.setString(_automationsKey, jsonEncode(data));
  }

  List<AutomationData> getAutomations() {
    final data = _prefs?.getString(_automationsKey);
    if (data != null) {
      final list = jsonDecode(data) as List;
      return list.map((e) => AutomationData.fromJson(e)).toList();
    }
    return [];
  }

  // ==================== Reminders ====================

  Future<void> saveReminders(List<ReminderData> reminders) async {
    final data = reminders.map((r) => r.toJson()).toList();
    await _prefs?.setString(_remindersKey, jsonEncode(data));
  }

  List<ReminderData> getReminders() {
    final data = _prefs?.getString(_remindersKey);
    if (data != null) {
      final list = jsonDecode(data) as List;
      return list.map((e) => ReminderData.fromJson(e)).toList();
    }
    return [];
  }

  // ==================== Clear All Data ====================

  Future<void> clearAllData() async {
    await _prefs?.remove(_alarmsKey);
    await _prefs?.remove(_locationsKey);
    await _prefs?.remove(_automationsKey);
    await _prefs?.remove(_remindersKey);
  }

  // ==================== Reset First Time (for logout) ====================

  Future<void> setFirstTimeNotDone() async {
    await _prefs?.setBool(_isFirstTimeKey, true);
    await clearUserProfile();
    await clearAllData();
  }
}

// ==================== Data Models ====================

class UserProfile {
  final String name;
  final String? surname;
  final DateTime? birthDate;
  final String? email;
  final String? phone;
  final String? avatarEmoji;
  final DateTime createdAt;

  UserProfile({
    required this.name,
    this.surname,
    this.birthDate,
    this.email,
    this.phone,
    this.avatarEmoji,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'name': name,
    'surname': surname,
    'birthDate': birthDate?.toIso8601String(),
    'email': email,
    'phone': phone,
    'avatarEmoji': avatarEmoji,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'],
    surname: json['surname'],
    birthDate: json['birthDate'] != null
        ? DateTime.parse(json['birthDate'])
        : null,
    email: json['email'],
    phone: json['phone'],
    avatarEmoji: json['avatarEmoji'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  UserProfile copyWith({
    String? name,
    String? surname,
    DateTime? birthDate,
    String? email,
    String? phone,
    String? avatarEmoji,
  }) {
    return UserProfile(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      createdAt: createdAt,
    );
  }
}

class AlarmData {
  final String id;
  final String title;
  final String locationId;
  final String locationName;
  final int distanceMeters;
  final bool isActive;
  final String? note;
  final List<int> repeatDays; // 1=Pzt, 7=Paz
  final DateTime createdAt;

  AlarmData({
    required this.id,
    required this.title,
    required this.locationId,
    required this.locationName,
    required this.distanceMeters,
    this.isActive = true,
    this.note,
    this.repeatDays = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'locationId': locationId,
    'locationName': locationName,
    'distanceMeters': distanceMeters,
    'isActive': isActive,
    'note': note,
    'repeatDays': repeatDays,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AlarmData.fromJson(Map<String, dynamic> json) => AlarmData(
    id: json['id'],
    title: json['title'],
    locationId: json['locationId'],
    locationName: json['locationName'],
    distanceMeters: json['distanceMeters'],
    isActive: json['isActive'] ?? true,
    note: json['note'],
    repeatDays: List<int>.from(json['repeatDays'] ?? []),
    createdAt: DateTime.parse(json['createdAt']),
  );

  AlarmData copyWith({
    String? title,
    String? locationId,
    String? locationName,
    int? distanceMeters,
    bool? isActive,
    String? note,
    List<int>? repeatDays,
  }) {
    return AlarmData(
      id: id,
      title: title ?? this.title,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      isActive: isActive ?? this.isActive,
      note: note ?? this.note,
      repeatDays: repeatDays ?? this.repeatDays,
      createdAt: createdAt,
    );
  }
}

class LocationData {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String category;
  final bool isFavorite;
  final DateTime createdAt;

  LocationData({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'category': category,
    'isFavorite': isFavorite,
    'createdAt': createdAt.toIso8601String(),
  };

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    id: json['id'],
    name: json['name'],
    address: json['address'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    category: json['category'],
    isFavorite: json['isFavorite'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
  );

  LocationData copyWith({
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    bool? isFavorite,
  }) {
    return LocationData(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
    );
  }
}

class AutomationData {
  final String id;
  final String title;
  final String locationId;
  final String locationName;
  final int distanceMeters;
  final AutomationTrigger trigger; // entering, leaving
  final List<AutomationAction> actions;
  final bool isActive;
  final DateTime createdAt;

  AutomationData({
    required this.id,
    required this.title,
    required this.locationId,
    required this.locationName,
    required this.distanceMeters,
    required this.trigger,
    required this.actions,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'locationId': locationId,
    'locationName': locationName,
    'distanceMeters': distanceMeters,
    'trigger': trigger.name,
    'actions': actions.map((a) => a.toJson()).toList(),
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AutomationData.fromJson(Map<String, dynamic> json) => AutomationData(
    id: json['id'],
    title: json['title'],
    locationId: json['locationId'],
    locationName: json['locationName'],
    distanceMeters: json['distanceMeters'],
    trigger: AutomationTrigger.values.firstWhere(
      (e) => e.name == json['trigger'],
      orElse: () => AutomationTrigger.entering,
    ),
    actions: (json['actions'] as List)
        .map((a) => AutomationAction.fromJson(a))
        .toList(),
    isActive: json['isActive'] ?? true,
    createdAt: DateTime.parse(json['createdAt']),
  );

  AutomationData copyWith({
    String? title,
    String? locationId,
    String? locationName,
    int? distanceMeters,
    AutomationTrigger? trigger,
    List<AutomationAction>? actions,
    bool? isActive,
  }) {
    return AutomationData(
      id: id,
      title: title ?? this.title,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      trigger: trigger ?? this.trigger,
      actions: actions ?? this.actions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}

enum AutomationTrigger {
  entering, // Konuma girerken
  leaving, // Konumdan çıkarken
}

class AutomationAction {
  final AutomationActionType type;
  final Map<String, dynamic> params;

  AutomationAction({required this.type, this.params = const {}});

  Map<String, dynamic> toJson() => {'type': type.name, 'params': params};

  factory AutomationAction.fromJson(Map<String, dynamic> json) =>
      AutomationAction(
        type: AutomationActionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => AutomationActionType.notification,
        ),
        params: Map<String, dynamic>.from(json['params'] ?? {}),
      );
}

enum AutomationActionType {
  notification, // Bildirim gönder
  wifiOff, // WiFi kapat
  wifiOn, // WiFi aç
  bluetoothOff, // Bluetooth kapat
  bluetoothOn, // Bluetooth aç
  silentMode, // Sessiz mod
  vibrationMode, // Titreşim modu
  normalMode, // Normal mod
  airplaneOn, // Uçak modu aç
  airplaneOff, // Uçak modu kapat
  dndOn, // Rahatsız etmeyin aç
  dndOff, // Rahatsız etmeyin kapat
  brightness, // Parlaklık ayarla
  volume, // Ses seviyesi ayarla
}

class ReminderData {
  final String id;
  final String title;
  final String? note;
  final String locationId;
  final String locationName;
  final int distanceMeters;
  final bool isActive;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime createdAt;

  ReminderData({
    required this.id,
    required this.title,
    this.note,
    required this.locationId,
    required this.locationName,
    required this.distanceMeters,
    this.isActive = true,
    this.isCompleted = false,
    this.dueDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'locationId': locationId,
    'locationName': locationName,
    'distanceMeters': distanceMeters,
    'isActive': isActive,
    'isCompleted': isCompleted,
    'dueDate': dueDate?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory ReminderData.fromJson(Map<String, dynamic> json) => ReminderData(
    id: json['id'],
    title: json['title'],
    note: json['note'],
    locationId: json['locationId'],
    locationName: json['locationName'],
    distanceMeters: json['distanceMeters'],
    isActive: json['isActive'] ?? true,
    isCompleted: json['isCompleted'] ?? false,
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    createdAt: DateTime.parse(json['createdAt']),
  );

  ReminderData copyWith({
    String? title,
    String? note,
    String? locationId,
    String? locationName,
    int? distanceMeters,
    bool? isActive,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return ReminderData(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
    );
  }
}
