import json
import os
import base64
from PIL import Image
from io import BytesIO

code_js_path = r"D:\PROJECTS\Spotter\spotter\figma-plugin\code.js"

# ============================================================
# PREMIUM DESIGN SYSTEM — Airbnb × Uber × Pinterest × Linear
# ============================================================

# Deep, rich background with subtle warmth (not dead black)
C_BG_DEEP    = {"r": 0.035, "g": 0.027, "b": 0.055}    # #09071E — deep navy-black
C_BG         = {"r": 0.047, "g": 0.039, "b": 0.071}    # #0C0A12 — rich dark
C_SURFACE    = {"r": 0.075, "g": 0.063, "b": 0.114}    # #13101D — elevated surface
C_CARD       = {"r": 0.098, "g": 0.082, "b": 0.149}    # #191526 — card layer
C_CARD_HOVER = {"r": 0.122, "g": 0.102, "b": 0.184}    # #1F1A2F — hover/active

# Primary: Vibrant coral-red (Pinterest-inspired, warmer than pure red)
C_PRIMARY       = {"r": 0.933, "g": 0.180, "b": 0.275}  # #EE2E46
C_PRIMARY_LIGHT = {"r": 1.0,   "g": 0.333, "b": 0.400}  # #FF5566
C_PRIMARY_DARK  = {"r": 0.710, "g": 0.075, "b": 0.176}  # #B5132D
C_PRIMARY_GLOW  = {"r": 1.0,   "g": 0.267, "b": 0.353, "a": 0.20}  # glow shadow

# Accent: Electric violet-blue (Linear-inspired)
C_ACCENT       = {"r": 0.376, "g": 0.310, "b": 1.0}    # #604FFF
C_ACCENT_LIGHT = {"r": 0.533, "g": 0.467, "b": 1.0}    # #8877FF
C_ACCENT_GLOW  = {"r": 0.376, "g": 0.310, "b": 1.0, "a": 0.15}

# Success: Rich emerald
C_GREEN      = {"r": 0.118, "g": 0.820, "b": 0.443}    # #1ED171
C_GREEN_DARK = {"r": 0.059, "g": 0.302, "b": 0.169}    # #0F4D2B
C_GREEN_GLOW = {"r": 0.118, "g": 0.820, "b": 0.443, "a": 0.15}

# Warning: Warm amber-gold
C_AMBER      = {"r": 1.0,   "g": 0.694, "b": 0.216}    # #FFB137
C_AMBER_DARK = {"r": 0.302, "g": 0.208, "b": 0.067}    # #4D3511

# Text hierarchy
C_WHITE      = {"r": 1.0,   "g": 1.0,   "b": 1.0}
C_TEXT_PRI   = {"r": 0.953, "g": 0.941, "b": 0.973}     # #F3F0F8 — primary text
C_TEXT_SEC   = {"r": 0.600, "g": 0.561, "b": 0.690}     # #998FB0 — secondary
C_TEXT_TER   = {"r": 0.420, "g": 0.380, "b": 0.510}     # #6B6182 — tertiary
C_TEXT_MUTED = {"r": 0.302, "g": 0.271, "b": 0.376}     # #4D4560 — muted

# Glass & overlay
C_GLASS      = {"r": 1.0,   "g": 1.0,   "b": 1.0, "a": 0.06}
C_GLASS_EDGE = {"r": 1.0,   "g": 1.0,   "b": 1.0, "a": 0.12}
C_OVERLAY    = {"r": 0.0,   "g": 0.0,   "b": 0.0, "a": 0.50}

# Borders
C_BORDER     = {"r": 1.0,   "g": 1.0,   "b": 1.0, "a": 0.08}
C_BORDER_ACC = {"r": 0.376, "g": 0.310, "b": 1.0, "a": 0.25}

# Radii — generous, premium
R_XS     = 8
R_SM     = 12
R_MD     = 16
R_LG     = 20
R_XL     = 24
R_XXL    = 28
R_FULL   = 100

SCREEN_W = 390
SCREEN_H = 844

# ============================================================
# ASSET LOADING
# ============================================================
def load_png_as_base64(filepath, max_size=400):
    if not os.path.exists(filepath):
        print(f"Warning: {filepath} not found.")
        return ""
    try:
        img = Image.open(filepath)
        img.thumbnail((max_size, max_size), Image.Resampling.LANCZOS)
        buf = BytesIO()
        img.save(buf, format="PNG", optimize=True)
        return base64.b64encode(buf.getvalue()).decode('utf-8')
    except Exception as e:
        print(f"Error loading {filepath}: {e}")
        return ""

print("Loading PNG assets at high quality...")
car_img = load_png_as_base64("Car.png", 400)
bike_img = load_png_as_base64("Bike.png", 400)
parcel_img = load_png_as_base64("Parcel.png", 400)
rikshaw_img = load_png_as_base64("Rikshaw.png", 400)
calendar_img = load_png_as_base64("Calendar.png", 400)
safety_img = load_png_as_base64("safety.png", 400)
verification_img = load_png_as_base64("verification.png", 400)
route_img = load_png_as_base64("route.png", 400)
car_clock_img = load_png_as_base64("Car_Clock.png", 400)
bike_clock_img = load_png_as_base64("Bike_Clock.png", 400)
rikshaw_clock_img = load_png_as_base64("Rikshaw_Clock.png", 400)
print("All assets loaded successfully.")

# ============================================================
# COMPONENT PRIMITIVES
# ============================================================

def rect(x, y, w, h, fill, r=0, name="Rect", blur=False, shadow=False, shadow_color=None, shadow_offset=None, shadow_radius=None, opacity=None, stroke=None, stroke_width=None):
    node = {
        "type": "rect",
        "x": x, "y": y,
        "width": w, "height": h,
        "fill": fill,
        "cornerRadius": r,
        "hasBlur": blur,
        "hasShadow": shadow,
        "name": name
    }
    if shadow_color:
        node["shadowColor"] = shadow_color
    if shadow_offset:
        node["shadowOffset"] = shadow_offset
    if shadow_radius:
        node["shadowRadius"] = shadow_radius
    if opacity is not None:
        node["opacity"] = opacity
    if stroke:
        node["stroke"] = stroke
    if stroke_width:
        node["strokeWidth"] = stroke_width
    return node

def gradient_rect(x, y, w, h, stops, r=0, name="GradientRect", direction="vertical", shadow=False, shadow_color=None, shadow_radius=None, blur=False, stroke=None, stroke_width=None):
    """Multi-stop gradient rectangle — the core premium element"""
    node = {
        "type": "rect",
        "x": x, "y": y,
        "width": w, "height": h,
        "gradientStops": stops,  # list of {"position": 0-1, "color": {r,g,b,a}}
        "gradientDirection": direction,  # vertical, horizontal, diagonal
        "cornerRadius": r,
        "hasShadow": shadow,
        "hasBlur": blur,
        "name": name
    }
    if shadow_color:
        node["shadowColor"] = shadow_color
    if shadow_radius:
        node["shadowRadius"] = shadow_radius
    if stroke:
        node["stroke"] = stroke
    if stroke_width:
        node["strokeWidth"] = stroke_width
    return node

def gradient_card(x, y, w, h, color1, color2, r=R_XL, name="GradientCard", blur=False, shadow=True, shadow_color=None, stroke=None, stroke_width=None):
    node = {
        "type": "rect",
        "x": x, "y": y,
        "width": w, "height": h,
        "color1": color1,
        "color2": color2,
        "cornerRadius": r,
        "hasBlur": blur,
        "hasShadow": shadow,
        "name": name
    }
    if shadow_color:
        node["shadowColor"] = shadow_color
    if stroke:
        node["stroke"] = stroke
    if stroke_width:
        node["strokeWidth"] = stroke_width
    return node

def glass_panel(x, y, w, h, r=R_XL, name="GlassPanel", opacity=0.06):
    """Glassmorphism panel with blur + translucent fill + subtle border"""
    return rect(x, y, w, h, {"r": 1.0, "g": 1.0, "b": 1.0, "a": opacity}, r, name, blur=True, shadow=True,
                shadow_color={"r": 0, "g": 0, "b": 0, "a": 0.25}, shadow_radius=30,
                stroke={"r": 1.0, "g": 1.0, "b": 1.0, "a": 0.10}, stroke_width=1)

def image_node(x, y, w, h, base64_str, r=0, name="Image", shadow=False, shadow_color=None):
    node = {
        "type": "rect",
        "x": x, "y": y,
        "width": w, "height": h,
        "base64": base64_str,
        "cornerRadius": r,
        "name": name,
        "hasShadow": shadow
    }
    if shadow_color:
        node["shadowColor"] = shadow_color
    return node

def text(x, y, txt, size=14, color=None, weight="Regular", name="Text", w=None, align="LEFT", letter_spacing=None, line_height=None):
    if color is None:
        color = C_TEXT_PRI
    node = {
        "type": "text",
        "x": x, "y": y,
        "text": txt,
        "fontSize": size,
        "color": color,
        "font": {"family": "Inter", "style": weight},
        "name": name,
        "width": w,
        "align": align
    }
    if letter_spacing is not None:
        node["letterSpacing"] = letter_spacing
    if line_height is not None:
        node["lineHeight"] = line_height
    return node

def button(x, y, w, h, txt, fill=None, txt_color=None, size=15, r=R_MD, name="Button", shadow=False, shadow_color=None):
    if fill is None:
        fill = C_PRIMARY
    if txt_color is None:
        txt_color = C_WHITE
    node = {
        "type": "button",
        "x": x, "y": y,
        "width": w, "height": h,
        "text": txt,
        "fill": fill,
        "textColor": txt_color,
        "fontSize": size,
        "cornerRadius": r,
        "name": name,
        "font": {"family": "Inter", "style": "Bold"},
        "hasShadow": shadow
    }
    if shadow_color:
        node["shadowColor"] = shadow_color
    return node

def chip(x, y, w, h, txt, fill=None, txt_color=None, size=12, r=R_FULL, name="Chip", stroke=None):
    if fill is None:
        fill = C_CARD
    if txt_color is None:
        txt_color = C_TEXT_PRI
    node = {
        "type": "chip",
        "x": x, "y": y,
        "width": w, "height": h,
        "text": txt,
        "fill": fill,
        "textColor": txt_color,
        "fontSize": size,
        "cornerRadius": r,
        "name": name,
        "font": {"family": "Inter", "style": "Medium"}
    }
    if stroke:
        node["stroke"] = stroke
    return node

# ============================================================
# PREMIUM COMPOUND COMPONENTS
# ============================================================

def status_bar():
    """iOS-style status bar"""
    return [
        text(34, 14, "9:41", 14, C_TEXT_PRI, "Semi Bold", "Time"),
        rect(290, 14, 20, 12, C_TEXT_PRI, 3, "Signal"),
        rect(315, 14, 16, 12, C_TEXT_PRI, 3, "WiFi"),
        rect(336, 15, 27, 11, C_TEXT_PRI, 3, "Battery"),
    ]

def dynamic_island():
    return rect(125, 8, 140, 37, {"r": 0, "g": 0, "b": 0}, 20, "Dynamic Island")

def premium_header(greeting, subtitle, has_avatar=True, has_notification=True):
    """Airbnb-style header with avatar + greeting"""
    children = []
    if has_avatar:
        # Avatar with gradient ring
        children.append(rect(24, 65, 52, 52, C_ACCENT, 26, "Avatar Ring"))
        children.append(rect(26, 67, 48, 48, C_BG, 24, "Avatar Inner"))
        children.append(text(26, 78, "AS", 16, C_ACCENT_LIGHT, "Bold", "Avatar Initials", w=48, align="CENTER"))
    
    tx = 88 if has_avatar else 24
    children.append(text(tx, 68, greeting, 22, C_TEXT_PRI, "Bold", "Greeting", letter_spacing=-0.5))
    children.append(text(tx, 94, subtitle, 13, C_TEXT_SEC, "Regular", "Subtitle"))
    
    if has_notification:
        # Notification bell with glow dot
        children.append(glass_panel(318, 68, 48, 48, 24, "Notif Button", 0.06))
        children.append(text(318, 78, "🔔", 18, C_WHITE, "Regular", "Bell Icon", w=48, align="CENTER"))
        children.append(rect(350, 68, 10, 10, C_PRIMARY, 5, "Notif Dot"))
    return children

