/// Model representing a verified or curated project.
class Project {
  final String id;
  final String slug;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String category;
  final String projectType;
  final String companyName;
  final List<String> technologies;
  final String thumbnailUrl;
  final String imageUrl;
  final List<String> galleryUrls;
  final List<String> keyFeatures;
  final String personalContribution;
  final String challengesAndSolutions;
  final String verifiedOutcomes;
  final String playStoreUrl;
  final String appStoreUrl;
  final String githubUrl;
  final String demoUrl;
  final bool isFeatured;
  final bool isPublished;
  final bool isStatusActive;
  final int orderIndex;
  final DateTime? createdAt;

  const Project({
    required this.id,
    required this.slug,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.category,
    this.projectType = 'Client Project',
    this.companyName = '',
    this.technologies = const [],
    this.thumbnailUrl = '',
    this.imageUrl = '',
    this.galleryUrls = const [],
    this.keyFeatures = const [],
    this.personalContribution = '',
    this.challengesAndSolutions = '',
    this.verifiedOutcomes = '',
    this.playStoreUrl = '',
    this.appStoreUrl = '',
    this.githubUrl = '',
    this.demoUrl = '',
    this.isFeatured = false,
    this.isPublished = true,
    this.isStatusActive = true,
    this.orderIndex = 0,
    this.createdAt,
  });

  static const String defaultProjectImageUrl =
      'assets/images/project/default.webp';

  /// Canonical platform category guaranteed to be one of:
  /// 'Mobile App', 'Website', or 'Mobile & Web'.
  String get platformCategory {
    final lower = category.trim().toLowerCase();
    if (category == 'Website' || lower == 'flutter web') {
      return 'Website';
    }
    if (category == 'Mobile & Web' ||
        (lower.contains('web') && lower.contains('mobile'))) {
      return 'Mobile & Web';
    }
    return 'Mobile App';
  }

  /// Canonical project type guaranteed to be one of:
  /// 'Client Project', 'Professional Project', or 'Personal Project'.
  String get effectiveProjectType {
    if (projectType.trim().isNotEmpty) {
      final lower = projectType.toLowerCase();
      if (lower.contains('personal')) return 'Personal Project';
      if (lower.contains('professional')) return 'Professional Project';
      return 'Client Project';
    }
    if (companyName.trim().isEmpty) return 'Personal Project';
    return 'Client Project';
  }

  /// Flag indicating whether the project has a custom image provided.
  /// If false, the project defaults to [defaultProjectImageUrl].
  bool get hasCustomImage =>
      imageUrl.trim().isNotEmpty || thumbnailUrl.trim().isNotEmpty;

  /// Returns the effective image URL whether specified via imageUrl or thumbnailUrl,
  /// or falls back to [defaultProjectImageUrl] if no custom image is specified.
  String get displayImageUrl {
    if (imageUrl.trim().isNotEmpty) return imageUrl.trim();
    if (thumbnailUrl.trim().isNotEmpty) return thumbnailUrl.trim();
    return defaultProjectImageUrl;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'category': category,
      'projectType': projectType,
      'companyName': companyName,
      'technologies': technologies,
      'thumbnailUrl': thumbnailUrl,
      'imageUrl': imageUrl,
      'galleryUrls': galleryUrls,
      'keyFeatures': keyFeatures,
      'personalContribution': personalContribution,
      'challengesAndSolutions': challengesAndSolutions,
      'verifiedOutcomes': verifiedOutcomes,
      'playStoreUrl': playStoreUrl,
      'appStoreUrl': appStoreUrl,
      'githubUrl': githubUrl,
      'demoUrl': demoUrl,
      'isFeatured': isFeatured,
      'isPublished': isPublished,
      'is_status_active': isStatusActive,
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
      projectType:
          map['projectType'] ?? map['project_type'] ?? 'Client Project',
      companyName: map['companyName'] ?? '',
      technologies: List<String>.from(map['technologies'] ?? []),
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      galleryUrls: List<String>.from(map['galleryUrls'] ?? []),
      keyFeatures: List<String>.from(map['keyFeatures'] ?? []),
      personalContribution: map['personalContribution'] ?? '',
      challengesAndSolutions: map['challengesAndSolutions'] ?? '',
      verifiedOutcomes: map['verifiedOutcomes'] ?? '',
      playStoreUrl: map['playStoreUrl'] ?? '',
      appStoreUrl: map['appStoreUrl'] ?? (map['appleStoreUrl'] ?? ''),
      githubUrl: map['githubUrl'] ?? '',
      demoUrl: map['demoUrl'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
      isPublished: map['isPublished'] ?? true,
      isStatusActive:
          map['is_status_active'] ??
          map['isStatusActive'] ??
          map['isPublished'] ??
          true,
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
    String? projectType,
    String? companyName,
    List<String>? technologies,
    String? thumbnailUrl,
    String? imageUrl,
    List<String>? galleryUrls,
    List<String>? keyFeatures,
    String? personalContribution,
    String? challengesAndSolutions,
    String? verifiedOutcomes,
    String? playStoreUrl,
    String? appStoreUrl,
    String? githubUrl,
    String? demoUrl,
    bool? isFeatured,
    bool? isPublished,
    bool? isStatusActive,
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
      projectType: projectType ?? this.projectType,
      companyName: companyName ?? this.companyName,
      technologies: technologies ?? this.technologies,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      keyFeatures: keyFeatures ?? this.keyFeatures,
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
      isStatusActive: isStatusActive ?? this.isStatusActive,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
