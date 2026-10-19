/// Model representing verified educational degrees.
class Education {
  final String id;
  final String degree;
  final String institution;
  final String affiliation;
  final String location;
  final String startDate;
  final String endDate;
  final String cgpa;
  final String honors;
  final String description;
  final bool isPublished;
  final int orderIndex;

  const Education({
    required this.id,
    required this.degree,
    required this.institution,
    this.affiliation = '',
    required this.location,
    required this.startDate,
    required this.endDate,
    this.cgpa = '',
    this.honors = '',
    this.description = '',
    this.isPublished = true,
    this.orderIndex = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'degree': degree,
      'institution': institution,
      'affiliation': affiliation,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'cgpa': cgpa,
      'honors': honors,
      'description': description,
      'isPublished': isPublished,
      'orderIndex': orderIndex,
    };
  }

  factory Education.fromMap(Map<String, dynamic> map, {String? id}) {
    return Education(
      id: id ?? map['id'] ?? '',
      degree: map['degree'] ?? '',
      institution: map['institution'] ?? '',
      affiliation: map['affiliation'] ?? '',
      location: map['location'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      cgpa: map['cgpa'] ?? '',
      honors: map['honors'] ?? '',
      description: map['description'] ?? '',
      isPublished: map['isPublished'] ?? true,
      orderIndex: (map['orderIndex'] as num?)?.toInt() ?? 0,
    );
  }

  Education copyWith({
    String? id,
    String? degree,
    String? institution,
    String? affiliation,
    String? location,
    String? startDate,
    String? endDate,
    String? cgpa,
    String? honors,
    String? description,
    bool? isPublished,
    int? orderIndex,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      affiliation: affiliation ?? this.affiliation,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cgpa: cgpa ?? this.cgpa,
      honors: honors ?? this.honors,
      description: description ?? this.description,
      isPublished: isPublished ?? this.isPublished,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