def premium_search_bar(x, y, w=342, placeholder="Where are you heading?"):
    """Uber-style search bar with gradient border"""
    return [
        # Outer glow
        rect(x-1, y-1, w+2, 58, C_BORDER_ACC, R_LG, "Search Glow", shadow=True, shadow_color=C_ACCENT_GLOW, shadow_radius=20),
        # Inner
        rect(x, y, w, 56, C_SURFACE, R_LG-1, "Search Inner"),
        text(x+48, y+18, placeholder, 15, C_TEXT_TER, "Regular", "Search Placeholder"),
        rect(x+16, y+16, 24, 24, C_ACCENT, R_SM, "Search Icon Bg"),
        text(x+16, y+17, "🔍", 14, C_WHITE, "Regular", "Search Icon", w=24, align="CENTER"),
    ]

def bento_card(x, y, w, h, title, subtitle, img_b64=None, gradient_start=None, gradient_end=None, accent_color=None, r=R_XL, badge=None):
    """Pinterest-style bento grid card with rich visuals"""
    children = []
    
    if gradient_start and gradient_end:
        children.append(gradient_card(x, y, w, h, gradient_start, gradient_end, r, f"Bento {title}",
                        shadow=True, shadow_color={"r": gradient_start.get("r",0)*0.5, "g": gradient_start.get("g",0)*0.5, "b": gradient_start.get("b",0)*0.5, "a": 0.30},
                        stroke={"r": 1.0, "g": 1.0, "b": 1.0, "a": 0.08}, stroke_width=1))
    else:
        children.append(rect(x, y, w, h, C_CARD, r, f"Bento {title}", shadow=True,
                       shadow_color={"r": 0, "g": 0, "b": 0, "a": 0.3}, shadow_radius=20,
                       stroke=C_BORDER, stroke_width=1))
    
    children.append(text(x+20, y+20, title, 17, C_TEXT_PRI, "Bold", f"Bento Title {title}"))
    children.append(text(x+20, y+42, subtitle, 12, C_TEXT_SEC if not gradient_start else {"r":1,"g":0.85,"b":0.88}, "Regular", f"Bento Sub {title}", w=w-80))
    
    if img_b64:
        img_w = min(w-20, 140)
        img_h = min(h-50, 120)
        children.append(image_node(x+w-img_w-8, y+h-img_h-8, img_w, img_h, img_b64, r-4, f"Bento Img {title}"))
    
    if badge:
        children.append(chip(x+20, y+h-40, len(badge)*8+16, 24, badge, {"r":0,"g":0,"b":0,"a":0.4}, C_WHITE, 10, R_FULL, f"Badge {badge}"))
    
    return children

def floating_nav(selected_index=0, mode="passenger"):
    """Premium floating glass navigation bar"""
    children = [
        # Outer glow
        rect(20, 752, 350, 72, {"r": 0.05, "g": 0.04, "b": 0.08, "a": 0.90}, R_XXL, "Nav Outer", blur=True, shadow=True,
             shadow_color={"r": 0, "g": 0, "b": 0, "a": 0.5}, shadow_radius=30,
             stroke=C_BORDER, stroke_width=1),
    ]
    
    if mode == "passenger":
        tabs = [("Home", "🏠"), ("Explore", "🧭"), ("Trips", "🚗"), ("Activity", "⚡"), ("Profile", "👤")]
    else:
        tabs = [("Dash", "📊"), ("Requests", "📬"), ("Trips", "🚗"), ("Vehicle", "🔧"), ("Profile", "👤")]
    
    tab_w = 310 // len(tabs)
    start_x = 40
    
    for i, (label, icon) in enumerate(tabs):
        tx = start_x + i * tab_w
        is_sel = (i == selected_index)
        
        if is_sel:
            # Selected: accent pill behind
            children.append(rect(tx-4, 762, tab_w-2, 42, C_PRIMARY, R_MD, f"Tab Active Bg",
                               shadow=True, shadow_color=C_PRIMARY_GLOW, shadow_radius=12))
            children.append(text(tx, 766, icon, 16, C_WHITE, "Regular", f"Tab Icon {label}", w=tab_w-8, align="CENTER"))
            children.append(text(tx, 786, label, 10, C_WHITE, "Bold", f"Tab Label {label}", w=tab_w-8, align="CENTER"))
        else:
            children.append(text(tx, 770, icon, 16, C_TEXT_TER, "Regular", f"Tab Icon {label}", w=tab_w-8, align="CENTER"))
            children.append(text(tx, 790, label, 9, C_TEXT_MUTED, "Medium", f"Tab Label {label}", w=tab_w-8, align="CENTER"))
    
    return children

def timeline_premium(x, y, steps, active_step=0):
    """Stripe-style timeline with glowing nodes"""
    children = []
    curr_y = y
    
    for i, (time_str, label, sub) in enumerate(steps):
        is_active = (i <= active_step)
        is_current = (i == active_step)
        
        # Node
        node_color = C_PRIMARY if is_active else C_CARD_HOVER
        if is_current:
            # Glowing pulse ring
            children.append(rect(x-6, curr_y-2, 28, 28, C_PRIMARY_GLOW, 14, f"Glow {i}"))
            children.append(rect(x, curr_y+2, 16, 16, C_PRIMARY, 8, f"Node {i}"))
            children.append(rect(x+4, curr_y+6, 8, 8, C_WHITE, 4, f"NodeInner {i}"))
        elif is_active:
            children.append(rect(x, curr_y+2, 16, 16, C_GREEN, 8, f"Node {i}"))
            children.append(text(x, curr_y+2, "✓", 10, C_WHITE, "Bold", f"Check {i}", w=16, align="CENTER"))
        else:
            children.append(rect(x, curr_y+2, 16, 16, C_CARD_HOVER, 8, f"Node {i}"))
        
        # Labels
        text_color = C_TEXT_PRI if is_active else C_TEXT_TER
        children.append(text(x+30, curr_y, label, 15, text_color, "Bold" if is_current else "Medium", f"Step {i}"))
        children.append(text(x+30, curr_y+22, f"{time_str} · {sub}", 12, C_TEXT_SEC, "Regular", f"Detail {i}"))
        
        # Connector line
        if i < len(steps) - 1:
            line_c = C_GREEN if is_active and not is_current else C_CARD_HOVER
            children.append(rect(x+7, curr_y+20, 2, 42, line_c, 1, f"Line {i}"))
        curr_y += 62
    return children

def verification_badges(x, y, w=342):
    """Modern verification display — no trust scores"""
    children = [
        rect(x, y, w, 160, C_CARD, R_XL, "Verify Card", shadow=True,
             shadow_color={"r":0,"g":0,"b":0,"a":0.2}, shadow_radius=16,
             stroke=C_BORDER, stroke_width=1),
        text(x+20, y+16, "VERIFIED CREDENTIALS", 10, C_TEXT_TER, "Bold", letter_spacing=2),
    ]
    
    badges = [
        ("Identity Verified", "✓", C_GREEN),
        ("Driving License Verified", "✓", C_GREEN),
        ("Vehicle RC Verified", "✓", C_GREEN),
    ]
    
    for i, (label, icon, color) in enumerate(badges):
        by = y + 42 + i * 28
        children.append(rect(x+20, by, 18, 18, {**color, "a": 0.15}, 9, f"Badge Bg {i}"))
        children.append(text(x+22, by+2, icon, 10, color, "Bold", f"Badge Icon {i}", w=14, align="CENTER"))
        children.append(text(x+46, by+1, label, 13, C_TEXT_PRI, "Medium", f"Badge Label {i}"))
    
    children.append(rect(x+20, y+130, w-40, 1, C_BORDER, 0, "Divider"))
    children.append(text(x+20, y+138, "147 Trips Completed · Member since Jan 2024", 11, C_TEXT_SEC, "Regular"))
    return children

def hero_gradient_bg(x, y, w, h, primary_color, secondary_color, name="Hero BG"):
    """Multi-layered gradient background for hero sections"""
    return [
        gradient_rect(x, y, w, h, [
            {"position": 0, "color": {**primary_color, "a": 1.0}},
            {"position": 0.5, "color": {"r": (primary_color["r"]+secondary_color["r"])/2, "g": (primary_color["g"]+secondary_color["g"])/2, "b": (primary_color["b"]+secondary_color["b"])/2, "a": 1.0}},
            {"position": 1.0, "color": {**secondary_color, "a": 1.0}},
        ], R_XL, name, "diagonal", shadow=True,
        shadow_color={"r": primary_color["r"]*0.5, "g": primary_color["g"]*0.5, "b": primary_color["b"]*0.5, "a": 0.35},
        shadow_radius=30,
        stroke={"r":1,"g":1,"b":1,"a":0.08}, stroke_width=1),
        # Noise overlay for texture
        rect(x, y, w, h, {"r":1,"g":1,"b":1,"a":0.03}, R_XL, f"{name} Texture"),
    ]

def metric_card(x, y, w, h, title, value, trend, trend_up=True, accent=None):
    """Fintech-style metric with sparkline"""
    if accent is None:
        accent = C_GREEN if trend_up else C_PRIMARY
    
    children = [
        rect(x, y, w, h, C_CARD, R_XL, f"Metric {title}", shadow=True,
             shadow_color={"r":0,"g":0,"b":0,"a":0.2}, shadow_radius=16,
             stroke=C_BORDER, stroke_width=1),
        text(x+20, y+16, title, 12, C_TEXT_TER, "Medium", letter_spacing=1),
        text(x+20, y+34, value, 26, C_TEXT_PRI, "Bold"),
    ]
    
    # Trend badge
    trend_bg = {**accent, "a": 0.12}
    trend_sign = "↑" if trend_up else "↓"
    children.append(rect(x+20, y+68, 80, 22, trend_bg, R_FULL, "Trend Pill"))
    children.append(text(x+28, y+71, f"{trend_sign} {trend}", 11, accent, "Bold"))
    
    # Sparkline bars
    heights = [12, 18, 10, 24, 16, 28, 20]
    for idx, bh in enumerate(heights):
        bx = x + w - 70 + idx * 8
        children.append(rect(bx, y + h - 20 - bh, 4, bh, {**accent, "a": 0.6 if idx < len(heights)-1 else 1.0}, 2, f"Spark {idx}"))
    
    return children

def premium_card(x, y, w, h, r=R_XL, name="Card"):
    """Standard elevated card with border + shadow"""
    return rect(x, y, w, h, C_CARD, r, name, shadow=True,
                shadow_color={"r":0,"g":0,"b":0,"a":0.25}, shadow_radius=20,
                stroke=C_BORDER, stroke_width=1)

# ============================================================
# SCREEN BUILDER
# ============================================================

def screen(name, x, y, children):
    return {
        "name": name,
        "x": x, "y": y,
        "width": SCREEN_W, "height": SCREEN_H,
        "fill": C_BG,
        "children": [dynamic_island()] + children
    }

screens = []

# ================================================================
# ROW 1: ONBOARDING & AUTH (y=0)
# ================================================================
y1 = 0

# --- SPLASH SCREEN ---
screens.append(screen("Splash Screen", 0, y1, [
    # Background ambient glow
    rect(95, 150, 200, 200, C_PRIMARY_GLOW, 100, "Ambient Glow 1"),
    rect(195, 350, 150, 150, C_ACCENT_GLOW, 75, "Ambient Glow 2"),
    
    # Logo with glow ring
    rect(145, 260, 100, 100, C_PRIMARY_GLOW, 50, "Logo Glow"),
    gradient_card(155, 270, 80, 80, C_PRIMARY, C_PRIMARY_LIGHT, 40, "Logo Circle"),
    text(155, 295, "S", 40, C_WHITE, "Bold", "Logo Letter", w=80, align="CENTER"),
    
    # Brand name
    text(24, 400, "Spott", 44, C_TEXT_PRI, "Bold", "Brand", w=342, align="CENTER", letter_spacing=-1.5),
    text(24, 455, "Premium cost-sharing travel\n& parcel delivery network", 16, C_TEXT_SEC, "Regular", "Tagline", w=342, align="CENTER"),
    
    # Primary CTA with glow shadow
    button(24, 630, 342, 56, "Get Started", C_PRIMARY, C_WHITE, 16, R_LG, "CTA Primary", shadow=True, shadow_color=C_PRIMARY_GLOW),
    button(24, 700, 342, 56, "Log In", C_SURFACE, C_TEXT_PRI, 16, R_LG, "CTA Secondary"),
    
    # Feature pills
    chip(24, 780, 110, 30, "💰 Cost Share", C_CARD, C_TEXT_SEC, 11, R_FULL, "Pill 1", stroke=C_BORDER),
    chip(142, 780, 110, 30, "🛡️ Safe Travel", C_CARD, C_TEXT_SEC, 11, R_FULL, "Pill 2", stroke=C_BORDER),
    chip(260, 780, 106, 30, "📦 Fast Parcel", C_CARD, C_TEXT_SEC, 11, R_FULL, "Pill 3", stroke=C_BORDER),
]))

