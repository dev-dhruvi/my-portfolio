import os
import math
import pypdfium2 as pdfium
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_resume_thumbnail():
    width = 1200
    height = 675

    # 1. Base Dark Canvas
    img = Image.new("RGBA", (width, height), (9, 13, 22, 255))
    draw = ImageDraw.Draw(img)

    # 2. Add subtle background ambient glow
    glow_overlay = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow_overlay)

    # Cyan ambient glow top-left
    for r in range(260, 40, -10):
        alpha = int(22 * (1 - r / 260))
        glow_draw.ellipse(
            (60 - r, 80 - r, 60 + r, 80 + r),
            fill=(6, 182, 212, alpha)
        )

    # Indigo/Sky ambient glow bottom-right
    for r in range(320, 50, -15):
        alpha = int(25 * (1 - r / 320))
        glow_draw.ellipse(
            (950 - r, 480 - r, 950 + r, 480 + r),
            fill=(99, 102, 241, alpha)
        )

    img = Image.alpha_composite(img, glow_overlay)
    draw = ImageDraw.Draw(img)

    # 3. Subtle grid lines / dots (very faint)
    grid_overlay = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    grid_draw = ImageDraw.Draw(grid_overlay)
    for x in range(40, width, 40):
        for y in range(40, height, 40):
            grid_draw.point((x, y), fill=(255, 255, 255, 12))
    img = Image.alpha_composite(img, grid_overlay)
    draw = ImageDraw.Draw(img)

    # 4. Render actual PDF page 1 and page 2
    pdf = pdfium.PdfDocument("web/resume.pdf")
    page1_raw = pdf[0].render(scale=3).to_pil()
    page2_raw = pdf[1].render(scale=3).to_pil() if len(pdf) > 1 else None

    # Target size for resume preview: height = 550px
    target_h = 550
    aspect = page1_raw.width / page1_raw.height
    target_w = int(target_h * aspect)  # ~388px

    page1_resized = page1_raw.resize((target_w, target_h), Image.LANCZOS)
    if page2_raw:
        page2_resized = page2_raw.resize((target_w, target_h), Image.LANCZOS)

    # Function to add rounded corners and subtle border
    def process_page(pil_page):
        corner_radius = 12
        mask = Image.new("L", pil_page.size, 0)
        mask_draw = ImageDraw.Draw(mask)
        mask_draw.rounded_rectangle((0, 0, pil_page.width, pil_page.height), radius=corner_radius, fill=255)
        
        output = Image.new("RGBA", pil_page.size, (0, 0, 0, 0))
        output.paste(pil_page, (0, 0), mask=mask)
        
        # Draw border
        border_draw = ImageDraw.Draw(output)
        border_draw.rounded_rectangle(
            (0, 0, pil_page.width - 1, pil_page.height - 1),
            radius=corner_radius,
            outline=(255, 255, 255, 80),
            width=2
        )
        return output

    p1_processed = process_page(page1_resized)
    p2_processed = process_page(page2_resized) if page2_raw else None

    # Positioning for resume document: right side
    # Canvas is 1200 wide. Left side takes 0..700. Right side takes 720..1150
    p1_x = 750
    p1_y = (height - target_h) // 2  # centered vertically (~62)

    # Drop shadow for page 2 (peek under page 1)
    if p2_processed:
        p2_x = p1_x + 30
        p2_y = p1_y - 18
        
        # Shadow for page 2
        p2_shadow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        s2_draw = ImageDraw.Draw(p2_shadow)
        s2_draw.rounded_rectangle((p2_x + 4, p2_y + 10, p2_x + target_w + 10, p2_y + target_h + 16), radius=16, fill=(0, 0, 0, 140))
        p2_shadow = p2_shadow.filter(ImageFilter.GaussianBlur(16))
        img = Image.alpha_composite(img, p2_shadow)
        
        # Paste page 2
        img.paste(p2_processed, (p2_x, p2_y), mask=p2_processed)

    # Multi-layered deep shadow for page 1
    p1_shadow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    s1_draw = ImageDraw.Draw(p1_shadow)
    # Ambient shadow
    s1_draw.rounded_rectangle((p1_x - 10, p1_y + 10, p1_x + target_w + 10, p1_y + target_h + 24), radius=20, fill=(0, 0, 0, 180))
    p1_shadow = p1_shadow.filter(ImageFilter.GaussianBlur(24))
    img = Image.alpha_composite(img, p1_shadow)

    # Direct contact shadow
    p1_c_shadow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    cs_draw = ImageDraw.Draw(p1_c_shadow)
    cs_draw.rounded_rectangle((p1_x + 4, p1_y + 12, p1_x + target_w - 4, p1_y + target_h + 16), radius=14, fill=(0, 0, 0, 210))
    p1_c_shadow = p1_c_shadow.filter(ImageFilter.GaussianBlur(10))
    img = Image.alpha_composite(img, p1_c_shadow)

    # Paste page 1
    img.paste(p1_processed, (p1_x, p1_y), mask=p1_processed)
    draw = ImageDraw.Draw(img)

    # Add a glowing badge over the top corner of the resume: "2-PAGE VERIFIED"
    badge_w, badge_h = 130, 32
    badge_x = p1_x + target_w - badge_w - 14
    badge_y = p1_y + 14
    draw.rounded_rectangle((badge_x, badge_y, badge_x + badge_w, badge_y + badge_h), radius=16, fill=(15, 23, 42, 230), outline=(56, 189, 248, 180), width=1)
    
    font_badge = ImageFont.truetype("C:/Windows/Fonts/segoeuib.ttf", 12)
    draw.ellipse((badge_x + 12, badge_y + 12, badge_x + 18, badge_y + 18), fill=(56, 189, 248, 255))
    draw.text((badge_x + 26, badge_y + 8), "2-PAGE CV", font=font_badge, fill=(241, 245, 249, 255))

    # 5. Left Side: Content & Typography
    font_pill = ImageFont.truetype("C:/Windows/Fonts/segoeuib.ttf", 13)
    font_name = ImageFont.truetype("C:/Windows/Fonts/segoeuib.ttf", 46)
    font_title = ImageFont.truetype("C:/Windows/Fonts/segoeuib.ttf", 25)
    font_sub = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf", 16)
    font_bullet = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf", 17)
    font_bullet_bold = ImageFont.truetype("C:/Windows/Fonts/segoeuib.ttf", 17)
    font_btn = ImageFont.truetype("C:/Windows/Fonts/segoeuib.ttf", 17)
    font_url = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf", 14)

    left_x = 75
    cur_y = 65

    # Top Pill: "OFFICIAL RESUME • VERIFIED PROFILE"
    pill_text = "OFFICIAL RESUME • VERIFIED PROFILE"
    pill_box_w = 280
    pill_box_h = 32
    draw.rounded_rectangle(
        (left_x, cur_y, left_x + pill_box_w, cur_y + pill_box_h),
        radius=16,
        fill=(15, 23, 42, 210),
        outline=(56, 189, 248, 120),
        width=1
    )
    # Dot inside pill
    draw.ellipse((left_x + 14, cur_y + 11, left_x + 22, cur_y + 19), fill=(16, 185, 129, 255))  # Green live dot
    draw.text((left_x + 30, cur_y + 7), pill_text, font=font_pill, fill=(56, 189, 248, 255))

    cur_y += 46

    # Candidate Name
    draw.text((left_x, cur_y), "Dhruvi Patel", font=font_name, fill=(255, 255, 255, 255))
    cur_y += 56

    # Title & Role
    draw.text((left_x, cur_y), "Senior Flutter Developer", font=font_title, fill=(56, 189, 248, 255))
    cur_y += 34
    draw.text((left_x, cur_y), "Mobile Application Engineer  |  Android • iOS • Web", font=font_sub, fill=(148, 163, 184, 255))
    cur_y += 28

    # Sleek Accent Divider with Cyan Gradient
    div_w = 580
    for i in range(div_w):
        alpha = int(180 * (1 - i / div_w))
        draw.point((left_x + i, cur_y), fill=(56, 189, 248, alpha))
        draw.point((left_x + i, cur_y + 1), fill=(99, 102, 241, int(alpha * 0.6)))
    cur_y += 24

    # Bullet Highlights
    bullets = [
        ("4+ Years Experience", "building scalable Android, iOS & Web apps"),
        ("50+ Production Releases", "across Google Play & Apple App Store"),
        ("Clean Architecture & GetX", "with robust modular repository design"),
        ("Real-Time Systems", "AWS IoT Core (MQTT) & Firebase Cloud Messaging"),
        ("Code Craft Excellence Award", "honored for code quality & craftsmanship (2025)")
    ]

    for title, desc in bullets:
        # Checkmark Icon Pill
        draw.rounded_rectangle((left_x, cur_y + 2, left_x + 20, cur_y + 22), radius=6, fill=(14, 165, 233, 40), outline=(56, 189, 248, 180), width=1)
        # Checkmark tick
        draw.line((left_x + 5, cur_y + 12, left_x + 9, cur_y + 17), fill=(56, 189, 248, 255), width=2)
        draw.line((left_x + 9, cur_y + 17, left_x + 16, cur_y + 8), fill=(56, 189, 248, 255), width=2)

        # Title bold + normal desc
        draw.text((left_x + 30, cur_y), title, font=font_bullet_bold, fill=(241, 245, 249, 255))
        # Measure title width
        bbox = draw.textbbox((left_x + 30, cur_y), title, font=font_bullet_bold)
        title_w = bbox[2] - bbox[0]
        
        draw.text((left_x + 36 + title_w, cur_y), f"– {desc}", font=font_bullet, fill=(148, 163, 184, 255))
        cur_y += 33

    cur_y += 18

    # CTA Action Button: "[ 📥 Click Card to View & Download PDF ]"
    btn_w = 400
    btn_h = 48
    draw.rounded_rectangle(
        (left_x, cur_y, left_x + btn_w, cur_y + btn_h),
        radius=24,
        fill=(2, 132, 199, 255),
        outline=(56, 189, 248, 255),
        width=1
    )
    # Download icon inside button
    icon_x = left_x + 28
    icon_y = cur_y + 15
    draw.line((icon_x + 8, icon_y + 2, icon_x + 8, icon_y + 14), fill=(255, 255, 255, 255), width=2)
    draw.line((icon_x + 3, icon_y + 9, icon_x + 8, icon_y + 14), fill=(255, 255, 255, 255), width=2)
    draw.line((icon_x + 13, icon_y + 9, icon_x + 8, icon_y + 14), fill=(255, 255, 255, 255), width=2)
    draw.line((icon_x + 2, icon_y + 18, icon_x + 14, icon_y + 18), fill=(255, 255, 255, 255), width=2)

    draw.text((left_x + 58, cur_y + 12), "Click Card to View & Download PDF", font=font_btn, fill=(255, 255, 255, 255))

    # Portfolio domain note under button
    draw.text((left_x + 420, cur_y + 16), "dev-dhruvi.github.io/my-portfolio", font=font_url, fill=(100, 116, 139, 255))

    # Save final image
    os.makedirs("assets/images", exist_ok=True)
    out_path = "assets/images/resume_featured_thumbnail.png"
    img.save(out_path, "PNG", quality=95)
    print(f"Generated successfully: {out_path} ({width}x{height})")

if __name__ == "__main__":
    create_resume_thumbnail()
