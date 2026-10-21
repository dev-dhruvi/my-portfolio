"""
Generates TWO high-quality, ATS-optimized PDF CVs for Dhruvi Patel:
1. 1-Page Executive CV:
   - File: assets/docs/Dhruvi_Patel_Senior_Flutter_Developer_1Page_CV.pdf (and assets/docs/resume.pdf)
   - Role: Senior Flutter Developer
   - Sized perfectly to fit strictly on 1 page with no overflow.
2. Complete Comprehensive CV (Jan 2022 to Present):
   - File: assets/docs/Dhruvi_Patel_Senior_Flutter_Developer_Complete_CV.pdf (and root Dhruvi_Patel_Senior_Flutter_Developer_Complete_CV.pdf)
   - Role: Senior Flutter Developer
   - Full work experience from Jan 2022 to present, with all 19 projects in detail with live store links.
"""

import os
import subprocess
import sys
from pathlib import Path
from pypdf import PdfReader

WORKSPACE_ROOT = Path(__file__).resolve().parent.parent

# Output paths for 1-Page CV
PDF_1PAGE_DOCS = WORKSPACE_ROOT / "assets" / "docs" / "Dhruvi_Patel_Senior_Flutter_Developer_1Page_CV.pdf"
PDF_1PAGE_ROOT = WORKSPACE_ROOT / "Dhruvi_Patel_Senior_Flutter_Developer_1Page_CV.pdf"
PDF_DEFAULT_RESUME = WORKSPACE_ROOT / "assets" / "docs" / "resume.pdf"
HTML_1PAGE = WORKSPACE_ROOT / "scripts" / "cv_1page_template.html"

# Output paths for Complete Detailed CV
PDF_COMPLETE_DOCS = WORKSPACE_ROOT / "assets" / "docs" / "Dhruvi_Patel_Senior_Flutter_Developer_Complete_CV.pdf"
PDF_COMPLETE_ROOT = WORKSPACE_ROOT / "Dhruvi_Patel_Senior_Flutter_Developer_Complete_CV.pdf"
HTML_COMPLETE = WORKSPACE_ROOT / "scripts" / "cv_complete_template.html"


def find_browser():
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


# =========================================================================
# 1-PAGE CV TEMPLATE
# =========================================================================
HTML_1PAGE_CONTENT = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Dhruvi Patel - Senior Flutter Developer CV</title>
  <style>
    @page {
      size: A4;
      margin: 8mm 10mm 8mm 10mm;
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
      font-size: 8.1pt;
      line-height: 1.28;
      -webkit-font-smoothing: antialiased;
    }
    a {
      color: #1d4ed8;
      text-decoration: none;
    }
    .header {
      border-bottom: 2px solid #2563eb;
      padding-bottom: 4px;
      margin-bottom: 6px;
    }
    .name-title-row {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
    }
    .candidate-name {
      font-size: 18pt;
      font-weight: 800;
      color: #0f172a;
      line-height: 1;
    }
    .candidate-title {
      font-size: 10.5pt;
      font-weight: 700;
      color: #2563eb;
    }
    .contact-bar {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      font-size: 7.9pt;
      color: #475569;
      margin-top: 3px;
    }
    .contact-item {
      display: inline-flex;
      align-items: center;
      gap: 3px;
    }
    .contact-item svg {
      width: 10px;
      height: 10px;
      fill: #2563eb;
      flex-shrink: 0;
    }
    .section {
      margin-bottom: 6px;
    }
    .section-title {
      font-size: 8.8pt;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: #0f172a;
      border-bottom: 1px solid #cbd5e1;
      padding-bottom: 1.5px;
      margin-bottom: 4px;
      display: flex;
      align-items: center;
      gap: 4px;
    }
    .section-title svg {
      width: 10px;
      height: 10px;
      fill: #2563eb;
    }
    .summary-text {
      font-size: 8pt;
      color: #334155;
      text-align: justify;
      line-height: 1.3;
    }
    .skills-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 7.7pt;
    }
    .skills-table td {
      padding: 1.2px 0;
      vertical-align: top;
    }
    .skill-cat {
      width: 24%;
      font-weight: 700;
      color: #0f172a;
      white-space: nowrap;
    }
    .skill-val {
      width: 76%;
      color: #334155;
    }
    .entry {
      margin-bottom: 4.5px;
    }
    .entry-header {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
    }
    .entry-title {
      font-size: 8.4pt;
      font-weight: 700;
      color: #0f172a;
    }
    .entry-role {
      font-weight: 600;
      color: #2563eb;
      font-size: 7.9pt;
    }
    .entry-meta {
      font-size: 7.4pt;
      font-weight: 600;
      color: #64748b;
      white-space: nowrap;
    }
    .award-pill {
      display: inline-block;
      background: #fef3c7;
      border: 1px solid #f59e0b;
      color: #92400e;
      font-weight: 700;
      font-size: 7.2pt;
      padding: 0.5px 5px;
      border-radius: 3px;
    }
    ul.bullet-list {
      margin-left: 12px;
      padding-left: 0;
      list-style-type: disc;
    }
    ul.bullet-list li {
      font-size: 7.6pt;
      color: #334155;
      margin-bottom: 1.2px;
      line-height: 1.26;
      text-align: justify;
    }
    ul.bullet-list li strong {
      color: #0f172a;
    }
    .edu-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 8px;
    }
    .edu-card {
      border-left: 2px solid #2563eb;
      padding-left: 6px;
    }
    .edu-degree {
      font-size: 8pt;
      font-weight: 700;
      color: #0f172a;
    }
    .edu-inst {
      font-size: 7.3pt;
      color: #475569;
    }
    .edu-grade {
      font-size: 7.3pt;
      font-weight: 700;
      color: #166534;
    }
  </style>
