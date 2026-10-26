import '../../models/education.dart';
import '../../models/experience.dart';
import '../../models/profile.dart';
import '../../models/project.dart';
import '../../models/skill.dart';
import 'app_constants.dart';

/// Authoritative seed data extracted strictly from Dhruvi Patel's resumes.
/// Used for initial database seeding and resilient offline/fallback operation.
class SeedData {
  SeedData._();

  static Profile get initialProfile => const Profile(
    id: 'default_profile',
    name: AppConstants.developerName,
    headline: AppConstants.fullRoleHeadline,
    bio: AppConstants.summary,
    email: AppConstants.email,
    phone: AppConstants.phone,
    location: AppConstants.location,
    githubUrl: AppConstants.defaultGithubUrl,
    linkedinUrl: AppConstants.defaultLinkedinUrl,
    resumeUrl: AppConstants.defaultResumeUrl,
    yearsOfExperience: '4+',
    openToWork: true,
  );

  static List<Experience> get initialExperiences => [
    const Experience(
      id: 'exp_1_logix',
      company: 'Logix Built Solutions Limited',
      role: 'Sr. Software Engineer – Flutter Developer',
      location: 'Surat, Gujarat, India',
      startDate: 'May 2025',
      endDate: 'Present',
      isCurrent: true, // Preserving historical / explicit mode
      locationType: 'On-Site', // Preserving historical / explicit mode
      award: 'Code Craft Excellence Award (2025)',
      orderIndex: 0,
      isPublished: true,
      responsibilities: [
        'Honored with the Code Craft Excellence Award (2025) for exceptional code craftsmanship, modular architecture, and technical quality.',
        'Lead cross-platform application development using Flutter, Dart, GetX, and modular architecture.',
        'Implement real-time notifications using AWS IoT Core (MQTT) and Firebase Cloud Messaging (FCM).',
        'Develop booking workflows, role-based features, location services, and OTP-based verification.',
        'Implement secure JWT authentication, API retry mechanisms, and background processing.',
        'Integrate Firebase Analytics, Crashlytics, Remote Config, and Performance Monitoring.',
        'Build a Flutter web-based validation tool using Dart and Python with 20 validation rules.',
        'Develop automated unit, widget, and integration tests to improve application quality.',
        'Manage responsive UI development, dependency upgrades, and Android/iOS configuration migrations.',
      ],
    ),
    const Experience(
      id: 'exp_2_dinjan',
      company: 'Dinjan Infotech',
      role: 'Flutter Developer',
      location: 'Surat, Gujarat, India',
      startDate: 'June 2024',
      endDate: 'April 2025',
      isCurrent: false,
      locationType: 'Remote',
      orderIndex: 1,
      isPublished: true,
      responsibilities: [
        'Designed and implemented user-friendly visually appealing UIs using Flutter and FlutterFlow, including custom widgets for enhanced functionality.',
        'Built and deployed cross-platform applications for Android and iOS, ensuring optimal performance.',
        'Provided ongoing maintenance for existing apps, addressing any issues promptly to ensure continued, optimal performance.',
        'Mentored junior developers, fostering a collaborative and supportive work environment that accelerated skill.',
      ],
    ),
    const Experience(
      id: 'exp_3_white_orange_dev',
      company: 'White Orange Software',
      role: 'Mobile App Developer',
      location: 'Surat, Gujarat, India',
      startDate: 'June 2022',
      endDate: 'May 2024',
      isCurrent: false,
      locationType: 'On-Site',
      orderIndex: 2,
      isPublished: true,
      responsibilities: [
        'Served as a Flutter Developer, creating high-performance mobile applications for both Android and iOS platforms.',
        'Designed user-friendly software interfaces to simplify overall management.',
        'Analyzed solutions and coding fixes for software problems.',
        'Modified existing software systems to enhance performance and add new features.',
        'Collaborated closely with cross-functional teams to keep projects on track and meet anticipated deadlines.',
      ],
    ),
    const Experience(
      id: 'exp_4_white_orange_intern',
      company: 'White Orange Software',
      role: 'Intern, Android Developer',
      location: 'Surat, Gujarat, India',
      locationType: 'On-Site',
      startDate: 'January 2022',
      endDate: 'May 2022',
      isCurrent: false,
      orderIndex: 3,
      isPublished: true,
      responsibilities: [
        'Developed mobile application for Android which helps HR of any industry to manage salary and employee, implemented Chat between HR and Employees.',
        'Used the Android Studio tool to create the application and managed the database using Firebase and third-party SDKs.',
        'Conducted mobile testing, performance profiling, and bug resolution.',
      ],
    ),
  ];

  static List<Education> get initialEducation => [
    const Education(
      id: 'edu_1_mca',
      degree: 'Master of Computer Applications (MCA)',
      institution: 'Sarvajanik College of Engineering & Technology',
      affiliation: 'Gujarat Technological University (G.T.U.)',
      location: 'Surat, India',
      startDate: 'Dec 2020',
      endDate: 'May 2022',
      cgpa: '7.61',
      honors: 'Distinction with CGPA – 7.61',
      description: 'Advanced study in computer applications, system architecture, database design, software engineering, and mobile computing.',
      orderIndex: 0,
      isPublished: true,
    ),
    const Education(
      id: 'edu_2_bca',
      degree: 'Bachelor of Computer Applications (BCA)',
      institution: 'Vivekanand College for Advance Computer & Info. Science',
      affiliation: 'Veer Narmad South Gujarat University (V.N.S.G.U.)',
      location: 'Surat, India',
      startDate: 'Jun 2017',
      endDate: 'Mar 2020',
      cgpa: '7.39',
      honors: 'Distinction with CGPA – 7.39',
      description: 'Core computer science curriculum including object-oriented programming, data structures, algorithms, web technologies, and database management.',
      orderIndex: 1,
      isPublished: true,
    ),
  ];

