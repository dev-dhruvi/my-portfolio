/// Model representing the developer's profile and contact metadata.
class Profile {
  final String id;
  final String name;
  final String headline;
  final String bio;
  final String email;
  final String phone;
  final String location;
  final String githubUrl;
  final String linkedinUrl;
  final String resumeUrl;
  final String avatarUrl;
  final String yearsOfExperience;
  final bool openToWork;
  final DateTime? updatedAt;

  const Profile({
    this.id = 'default',
    required this.name,
    required this.headline,
    required this.bio,
    required this.email,
    required this.phone,
    required this.location,
    this.githubUrl = '',
    this.linkedinUrl = '',
    this.resumeUrl = '',
    this.avatarUrl = '',
    this.yearsOfExperience = '4+',
    this.openToWork = true,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'headline': headline,
      'bio': bio,
      'email': email,
      'phone': phone,
      'location': location,
      'githubUrl': githubUrl,
      'linkedinUrl': linkedinUrl,
      'resumeUrl': resumeUrl,
      'avatarUrl': avatarUrl,
      'yearsOfExperience': yearsOfExperience,
      'openToWork': openToWork,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map, {String? id}) {
    return Profile(
      id: id ?? map['id'] ?? 'default',
      name: map['name'] ?? '',
      headline: map['headline'] ?? '',
      bio: map['bio'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      githubUrl: map['githubUrl'] ?? '',
      linkedinUrl: map['linkedinUrl'] ?? '',
      resumeUrl: map['resumeUrl'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      yearsOfExperience: map['yearsOfExperience'] ?? '4+',
      openToWork: map['openToWork'] ?? true,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
    );
  }

  Profile copyWith({
    String? id,
    String? name,
    String? headline,
    String? bio,
    String? email,
    String? phone,
    String? location,
    String? githubUrl,
    String? linkedinUrl,
    String? resumeUrl,
    String? avatarUrl,
    String? yearsOfExperience,
    bool? openToWork,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      headline: headline ?? this.headline,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      openToWork: openToWork ?? this.openToWork,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
