# Dhruvi Patel - Flutter Web Portfolio

A high-performance, responsive personal developer portfolio engineered with **Flutter Web** and **Dart**. Designed with a dark obsidian and electric violet/cyan aesthetic, subtle ambient lighting, frosted glassmorphism, 3D character branding, and authoritative verified credentials.

---

## 🌟 Key Features & Architectural Highlights

### 1. Premium Visual Design & Branding
- **Dark Theme Digital Product Aesthetic**: Obsidian and midnight-slate surfaces (`#090D16`, `#0F172A`, `#131D31`) with electric violet (`#8B5CF6`) and cyan (`#06B6D4`) ambient accents.
- **GPU-Optimized Ambient Motion**: Custom-painted ambient glow orbs with automatic reduced-motion detection (`MediaQuery.of(context).disableAnimations`).
- **Restrained Glassmorphism**: Polished translucent cards with thin border lighting and smooth hover elevations (`GlassCard`).
- **Balanced Typography**: Modern geometric sans-serif via `GoogleFonts.inter` with monospace code tags.
- **Seamless Light Theme**: Full light theme support (`#FAF9FE` frosted lavender canvas) with carefully calibrated contrast ratios.
- **3D Character Brand Identity**: Custom 3D anime character illustrations featured across Hero, About, Education, Contact, and Startup Preloader stages.

### 2. High-Performance Web Architecture
- **Instant First-Frame Display**: HTML/CSS startup preloader in `web/index.html` transitions instantly on `flutter-first-frame` without artificial double-loader delays.
- **PWA Ready**: Customized `web/manifest.json` configured for standalone installation on mobile, tablet, and desktop viewports.
- **OpenGraph & Social Share Ready**: High-resolution 1200×630 `og-image.png` social preview card for LinkedIn, WhatsApp, Twitter/X, and Slack link shares.
- **Clean Architecture & Decoupled State**: Layered separation between data models, reactive `PortfolioRepository` (`ChangeNotifier`), and UI view components.

### 3. Public Portfolio Sections
- **Hero Section**: Animated role switcher (`Sr. Software Engineer`, `Sr. Flutter Developer`, `Mobile Application Developer`), initials avatar badge (`DP`), direct action buttons (`View Projects`, `Download CV`), status chip (`Available for Senior Roles`), and 3D developer character stage.
- **About Section**: Verified commercial experience, engineering philosophy, Code Craft Excellence Award (2025) badge, and animated milestone counters (4+ Years, 50+ Releases, 20+ Projects, MCA/BCA Distinction).
- **Core Capabilities & Skills**: Categorized technical stacks (`Mobile & Frameworks`, `Cloud & Backend`, `Architecture & Quality`) with verified technology badges.
- **Career Path & Experience**: 2-column desktop grid and mobile timeline showing 4 career roles with **interval-merging cumulative duration calculation** (`ExperienceCalculator`) that avoids double-counting overlapping dates.
- **Featured Work & Projects**: 20 verified production applications featuring real-time AWS IoT Core (MQTT) dispatch, GetX, custom astrology engines, LaTeX formula parsing, and dual-store app releases with interactive search and category filtering.
- **Academic Foundation**: Verified Master of Computer Applications (MCA - GTU, 7.61 CGPA) and Bachelor of Computer Applications (BCA - VNSGU, 7.39 CGPA) distinctions.
- **Contact & Direct Inquiry**: One-click email launching, phone/location verification, and direct inquiry composer.

---

## 📁 Project Structure

