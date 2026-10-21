/// Application-wide constants for Dhruvi Patel's portfolio.
class AppConstants {
  AppConstants._();

  // Personal Branding & Identity (Verified from Resumes)
  static const String developerName = 'Dhruvi Patel';
  static const String primaryRole = 'Senior Flutter Developer';
  static const String fullRoleHeadline =
      'Senior Software Engineer | Senior Flutter Developer | Mobile Application Developer';
  static const String email = 'dhruvi39604@gmail.com';
  static const String phone = '+91 9925589405';
  static const String location = 'Surat, Gujarat, India';
  static const String developBy = 'Crafted with ♥ by Dhruvi Patel © 2026';

  // Configurable Links
  static const String defaultGithubUrl = 'https://github.com/dhruvi-mobiledev';
  static const String defaultLinkedinUrl = 'https://www.linkedin.com/in/duvi03';
  static const String defaultResumeUrl = 'assets/docs/resume.pdf';
  static const String repoName = 'my-portfolio';

  // Role Switcher items
  static const List<String> animatedRoles = [
    'Sr. Software Engineer',
    'Sr. Flutter Developer',
    'Mobile Application Developer',
  ];

  // Professional summary (Verified from latest resume)
  static const String summary =
      'Senior Software Engineer specializing in Flutter development, with 4+ years '
      'of experience building cross-platform mobile and web applications. Expertise in '
      'Flutter, Dart, GetX, REST APIs, Firebase, AWS IoT Core (MQTT), and scalable application '
      'architecture. Experienced in leading product development from scratch, implementing '
      'real-time booking systems, optimizing performance, securing API communication, and '
      'developing automated tests for production-ready applications.';

  // Short & punchy hero summary matching modern reference design
  static const String shortSummary =
      '4+ years shipping production Flutter apps for iOS, Android & Web, '
      'specializing in clean architecture, real-time cloud integrations, '
      'and high-performance mobile experiences.';

  // Firestore Collection Names
  static const String colProfile = 'profile';
  static const String colExperiences = 'experiences';
  static const String colProjects = 'projects';
  static const String colSkills = 'skills';
  static const String colEducation = 'education';
  static const String colAdmins = 'admins';
}
