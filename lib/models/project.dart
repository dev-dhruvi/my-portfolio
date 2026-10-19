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
  final List<String> keyFeatures;
  final String playStoreUrl;
  final String appStoreUrl;
  final String githubUrl;
  final String demoUrl;
  final bool isFeatured;
  final bool isPublished;
  final int orderIndex;
  final DateTime? createdAt;

  const Project({
    this.id = '',
    this.slug = '',
    required this.title,
    String? shortDescription,
    String? fullDescription,
    String? description,
    this.category = 'Mobile App',
    this.technologies = const [],
    String? thumbnailUrl,
    String? imageUrl,
    this.galleryUrls = const [],
    this.personalContribution = '',
    this.challengesAndSolutions = '',
    this.verifiedOutcomes = '',
    this.keyFeatures = const [],
    String? playStoreUrl,
    String? liveUrl,
    String? appStoreUrl,
    String? appleStoreUrl,
    this.githubUrl = '',
    this.demoUrl = '',
    this.isFeatured = false,
    this.isPublished = true,
    this.orderIndex = 0,
    this.createdAt,
  })  : shortDescription = shortDescription ?? description ?? '',
        fullDescription = fullDescription ?? description ?? '',
        thumbnailUrl = thumbnailUrl ?? imageUrl ?? '',
        playStoreUrl = playStoreUrl ?? liveUrl ?? '',
        appStoreUrl = appStoreUrl ?? appleStoreUrl ?? '';

  String get description =>
      shortDescription.isNotEmpty ? shortDescription : fullDescription;
  String get imageUrl => thumbnailUrl;
  String get liveUrl => playStoreUrl.isNotEmpty ? playStoreUrl : demoUrl;
  String get appleStoreUrl => appStoreUrl;

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
      'imageUrl': thumbnailUrl,
      'galleryUrls': galleryUrls,
      'personalContribution': personalContribution,
      'challengesAndSolutions': challengesAndSolutions,
      'verifiedOutcomes': verifiedOutcomes,
      'keyFeatures': keyFeatures,
      'playStoreUrl': playStoreUrl,
      'appStoreUrl': appStoreUrl,
      'liveUrl': playStoreUrl.isNotEmpty ? playStoreUrl : demoUrl,
      'appleStoreUrl': appStoreUrl,
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
      shortDescription: map['shortDescription'] ?? map['description'] ?? '',
      fullDescription: map['fullDescription'] ?? map['description'] ?? '',
      category: map['category'] ?? 'Mobile App',
      technologies: List<String>.from(map['technologies'] ?? []),
      thumbnailUrl: map['thumbnailUrl'] ?? map['imageUrl'] ?? '',
      galleryUrls: List<String>.from(map['galleryUrls'] ?? []),
      personalContribution: map['personalContribution'] ?? '',
      challengesAndSolutions: map['challengesAndSolutions'] ?? '',
      verifiedOutcomes: map['verifiedOutcomes'] ?? '',
      keyFeatures: List<String>.from(map['keyFeatures'] ?? []),
      playStoreUrl: map['playStoreUrl'] ?? map['liveUrl'] ?? '',
      appStoreUrl: map['appStoreUrl'] ?? map['appleStoreUrl'] ?? '',
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
    String? description,
    String? category,
    List<String>? technologies,
    String? thumbnailUrl,
    String? imageUrl,
    List<String>? galleryUrls,
    String? personalContribution,
    String? challengesAndSolutions,
    String? verifiedOutcomes,
    List<String>? keyFeatures,
    String? playStoreUrl,
    String? liveUrl,
    String? appStoreUrl,
    String? appleStoreUrl,
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
      shortDescription:
          shortDescription ?? description ?? this.shortDescription,
      fullDescription: fullDescription ?? description ?? this.fullDescription,
      category: category ?? this.category,
      technologies: technologies ?? this.technologies,
      thumbnailUrl: thumbnailUrl ?? imageUrl ?? this.thumbnailUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      personalContribution:
          personalContribution ?? this.personalContribution,
      challengesAndSolutions:
          challengesAndSolutions ?? this.challengesAndSolutions,
      verifiedOutcomes: verifiedOutcomes ?? this.verifiedOutcomes,
      keyFeatures: keyFeatures ?? this.keyFeatures,
      playStoreUrl: playStoreUrl ?? liveUrl ?? this.playStoreUrl,
      appStoreUrl: appStoreUrl ?? appleStoreUrl ?? this.appStoreUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      demoUrl: demoUrl ?? this.demoUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      isPublished: isPublished ?? this.isPublished,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