</head>
<body>

  <!-- HEADER -->
  <header class="header">
    <div class="name-title-row">
      <h1 class="candidate-name">Dhruvi Patel</h1>
      <div class="candidate-title">• Senior Flutter Developer</div>
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
        <a href="https://www.linkedin.com/in/duvi03" target="_blank">linkedin.com/in/duvi03</a>
      </span>
      <span class="contact-item">
        <svg viewBox="0 0 24 24"><path d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34-.46-1.16-1.11-1.47-1.11-1.47-.91-.62.07-.6.07-.6 1 .07 1.53 1.03 1.53 1.03.87 1.52 2.34 1.07 2.91.83.1-.65.35-1.09.63-1.34-2.22-.25-4.55-1.11-4.55-4.92 0-1.11.38-2 1.03-2.71-.1-.25-.45-1.29.1-2.64 0 0 .84-.27 2.75 1.02.79-.22 1.65-.33 2.5-.33.85 0 1.71.11 2.5.33 1.91-1.29 2.75-1.02 2.75-1.02.55 1.35.2 2.39.1 2.64.65.71 1.03 1.6 1.03 2.71 0 3.82-2.34 4.66-4.57 4.91.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2z"/></svg>
        <a href="https://github.com/dhruvi-mobiledev" target="_blank">github.com/dhruvi-mobiledev</a>
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
      <strong>Senior Flutter Developer</strong> with <strong>4+ years</strong> of hands-on experience engineering, optimizing, and deploying high-performance cross-platform mobile (Android & iOS) and web applications. Recipient of the <strong>Code Craft Excellence Award (2025)</strong> for clean modular architecture and engineering leadership. Expertise across Flutter, Dart, GetX, Clean Architecture, REST APIs with Dio, Firebase, and real-time bidirectional communication via <strong>AWS IoT Core (MQTT)</strong>. Proven record driving 50+ production releases, building automated test suites (Unit, Widget, Integration), and delivering scalable on-demand marketplace and enterprise software.
    </p>
  </section>

  <!-- TECHNICAL SKILLS -->
  <section class="section">
    <div class="section-title">
      <svg viewBox="0 0 24 24"><path d="M22.7 19l-9.1-9.1c.9-2.3.4-5-1.5-6.9-2-2-5-2.4-7.4-1.3L9 6 6 9 1.6 4.7C.4 7.1.9 10.1 2.9 12.1c1.9 1.9 4.6 2.4 6.9 1.5l9.1 9.1c.4.4 1 .4 1.4 0l2.3-2.3c.5-.4.5-1.1.1-1.4z"/></svg>
      Technical Competencies
    </div>
    <table class="skills-table">
      <tr>
        <td class="skill-cat">Languages & Frameworks:</td>
        <td class="skill-val"><strong>Flutter (Mobile & Web)</strong>, <strong>Dart</strong>, FlutterFlow, Java, Kotlin, Python, HTML5, CSS3, JavaScript</td>
      </tr>
      <tr>
        <td class="skill-cat">Architecture & State:</td>
        <td class="skill-val"><strong>Clean & Modular Architecture</strong>, <strong>GetX State Management</strong>, BLoC Pattern, Repository Pattern, Dependency Injection</td>
      </tr>
      <tr>
        <td class="skill-cat">Cloud & Real-Time Backend:</td>
        <td class="skill-val"><strong>AWS IoT Core (MQTT over WebSockets)</strong>, Firebase (FCM, Firestore, Auth, Crashlytics, Remote Config), Dio, REST APIs, JWT</td>
      </tr>
      <tr>
        <td class="skill-cat">Storage & Testing:</td>
        <td class="skill-val">Hive DB, Flutter Secure Storage, SharedPreferences, SQLite, <strong>Mocktail</strong>, Unit/Widget/Integration Testing, DevTools Profiling</td>
      </tr>
      <tr>
        <td class="skill-cat">Tooling & Integrations:</td>
        <td class="skill-val">Git, GitHub Actions, Google Play Console, App Store Connect, Google Places API, Cloudflare Turnstile, CustomPainter, StoreKit/In-App Purchases</td>
      </tr>
    </table>
  </section>

  <!-- WORK EXPERIENCE -->
  <section class="section">
    <div class="section-title">
      <svg viewBox="0 0 24 24"><path d="M20 6h-4V4c0-1.11-.89-2-2-2h-4c-1.11 0-2 .89-2 2v2H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-6 0h-4V4h4v2z"/></svg>
      Work Experience
    </div>

    <!-- Logix Built -->
    <div class="entry">
      <div class="entry-header">
        <div>
          <span class="entry-title">Logix Built Solutions Limited</span>
          <span class="entry-role"> — Senior Software Engineer | Flutter Developer</span>
          <span class="award-pill">🏆 Code Craft Excellence Award 2025</span>
        </div>
        <span class="entry-meta">May 2025 – Present | Surat, India</span>
      </div>
      <ul class="bullet-list">
        <li><strong>Architecture & Real-Time Dispatch:</strong> Architected dual-sided on-demand marketplace app from scratch using Flutter, Dart, and GetX under Clean Modular Architecture; built low-latency real-time dispatch via <strong>AWS IoT Core (MQTT over WSS)</strong> and FCM with custom sound/vibration alerts.</li>
        <li><strong>Resilient Network Layer:</strong> Implemented Dio HTTP client with exponential backoff and a thread-safe <strong>Single-Flight Lock (Completer)</strong> eliminating token-refresh race conditions.</li>
        <li><strong>Web QA Automation & Releases:</strong> Built Flutter Web dataset validation tool with a 20-rule AST parser, auto-fixing malformed HTML without data loss; managed <strong>50+ production releases</strong> across Google Play and Apple App Store with In-App Updates and Remote Config.</li>
        <li><strong>Automated Testing:</strong> Authored Unit, Widget, and Integration tests using <strong>Mocktail</strong> ensuring zero regressions across critical flows.</li>
      </ul>
    </div>

    <!-- DinJan Infotech -->
    <div class="entry">
      <div class="entry-header">
        <div>
          <span class="entry-title">DinJan Infotech Pvt. Ltd.</span>
          <span class="entry-role"> — Flutter Developer</span>
        </div>
        <span class="entry-meta">June 2024 – April 2025 | Surat, India</span>
      </div>
      <ul class="bullet-list">
        <li>Designed and developed cross-platform applications for Android and iOS using Flutter and FlutterFlow with custom interactive widgets.</li>
        <li>Integrated secure REST APIs, centralized state handling via GetX, optimized memory/rendering performance, and mentored junior developers.</li>
      </ul>
    </div>

    <!-- White Orange Software -->
    <div class="entry">
      <div class="entry-header">
        <div>
          <span class="entry-title">White Orange Software</span>
          <span class="entry-role"> — Mobile App Developer & Intern</span>
        </div>
        <span class="entry-meta">Jan 2022 – May 2024 | Surat, India</span>
      </div>
      <ul class="bullet-list">
        <li>Built, optimized, and deployed scalable mobile apps using Flutter, Dart, and Android Native (Java/Kotlin); engineered enterprise HR app with real-time chat.</li>
      </ul>
    </div>
  </section>

  <!-- KEY FEATURED PROJECTS (FLAGSHIP) -->
  <section class="section">
    <div class="section-title">
      <svg viewBox="0 0 24 24"><path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H8V4h12v12z"/></svg>
      Key Commercial Projects & Live Store Links
    </div>

    <div class="entry">
      <div class="entry-header">
        <div>
          <span class="entry-title">Pandit Near Me</span>
          <span style="font-size:7.4pt; color:#64748b;">(Logix Built Solutions Limited | 50+ Releases)</span>
        </div>
        <span class="entry-meta">
          <a href="https://play.google.com/store/apps/details?id=com.officialpanditsnearme&hl=en" target="_blank">[Google Play]</a> •
          <a href="https://apps.apple.com/in/app/pandits-near-me-instant-puja/id6757301105" target="_blank">[App Store]</a>
        </span>
      </div>
      <ul class="bullet-list">
        <li>Dual-sided on-demand spiritual services marketplace (Users, Pandits, Astrologers); integrated AWS IoT Core MQTT dispatch, Aadhaar KYC verification, and Kundali matching with custom geometric horoscope charts rendered via <strong>CustomPainter</strong> and PDF export.</li>
      </ul>
    </div>

    <div class="entry">
      <div class="entry-header">
        <div>
          <span class="entry-title">PMP CSV Validator & Preview Tool</span>
          <span style="font-size:7.4pt; color:#64748b;">(Logix Built Solutions Limited | Flutter Web)</span>
        </div>
        <span class="entry-meta">Flutter Web QA Suite</span>
      </div>
      <ul class="bullet-list">
        <li>Engineered a responsive dataset QA platform with a 20-rule AST parser repairing malformed HTML tags/tables, LaTeX rendering via <strong>flutter_math_fork</strong>, and live multi-device simulation via HTML5 BroadcastChannel API.</li>
      </ul>
    </div>

    <div class="entry">
      <div class="entry-header">
        <div>
          <span class="entry-title">Published Consumer & Enterprise Apps</span>
          <span style="font-size:7.4pt; color:#64748b;">(DinJan Infotech & White Orange Software)</span>
        </div>
        <span class="entry-meta">Live on App Store & Google Play</span>
      </div>
      <ul class="bullet-list">
        <li><strong>The Healthi Indian</strong> (<a href="https://play.google.com/store/apps/details?id=com.app.thehealthiindian&pli=1" target="_blank">Play Store</a> | <a href="https://apps.apple.com/us/app/the-healthi-indian/id6738694566" target="_blank">App Store</a>): Nutrition & recipe app with GetX and offline caching.</li>
        <li><strong>FineAway</strong> (<a href="https://play.google.com/store/apps/details?id=com.app.fineaway&pcampaignid=web_share" target="_blank">Play Store</a> | <a href="https://apps.apple.com/us/app/fineaway-app/id6467185920" target="_blank">App Store</a>): Traffic fine resolution with OCR camera scanning.</li>
        <li><strong>Radio Spice</strong> (<a href="https://play.google.com/store/apps/details?id=com.app.audio_app&pcampaignid=web_share&pli=1" target="_blank">Play Store</a> | <a href="https://apps.apple.com/in/app/radio-spice-nzpmt/id6737826716" target="_blank">App Store</a>), <strong>Agents Thrive</strong> (<a href="https://apps.apple.com/us/app/agent-thrive-app/id6467190612" target="_blank">App Store</a>), <strong>Muvr</strong> (<a href="https://apps.apple.com/us/app/muvr-get-furniture-delivery/id6450030781" target="_blank">App Store</a>).</li>
      </ul>
    </div>
  </section>

  <!-- EDUCATION & HONORS -->
  <section class="section">
    <div class="section-title">
      <svg viewBox="0 0 24 24"><path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/></svg>
      Education & Honors
    </div>
    <div class="edu-grid">
      <div class="edu-card">
        <div class="edu-degree">Master of Computer Applications (MCA) — CGPA: 7.61 (Distinction)</div>
        <div class="edu-inst">Sarvajanik College of Eng. & Tech., GTU • 2020 – 2022</div>
      </div>
      <div class="edu-card">
        <div class="edu-degree">Bachelor of Computer Applications (BCA) — CGPA: 7.39 (Distinction)</div>
        <div class="edu-inst">Vivekanand College for Advance Computer & Info. Sci., VNSGU • 2017 – 2020</div>
      </div>
    </div>
  </section>

