/// Model representing a technical skill or tool.
class Skill {
  final String id;
  final String name;
  final String category;
  final String iconName;
  final String description;
  final bool isHighlighted;
  final bool isPublished;
  final int orderIndex;

  const Skill({
    required this.id,
    required this.name,
    required this.category,
    this.iconName = '',
    this.description = '',
    this.isHighlighted = false,
    this.isPublished = true,
    this.orderIndex = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'iconName': iconName,
      'description': description,
      'isHighlighted': isHighlighted,
      'isPublished': isPublished,
      'orderIndex': orderIndex,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map, {String? id}) {
    return Skill(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'General',
      iconName: map['iconName'] ?? '',
      description: map['description'] ?? '',
      isHighlighted: map['isHighlighted'] ?? false,
      isPublished: map['isPublished'] ?? true,
      orderIndex: (map['orderIndex'] as num?)?.toInt() ?? 0,
    );
  }

  Skill copyWith({
    String? id,
    String? name,
    String? category,
    String? iconName,
    String? description,
    bool? isHighlighted,
    bool? isPublished,
    int? orderIndex,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
      description: description ?? this.description,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      isPublished: isPublished ?? this.isPublished,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
