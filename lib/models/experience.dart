import '../core/utils/experience_calculator.dart';

/// Professional work experience model.
class Experience {
  final String id;
  final String role;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final List<String> responsibilities;
  final List<String> technologies;
  final int orderIndex;
  final bool isPublished;
  final DateTime? createdAt;

  const Experience({
    required this.id,
    required this.role,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.isCurrent = false,
    this.responsibilities = const [],
    this.technologies = const [],
    this.orderIndex = 0,
    this.isPublished = true,
    this.createdAt,
  });

  /// Computed single duration (e.g. "11 mos", "2 yrs").
  String get calculatedDuration =>
      ExperienceCalculator.calculateSingleDuration(startDate, endDate);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'company': company,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrent': isCurrent,
      'responsibilities': responsibilities,
      'technologies': technologies,
      'orderIndex': orderIndex,
      'isPublished': isPublished,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map, {String? id}) {
    return Experience(
      id: id ?? map['id'] ?? '',
      role: map['role'] ?? '',
      company: map['company'] ?? '',
      location: map['location'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      isCurrent: map['isCurrent'] ?? false,
      responsibilities: List<String>.from(map['responsibilities'] ?? []),
      technologies: List<String>.from(map['technologies'] ?? []),
      orderIndex: (map['orderIndex'] as num?)?.toInt() ?? 0,
      isPublished: map['isPublished'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
    );
  }

  Experience copyWith({
    String? id,
    String? role,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    bool? isCurrent,
    List<String>? responsibilities,
    List<String>? technologies,
    int? orderIndex,
    bool? isPublished,
    DateTime? createdAt,
  }) {
    return Experience(
      id: id ?? this.id,
      role: role ?? this.role,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      responsibilities: responsibilities ?? this.responsibilities,
      technologies: technologies ?? this.technologies,
      orderIndex: orderIndex ?? this.orderIndex,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
