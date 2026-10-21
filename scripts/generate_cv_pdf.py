"""
CV / Resume PDF Generator for Dhruvi Patel
Generates an ATS-compliant, executive, beautifully formatted 2-page CV in PDF format
using headless Microsoft Edge / Google Chrome.
"""

import os
import subprocess
import sys
from pathlib import Path

WORKSPACE_ROOT = Path(__file__).resolve().parent.parent
OUTPUT_PDF_DOCS = WORKSPACE_ROOT / "assets" / "docs" / "Dhruvi_Patel_CV.pdf"
OUTPUT_PDF_DEFAULT = WORKSPACE_ROOT / "assets" / "docs" / "resume.pdf"
TEMP_HTML = WORKSPACE_ROOT / "scripts" / "cv_template.html"

HTML_CONTENT = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Dhruvi Patel - Senior Flutter Developer & Senior Software Engineer CV</title>
  <style>
    @page {
      size: A4;
      margin: 10mm 12mm 10mm 12mm;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      color: #1e293b;
      background: #ffffff;
      font-size: 8.8pt;
      line-height: 1.35;
      -webkit-font-smoothing: antialiased;
    }

    a {
      color: #1d4ed8;
      text-decoration: none;
    }

    a:hover {
      text-decoration: underline;
    }

    /* Page container */
    .page {
      width: 100%;
    }

    .page-break {
      page-break-before: always;
      padding-top: 2mm;
    }

    /* Header styling */
    .header {
      border-bottom: 2px solid #2563eb;
      padding-bottom: 7px;
      margin-bottom: 9px;
    }

    .name-title-row {
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
      margin-bottom: 5px;
    }

    .candidate-name {
      font-size: 20pt;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -0.5px;
      line-height: 1;
    }

    .candidate-headline {
      font-size: 9.8pt;
      font-weight: 600;
      color: #2563eb;
      letter-spacing: -0.2px;
      margin-top: 3px;
    }

    .contact-bar {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      font-size: 8.2pt;
      color: #475569;
      margin-top: 4px;
    }

    .contact-item {
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }

    .contact-item svg {
      width: 11px;
      height: 11px;
      fill: #2563eb;
      flex-shrink: 0;
    }

    /* Section styling */
    .section {
      margin-bottom: 9px;
    }

    .section-title {
      font-size: 9.8pt;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.6px;
      color: #0f172a;
      border-bottom: 1px solid #cbd5e1;
      padding-bottom: 2px;
      margin-bottom: 6px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .section-title svg {
      width: 12px;
      height: 12px;
      fill: #2563eb;
    }

    /* Summary */
    .summary-text {
      font-size: 8.6pt;
      color: #334155;
      text-align: justify;
      line-height: 1.38;
    }

    /* Skills Grid */
    .skills-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 8.4pt;
    }

    .skills-table td {
      padding: 2.2px 0;
      vertical-align: top;
    }

    .skill-cat {
      width: 25%;
      font-weight: 700;
      color: #0f172a;
      white-space: nowrap;
    }

    .skill-val {
      width: 75%;
      color: #334155;
    }

    .skill-highlight {
      color: #1e40af;
      font-weight: 600;
    }

    /* Work Experience & Projects */
    .entry {
      margin-bottom: 7px;
      page-break-inside: avoid;
    }

    .entry-header {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      margin-bottom: 1.5px;
    }

    .entry-title {
      font-size: 9.2pt;
      font-weight: 700;
      color: #0f172a;
    }

    .entry-role {
      font-weight: 600;
      color: #2563eb;
    }

    .entry-meta {
      font-size: 8pt;
      font-weight: 600;
      color: #64748b;
      text-align: right;
      white-space: nowrap;
    }

    .entry-sub {
      display: flex;
      justify-content: space-between;
      font-size: 8.2pt;
      color: #475569;
      margin-bottom: 2.5px;
      font-style: italic;
    }

    .award-pill {
      display: inline-block;
      background: #fef3c7;
      border: 1px solid #f59e0b;
      color: #92400e;
      font-weight: 700;
      font-size: 7.8pt;
      padding: 1px 6px;
      border-radius: 3px;
      margin-bottom: 3px;
      font-style: normal;
    }

    .tech-stack-line {
      font-size: 7.9pt;
      color: #475569;
      margin-bottom: 2.5px;
    }

    .tech-label {
      font-weight: 700;
      color: #0f172a;
    }

    ul.bullet-list {
      margin-left: 14px;
      padding-left: 0;
      list-style-type: disc;
    }

    ul.bullet-list li {
      font-size: 8.35pt;
      color: #334155;
      margin-bottom: 2px;
      line-height: 1.32;
      text-align: justify;
    }

    ul.bullet-list li strong {
      color: #0f172a;
    }

    /* Education */
    .edu-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
      page-break-inside: avoid;
    }

    .edu-card {
      border-left: 2px solid #2563eb;
      padding-left: 8px;
    }

    .edu-degree {
      font-size: 8.8pt;
      font-weight: 700;
      color: #0f172a;
    }

    .edu-inst {
      font-size: 8.1pt;
      color: #475569;
    }

    .edu-dates {
      font-size: 7.8pt;
      color: #64748b;
      font-weight: 600;
      margin-top: 1px;
    }

    .edu-grade {
      font-size: 8pt;
      font-weight: 700;
      color: #166534;
      display: inline-block;
      margin-top: 2px;
    }

    /* Footer Note */
    .cv-footer {
      border-top: 1px solid #e2e8f0;
      padding-top: 4px;
      margin-top: 8px;
      display: flex;
      justify-content: space-between;
      font-size: 7.2pt;
      color: #94a3b8;
    }
  </style>
