# Dhruvi Patel - Flutter Web Portfolio

A high-performance, animated, production-ready personal developer portfolio and content management system built with **Flutter Web** and **Dart**.

---

## 🌟 Key Features & Architectural Highlights

### 1. Premium Visual Design & Branding
- **Dark Theme Digital Product Aesthetic**: Charcoal and near-black surfaces (`#090D16`, `#0F172A`, `#131D31`) with electric violet (`#8B5CF6`) and cyan (`#06B6D4`) ambient accents.
- **Subtle Ambient Motion**: GPU-optimized custom-painted ambient glow orbs with automatic reduced-motion detection (`MediaQuery.of(context).disableAnimations`).
- **Restrained Glassmorphism**: Polished translucent cards with thin border lighting and smooth hover elevations (`GlassCard`).
- **Balanced Typography**: Modern geometric sans-serif via `GoogleFonts.inter` and monospace code tags.
- **Light Theme Support**: Seamless toggle between dark and light themes without compromising visual contrast.

### 2. Public Portfolio Sections
- **Hero**: Animated role switcher (`Sr. Flutter Developer`, `Mobile App Specialist`, `Flutter Web Engineer`, `Cross-Platform Architect`), initials-based glowing avatar badge (`DP`), direct action buttons (`View Projects`, `Download Resume`, `Contact Me`), and verified contact pills.
- **About**: Summarized verified experience in Flutter, Dart, GetX, REST APIs, Firebase, AWS IoT Core (MQTT), and testing, paired with quantitative metric highlights.
- **Capabilities & Skills**: Reusable categories (`Mobile & Frameworks`, `Cloud & Backend`, `Architecture & Quality`) with verified technology badges. **No artificial percentage scores**.
- **Experience Timeline**: Vertical timeline with connecting gradient paths, individual duration badges, verified responsibilities, and **interval-merging cumulative duration calculation** (`ExperienceCalculator`) that avoids double-counting overlapping job dates.
- **Project Gallery**: Interactive project showcase featuring search and category filtering, responsive grid layouts, store/repository links, and comprehensive case-study modal dialogs.
- **Academic Foundation**: Verified degrees from Gujarat Technological University (G.T.U. / Sarvajanik College of Engineering & Technology - MCA) and Veer Narmad South Gujarat University (V.N.S.G.U. / Vivekanand College - BCA) with distinctions.
- **Functional Contact Section**: One-click email copy to clipboard, social links, location verification (Surat, Gujarat, India), and a functional inquiry composer that pre-fills and launches the default email client.

### 3. Secure Administrative CMS (`/#/admin`)
- Accessible via route `/admin` with hash-based routing resilience.
- **Firebase Authentication**: Email and password authentication with form validation.
- **Backend Authorization**: Restricted to verified identities matching `/databases/$(database)/documents/admins/$(request.auth.uid)` with `role == 'admin'`. Client-side flag spoofing is prevented by backend Firestore rules.
- **Content Management Operations**: Full CRUD, reordering, draft/published status toggling, and confirmation dialogs before destructive deletions for:
  - Work Experience
  - Projects (including featured toggle and store URLs)
  - Technical Skills
  - Education & Qualifications
  - Profile & Resume URL Settings
- **Resilient Fallback Mode**: If Firebase is offline or unconfigured, the app renders authoritative seed data extracted from Dhruvi Patel's resumes.

---

## 📁 Project Structure

```
lib/
├── main.dart                          # Application entrypoint
├── app.dart                           # MultiProvider and MaterialApp.router setup
├── core/
│   ├── constants/
│   │   ├── app_breakpoints.dart       # Responsive layout breakpoints
│   │   ├── app_constants.dart         # Verified biographical & contact constants
│   │   ├── app_durations.dart         # Centralized animation timings
│   │   └── seed_data.dart             # Authoritative resume seed data
│   ├── routing/
│   │   └── app_router.dart            # GoRouter with authentication route guards
│   ├── theme/
│   │   ├── app_colors.dart            # Charcoal, violet, and cyan palette
│   │   ├── app_theme.dart             # Dark and light ThemeData + ThemeController
│   │   └── app_typography.dart        # Typography styles
│   └── utils/
│       ├── experience_calculator.dart # Interval merging duration calculator
│       └── url_launcher_util.dart     # Safe URL and email launching
├── models/
│   ├── education.dart                 # Academic qualification model
│   ├── experience.dart                # Work experience model
│   ├── profile.dart                   # Developer profile & social link model
│   ├── project.dart                   # Project model with case study fields
│   └── skill.dart                     # Categorized skill model
├── repositories/
│   ├── admin_repository.dart          # Administrative CRUD and reordering
│   └── portfolio_repository.dart      # Public data fetching & fallback handling
├── services/
│   ├── auth_service.dart              # Firebase Auth & backend admin verification
│   └── firebase_service.dart          # Safe Firebase initialization
├── sections/
│   ├── portfolio_page.dart            # Assembled public portfolio screen
│   ├── hero/hero_section.dart
│   ├── about/about_section.dart
│   ├── skills/skills_section.dart
│   ├── experience/experience_section.dart
│   ├── projects/projects_section.dart
│   ├── education/education_section.dart
│   ├── contact/contact_section.dart
│   └── footer/footer_section.dart
├── admin/
│   ├── auth/admin_login_page.dart     # Admin authentication page
│   ├── dashboard/admin_dashboard_page.dart # Admin CMS console
│   ├── education/education_edit_dialog.dart
│   ├── experience/experience_edit_dialog.dart
│   ├── projects/project_edit_dialog.dart
│   └── skills/skill_edit_dialog.dart
└── widgets/
    ├── animations/ambient_background.dart # Custom-painted ambient lighting
    ├── animations/staggered_entrance.dart
    ├── cards/app_network_image.dart   # Image loading with placeholder & fallback
    ├── cards/glass_card.dart          # Glassmorphic container with hover effect
    ├── navigation/nav_bar.dart        # Desktop navigation header
    ├── navigation/mobile_drawer.dart  # Mobile drawer navigation
    └── responsive/responsive_layout.dart
```

