"""
Professional DOCX CV / Resume Generator for Dhruvi Patel
Generates an executive, ATS-optimized, beautifully styled Word Document (.docx)
with true clickable hyperlinks, clean typography, categorized skills,
and comprehensive project details with live App Store & Play Store links.
"""

import os
from pathlib import Path
import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

WORKSPACE_ROOT = Path(__file__).resolve().parent.parent
OUTPUT_DOCX = WORKSPACE_ROOT / "Dhruvi_Patel_Senior_Flutter_Developer_CV.docx"
OUTPUT_DOCX_ASSETS = WORKSPACE_ROOT / "assets" / "docs" / "Dhruvi_Patel_Senior_Flutter_Developer_CV.docx"

# Color Palette
HEX_NAVY = "0F294A"       # Primary Headers & Name
HEX_BLUE = "1D4ED8"       # Accent / Hyperlinks
HEX_SLATE = "475569"      # Subtitles & Metadata
HEX_BODY = "1E293B"       # Body Text
HEX_BORDER = "CBD5E1"     # Section Dividers
HEX_AWARD_BG = "FEF3C7"   # Award Badge BG
HEX_AWARD_TXT = "92400E"  # Award Badge Text

RGB_NAVY = RGBColor(15, 41, 74)
RGB_BLUE = RGBColor(29, 78, 216)
RGB_SLATE = RGBColor(71, 85, 105)
RGB_BODY = RGBColor(30, 41, 59)
RGB_AWARD = RGBColor(146, 64, 14)


def add_hyperlink(paragraph, text, url, color=HEX_BLUE, underline=True, bold=False):
    """Adds a clickable hyperlink into a python-docx paragraph using Word XML."""
    part = paragraph.part
    r_id = part.relate_to(url, docx.opc.constants.RELATIONSHIP_TYPE.HYPERLINK, is_external=True)

    hyperlink = parse_xml(f'<w:hyperlink xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" r:id="{r_id}" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>')
    new_run = parse_xml(f'<w:r xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"/>')

    rPr = parse_xml(f'<w:rPr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"/>')
    if color:
        c = parse_xml(f'<w:color xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:val="{color}"/>')
        rPr.append(c)
    if underline:
        u = parse_xml(f'<w:u xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:val="single"/>')
        rPr.append(u)
    if bold:
        b = parse_xml(f'<w:b xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"/>')
        rPr.append(b)

    text_node = parse_xml(f'<w:t xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xml:space="preserve">{text}</w:t>')
    new_run.append(rPr)
    new_run.append(text_node)
    hyperlink.append(new_run)
    paragraph._p.append(hyperlink)


def set_cell_border_bottom(cell, color=HEX_BORDER, sz="6"):
    """Sets a bottom border on a table cell."""
    tcPr = cell._tc.get_or_add_tcPr()
    tcBorders = parse_xml(
        f'<w:tcBorders {nsdecls("w")}>\n'
        f'  <w:bottom w:val="single" w:sz="{sz}" w:space="0" w:color="{color}"/>\n'
        f'  <w:top w:val="none"/>\n'
        f'  <w:left w:val="none"/>\n'
        f'  <w:right w:val="none"/>\n'
        f'</w:tcBorders>'
    )
    tcPr.append(tcBorders)


def set_cell_margins(cell, top=50, bottom=50, left=60, right=60):
    """Sets padding for a table cell in dxa (1 pt = 20 dxa)."""
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = parse_xml(
        f'<w:tcMar {nsdecls("w")}>\n'
        f'  <w:top w:w="{top}" w:type="dxa"/>\n'
        f'  <w:bottom w:w="{bottom}" w:type="dxa"/>\n'
        f'  <w:left w:w="{left}" w:type="dxa"/>\n'
        f'  <w:right w:w="{right}" w:type="dxa"/>\n'
        f'</w:tcMar>'
    )
    tcPr.append(tcMar)


def add_section_header(doc, title):
    """Creates a modern, styled section header with an elegant underline."""
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(10)
    p.paragraph_format.space_after = Pt(3)
    p.paragraph_format.keep_with_next = True

    run = p.add_run(title.upper())
    run.font.name = "Calibri"
    run.font.size = Pt(11)
    run.font.bold = True
    run.font.color.rgb = RGB_NAVY

    # Add a thin colored border under paragraph via XML
    pPr = p._p.get_or_add_pPr()
    pBdr = parse_xml(
        f'<w:pBdr {nsdecls("w")}>\n'
        f'  <w:bottom w:val="single" w:sz="8" w:space="2" w:color="{HEX_NAVY}"/>\n'
        f'</w:pBdr>'
    )
    pPr.append(pBdr)


def add_bullet_point(doc, lead_in, text, space_after=2):
    """Adds a clean bullet point with bold lead-in."""
    p = doc.add_paragraph(style="List Bullet")
    p.paragraph_format.space_before = Pt(0)
    p.paragraph_format.space_after = Pt(space_after)
    p.paragraph_format.line_spacing = 1.15

    if lead_in:
        r_lead = p.add_run(lead_in + (" " if not lead_in.endswith(" ") else ""))
        r_lead.font.name = "Calibri"
        r_lead.font.size = Pt(9.5)
        r_lead.font.bold = True
        r_lead.font.color.rgb = RGB_BODY

    r_text = p.add_run(text)
    r_text.font.name = "Calibri"
    r_text.font.size = Pt(9.5)
    r_text.font.color.rgb = RGB_BODY
    return p