```
lib/
├── main.dart                          # Application entrypoint
├── app.dart                           # MultiProvider and MaterialApp.router setup
├── core/
│   ├── constants/
│   │   ├── app_breakpoints.dart       # Responsive 3-tier layout breakpoints
│   │   ├── app_constants.dart         # Verified biographical & contact constants
│   │   ├── app_durations.dart         # Centralized animation timings
│   │   └── seed_data.dart             # Authoritative resume data (20 apps, 4 roles)
│   ├── routing/
│   │   └── app_router.dart            # GoRouter configuration
│   ├── theme/
│   │   ├── app_colors.dart            # Obsidian, electric violet, and cyan palette
│   │   ├── app_theme.dart             # Dark and light ThemeData + ThemeController
│   │   └── app_typography.dart        # Typography styles with GoogleFonts.inter
│   └── utils/
│       ├── experience_calculator.dart # Interval-merging cumulative duration calculator
│       └── url_launcher_util.dart     # Safe URL and email launching
├── models/
│   ├── education.dart                 # Academic qualification model
│   ├── experience.dart                # Work experience model
│   ├── profile.dart                   # Developer profile & social link model
│   ├── project.dart                   # Project model with case study fields
│   └── skill.dart                     # Categorized skill model
├── repositories/
│   └── portfolio_repository.dart      # Reactive data repository providing seed data
├── sections/
│   ├── portfolio_page.dart            # Main assembled public portfolio screen
│   ├── hero/hero_section.dart         # Hero section with 3D character & dynamic roles
│   ├── about/about_section.dart       # About section with metric counters & award
│   ├── skills/skills_section.dart     # Categorized skill badges
│   ├── experience/experience_section.dart # 2-column desktop grid & mobile timeline
│   ├── projects/projects_section.dart # Searchable project showcase with category filters
│   ├── education/education_section.dart # Degree distinctions with academic character
│   ├── contact/contact_section.dart   # Interactive inquiry composer & verified info
│   └── footer/footer_section.dart     # Navigation links & developer credit
└── widgets/
    ├── animations/
    │   ├── ambient_background.dart    # Custom-painted ambient lighting orbs
    │   ├── character_loader.dart      # 3D character animated loader component
    │   └── staggered_entrance.dart    # Subtle entrance animations
    ├── cards/
    │   ├── app_network_image.dart     # Resilient image loader with placeholder
    │   └── glass_card.dart            # Frosted glassmorphic container with hover effect
    ├── navigation/
    │   ├── nav_bar.dart               # Floating glassmorphic desktop navbar
    │   └── mobile_drawer.dart         # Mobile drawer navigation
    └── responsive/
        └── responsive_layout.dart     # Max-width content wrappers & layout helpers
```

---

## 🚀 Local Development Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.27+ (Channel stable)
- [Git](https://git-scm.com/)

### 1. Clone & Install Dependencies
```bash
git clone https://github.com/dhruvi-mobiledev/my-portfolio.git
cd my-portfolio
flutter pub get
```

### 2. Run Local Development Server
```bash
# Run in Google Chrome
flutter run -d chrome
```

### 3. Verify Code Quality & Tests
```bash
# Verify formatting
dart format --output=none --set-exit-if-changed .

# Static code analysis (0 issues)
flutter analyze

# Execute all 22 unit, model, and widget test suites
flutter test

# Test production release web build
flutter build web --release --base-href "/my-portfolio/"
```

---

## 🌐 GitHub Pages Deployment (Automated CI/CD)

The repository includes a GitHub Actions workflow at `.github/workflows/deploy.yml`.

### Deployment Steps:
1. Push your changes to the `main` branch:
   ```bash
   git push origin main
   ```
2. In your GitHub repository:
   - Navigate to **Settings** > **Pages**.
   - Under **Build and deployment** > **Source**, select **GitHub Actions**.
3. The workflow automatically executes on push to `main`:
   - Checks code formatting (`dart format`)
   - Runs static analysis (`flutter analyze`)
   - Executes all test suites (`flutter test`)
   - Builds Flutter web in release mode (`flutter build web --release`)
   - Deploys the production build to GitHub Pages.

### Live Production Target:
- **Live URL**: `https://dhruvi-mobiledev.github.io/my-portfolio/`

---

## 📋 Verified Credentials & Content Summary

| Item | Details |
| :--- | :--- |
| **Developer Name** | Dhruvi Patel |
| **Primary Title** | Senior Software Engineer • Senior Flutter Developer |
| **Email** | `dhruvi39604@gmail.com` |
| **Phone** | `+91 9925589405` |
| **Location** | Surat, Gujarat, India |
| **Commercial Experience** | 4+ Years (Logix Built Solutions, Dinjan Infotech, White Orange Software) |
| **App Releases** | 50+ Production releases on Google Play Store & Apple App Store |
| **Key Projects (20)** | Pandits Near Me, PMP CSV Validator, The Healthi Indian, Fine Away, Radio Spice, etc. |
| **Education** | MCA (GTU, Distinction 7.61) & BCA (VNSGU, Distinction 7.39) |
| **Awards** | Code Craft Excellence Award (2025) |
| **GitHub** | [github.com/dhruvi-mobiledev](https://github.com/dhruvi-mobiledev) |
| **LinkedIn** | [linkedin.com/in/duvi03](https://www.linkedin.com/in/duvi03) |
| **Archived Rules** | Optional Cloud Firestore security rules archived in [`archive/firestore.rules`](archive/firestore.rules) |
