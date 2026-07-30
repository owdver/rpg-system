/// Item rarity levels.
enum ItemRarity {
  common,
  rare,
  epic,
  legendary,
  mythic,
}

extension ItemRarityExtension on ItemRarity {
  String get label {
    switch (this) {
      case ItemRarity.common:
        return 'Common';
      case ItemRarity.rare:
        return 'Rare';
      case ItemRarity.epic:
        return 'Epic';
      case ItemRarity.legendary:
        return 'Legendary';
      case ItemRarity.mythic:
        return 'Mythic';
    }
  }

  int get colorValue {
    switch (this) {
      case ItemRarity.common:
        return 0xFF9CA3AF; // Gray
      case ItemRarity.rare:
        return 0xFF3B82F6; // Blue
      case ItemRarity.epic:
        return 0xFF8B5CF6; // Purple
      case ItemRarity.legendary:
        return 0xFFF59E0B; // Amber/Gold
      case ItemRarity.mythic:
        return 0xFFEC4899; // Pink
    }
  }

  int get sparkles {
    switch (this) {
      case ItemRarity.common:
        return 0;
      case ItemRarity.rare:
        return 5;
      case ItemRarity.epic:
        return 15;
      case ItemRarity.legendary:
        return 30;
      case ItemRarity.mythic:
        return 50;
    }
  }
}

/// Inventory item types.
enum InventoryItemType {
  title,
  badge,
  theme,
  background,
  windowEffect,
  particleEffect,
  border,
  icon,
}

extension InventoryItemTypeExtension on InventoryItemType {
  String get label {
    switch (this) {
      case InventoryItemType.title:
        return 'Title';
      case InventoryItemType.badge:
        return 'Badge';
      case InventoryItemType.theme:
        return 'Theme';
      case InventoryItemType.background:
        return 'Background';
      case InventoryItemType.windowEffect:
        return 'Window Effect';
      case InventoryItemType.particleEffect:
        return 'Particle Effect';
      case InventoryItemType.border:
        return 'Border';
      case InventoryItemType.icon:
        return 'Icon';
    }
  }
}

