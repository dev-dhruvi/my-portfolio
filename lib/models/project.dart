/// Model representing a verified or curated project.
class Project {
  final String id;
  final String slug;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String category;
  final List<String> technologies;
  final String thumbnailUrl;
  final List<String> galleryUrls;
  final String personalContribution;
  final String challengesAndSolutions;
  final String verifiedOutcomes;
  final String playStoreUrl;
  final String appStoreUrl;
  final String githubUrl;
  final String demoUrl;
  final bool isFeatured;
  final bool isPublished;
  final int orderIndex;
  final DateTime? createdAt;

  const Project({
    required this.id,
    required this.slug,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.category,
    this.technologies = const [],
    this.thumbnailUrl = '',
    this.galleryUrls = const [],
    this.personalContribution = '',
    this.challengesAndSolutions = '',
    this.verifiedOutcomes = '',
    this.playStoreUrl = '',
    this.appStoreUrl = '',
    this.githubUrl = '',
    this.demoUrl = '',
    this.isFeatured = false,
    this.isPublished = true,
    this.orderIndex = 0,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'category': category,
      'technologies': technologies,
      'thumbnailUrl': thumbnailUrl,
      'galleryUrls': galleryUrls,
      'personalContribution': personalContribution,
      'challengesAndSolutions': challengesAndSolutions,
      'verifiedOutcomes': verifiedOutcomes,
      'playStoreUrl': playStoreUrl,
      'appStoreUrl': appStoreUrl,
      'githubUrl': githubUrl,
      'demoUrl': demoUrl,
      'isFeatured': isFeatured,
      'isPublished': isPublished,
      'orderIndex': orderIndex,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map, {String? id}) {
    return Project(
      id: id ?? map['id'] ?? '',
      slug: map['slug'] ?? '',
      title: map['title'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      fullDescription: map['fullDescription'] ?? '',
      category: map['category'] ?? 'Mobile App',
      technologies: List<String>.from(map['technologies'] ?? []),
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      galleryUrls: List<String>.from(map['galleryUrls'] ?? []),
      personalContribution: map['personalContribution'] ?? '',
      challengesAndSolutions: map['challengesAndSolutions'] ?? '',
      verifiedOutcomes: map['verifiedOutcomes'] ?? '',
      playStoreUrl: map['playStoreUrl'] ?? '',
      appStoreUrl: map['appStoreUrl'] ?? '',
      githubUrl: map['githubUrl'] ?? '',
      demoUrl: map['demoUrl'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
      isPublished: map['isPublished'] ?? true,
      orderIndex: (map['orderIndex'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
    );
  }

  Project copyWith({
    String? id,
    String? slug,
    String? title,
    String? shortDescription,
    String? fullDescription,
    String? category,
    List<String>? technologies,
    String? thumbnailUrl,
    List<String>? galleryUrls,
    String? personalContribution,
    String? challengesAndSolutions,
    String? verifiedOutcomes,
    String? playStoreUrl,
    String? appStoreUrl,
    String? githubUrl,
    String? demoUrl,
    bool? isFeatured,
    bool? isPublished,
    int? orderIndex,
    DateTime? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      category: category ?? this.category,
      technologies: technologies ?? this.technologies,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      personalContribution: personalContribution ?? this.personalContribution,
      challengesAndSolutions:
          challengesAndSolutions ?? this.challengesAndSolutions,
      verifiedOutcomes: verifiedOutcomes ?? this.verifiedOutcomes,
      playStoreUrl: playStoreUrl ?? this.playStoreUrl,
      appStoreUrl: appStoreUrl ?? this.appStoreUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      demoUrl: demoUrl ?? this.demoUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      isPublished: isPublished ?? this.isPublished,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