</head>
<body>

  <!-- ==================== PAGE 1 ==================== -->
  <div class="page">
    
    <!-- HEADER -->
    <header class="header">
      <div class="name-title-row">
        <div>
          <h1 class="candidate-name">Dhruvi Patel</h1>
          <div class="candidate-headline">Sr. Software Engineer • Sr. Flutter Developer • Mobile Application Developer</div>
        </div>
      </div>
      <div class="contact-bar">
        <span class="contact-item">
          <svg viewBox="0 0 24 24"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
          Surat, Gujarat, India
        </span>
        <span class="contact-item">
          <svg viewBox="0 0 24 24"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
          <a href="tel:+919925589405">+91 9925589405</a>
        </span>
        <span class="contact-item">
          <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
          <a href="mailto:dhruvi39604@gmail.com">dhruvi39604@gmail.com</a>
        </span>
        <span class="contact-item">
          <svg viewBox="0 0 24 24"><path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.28 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.75M6.46 8.76a1.45 1.45 0 1 0 0-2.9 1.45 1.45 0 0 0 0 2.9m1.4 9.74v-8.37H5.06v8.37h2.8z"/></svg>
          <a href="https://www.linkedin.com/in/dhruvi-patel-flutter" target="_blank">linkedin.com/in/dhruvi-patel-flutter</a>
        </span>
        <span class="contact-item">
          <svg viewBox="0 0 24 24"><path d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34-.46-1.16-1.11-1.47-1.11-1.47-.91-.62.07-.6.07-.6 1 .07 1.53 1.03 1.53 1.03.87 1.52 2.34 1.07 2.91.83.1-.65.35-1.09.63-1.34-2.22-.25-4.55-1.11-4.55-4.92 0-1.11.38-2 1.03-2.71-.1-.25-.45-1.29.1-2.64 0 0 .84-.27 2.75 1.02.79-.22 1.65-.33 2.5-.33.85 0 1.71.11 2.5.33 1.91-1.29 2.75-1.02 2.75-1.02.55 1.35.2 2.39.1 2.64.65.71 1.03 1.6 1.03 2.71 0 3.82-2.34 4.66-4.57 4.91.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2z"/></svg>
          <a href="https://github.com/dhruvipatel" target="_blank">github.com/dhruvipatel</a>
        </span>
      </div>
    </header>

    <!-- PROFESSIONAL SUMMARY -->
    <section class="section">
      <div class="section-title">
        <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
        Professional Summary
      </div>
      <p class="summary-text">
        <strong>Senior Software Engineer & Senior Flutter Developer</strong> with <strong>4+ years</strong> of professional experience architecting, engineering, and publishing high-performance cross-platform mobile (iOS, Android) and web applications. Recognized with the <strong>Code Craft Excellence Award (2025)</strong> for clean modular architecture, technical leadership, and engineering craftsmanship. Proven track record leading products from concept to scale, managing <strong>50+ production releases</strong>, designing low-latency real-time dispatch systems via <strong>AWS IoT Core (MQTT)</strong> and <strong>Firebase Cloud Messaging</strong>, engineering resilient networking layers with thread-safe locks, and authoring automated testing suites (Unit, Widget, Integration) ensuring zero regression.
      </p>
    </section>

    <!-- CORE TECHNICAL SKILLS -->
    <section class="section">
      <div class="section-title">
        <svg viewBox="0 0 24 24"><path d="M22.7 19l-9.1-9.1c.9-2.3.4-5-1.5-6.9-2-2-5-2.4-7.4-1.3L9 6 6 9 1.6 4.7C.4 7.1.9 10.1 2.9 12.1c1.9 1.9 4.6 2.4 6.9 1.5l9.1 9.1c.4.4 1 .4 1.4 0l2.3-2.3c.5-.4.5-1.1.1-1.4z"/></svg>
        Technical Competencies
      </div>
      <table class="skills-table">
        <tr>
          <td class="skill-cat">Languages & Frameworks:</td>
          <td class="skill-val"><span class="skill-highlight">Flutter (Mobile & Web)</span>, <span class="skill-highlight">Dart</span>, FlutterFlow, Java, Kotlin, Python, HTML5, CSS3, JavaScript</td>
        </tr>
        <tr>
          <td class="skill-cat">Architecture & State:</td>
          <td class="skill-val"><span class="skill-highlight">Clean & Modular Architecture</span>, <span class="skill-highlight">GetX State Management</span>, BLoC Pattern, Repository Pattern, Dependency Injection</td>
        </tr>
        <tr>
          <td class="skill-cat">Cloud & Real-Time:</td>
          <td class="skill-val"><span class="skill-highlight">AWS IoT Core (MQTT over WebSockets)</span>, Firebase (FCM, Firestore, Auth, Crashlytics, Remote Config, Performance), RESTful APIs, Dio, JWT Security</td>
        </tr>
        <tr>
          <td class="skill-cat">Storage & Database:</td>
          <td class="skill-val"><span class="skill-highlight">Hive DB</span>, Flutter Secure Storage, Cloud Firestore, SQLite, SharedPreferences</td>
        </tr>
        <tr>
          <td class="skill-cat">Testing & Quality:</td>
          <td class="skill-val"><span class="skill-highlight">Mocktail</span>, Unit Testing, Widget Testing, Flutter Integration Test, DevTools Profiling, Code Analysis</td>
        </tr>
        <tr>
          <td class="skill-cat">Tooling & Deployment:</td>
          <td class="skill-val">Git, GitHub Actions, Google Play Console, Apple App Store Connect, Android Studio, Xcode, VS Code, Postman</td>
        </tr>
        <tr>
          <td class="skill-cat">APIs & Integrations:</td>
          <td class="skill-val">Google Places API, Cloudflare Turnstile, In-App Review, In-App Purchases (StoreKit / RevenueCat), CustomPainter, flutter_math_fork</td>
        </tr>
      </table>
    </section>

    <!-- PROFESSIONAL EXPERIENCE -->
    <section class="section">
      <div class="section-title">
        <svg viewBox="0 0 24 24"><path d="M20 6h-4V4c0-1.11-.89-2-2-2h-4c-1.11 0-2 .89-2 2v2H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-6 0h-4V4h4v2z"/></svg>
        Professional Experience
      </div>

      <!-- Logix Built Solution Limited -->
      <div class="entry">
        <div class="entry-header">
          <div>
            <span class="entry-title">Logix Built Solution Limited</span>
            <span style="color:#64748b;"> • Surat, India</span>
          </div>
          <span class="entry-meta">May 2025 – Present</span>
        </div>
        <div class="entry-sub">
          <span class="entry-role">Sr. Software Engineer – Flutter Developer</span>
          <span class="award-pill">🏆 Code Craft Excellence Award (2025)</span>
        </div>
        <div class="tech-stack-line">
          <span class="tech-label">Technologies:</span> Flutter, Dart, GetX, AWS IoT Core (MQTT), FCM, Dio, JWT, Python, Firebase Crashlytics & Analytics, Mocktail
        </div>
        <ul class="bullet-list">
          <li><strong>Engineering Leadership & Architecture:</strong> Architected dual-sided on-demand mobile applications and web QA platforms from scratch using Flutter, Dart, and GetX under a strict Clean Modular Architecture.</li>
          <li><strong>Real-Time Dispatch Engine:</strong> Built low-latency bidirectional dispatch infrastructure using <strong>AWS IoT Core (MQTT over Secure WebSockets)</strong> and <strong>Firebase Cloud Messaging (FCM)</strong> with background reconnection logic and custom sound/vibration alerts.</li>
          <li><strong>Resilient Network Layer:</strong> Engineered Dio HTTP client with smart exponential backoff retries and a thread-safe <strong>Single-Flight Lock (Completer)</strong> that completely resolved token-refresh race conditions in concurrent API requests.</li>
          <li><strong>Release & Production Lifecycle:</strong> Managed <strong>50+ production releases</strong> across Google Play and Apple App Store, orchestrating zero-downtime updates with Google Play In-App Updates (Immediate & Flexible) and Firebase Remote Config.</li>
          <li><strong>Web QA Automation Suite:</strong> Engineered a browser-based dataset validation suite in Flutter Web with a 20-rule AST parser, auto-remediating malformed HTML, broken table/list hierarchies, and encoding artifacts.</li>
          <li><strong>Deep Linking & User Engagement:</strong> Implemented AppLinks deep-linking with auth-gated intent preservation for one-click external booking acceptance, alongside an engagement-gated In-App Review triage system.</li>
          <li><strong>Automated Testing:</strong> Authored comprehensive Unit, Widget, and Integration test suites using <strong>Mocktail</strong> and Flutter Integration Test, achieving high coverage and eliminating production regressions.</li>
        </ul>
      </div>

      <!-- DinJan Infotech -->
      <div class="entry">
        <div class="entry-header">
          <div>
            <span class="entry-title">DinJan Infotech Private Limited</span>
            <span style="color:#64748b;"> • Surat, India</span>
          </div>
          <span class="entry-meta">June 2024 – April 2025</span>
        </div>
        <div class="entry-sub">
          <span class="entry-role">Flutter Developer</span>
          <span>Full-time</span>
        </div>
        <div class="tech-stack-line">
          <span class="tech-label">Technologies:</span> Flutter, FlutterFlow, Dart, Custom Widgets, Android, iOS, REST APIs, Git
        </div>
        <ul class="bullet-list">
          <li><strong>Cross-Platform Product Delivery:</strong> Designed and implemented pixel-perfect, responsive user interfaces for Android and iOS using Flutter and FlutterFlow, authoring custom interactive widgets for complex UI workflows.</li>
          <li><strong>API & State Management:</strong> Integrated secure RESTful API communication, structured centralized state handling, and engineered reliable offline caching mechanisms.</li>
          <li><strong>Performance Optimization & Maintenance:</strong> Conducted routine memory profiling, resolved layout jank, updated deprecated dependencies, and ensured continuous platform compatibility.</li>
          <li><strong>Team Mentorship:</strong> Mentored junior mobile developers on Dart conventions, effective widget tree decomposition, and collaborative Git branching workflows.</li>
        </ul>
      </div>

    </section>

    <!-- FOOTER PAGE 1 -->
    <footer class="cv-footer">
      <span>Dhruvi Patel • Senior Software Engineer / Senior Flutter Developer</span>
      <span>Surat, India • +91 9925589405 • dhruvi39604@gmail.com</span>
      <span>Page 1 of 2</span>
    </footer>

  </div>

  <!-- ==================== PAGE 2 ==================== -->
  <div class="page page-break">
    
    <!-- PRIOR EXPERIENCE CONTINUED -->
    <section class="section">
      <div class="section-title">
        <svg viewBox="0 0 24 24"><path d="M20 6h-4V4c0-1.11-.89-2-2-2h-4c-1.11 0-2 .89-2 2v2H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-6 0h-4V4h4v2z"/></svg>
        Professional Experience (Continued)
      </div>

      <!-- White Orange Software - Developer -->
      <div class="entry">
        <div class="entry-header">
          <div>
            <span class="entry-title">White Orange Software</span>
            <span style="color:#64748b;"> • Surat, India</span>
          </div>
          <span class="entry-meta">June 2022 – May 2024</span>
        </div>
        <div class="entry-sub">
          <span class="entry-role">Mobile App Developer</span>
          <span>Full-time</span>
        </div>
        <div class="tech-stack-line">
          <span class="tech-label">Technologies:</span> Flutter, Dart, REST APIs, Firebase, Android SDK, iOS Xcode, Git
        </div>
        <ul class="bullet-list">
          <li><strong>Production App Development:</strong> Developed and shipped multiple cross-platform mobile apps for Android and iOS, implementing clean UI components and seamless navigation flows.</li>
          <li><strong>System Enhancement:</strong> Analyzed complex software bugs, optimized list rendering performance, and refactored legacy modules to support new client requirements.</li>
          <li><strong>Agile Collaboration:</strong> Partnered closely with backend engineers, UI/UX designers, and QA testers in Agile sprints to meet release deadlines with high software reliability.</li>
        </ul>
      </div>

      <!-- White Orange Software - Intern -->
      <div class="entry">
        <div class="entry-header">
          <div>
            <span class="entry-title">White Orange Software</span>
            <span style="color:#64748b;"> • Surat, India</span>
          </div>
          <span class="entry-meta">January 2022 – May 2022</span>
        </div>
        <div class="entry-sub">
          <span class="entry-role">Intern, Android Developer</span>
          <span>Internship</span>
        </div>
        <div class="tech-stack-line">
          <span class="tech-label">Technologies:</span> Android Studio, Java, Kotlin, Firebase, Third-Party SDKs, Profiling
        </div>
        <ul class="bullet-list">
          <li><strong>Enterprise HR Application:</strong> Built an Android mobile application for industry HR departments to manage employee profiles, salary records, attendance, and real-time messaging between HR and employees.</li>
          <li><strong>Native Integration:</strong> Integrated Firebase Realtime Database and third-party communication SDKs; performed manual and automated test execution across diverse physical Android devices.</li>
        </ul>
      </div>
    </section>

    <!-- KEY FEATURED PROJECTS -->
    <section class="section">
      <div class="section-title">
        <svg viewBox="0 0 24 24"><path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H8V4h12v12z"/></svg>
        Featured Production Projects
      </div>

      <!-- Pandit Near Me -->
      <div class="entry">
        <div class="entry-header">
          <div>
            <span class="entry-title">Pandit Near Me</span>
            <span style="color:#64748b;"> • Dual-Sided On-Demand Marketplace (Android & iOS)</span>
          </div>
          <span class="entry-meta">50+ App Releases</span>
        </div>
        <div class="entry-sub">
          <span class="entry-role">Lead / Mobile Software Engineer (Built from Scratch)</span>
          <span>May 2025 – Present</span>
        </div>
        <div class="tech-stack-line">
          <span class="tech-label">Stack:</span> Flutter, Dart, GetX, Dio, AWS IoT Core (MQTT), FCM, Crashlytics, Cloudflare Turnstile, Google Places, Hive, Mocktail
        </div>
        <ul class="bullet-list">
          <li>Architected and developed a dual-sided marketplace app from scratch for users, Pandits, and Astrologers with dynamic puja bookings, wallet discounts, multilingual support (EN, HI, GU), and Aadhaar KYC verification.</li>
          <li>Engineered real-time dispatch via <strong>AWS IoT Core (MQTT)</strong> and FCM with custom sound/vibration alerts, AppLinks deep-linking with auth-gated intent preservation, and Google Play In-App Updates.</li>
          <li>Built Kundali and Kundali Matching engine featuring dynamic planetary data, custom geometric horoscope charts rendered via <strong>CustomPainter</strong>, Gun Milan scores, and PDF generation.</li>
        </ul>
      </div>

      <!-- PMP CSV Validator -->
      <div class="entry">
        <div class="entry-header">
          <div>
            <span class="entry-title">PMP CSV Validator & Preview Tool</span>
            <span style="color:#64748b;"> • Dataset QA & Mobile Simulation Suite</span>
          </div>
          <span class="entry-meta">Flutter Web</span>
        </div>
        <div class="entry-sub">
          <span class="entry-role">Lead Flutter Web Engineer</span>
          <span>Platform: Web</span>
        </div>
        <div class="tech-stack-line">
          <span class="tech-label">Stack:</span> Flutter Web, Dart, Python, AST Engine, HTML5 BroadcastChannel, flutter_math_fork, Widget Testing
        </div>
        <ul class="bullet-list">
          <li>Developed a responsive browser-based dataset validation and auto-repair suite automating QA for multi-thousand question exam banks with full Unicode support (Gujarati, Hindi, Sanskrit, special characters).</li>
          <li>Engineered a 20-rule AST parser repairing unclosed tags, orphan tables/lists, and encoding artifacts without data loss; implemented an interactive multi-device mobile simulator with TRAIN/FLIP cards and side-by-side Cell Inspector.</li>
        </ul>
      </div>

      <!-- Additional Flagship Projects Grid -->
      <div class="entry">
        <div class="entry-header">
          <div>
            <span class="entry-title">Additional Flagship & Commercial Applications</span>
          </div>
          <span class="entry-meta">Published Apps</span>
        </div>
        <ul class="bullet-list">
          <li><strong>PMP Exam Prep App (EdTech):</strong> Comprehensive certification exam simulator with interactive quizzes, timed mock tests, question bookmarking, answer explanations, attempt analytics, AdMob ads, and referral deep linking.</li>
          <li><strong>The Healthi Indian (Health & Nutrition):</strong> High-traffic lifestyle app published on <strong>Google Play & App Store</strong> featuring personalized nutrition logs, recipe discovery, meal planning, and in-app subscription paywalls.</li>
          <li><strong>Enterprise & Client Apps:</strong> Shipped <strong>Lighthouse Canton (LC Banker)</strong> (private wealth management for high-net-worth clients), <strong>Radio Spice</strong> (live streaming audio app), <strong>Fine Away</strong> (traffic fine resolution), and <strong>AV Social</strong>.</li>
        </ul>
      </div>
    </section>

    <!-- EDUCATION -->
    <section class="section">
      <div class="section-title">
        <svg viewBox="0 0 24 24"><path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/></svg>
        Education
      </div>
      <div class="edu-grid">
        <div class="edu-card">
          <div class="edu-degree">Master of Computer Applications (MCA)</div>
          <div class="edu-inst">Sarvajanik College of Engineering & Technology (G.T.U.)</div>
          <div class="edu-dates">Dec 2020 – May 2022 • Surat, India</div>
          <div class="edu-grade">Distinction (CGPA: 7.61)</div>
        </div>
        <div class="edu-card">
          <div class="edu-degree">Bachelor of Computer Applications (BCA)</div>
          <div class="edu-inst">Vivekanand College for Advance Computer & Info. Science (V.N.S.G.U.)</div>
          <div class="edu-dates">Jun 2017 – Mar 2020 • Surat, India</div>
          <div class="edu-grade">Distinction (CGPA: 7.39)</div>
        </div>
      </div>
    </section>

    <!-- AWARDS & HONORS -->
    <section class="section" style="margin-bottom: 0;">
      <div class="section-title">
        <svg viewBox="0 0 24 24"><path d="M19 5h-2V3H7v2H5c-1.1 0-2 .9-2 2v1c0 2.55 1.92 4.63 4.39 4.94A5.01 5.01 0 0 0 11 15.9V19H7v2h10v-2h-4v-3.1a5.01 5.01 0 0 0 3.61-4.96C19.08 10.63 21 8.55 21 8V7c0-1.1-.9-2-2-2zM5 8V7h2v3.82C5.84 10.4 5 9.3 5 8zm14 0c0 1.3-.84 2.4-2 2.82V7h2v1z"/></svg>
        Honors & Awards
      </div>
      <div style="font-size: 8.4pt; color: #334155;">
        <strong>🏆 Code Craft Excellence Award (2025)</strong> – Logixbuilt Infotech: Awarded in recognition of exceptional code craftsmanship, modular architecture design, and outstanding engineering delivery across cross-platform mobile and web products.
      </div>
    </section>

    <!-- FOOTER -->
    <footer class="cv-footer">
      <span>Dhruvi Patel • Senior Software Engineer / Senior Flutter Developer</span>
      <span>Surat, India • +91 9925589405 • dhruvi39604@gmail.com</span>
      <span>Page 2 of 2</span>
    </footer>

  </div>