</body>
</html>
"""


# =========================================================================
# COMPLETE DETAILED CV TEMPLATE (Jan 2022 - Present)
# =========================================================================
HTML_COMPLETE_CONTENT = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Dhruvi Patel - Senior Flutter Developer Complete Experience CV</title>
  <style>
    @page {
      size: A4;
      margin: 9mm 11mm 9mm 11mm;
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
      font-size: 8.5pt;
      line-height: 1.32;
      -webkit-font-smoothing: antialiased;
    }
    a {
      color: #1d4ed8;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
    .page-break {
      page-break-before: always;
      padding-top: 3mm;
    }
    .header {
      border-bottom: 2px solid #2563eb;
      padding-bottom: 5px;
      margin-bottom: 7px;
    }
    .name-title-row {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
    }
    .candidate-name {
      font-size: 19pt;
      font-weight: 800;
      color: #0f172a;
      line-height: 1;
    }
    .candidate-title {
      font-size: 11pt;
      font-weight: 700;
      color: #2563eb;
    }
    .contact-bar {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      font-size: 8pt;
      color: #475569;
      margin-top: 3.5px;
    }
    .contact-item {
      display: inline-flex;
      align-items: center;
      gap: 3px;
    }
    .contact-item svg {
      width: 10px;
      height: 10px;
      fill: #2563eb;
      flex-shrink: 0;
    }
    .section {
      margin-bottom: 7px;
    }
    .section-title {
      font-size: 9.2pt;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: #0f172a;
      border-bottom: 1px solid #cbd5e1;
      padding-bottom: 1.5px;
      margin-bottom: 5px;
      display: flex;
      align-items: center;
      gap: 5px;
    }
    .section-title svg {
      width: 11px;
      height: 11px;
      fill: #2563eb;
    }
    .company-subheading {
      font-size: 8.8pt;
      font-weight: 800;
      color: #0f172a;
      background: #f1f5f9;
      padding: 3px 6px;
      border-left: 3px solid #2563eb;
      margin-top: 6px;
      margin-bottom: 4px;
      display: flex;
      justify-content: space-between;
    }
    .summary-text {
      font-size: 8.3pt;
      color: #334155;
      text-align: justify;
      line-height: 1.34;
    }
    .skills-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 8pt;
    }
    .skills-table td {
      padding: 1.8px 0;
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
    .entry {
      margin-bottom: 6px;
      page-break-inside: avoid;
    }
    .entry-header {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      margin-bottom: 1px;
    }
    .entry-title {
      font-size: 8.8pt;
      font-weight: 700;
      color: #0f172a;
    }
    .entry-role {
      font-weight: 600;
      color: #2563eb;
      font-size: 8.2pt;
    }
    .entry-meta {
      font-size: 7.7pt;
      font-weight: 600;
      color: #64748b;
      white-space: nowrap;
    }
    .entry-tech {
      font-size: 7.6pt;
      color: #475569;
      margin-bottom: 2px;
    }
    .award-pill {
      display: inline-block;
      background: #fef3c7;
      border: 1px solid #f59e0b;
      color: #92400e;
      font-weight: 700;
      font-size: 7.4pt;
      padding: 0.5px 5px;
      border-radius: 3px;
    }
    ul.bullet-list {
      margin-left: 13px;
      padding-left: 0;
      list-style-type: disc;
    }
    ul.bullet-list li {
      font-size: 8pt;
      color: #334155;
      margin-bottom: 1.8px;
      line-height: 1.28;
      text-align: justify;
    }
    ul.bullet-list li strong {
      color: #0f172a;
    }
    .edu-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
    }
    .edu-card {
      border-left: 2px solid #2563eb;
      padding-left: 8px;
    }
    .edu-degree {
      font-size: 8.4pt;
      font-weight: 700;
      color: #0f172a;
    }
    .edu-inst {
      font-size: 7.7pt;
      color: #475569;
    }
    .edu-grade {
      font-size: 7.7pt;
      font-weight: 700;
      color: #166534;
    }
    .cv-footer {
      border-top: 1px solid #e2e8f0;
      padding-top: 3px;
      margin-top: 6px;
      display: flex;
      justify-content: space-between;
      font-size: 7pt;
      color: #94a3b8;
    }
  </style>
</head>
<body>

  <!-- ================= PAGE 1 ================= -->
  <header class="header">
    <div class="name-title-row">
      <h1 class="candidate-name">Dhruvi Patel</h1>
      <div class="candidate-title">• Senior Flutter Developer</div>
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
        <a href="https://www.linkedin.com/in/duvi03" target="_blank">linkedin.com/in/duvi03</a>
      </span>
      <span class="contact-item">
        <svg viewBox="0 0 24 24"><path d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34-.46-1.16-1.11-1.47-1.11-1.47-.91-.62.07-.6.07-.6 1 .07 1.53 1.03 1.53 1.03.87 1.52 2.34 1.07 2.91.83.1-.65.35-1.09.63-1.34-2.22-.25-4.55-1.11-4.55-4.92 0-1.11.38-2 1.03-2.71-.1-.25-.45-1.29.1-2.64 0 0 .84-.27 2.75 1.02.79-.22 1.65-.33 2.5-.33.85 0 1.71.11 2.5.33 1.91-1.29 2.75-1.02 2.75-1.02.55 1.35.2 2.39.1 2.64.65.71 1.03 1.6 1.03 2.71 0 3.82-2.34 4.66-4.57 4.91.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2z"/></svg>
        <a href="https://github.com/dhruvi-mobiledev" target="_blank">github.com/dhruvi-mobiledev</a>
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
      <strong>Senior Flutter Developer</strong> with <strong>4+ years</strong> of hands-on experience building, optimizing, and deploying high-performance cross-platform mobile applications for Android and iOS, alongside enterprise Flutter Web platforms. Honored with the <strong>Code Craft Excellence Award (2025)</strong> from Logix Built Solutions Limited for clean modular architecture design, code craftsmanship, and engineering delivery. Deep expertise in Flutter, Dart, GetX, Clean Architecture, REST APIs with Dio, Firebase, and real-time bidirectional communication via <strong>AWS IoT Core (MQTT over WebSockets)</strong>. Proven track record leading dual-sided on-demand product engineering from scratch, managing <strong>50+ production releases</strong>, designing zero-downtime update engines, and authoring automated test suites (Unit, Widget, Integration) ensuring zero regression.
    </p>
  </section>

  <!-- TECHNICAL COMPETENCIES -->
  <section class="section">
    <div class="section-title">
      <svg viewBox="0 0 24 24"><path d="M22.7 19l-9.1-9.1c.9-2.3.4-5-1.5-6.9-2-2-5-2.4-7.4-1.3L9 6 6 9 1.6 4.7C.4 7.1.9 10.1 2.9 12.1c1.9 1.9 4.6 2.4 6.9 1.5l9.1 9.1c.4.4 1 .4 1.4 0l2.3-2.3c.5-.4.5-1.1.1-1.4z"/></svg>
      Technical Competencies
    </div>
    <table class="skills-table">
      <tr>
        <td class="skill-cat">Languages & Frameworks:</td>
        <td class="skill-val"><strong>Flutter (Mobile iOS & Android, Flutter Web)</strong>, <strong>Dart</strong>, FlutterFlow, Java, Kotlin, Python, HTML5, CSS3, JavaScript</td>
      </tr>
      <tr>
        <td class="skill-cat">Architecture & State:</td>
        <td class="skill-val"><strong>Clean Architecture</strong>, <strong>Modular Design</strong>, <strong>GetX State Management</strong>, BLoC Pattern, Repository Pattern, Dependency Injection</td>
      </tr>
      <tr>
        <td class="skill-cat">API & Real-Time Backend:</td>
        <td class="skill-val"><strong>AWS IoT Core (MQTT over WebSockets)</strong>, Firebase Cloud Messaging (FCM), REST APIs, <strong>Dio</strong>, Single-Flight Lock, WebSocket Lifecycle</td>
      </tr>
      <tr>
        <td class="skill-cat">Cloud & Database:</td>
        <td class="skill-val">Firebase (Auth, Firestore, Crashlytics, Remote Config, Analytics, Performance), <strong>Hive DB</strong>, Flutter Secure Storage, SharedPreferences, SQLite</td>
      </tr>
      <tr>
        <td class="skill-cat">Testing & Quality:</td>
        <td class="skill-val"><strong>Mocktail</strong>, Unit Testing, Widget Testing, Flutter Integration Test, Debugging, DevTools Profiling, Code Reviews</td>
      </tr>
      <tr>
        <td class="skill-cat">Tooling & Deployment:</td>
        <td class="skill-val">Git, GitHub Actions, Google Play Console, Apple App Store Connect, Android Studio, Xcode, VS Code, Postman</td>
      </tr>
      <tr>
        <td class="skill-cat">Specialized Integrations:</td>
        <td class="skill-val">Google Places API, Cloudflare Turnstile, In-App Review, In-App Purchases (StoreKit / RevenueCat), CustomPainter, flutter_math_fork</td>
      </tr>
    </table>
  </section>

  <!-- PROFESSIONAL WORK EXPERIENCE -->
  <section class="section">
    <div class="section-title">
      <svg viewBox="0 0 24 24"><path d="M20 6h-4V4c0-1.11-.89-2-2-2h-4c-1.11 0-2 .89-2 2v2H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-6 0h-4V4h4v2z"/></svg>
      Professional Experience (Jan 2022 – Present)
    </div>

    <!-- Role 1: Logix Built -->
    <div class="entry">
      <div class="entry-header">
        <div>
          <span class="entry-title">Logix Built Solutions Limited</span>
          <span class="entry-role"> — Senior Software Engineer | Flutter Developer</span>
          <span class="award-pill">🏆 Code Craft Excellence Award (2025)</span>
        </div>
        <span class="entry-meta">May 2025 – Present | Surat, India</span>
      </div>
      <ul class="bullet-list">
        <li><strong>Architecture & Real-Time Engine:</strong> Architected dual-sided on-demand mobile applications and web QA platforms from scratch using Flutter, Dart, and GetX under Clean Modular Architecture, supporting <strong>50+ production releases</strong> on Android & iOS. Built low-latency dispatch via <strong>AWS IoT Core (MQTT over WebSockets)</strong> and FCM with custom sound/vibration alerts.</li>
        <li><strong>Resilient Network Layer:</strong> Engineered Dio HTTP client with exponential backoff retries and a thread-safe <strong>Single-Flight Lock (Completer)</strong> that completely resolved token-refresh race conditions in concurrent API requests.</li>
        <li><strong>Web QA Automation Suite:</strong> Engineered a browser-based dataset validation suite in Flutter Web with a 20-rule AST parser, auto-remediating malformed HTML, broken tables/lists, and encoding artifacts for multi-thousand question exam banks.</li>
        <li><strong>Release & Zero-Downtime Engine:</strong> Implemented AppLinks deep-linking with auth-gated intent preservation, Google Play In-App Updates (Immediate & Flexible), and Firebase Remote Config with automated local storage migrations on version bumps.</li>
        <li><strong>Automated Testing:</strong> Authored Unit, Widget, and Integration test suites using <strong>Mocktail</strong> and Flutter Integration Test, achieving high coverage and zero production regressions.</li>
      </ul>
    </div>

    <!-- Role 2: DinJan Infotech -->
    <div class="entry">
      <div class="entry-header">
        <div>
          <span class="entry-title">DinJan Infotech Pvt. Ltd.</span>
          <span class="entry-role"> — Flutter Developer</span>
        </div>
        <span class="entry-meta">June 2024 – April 2025 | Surat, India</span>
      </div>
      <ul class="bullet-list">
        <li>Designed and implemented responsive user interfaces for Android and iOS using Flutter and FlutterFlow, authoring custom interactive widgets.</li>
        <li>Integrated RESTful APIs, managed app state via GetX, optimized offline caching, and resolved complex memory/rendering bottlenecks.</li>
        <li>Mentored junior developers on Dart idioms, clean widget tree decomposition, and Git collaboration workflows.</li>
      </ul>
    </div>

    <!-- Role 3: White Orange Software (Developer & Intern) -->
    <div class="entry">
      <div class="entry-header">
        <div>
          <span class="entry-title">White Orange Software</span>
          <span class="entry-role"> — Mobile App Developer (June 2022 – May 2024) & Intern (Jan 2022 – May 2022)</span>
        </div>
        <span class="entry-meta">Jan 2022 – May 2024 | Surat, India</span>
      </div>
      <ul class="bullet-list">
        <li>Developed, maintained, and shipped cross-platform applications for Android and iOS utilizing Flutter, Dart, REST APIs, and Firebase.</li>
        <li>Built an enterprise Android application (Java/Kotlin) for HR workforce management, salary records, attendance, and real-time messaging.</li>
        <li>Conducted performance profiling, memory leak prevention, and automated testing across diverse physical mobile devices.</li>
      </ul>
    </div>
  </section>

  <!-- ================= PAGE 2 ================= -->
  <div class="page-break"></div>

  <!-- COMPLETE PROJECT PORTFOLIO (19 PROJECTS) -->
  <section class="section">
    <div class="section-title">
      <svg viewBox="0 0 24 24"><path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H8V4h12v12z"/></svg>
      Complete Project Experience (Jan 2022 – Present)
    </div>

    <!-- COMPANY 1: LOGIX BUILT SOLUTIONS LIMITED -->
    <div class="company-subheading">
      <span>LOGIX BUILT SOLUTIONS LIMITED PROJECTS</span>
      <span>May 2025 – Present</span>
    </div>

    <!-- 1. Pandit Near Me -->
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">1. Pandit Near Me — Dual-Sided On-Demand Marketplace (Android & iOS | 50+ Releases)</span>
        <span class="entry-meta">
          <a href="https://play.google.com/store/apps/details?id=com.officialpanditsnearme&hl=en" target="_blank">[Google Play Store]</a> •
          <a href="https://apps.apple.com/in/app/pandits-near-me-instant-puja/id6757301105" target="_blank">[Apple App Store]</a>
        </span>
      </div>
      <div class="entry-tech"><strong>Tech Stack:</strong> Flutter, Dart, GetX, Dio, AWS IoT Core (MQTT), FCM, Google Places API, CustomPainter, Hive, Mocktail</div>
      <ul class="bullet-list">
        <li>Architected dual-sided app from scratch for users, Pandits, and Astrologers with dynamic puja bookings, wallet discounts, multilingual support (EN, HI, GU), and Aadhaar KYC document uploads with verification status.</li>
        <li>Engineered low-latency dispatch via <strong>AWS IoT Core (MQTT over signed WebSockets)</strong> and FCM with custom sound/vibration alerts, AppLinks deep-linking with auth-gated intent preservation, and Google Play In-App Updates.</li>
        <li>Built Kundali and Kundali Matching engine with dynamic planetary data, custom horoscope charts using <strong>CustomPainter</strong>, Gun Milan results, saved records, and PDF download integration.</li>
        <li>Integrated Google Places API autocomplete, location-aware Panchang, Muhurat, Choghadiya, and festival content modules.</li>
      </ul>
    </div>

    <!-- 2. PMP CSV Validator -->
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">2. PMP CSV Validator & Preview Tool — Dataset QA & Mobile Simulation Suite (Flutter Web)</span>
        <span class="entry-meta">Lead Flutter Web Engineer</span>
      </div>
      <div class="entry-tech"><strong>Tech Stack:</strong> Flutter Web, Dart, Python, CSV Parsing, AST Parser Engine, HTML Rendering, flutter_math_fork, Widget Testing</div>
      <ul class="bullet-list">
        <li>Developed a responsive browser-based tool to upload, validate, inspect, auto-correct, and export PMP question datasets with drag-and-drop CSV upload and automatic delimiter/encoding detection (Gujarati, Hindi, Sanskrit Unicode).</li>
        <li>Engineered a 20-rule AST parser repairing unclosed tags, orphan tables/lists, and encoding artifacts without data loss; delivered bulk Auto-Fix functionality.</li>
        <li>Created reusable HTML rendering supporting rich text, nested lists, Base64 images, and LaTeX equations via <strong>flutter_math_fork</strong>, alongside an interactive multi-device simulator with TRAIN/FLIP cards and side-by-side Cell Inspector.</li>
      </ul>
    </div>

    <!-- 3. PMP Exam Prep App -->
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">3. PMP Exam Prep App — Professional Certification Exam Simulator</span>
        <span class="entry-meta">Software Engineer</span>
      </div>
      <div class="entry-tech"><strong>Tech Stack:</strong> Flutter, Dart, GetX, REST APIs, Firebase, Local Storage, AdMob Advertising SDKs, AppLinks Deep Linking</div>
      <ul class="bullet-list">
        <li>Enhanced interactive quiz workflows with timed mock tests, question navigation, answer review, flagged questions, explanations, and attempt analytics.</li>
        <li>Engineered referral deep-link handling for cold-start and resumed sessions, guest vs. premium tiered subscription paywalls, and resolved native AdMob lifecycle and controller leaks.</li>
      </ul>
    </div>

    <!-- 4. Nirvana App -->
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">4. Nirvana App — Real Estate Property Discovery & Dynamic Booking System</span>
        <span class="entry-meta">Software Engineer</span>
      </div>
      <div class="entry-tech"><strong>Tech Stack:</strong> Flutter, Dart, REST APIs, PDF Viewer, Chatbot API, Responsive Tablet & Mobile Layouts</div>
      <ul class="bullet-list">
        <li>Implemented multi-step property purchase flow covering unit selection, real-time availability states, dynamic pricing, purchaser agreements, down-payment calculation, and payment summaries.</li>
        <li>Integrated in-app PDF agreement viewing, terms bottom sheets, and home-screen AI chatbot API; prepared TestFlight and Android staging builds.</li>
      </ul>
    </div>

    <!-- 5, 6, 7. Reutbyitforme, Milos Paddle, Minder -->
    <div class="entry">
      <ul class="bullet-list">
        <li><strong>5. Reutbyitforme App (Framework & Dependency Upgrade):</strong> Upgraded legacy Flutter codebase from 3.10 to 3.32; modernized dependencies (Firebase Messaging, modern flutter_inappwebview with WebUri, Android Gradle 8+, namespace requirements, and external browser link routing).</li>
        <li><strong>6. Milos Paddle App (Multi-Court Sports Booking):</strong> Engineered multi-court and time-slot booking functionality with dynamic pricing calculations, availability validation, and payment API integrations.</li>
        <li><strong>7. Minder App (API Connectivity & Diagnostics):</strong> Conducted deep-dive API diagnostic benchmarking between production and development environments, identifying timeout edge cases and resolving backend integration discrepancies.</li>
      </ul>
    </div>

    <!-- COMPANY 2: DINJAN INFOTECH -->
    <div class="company-subheading">
      <span>DINJAN INFOTECH PVT. LTD. PROJECTS</span>
      <span>June 2024 – April 2025</span>
    </div>

    <!-- 8. The Healthi Indian -->
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">8. The Healthi Indian — Health & Nutrition Platform</span>
        <span class="entry-meta">
          <a href="https://play.google.com/store/apps/details?id=com.app.thehealthiindian&pli=1" target="_blank">[Google Play Store]</a> •
          <a href="https://apps.apple.com/us/app/the-healthi-indian/id6738694566" target="_blank">[Apple App Store]</a>
        </span>
      </div>
      <div class="entry-tech"><strong>Tech Stack:</strong> Flutter, Dart, GetX, REST APIs, SharedPreferences</div>
      <ul class="bullet-list">
        <li>Architected macro-balanced vegetarian and vegan recipe platform; refactored state management from setState to GetX, redesigned UI, integrated REST APIs, and deployed to Google Play and Apple App Store.</li>
      </ul>
    </div>

    <!-- 9. Agents Thrive -->
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">9. Agents Thrive — Real Estate Agent Productivity Suite</span>
        <span class="entry-meta"><a href="https://apps.apple.com/us/app/agent-thrive-app/id6467190612" target="_blank">[Apple App Store]</a></span>
      </div>
      <div class="entry-tech"><strong>Tech Stack:</strong> Flutter, FlutterFlow, DocuSign API, PDF Viewer, Calendar Sync</div>
      <ul class="bullet-list">
        <li>Implemented secure biometric authentication, DocuSign contract integration, PDF generation/viewing, calendar synchronization, and production deployment.</li>
      </ul>
    </div>

    <!-- 10. Radio Spice -->
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">10. Radio Spice — Live Radio & Audio Streaming Platform</span>
        <span class="entry-meta">
          <a href="https://play.google.com/store/apps/details?id=com.app.audio_app&pcampaignid=web_share&pli=1" target="_blank">[Google Play Store]</a> •
          <a href="https://apps.apple.com/in/app/radio-spice-nzpmt/id6737826716" target="_blank">[Apple App Store]</a>
        </span>
      </div>
      <div class="entry-tech"><strong>Tech Stack:</strong> Flutter, Dart, GetX, Firebase Cloud Messaging, Audio Playback, WebView</div>
      <ul class="bullet-list">
        <li>Built live radio streaming application with background playback, YouTube/WhatsApp integration, Firebase push notifications, and bilingual support.</li>
      </ul>
    </div>

    <!-- 11, 12, 13. FinPin, Inspire4Goal, Disporata -->
    <div class="entry">
      <ul class="bullet-list">
        <li><strong>11. FinPin (<a href="https://apps.apple.com/in/app/finpin/id6727005412" target="_blank">App Store</a>):</strong> Personal finance tracking app built with FlutterFlow & Firebase; implemented timelines (weekly, monthly, yearly), income/expense targets, and interactive charts.</li>
        <li><strong>12. Inspire4Goal:</strong> Motivational quotes app with GetX, scheduled notifications, dark/light themes, and English/Dutch localization.</li>
        <li><strong>13. Disporata:</strong> Location-based social platform built with Flutter & FlutterFlow; implemented Google Places profile setup, distance calculation, and nearby user discovery.</li>
      </ul>
    </div>

    <!-- COMPANY 3: WHITE ORANGE SOFTWARE -->
    <div class="company-subheading">
      <span>WHITE ORANGE SOFTWARE PROJECTS</span>
      <span>Jan 2022 – May 2024</span>
    </div>

    <!-- 14. FineAway -->
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">14. FineAway — Traffic Fine Resolution & License Renewal</span>
        <span class="entry-meta">
          <a href="https://play.google.com/store/apps/details?id=com.app.fineaway&pcampaignid=web_share" target="_blank">[Google Play Store]</a> •
          <a href="https://apps.apple.com/us/app/fineaway-app/id6467185920" target="_blank">[Apple App Store]</a>
        </span>
      </div>
      <div class="entry-tech"><strong>Tech Stack:</strong> Flutter, Dart, GetX, OCR Text Scanning, REST APIs</div>
      <ul class="bullet-list">
        <li>Integrated camera-based OCR text recognition for automated vehicle license data extraction, fine resolution, and payment handling across Android and iOS.</li>
      </ul>
    </div>

    <!-- 15, 16. LC Banker & Wealth Management -->
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">15. Adroit Vantage — LC Banker & 16. Wealth Management 2.0</span>
        <span class="entry-meta"><a href="https://apps.apple.com/us/app/wealth-management-2-0/id1672260039" target="_blank">[Apple App Store]</a></span>
      </div>
      <div class="entry-tech"><strong>Tech Stack:</strong> Flutter, GetX, Interactive Graphs, Calendar Events, REST APIs, Hive DB</div>
      <ul class="bullet-list">
        <li>Engineered financial portfolio interfaces for high-net-worth clients with responsive equity/bond charting, calendar events, and real-time chat.</li>
      </ul>
    </div>

    <!-- 17, 18, 19. Muvr, AV Social, Mdsty -->
    <div class="entry">
      <ul class="bullet-list">
        <li><strong>17. Muvr On-Demand Logistics (<a href="https://apps.apple.com/us/app/muvr-get-furniture-delivery/id6450030781" target="_blank">Customer App</a> • <a href="https://apps.apple.com/us/app/muvr-for-movers-earn-money/id6450041017" target="_blank">Driver App</a>):</strong> Developed booking workflows, dynamic dispatch, and real-time tracking across customer and driver applications.</li>
        <li><strong>18. AV Social:</strong> Social networking app with live feed, polls, media sharing, and Hive DB.</li>
        <li><strong>19. Mdsty:</strong> German market e-commerce application with MVC architecture, local language support, product catalog, and payment gateway integration.</li>
      </ul>
    </div>

  </section>

  <!-- EDUCATION & HONORS -->
  <section class="section">
    <div class="section-title">
      <svg viewBox="0 0 24 24"><path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/></svg>
      Education & Honors
    </div>
    <div class="edu-grid">
      <div class="edu-card">
        <div class="edu-degree">Master of Computer Applications (MCA) — CGPA: 7.61 (Distinction)</div>
        <div class="edu-inst">Sarvajanik College of Engineering & Technology, GTU • Surat, India (Dec 2020 – May 2022)</div>
      </div>
      <div class="edu-card">
        <div class="edu-degree">Bachelor of Computer Applications (BCA) — CGPA: 7.39 (Distinction)</div>
        <div class="edu-inst">Vivekanand College for Advance Computer & Info. Science, VNSGU • Surat, India (Jun 2017 – Mar 2020)</div>
      </div>
    </div>
  </section>

  <!-- AWARDS -->
  <section class="section" style="margin-bottom:0;">
    <div class="section-title">
      <svg viewBox="0 0 24 24"><path d="M19 5h-2V3H7v2H5c-1.1 0-2 .9-2 2v1c0 2.55 1.92 4.63 4.39 4.94A5.01 5.01 0 0 0 11 15.9V19H7v2h10v-2h-4v-3.1a5.01 5.01 0 0 0 3.61-4.96C19.08 10.63 21 8.55 21 8V7c0-1.1-.9-2-2-2zM5 8V7h2v3.82C5.84 10.4 5 9.3 5 8zm14 0c0 1.3-.84 2.4-2 2.82V7h2v1z"/></svg>
      Honors & Awards
    </div>
    <p style="font-size:8pt; color:#334155;">
      <strong>🏆 Code Craft Excellence Award (2025) — Logix Built Solutions Limited:</strong> Awarded in recognition of exceptional code craftsmanship, modular architecture design, and outstanding engineering delivery across enterprise cross-platform mobile and web applications.
    </p>
  </section>

  <!-- FOOTER -->
  <footer class="cv-footer">
    <span>Dhruvi Patel • Senior Flutter Developer</span>
    <span>Surat, India • +91 9925589405 • dhruvi39604@gmail.com</span>
    <span>Complete Experience & Projects Portfolio</span>
  </footer>

</body>
</html>
"""