/// An inventory item.
class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    this.icon,
    this.previewAsset,
    this.isEquipped = false,
    this.isUnlocked = false,
    this.unlockedAt,
    this.effectValue = 0,
  });

  final String id;
  final String name;
  final String description;
  final InventoryItemType type;
  final ItemRarity rarity;
  final String? icon;
  final String? previewAsset;
  final bool isEquipped;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double effectValue;

  InventoryItem copyWith({
    String? id,
    String? name,
    String? description,
    InventoryItemType? type,
    ItemRarity? rarity,
    String? icon,
    String? previewAsset,
    bool? isEquipped,
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? effectValue,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      icon: icon ?? this.icon,
      previewAsset: previewAsset ?? this.previewAsset,
      isEquipped: isEquipped ?? this.isEquipped,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      effectValue: effectValue ?? this.effectValue,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type.index,
        'rarity': rarity.index,
        'icon': icon,
        'previewAsset': previewAsset,
        'isEquipped': isEquipped,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
        'effectValue': effectValue,
      };

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: InventoryItemType.values[json['type'] as int],
      rarity: ItemRarity.values[json['rarity'] as int],
      icon: json['icon'] as String?,
      previewAsset: json['previewAsset'] as String?,
      isEquipped: json['isEquipped'] as bool? ?? false,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      effectValue: (json['effectValue'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Predefined inventory items.
class InventoryCatalog {
  static List<InventoryItem> get allItems => [
        ...titles,
        ...badges,
        ...backgrounds,
        ...windowEffects,
        ...borders,
      ];

  static const titles = [
    InventoryItem(
      id: 'title_novice',
      name: 'Novice',
      description: 'Beginner operative.',
      type: InventoryItemType.title,
      rarity: ItemRarity.common,
      icon: '🌱',
      isUnlocked: true,
    ),
    InventoryItem(
      id: 'title_trainee',
      name: 'Trainee',
      description: 'Committed to growth.',
      type: InventoryItemType.title,
      rarity: ItemRarity.common,
      icon: '📚',
    ),
    InventoryItem(
      id: 'title_warrior',
      name: 'Warrior',
      description: 'Proven in battle.',
      type: InventoryItemType.title,
      rarity: ItemRarity.rare,
      icon: '⚔️',
    ),
    InventoryItem(
      id: 'title_champion',
      name: 'Champion',
      description: 'Consistently excels.',
      type: InventoryItemType.title,
      rarity: ItemRarity.epic,
      icon: '🏆',
    ),
    InventoryItem(
      id: 'title_legend',
      name: 'Legend',
      description: 'Achieved legendary status.',
      type: InventoryItemType.title,
      rarity: ItemRarity.legendary,
      icon: '⭐',
    ),
    InventoryItem(
      id: 'title_transcendent',
      name: 'Transcendent',
      description: 'Beyond mortal limits.',
      type: InventoryItemType.title,
      rarity: ItemRarity.mythic,
      icon: '👑',
    ),
  ];

  static const badges = [
    InventoryItem(
      id: 'badge_first_workout',
      name: 'First Step',
      description: 'Completed first workout.',
      type: InventoryItemType.badge,
      rarity: ItemRarity.common,
      icon: '👟',
    ),
    InventoryItem(
      id: 'badge_streak_7',
      name: 'Week Warrior',
      description: '7-day streak achieved.',
      type: InventoryItemType.badge,
      rarity: ItemRarity.rare,
      icon: '🔥',
    ),
    InventoryItem(
      id: 'badge_streak_30',
      name: 'Monthly Master',
      description: '30-day streak achieved.',
      type: InventoryItemType.badge,
      rarity: ItemRarity.epic,
      icon: '💫',
    ),
    InventoryItem(
      id: 'badge_level_50',
      name: 'Elite Operative',
      description: 'Reached level 50.',
      type: InventoryItemType.badge,
      rarity: ItemRarity.legendary,
      icon: '🌟',
    ),
    InventoryItem(
      id: 'badge_perfectionist',
      name: 'Perfectionist',
      description: 'Achieved 100% workout accuracy.',
      type: InventoryItemType.badge,
      rarity: ItemRarity.mythic,
      icon: '💎',
    ),
  ];

  static const backgrounds = [
    InventoryItem(
      id: 'bg_default',
      name: 'Default',
      description: 'Standard holographic background.',
      type: InventoryItemType.background,
      rarity: ItemRarity.common,
      icon: '🎨',
      isUnlocked: true,
    ),
    InventoryItem(
      id: 'bg_cyber',
      name: 'Cyber Grid',
      description: 'Futuristic grid pattern.',
      type: InventoryItemType.background,
      rarity: ItemRarity.rare,
      icon: '🟩',
    ),
    InventoryItem(
      id: 'bg_storm',
      name: 'Storm',
      description: 'Dynamic storm effect.',
      type: InventoryItemType.background,
      rarity: ItemRarity.epic,
      icon: '⛈️',
    ),
    InventoryItem(
      id: 'bg_nebula',
      name: 'Nebula',
      description: 'Cosmic nebula clouds.',
      type: InventoryItemType.background,
      rarity: ItemRarity.legendary,
      icon: '🌌',
    ),
    InventoryItem(
      id: 'bg_transcendent',
      name: 'Transcendence',
      description: 'Ultimate visual experience.',
      type: InventoryItemType.background,
      rarity: ItemRarity.mythic,
      icon: '✨',
    ),
  ];

  static const windowEffects = [
    InventoryItem(
      id: 'effect_basic',
      name: 'Basic Glow',
      description: 'Simple glow effect.',
      type: InventoryItemType.windowEffect,
      rarity: ItemRarity.common,
      icon: '💡',
      isUnlocked: true,
    ),
    InventoryItem(
      id: 'effect_holo',
      name: 'Holographic',
      description: 'Full holographic effect.',
      type: InventoryItemType.windowEffect,
      rarity: ItemRarity.rare,
      icon: '🔮',
    ),
    InventoryItem(
      id: 'effect_energy',
      name: 'Energy Field',
      description: 'Pulsing energy effect.',
      type: InventoryItemType.windowEffect,
      rarity: ItemRarity.epic,
      icon: '⚡',
    ),
    InventoryItem(
      id: 'effect_plasma',
      name: 'Plasma Core',
      description: 'Living plasma effect.',
      type: InventoryItemType.windowEffect,
      rarity: ItemRarity.legendary,
      icon: '🔥',
    ),
  ];

  static const borders = [
    InventoryItem(
      id: 'border_standard',
      name: 'Standard',
      description: 'Default border style.',
      type: InventoryItemType.border,
      rarity: ItemRarity.common,
      icon: '▢',
      isUnlocked: true,
    ),
    InventoryItem(
      id: 'border_tech',
      name: 'Tech Frame',
      description: 'Technological frame.',
      type: InventoryItemType.border,
      rarity: ItemRarity.rare,
      icon: '⌘',
    ),
    InventoryItem(
      id: 'border_ornate',
      name: 'Ornate',
      description: 'Decorative border.',
      type: InventoryItemType.border,
      rarity: ItemRarity.epic,
      icon: '✧',
    ),
    InventoryItem(
      id: 'border_cosmic',
      name: 'Cosmic',
      description: 'Celestial border.',
      type: InventoryItemType.border,
      rarity: ItemRarity.legendary,
      icon: '☆',
    ),
  ];
}

/// Inventory state.
class InventoryState {
  const InventoryState({
    this.items = const [],
    this.equippedItems = const {},
    this.totalItems = 0,
    this.unlockedItems = 0,
  });

  final List<InventoryItem> items;
  final Map<InventoryItemType, String?> equippedItems;
  final int totalItems;
  final int unlockedItems;

  factory InventoryState.initial() {
    final items = InventoryCatalog.allItems;
    return InventoryState(
      items: items,
      equippedItems: {
        for (final type in InventoryItemType.values) type: null,
      },
      totalItems: items.length,
      unlockedItems: items.where((i) => i.isUnlocked).length,
    );
  }

  List<InventoryItem> getItemsByType(InventoryItemType type) {
    return items.where((i) => i.type == type).toList();
  }

  List<InventoryItem> getUnlockedItems() {
    return items.where((i) => i.isUnlocked).toList();
  }

  List<InventoryItem> getEquippedItems() {
    return items.where((i) => i.isEquipped).toList();
  }

  InventoryItem? getItem(String id) {
    return items.where((i) => i.id == id).firstOrNull;
  }

  InventoryItem? getEquippedItem(InventoryItemType type) {
    final id = equippedItems[type];
    return id != null ? getItem(id) : null;
  }

  InventoryState copyWith({
    List<InventoryItem>? items,
    Map<InventoryItemType, String?>? equippedItems,
    int? totalItems,
    int? unlockedItems,
  }) {
    return InventoryState(
      items: items ?? this.items,
      equippedItems: equippedItems ?? this.equippedItems,
      totalItems: totalItems ?? this.totalItems,
      unlockedItems: unlockedItems ?? this.unlockedItems,
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((i) => i.toJson()).toList(),
        'equippedItems':
            equippedItems.map((k, v) => MapEntry(k.index.toString(), v)),
        'totalItems': totalItems,
        'unlockedItems': unlockedItems,
      };

  factory InventoryState.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>?)
        ?.map((i) => InventoryItem.fromJson(i as Map<String, dynamic>))
        .toList();

    final equippedMap = (json['equippedItems'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(
                InventoryItemType.values[int.parse(k)], v as String?)) ??
        {};

    return InventoryState(
      items: itemsList ?? InventoryCatalog.allItems,
      equippedItems: equippedMap,
      totalItems: json['totalItems'] as int? ?? 0,
      unlockedItems: json['unlockedItems'] as int? ?? 0,
    );
  }
}