def build_docx():
    doc = Document()

    # Configure Margins (0.55 in = 39.6 pt)
    sections = doc.sections
    for section in sections:
        section.top_margin = Inches(0.55)
        section.bottom_margin = Inches(0.55)
        section.left_margin = Inches(0.6)
        section.right_margin = Inches(0.6)

    # Base Normal Style
    style_normal = doc.styles['Normal']
    style_normal.font.name = 'Calibri'
    style_normal.font.size = Pt(9.5)
    style_normal.font.color.rgb = RGB_BODY

    # ==========================================
    # 1. HEADER (NAME & TITLE)
    # ==========================================
    p_name = doc.add_paragraph()
    p_name.paragraph_format.space_before = Pt(0)
    p_name.paragraph_format.space_after = Pt(1)
    r_name = p_name.add_run("Dhruvi Patel")
    r_name.font.name = "Calibri"
    r_name.font.size = Pt(22)
    r_name.font.bold = True
    r_name.font.color.rgb = RGB_NAVY

    p_title = doc.add_paragraph()
    p_title.paragraph_format.space_before = Pt(0)
    p_title.paragraph_format.space_after = Pt(4)
    r_title = p_title.add_run("Senior Software Engineer • Senior Flutter Developer • Mobile Application Developer")
    r_title.font.name = "Calibri"
    r_title.font.size = Pt(10.5)
    r_title.font.bold = True
    r_title.font.color.rgb = RGB_BLUE

    # Contact Info Bar with clickable hyperlinks
    p_contact = doc.add_paragraph()
    p_contact.paragraph_format.space_before = Pt(0)
    p_contact.paragraph_format.space_after = Pt(6)

    r_loc = p_contact.add_run("📍 Surat, Gujarat, India  |  📞 ")
    r_loc.font.size = Pt(9)
    r_loc.font.color.rgb = RGB_SLATE

    add_hyperlink(p_contact, "+91 9925589405", "tel:+919925589405", color=HEX_BLUE, underline=False)

    r_sep1 = p_contact.add_run("  |  ✉️ ")
    r_sep1.font.size = Pt(9)
    r_sep1.font.color.rgb = RGB_SLATE

    add_hyperlink(p_contact, "dhruvi39604@gmail.com", "mailto:dhruvi39604@gmail.com", color=HEX_BLUE, underline=False)

    r_sep2 = p_contact.add_run("  |  🔗 ")
    r_sep2.font.size = Pt(9)
    r_sep2.font.color.rgb = RGB_SLATE

    add_hyperlink(p_contact, "LinkedIn Profile", "https://www.linkedin.com/in/dhruvi-patel-flutter", color=HEX_BLUE, underline=True)

    r_sep3 = p_contact.add_run("  |  💻 ")
    r_sep3.font.size = Pt(9)
    r_sep3.font.color.rgb = RGB_SLATE

    add_hyperlink(p_contact, "GitHub", "https://github.com/dhruvipatel", color=HEX_BLUE, underline=True)

    # Bottom border for header
    pPr = p_contact._p.get_or_add_pPr()
    pBdr = parse_xml(
        f'<w:pBdr {nsdecls("w")}>\n'
        f'  <w:bottom w:val="single" w:sz="12" w:space="4" w:color="{HEX_NAVY}"/>\n'
        f'</w:pBdr>'
    )
    pPr.append(pBdr)

    # ==========================================
    # 2. PROFESSIONAL SUMMARY
    # ==========================================
    add_section_header(doc, "Professional Summary")
    p_sum = doc.add_paragraph()
    p_sum.paragraph_format.space_before = Pt(2)
    p_sum.paragraph_format.space_after = Pt(6)
    p_sum.paragraph_format.line_spacing = 1.15
    p_sum.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY

    r_sum1 = p_sum.add_run("Senior Software Engineer and Senior Flutter Developer with ")
    r_sum2 = p_sum.add_run("4+ years")
    r_sum2.font.bold = True
    r_sum3 = p_sum.add_run(
        " of proven professional experience building, optimizing, and deploying high-performance cross-platform mobile (Android & iOS) "
        "and web applications. Honored with the "
    )
    r_sum_awd = p_sum.add_run("Code Craft Excellence Award (2025)")
    r_sum_awd.font.bold = True
    r_sum_awd.font.color.rgb = RGB_NAVY
    r_sum4 = p_sum.add_run(
        " for clean modular architecture design, code craftsmanship, and engineering leadership. Expert in Flutter, Dart, GetX, "
        "Clean Architecture, REST APIs with Dio, Firebase, and real-time bidirectional communication using "
    )
    r_sum_iot = p_sum.add_run("AWS IoT Core (MQTT over WebSockets).")
    r_sum_iot.font.bold = True
    r_sum5 = p_sum.add_run(
        " Demonstrated success leading dual-sided on-demand product development from scratch, shipping 50+ production releases to Google Play and Apple App Store, "
        "engineering resilient networking with single-flight locks, optimizing complex rendering pipelines, and building automated test suites (Unit, Widget, Integration) ensuring zero regression."
    )

    # ==========================================
    # 3. TECHNICAL COMPETENCIES
    # ==========================================
    add_section_header(doc, "Technical Competencies")

    skills_data = [
        ("Languages & Core:", "Dart, Java, Kotlin, Python, HTML5, CSS3, JavaScript"),
        ("Mobile & Web Frameworks:", "Flutter (Mobile iOS & Android, Flutter Web), FlutterFlow"),
        ("State Management & Architecture:", "GetX State Management, Clean Architecture, Modular Design, BLoC Pattern, Repository Pattern, Dependency Injection"),
        ("API & Real-Time Backend:", "REST APIs, Dio, Single-Flight Lock, AWS IoT Core (MQTT over WebSockets), Firebase Cloud Messaging (FCM), WebSocket Lifecycle"),
        ("Backend & Cloud Services:", "Firebase (Auth, Firestore, Cloud Functions, Remote Config, Crashlytics, Analytics, Performance Monitoring)"),
        ("Local Storage & Database:", "Hive DB, Flutter Secure Storage, SharedPreferences, SQLite, Cloud Firestore"),
        ("Testing & Quality Assurance:", "Unit Testing, Widget Testing, Flutter Integration Test, Mocktail, Debugging, DevTools Profiling, Code Reviews"),
        ("DevOps, Tooling & Release:", "Git, GitHub Actions, Android Studio, Xcode, VS Code, Google Play Console, Apple App Store Connect, Postman"),
        ("Specialized Integrations:", "Google Places API, Cloudflare Turnstile, In-App Review, RevenueCat & StoreKit In-App Purchases, CustomPainter, flutter_math_fork, BroadcastChannel API"),
    ]

    t_skills = doc.add_table(rows=len(skills_data), cols=2)
    t_skills.alignment = WD_TABLE_ALIGNMENT.CENTER
    t_skills.autofit = False

    for i, (cat, val) in enumerate(skills_data):
        row = t_skills.rows[i]
        
        # Category Column
        cell_cat = row.cells[0]
        cell_cat.width = Inches(2.2)
        set_cell_margins(cell_cat, top=25, bottom=25, left=30, right=30)
        p_c = cell_cat.paragraphs[0]
        p_c.paragraph_format.space_before = Pt(0)
        p_c.paragraph_format.space_after = Pt(0)
        r_c = p_c.add_run(cat)
        r_c.font.size = Pt(8.8)
        r_c.font.bold = True
        r_c.font.color.rgb = RGB_NAVY

        # Value Column
        cell_val = row.cells[1]
        cell_val.width = Inches(5.0)
        set_cell_margins(cell_val, top=25, bottom=25, left=30, right=30)
        p_v = cell_val.paragraphs[0]
        p_v.paragraph_format.space_before = Pt(0)
        p_v.paragraph_format.space_after = Pt(0)
        r_v = p_v.add_run(val)
        r_v.font.size = Pt(8.8)
        r_v.font.color.rgb = RGB_BODY

    # ==========================================
    # 4. PROFESSIONAL EXPERIENCE
    # ==========================================
    add_section_header(doc, "Professional Experience")

    # --- Role 1: Logix Built Solutions Limited ---
    p_exp1 = doc.add_paragraph()
    p_exp1.paragraph_format.space_before = Pt(5)
    p_exp1.paragraph_format.space_after = Pt(1)
    p_exp1.paragraph_format.keep_with_next = True

    r1_co = p_exp1.add_run("Logix Built Solutions Limited")
    r1_co.font.bold = True
    r1_co.font.size = Pt(10.5)
    r1_co.font.color.rgb = RGB_NAVY

    r1_loc = p_exp1.add_run(" — Surat, India")
    r1_loc.font.size = Pt(9.5)
    r1_loc.font.color.rgb = RGB_SLATE

    # Right-aligned date via tabs or formatting
    r1_date = p_exp1.add_run("  |  May 2025 – Present")
    r1_date.font.bold = True
    r1_date.font.size = Pt(9.5)
    r1_date.font.color.rgb = RGB_SLATE

    p_sub1 = doc.add_paragraph()
    p_sub1.paragraph_format.space_before = Pt(0)
    p_sub1.paragraph_format.space_after = Pt(3)
    p_sub1.paragraph_format.keep_with_next = True

    r1_role = p_sub1.add_run("Senior Software Engineer | Flutter Developer")
    r1_role.font.bold = True
    r1_role.font.size = Pt(10)
    r1_role.font.color.rgb = RGB_BLUE

    r1_awd = p_sub1.add_run("   [ 🏆 Code Craft Excellence Award (2025) Recipient ]")
    r1_awd.font.bold = True
    r1_awd.font.size = Pt(9)
    r1_awd.font.color.rgb = RGB_AWARD

    add_bullet_point(doc, "System Architecture & Leadership:", "Architected dual-sided on-demand applications and internal engineering platforms from scratch using Flutter, Dart, and GetX under Clean Modular Architecture, driving 50+ successful production releases across Android and iOS.")
    add_bullet_point(doc, "Real-Time Dispatch Engine:", "Engineered low-latency bidirectional dispatch infrastructure using AWS IoT Core (MQTT over Secure WebSockets) and Firebase Cloud Messaging (FCM), featuring signed WebSocket setup, reconnection lifecycle handlers, and custom platform sound/vibration alerts.")
    add_bullet_point(doc, "Resilient Networking & Token Security:", "Implemented Dio HTTP client with smart exponential backoff retries and a thread-safe Single-Flight Lock (Completer) to completely eliminate token-refresh race conditions during concurrent API requests.")
    add_bullet_point(doc, "Flutter Web QA & Auto-Fix Suite:", "Engineered a browser-based dataset validation suite with a 20-rule AST parser, auto-remediating malformed HTML, broken table/list hierarchies, and encoding artifacts for multi-thousand question exam banks.")
    add_bullet_point(doc, "Zero-Downtime Release Engine:", "Integrated Google Play In-App Updates (Immediate & Flexible) and Firebase Remote Config, featuring automated local storage migrations on version bumps and AppLinks deep linking with auth-gated intent preservation.")
    add_bullet_point(doc, "Automated Testing & Reliability:", "Authored unit, widget, and integration test suites using Mocktail and Flutter Integration Test for critical authentication, booking, and payment flows, ensuring regression-free deployments.")

    # --- Role 2: DinJan Infotech ---
    p_exp2 = doc.add_paragraph()
    p_exp2.paragraph_format.space_before = Pt(6)
    p_exp2.paragraph_format.space_after = Pt(1)
    p_exp2.paragraph_format.keep_with_next = True

    r2_co = p_exp2.add_run("Dinjan Infotech")
    r2_co.font.bold = True
    r2_co.font.size = Pt(10.5)
    r2_co.font.color.rgb = RGB_NAVY

    r2_loc = p_exp2.add_run(" — Surat, India")
    r2_loc.font.size = Pt(9.5)
    r2_loc.font.color.rgb = RGB_SLATE

    r2_date = p_exp2.add_run("  |  June 2024 – April 2025")
    r2_date.font.bold = True
    r2_date.font.size = Pt(9.5)
    r2_date.font.color.rgb = RGB_SLATE

    p_sub2 = doc.add_paragraph()
    p_sub2.paragraph_format.space_before = Pt(0)
    p_sub2.paragraph_format.space_after = Pt(3)
    p_sub2.paragraph_format.keep_with_next = True

    r2_role = p_sub2.add_run("Flutter Developer")
    r2_role.font.bold = True
    r2_role.font.size = Pt(10)
    r2_role.font.color.rgb = RGB_BLUE

    add_bullet_point(doc, "Cross-Platform Application Delivery:", "Designed and implemented responsive, visually appealing UIs for Android and iOS using Flutter and FlutterFlow, authoring custom interactive widgets for complex UI workflows.")
    add_bullet_point(doc, "API Integration & State Management:", "Integrated secure RESTful APIs, structured centralized state handling using GetX, and engineered reliable offline caching and data persistence.")
    add_bullet_point(doc, "Performance Profiling & Maintenance:", "Conducted routine DevTools memory profiling, resolved layout jank, updated deprecated dependencies, and ensured continuous platform compatibility.")
    add_bullet_point(doc, "Technical Mentorship:", "Mentored junior mobile developers on Dart idiomatic conventions, effective widget tree decomposition, and collaborative Git branching workflows.")

    # --- Role 3: White Orange Software (Developer) ---
    p_exp3 = doc.add_paragraph()
    p_exp3.paragraph_format.space_before = Pt(6)
    p_exp3.paragraph_format.space_after = Pt(1)
    p_exp3.paragraph_format.keep_with_next = True

    r3_co = p_exp3.add_run("White Orange Software")
    r3_co.font.bold = True
    r3_co.font.size = Pt(10.5)
    r3_co.font.color.rgb = RGB_NAVY

    r3_loc = p_exp3.add_run(" — Surat, India")
    r3_loc.font.size = Pt(9.5)
    r3_loc.font.color.rgb = RGB_SLATE

    r3_date = p_exp3.add_run("  |  June 2022 – May 2024")
    r3_date.font.bold = True
    r3_date.font.size = Pt(9.5)
    r3_date.font.color.rgb = RGB_SLATE

    p_sub3 = doc.add_paragraph()
    p_sub3.paragraph_format.space_before = Pt(0)
    p_sub3.paragraph_format.space_after = Pt(3)
    p_sub3.paragraph_format.keep_with_next = True

    r3_role = p_sub3.add_run("Mobile App Developer")
    r3_role.font.bold = True
    r3_role.font.size = Pt(10)
    r3_role.font.color.rgb = RGB_BLUE

    add_bullet_point(doc, "Production Mobile Development:", "Developed and shipped scalable cross-platform mobile applications for Android and iOS utilizing Flutter, Dart, REST APIs, and Firebase.")
    add_bullet_point(doc, "Performance & UI Optimization:", "Analyzed software issues, optimized memory/CPU footprints, accelerated list rendering, and adapted interfaces across diverse screen dimensions.")
    add_bullet_point(doc, "Agile Collaboration:", "Collaborated closely with backend developers, UI/UX designers, and QA teams to maintain velocity and meet release deadlines.")

    # --- Role 4: White Orange Software (Intern) ---
    p_exp4 = doc.add_paragraph()
    p_exp4.paragraph_format.space_before = Pt(6)
    p_exp4.paragraph_format.space_after = Pt(1)
    p_exp4.paragraph_format.keep_with_next = True

    r4_co = p_exp4.add_run("White Orange Software")
    r4_co.font.bold = True
    r4_co.font.size = Pt(10.5)
    r4_co.font.color.rgb = RGB_NAVY

    r4_loc = p_exp4.add_run(" — Surat, India")
    r4_loc.font.size = Pt(9.5)
    r4_loc.font.color.rgb = RGB_SLATE

    r4_date = p_exp4.add_run("  |  January 2022 – May 2022")
    r4_date.font.bold = True
    r4_date.font.size = Pt(9.5)
    r4_date.font.color.rgb = RGB_SLATE

    p_sub4 = doc.add_paragraph()
    p_sub4.paragraph_format.space_before = Pt(0)
    p_sub4.paragraph_format.space_after = Pt(3)
    p_sub4.paragraph_format.keep_with_next = True

    r4_role = p_sub4.add_run("Android Developer Intern")
    r4_role.font.bold = True
    r4_role.font.size = Pt(10)
    r4_role.font.color.rgb = RGB_BLUE

    add_bullet_point(doc, "Enterprise HR Application:", "Engineered Android mobile application for enterprise HR departments to manage employee profiles, salary records, attendance, and real-time messaging between HR and staff.")
    add_bullet_point(doc, "Native SDK Integration & Testing:", "Used Android Studio, Java, Kotlin, Firebase Realtime Database, and third-party SDKs; performed manual testing and profiling across physical Android devices.")

    # ==========================================
    # 5. KEY PROJECT EXPERIENCE (COMPANY-WISE WITH LIVE LINKS)
    # ==========================================
    add_section_header(doc, "Key Project Experience (Flagship & Commercial Applications)")

    # ------------------------------------------
    # Logix Built Solutions Limited Projects
    # ------------------------------------------
    p_sec_logix = doc.add_paragraph()
    p_sec_logix.paragraph_format.space_before = Pt(5)
    p_sec_logix.paragraph_format.space_after = Pt(2)
    p_sec_logix.paragraph_format.keep_with_next = True
    r_sl = p_sec_logix.add_run("LOGIX BUILT SOLUTIONS LIMITED PROJECTS")
    r_sl.font.bold = True
    r_sl.font.size = Pt(10)
    r_sl.font.color.rgb = RGB_NAVY

    # Project 1: Pandits Near Me - Instant Puja
    p_p1 = doc.add_paragraph()
    p_p1.paragraph_format.space_before = Pt(3)
    p_p1.paragraph_format.space_after = Pt(1)
    p_p1.paragraph_format.keep_with_next = True
    r_p1 = p_p1.add_run("1. Pandits Near Me - Instant Puja — Dual-Sided On-Demand Marketplace (Android & iOS | 50+ Releases)")
    r_p1.font.bold = True
    r_p1.font.size = Pt(9.8)
    r_p1.font.color.rgb = RGB_BODY

    p_p1_links = doc.add_paragraph()
    p_p1_links.paragraph_format.space_before = Pt(0)
    p_p1_links.paragraph_format.space_after = Pt(2)
    r_tech1 = p_p1_links.add_run("Tech Stack: Flutter, Dart, GetX, REST APIs, Firebase, FCM, AWS IoT Core (MQTT), Google Places API, Hive  |  ")
    r_tech1.font.size = Pt(8.5)
    r_tech1.font.color.rgb = RGB_SLATE

    add_hyperlink(p_p1_links, "Google Play Store", "https://play.google.com/store/apps/details?id=com.officialpanditsnearme&hl=en", color=HEX_BLUE)
    p_p1_links.add_run("  •  ").font.size = Pt(8.5)
    add_hyperlink(p_p1_links, "Apple App Store", "https://apps.apple.com/in/app/pandits-near-me-instant-puja/id6757301105", color=HEX_BLUE)

    add_bullet_point(doc, "Dual-Sided Marketplace:", "Architected dual-sided app from scratch for users, Pandits, and Astrologers covering onboarding, OTP/email authentication, profile management, service discovery, puja booking, and booking management.")
    add_bullet_point(doc, "Real-Time MQTT Communication:", "Integrated AWS IoT Core MQTT over signed WebSocket connections with connection lifecycle handling, automatic reconnection, and FCM push notifications with platform-specific sound/vibration alerts.")
    add_bullet_point(doc, "KYC & Verification:", "Built Pandit KYC onboarding with Aadhaar document uploads, certificates, experience details, service locations, and verification status.")
    add_bullet_point(doc, "Astrology & Horoscope Engine:", "Built Kundali and Kundali Matching features with dynamic planetary calculations, custom geometric horoscope charts rendered via CustomPainter, Gun Milan, and PDF download.")
    add_bullet_point(doc, "Location & Multilingual:", "Integrated Google Places API autocomplete, location-aware Panchang/Muhurat, and full multilingual support (English, Hindi, Gujarati).")

    # Project 2: PMP CSV Validator
    p_p2 = doc.add_paragraph()
    p_p2.paragraph_format.space_before = Pt(4)
    p_p2.paragraph_format.space_after = Pt(1)
    p_p2.paragraph_format.keep_with_next = True
    r_p2 = p_p2.add_run("2. PMP CSV Validator & Preview Tool — Dataset QA & Mobile Simulation Suite (Flutter Web)")
    r_p2.font.bold = True
    r_p2.font.size = Pt(9.8)
    r_p2.font.color.rgb = RGB_BODY

    p_p2_tech = doc.add_paragraph()
    p_p2_tech.paragraph_format.space_before = Pt(0)
    p_p2_tech.paragraph_format.space_after = Pt(2)
    r_tech2 = p_p2_tech.add_run("Tech Stack: Flutter Web, Dart, Python, CSV Parsing, AST Parser Engine, HTML Rendering, flutter_math_fork, Widget Testing")
    r_tech2.font.size = Pt(8.5)
    r_tech2.font.color.rgb = RGB_SLATE

    add_bullet_point(doc, "Dataset QA & Validation Suite:", "Developed a responsive browser-based tool to upload, validate, inspect, auto-correct, and export PMP question datasets with drag-and-drop CSV upload and automatic delimiter/encoding detection (Gujarati, Hindi, Sanskrit Unicode).")
    add_bullet_point(doc, "20-Rule AST Remediation:", "Engineered an AST parser and stack-based remediation engine resolving unclosed HTML tags, orphan tables/lists, and encoding artifacts without data loss; delivered bulk Auto-Fix functionality.")
    add_bullet_point(doc, "Mobile Simulator & LaTeX:", "Created reusable HTML rendering supporting rich text, nested lists, Base64 images, scrollable tables, and LaTeX equations via flutter_math_fork, alongside an interactive multi-device simulator with TRAIN/FLIP cards and side-by-side Cell Inspector.")

    # Project 3: PMP Exam Prep App
    p_p3 = doc.add_paragraph()
    p_p3.paragraph_format.space_before = Pt(4)
    p_p3.paragraph_format.space_after = Pt(1)
    p_p3.paragraph_format.keep_with_next = True
    r_p3 = p_p3.add_run("3. PMP Exam Prep App — Professional Certification Exam Simulator (Mobile)")
    r_p3.font.bold = True
    r_p3.font.size = Pt(9.8)
    r_p3.font.color.rgb = RGB_BODY

    p_p3_tech = doc.add_paragraph()
    p_p3_tech.paragraph_format.space_before = Pt(0)
    p_p3_tech.paragraph_format.space_after = Pt(2)
    r_tech3 = p_p3_tech.add_run("Tech Stack: Flutter, Dart, GetX, REST APIs, Firebase, Local Storage, AdMob Advertising SDKs, AppLinks Deep Linking")
    r_tech3.font.size = Pt(8.5)
    r_tech3.font.color.rgb = RGB_SLATE

    add_bullet_point(doc, "Interactive Quiz Workflows:", "Enhanced timed mock tests, question navigation, answer review, flagged questions, explanations, and attempt analytics with responsive loading states.")
    add_bullet_point(doc, "Deep Linking & Monetization:", "Engineered referral deep-link handling for cold-start and resumed sessions, guest vs. premium tiered subscription paywalls, and resolved native AdMob lifecycle and controller leaks.")

    # Project 4: Nirvana App
    p_p4 = doc.add_paragraph()
    p_p4.paragraph_format.space_before = Pt(4)
    p_p4.paragraph_format.space_after = Pt(1)
    p_p4.paragraph_format.keep_with_next = True
    r_p4 = p_p4.add_run("4. Nirvana App — Real Estate Property Discovery & Dynamic Booking System")
    r_p4.font.bold = True
    r_p4.font.size = Pt(9.8)
    r_p4.font.color.rgb = RGB_BODY

    p_p4_tech = doc.add_paragraph()
    p_p4_tech.paragraph_format.space_before = Pt(0)
    p_p4_tech.paragraph_format.space_after = Pt(2)
    r_tech4 = p_p4_tech.add_run("Tech Stack: Flutter, Dart, REST APIs, PDF Viewer, Chatbot API, Responsive Tablet & Mobile Layouts")
    r_tech4.font.size = Pt(8.5)
    r_tech4.font.color.rgb = RGB_SLATE

    add_bullet_point(doc, "Property Booking Workflow:", "Implemented multi-step property purchase flow covering unit selection, real-time availability states, dynamic pricing, purchaser agreements, down-payment calculation, and payment summaries.")
    add_bullet_point(doc, "PDF & Chatbot Integration:", "Integrated in-app PDF agreement viewing, terms bottom sheets, and integrated home-screen AI chatbot API; prepared TestFlight and Android staging builds.")

    # Projects 5, 6, 7 (Summary bullets for clean density)
    add_bullet_point(doc, "5. Reutbyitforme App (Migration):", "Upgraded legacy codebase from Flutter 3.10 to 3.32; modernized dependencies (Firebase Messaging, modern flutter_inappwebview with WebUri, Android Gradle 8+, namespace requirements, and external browser link routing).")
    add_bullet_point(doc, "6. Milos Paddle App (Sports Booking):", "Engineered multi-court and time-slot booking functionality with dynamic pricing calculations, availability validation, and payment API integrations.")
    add_bullet_point(doc, "7. Minder App (API Resiliency):", "Conducted deep-dive API diagnostic benchmarking between production and development environments, identifying timeout edge cases and resolving backend integration discrepancies.")

    # ------------------------------------------
    # DinJan Infotech Projects
    # ------------------------------------------
    p_sec_dinjan = doc.add_paragraph()
    p_sec_dinjan.paragraph_format.space_before = Pt(6)
    p_sec_dinjan.paragraph_format.space_after = Pt(2)
    p_sec_dinjan.paragraph_format.keep_with_next = True
    r_sd = p_sec_dinjan.add_run("DINJAN INFOTECH PROJECTS")
    r_sd.font.bold = True
    r_sd.font.size = Pt(10)
    r_sd.font.color.rgb = RGB_NAVY

    # Project: The Healthi Indian
    p_hi = doc.add_paragraph()
    p_hi.paragraph_format.space_before = Pt(3)
    p_hi.paragraph_format.space_after = Pt(1)
    p_hi.paragraph_format.keep_with_next = True
    r_hi = p_hi.add_run("1. The Healthi Indian — Health & Nutrition Platform (Google Play & App Store)")
    r_hi.font.bold = True
    r_hi.font.size = Pt(9.8)

    p_hi_links = doc.add_paragraph()
    p_hi_links.paragraph_format.space_before = Pt(0)
    p_hi_links.paragraph_format.space_after = Pt(2)
    r_hi_tech = p_hi_links.add_run("Tech Stack: Flutter, Dart, GetX, REST APIs, SharedPreferences  |  ")
    r_hi_tech.font.size = Pt(8.5)
    r_hi_tech.font.color.rgb = RGB_SLATE
    add_hyperlink(p_hi_links, "Google Play Store", "https://play.google.com/store/apps/details?id=com.app.thehealthiindian&pli=1", color=HEX_BLUE)
    p_hi_links.add_run("  •  ").font.size = Pt(8.5)
    add_hyperlink(p_hi_links, "Apple App Store", "https://apps.apple.com/us/app/the-healthi-indian/id6738694566", color=HEX_BLUE)

    add_bullet_point(doc, "Health & Nutrition Platform:", "Architected macro-balanced vegetarian and vegan recipe platform; refactored state management from setState to GetX, redesigned UI, integrated REST APIs, and deployed to Google Play and Apple App Store.")

    # Project: Radio Spice
    p_rs = doc.add_paragraph()
    p_rs.paragraph_format.space_before = Pt(4)
    p_rs.paragraph_format.space_after = Pt(1)
    p_rs.paragraph_format.keep_with_next = True
    r_rs = p_rs.add_run("2. Radio Spice — Live Radio & Audio Streaming Platform (Google Play & App Store)")
    r_rs.font.bold = True
    r_rs.font.size = Pt(9.8)

    p_rs_links = doc.add_paragraph()
    p_rs_links.paragraph_format.space_before = Pt(0)
    p_rs_links.paragraph_format.space_after = Pt(2)
    r_rs_tech = p_rs_links.add_run("Tech Stack: Flutter, Dart, GetX, Firebase Cloud Messaging, Audio Playback, WebView  |  ")
    r_rs_tech.font.size = Pt(8.5)
    r_rs_tech.font.color.rgb = RGB_SLATE
    add_hyperlink(p_rs_links, "Google Play Store", "https://play.google.com/store/apps/details?id=com.app.audio_app&pcampaignid=web_share&pli=1", color=HEX_BLUE)
    p_rs_links.add_run("  •  ").font.size = Pt(8.5)
    add_hyperlink(p_rs_links, "Apple App Store", "https://apps.apple.com/in/app/radio-spice-nzpmt/id6737826716", color=HEX_BLUE)

    add_bullet_point(doc, "Streaming Audio App:", "Built live radio streaming application with background playback, YouTube/WhatsApp integration, Firebase push notifications, and bilingual support.")

    # Project: Agents Thrive
    p_at = doc.add_paragraph()
    p_at.paragraph_format.space_before = Pt(4)
    p_at.paragraph_format.space_after = Pt(1)
    p_at.paragraph_format.keep_with_next = True
    r_at = p_at.add_run("3. Agents Thrive — Real Estate Agent Productivity Suite (App Store)")
    r_at.font.bold = True
    r_at.font.size = Pt(9.8)

    p_at_links = doc.add_paragraph()
    p_at_links.paragraph_format.space_before = Pt(0)
    p_at_links.paragraph_format.space_after = Pt(2)
    r_at_tech = p_at_links.add_run("Tech Stack: Flutter, FlutterFlow, DocuSign API, PDF Viewer, Calendar Sync  |  ")
    r_at_tech.font.size = Pt(8.5)
    r_at_tech.font.color.rgb = RGB_SLATE
    add_hyperlink(p_at_links, "Apple App Store", "https://apps.apple.com/us/app/agent-thrive-app/id6467190612", color=HEX_BLUE)

    add_bullet_point(doc, "Productivity & E-Signature:", "Implemented secure biometric authentication, DocuSign contract integration, PDF generation/viewing, calendar synchronization, and production deployment.")

    # Project: FinPin & Others
    p_fp = doc.add_paragraph()
    p_fp.paragraph_format.space_before = Pt(4)
    p_fp.paragraph_format.space_after = Pt(1)
    p_fp.paragraph_format.keep_with_next = True
    r_fp = p_fp.add_run("4. FinPin — Personal Finance & Goal Tracking App (App Store)")
    r_fp.font.bold = True
    r_fp.font.size = Pt(9.8)

    p_fp_links = doc.add_paragraph()
    p_fp_links.paragraph_format.space_before = Pt(0)
    p_fp_links.paragraph_format.space_after = Pt(2)
    r_fp_tech = p_fp_links.add_run("Tech Stack: FlutterFlow, Firebase, Google/Apple Sign-In, Interactive Charts  |  ")
    r_fp_tech.font.size = Pt(8.5)
    r_fp_tech.font.color.rgb = RGB_SLATE
    add_hyperlink(p_fp_links, "Apple App Store", "https://apps.apple.com/in/app/finpin/id6727005412", color=HEX_BLUE)

    add_bullet_point(doc, "Finance Tracking:", "Built expense/income timelines (weekly, monthly, yearly), financial target trackers, and interactive chart visualizations.")
    add_bullet_point(doc, "5. Disporata & Inspire4Goal:", "Developed location-based social app (Disporata) with Google Places and distance calculation; developed quotes app (Inspire4Goal) with multi-language localization (EN/NL) and scheduled notifications.")

    # ------------------------------------------
    # White Orange Software Projects
    # ------------------------------------------
    p_sec_wo = doc.add_paragraph()
    p_sec_wo.paragraph_format.space_before = Pt(6)
    p_sec_wo.paragraph_format.space_after = Pt(2)
    p_sec_wo.paragraph_format.keep_with_next = True
    r_swo = p_sec_wo.add_run("WHITE ORANGE SOFTWARE PROJECTS")
    r_swo.font.bold = True
    r_swo.font.size = Pt(10)
    r_swo.font.color.rgb = RGB_NAVY

    # FineAway
    p_fa = doc.add_paragraph()
    p_fa.paragraph_format.space_before = Pt(3)
    p_fa.paragraph_format.space_after = Pt(1)
    p_fa.paragraph_format.keep_with_next = True
    r_fa = p_fa.add_run("1. FineAway — Traffic Fine Resolution & License Renewal (Google Play & App Store)")
    r_fa.font.bold = True
    r_fa.font.size = Pt(9.8)

    p_fa_links = doc.add_paragraph()
    p_fa_links.paragraph_format.space_before = Pt(0)
    p_fa_links.paragraph_format.space_after = Pt(2)
    r_fa_tech = p_fa_links.add_run("Tech Stack: Flutter, Dart, GetX, OCR Text Scanning, REST APIs  |  ")
    r_fa_tech.font.size = Pt(8.5)
    r_fa_tech.font.color.rgb = RGB_SLATE
    add_hyperlink(p_fa_links, "Google Play Store", "https://play.google.com/store/apps/details?id=com.app.fineaway&pcampaignid=web_share", color=HEX_BLUE)
    p_fa_links.add_run("  •  ").font.size = Pt(8.5)
    add_hyperlink(p_fa_links, "Apple App Store", "https://apps.apple.com/us/app/fineaway-app/id6467185920", color=HEX_BLUE)

    add_bullet_point(doc, "OCR License Scanning:", "Integrated camera-based OCR text recognition for automated vehicle license data extraction, fine resolution, and payment handling across Android and iOS.")

    # LC Banker & Wealth Management
    p_lc = doc.add_paragraph()
    p_lc.paragraph_format.space_before = Pt(4)
    p_lc.paragraph_format.space_after = Pt(1)
    p_lc.paragraph_format.keep_with_next = True
    r_lc = p_lc.add_run("2. Adroit Vantage — LC Banker & Wealth Management 2.0 (App Store)")
    r_lc.font.bold = True
    r_lc.font.size = Pt(9.8)

    p_lc_links = doc.add_paragraph()
    p_lc_links.paragraph_format.space_before = Pt(0)
    p_lc_links.paragraph_format.space_after = Pt(2)
    r_lc_tech = p_lc_links.add_run("Tech Stack: Flutter, GetX, Interactive Graphs, Calendar Events, REST APIs, Hive DB  |  ")
    r_lc_tech.font.size = Pt(8.5)
    r_lc_tech.font.color.rgb = RGB_SLATE
    add_hyperlink(p_lc_links, "Wealth Management App Store", "https://apps.apple.com/us/app/wealth-management-2-0/id1672260039", color=HEX_BLUE)

    add_bullet_point(doc, "Private Banking & Wealth Management:", "Engineered financial portfolio interfaces for high-net-worth clients with responsive equity/bond charting, calendar events, and real-time chat.")

    # Muvr
    p_muvr = doc.add_paragraph()
    p_muvr.paragraph_format.space_before = Pt(4)
    p_muvr.paragraph_format.space_after = Pt(1)
    p_muvr.paragraph_format.keep_with_next = True
    r_muvr = p_muvr.add_run("3. Muvr — On-Demand Moving & Furniture Delivery Marketplace (App Store)")
    r_muvr.font.bold = True
    r_muvr.font.size = Pt(9.8)

    p_muvr_links = doc.add_paragraph()
    p_muvr_links.paragraph_format.space_before = Pt(0)
    p_muvr_links.paragraph_format.space_after = Pt(2)
    r_muvr_tech = p_muvr_links.add_run("Tech Stack: Flutter, GetX, Google Maps, Location Tracking, REST APIs  |  ")
    r_muvr_tech.font.size = Pt(8.5)
    r_muvr_tech.font.color.rgb = RGB_SLATE
    add_hyperlink(p_muvr_links, "Muvr Customer App", "https://apps.apple.com/us/app/muvr-get-furniture-delivery/id6450030781", color=HEX_BLUE)
    p_muvr_links.add_run("  •  ").font.size = Pt(8.5)
    add_hyperlink(p_muvr_links, "Muvr Driver App", "https://apps.apple.com/us/app/muvr-for-movers-earn-money/id6450041017", color=HEX_BLUE)

    add_bullet_point(doc, "On-Demand Moving Logistics:", "Developed booking workflows, dynamic dispatch, and real-time tracking across customer and driver applications.")
    add_bullet_point(doc, "4. AV Social & Mdsty:", "Built social media app (AV Social) with live feed, polls, media sharing, and Hive DB; built German e-commerce app (Mdsty) with MVC architecture and local language support.")

    # ==========================================
    # 6. EDUCATION
    # ==========================================
    add_section_header(doc, "Education")

    t_edu = doc.add_table(rows=2, cols=2)
    t_edu.alignment = WD_TABLE_ALIGNMENT.CENTER
    t_edu.autofit = False

    # MCA
    row0 = t_edu.rows[0]
    cell_mca = row0.cells[0]
    cell_mca.width = Inches(3.6)
    set_cell_margins(cell_mca, top=40, bottom=40, left=50, right=50)
    p_m1 = cell_mca.paragraphs[0]
    p_m1.paragraph_format.space_before = Pt(0)
    p_m1.paragraph_format.space_after = Pt(1)
    r_m1 = p_m1.add_run("Master of Computer Applications (MCA)")
    r_m1.font.bold = True
    r_m1.font.size = Pt(9.5)
    r_m1.font.color.rgb = RGB_NAVY

    p_m2 = cell_mca.add_paragraph()
    p_m2.paragraph_format.space_before = Pt(0)
    p_m2.paragraph_format.space_after = Pt(1)
    r_m2 = p_m2.add_run("Sarvajanik College of Engineering & Technology\nGujarat Technological University (GTU) • Surat, India")
    r_m2.font.size = Pt(8.5)
    r_m2.font.color.rgb = RGB_SLATE

    p_m3 = cell_mca.add_paragraph()
    p_m3.paragraph_format.space_before = Pt(0)
    p_m3.paragraph_format.space_after = Pt(0)
    r_m3 = p_m3.add_run("Dec 2020 – May 2022  |  Distinction (CGPA: 7.61)")
    r_m3.font.bold = True
    r_m3.font.size = Pt(8.5)
    r_m3.font.color.rgb = RGB_BLUE

    # BCA
    cell_bca = row0.cells[1]
    cell_bca.width = Inches(3.6)
    set_cell_margins(cell_bca, top=40, bottom=40, left=50, right=50)
    p_b1 = cell_bca.paragraphs[0]
    p_b1.paragraph_format.space_before = Pt(0)
    p_b1.paragraph_format.space_after = Pt(1)
    r_b1 = p_b1.add_run("Bachelor of Computer Applications (BCA)")
    r_b1.font.bold = True
    r_b1.font.size = Pt(9.5)
    r_b1.font.color.rgb = RGB_NAVY

    p_b2 = cell_bca.add_paragraph()
    p_b2.paragraph_format.space_before = Pt(0)
    p_b2.paragraph_format.space_after = Pt(1)
    r_b2 = p_b2.add_run("Vivekanand College for Advance Computer & Info. Science\nVeer Narmad South Gujarat University (VNSGU) • Surat, India")
    r_b2.font.size = Pt(8.5)
    r_b2.font.color.rgb = RGB_SLATE

    p_b3 = cell_bca.add_paragraph()
    p_b3.paragraph_format.space_before = Pt(0)
    p_b3.paragraph_format.space_after = Pt(0)
    r_b3 = p_b3.add_run("Jun 2017 – Mar 2020  |  Distinction (CGPA: 7.39)")
    r_b3.font.bold = True
    r_b3.font.size = Pt(8.5)
    r_b3.font.color.rgb = RGB_BLUE

    # Empty second row for spacing or cleanup
    t_edu._tbl.remove(t_edu.rows[1]._tr)

    # ==========================================
    # 7. HONORS & AWARDS
    # ==========================================
    add_section_header(doc, "Honors & Awards")

    p_awd = doc.add_paragraph()
    p_awd.paragraph_format.space_before = Pt(3)
    p_awd.paragraph_format.space_after = Pt(5)
    r_awd_t = p_awd.add_run("🏆 Code Craft Excellence Award (2025) — Logix Built Solutions Limited\n")
    r_awd_t.font.bold = True
    r_awd_t.font.size = Pt(9.5)
    r_awd_t.font.color.rgb = RGB_NAVY

    r_awd_d = p_awd.add_run(
        "Awarded in recognition of exceptional code craftsmanship, modular architecture design, and outstanding engineering delivery "
        "across enterprise cross-platform mobile and web applications."
    )
    r_awd_d.font.size = Pt(9)
    r_awd_d.font.color.rgb = RGB_BODY

    # ==========================================
    # 8. LANGUAGES
    # ==========================================
    add_section_header(doc, "Languages")
    p_lang = doc.add_paragraph()
    p_lang.paragraph_format.space_before = Pt(2)
    p_lang.paragraph_format.space_after = Pt(6)
    r_l = p_lang.add_run("English  (Professional Proficiency)  •  Hindi  (Professional Working)  •  Gujarati  (Native)")
    r_l.font.size = Pt(9.2)
    r_l.font.color.rgb = RGB_BODY

    # Save to targets
    OUTPUT_DOCX.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_DOCX_ASSETS.parent.mkdir(parents=True, exist_ok=True)

    doc.save(OUTPUT_DOCX)
    doc.save(OUTPUT_DOCX_ASSETS)

    print(f"SUCCESS: Generated Word document at {OUTPUT_DOCX} ({OUTPUT_DOCX.stat().st_size} bytes)")
    print(f"SUCCESS: Copied to {OUTPUT_DOCX_ASSETS}")


if __name__ == "__main__":
    build_docx()