def render_pdf(browser, html_path, pdf_path):
    file_uri = f"file:///{str(html_path).replace(os.sep, '/')}"
    out_path_str = str(pdf_path)

    ps_cmd = (
        f'Start-Process -FilePath "{browser}" '
        f'-ArgumentList "--headless=new --disable-gpu --print-to-pdf=`"{out_path_str}`" --no-pdf-header-footer `"{file_uri}`"" '
        f"-Wait"
    )

    result = subprocess.run(["powershell", "-NoProfile", "-Command", ps_cmd], capture_output=True, text=True)
    if result.returncode != 0 or not pdf_path.exists():
        print(f"Error generating PDF {pdf_path}: {result.stderr}")
        return False
    return True


def main():
    browser = find_browser()
    if not browser:
        print("ERROR: Neither Microsoft Edge nor Google Chrome was found.")
        sys.exit(1)

    print(f"Using browser: {browser}")

    # 1. Generate 1-Page CV
    HTML_1PAGE.parent.mkdir(parents=True, exist_ok=True)
    HTML_1PAGE.write_text(HTML_1PAGE_CONTENT, encoding="utf-8")

    PDF_1PAGE_DOCS.parent.mkdir(parents=True, exist_ok=True)
    success_1 = render_pdf(browser, HTML_1PAGE, PDF_1PAGE_DOCS)
    if success_1:
        reader = PdfReader(str(PDF_1PAGE_DOCS))
        page_count = len(reader.pages)
        print(f"SUCCESS: 1-Page CV generated at {PDF_1PAGE_DOCS} with {page_count} page(s) ({PDF_1PAGE_DOCS.stat().st_size} bytes)")
        
        # Copy to root and resume.pdf
        pdf_bytes = PDF_1PAGE_DOCS.read_bytes()
        PDF_1PAGE_ROOT.write_bytes(pdf_bytes)
        PDF_DEFAULT_RESUME.write_bytes(pdf_bytes)
        print(f"SUCCESS: Copied 1-page CV to {PDF_1PAGE_ROOT} and {PDF_DEFAULT_RESUME}")

    # 2. Generate Complete Detailed CV
    HTML_COMPLETE.parent.mkdir(parents=True, exist_ok=True)
    HTML_COMPLETE.write_text(HTML_COMPLETE_CONTENT, encoding="utf-8")

    PDF_COMPLETE_DOCS.parent.mkdir(parents=True, exist_ok=True)
    success_complete = render_pdf(browser, HTML_COMPLETE, PDF_COMPLETE_DOCS)
    if success_complete:
        reader = PdfReader(str(PDF_COMPLETE_DOCS))
        page_count = len(reader.pages)
        print(f"SUCCESS: Complete CV generated at {PDF_COMPLETE_DOCS} with {page_count} page(s) ({PDF_COMPLETE_DOCS.stat().st_size} bytes)")

        # Copy to root
        PDF_COMPLETE_ROOT.write_bytes(PDF_COMPLETE_DOCS.read_bytes())
        print(f"SUCCESS: Copied Complete CV to {PDF_COMPLETE_ROOT}")


if __name__ == "__main__":
    main()