</body>
</html>
"""


def find_browser():
    """Find Microsoft Edge or Google Chrome executable."""
    candidates = [
        r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
        r"C:\Program Files\Microsoft\Edge\Application\msedge.exe",
        r"C:\Program Files\Google\Chrome\Application\chrome.exe",
        r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    ]
    for c in candidates:
        if os.path.exists(c):
            return c
    return None


def main():
    browser = find_browser()
    if not browser:
        print("ERROR: Neither Microsoft Edge nor Google Chrome was found.")
        sys.exit(1)

    print(f"Using browser: {browser}")

    # Write HTML file
    TEMP_HTML.parent.mkdir(parents=True, exist_ok=True)
    with open(TEMP_HTML, "w", encoding="utf-8") as f:
        f.write(HTML_CONTENT)
    print(f"Wrote HTML template to {TEMP_HTML}")

    # Ensure output directories exist
    OUTPUT_PDF_DOCS.parent.mkdir(parents=True, exist_ok=True)

    file_uri = f"file:///{str(TEMP_HTML).replace(os.sep, '/')}"
    out_path_str = str(OUTPUT_PDF_DOCS)

    # Use PowerShell Start-Process to reliably invoke headless browser
    ps_cmd = (
        f'Start-Process -FilePath "{browser}" '
        f'-ArgumentList "--headless=new --disable-gpu --print-to-pdf=`"{out_path_str}`" --no-pdf-header-footer `"{file_uri}`"" '
        f"-Wait"
    )

    print(f"Generating PDF: {out_path_str} ...")
    result = subprocess.run(["powershell", "-NoProfile", "-Command", ps_cmd], capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error generating PDF: {result.stderr}")
        sys.exit(result.returncode)

    if not OUTPUT_PDF_DOCS.exists():
        print(f"ERROR: Expected PDF was not generated at {OUTPUT_PDF_DOCS}")
        sys.exit(1)

    # Copy to default resume.pdf and standard distribution locations
    targets = [
        OUTPUT_PDF_DEFAULT,
        WORKSPACE_ROOT / "Dhruvi_Patel_CV.pdf",
        WORKSPACE_ROOT / "assets" / "docs" / "Dhruvi_Patel_Senior_Flutter_Developer_CV.pdf",
        WORKSPACE_ROOT / "build" / "flutter_assets" / "assets" / "docs" / "resume.pdf",
        WORKSPACE_ROOT / "build" / "web" / "assets" / "assets" / "docs" / "resume.pdf",
    ]

    pdf_data = OUTPUT_PDF_DOCS.read_bytes()
    for target in targets:
        try:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(pdf_data)
            print(f"SUCCESS: Copied to {target}")
        except Exception as e:
            print(f"Note: Could not copy to {target}: {e}")

    print(f"SUCCESS: Generated CV at {OUTPUT_PDF_DOCS} ({OUTPUT_PDF_DOCS.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