# --- ROLE SELECTOR ---
screens.append(screen("Role Selector", 500, y1, [
    # Ambient glow
    rect(150, 60, 200, 200, C_ACCENT_GLOW, 100, "Ambient"),
    
    text(24, 75, "Choose your\njourney", 32, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    text(24, 148, "Select how you'd like to interact with Spott", 14, C_TEXT_SEC, "Regular", "Sub"),
    
    # Passenger Card — gradient hero with vehicle image
    *hero_gradient_bg(24, 190, 342, 140, C_PRIMARY, C_PRIMARY_DARK, "Pass Hero"),
    text(44, 210, "Passenger Mode", 20, C_WHITE, "Bold", "Pass Title"),
    text(44, 236, "Find cost-sharing rides\non your daily commute", 13, {"r":1,"g":0.88,"b":0.90}, "Regular", "Pass Sub", w=180),
    chip(44, 286, 100, 24, "🔥 Popular", {"r":0,"g":0,"b":0,"a":0.3}, C_WHITE, 10, R_FULL, "Pop Badge"),
    image_node(245, 195, 120, 120, car_img, 0, "Car Hero"),
    
    # Traveler Card
    premium_card(24, 350, 342, 130, R_XL, "Traveler Card"),
    text(44, 370, "Traveler Mode", 20, C_TEXT_PRI, "Bold", "Trav Title"),
    text(44, 396, "Share empty seats, offset\nyour fuel costs", 13, C_TEXT_SEC, "Regular", "Trav Sub", w=180),
    chip(44, 440, 140, 24, "🚗 Recover fuel cost", C_GREEN_DARK, C_GREEN, 10, R_FULL, "Earn Badge"),
    image_node(255, 355, 100, 100, bike_img, 0, "Bike Hero"),
    
    # Parcel Card
    premium_card(24, 500, 342, 130, R_XL, "Parcel Card"),
    text(44, 520, "Parcel Sender", 20, C_TEXT_PRI, "Bold", "Par Title"),
    text(44, 546, "Send packages via verified\ntravelers on their route", 13, C_TEXT_SEC, "Regular", "Par Sub", w=180),
    chip(44, 590, 130, 24, "📦 Same-day", C_AMBER_DARK, C_AMBER, 10, R_FULL, "Speed Badge"),
    image_node(255, 510, 100, 100, parcel_img, 0, "Parcel Hero"),
    
    button(24, 660, 342, 56, "Continue", C_PRIMARY, C_WHITE, 16, R_LG, "Continue CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
]))

# --- LOGIN ---
screens.append(screen("Login", 1000, y1, [
    rect(200, 30, 180, 180, C_ACCENT_GLOW, 90, "Ambient"),
    
    text(24, 90, "Welcome back", 32, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    text(24, 130, "Enter your mobile number to continue", 14, C_TEXT_SEC, "Regular", "Sub"),
    
    # Phone input with accent border
    rect(23, 195, 344, 60, C_BORDER_ACC, R_LG, "Input Glow"),
    rect(24, 196, 342, 58, C_SURFACE, R_LG-1, "Input Bg"),
    text(48, 216, "+91", 16, C_TEXT_PRI, "Bold", "Country"),
    rect(85, 210, 1, 30, C_BORDER, 0, "Divider"),
    text(100, 216, "98765 43210", 16, C_TEXT_PRI, "Medium", "Phone"),
    
    button(24, 280, 342, 56, "Request Access Code", C_PRIMARY, C_WHITE, 15, R_LG, "CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
    
    # Divider
    rect(24, 370, 150, 1, C_BORDER, 0, "Div L"),
    text(174, 363, "or", 13, C_TEXT_TER, "Regular", "Or", w=42, align="CENTER"),
    rect(216, 370, 150, 1, C_BORDER, 0, "Div R"),
    
    # Social buttons
    rect(24, 400, 342, 56, C_SURFACE, R_LG, "Google Btn", stroke=C_BORDER, stroke_width=1),
    text(24, 418, "Sign in with Google", 15, C_TEXT_PRI, "Medium", "Google Label", w=342, align="CENTER"),
    
    rect(24, 470, 342, 56, C_WHITE, R_LG, "Apple Btn"),
    text(24, 488, "Sign in with Apple", 15, {"r":0,"g":0,"b":0}, "Medium", "Apple Label", w=342, align="CENTER"),
]))

# --- OTP ---
screens.append(screen("OTP Verification", 1500, y1, [
    text(24, 90, "Enter Passcode", 32, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    text(24, 130, "4-digit code sent to +91 98765 43210", 14, C_TEXT_SEC, "Regular"),
    
    # OTP boxes with active state glow
    rect(24, 200, 75, 75, C_SURFACE, R_LG, "OTP 1", stroke=C_BORDER, stroke_width=1),
    text(24, 222, "4", 30, C_TEXT_PRI, "Bold", "D1", w=75, align="CENTER"),
    
    rect(114, 200, 75, 75, C_SURFACE, R_LG, "OTP 2", stroke=C_BORDER, stroke_width=1),
    text(114, 222, "8", 30, C_TEXT_PRI, "Bold", "D2", w=75, align="CENTER"),
    
    rect(204, 200, 75, 75, C_SURFACE, R_LG, "OTP 3", stroke=C_BORDER, stroke_width=1),
    text(204, 222, "2", 30, C_TEXT_PRI, "Bold", "D3", w=75, align="CENTER"),
    
    # Active OTP with accent border
    rect(293, 199, 77, 77, C_ACCENT, R_LG, "OTP 4 Glow", shadow=True, shadow_color=C_ACCENT_GLOW, shadow_radius=12),
    rect(294, 200, 75, 75, C_SURFACE, R_LG-1, "OTP 4"),
    rect(327, 230, 3, 20, C_ACCENT, 1, "Cursor"),
    
    button(24, 310, 342, 56, "Verify & Enter", C_PRIMARY, C_WHITE, 15, R_LG, "CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
    text(24, 390, "Resend code in 44s", 13, C_TEXT_TER, "Medium", "Resend", w=342, align="CENTER"),
]))

# ================================================================
# ROW 2: PASSENGER FLOW (y=1000)
# ================================================================
y2 = 1000

# --- PASSENGER HOME ---
screens.append(screen("Passenger Home", 0, y2, [
    # Subtle ambient glow at top
    rect(0, 0, 390, 200, {"r": 0.376, "g": 0.310, "b": 1.0, "a": 0.04}, 0, "Top Ambient"),
    
    *premium_header("Hey Amit 👋", "Pune, Maharashtra"),
    
    # Premium search bar
    *premium_search_bar(24, 135),
    
    # Recent routes
    text(24, 210, "RECENT ROUTES", 10, C_TEXT_TER, "Bold", "Section Label", letter_spacing=2),
    chip(24, 232, 140, 32, "⚡ Kolhapur → Pune", C_CARD, C_TEXT_PRI, 12, R_FULL, "Route 1", stroke=C_BORDER),
    chip(172, 232, 130, 32, "⚡ Pune → Mumbai", C_CARD, C_TEXT_PRI, 12, R_FULL, "Route 2", stroke=C_BORDER),
    
    # Bento Grid — visually rich
    *bento_card(24, 282, 170, 180, "Find Trip", "Cost-share\nshared rides", car_img, C_PRIMARY, C_PRIMARY_DARK, badge="Most Popular"),
    *bento_card(206, 282, 160, 120, "Send Parcel", "Fast same-day\ncourier", parcel_img, accent_color=C_AMBER),
    *bento_card(206, 414, 160, 120, "Weekly Pass", "Save up to 35%", calendar_img, accent_color=C_ACCENT),
    *bento_card(24, 474, 170, 120, "Safety Hub", "SOS & Live\nTracking", safety_img, accent_color=C_GREEN),
    
    # Active travelers section
    text(24, 614, "Active Commuters", 18, C_TEXT_PRI, "Bold", "Section Title"),
    text(280, 618, "See All →", 13, C_ACCENT_LIGHT, "Medium", "See All"),
    
    # Nearby trip card
    premium_card(24, 646, 342, 95, R_XL, "Trip Card"),
    rect(44, 662, 44, 44, C_SURFACE, 22, "Traveler Pic"),
    text(44, 670, "PK", 14, C_ACCENT_LIGHT, "Bold", "Initials", w=44, align="CENTER"),
    text(100, 658, "Pune → Mumbai", 16, C_TEXT_PRI, "Bold", "Trip Route"),
    text(100, 678, "Priya K. · Verna AC", 13, C_TEXT_SEC, "Medium", "Trip Detail"),
    text(100, 698, "Identity Verified ✓", 11, C_GREEN, "Medium", "Trust"),
    text(290, 658, "₹450", 20, C_PRIMARY_LIGHT, "Bold", "Price"),
    chip(290, 688, 52, 22, "★ 4.9", C_CARD_HOVER, C_AMBER, 10, R_FULL, "Rating"),
    
    *floating_nav(0, "passenger"),
]))

# --- PASSENGER EXPLORE ---
screens.append(screen("Passenger Explore", 500, y2, [
    # Map background
    rect(0, 0, 390, 844, C_SURFACE, 0, "Map BG"),
    rect(0, 0, 390, 130, C_BG, 0, "Top Shade"),
    
    text(24, 70, "Explore", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    # Search bar
    rect(24, 110, 342, 48, C_CARD, R_MD, "Search", stroke=C_BORDER, stroke_width=1),
    text(52, 124, "🔍 Search routes or cities…", 14, C_TEXT_TER, "Medium", "Placeholder"),
    
    # Map pins
    rect(100, 280, 44, 44, C_PRIMARY, 22, "Pin 1 Ring", shadow=True, shadow_color=C_PRIMARY_GLOW, shadow_radius=15),
    text(100, 290, "🚗", 18, C_WHITE, "Regular", "Pin 1 Icon", w=44, align="CENTER"),
    
    rect(230, 380, 44, 44, C_GREEN, 22, "Pin 2 Ring", shadow=True, shadow_color=C_GREEN_GLOW, shadow_radius=15),
    text(230, 390, "🏍️", 18, C_WHITE, "Regular", "Pin 2 Icon", w=44, align="CENTER"),
    
    rect(170, 440, 44, 44, C_ACCENT, 22, "Pin 3 Ring", shadow=True, shadow_color=C_ACCENT_GLOW, shadow_radius=15),
    text(170, 450, "📦", 18, C_WHITE, "Regular", "Pin 3 Icon", w=44, align="CENTER"),
    
    # Floating card at bottom
    glass_panel(16, 570, 358, 160, R_XL, "Selected Card", 0.08),
    rect(36, 590, 48, 48, C_SURFACE, 24, "Avatar"),
    text(36, 600, "VM", 14, C_ACCENT_LIGHT, "Bold", "Init", w=48, align="CENTER"),
    text(96, 588, "Pune-Mumbai Express", 17, C_TEXT_PRI, "Bold", "Name"),
    text(96, 610, "Vikram M. · Identity Verified ✓", 12, C_GREEN, "Medium", "Trust"),
    chip(96, 636, 75, 22, "★ 4.9", C_CARD_HOVER, C_AMBER, 10, R_FULL, "Rate"),
    chip(177, 636, 100, 22, "147 Trips", C_CARD_HOVER, C_TEXT_SEC, 10, R_FULL, "Count"),
    
    button(256, 680, 100, 38, "Request", C_PRIMARY, C_WHITE, 13, R_MD, "CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
    
    *floating_nav(1, "passenger"),
]))

# --- PASSENGER TRIPS ---
screens.append(screen("Passenger Trips", 1000, y2, [
    rect(0, 0, 390, 120, {"r":0.376,"g":0.310,"b":1.0,"a":0.03}, 0, "Ambient"),
    
    text(24, 70, "Your Trips", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    # Filter chips
    chip(24, 112, 100, 34, "Upcoming", C_PRIMARY, C_WHITE, 12, R_FULL, "Filter Active"),
    chip(130, 112, 80, 34, "History", C_CARD, C_TEXT_SEC, 12, R_FULL, "Filter 2", stroke=C_BORDER),
    chip(216, 112, 80, 34, "Parcels", C_CARD, C_TEXT_SEC, 12, R_FULL, "Filter 3", stroke=C_BORDER),
    
    # Upcoming trip card
    premium_card(24, 164, 342, 160, R_XL, "Trip Card"),
    chip(44, 180, 70, 22, "Tomorrow", C_ACCENT, C_WHITE, 10, R_FULL, "Time Badge"),
    text(44, 212, "Pune → Kolhapur", 20, C_TEXT_PRI, "Bold", "Route"),
    text(44, 238, "08:30 AM · 1 Seat Booked", 13, C_TEXT_SEC, "Regular", "Detail"),
    rect(44, 268, 302, 1, C_BORDER, 0, "Divider"),
    text(44, 280, "Traveler: Priya K. · License Verified ✓", 12, C_GREEN, "Medium", "Trust"),
    button(232, 274, 114, 36, "View Details", C_CARD_HOVER, C_TEXT_PRI, 12, R_MD, "CTA"),
    
    *floating_nav(2, "passenger"),
]))

# --- PASSENGER ACTIVITY ---
screens.append(screen("Passenger Activity", 1500, y2, [
    text(24, 70, "Activity", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    text(24, 115, "TODAY", 10, C_TEXT_TER, "Bold", "Date Section", letter_spacing=2),
    
    premium_card(24, 138, 342, 110, R_XL, "Activity 1"),
    rect(44, 158, 40, 40, C_GREEN_DARK, 20, "Icon Bg 1"),
    text(44, 166, "📦", 16, C_WHITE, "Regular", "Icon 1", w=40, align="CENTER"),
    text(94, 154, "Parcel Delivered", 16, C_TEXT_PRI, "Bold", "Title 1"),
    text(94, 176, "Documents to Mumbai Hub", 13, C_TEXT_SEC, "Regular", "Sub 1"),
    text(94, 198, "OTP Verified ✓ · 4:15 PM", 11, C_GREEN, "Medium", "Status 1"),
    
    text(24, 270, "LAST WEEK", 10, C_TEXT_TER, "Bold", "Date Section 2", letter_spacing=2),
    
    premium_card(24, 293, 342, 110, R_XL, "Activity 2"),
    rect(44, 313, 40, 40, {"r": 0.15, "g": 0.10, "b": 0.28}, 20, "Icon Bg 2"),
    text(44, 321, "🚗", 16, C_WHITE, "Regular", "Icon 2", w=40, align="CENTER"),
    text(94, 309, "Trip Completed", 16, C_TEXT_PRI, "Bold", "Title 2"),
    text(94, 331, "Pune → Lonavala · Fuel Split ₹180", 13, C_TEXT_SEC, "Regular", "Sub 2"),
    text(94, 353, "Completed · May 8, 11:30 AM", 11, C_ACCENT_LIGHT, "Medium", "Status 2"),
    
    *floating_nav(3, "passenger"),
]))

# --- PASSENGER PROFILE ---
screens.append(screen("Passenger Profile", 2000, y2, [
    # Profile ambient glow
    rect(120, 60, 150, 150, C_ACCENT_GLOW, 75, "Profile Glow"),
    
    text(24, 70, "Profile", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    # Avatar with gradient ring
    rect(152, 120, 86, 86, C_ACCENT, 43, "Ring"),
    rect(155, 123, 80, 80, C_BG, 40, "Inner"),
    text(155, 148, "AS", 22, C_ACCENT_LIGHT, "Bold", "Initials", w=80, align="CENTER"),
    
    text(24, 222, "Amit Sharma", 24, C_TEXT_PRI, "Bold", "Name", w=342, align="CENTER"),
    text(24, 252, "Member since January 2024", 13, C_TEXT_SEC, "Medium", "Since", w=342, align="CENTER"),
    
    *verification_badges(24, 285),
    
    # Settings menu
    premium_card(24, 465, 342, 56, R_LG, "Menu 1"),
    text(44, 483, "Personal Details", 15, C_TEXT_PRI, "Medium", "M1"),
    text(340, 483, "→", 15, C_TEXT_TER, "Regular", "Arrow 1"),
    
    premium_card(24, 531, 342, 56, R_LG, "Menu 2"),
    text(44, 549, "Payment & Split Settings", 15, C_TEXT_PRI, "Medium", "M2"),
    text(340, 549, "→", 15, C_TEXT_TER, "Regular", "Arrow 2"),
    
    premium_card(24, 597, 342, 56, R_LG, "Menu 3"),
    text(44, 615, "Route Alerts", 15, C_TEXT_PRI, "Medium", "M3"),
    chip(240, 612, 60, 22, "3 active", C_PRIMARY, C_WHITE, 10, R_FULL, "Alert Count"),
    text(340, 615, "→", 15, C_TEXT_TER, "Regular", "Arrow 3"),
    
    *floating_nav(4, "passenger"),
]))

# --- TRIP SEARCH SHEET ---
screens.append(screen("Trip Search Sheet", 2500, y2, [
    # Map area
    rect(0, 0, 390, 380, C_SURFACE, 0, "Map Area"),
    rect(100, 200, 14, 14, C_PRIMARY, 7, "Pin Origin", shadow=True, shadow_color=C_PRIMARY_GLOW),
    rect(260, 280, 14, 14, C_GREEN, 7, "Pin Dest", shadow=True, shadow_color=C_GREEN_GLOW),
    # Route line
    rect(107, 210, 2, 80, C_PRIMARY, 1, "Route Line"),
    
    # Bottom sheet
    rect(0, 340, 390, 504, C_BG, R_XXL, "Sheet", shadow=True, shadow_color={"r":0,"g":0,"b":0,"a":0.5}, shadow_radius=30),
    rect(170, 354, 50, 5, C_CARD_HOVER, 3, "Handle"),
    
    text(24, 380, "Find a Shared Trip", 24, C_TEXT_PRI, "Bold", "Title", letter_spacing=-0.5),
    
    # Route input card
    premium_card(24, 420, 342, 130, R_XL, "Route Input"),
    # Origin
    rect(48, 450, 14, 14, C_GREEN, 7, "Origin Dot"),
    text(72, 446, "Pune Station", 15, C_TEXT_PRI, "Medium", "Origin"),
    # Connector
    rect(54, 468, 2, 28, C_BORDER, 1, "Connector"),
    # Destination
    rect(48, 500, 14, 14, C_PRIMARY, 7, "Dest Dot"),
    text(72, 496, "Mumbai Airport (T2)", 15, C_TEXT_PRI, "Bold", "Dest"),
    
    # Quick locations
    chip(24, 570, 110, 32, "📍 Wakad", C_CARD, C_TEXT_SEC, 12, R_FULL, "Loc 1", stroke=C_BORDER),
    chip(142, 570, 120, 32, "📍 Hinjewadi", C_CARD, C_TEXT_SEC, 12, R_FULL, "Loc 2", stroke=C_BORDER),
    chip(270, 570, 96, 32, "📍 Baner", C_CARD, C_TEXT_SEC, 12, R_FULL, "Loc 3", stroke=C_BORDER),
    
    # Schedule
    text(24, 620, "SCHEDULE", 10, C_TEXT_TER, "Bold", "Schedule Label", letter_spacing=2),
    chip(24, 642, 90, 34, "📅 Today", C_PRIMARY, C_WHITE, 12, R_FULL, "Today"),
    chip(122, 642, 100, 34, "📅 Tomorrow", C_CARD, C_TEXT_SEC, 12, R_FULL, "Tomorrow", stroke=C_BORDER),
    chip(230, 642, 110, 34, "📅 Pick Date", C_CARD, C_TEXT_SEC, 12, R_FULL, "Custom", stroke=C_BORDER),
    
    button(24, 740, 342, 56, "Search Commuters", C_PRIMARY, C_WHITE, 16, R_LG, "Search CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
]))

# --- SEARCH RESULTS ---
screens.append(screen("Search Results", 3000, y2, [
    # Top bar
    rect(0, 0, 390, 130, C_SURFACE, 0, "Top Bar"),
    rect(0, 120, 390, 10, C_BG, 0, "Transition"),
    text(24, 65, "← Pune → Mumbai", 18, C_TEXT_PRI, "Bold", "Route"),
    text(24, 90, "Today, 10:30 AM · 1 Seat", 13, C_TEXT_SEC, "Regular", "Detail"),
    chip(280, 67, 86, 24, "3 results", C_ACCENT, C_WHITE, 10, R_FULL, "Count"),
    
    # Result Card 1 — Premium
    premium_card(24, 148, 342, 210, R_XL, "Result 1"),
    rect(44, 170, 50, 50, C_SURFACE, 25, "Avatar 1"),
    text(44, 180, "PK", 16, C_PRIMARY_LIGHT, "Bold", "Init 1", w=50, align="CENTER"),
    text(106, 170, "Priya K.", 18, C_TEXT_PRI, "Bold", "Name 1"),
    text(106, 194, "Identity & License Verified ✓", 12, C_GREEN, "Medium", "Trust 1"),
    chip(260, 170, 80, 24, "★ 4.9", C_CARD_HOVER, C_AMBER, 11, R_FULL, "Rate 1"),
    
    image_node(258, 206, 100, 100, car_img, R_MD, "Car 1"),
    text(44, 234, "Honda City AC · 2 seats left", 13, C_TEXT_SEC, "Regular", "Vehicle 1"),
    text(44, 258, "Route Match: 96%", 13, C_GREEN, "Bold", "Match 1"),
    
    rect(44, 284, 260, 1, C_BORDER, 0, "Divider 1"),
    text(44, 300, "₹450", 24, C_PRIMARY_LIGHT, "Bold", "Price 1"),
    text(100, 308, "per seat", 12, C_TEXT_TER, "Regular", "Per 1"),
    button(244, 296, 102, 40, "Request", C_PRIMARY, C_WHITE, 13, R_MD, "CTA 1", shadow=True, shadow_color=C_PRIMARY_GLOW),
    
    # Result Card 2
    premium_card(24, 376, 342, 210, R_XL, "Result 2"),
    rect(44, 398, 50, 50, C_SURFACE, 25, "Avatar 2"),
    text(44, 408, "RS", 16, C_ACCENT_LIGHT, "Bold", "Init 2", w=50, align="CENTER"),
    text(106, 398, "Rahul S.", 18, C_TEXT_PRI, "Bold", "Name 2"),
    text(106, 422, "Identity Verified ✓ · 89 Trips", 12, C_GREEN, "Medium", "Trust 2"),
    chip(260, 398, 80, 24, "★ 4.8", C_CARD_HOVER, C_AMBER, 11, R_FULL, "Rate 2"),
    
    image_node(258, 434, 100, 100, rikshaw_img, R_MD, "Auto 2"),
    text(44, 462, "Bajaj RE Auto · 1 seat left", 13, C_TEXT_SEC, "Regular", "Vehicle 2"),
    text(44, 486, "Route Match: 88%", 13, C_AMBER, "Bold", "Match 2"),
    
    rect(44, 512, 260, 1, C_BORDER, 0, "Divider 2"),
    text(44, 528, "₹250", 24, C_PRIMARY_LIGHT, "Bold", "Price 2"),
    text(100, 536, "per seat", 12, C_TEXT_TER, "Regular", "Per 2"),
    button(244, 524, 102, 40, "Request", C_PRIMARY, C_WHITE, 13, R_MD, "CTA 2"),
    
    *floating_nav(1, "passenger"),
]))

# --- TRIP DETAILS ---
screens.append(screen("Trip Details", 3500, y2, [
    # Map header
    rect(0, 0, 390, 220, C_SURFACE, 0, "Map Preview"),
    text(24, 20, "←", 24, C_TEXT_PRI, "Bold", "Back"),
    
    # Bottom sheet
    rect(0, 190, 390, 654, C_BG, R_XXL, "Detail Sheet", shadow=True, shadow_color={"r":0,"g":0,"b":0,"a":0.5}),
    rect(170, 204, 50, 5, C_CARD_HOVER, 3, "Handle"),
    
    # Traveler info
    rect(24, 230, 56, 56, C_SURFACE, 28, "Pic"),
    text(24, 242, "PK", 18, C_PRIMARY_LIGHT, "Bold", "Init", w=56, align="CENTER"),
    text(92, 236, "Priya K.", 20, C_TEXT_PRI, "Bold", "Name"),
    text(92, 260, "Honda City · MH12-AB-9876", 13, C_TEXT_SEC, "Regular", "Vehicle"),
    chip(280, 240, 86, 26, "Verified ✓", C_GREEN_DARK, C_GREEN, 10, R_FULL, "Badge"),
    
    # Timeline
    text(24, 306, "TRIP ROUTE", 10, C_TEXT_TER, "Bold", "Section", letter_spacing=2),
    *timeline_premium(38, 334, [
        ("10:30 AM", "Pune Station", "Origin"),
        ("11:10 AM", "Wakad Highway", "Pickup stop"),
        ("01:45 PM", "Panvel Express", "Drop point"),
        ("02:15 PM", "Mumbai Airport T2", "Destination"),
    ], 1),
    
    # Verification
    *verification_badges(24, 590, 342),
    
    # Bottom action
    rect(0, 758, 390, 86, C_SURFACE, 0, "Bottom Action"),
    text(24, 772, "SPLIT AMOUNT", 10, C_TEXT_TER, "Bold", "Label", letter_spacing=1),
    text(24, 790, "₹450", 28, C_TEXT_PRI, "Bold", "Amount"),
    button(180, 772, 186, 50, "Book Seat", C_PRIMARY, C_WHITE, 15, R_MD, "CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
]))

# --- REQUEST SEAT PANEL ---
screens.append(screen("Request Seat Panel", 4000, y2, [
    rect(0, 0, 390, 844, C_OVERLAY, 0, "Dimmed BG"),
    
    # Bottom sheet
    rect(0, 380, 390, 464, C_BG, R_XXL, "Confirm Sheet", shadow=True, shadow_color={"r":0,"g":0,"b":0,"a":0.6}),
    rect(170, 394, 50, 5, C_CARD_HOVER, 3, "Handle"),
    
    text(24, 420, "Confirm Booking", 24, C_TEXT_PRI, "Bold", "Title", letter_spacing=-0.5),
    
    # Receipt
    text(24, 460, "SPLIT RECEIPT", 10, C_TEXT_TER, "Bold", "Receipt Label", letter_spacing=2),
    
    premium_card(24, 482, 342, 130, R_XL, "Receipt Card"),
    text(44, 502, "Pune → Mumbai Seat", 14, C_TEXT_PRI, "Regular", "Item 1"),
    text(300, 502, "₹450", 14, C_TEXT_PRI, "Bold", "Amt 1"),
    text(44, 528, "Safety Fee", 14, C_TEXT_SEC, "Regular", "Item 2"),
    text(300, 528, "₹35", 14, C_TEXT_SEC, "Regular", "Amt 2"),
    text(44, 554, "First Ride Discount", 14, C_GREEN, "Regular", "Item 3"),
    text(294, 554, "- ₹50", 14, C_GREEN, "Bold", "Amt 3"),
    rect(44, 580, 302, 1, C_BORDER, 0, "Divider"),
    text(44, 592, "Total", 16, C_TEXT_PRI, "Bold", "Total Label"),
    text(290, 590, "₹435", 22, C_PRIMARY_LIGHT, "Bold", "Total Amt"),
    
    text(24, 650, "⚡ Instant notification to Priya", 13, C_TEXT_TER, "Medium", "Info", w=342, align="CENTER"),
    
    button(24, 685, 342, 54, "Pay & Request", C_PRIMARY, C_WHITE, 16, R_LG, "CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
    button(24, 750, 342, 46, "Cancel", C_CARD, C_TEXT_SEC, 14, R_LG, "Cancel"),
]))

# ================================================================
# ROW 3: PARCEL FLOW (y=2000)
# ================================================================
y3 = 2000

# --- SEND PARCEL ---
screens.append(screen("Send Parcel", 0, y3, [
    text(24, 70, "← Send Parcel", 22, C_TEXT_PRI, "Bold", "Title"),
    
    # Hero
    *hero_gradient_bg(24, 110, 342, 130, C_ACCENT, {"r":0.20,"g":0.15,"b":0.50}, "Parcel Hero"),
    text(44, 126, "Same-day delivery network", 18, C_WHITE, "Bold", "Hero Title"),
    text(44, 150, "Verified travelers carry\nyour items securely", 13, {"r":0.8,"g":0.78,"b":1.0}, "Regular", "Hero Sub", w=180),
    image_node(260, 115, 100, 100, parcel_img, 0, "Hero Img"),
    
    # Step 1: Type
    text(24, 260, "1. WHAT ARE YOU SENDING?", 10, C_TEXT_TER, "Bold", "Step 1", letter_spacing=2),
    
    # Selected type with accent border
    rect(23, 283, 106, 82, C_ACCENT, R_LG, "Type 1 Active Border"),
    rect(24, 284, 104, 80, C_CARD, R_LG-1, "Type 1 Bg"),
    text(34, 298, "📄", 24, C_WHITE, "Regular", "Type 1 Icon"),
    text(34, 330, "Documents", 12, C_TEXT_PRI, "Bold", "Type 1 Label"),
    
    rect(142, 284, 104, 80, C_CARD, R_LG, "Type 2 Bg", stroke=C_BORDER, stroke_width=1),
    text(152, 298, "📦", 24, C_WHITE, "Regular", "Type 2 Icon"),
    text(152, 330, "Medium Box", 12, C_TEXT_SEC, "Medium", "Type 2 Label"),
    
    rect(261, 284, 104, 80, C_CARD, R_LG, "Type 3 Bg", stroke=C_BORDER, stroke_width=1),
    text(271, 298, "🥡", 24, C_WHITE, "Regular", "Type 3 Icon"),
    text(271, 330, "Perishable", 12, C_TEXT_SEC, "Medium", "Type 3 Label"),
    
    # Step 2: Weight
    text(24, 388, "2. WEIGHT RANGE", 10, C_TEXT_TER, "Bold", "Step 2", letter_spacing=2),
    chip(24, 410, 90, 34, "Under 1 kg", C_PRIMARY, C_WHITE, 12, R_FULL, "W1"),
    chip(122, 410, 90, 34, "1 - 5 kg", C_CARD, C_TEXT_SEC, 12, R_FULL, "W2", stroke=C_BORDER),
    chip(220, 410, 90, 34, "Over 5 kg", C_CARD, C_TEXT_SEC, 12, R_FULL, "W3", stroke=C_BORDER),
    
    # Step 3: Route
    text(24, 468, "3. ROUTE", 10, C_TEXT_TER, "Bold", "Step 3", letter_spacing=2),
    premium_card(24, 490, 342, 100, R_XL, "Route Card"),
    rect(48, 514, 12, 12, C_GREEN, 6, "Origin Dot"),
    text(70, 510, "Pune Station area", 14, C_TEXT_PRI, "Bold", "Origin"),
    rect(53, 530, 2, 20, C_BORDER, 1, "Line"),
    rect(48, 554, 12, 12, C_PRIMARY, 6, "Dest Dot"),
    text(70, 550, "Mumbai Hub (Andheri)", 14, C_TEXT_PRI, "Bold", "Dest"),
    
    button(24, 730, 342, 56, "Search Matched Travelers", C_PRIMARY, C_WHITE, 15, R_LG, "CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
]))

# --- TRACK PARCEL ---
screens.append(screen("Track Parcel", 500, y3, [
    text(24, 70, "← Tracking", 22, C_TEXT_PRI, "Bold", "Title"),
    
    # Status hero
    *hero_gradient_bg(24, 110, 342, 100, C_GREEN, C_GREEN_DARK, "Status Hero"),
    text(44, 128, "In Transit", 22, C_WHITE, "Bold", "Status"),
    text(44, 154, "Pune → Mumbai · ETA 4:30 PM", 13, {"r":0.8,"g":1.0,"b":0.88}, "Regular", "ETA"),
    chip(260, 132, 86, 24, "On Time", {"r":0,"g":0,"b":0,"a":0.3}, C_WHITE, 10, R_FULL, "Time Badge"),
    
    # Timeline
    text(24, 235, "TRACKING STEPS", 10, C_TEXT_TER, "Bold", "Section", letter_spacing=2),
    *timeline_premium(38, 262, [
        ("2:00 PM", "Sender Handover", "Verified by Rahul M."),
        ("2:45 PM", "Highway Passing", "Near Lonavala"),
        ("Pending", "Out for Delivery", "Approaching destination"),
        ("Pending", "Package Received", "Awaiting OTP"),
    ], 1),
    
    # Carrier info
    text(24, 530, "CARRIER", 10, C_TEXT_TER, "Bold", "Carrier Label", letter_spacing=2),
    premium_card(24, 552, 342, 80, R_XL, "Carrier Card"),
    rect(44, 568, 48, 48, C_SURFACE, 24, "Carrier Pic"),
    text(44, 580, "RM", 14, C_ACCENT_LIGHT, "Bold", "Init", w=48, align="CENTER"),
    text(104, 568, "Rahul M.", 16, C_TEXT_PRI, "Bold", "Name"),
    text(104, 590, "Tata Nexon · MH12-EF-3344", 13, C_TEXT_SEC, "Regular", "Vehicle"),
    button(260, 572, 86, 36, "Contact", C_ACCENT, C_WHITE, 12, R_MD, "Contact CTA"),
]))

# --- PARCEL HISTORY ---
screens.append(screen("Parcel History", 1000, y3, [
    text(24, 70, "Logistics History", 24, C_TEXT_PRI, "Bold", "Title", letter_spacing=-0.5),
    
    premium_card(24, 120, 342, 130, R_XL, "Past 1"),
    image_node(44, 140, 65, 65, parcel_img, R_MD, "Icon 1"),
    text(122, 138, "Document Folder", 17, C_TEXT_PRI, "Bold", "T1"),
    text(122, 162, "Mumbai → Pune · < 1kg", 13, C_TEXT_SEC, "Regular", "D1"),
    chip(122, 190, 100, 22, "✓ Delivered", C_GREEN_DARK, C_GREEN, 10, R_FULL, "Status 1"),
    text(122, 218, "May 12, 2024", 11, C_TEXT_TER, "Regular", "Date 1"),
    
    premium_card(24, 268, 342, 130, R_XL, "Past 2"),
    image_node(44, 288, 65, 65, parcel_img, R_MD, "Icon 2"),
    text(122, 286, "Electronics Box", 17, C_TEXT_PRI, "Bold", "T2"),
    text(122, 310, "Pune → Bangalore · 3kg", 13, C_TEXT_SEC, "Regular", "D2"),
    chip(122, 338, 100, 22, "✗ Cancelled", {"r":0.25,"g":0.05,"b":0.08}, C_PRIMARY_LIGHT, 10, R_FULL, "Status 2"),
    text(122, 366, "May 8, 2024", 11, C_TEXT_TER, "Regular", "Date 2"),
]))

# ================================================================
# ROW 4: TRAVELER FLOW (y=3000)
# ================================================================
y4 = 3000

# --- TRAVELER DASHBOARD ---
screens.append(screen("Traveler Dashboard", 0, y4, [
    rect(0, 0, 390, 200, {"r":0.933,"g":0.180,"b":0.275,"a":0.04}, 0, "Ambient"),
    
    text(24, 70, "Dashboard", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    # Availability toggle
    glass_panel(24, 110, 342, 52, R_LG, "Toggle Panel"),
    text(44, 126, "🟢 Accepting Passengers & Parcels", 13, C_GREEN, "Bold", "Toggle Label"),
    rect(300, 124, 46, 26, C_GREEN, 13, "Toggle Body"),
    rect(322, 127, 20, 20, C_WHITE, 10, "Toggle Knob"),
    
    # Next trip hero (NOT earnings first)
    *hero_gradient_bg(24, 178, 342, 170, C_PRIMARY, C_PRIMARY_DARK, "Trip Hero"),
    text(44, 195, "YOUR NEXT COMMUTE", 10, {"r":1,"g":0.8,"b":0.85}, "Bold", "Hero Label", letter_spacing=2),
    text(44, 216, "Pune → Kolhapur", 24, C_WHITE, "Bold", "Hero Route"),
    text(44, 246, "Today, 10:30 AM · Verna AC", 13, {"r":1,"g":0.9,"b":0.92}, "Regular", "Hero Detail"),
    chip(44, 278, 100, 24, "3 Seats Left", {"r":0,"g":0,"b":0,"a":0.3}, C_WHITE, 10, R_FULL, "Seats"),
    chip(150, 278, 120, 24, "2 Joined", {"r":0,"g":0,"b":0,"a":0.3}, C_WHITE, 10, R_FULL, "Joined"),
    chip(276, 278, 80, 24, "📦 Parcel", {"r":0,"g":0,"b":0,"a":0.3}, C_AMBER, 10, R_FULL, "Parcel"),
    image_node(270, 190, 90, 80, car_clock_img, 0, "Clock Car"),
    
    # Stats (fuel cost recovery, NOT earnings)
    text(24, 370, "FUEL COST RECOVERY", 10, C_TEXT_TER, "Bold", "Stats Label", letter_spacing=2),
    *metric_card(24, 392, 342, 100, "This Week Recovery", "₹4,890", "+22%", True, C_GREEN),
    
    # Bento stats
    premium_card(24, 510, 163, 90, R_XL, "Stat 1"),
    text(40, 526, "Trips Done", 11, C_TEXT_TER, "Medium"),
    text(40, 544, "34", 24, C_TEXT_PRI, "Bold"),
    chip(40, 574, 80, 18, "Verified ✓", C_GREEN_DARK, C_GREEN, 9, R_FULL, "V1"),
    
    premium_card(203, 510, 163, 90, R_XL, "Stat 2"),
    text(219, 526, "CO₂ Saved", 11, C_TEXT_TER, "Medium"),
    text(219, 544, "124 kg", 24, C_GREEN, "Bold"),
    chip(219, 574, 80, 18, "Level 4 🌱", C_GREEN_DARK, C_GREEN, 9, R_FULL, "Eco"),
    
    *floating_nav(0, "traveler"),
]))

# --- TRAVELER REQUESTS ---
screens.append(screen("Traveler Requests", 500, y4, [
    text(24, 70, "Requests", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    # Passenger request
    premium_card(24, 120, 342, 190, R_XL, "Req 1"),
    chip(44, 138, 80, 22, "Passenger", C_ACCENT, C_WHITE, 10, R_FULL, "Type 1"),
    rect(44, 170, 48, 48, C_SURFACE, 24, "Avatar 1"),
    text(44, 182, "SS", 14, C_PRIMARY_LIGHT, "Bold", "Init 1", w=48, align="CENTER"),
    text(104, 172, "Shreya Sen", 17, C_TEXT_PRI, "Bold", "Name 1"),
    text(104, 194, "Identity Verified ✓ · ★ 4.9", 12, C_GREEN, "Medium", "Trust 1"),
    text(44, 228, "📍 Pickup: Wakad (+2 min detour)", 13, C_TEXT_SEC, "Regular", "Pickup"),
    
    button(44, 260, 140, 38, "Decline", C_CARD, C_TEXT_SEC, 13, R_MD, "Decline 1"),
    button(194, 260, 152, 38, "Accept Seat", C_GREEN, C_WHITE, 13, R_MD, "Accept 1", shadow=True, shadow_color=C_GREEN_GLOW),
    
    # Parcel request
    premium_card(24, 328, 342, 200, R_XL, "Req 2"),
    chip(44, 346, 60, 22, "Parcel", C_AMBER, {"r":0,"g":0,"b":0}, 10, R_FULL, "Type 2"),
    image_node(44, 378, 65, 65, parcel_img, R_MD, "Parcel Img"),
    text(122, 376, "Documents Envelope", 17, C_TEXT_PRI, "Bold", "Name 2"),
    text(122, 400, "Sender: Amit S. · ID Verified ✓", 12, C_TEXT_SEC, "Regular", "Sender"),
    text(122, 424, "Recovery: ₹180", 14, C_PRIMARY_LIGHT, "Bold", "Payout"),
    
    button(44, 470, 140, 38, "Decline", C_CARD, C_TEXT_SEC, 13, R_MD, "Decline 2"),
    button(194, 470, 152, 38, "Accept Carry", C_PRIMARY, C_WHITE, 13, R_MD, "Accept 2", shadow=True, shadow_color=C_PRIMARY_GLOW),
    
    *floating_nav(1, "traveler"),
]))

# --- TRAVELER TRIPS ---
screens.append(screen("Traveler Trips", 1000, y4, [
    text(24, 70, "Your Rides", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    # Active trip
    premium_card(24, 120, 342, 175, R_XL, "Trip 1"),
    chip(44, 138, 90, 22, "🟢 Active", C_GREEN_DARK, C_GREEN, 10, R_FULL, "Status 1"),
    text(44, 172, "Pune → Mumbai Express", 18, C_TEXT_PRI, "Bold", "Route 1"),
    text(44, 196, "Today, 10:30 AM · Verna AC", 13, C_TEXT_SEC, "Regular", "Detail 1"),
    text(44, 222, "Seats: 3/4 filled", 14, C_GREEN, "Bold", "Seats 1"),
    button(228, 222, 118, 36, "Manage", C_CARD_HOVER, C_TEXT_PRI, 12, R_MD, "Manage 1"),
    image_node(280, 130, 80, 80, car_img, R_MD, "Car 1"),
    
    # Completed trip
    premium_card(24, 313, 342, 140, R_XL, "Trip 2"),
    chip(44, 331, 100, 22, "✓ Completed", C_CARD_HOVER, C_TEXT_SEC, 10, R_FULL, "Status 2"),
    text(44, 365, "Mumbai → Pune Bypass", 18, C_TEXT_PRI, "Bold", "Route 2"),
    text(44, 389, "May 31 · Recovered ₹1,250", 13, C_TEXT_SEC, "Regular", "Detail 2"),
    
    *floating_nav(2, "traveler"),
]))

# --- TRAVELER VEHICLE ---
screens.append(screen("Traveler Vehicle", 1500, y4, [
    text(24, 70, "Vehicle Profile", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    # Vehicle hero
    *hero_gradient_bg(24, 115, 342, 160, C_ACCENT, {"r": 0.20, "g": 0.15, "b": 0.50}, "Vehicle Hero"),
    text(44, 132, "REGISTERED VEHICLE", 10, {"r":0.8,"g":0.78,"b":1.0}, "Bold", "Hero Label", letter_spacing=2),
    text(44, 152, "Hyundai Verna 1.5", 22, C_WHITE, "Bold", "Hero Name"),
    text(44, 180, "MH12-AB-9876", 14, {"r":0.8,"g":0.78,"b":1.0}, "Regular", "Plate"),
    chip(44, 212, 95, 24, "RC Verified ✓", {"r":0,"g":0,"b":0,"a":0.3}, C_GREEN, 10, R_FULL, "RC"),
    chip(145, 212, 110, 24, "Insured ✓", {"r":0,"g":0,"b":0,"a":0.3}, C_GREEN, 10, R_FULL, "Insurance"),
    image_node(258, 125, 100, 120, car_img, 0, "Car Badge"),
    
    # Specs
    text(24, 296, "SPECIFICATIONS", 10, C_TEXT_TER, "Bold", "Specs Label", letter_spacing=2),
    
    premium_card(24, 318, 342, 52, R_LG, "Spec 1"),
    text(44, 334, "Seat Capacity", 14, C_TEXT_SEC, "Medium"),
    text(280, 334, "4 Max", 14, C_TEXT_PRI, "Bold"),
    
    premium_card(24, 380, 342, 52, R_LG, "Spec 2"),
    text(44, 396, "Parcel Capacity", 14, C_TEXT_SEC, "Medium"),
    text(260, 396, "15 kg (Trunk)", 14, C_TEXT_PRI, "Bold"),
    
    premium_card(24, 442, 342, 52, R_LG, "Spec 3"),
    text(44, 458, "Amenities", 14, C_TEXT_SEC, "Medium"),
    text(250, 458, "AC, Charger ✓", 14, C_GREEN, "Bold"),
    
    # Auto-match
    text(24, 516, "AVAILABILITY", 10, C_TEXT_TER, "Bold", "Avail Label", letter_spacing=2),
    premium_card(24, 538, 342, 52, R_LG, "Auto Match"),
    text(44, 554, "Auto-match searches", 14, C_TEXT_PRI, "Medium"),
    text(280, 554, "ON ✓", 14, C_GREEN, "Bold"),
    
    *floating_nav(3, "traveler"),
]))

# --- TRAVELER PROFILE ---
screens.append(screen("Traveler Profile", 2000, y4, [
    rect(120, 60, 150, 150, C_PRIMARY_GLOW, 75, "Profile Glow"),
    
    text(24, 70, "Profile", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    rect(152, 120, 86, 86, C_PRIMARY, 43, "Ring"),
    rect(155, 123, 80, 80, C_BG, 40, "Inner"),
    text(155, 148, "RM", 22, C_PRIMARY_LIGHT, "Bold", "Initials", w=80, align="CENTER"),
    
    text(24, 222, "Rahul Malhotra", 24, C_TEXT_PRI, "Bold", "Name", w=342, align="CENTER"),
    text(24, 252, "Member since Feb 2024", 13, C_TEXT_SEC, "Medium", "Since", w=342, align="CENTER"),
    
    *verification_badges(24, 285),
    
    premium_card(24, 465, 342, 52, R_LG, "Menu 1"),
    text(44, 481, "Driving History", 14, C_TEXT_PRI, "Medium"),
    text(340, 481, "→", 14, C_TEXT_TER, "Regular"),
    
    premium_card(24, 527, 342, 52, R_LG, "Menu 2"),
    text(44, 543, "Bank Account (Payouts)", 14, C_TEXT_PRI, "Medium"),
    text(340, 543, "→", 14, C_TEXT_TER, "Regular"),
    
    *floating_nav(4, "traveler"),
]))

# --- CREATE TRIP WIZARD ---
screens.append(screen("Create Trip", 2500, y4, [
    text(24, 70, "Offer a Ride", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    text(24, 102, "Step 1 of 5 · Route Setup", 13, C_ACCENT_LIGHT, "Medium", "Progress Label"),
    
    # Progress bar
    rect(24, 125, 66, 4, C_PRIMARY, 2, "Bar 1"),
    rect(94, 125, 66, 4, C_CARD_HOVER, 2, "Bar 2"),
    rect(164, 125, 66, 4, C_CARD_HOVER, 2, "Bar 3"),
    rect(234, 125, 66, 4, C_CARD_HOVER, 2, "Bar 4"),
    rect(304, 125, 62, 4, C_CARD_HOVER, 2, "Bar 5"),
    
    # Route section
    text(24, 156, "1. DEFINE ROUTE", 10, C_TEXT_TER, "Bold", "Section 1", letter_spacing=2),
    premium_card(24, 178, 342, 110, R_XL, "Route Card"),
    rect(48, 202, 12, 12, C_GREEN, 6, "Start Dot"),
    text(70, 198, "Baner, Pune", 14, C_TEXT_PRI, "Medium", "Start"),
    rect(53, 218, 2, 24, C_BORDER, 1, "Line"),
    rect(48, 248, 12, 12, C_PRIMARY, 6, "End Dot"),
    text(70, 244, "Bandra, Mumbai", 14, C_TEXT_PRI, "Bold", "End"),
    
    # Vehicle
    text(24, 312, "2. VEHICLE", 10, C_TEXT_TER, "Bold", "Section 2", letter_spacing=2),
    chip(24, 334, 110, 36, "🚗 Verna AC", C_PRIMARY, C_WHITE, 12, R_FULL, "V1"),
    chip(142, 334, 110, 36, "🏍️ Pulsar", C_CARD, C_TEXT_SEC, 12, R_FULL, "V2", stroke=C_BORDER),
    
    # Seats
    text(24, 396, "3. SEATS", 10, C_TEXT_TER, "Bold", "Section 3", letter_spacing=2),
    rect(24, 418, 160, 48, C_CARD, R_MD, "Stepper", stroke=C_BORDER, stroke_width=1),
    text(24, 432, "−   3 seats   +", 16, C_TEXT_PRI, "Bold", "Stepper Val", w=160, align="CENTER"),
    
    # Pricing
    text(24, 492, "4. SUGGESTED SPLIT", 10, C_TEXT_TER, "Bold", "Section 4", letter_spacing=2),
    premium_card(24, 514, 342, 70, R_XL, "Pricing"),
    text(44, 530, "Suggested: ₹420 - ₹480 / seat", 14, C_TEXT_PRI, "Bold", "Suggestion"),
    text(44, 552, "This rate fills seats 90% faster", 12, C_GREEN, "Regular", "Tip"),
    
    button(24, 730, 342, 56, "Confirm & Continue", C_PRIMARY, C_WHITE, 15, R_LG, "CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
]))

# ================================================================
# ROW 5: UTILITY SCREENS (y=4000)
# ================================================================
y5 = 4000

# --- ACTIVE TRIP ---
screens.append(screen("Active Trip", 0, y5, [
    rect(0, 0, 390, 844, C_SURFACE, 0, "Map View"),
    
    # Speed widget
    glass_panel(24, 68, 105, 80, R_XL, "Speed Widget"),
    text(24, 82, "Speed", 10, C_TEXT_TER, "Medium", "Speed Label", w=105, align="CENTER"),
    text(24, 100, "84", 28, C_GREEN, "Bold", "Speed Val", w=105, align="CENTER"),
    text(24, 130, "km/h", 10, C_TEXT_SEC, "Regular", "Speed Unit", w=105, align="CENTER"),
    
    # ETA widget
    glass_panel(142, 68, 224, 80, R_XL, "ETA Widget"),
    text(162, 82, "Next: Wakad Toll Gate", 14, C_TEXT_PRI, "Bold", "ETA Dest"),
    text(162, 104, "ETA 12 min · 8.4 km", 12, C_TEXT_SEC, "Regular", "ETA Detail"),
    text(162, 126, "⏱️ On Schedule", 12, C_GREEN, "Medium", "ETA Status"),
    
    # Bottom controls
    rect(0, 590, 390, 254, C_BG, R_XXL, "Controls Sheet", shadow=True, shadow_color={"r":0,"g":0,"b":0,"a":0.5}),
    rect(170, 604, 50, 5, C_CARD_HOVER, 3, "Handle"),
    
    text(24, 630, "En Route", 22, C_TEXT_PRI, "Bold", "Status"),
    text(24, 656, "Pune → Mumbai · Rahul · Verna", 13, C_TEXT_SEC, "Regular", "Trip Info"),
    
    # Passenger list
    rect(24, 690, 44, 44, C_SURFACE, 22, "P1"),
    text(24, 700, "SS", 12, C_ACCENT_LIGHT, "Bold", "P1 Init", w=44, align="CENTER"),
    rect(60, 690, 44, 44, C_SURFACE, 22, "P2"),
    text(60, 700, "AK", 12, C_GREEN, "Bold", "P2 Init", w=44, align="CENTER"),
    text(118, 700, "2 passengers onboard", 13, C_TEXT_SEC, "Regular", "P Count"),
    
    button(24, 750, 342, 50, "Share Live Location", C_CARD, C_TEXT_PRI, 14, R_LG, "Share"),
    button(24, 808, 342, 50, "🚨 EMERGENCY SOS", C_PRIMARY, C_WHITE, 14, R_LG, "SOS", shadow=True, shadow_color=C_PRIMARY_GLOW),
]))

# --- SAFETY CENTER ---
screens.append(screen("Safety Center", 500, y5, [
    text(24, 70, "Safety Hub", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    # SOS Hero
    *hero_gradient_bg(24, 115, 342, 140, C_PRIMARY, C_PRIMARY_DARK, "SOS Hero"),
    text(44, 132, "EMERGENCY ALERT", 10, {"r":1,"g":0.8,"b":0.85}, "Bold", "SOS Label", letter_spacing=2),
    text(44, 152, "Instantly trigger SOS", 22, C_WHITE, "Bold", "SOS Title"),
    text(44, 180, "Notifies police (112) &\nyour trusted contacts", 13, {"r":1,"g":0.9,"b":0.92}, "Regular", "SOS Sub", w=200),
    image_node(268, 120, 90, 90, safety_img, 0, "SOS Image"),
    
    # Safety features
    premium_card(24, 275, 342, 80, R_XL, "Safety 1"),
    rect(44, 295, 40, 40, {"r": 0.10, "g": 0.15, "b": 0.30}, 20, "Icon Bg 1"),
    text(44, 305, "📍", 16, C_WHITE, "Regular", "Icon 1", w=40, align="CENTER"),
    text(94, 295, "Share Live Tracking", 16, C_TEXT_PRI, "Bold", "T1"),
    text(94, 317, "GPS link to relatives in real-time", 12, C_TEXT_SEC, "Regular", "D1"),
    
    premium_card(24, 370, 342, 80, R_XL, "Safety 2"),
    rect(44, 390, 40, 40, {"r": 0.10, "g": 0.15, "b": 0.30}, 20, "Icon Bg 2"),
    text(44, 400, "👥", 16, C_WHITE, "Regular", "Icon 2", w=40, align="CENTER"),
    text(94, 390, "Trusted Contacts", 16, C_TEXT_PRI, "Bold", "T2"),
    text(94, 412, "Up to 5 emergency SMS recipients", 12, C_TEXT_SEC, "Regular", "D2"),
    
    premium_card(24, 465, 342, 80, R_XL, "Safety 3"),
    rect(44, 485, 40, 40, {"r": 0.15, "g": 0.08, "b": 0.10}, 20, "Icon Bg 3"),
    text(44, 495, "🚩", 16, C_WHITE, "Regular", "Icon 3", w=40, align="CENTER"),
    text(94, 485, "Report Incident", 16, C_TEXT_PRI, "Bold", "T3"),
    text(94, 507, "Flag unsafe behavior or delays", 12, C_TEXT_SEC, "Regular", "D3"),
    
    button(24, 740, 342, 50, "Help Desk Support", C_CARD, C_TEXT_PRI, 14, R_LG, "Help"),
]))

# --- SETTINGS ---
screens.append(screen("Settings", 1000, y5, [
    text(24, 70, "Settings", 28, C_TEXT_PRI, "Bold", "Title", letter_spacing=-1),
    
    text(24, 120, "PREFERENCES", 10, C_TEXT_TER, "Bold", "S1", letter_spacing=2),
    premium_card(24, 142, 342, 52, R_LG, "Pref 1"),
    text(44, 158, "Push Notifications", 14, C_TEXT_PRI, "Medium"),
    text(340, 158, "→", 14, C_TEXT_TER, "Regular"),
    
    premium_card(24, 204, 342, 52, R_LG, "Pref 2"),
    text(44, 220, "Language", 14, C_TEXT_PRI, "Medium"),
    text(290, 220, "English", 14, C_TEXT_SEC, "Regular"),
    text(340, 220, "→", 14, C_TEXT_TER, "Regular"),
    
    text(24, 282, "LEGAL", 10, C_TEXT_TER, "Bold", "S2", letter_spacing=2),
    premium_card(24, 304, 342, 52, R_LG, "Legal 1"),
    text(44, 320, "Terms of Service", 14, C_TEXT_PRI, "Medium"),
    text(340, 320, "→", 14, C_TEXT_TER, "Regular"),
    
    premium_card(24, 366, 342, 52, R_LG, "Legal 2"),
    text(44, 382, "Privacy Policy", 14, C_TEXT_PRI, "Medium"),
    text(340, 382, "→", 14, C_TEXT_TER, "Regular"),
    
    text(24, 444, "VEHICLE", 10, C_TEXT_TER, "Bold", "S3", letter_spacing=2),
    premium_card(24, 466, 342, 52, R_LG, "Vehicle"),
    text(44, 482, "Vehicle Registration", 14, C_TEXT_PRI, "Medium"),
    text(340, 482, "→", 14, C_TEXT_TER, "Regular"),
    
    button(24, 730, 342, 50, "Log Out", C_CARD, C_PRIMARY_LIGHT, 14, R_LG, "Logout"),
]))

# --- EMPTY STATE ---
screens.append(screen("Empty State", 1500, y5, [
    rect(120, 220, 150, 150, C_ACCENT_GLOW, 75, "Ambient"),
    rect(145, 250, 100, 100, C_CARD, 50, "Circle BG", stroke=C_BORDER, stroke_width=1),
    text(145, 280, "🔍", 36, C_WHITE, "Regular", "Icon", w=100, align="CENTER"),
    
    text(24, 390, "No Active Trips", 24, C_TEXT_PRI, "Bold", "Title", w=342, align="CENTER"),
    text(24, 425, "You don\\'t have any upcoming\ncost-sharing trips scheduled.", 14, C_TEXT_SEC, "Regular", "Sub", w=342, align="CENTER"),
    
    button(75, 490, 240, 54, "Offer a Ride", C_PRIMARY, C_WHITE, 15, R_LG, "CTA 1", shadow=True, shadow_color=C_PRIMARY_GLOW),
    button(75, 554, 240, 48, "Search Available Rides", C_CARD, C_TEXT_PRI, 14, R_LG, "CTA 2"),
]))

# --- NO RESULTS ---
screens.append(screen("No Results", 2000, y5, [
    rect(120, 220, 150, 150, C_PRIMARY_GLOW, 75, "Ambient"),
    rect(145, 250, 100, 100, C_CARD, 50, "Circle BG", stroke=C_BORDER, stroke_width=1),
    text(145, 280, "📍", 36, C_WHITE, "Regular", "Icon", w=100, align="CENTER"),
    
    text(24, 390, "No Commuters Found", 24, C_TEXT_PRI, "Bold", "Title", w=342, align="CENTER"),
    text(24, 425, "Create a route alert to get\nnotified when a match appears.", 14, C_TEXT_SEC, "Regular", "Sub", w=342, align="CENTER"),
    
    button(75, 490, 240, 54, "Create Route Alert 🔔", C_PRIMARY, C_WHITE, 15, R_LG, "CTA 1", shadow=True, shadow_color=C_PRIMARY_GLOW),
    button(75, 554, 240, 48, "Offer My Own Ride 🚗", C_CARD, C_TEXT_PRI, 14, R_LG, "CTA 2"),
]))

# --- NETWORK ERROR ---
screens.append(screen("Network Error", 2500, y5, [
    rect(120, 220, 150, 150, {"r":0.933,"g":0.18,"b":0.275,"a":0.10}, 75, "Ambient"),
    rect(145, 250, 100, 100, {"r":0.2,"g":0.05,"b":0.08}, 50, "Circle BG"),
    text(145, 280, "📶", 36, C_PRIMARY_LIGHT, "Regular", "Icon", w=100, align="CENTER"),
    
    text(24, 390, "Connection Lost", 24, C_TEXT_PRI, "Bold", "Title", w=342, align="CENTER"),
    text(24, 425, "Check your internet and try again.", 14, C_TEXT_SEC, "Regular", "Sub", w=342, align="CENTER"),
    
    button(75, 490, 240, 54, "Reconnect", C_PRIMARY, C_WHITE, 15, R_LG, "CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
]))

# --- VERIFICATION PENDING ---
screens.append(screen("Verification Pending", 3000, y5, [
    rect(120, 220, 150, 150, C_GREEN_GLOW, 75, "Ambient"),
    image_node(145, 250, 100, 100, verification_img, 50, "Verify Img"),
    
    text(24, 390, "Validation In Progress", 24, C_TEXT_PRI, "Bold", "Title", w=342, align="CENTER"),
    text(24, 425, "Our compliance team is verifying\nyour documents (ETA 12 min).", 14, C_TEXT_SEC, "Regular", "Sub", w=342, align="CENTER"),
    
    button(75, 490, 240, 54, "Refresh Status", C_PRIMARY, C_WHITE, 15, R_LG, "CTA", shadow=True, shadow_color=C_PRIMARY_GLOW),
]))

# --- MAINTENANCE ---
screens.append(screen("Maintenance", 3500, y5, [
    rect(120, 220, 150, 150, C_ACCENT_GLOW, 75, "Ambient"),
    rect(145, 250, 100, 100, C_CARD, 50, "Circle BG", stroke=C_BORDER, stroke_width=1),
    text(145, 280, "⚙️", 36, C_WHITE, "Regular", "Icon", w=100, align="CENTER"),
    
    text(24, 390, "Optimizing Platform", 24, C_TEXT_PRI, "Bold", "Title", w=342, align="CENTER"),
    text(24, 425, "Spott is undergoing upgrades.\nWe\\'ll be back shortly.", 14, C_TEXT_SEC, "Regular", "Sub", w=342, align="CENTER"),
]))


# ============================================================
# JS COMPILATION ENGINE
# ============================================================

def format_js(obj, indent=2):
    ind = " " * indent
    if isinstance(obj, dict):
        if len(obj) == 3 and "r" in obj and "g" in obj and "b" in obj:
            return f"{{ r: {obj['r']}, g: {obj['g']}, b: {obj['b']} }}"
        if len(obj) == 4 and "r" in obj and "g" in obj and "b" in obj and "a" in obj:
            return f"{{ r: {obj['r']}, g: {obj['g']}, b: {obj['b']}, a: {obj['a']} }}"
        if len(obj) == 2 and "family" in obj and "style" in obj:
            return f"{{ family: '{obj['family']}', style: '{obj['style']}' }}"
            
        items = []
        for k, v in obj.items():
            items.append(f"{ind}  {k}: {format_js(v, indent + 2)}")
        return "{\n" + ",\n".join(items) + "\n" + ind + "}"
    elif isinstance(obj, list):
        if not obj:
            return "[]"
        items = [format_js(x, indent + 2) for x in obj]
        return "[\n" + ",\n".join(f"{ind}  {item}" if not item.startswith(" ") else item for item in items) + "\n" + ind + "]"
    elif isinstance(obj, str):
        escaped = obj.replace("\\", "\\\\").replace("'", "\\'").replace("\n", "\\n").replace("\r", "\\r")
        return f"'{escaped}'"
    elif isinstance(obj, bool):
        return "true" if obj else "false"
    elif isinstance(obj, (int, float)):
        return str(obj)
    elif obj is None:
        return "null"
    return str(obj)

print("Compiling premium JS...")
js_screens_str = "const screens = " + format_js(screens, 0) + ";\n"

js_rest = """
const fontRequests = [
  { family: 'Inter', style: 'Regular' },
  { family: 'Inter', style: 'Medium' },
  { family: 'Inter', style: 'Semi Bold' },
  { family: 'Inter', style: 'Bold' }
];

function base64ToBytes(base64) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  const lookup = new Uint8Array(256);
  for (let i = 0; i < chars.length; i++) {
    lookup[chars.charCodeAt(i)] = i;
  }
  let bufferLength = base64.length * 0.75;
  if (base64[base64.length - 1] === '=') {
    bufferLength--;
    if (base64[base64.length - 2] === '=') bufferLength--;
  }
  const arrayBuffer = new ArrayBuffer(bufferLength);
  const bytes = new Uint8Array(arrayBuffer);
  let p = 0;
  for (let i = 0; i < base64.length; i += 4) {
    const e1 = lookup[base64.charCodeAt(i)];
    const e2 = lookup[base64.charCodeAt(i + 1)];
    const e3 = lookup[base64.charCodeAt(i + 2)];
    const e4 = lookup[base64.charCodeAt(i + 3)];
    bytes[p++] = (e1 << 2) | (e2 >> 4);
    if (p < bufferLength) bytes[p++] = ((e2 & 15) << 4) | (e3 >> 2);
    if (p < bufferLength) bytes[p++] = ((e3 & 3) << 6) | (e4 & 63);
  }
  return bytes;
}

function rgba(color) {
  const c = color || { r: 0, g: 0, b: 0 };
  return { r: c.r || 0, g: c.g || 0, b: c.b || 0 };
}

function createFill(color) {
  const c = color || { r: 0, g: 0, b: 0 };
  return {
    type: 'SOLID',
    color: { r: c.r || 0, g: c.g || 0, b: c.b || 0 },
    opacity: c.a !== undefined ? c.a : 1.0
  };
}

function createGradientFill(stops, direction) {
  // direction: 'vertical', 'horizontal', 'diagonal'
  let transform;
  if (direction === 'horizontal') {
    transform = [[1, 0, 0], [0, 1, 0.5]];
  } else if (direction === 'diagonal') {
    transform = [[0.7071, 0.7071, 0], [-0.7071, 0.7071, 0.5]];
  } else {
    // vertical (default)
    transform = [[0, 1, 0], [-1, 0, 1]];
  }
  
  const gradientStops = stops.map(s => ({
    position: s.position,
    color: {
      r: s.color.r || 0,
      g: s.color.g || 0,
      b: s.color.b || 0,
      a: s.color.a !== undefined ? s.color.a : 1.0
    }
  }));
  
  return {
    type: 'GRADIENT_LINEAR',
    gradientTransform: transform,
    gradientStops: gradientStops
  };
}

function applyTextStyles(node, item) {
  node.fontName = item.font || { family: 'Inter', style: 'Regular' };
  node.fontSize = item.fontSize || 14;
  node.fills = [{ type: 'SOLID', color: rgba(item.color || item.textColor) }];
  node.textAlignHorizontal = item.align || 'LEFT';
  node.textAlignVertical = 'TOP';
  node.textAutoResize = 'WIDTH_AND_HEIGHT';
  
  if (item.letterSpacing !== undefined && item.letterSpacing !== null) {
    node.letterSpacing = { value: item.letterSpacing, unit: 'PIXELS' };
  } else {
    node.letterSpacing = { value: 0, unit: 'PIXELS' };
  }
  
  if (item.lineHeight !== undefined && item.lineHeight !== null) {
    node.lineHeight = { value: item.lineHeight, unit: 'PIXELS' };
  } else {
    node.lineHeight = { value: node.fontSize * 1.35, unit: 'PIXELS' };
  }
}

function createText(item) {
  const node = figma.createText();
  node.characters = item.text;
  applyTextStyles(node, item);
  node.x = item.x;
  node.y = item.y;
  if (item.name) node.name = item.name;
  if (item.width) {
    node.textAutoResize = 'HEIGHT';
    node.resize(item.width, node.height);
  }
  return node;
}

function createRectangle(item) {
  const node = figma.createRectangle();
  node.resize(item.width, item.height);
  node.x = item.x;
  node.y = item.y;
  
  // Fill logic: base64 image > multi-stop gradient > two-color gradient > solid
  if (item.base64) {
    const bytes = base64ToBytes(item.base64);
    const image = figma.createImage(bytes);
    node.fills = [{ type: 'IMAGE', imageHash: image.hash, scaleMode: 'FILL' }];
  } else if (item.gradientStops) {
    node.fills = [createGradientFill(item.gradientStops, item.gradientDirection || 'vertical')];
  } else if (item.color1 && item.color2) {
    node.fills = [{
      type: 'GRADIENT_LINEAR',
      gradientTransform: [[0.7071, 0.7071, 0], [-0.7071, 0.7071, 0.5]],
      gradientStops: [
        { position: 0, color: { r: item.color1.r, g: item.color1.g, b: item.color1.b, a: 1 } },
        { position: 1, color: { r: item.color2.r, g: item.color2.g, b: item.color2.b, a: 1 } }
      ]
    }];
  } else {
    node.fills = [createFill(item.fill)];
  }
  
  if (item.cornerRadius !== undefined) node.cornerRadius = item.cornerRadius;
  if (item.opacity !== undefined) node.opacity = item.opacity;
  
  // Strokes
  if (item.stroke) {
    node.strokes = [{
      type: 'SOLID',
      color: { r: item.stroke.r || 0, g: item.stroke.g || 0, b: item.stroke.b || 0 },
      opacity: item.stroke.a !== undefined ? item.stroke.a : 1.0
    }];
    node.strokeWeight = item.strokeWidth || 1;
    node.strokeAlign = 'INSIDE';
  }
  
  // Effects: blur + shadow with custom colors
  const effects = [];
  if (item.hasBlur) {
    effects.push({
      type: 'BACKGROUND_BLUR',
      radius: 24,
      visible: true
    });
  }
  if (item.hasShadow) {
    const sc = item.shadowColor || { r: 0, g: 0, b: 0, a: 0.35 };
    const sr = item.shadowRadius || 24;
    const so = item.shadowOffset || { x: 0, y: 8 };
    effects.push({
      type: 'DROP_SHADOW',
      color: { r: sc.r || 0, g: sc.g || 0, b: sc.b || 0, a: sc.a !== undefined ? sc.a : 0.35 },
      offset: so,
      radius: sr,
      visible: true,
      blendMode: 'NORMAL'
    });
  }
  if (effects.length > 0) node.effects = effects;
  
  if (item.name) node.name = item.name;
  return node;
}

function createButton(item) {
  const bg = figma.createRectangle();
  bg.resize(item.width, item.height);
  bg.x = 0;
  bg.y = 0;
  bg.fills = [createFill(item.fill)];
  bg.cornerRadius = item.cornerRadius !== undefined ? item.cornerRadius : 16;
  
  // Button shadow
  if (item.hasShadow && item.shadowColor) {
    const sc = item.shadowColor;
    bg.effects = [{
      type: 'DROP_SHADOW',
      color: { r: sc.r || 0, g: sc.g || 0, b: sc.b || 0, a: sc.a !== undefined ? sc.a : 0.3 },
      offset: { x: 0, y: 4 },
      radius: 16,
      visible: true,
      blendMode: 'NORMAL'
    }];
  }

  const children = [bg];
  if (item.text) {
    const label = figma.createText();
    label.characters = item.text;
    label.fontName = item.font || { family: 'Inter', style: 'Bold' };
    label.fontSize = item.fontSize || 15;
    label.textAlignHorizontal = 'CENTER';
    label.textAlignVertical = 'CENTER';
    label.textAutoResize = 'WIDTH_AND_HEIGHT';
    label.fills = [{ type: 'SOLID', color: rgba(item.textColor || { r: 1, g: 1, b: 1 }) }];
    label.resize(item.width, item.height);
    label.x = 0;
    label.y = (item.height - label.height) / 2;
    children.push(label);
  }

  const group = figma.group(children, figma.currentPage);
  group.x = item.x;
  group.y = item.y;
  group.name = item.name || 'Button';
  return group;
}

function createChip(item) {
  const bg = figma.createRectangle();
  bg.resize(item.width, item.height);
  bg.x = 0;
  bg.y = 0;
  bg.fills = [createFill(item.fill)];
  bg.cornerRadius = item.cornerRadius !== undefined ? item.cornerRadius : 100;
  
  if (item.stroke) {
    bg.strokes = [{
      type: 'SOLID',
      color: { r: item.stroke.r || 0, g: item.stroke.g || 0, b: item.stroke.b || 0 },
      opacity: item.stroke.a !== undefined ? item.stroke.a : 1.0
    }];
    bg.strokeWeight = 1;
    bg.strokeAlign = 'INSIDE';
  }

  const children = [bg];
  if (item.text) {
    const label = figma.createText();
    label.characters = item.text;
    label.fontName = item.font || { family: 'Inter', style: 'Medium' };
    label.fontSize = item.fontSize || 12;
    label.textAlignHorizontal = 'CENTER';
    label.textAlignVertical = 'CENTER';
    label.textAutoResize = 'WIDTH_AND_HEIGHT';
    label.fills = [{ type: 'SOLID', color: rgba(item.textColor || { r: 1, g: 1, b: 1 }) }];
    label.resize(item.width, item.height);
    label.x = 0;
    label.y = (item.height - label.height) / 2;
    children.push(label);
  }

  const group = figma.group(children, figma.currentPage);
  group.x = item.x;
  group.y = item.y;
  group.name = item.name || 'Chip';
  return group;
}

function createFrame(item) {
  const frame = figma.createFrame();
  frame.name = item.name;
  frame.resize(item.width, item.height);
  frame.x = item.x;
  frame.y = item.y;
  frame.fills = [createFill(item.fill)];
  frame.clipsContent = true;
  frame.layoutMode = 'NONE';
  item.children.forEach(child => {
    let node;
    if (child.type === 'text') node = createText(child);
    else if (child.type === 'rect') node = createRectangle(child);
    else if (child.type === 'button') node = createButton(child);
    else if (child.type === 'chip') node = createChip(child);
    if (node) frame.appendChild(node);
  });
  return frame;
}

async function main() {
  for (const font of fontRequests) {
    await figma.loadFontAsync(font);
  }

  const createdFrames = screens.map(createFrame);
  createdFrames.forEach(frame => figma.currentPage.appendChild(frame));

  figma.viewport.scrollAndZoomIntoView(createdFrames);
  figma.closePlugin('✨ Spott Premium UI generated successfully!');
}

main();
"""

full_code = js_screens_str + js_rest

with open(code_js_path, 'w', encoding='utf-8') as f:
    f.write(full_code)

print(f"Successfully compiled premium code.js at: {code_js_path}")
print(f"Total screens: {len(screens)}")