  static List<Skill> get initialSkills => [
    // Mobile & Frameworks
    const Skill(
      id: 'sk_flutter',
      name: 'Flutter (Mobile & Web)',
      category: 'Mobile & Frameworks',
      iconName: 'flutter',
      description:
          'Build responsive cross-platform apps for Android, iOS, and Web.',
      isHighlighted: true,
      orderIndex: 0,
    ),
    const Skill(
      id: 'sk_dart',
      name: 'Dart',
      category: 'Mobile & Frameworks',
      iconName: 'code',
      description:
          'Write type-safe, maintainable code with asynchronous programming.',
      isHighlighted: true,
      orderIndex: 1,
    ),
    const Skill(
      id: 'sk_getx',
      name: 'GetX State Management',
      category: 'Mobile & Frameworks',
      iconName: 'layers',
      description:
          'Manage reactive state, navigation, and dependency injection.',
      isHighlighted: true,
      orderIndex: 2,
    ),
    const Skill(
      id: 'sk_flutterflow',
      name: 'FlutterFlow',
      category: 'Mobile & Frameworks',
      iconName: 'palette',
      description:
          'Build app interfaces with custom widgets and API integrations.',
      isHighlighted: false,
      orderIndex: 3,
    ),
    const Skill(
      id: 'sk_android',
      name: 'Android Studio & Android SDK',
      category: 'Mobile & Frameworks',
      iconName: 'android',
      description:
          'Configure Android builds, Gradle, and platform-specific features.',
      isHighlighted: false,
      orderIndex: 4,
    ),
    const Skill(
      id: 'sk_ios',
      name: 'iOS App Deployment',
      category: 'Mobile & Frameworks',
      iconName: 'apple',
      description: 'Configure iOS builds, signing, provisioning, and App Store releases.',
      isHighlighted: false,
      orderIndex: 5,
    ),

    // Cloud & Backend
    const Skill(
      id: 'sk_firebase_auth',
      name: 'Firebase Authentication & Firestore',
      category: 'Cloud & Backend',
      iconName: 'fire',
      description: 'Implement authentication and cloud-based data storage.',
      isHighlighted: true,
      orderIndex: 6,
    ),
    const Skill(
      id: 'sk_fcm',
      name: 'Firebase Cloud Messaging (FCM)',
      category: 'Cloud & Backend',
      iconName: 'bell',
      description:
          'Integrate push notifications and background message handling.',
      isHighlighted: false,
      orderIndex: 7,
    ),
    const Skill(
      id: 'sk_aws_iot',
      name: 'AWS IoT Core & MQTT',
      category: 'Cloud & Backend',
      iconName: 'cloud',
      description: 'Enable real-time, bidirectional messaging through MQTT.',
      isHighlighted: true,
      orderIndex: 8,
    ),
    const Skill(
      id: 'sk_rest_jwt',
      name: 'Dio, REST APIs & JWT',
      category: 'Cloud & Backend',
      iconName: 'key',
      description: 'Integrate APIs with authentication, interceptors, and error handling.',
      isHighlighted: true,
      orderIndex: 9,
    ),
    const Skill(
      id: 'sk_crashlytics',
      name: 'Firebase Crashlytics & Analytics',
      category: 'Cloud & Backend',
      iconName: 'chart',
      description:
          'Monitor application crashes, diagnose issues, and track events.',
      isHighlighted: false,
      orderIndex: 10,
    ),
    const Skill(
      id: 'sk_python_automation',
      name: 'Python & Dataset Automation',
      category: 'Cloud & Backend',
      iconName: 'terminal',
      description:
          'Automate dataset validation, data processing, and error correction.',
      isHighlighted: false,
      orderIndex: 11,
    ),

    // Architecture & Quality
    const Skill(
      id: 'sk_clean_arch',
      name: 'Clean & Modular Architecture',
      category: 'Architecture & Quality',
      iconName: 'shield',
      description:
          'Structure applications with clear separation of responsibilities.',
      isHighlighted: true,
      orderIndex: 12,
    ),
    const Skill(
      id: 'sk_testing',
      name: 'Automated Testing',
      category: 'Architecture & Quality',
      iconName: 'check_circle',
      description: 'Write unit, widget, and integration tests using Flutter testing tools.',
      isHighlighted: false,
      orderIndex: 13,
    ),
    const Skill(
      id: 'sk_perf_opt',
      name: 'Performance Optimization',
      category: 'Architecture & Quality',
      iconName: 'bolt',
      description: 'Profile rendering, investigate memory issues, and improve app performance.',
      isHighlighted: false,
      orderIndex: 14,
    ),
    const Skill(
      id: 'sk_git',
      name: 'Git & Version Control',
      category: 'Architecture & Quality',
      iconName: 'branch',
      description: 'Manage branches, collaborate through pull requests, and review code.',
      isHighlighted: false,
      orderIndex: 15,
    ),
    const Skill(
      id: 'sk_integrations',
      name: 'Third-Party Integrations & Local Storage',
      category: 'Architecture & Quality',
      iconName: 'plug',
      description: 'Integrate DocuSign and Google Places, and manage local data with Hive.',
      isHighlighted: false,
      orderIndex: 16,
    ),
    const Skill(
      id: 'sk_hive',
      name: 'Hive DB & Local Storage',
      category: 'Architecture & Quality',
      iconName: 'database',
      description:
          'Manage offline key-value NoSQL storage and local state with Hive.',
      isHighlighted: false,
      orderIndex: 17,
    ),
  ];

