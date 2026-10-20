/// Application-wide constants for Dhruvi Patel's portfolio.
class AppConstants {
  AppConstants._();

  // Personal Branding & Identity (Verified from Resumes)
  static const String developerName = 'Dhruvi Patel';
  static const String primaryRole = 'Sr. Flutter Developer';
  static const String secondaryRole = 'Sr. Software Engineer';
  static const String tertiaryRole = 'Mobile Application Developer';
  static const String fullRoleHeadline =
      'Sr. Software Engineer • Sr. Flutter Developer • Mobile Application Developer';
  static const String email = 'dhruvi39604@gmail.com';
  static const String phone = '+91 9925589405';
  static const String location = 'Surat, Gujarat, India';

  // Configurable Links
  static const String defaultGithubUrl = 'https://github.com/dhruvipatel';
  static const String defaultLinkedinUrl =
      'https://www.linkedin.com/in/dhruvi-patel-flutter';
  static const String defaultResumeUrl = 'assets/docs/resume.pdf';
  static const String repoName = 'my-portfolio';

  // Role Switcher items
  static const List<String> animatedRoles = [
    'Sr. Software Engineer',
    'Sr. Flutter Developer',
    'Mobile Application Developer',
    'Flutter Web Engineer',
    'Cross-Platform Architect',
  ];

  // Professional summary (Verified from latest resume)
  static const String summary =
      'Senior Software Engineer specializing in Flutter development, with 4+ years '
      'of experience building cross-platform mobile and web applications. Expertise in '
      'Flutter, Dart, GetX, REST APIs, Firebase, AWS IoT Core (MQTT), and scalable application '
      'architecture. Experienced in leading product development from scratch, implementing '
      'real-time booking systems, optimizing performance, securing API communication, and '
      'developing automated tests for production-ready applications.';

  // Firestore Collection Names
  static const String colProfile = 'profile';
  static const String colExperiences = 'experiences';
  static const String colProjects = 'projects';
  static const String colSkills = 'skills';
  static const String colEducation = 'education';
  static const String colAdmins = 'admins';
}