---

## 🚀 Local Development Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.27+ / 3.47+
- [Git](https://git-scm.com/)

### 1. Clone & Install Dependencies
```bash
git clone https://github.com/YOUR-USERNAME/dhruvi-portfolio.git
cd dhruvi-portfolio
flutter pub get
```

### 2. Run Local Development Server
```bash
flutter run -d chrome
```

### 3. Verify Code Quality & Tests
```bash
# Verify formatting
dart format --output=none --set-exit-if-changed .

# Static code analysis (must report: No issues found!)
flutter analyze

# Execute all unit and widget tests
flutter test

# Test production release web build
flutter build web --release --base-href "/dhruvi-portfolio/"
```

---

## 🔒 Firebase Configuration & Security Rules

### 1. Initialize Firebase Web App
1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a project (e.g. `dhruvi-portfolio`).
2. Register a **Web App** in the project settings.
3. Enable **Email/Password** sign-in under **Authentication** > **Sign-in method**.
4. Create a **Cloud Firestore** database.

### 2. Bootstrap the First Administrator Account
To maintain strict security, client-side self-registration is disabled. Provision the administrator account directly:
1. In the **Firebase Console** under **Authentication**, click **Add user** and register `dhruvi39604@gmail.com` with a secure password. Copy the resulting **User UID**.
2. Go to **Firestore Database** and create a document:
   - **Collection ID**: `admins`
   - **Document ID**: `<PASTE_USER_UID_HERE>`
   - **Fields**:
     - `role`: string `"admin"`
3. Log in via `/#/admin` in the application using these credentials.

### 3. Deploy Cloud Firestore Security Rules
The production rules file is located at `firestore.rules`. Deploy using the Firebase CLI:
```bash
# Validate syntax with a dry run
firebase deploy --only firestore:rules --dry-run

# Deploy to live Firestore
firebase deploy --only firestore:rules
```

---

## 🌐 GitHub Pages Deployment (Automated CI/CD)

The repository includes a GitHub Actions workflow at `.github/workflows/deploy.yml`.

### Deployment Steps:
1. Push your repository to GitHub under the name `dhruvi-portfolio`:
   ```bash
   git remote add origin https://github.com/YOUR-USERNAME/dhruvi-portfolio.git
   git branch -M main
   git push -u origin main
   ```
2. In your GitHub repository:
   - Navigate to **Settings** > **Pages**.
   - Under **Build and deployment** > **Source**, select **GitHub Actions**.
3. The workflow will automatically trigger on push to `main`:
   - Checks code formatting (`dart format`)
   - Runs static analysis (`flutter analyze`)
   - Runs all tests (`flutter test`)
   - Builds Flutter web in release mode with base href `/dhruvi-portfolio/`
   - Deploys the release artifact to GitHub Pages.

### Hosting URL Targets:
- **Project Site**: `https://<YOUR-USERNAME>.github.io/dhruvi-portfolio/` (uses default base href `/dhruvi-portfolio/`)
- **User Site / Custom Domain**: `https://<YOUR-USERNAME>.github.io/` (trigger workflow manually via `workflow_dispatch` with base href `/`)

### Rollback Strategy:
If a faulty commit is deployed to `main`:
1. Check out the last known good commit:
   ```bash
   git revert HEAD
   git push origin main
   ```
2. The GitHub Actions pipeline will immediately build and deploy the reverted, stable release.

---

## 📋 Verified Content Checklist & Customization Notes

| Item | Status | Source / Value | Action Required |
| :--- | :--- | :--- | :--- |
| **Developer Name** | ✅ Verified | Dhruvi Patel | Ready |
| **Email** | ✅ Verified | `dhruvi39604@gmail.com` | Ready |
| **Phone** | ✅ Verified | `+91 9925589405` | Ready |
| **Location** | ✅ Verified | Surat, Gujarat, India | Ready |
| **Work History (4 Roles)** | ✅ Verified | DinJan, White Orange, Logix Built | Ready |
| **Education (MCA & BCA)** | ✅ Verified | GTU (7.61 CGPA) & VNSGU (7.39 CGPA) | Ready |
| **12 Projects** | ✅ Verified | Detailed case studies from resume | Add live store URLs when available |
| **GitHub Profile URL** | ⚠️ Placeholder | `https://github.com/dhruvipatel` | Update via `/admin` dashboard |
| **LinkedIn Profile URL** | ⚠️ Placeholder | `https://www.linkedin.com/in/...` | Update via `/admin` dashboard |
| **Custom Resume PDF** | ⚠️ Placeholder | `assets/docs/resume.pdf` | Replace with actual PDF asset |