  static List<Project> get initialProjects => [
    const Project(
      id: 'proj_pandits_near_me',
      slug: 'pandit-near-me',
      title: 'Pandits Near Me - Instant Puja',
      shortDescription: 'Dual-sided spiritual services marketplace with real-time AWS IoT MQTT dispatch, Kundali CustomPainter, and multilingual puja booking.',
      fullDescription:
          'A production-grade dual-sided on-demand marketplace application designed and developed from scratch using Flutter and clean modular architecture, supporting 50+ successful releases across Android and iOS. '
          'Built cross-platform features for users, Pandits, and Astrologers including phone OTP verification, role-based navigation, and end-to-end puja booking with dynamic pricing and wallet discounts. '
          'Engineered real-time booking dispatch with AWS IoT Core and MQTT over Secure WebSockets with connection lifecycle reconnection logic, paired with FCM notifications with custom audio/vibration behavior. '
          'Features complete Pandit onboarding and KYC (Aadhaar uploads, certificate verification), dynamic Kundali and Kundali Matching with CustomPainter horoscope charts and PDF downloads, '
          'location-aware services with Google Places, Panchang/Muhurat/Choghadiya astrology services, multilingual support (English, Hindi, Gujarati), zero-downtime updates, and resilient Dio single-flight concurrency.',
      category: 'On-Demand Marketplace',
      companyName: 'Logix Built Solutions Limited',
      technologies: [
        'Flutter',
        'Dart',
        'GetX',
        'Dio',
        'AWS IoT Core (MQTT)',
        'Firebase (FCM, Crashlytics, Analytics, Remote Config, Performance)',
        'Google Places API',
        'CustomPainter',
        'PostHog',
        'Cloudflare Turnstile',
        'Hive',
        'Flutter Secure Storage',
        'Mocktail',
        'Git',
      ],
      personalContribution:
          'Role: Senior Software Engineer | Flutter Developer (May 2025 – Present)\n'
          '• Built cross-platform application features for users, Pandits, and Astrologers, covering onboarding, authentication, profiles, service discovery, puja booking, and booking management.\n'
          '• Implemented authentication and account management with phone OTP verification, email verification, password recovery, profile updates, account recovery, and role-based navigation.\n'
          '• Developed end-to-end puja booking workflows, including dynamic service selection, language preferences, date and time validation, address management, pricing, wallet discounts, and booking submission.\n'
          '• Integrated real-time booking communication using AWS IoT Core and MQTT, including signed WebSocket URL setup, topic subscriptions, connection lifecycle handling, reconnection logic, and booking event processing.\n'
          '• Implemented push notification workflows using Firebase Cloud Messaging, custom notification interfaces, and Android/iOS notification configuration; worked on sound and vibration behavior across app states.\n'
          '• Developed Pandit onboarding and KYC functionality, including Aadhaar image uploads, certificates, reference details, service categories, experience information, service locations, and verification status.\n'
          '• Built Kundali and Kundali Matching features, including dynamic planetary data, custom horoscope charts using CustomPainter, Dasha details, Gun Milan results, saved records, deletion, and PDF download integration.\n'
          '• Integrated location-aware and astrology-related services, including Google location suggestions, address autocomplete, Panchang, Muhurat, Choghadiya, horoscope, festivals, Sankalp, Adhyatm, Dharma Shiksha, and blogs.\n'
          '• Implemented multilingual interfaces for English, Hindi, and Gujarati across relevant booking, onboarding, dashboard, and astrology screens.\n'
          '• Improved application reliability and release readiness through reusable form validation, API error handling, pagination, Firebase Analytics events, performance traces, environment separation, Git conflict resolution, and Android/iOS build preparation.',
      challengesAndSolutions:
          'Challenge: Coordinating real-time dispatch over unstable mobile networks without battery drain, rendering complex Vedic astrology charts smoothly, and preventing token refresh race conditions.\n'
          'Solution: Architected MQTT over Secure WebSockets with connection lifecycle reconnection on AWS IoT Core, built CustomPainter geometric algorithms for horoscope chart rendering, and implemented a thread-safe Single-Flight Lock Completer in Dio.',
      verifiedOutcomes: '50+ production releases on Android & iOS, real-time MQTT dispatch, custom astrology chart engine, multilingual support (English/Hindi/Gujarati), and comprehensive KYC verification.',
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.officialpanditsnearme',
      appStoreUrl: 'https://apps.apple.com/in/app/pandits-near-me-instant-puja/id6757301105',
      imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/WpXkFFjJYxueZPCTAq4hUA/648x365bb.webp',
      isFeatured: true,
      isPublished: true,
      orderIndex: 0,
    ),
    const Project(
      id: 'proj_adroit_wealth_mgmt',
      slug: 'adroit-vantage-wealth-management',
      title: 'Wealth Management 2.0',
      shortDescription: 'Stock trading and portfolio enhancement app with push alerts, calendar events, and real-time chat.',
      fullDescription: 'Stock trading and investment management app. Enhanced core app stability by fixing legacy chat bugs, implementing market event calendar reminders, and integrating Firebase push notifications for instant stock volatility alerts.',
      category: 'Mobile App',
      companyName: 'White Orange Software',
      technologies: [
        'Flutter',
        'REST APIs',
        'Push Notifications',
        'Firebase',
        'Play Store',
        'App Store',
      ],
      personalContribution: 'Resolved chat messaging synchronization issues, connected calendar reminder events, and deployed release builds to store consoles.',
      challengesAndSolutions: 'Challenge: Real-time stock alerts not triggering while app was closed. Solution: Replaced polling with FCM high-priority data payloads.',
      verifiedOutcomes: 'Deployed to Google Play & Apple App Store.',
      appStoreUrl:
          'https://apps.apple.com/us/app/wealth-management-2-0/id1672260039',
      imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/b0/d1/44/b0d144e8-fedc-befd-0868-f5bd0a5e2aaf/AppIcon-1x_U007emarketing-0-7-0-85-220.png/1200x630wa.jpg',
      isFeatured: false,
      isPublished: true,
      orderIndex: 13,
    ),
    const Project(
      id: 'proj_muvr-user',
      slug: 'muvr-user-app',
      title: 'Muvr User App',
      shortDescription:
          'On-demand moving and logistics platform with dedicated User App.',
      fullDescription: 'An on-demand logistics booking application connecting customers with professional moving service providers. Developed both the User App and Mover App using Flutter and GetX. Managed responsive layouts across all device sizes, mentored junior engineers on state management best practices, and maintained production stability.',
      category: 'Mobile App',
      companyName: 'White Orange Software',
      technologies: [
        'Flutter',
        'GetX',
        'Google Maps',
        'Role-Based Flow',
        'Play Store',
        'App Store',
      ],
      personalContribution: 'Engineered booking request workflows, mentored junior team members on clean code conventions, resolved layout issues, and prepared dual store deployments.',
      challengesAndSolutions: 'Challenge: Dual application role synchronization between customer booking and mover acceptance. Solution: Implemented atomic status state transitions in GetX controllers.',
      verifiedOutcomes: 'Four published store apps: Muvr User App (Play Store & App Store) and Muvr Mover App (Play Store & App Store).',
      appStoreUrl:
          'https://apps.apple.com/us/app/muvr-request-movers/id6450030781',
      imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/4c/26/c0/4c26c0ef-45b4-426e-6ecd-039ec9569644/Placeholder.mill/400x400Icon.ApSiOS01-75.webp',
      isFeatured: true,
      isPublished: true,
      orderIndex: 18,
    ),
    const Project(
      id: 'proj_healthi_indian',
      slug: 'the-healthi-indian',
      title: 'The Healthi Indian',
      shortDescription: 'Health and nutrition app offering macro-balanced vegetarian and vegan recipes.',
      fullDescription: 'A specialized health and nutrition platform offering curated, macro-balanced vegetarian and vegan recipes. Migrated application state management from setState to GetX for improved responsiveness and maintainability. Completely redesigned the user interface, resolved critical splash screen startup issues, integrated backend REST APIs, and utilized SharedPreferences for local caching of recently viewed recipes. Enhanced user engagement with real-time search and filter capabilities and deployed production builds to both Google Play Store and Apple App Store.',
      category: 'Mobile App',
      companyName: 'Dinjan Infotech',
      technologies: [
        'Flutter',
        'GetX',
        'REST API',
        'SharedPreferences',
        'Android',
        'iOS',
      ],
      personalContribution: 'Architected the migration to GetX, resolved UI freeze issues on launch, integrated recipe search and filter APIs, and deployed to app stores.',
      challengesAndSolutions: 'Challenge: Laggy recipe list filtering and persistent splash screen delays. Solution: Refactored data fetching into GetX workers and implemented cached local storage with SharedPreferences.',
      verifiedOutcomes:
          'Successfully published on Google Play Store & Apple App Store.',
      imageUrl: 'https://play-lh.googleusercontent.com/8nteAV4V8jELN5nHTGWKR4XZpKpbR5FA31agItrvYrBEwUuDLmYuPAXF7Pz5X8eKuH-ske7pZPs41jmVm-6c=w832-h470-rw',
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.app.thehealthiindian',
      appStoreUrl:
          'https://apps.apple.com/us/app/the-healthi-indian/id6738694566',
      isFeatured: true,
      isPublished: true,
      orderIndex: 7,
      keyFeatures: [
        'Personalized meal suggestions tailored to individual fitness and nutritional goals',
        'A wide range of healthy vegetarian and vegan recipes, optimized for balanced macronutrient intake',
        'Simple, user-friendly interface with category filters to help users find meals suited to their lifestyle',
        'Complete privacy—no account creation or personal data collection needed to use the app',
      ],
    ),
    const Project(
      id: 'proj_radio_spice',
      slug: 'radio-spice',
      title: 'Radio Spice',
      shortDescription: 'Radio streaming app with background audio playback, social integrations, and push alerts.',
      fullDescription: 'A modern live radio streaming mobile application engineered with Flutter and GetX. Features continuous background audio playback, seamless YouTube video player integration, direct WhatsApp contact links, embedded WebViews for community programming, and Firebase Cloud Messaging for instant broadcast notifications.',
      category: 'Mobile App',
      companyName: 'Dinjan Infotech',
      technologies: [
        'Flutter',
        'GetX',
        'Audio Playback',
        'Firebase FCM',
        'WebView',
        'Android',
        'iOS',
      ],
      personalContribution: 'Built static audio streaming pipelines, integrated Firebase notifications for show announcements, and created responsive media player controls.',
      challengesAndSolutions: 'Challenge: Handling audio playback transitions during incoming calls and app minimization. Solution: Implemented audio focus listeners and foreground service controllers.',
      verifiedOutcomes: 'Deployed to Google Play Store & Apple App Store.',
      imageUrl: 'https://play-lh.googleusercontent.com/sFcN7Jo7Y9zs4gVZNXoNjbYF7ZySPMzYlt9kYGWN2SSll-j_jzFkMmH074LF6FfuQL66DlFlcR0tvoh3k54IOA=w832-h470-rw',
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.nzealand.radioSpice',
      appStoreUrl:
          'https://apps.apple.com/in/app/radio-spice-nzpmt/id6737826716',
      isFeatured: true,
      isPublished: true,
      orderIndex: 8,
      keyFeatures: [
        '▶️ Audio Playback with Play/Pause control',
        '🌐 WebView Integration for in-app browsing',
        '📞 Contact Us Screen with Email and Ad Inquiry options',
        '📲 WhatsApp Integration to send quick messages',
        '📹 YouTube Access via embedded video support',
        '🔔 Push Notifications powered by Firebase',
      ],
    ),
    const Project(
      id: 'proj_pmp_csv_validator',
      slug: 'pmp-csv-validator',
      title: 'PMP CSV Validator',
      shortDescription: 'Responsive browser-based dataset validation, repair, and mobile simulation suite automating QA for PMP question banks.',
      fullDescription:
          'A responsive browser-based dataset validation and repair suite developed in Flutter Web to upload, inspect, validate, correct, and export PMP question datasets. '
          'Features drag-and-drop CSV uploads, automatic delimiter and text-encoding detection with full Unicode support (Gujarati, Hindi, Sanskrit, special characters), a validation dashboard with error/warning statuses, and bulk Auto-Fix repair for HTML tags, styling, and array formats. '
          'Includes reusable HTML rendering supporting rich text, nested lists, Base64 images, horizontally scrollable tables, and inline/block LaTeX equations via flutter_math_fork, alongside an interactive mobile simulator with device presets, TRAIN/FLIP cards, and a side-by-side Cell Inspector.',
      category: 'Flutter Web',
      companyName: 'Logix Built Solutions Limited',
      technologies: [
        'Flutter',
        'Dart',
        'Flutter Web',
        'CSV Parsing',
        'HTML Rendering',
        'flutter_math_fork',
        'Widget Testing',
        'Python',
        'Web APIs',
        'AST Parser',
        'HTML5 BroadcastChannel',
      ],
      personalContribution:
          'Role: Flutter Developer (Platform: Flutter Web)\n'
          '• Developed a responsive CSV validation tool to upload, inspect, validate, correct, and export PMP question datasets directly through a browser-based interface.\n'
          '• Implemented drag-and-drop CSV uploads, automatic delimiter and text-encoding detection, CSV column navigation, and support for Unicode content, including Gujarati, Hindi, Sanskrit, and special characters.\n'
          '• Built a validation dashboard with error, warning, and app-compatibility statuses, issue summaries, field-level validation, and direct navigation to affected questions.\n'
          '• Developed bulk Auto-Fix functionality to repair common HTML tag, styling, and array-format issues, with corrected CSV generation and export.\n'
          '• Created reusable HTML rendering components supporting rich text, nested lists, Base64 images, horizontally scrollable tables, and inline/block LaTeX equations.\n'
          '• Built an interactive mobile simulator with device presets, custom screen dimensions, question navigation, and TRAIN/FLIP card previews to verify how CSV content renders in the actual Flutter app.\n'
          '• Implemented a side-by-side Cell Inspector to compare original HTML content with its rendered Flutter preview, including code inspection and copy actions.\n'
          '• Optimized CSV validation performance through reusable validation patterns and improved responsive layouts across desktop, tablet, and mobile screen sizes.\n'
          '• Added automated unit and widget tests for CSV validation, HTML rendering, arrays, tables, images, LaTeX formulas, and Auto-Fix functionality; verified the implementation using flutter analyze and flutter test.',
      challengesAndSolutions:
          'Challenge: Parsing malformed HTML syntax, broken table/list hierarchies, LaTeX equations, and encoding artifacts across massive CSV question banks while accurately previewing on simulated mobile viewports.\n'
          'Solution: Engineered automated validation rules and bulk Auto-Fix routines for HTML/array remediation, rendered complex math with flutter_math_fork, and built a side-by-side Cell Inspector and multi-device interactive mobile simulator in Flutter Web.',
      verifiedOutcomes: 'Browser-based CSV dataset QA suite with Unicode/multi-language support, bulk Auto-Fix remediation, LaTeX rendering, side-by-side Cell Inspector, and multi-device mobile simulator with automated test coverage.',
      isFeatured: true,
      isPublished: false,
      orderIndex: 1,
    ),
    const Project(
      id: 'proj_pmp_exam_prep',
      slug: 'pmp-exam-prep',
      title: 'PMP Exam Prep',
      shortDescription: 'Comprehensive certification exam simulator with interactive quizzes, referral deep linking, and performance tracking.',
      fullDescription: 'A specialized professional certification preparation application engineered in Flutter and GetX. Features interactive quiz modes with timed examinations, question bookmarking, answer explanations, attempt tracking, and performance analytics. Integrates referral deep linking with intent preservation, guest vs. premium tiered access control with subscription paywalls, native ad lifecycle management, and smooth responsive animations across mobile viewports.',
      category: 'EdTech',
      companyName: 'Logix Built Solutions Limited',
      technologies: [
        'Flutter',
        'Dart',
        'GetX',
        'REST APIs',
        'Firebase',
        'Local Storage',
        'Advertising SDKs (AdMob)',
        'Deep Linking (AppLinks)',
        'Animations',
      ],
      personalContribution:
          'Role: Flutter Developer\n'
          '• Enhanced interactive quiz experiences with question navigation, answer review, flagged questions, timers, explanations, quiz submission, and retake workflows.\n'
          '• Implemented quiz result and performance interfaces with attempt tracking, completion states, progress indicators, and responsive loading behavior.\n'
          '• Developed quiz interactions using scroll controllers, page transitions, animations, and dynamically adjusted layouts to improve the question-answer experience.\n'
          '• Implemented referral deep-link handling for initial app launches and active sessions, extracting referral codes and navigating users into the registration flow.\n'
          '• Enhanced guest and premium access flows with subscription prompts, login redirection, and access-related UI behavior.\n'
          '• Resolved state-management, controller lifecycle, scrolling, and duplicate widget rendering issues; improved native ad loading and disposal handling.\n'
          '• Refined profile, password validation, dictionary, image zoom and rotation, theme consistency, and responsive UI behavior.',
      challengesAndSolutions:
          'Challenge: Managing complex quiz controller lifecycles during rapid scrolling and page transitions while preventing memory leaks from ad SDKs and duplicate widget rendering.\n'
          'Solution: Refactored GetX controller lifecycle bindings, decoupled scroll listeners, and implemented defensive ad instance cleanup on view disposal.',
      verifiedOutcomes: 'Interactive certification quiz engine with full attempt analytics, referral deep linking, and smooth ad monetization.',
      isFeatured: true,
      isPublished: true,
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.pmp.examprep",
      orderIndex: 2,
    ),
    const Project(
      id: 'proj_nirvana',
      slug: 'nirvana-app',
      title: 'My Nirvana Portal',
      shortDescription: 'Real estate discovery and unit booking platform featuring live pricing, multi-step purchase flows, and an embedded chatbot.',
      fullDescription: 'A premier real estate and property exploration application built with Flutter. Enables prospective buyers to explore architectural projects, zone layouts, and specific unit availability with real-time dynamic pricing. Implements a multi-step property purchase flow from unit reservation to legal agreement review, down-payment computation, PDF document inspection, terms and conditions bottom sheets, and an AI chatbot assistant embedded directly on the home dashboard.',
      category: 'PropTech',
      companyName: 'Logix Built Solutions Limited',
      technologies: [
        'Flutter',
        'Dart',
        'REST APIs',
        'PDF Viewer',
        'Chatbot API',
        'Responsive UI',
        'Android Gradle',
        'iOS TestFlight',
      ],
      personalContribution:
          'Role: Flutter Developer\n'
          '• Developed property discovery and booking interfaces, including project and zone listings, unit selection, dashboards, booking history, and sales screens.\n'
          '• Integrated APIs to retrieve unit availability, unit-specific pricing, booking information, and payment-related data.\n'
          '• Implemented a multi-step property purchase workflow covering product selection, pricing, purchaser information, agreements, and payment.\n'
          '• Developed dynamic booking and pricing behavior, including down-payment calculations, payment summaries, and unit status handling for available, sold, booked, and reserved units.\n'
          '• Implemented agreement and PDF viewing, terms and conditions, price information bottom sheets, and booking detail interfaces.\n'
          '• Integrated a chatbot API into the home-screen chatbot experience.\n'
          '• Improved mobile and horizontal tablet layouts and prepared Android builds and iOS TestFlight releases for testing.',
      challengesAndSolutions:
          'Challenge: Real-time synchronization of unit status (available, sold, reserved) and accurate down-payment calculation across diverse tablet and mobile orientations.\n'
          'Solution: Engineered reactive view models with layout builders adapting to landscape tablets, and integrated legal contract PDF rendering directly in-app.',
      verifiedOutcomes: 'End-to-end property purchase engine with interactive PDF agreements, live unit reservation status, and iOS TestFlight deployment.',
      isFeatured: true,
      isPublished: true,
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.cscp.mynirvana",
      appStoreUrl: "https://apps.apple.com/my/app/my-nirvana/id1555172257",
      orderIndex: 3,
    ),
    const Project(
      id: 'proj_reutbyitforme',
      slug: 'reutbyitforme-app',
      title: 'Reut, buy me',
      shortDescription: 'Modernization of a legacy Flutter app from Flutter 3.10 to 3.32 with modern InAppWebView, FCM, and Android Gradle upgrade.',
      fullDescription: 'An extensive legacy modernization project upgrading an enterprise mobile app from Flutter 3.10 to Flutter 3.32. Resolved breaking API deprecations, modernized null-safety constraints across all packages, upgraded Firebase Cloud Messaging to modern background/tap workflows, refactored webview interactions to flutter_inappwebview with external browser routing, and updated Android Gradle Plugin, namespace declarations, and Android embedding standards for production stability.',
      category: 'App Migration',
      companyName: 'Logix Built Solutions Limited',
      technologies: [
        'Flutter (3.10 to 3.32)',
        'Dart',
        'Firebase Core',
        'Firebase Messaging (FCM)',
        'flutter_inappwebview',
        'Provider',
        'REST APIs',
        'Android Gradle Plugin',
      ],
      personalContribution:
          'Role: Flutter Developer (Tomer Mash)\n'
          '• Upgraded the legacy Flutter application from Flutter 3.10 to Flutter 3.32, updating incompatible dependencies and adapting deprecated APIs.\n'
          '• Migrated the project toward null-safe, compatible packages, including Firebase, WebView, connectivity, shared preferences, URL launching, and package information libraries.\n'
          '• Updated Firebase Messaging to support foreground notifications, notification-tap events, initial notification handling, and modern notification permission workflows.\n'
          '• Migrated WebView functionality to updated flutter_inappwebview APIs, including WebUri, URLRequest, and revised loading callbacks.\n'
          '• Implemented external-browser handling for links that should not remain inside the WebView.\n'
          '• Updated Android project configuration for modern Android Gradle Plugin compatibility, namespace requirements, and Android embedding changes.\n'
          '• Prepared updated builds for testing while investigating remaining runtime stability issues.',
      challengesAndSolutions:
          'Challenge: Multiple conflicting legacy transitive dependencies, deprecated Android embedding v1 issues, and broken WebView JS bridge callbacks following Flutter framework upgrades.\n'
          'Solution: Systematically resolved dependency trees, migrated to modern Android v2 embedding with AGP namespaces, and implemented flutter_inappwebview WebUri routing with external URL dispatch.',
      verifiedOutcomes: 'Successful migration from Flutter 3.10 to 3.32, modern push notification pipeline, and updated Android Gradle toolchain.',
      isFeatured: false,
      isPublished: true,
      playStoreUrl: "https://play.google.com/store/apps/details?id=com.reuttomer.reut_buy_it_for_me",
      orderIndex: 4,
    ),
    const Project(
      id: 'proj_milos_paddle',
      slug: 'milos-paddle-app',
      title: 'Milos Padel',
      shortDescription: 'Sports reservation mobile app supporting multi-court booking, dynamic time-slot pricing, and integrated payments.',
      fullDescription: 'A modern sports court booking mobile application tailored for paddle sports enthusiasts. Supports flexible multi-court scheduling allowing players to select concurrent courts and multi-hour time slots. Integrates live availability checks, automated multi-slot pricing algorithms, payment gateway processing, and resolution of Android Gradle/Kotlin compatibility hurdles.',
      category: 'Sports & Booking',
      companyName: 'Logix Built Solutions Limited',
      technologies: [
        'Flutter',
        'Dart',
        'REST APIs',
        'Payment Gateway',
        'Time Slot Algorithms',
        'Android Gradle',
      ],
      personalContribution:
          'Role: Flutter Developer\n'
          '• Developed multi-court booking functionality that supports selecting multiple courts and time slots.\n'
          '• Implemented time-range selection, default slot selection, and availability-based time-slot listings.\n'
          '• Integrated booking APIs to retrieve selected-slot information and display dynamic pricing for multiple court reservations.\n'
          '• Integrated payment API workflows for bookings involving multiple selected court slots.\n'
          '• Refined single-slot and multi-slot selection interfaces to support the booking flow.\n'
          '• Investigated Android Gradle and Kotlin compatibility issues affecting APK generation.',
      challengesAndSolutions:
          'Challenge: Managing dynamic pricing matrix calculations for disjoint vs. contiguous multi-court bookings, alongside Kotlin compiler compatibility issues.\n'
          'Solution: Designed stateful selection grids with real-time cost accumulation, and updated Gradle Kotlin DSL configurations for clean APK builds.',
      verifiedOutcomes: 'Multi-court booking engine with dynamic time-slot reservation and streamlined payment checkout.',
      isFeatured: false,
      isPublished: true,
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.milos.padel",
      appStoreUrl: "https://apps.apple.com/id/app/milos-padel/id6737511643",
      orderIndex: 5,
    ),
    const Project(
      id: 'proj_minder',
      slug: 'minder-app',
      title: 'Minder App',
      shortDescription: 'Mobile authentication validation, network diagnostics, and backend integration QA for production stability.',
      fullDescription: 'A quality assurance and backend integration engineering engagement for the Minder mobile application. Focused on verifying user onboarding, registration, and authentication API contracts against production and staging backends. Conducted network latency investigations, timeout profiling, and root-cause analysis for API discrepancies.',
      category: 'QA & Diagnostics',
      companyName: 'Logix Built Solutions Limited',
      technologies: [
        'Flutter',
        'Dart',
        'REST APIs',
        'Network Diagnostics',
        'Environment Configuration',
        'API Profiling',
      ],
      personalContribution:
          'Role: Flutter Developer\n'
          '• Validated signup and login API workflows against the live application.\n'
          '• Investigated API connectivity and timeout behavior by comparing API responses with the production app.\n'
          '• Updated the API base URL to the development environment when required.\n'
          '• Shared reproducible findings and supporting evidence with the backend developer to help investigate integration issues.',
      challengesAndSolutions:
          'Challenge: Intermittent auth timeouts occurring only under specific carrier networks and staging backend environments.\n'
          'Solution: Built diagnostic logging interceptors, mapped request/response discrepancies between dev and prod environments, and delivered actionable bug reports to backend teams.',
      verifiedOutcomes: 'Resolved authentication bottlenecks and improved cross-environment API reliability.',
      isFeatured: false,
      isPublished: true,
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.minder_app",
      orderIndex: 6,
    ),

    const Project(
      id: 'proj_inspire4goal',
      slug: 'inspire4goal',
      title: 'Inspire4Goal',
      shortDescription: 'Motivational quotes app featuring scheduled notifications, dark/light themes, and bilingual support.',
      fullDescription: 'A daily motivational mobile app designed to inspire goal achievement. Features curated quote categories, REST API synchronization, background scheduled push notifications, dynamic localization supporting English and Dutch, and a polished dark and light theme switch.',
      category: 'Mobile App',
      companyName: 'Dinjan Infotech',
      technologies: [
        'Flutter',
        'GetX',
        'REST APIs',
        'Localization',
        'Local Notifications',
      ],
      personalContribution: 'Designed responsive quote viewports, configured background notification schedulers, and integrated dual-language English & Dutch localization strings.',
      challengesAndSolutions: 'Challenge: Exact scheduled notification delivery across differing Android OEM battery optimizations. Solution: Used exact alarm scheduling protocols with battery-exemption guidance.',
      verifiedOutcomes:
          'Multi-lingual production deployment with dark/light themes.',
      isFeatured: true,
      isPublished: true,
      orderIndex: 9,
    ),
    const Project(
      id: 'proj_fineaway',
      slug: 'fineaway',
      title: 'Fine Away (Pty) Ltd.',
      shortDescription: 'License renewal utility app with automated OCR text scanning and cross-platform support.',
      fullDescription: 'A mobile utility application streamlining driving and business license renewals. Features optical character recognition (OCR) camera scanning to automatically read and populate document details, reducing manual typing errors. Maintained high performance across Android and iOS platforms.',
      category: 'Mobile App',
      companyName: 'White Orange Software',
      technologies: [
        'Flutter',
        'GetX',
        'Text Recognition (OCR)',
        'Android',
        'iOS',
      ],
      personalContribution: 'Maintained and extended codebase, integrated camera-based text scanning for instant form auto-fill, and fixed cross-platform layout discrepancies.',
      challengesAndSolutions: 'Challenge: Scanning accuracy under poor lighting conditions. Solution: Added edge-detection preprocessing and fallback manual confirmation steps.',
      verifiedOutcomes: 'Available on Google Play Store & Apple App Store.',
      imageUrl: 'https://play-lh.googleusercontent.com/C4hcEoBm5ra-qtwAmVV2rkg5RR7ZccsAz5Tv_IS8j2ETaDr2jB-oBjgkTJFQZLpmbr1c0IC38SuQBpKKj12_TQ=w832-h470-rw',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.app.fineaway',
      appStoreUrl: 'https://apps.apple.com/us/app/fineaway-app/id6467185920',
      isFeatured: true,
      isPublished: true,
      orderIndex: 10,
      keyFeatures: [
        'Renewal Reminders: Notifies users before license expiry to avoid fines',
        'Text Scanning: Auto-detects and extracts data from license discs',
        'User-Friendly Interface: Simplifies license submission and tracking',
        'Stable Infrastructure: Ensures a reliable and responsive app experience',
        'Secure Data Handling: Keeps user and vehicle info safe',
      ],
    ),
    const Project(
      id: 'proj_adroit_lc_banker',
      slug: 'adroit-vantage-lc-banker',
      title: 'Lighthouse Canton (LC Banker)',
      shortDescription: 'Wealth management and banking application featuring interactive financial charts and calendar scheduling.',
      fullDescription: 'Part of the Adroit Vantage enterprise financial suite. LC Banker provides financial wealth managers with responsive analytics dashboards, interactive financial yield graphs, calendar scheduling for client portfolio reviews, and secure REST API integrations powered by GetX state management.',
      category: 'Mobile App',
      companyName: 'White Orange Software',
      technologies: [
        'Flutter',
        'GetX',
        'REST APIs',
        'Financial Charts',
        'Calendar Sync',
      ],
      personalContribution: 'Engineered UI responsiveness across diverse tablet and phone screens, implemented financial charting components, and managed REST API integration.',
      challengesAndSolutions: 'Challenge: Rendering complex real-time financial chart animations without UI lag. Solution: Optimized canvas repaints and decoupled state notifications.',
      verifiedOutcomes: 'Enterprise-grade wealth management solution.',
      imageUrl: 'https://media.cakeresume.com/image/upload/s--7U5mpGz0--/c_pad,fl_png8,h_288,w_384/v1746093250/ebf7gcahzw7bf7jywmiq.png',
      isFeatured: false,
      isPublished: true,
      orderIndex: 11,
      keyFeatures: [
        'Secure chatbox for real-time communication',
        'Built-in task manager for priority handling',
        'Out-of-office notification setup',
        'KYC verification for secure identity validation',
        'Call/meeting notes to capture critical client data',
        'Calendar integration for scheduling events',
      ],
    ),
    const Project(
      id: 'proj_adroit_avsocial',
      slug: 'adroit-vantage-avsocial',
      title: 'AV Social',
      shortDescription: 'Internal social networking app with live feeds, real-time chat, interactive polls, and news modules.',
      fullDescription: 'An enterprise social networking application designed for organizational collaboration. Features a real-time activity feed, peer-to-peer chat, participatory employee polls, multimedia sharing, and news dissemination modules. Persists offline data using fast Hive NoSQL database.',
      category: 'Social Networking',
      companyName: 'White Orange Software',
      technologies: ['Flutter', 'Hive DB', 'REST APIs', 'Jira', 'Git'],
      personalContribution: 'Developed live feed widgets, chat message components, poll voting calculations, and integrated local caching with Hive DB.',
      challengesAndSolutions: 'Challenge: High-throughput chat messages causing frequent rebuilds. Solution: Scoped widget rebuilds to individual chat bubble state controllers.',
      verifiedOutcomes:
          'Collaborative enterprise platform with offline persistence.',
      isFeatured: false,
      isPublished: true,
      orderIndex: 12,
    ),

    const Project(
      id: 'proj_agents_thrive',
      slug: 'agents-thrive',
      title: 'Agents Thrive',
      shortDescription: 'Real estate agent productivity app featuring DocuSign e-signatures, PDF handling, and calendar sync.',
      fullDescription: 'A high-efficiency productivity mobile app for licensed real estate agents built using FlutterFlow and custom Flutter code. Features secure enterprise authentication, DocuSign document signing integration, in-app PDF previewing and annotation, productivity task tracking, and two-way calendar synchronization.',
      category: 'FlutterFlow',
      companyName: 'Dinjan Infotech',
      technologies: [
        'FlutterFlow',
        'Flutter',
        'DocuSign API',
        'PDF Handling',
        'Calendar Sync',
      ],
      personalContribution: 'Implemented secure login workflows, DocuSign embedded signing sessions, PDF document rendering, and native calendar synchronization.',
      challengesAndSolutions: 'Challenge: Embedding DocuSign signing ceremonies within a smooth webview without losing mobile authentication tokens. Solution: Configured OAuth callback interceptors.',
      verifiedOutcomes: 'Deployed to Google Play Store & Apple App Store.',
      imageUrl: 'https://play-lh.googleusercontent.com/e4S7aIZ7LsghP2NF4GJWnNb6Csfy5h5ZGlQ53Xujy7k4u-cvV1pUSIWwBU6rEtyhgeYrcFAH1TYYqu1vNoxp=w832-h470-rw',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.kwneworleans.app',
      appStoreUrl: 'https://apps.apple.com/us/app/thriveai/id6739500812',
      isFeatured: true,
      isPublished: true,
      orderIndex: 14,
      keyFeatures: [
        'AI Integration: Get instant advice and support with ChatGPT',
        'Secure Login: Seamless access through Firebase Authentication',
        'Smart Document Handling: Manage and send agreements with built-in DocuSign integration',
        'Productivity Tools: Real-time updates, calendar sync, and networking features keep agents informed and connected',
      ],
    ),
    const Project(
      id: 'proj_finpin',
      slug: 'finpin',
      title: 'FinPin',
      shortDescription: 'Personal finance and target tracking app with Google & Apple authentication and visual timelines.',
      fullDescription: 'A personal finance tracking application built with FlutterFlow and Firebase backend. Enables users to monitor income, categorize daily expenses, visualize savings trajectories across weekly, monthly, and yearly timelines, and establish custom financial milestone targets. Supports seamless Google and Apple single sign-on.',
      category: 'FlutterFlow',
      companyName: 'Dinjan Infotech',
      technologies: [
        'FlutterFlow',
        'Firebase Auth',
        'Cloud Firestore',
        'Social Auth',
        'iOS',
      ],
      personalContribution: 'Configured Firebase database schema, implemented Apple and Google SSO, created interactive financial timeline widgets, and set up goal tracking calculations.',
      challengesAndSolutions: 'Challenge: Complying with strict Apple Sign In requirements for iOS submission. Solution: Integrated Apple identity tokens with Firebase Auth credentials.',
      verifiedOutcomes: 'Available on the Apple App Store.',
      isFeatured: false,
      isPublished: false,
      orderIndex: 15,
    ),
    const Project(
      id: 'proj_disporata',
      slug: 'disporata',
      title: 'Disporata',
      shortDescription: 'Location-based social discovery app featuring Google Places integration and proximity calculations.',
      fullDescription: 'A location-aware social networking app built with Flutter and FlutterFlow. Includes secure automated login, detailed profile onboarding with Google Places autocomplete, real-time geodistance calculations, and dynamic nearby user discovery feeds.',
      category: 'Mobile App',
      companyName: 'Dinjan Infotech',
      technologies: [
        'Flutter',
        'FlutterFlow',
        'Google Places API',
        'Geolocation',
        'REST APIs',
      ],
      personalContribution: 'Built Google Places address lookup components, implemented Haversine distance calculation algorithms, and populated nearby user grids.',
      challengesAndSolutions: 'Challenge: Battery drain from frequent GPS location updates. Solution: Applied adaptive distance-threshold geolocation listeners.',
      verifiedOutcomes: 'Dynamic location-based discovery platform.',
      imageUrl: 'https://media.cakeresume.com/image/upload/s--tPqPaP6w--/c_pad,fl_png8,h_288,w_384/v1746081099/yqohmx2abva4ffkxps9i.png',
      isFeatured: false,
      isPublished: true,
      orderIndex: 16,
      keyFeatures: [
        'Seamless phone number authentication with auto-login and SMS verification',
        'Profile creation with home/host country and town using Google Places API',
        'Location tracking and distance calculation between users (miles/km)',
        'Sorted nearby users by proximity',
        'Push notifications triggered when users from the same country are within a 50-mile range',
      ],
    ),
    const Project(
      id: 'proj_mdsty',
      slug: 'mdsty',
      title: 'Mdsty',
      shortDescription: 'German e-commerce mobile application featuring MVC architecture, localized UI, and checkout flows.',
      fullDescription: 'A dedicated e-commerce mobile app crafted for the German retail market. Built on structured MVC architecture with clean REST API integration, multi-language localization (German & English), frictionless product discovery, payment gateway integration, and real-time order tracking.',
      category: 'E-Commerce',
      companyName: 'White Orange Software',
      technologies: [
        'Flutter',
        'MVC Architecture',
        'REST APIs',
        'Payment Gateway',
        'Localization',
      ],
      personalContribution: 'Structured MVC controllers, integrated e-commerce catalog APIs, implemented German localization files, and built the multi-step checkout flow.',
      challengesAndSolutions: 'Challenge: Formatting currency and tax compliance for EU regulations. Solution: Built custom localization formatters respecting German decimal separators.',
      verifiedOutcomes:
          'Production retail app for international European market.',
      isFeatured: false,
      isPublished: true,
      orderIndex: 17,
    ),
    const Project(
      id: 'proj_muvr',
      slug: 'muvr',
      title: 'Muvr Mover App',
      shortDescription:
          'On-demand moving and logistics platform with dedicated Mover App.',
      fullDescription: 'An on-demand logistics booking application connecting customers with professional moving service providers. Developed both the User App and Mover App using Flutter and GetX. Managed responsive layouts across all device sizes, mentored junior engineers on state management best practices, and maintained production stability.',
      category: 'Mobile App',
      companyName: 'White Orange Software',
      technologies: [
        'Flutter',
        'GetX',
        'Google Maps',
        'Role-Based Flow',
        'Play Store',
        'App Store',
      ],
      personalContribution: 'Engineered booking request workflows, mentored junior team members on clean code conventions, resolved layout issues, and prepared dual store deployments.',
      challengesAndSolutions: 'Challenge: Dual application role synchronization between customer booking and mover acceptance. Solution: Implemented atomic status state transitions in GetX controllers.',
      verifiedOutcomes: 'Four published store apps: Muvr User App (Play Store & App Store) and Muvr Mover App (Play Store & App Store).',
      appStoreUrl:
          'https://apps.apple.com/us/app/muvr-driver-move-deliver/id6450041017',
      imageUrl: 'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/41/0d/f7/410df79e-1419-e557-cf3b-8a55556fbb02/Placeholder.mill/400x400Icon.ApSiOS01-75.webp',
      isFeatured: true,
      isPublished: true,
      orderIndex: 19,
    ),
  ];
}
