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
  static const String whatsappNumber = '919925589405';
  static const String whatsappDefaultText = 'Hi, I visited your portfolio';
  static const String whatsappUrl =
      'https://wa.me/919925589405?text=Hi%2C%20I%20visited%20your%20portfolio';
  static const String location = 'Surat, Gujarat, India';
  static const String developBy = 'Crafted with 👩‍💻 by Dhruvi Patel © 2026';

  // Configurable Links
  static const String defaultGithubUrl = 'https://github.com/dev-dhruvi';
  static const String defaultLinkedinUrl =
      'https://www.linkedin.com/in/duvi03/';
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
      'Senior Flutter Developer from Surat with 4+ years of experience building Android, iOS and web apps '
      'across 20+ client and company projects, including a marketplace app built from scratch with a 90%+ '
      'crash-free session rate. I care about clean, modular code and well-tested features, and I enjoy '
      'turning Figma designs into smooth UI and debugging performance issues. I prefer explaining things to '
      'junior developers, and I like working closely with designers and backend teams to build apps people actually use.';

  // Primary Hero Section Headlines & Value Proposition
  static const String heroHeadlinePrefix = 'Building Scalable ';
  static const String heroHeadlineHighlight = 'Mobile Experiences';
  static const String heroHeadlineSuffix = ' with Flutter';
  static const String heroFullHeadline =
      'Building Scalable Mobile Experiences with Flutter';
  static const String heroSupportingText =
      "I turn complex requirements into reliable, user-friendly Flutter applications. From clean architecture and custom UI to API integrations, automated testing, and performance optimization, I focus on building maintainable apps that are ready to scale.";

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
