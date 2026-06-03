import json
import os
import base64
from PIL import Image
from io import BytesIO

code_js_path = r"D:\PROJECTS\Spotter\spotter\figma-plugin\code.js"

# Design System Colors
C_BG = {"r": 0.027, "g": 0.027, "b": 0.027} # #070707
C_SURFACE = {"r": 0.07, "g": 0.07, "b": 0.07} # #121212
C_CARD = {"r": 0.094, "g": 0.094, "b": 0.094} # #181818
C_PRIMARY = {"r": 0.902, "g": 0.0, "b": 0.137} # #E60023
C_PRIMARY_GLOW = {"r": 1.0, "g": 0.2, "b": 0.333} # #FF3355
C_GREEN = {"r": 0.133, "g": 0.773, "b": 0.369} # #22C55E
C_AMBER = {"r": 0.961, "g": 0.62, "b": 0.043} # #F59E0B
C_WHITE = {"r": 1.0, "g": 1.0, "b": 1.0} # #FFFFFF
C_TEXT_SEC = {"r": 0.631, "g": 0.631, "b": 0.667} # #A1A1AA

R_CARD = 24
R_BUTTON = 18
R_BOTTOM_SHEET = 28
R_MODAL = 32

SCREEN_W = 390
SCREEN_H = 844

# Helper to load local PNG assets as compressed base64 strings
def load_png_as_base64(filepath, max_size=300):
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

print("Loading local PNG assets...")
car_img = load_png_as_base64("Car.png")
bike_img = load_png_as_base64("Bike.png")
parcel_img = load_png_as_base64("Parcel.png")
rikshaw_img = load_png_as_base64("Rikshaw.png")
calendar_img = load_png_as_base64("Calendar.png")
safety_img = load_png_as_base64("safety.png")
verification_img = load_png_as_base64("verification.png")
route_img = load_png_as_base64("route.png")
print("PNG assets loaded successfully.")

# Custom Figma UI Node Generators
def rect(x, y, w, h, fill, r=0, name="Rect", blur=False, shadow=False):
    return {
        "type": "rect",
        "x": x, "y": y,
        "width": w, "height": h,
        "fill": fill,
        "cornerRadius": r,
        "hasBlur": blur,
        "hasShadow": shadow,
        "name": name
    }

def gradient_card(x, y, w, h, color1, color2, r=R_CARD, name="GradientCard", blur=False, shadow=True):
    return {
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

def glass_card(x, y, w, h, r=R_CARD, name="GlassCard"):
    return rect(x, y, w, h, {"r": 1.0, "g": 1.0, "b": 1.0, "a": 0.08}, r, name, blur=True, shadow=True)

def image_card(x, y, w, h, base64_str, r=0, name="ImageCard"):
    return {
        "type": "rect",
        "x": x, "y": y,
        "width": w, "height": h,
        "base64": base64_str,
        "cornerRadius": r,
        "name": name
    }

def text(x, y, txt, size=14, color=C_WHITE, weight="Regular", name="Text", w=None, align="LEFT"):
    return {
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

def button(x, y, w, h, txt, fill=C_PRIMARY, txt_color=C_WHITE, size=16, r=R_BUTTON, name="Button"):
    return {
        "type": "button",
        "x": x, "y": y,
        "width": w, "height": h,
        "text": txt,
        "fill": fill,
        "textColor": txt_color,
        "fontSize": size,
        "cornerRadius": r,
        "name": name,
        "font": {"family": "Inter", "style": "Bold"}
    }

def chip(x, y, w, h, txt, fill=C_CARD, txt_color=C_WHITE, size=13, r=14, name="Chip"):
    return {
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

def avatar_group(x, y, count=3, r=14):
    children = []
    colors = [
        {"r": 0.133, "g": 0.773, "b": 0.369},
        {"r": 0.961, "g": 0.62, "b": 0.043},
        {"r": 0.902, "g": 0.0, "b": 0.137},
        {"r": 0.2, "g": 0.6, "b": 0.9}
    ]
    for i in range(count):
        children.append(rect(x + i * (r * 1.3), y, r * 2, r * 2, colors[i % len(colors)], r, f"Avatar {i+1}"))
    return children

def floating_glass_nav(selected_index=0, mode="passenger"):
    children = [
        # Floating bar base
        rect(24, 745, 342, 68, {"r": 0.08, "g": 0.08, "b": 0.08, "a": 0.85}, 24, "Floating Nav", blur=True, shadow=True)
    ]
    if mode == "passenger":
        # Tabs: Home, Explore, Trips, Activity, Profile
        tabs = [
            ("Home", 24 + 10),
            ("Explore", 24 + 75),
            ("Trips", 24 + 145),
            ("Activity", 24 + 215),
            ("Profile", 24 + 280)
        ]
    else:
        # Tabs: Dashboard, Requests, Trips, Vehicle, Profile
        tabs = [
            ("Dash", 24 + 10),
            ("Requests", 24 + 75),
            ("Trips", 24 + 145),
            ("Vehicle", 24 + 215),
            ("Profile", 24 + 280)
        ]
        
    for i, (name, tx) in enumerate(tabs):
        is_selected = (i == selected_index)
        color = C_PRIMARY_GLOW if is_selected else C_TEXT_SEC
        weight = "Bold" if is_selected else "Medium"
        children.append(text(tx, 760, name, 12, color, weight, f"Tab {name}", 50 if mode=="passenger" else 50, "CENTER"))
        if is_selected:
            children.append(rect(tx + 22, 788, 6, 6, C_PRIMARY_GLOW, 3, "Indicator Dot"))
    return children

def timeline_progress(x, y, steps, active_step=0):
    children = []
    curr_y = y
    for i, (time_str, label, sub) in enumerate(steps):
        is_active = (i <= active_step)
        node_color = C_PRIMARY_GLOW if is_active else C_CARD
        text_color = C_WHITE if is_active else C_TEXT_SEC
        
        # Node dot
        children.append(rect(x, curr_y + 4, 16, 16, node_color, 8, f"Node {i}"))
        if is_active:
            children.append(rect(x - 4, curr_y, 24, 24, {**C_PRIMARY_GLOW, "a": 0.15}, 12, f"Node Glow {i}"))
            
        children.append(text(x + 35, curr_y, label, 15, text_color, "Bold" if is_active else "Medium"))
        children.append(text(x + 35, curr_y + 22, f"{time_str} • {sub}", 12, C_TEXT_SEC, "Regular"))
        
        if i < len(steps) - 1:
            line_color = C_PRIMARY if is_active else C_SURFACE
            children.append(rect(x + 7, curr_y + 20, 2, 45, line_color, 1, f"Connector {i}"))
        curr_y += 65
    return children

def fintech_metric_card(x, y, w, h, title, val, trend, trend_up=True):
    children = [
        gradient_card(x, y, w, h, C_SURFACE, C_CARD, R_CARD, f"Metric {title}")
    ]
    children.append(text(x + 20, y + 16, title, 13, C_TEXT_SEC, "Medium"))
    children.append(text(x + 20, y + 36, val, 24, C_WHITE, "Bold"))
    
    trend_color = C_GREEN if trend_up else C_PRIMARY_GLOW
    trend_sign = "↑" if trend_up else "↓"
    children.append(rect(x + 20, y + 70, 70, 20, {**trend_color, "a": 0.15}, 10, "Trend Bg"))
    children.append(text(x + 28, y + 73, f"{trend_sign} {trend}", 11, trend_color, "Bold"))
    
    for idx, h_factor in enumerate([10, 15, 8, 20, 14, 25]):
        children.append(rect(x + w - 80 + idx * 8, y + 60 - h_factor, 4, h_factor, trend_color, 2, f"Spark {idx}"))
    return children

def hero_section(x, y, w, h, base64_img, title, subtitle, cta_primary, cta_secondary=None):
    children = [
        gradient_card(x, y, w, h, C_SURFACE, C_CARD, R_CARD, "Hero Card Base")
    ]
    if base64_img:
        children.append(image_card(x + w - 120, y + 20, 100, 100, base64_img, 16, "Hero Image"))
        
    children.append(text(x + 20, y + 20, title, 22, C_WHITE, "Bold", "Hero Title", w - 140))
    children.append(text(x + 20, y + 55, subtitle, 13, C_TEXT_SEC, "Regular", "Hero Subtitle", w - 140))
    
    if cta_secondary:
        children.append(button(x + 20, y + h - 50, (w - 50)//2, 36, cta_primary, C_PRIMARY, C_WHITE, 13, 12, "Hero Primary CTA"))
        children.append(button(x + 20 + (w - 50)//2 + 10, y + h - 50, (w - 50)//2, 36, cta_secondary, C_SURFACE, C_TEXT_SEC, 13, 12, "Hero Secondary CTA"))
    else:
        children.append(button(x + 20, y + h - 50, w - 40, 36, cta_primary, C_PRIMARY, C_WHITE, 13, 12, "Hero Primary CTA"))
    return children

# Explicit Verification Checklist component (No trust score)
def verification_checklist(x, y, completed_trips=147, member_since="Jan 2024"):
    return [
        gradient_card(x, y, 342, 160, C_SURFACE, C_CARD, R_CARD, "Trust Checklist Card"),
        text(x + 20, y + 16, "VERIFICATION & ACTIVITY STATUS", 11, C_TEXT_SEC, "Bold"),
        
        text(x + 20, y + 42, "Identity Verified ✓", 14, C_GREEN, "Bold"),
        text(x + 20, y + 66, "Driving License Verified ✓", 14, C_GREEN, "Bold"),
        text(x + 20, y + 90, "Vehicle Verified ✓", 14, C_GREEN, "Bold"),
        
        rect(x + 20, y + 118, 302, 1, C_SURFACE),
        text(x + 20, y + 128, f"{completed_trips} Completed commutes", 13, C_WHITE, "Medium"),
        text(x + 200, y + 128, f"Commuting since {member_since}", 13, C_TEXT_SEC, "Regular")
    ]

def screen(name, x, y, children):
    island = rect(125, 11, 140, 37, {"r":0,"g":0,"b":0}, 18, "Dynamic Island")
    return {
        "name": name,
        "x": x, "y": y,
        "width": SCREEN_W, "height": SCREEN_H,
        "fill": C_BG,
        "children": [island] + children
    }

screens = []

# --- ROW 1: Onboarding / Auth (y=0) ---
y1 = 0
screens.append(screen("Splash Screen", 0, y1, [
    rect(135, 240, 120, 120, C_PRIMARY, 60, "Logo Circle", shadow=True),
    text(135, 280, "S", 56, C_WHITE, "Bold", w=120, align="CENTER"),
    text(24, 400, "Spott", 48, C_WHITE, "Bold", w=342, align="CENTER"),
    text(24, 465, "Premium cost-sharing travel network & parcel ecosystem", 16, C_TEXT_SEC, "Regular", w=342, align="CENTER"),
    
    button(24, 650, 342, 56, "Get Started", C_PRIMARY_GLOW),
    button(24, 715, 342, 56, "Log In", C_SURFACE, C_WHITE),
    
    chip(34, 790, 95, 28, "Cost Share", C_SURFACE, C_WHITE, 12, 14),
    chip(148, 790, 95, 28, "Safe Travel", C_SURFACE, C_WHITE, 12, 14),
    chip(261, 790, 95, 28, "Fast Parcel", C_SURFACE, C_WHITE, 12, 14),
]))

screens.append(screen("Role Selector", 500, y1, [
    text(24, 80, "Choose your journey", 32, C_WHITE, "Bold"),
    text(24, 125, "Select how you would like to interact today", 15, C_TEXT_SEC, "Regular"),
    
    gradient_card(24, 180, 342, 130, C_PRIMARY, C_PRIMARY_GLOW, R_CARD, "Passenger Card"),
    text(48, 204, "Passenger Mode", 20, C_WHITE, "Bold"),
    text(48, 232, "Split travel expenses and find vetted rides easily.", 13, C_WHITE, "Medium", w=180),
    chip(48, 268, 120, 24, "Popular Option", C_BG, C_WHITE, 11, 12),
    image_card(250, 195, 100, 100, car_img, 0, "Car Illustration"),
    
    gradient_card(24, 330, 342, 130, C_SURFACE, C_CARD, R_CARD, "Traveler Card"),
    text(48, 354, "Traveler Mode", 20, C_WHITE, "Bold"),
    text(48, 382, "Offer empty seats in your vehicle to split costs.", 13, C_TEXT_SEC, "Regular", w=180),
    chip(48, 418, 140, 24, "Earn up to ₹1,500/day", C_BG, C_GREEN, 11, 12),
    image_card(250, 345, 100, 100, bike_img, 0, "Bike Illustration"),
    
    gradient_card(24, 480, 342, 130, C_SURFACE, C_CARD, R_CARD, "Sender Card"),
    text(48, 504, "Parcel Carrier Mode", 20, C_WHITE, "Bold"),
    text(48, 532, "Send same-day parcels via verified commuters.", 13, C_TEXT_SEC, "Regular", w=180),
    chip(48, 568, 140, 24, "Same-day delivery", C_BG, C_AMBER, 11, 12),
    image_card(250, 495, 100, 100, parcel_img, 0, "Parcel Illustration"),
    
    button(24, 730, 342, 56, "Continue", C_PRIMARY),
]))

screens.append(screen("Login", 1000, y1, [
    text(24, 100, "Enter your mobile", 32, C_WHITE, "Bold"),
    text(24, 145, "We'll send a secure one-time passcode to you", 15, C_TEXT_SEC, "Regular"),
    
    rect(24, 210, 342, 64, C_SURFACE, 18, "Input Outer Glow", shadow=True),
    text(48, 232, "+91", 16, C_WHITE, "Bold"),
    rect(90, 227, 2, 30, C_CARD),
    text(105, 232, "98765 43210", 16, C_WHITE, "Medium"),
    
    button(24, 300, 342, 56, "Request Access Code", C_PRIMARY),
    
    text(24, 420, "OR CONNECT SECURELY", 11, C_TEXT_SEC, "Bold", w=342, align="CENTER"),
    rect(24, 440, 140, 1, C_SURFACE),
    rect(226, 440, 140, 1, C_SURFACE),
    
    button(24, 470, 342, 56, "Sign in with Google", C_SURFACE, C_WHITE, r=18),
    button(24, 538, 342, 56, "Sign in with Apple", C_WHITE, C_BG, r=18),
]))

screens.append(screen("OTP Verification", 1500, y1, [
    text(24, 100, "Enter Passcode", 32, C_WHITE, "Bold"),
    text(24, 145, "A 4-digit code was sent to +91 98765 43210", 15, C_TEXT_SEC, "Regular"),
    
    rect(24, 210, 70, 70, C_SURFACE, 18, "Otp 1"), text(24, 230, "4", 28, C_WHITE, "Bold", w=70, align="CENTER"),
    rect(114, 210, 70, 70, C_SURFACE, 18, "Otp 2"), text(114, 230, "8", 28, C_WHITE, "Bold", w=70, align="CENTER"),
    rect(204, 210, 70, 70, C_SURFACE, 18, "Otp 3"), text(204, 230, "2", 28, C_WHITE, "Bold", w=70, align="CENTER"),
    rect(294, 210, 70, 70, C_SURFACE, 18, "Otp 4"),
    rect(324, 240, 10, 10, C_PRIMARY_GLOW, 5, "Cursor"),
    
    button(24, 310, 342, 56, "Verify and Enter", C_PRIMARY),
    text(24, 395, "Resend secure SMS in 44 seconds", 13, C_TEXT_SEC, "Medium", w=342, align="CENTER"),
]))

# --- ROW 2: Passenger Flow (y=1000) ---
y2 = 1000
screens.append(screen("Passenger Home", 0, y2, [
    rect(24, 70, 48, 48, C_SURFACE, 24, "User Profile Avatar"),
    text(84, 72, "Hi Amit 👋", 16, C_WHITE, "Bold"),
    text(84, 94, "Pune, MH", 12, C_TEXT_SEC, "Medium"),
    rect(318, 70, 48, 48, C_SURFACE, 24, "Notification Trigger"),
    text(318, 82, "🔔", 20, C_WHITE, "Bold", w=48, align="CENTER"),
    
    # 3. Route-Based Search Box on Home
    gradient_card(24, 140, 342, 136, C_SURFACE, C_CARD, R_CARD, "Search Route Card"),
    text(44, 160, "Where are you going?", 18, C_WHITE, "Bold"),
    rect(44, 194, 302, 44, C_BG, 12, "Search Bar Placeholder"),
    text(64, 206, "🔍 Enter your destination...", 14, C_TEXT_SEC, "Medium"),
    
    # Recent Routes Section (retention chips)
    text(24, 290, "RECENT ROUTES", 11, C_TEXT_SEC, "Bold"),
    chip(24, 314, 130, 32, "⚡ Kolhapur → Pune", C_SURFACE, C_WHITE, 12, 16),
    chip(162, 314, 120, 32, "⚡ Pune → Mumbai", C_SURFACE, C_WHITE, 12, 16),
    chip(290, 314, 130, 32, "⚡ Kolhapur → Sangli", C_SURFACE, C_WHITE, 12, 16),
    
    # Bento Quick Action Grid
    gradient_card(24, 366, 163, 160, C_PRIMARY, C_PRIMARY_GLOW, R_CARD, "Action Find"),
    text(40, 386, "Find Trip", 18, C_WHITE, "Bold"),
    text(40, 411, "Cost-share shared rides", 11, {"r":1,"g":0.8,"b":0.8}, "Medium"),
    image_card(35, 436, 130, 85, car_img, 0, "Bento Car"),
    
    gradient_card(203, 366, 163, 110, C_SURFACE, C_CARD, R_CARD, "Action Parcel"),
    text(219, 382, "Send Parcel", 16, C_WHITE, "Bold"),
    text(219, 404, "Fast courier", 11, C_TEXT_SEC, "Regular"),
    image_card(285, 396, 70, 70, parcel_img, 0, "Bento Parcel"),
    
    gradient_card(24, 542, 163, 110, C_SURFACE, C_CARD, R_CARD, "Action Safety"),
    text(40, 558, "Safety Center", 16, C_WHITE, "Bold"),
    text(40, 580, "SOS & Support", 11, C_TEXT_SEC, "Regular"),
    image_card(110, 576, 70, 70, safety_img, 0, "Bento Safety"),
    
    gradient_card(203, 492, 163, 160, C_SURFACE, C_CARD, R_CARD, "Action Calendar"),
    text(219, 512, "Weekly Pass", 16, C_WHITE, "Bold"),
    text(219, 534, "Save up to 35%", 11, C_TEXT_SEC, "Regular"),
    image_card(214, 556, 130, 90, calendar_img, 0, "Bento Calendar"),
    
    text(24, 672, "Active Commuters Nearby", 18, C_WHITE, "Bold"),
    # Nearby Trip Carousel Card
    gradient_card(24, 700, 342, 130, C_SURFACE, C_CARD, R_CARD, "Carousel Trip 1"),
    text(44, 720, "Pune → Mumbai", 16, C_WHITE, "Bold"),
    text(44, 742, "Hyundai Verna • Priya K.", 13, C_TEXT_SEC, "Medium"),
    chip(44, 770, 60, 24, "★ 4.9", C_SURFACE, C_WHITE, 12, 12),
    chip(110, 770, 90, 24, "Women-Friendly", {"r":0,"g":0.15,"b":0.08}, C_GREEN, 11, 12),
    text(280, 720, "₹450", 20, C_PRIMARY_GLOW, "Bold"),
    
    *floating_glass_nav(0, "passenger")
]))

# Explore screen for Passenger
screens.append(screen("Passenger Explore", 500, y2, [
    rect(0, 0, 390, 844, C_SURFACE, 0, "Map Discovery Bg"),
    text(24, 70, "Explore Near You", 24, C_WHITE, "Bold"),
    rect(24, 110, 342, 50, C_CARD, 12),
    text(44, 125, "🔍 Search highway points or cities...", 14, C_TEXT_SEC, "Medium"),
    
    # Pin mockups on map
    rect(100, 250, 40, 40, C_PRIMARY, 20, "Pin 1"), text(100, 260, "🚗", 16, C_WHITE, "Bold", w=40, align="CENTER"),
    rect(220, 380, 40, 40, C_GREEN, 20, "Pin 2"), text(220, 390, "🏍️", 16, C_WHITE, "Bold", w=40, align="CENTER"),
    
    # Floating card at bottom
    gradient_card(24, 580, 342, 130, C_BG, C_SURFACE, R_CARD, "Selected Pin Card", blur=True),
    text(44, 600, "Pune-Mumbai Express Drive", 16, C_WHITE, "Bold"),
    text(44, 622, "Traveler Vikram M. • Driving License Verified ✓", 13, C_GREEN, "Medium"),
    chip(44, 650, 80, 24, "4.9 Rating", C_CARD, C_WHITE, 11, 12),
    chip(130, 650, 110, 24, "147 Completed", C_CARD, C_WHITE, 11, 12),
    button(250, 646, 96, 38, "Book", C_PRIMARY_GLOW, C_WHITE, 12, 10),
    
    *floating_glass_nav(1, "passenger")
]))

# Passenger Trips Screen
screens.append(screen("Passenger Trips", 1000, y2, [
    text(24, 70, "Your Commutes", 24, C_WHITE, "Bold"),
    chip(24, 110, 100, 32, "Active Rides", C_PRIMARY, C_WHITE, 12, 16),
    chip(130, 110, 100, 32, "Logistics history", C_SURFACE, C_TEXT_SEC, 12, 16),
    
    gradient_card(24, 160, 342, 150, C_SURFACE, C_CARD, R_CARD, "Upcoming ride schedule"),
    text(44, 180, "Pune → Kolhapur", 18, C_WHITE, "Bold"),
    text(44, 204, "Tomorrow, 08:30 AM • 1 Seat booked", 13, C_TEXT_SEC, "Regular"),
    rect(44, 230, 302, 1, C_SURFACE),
    text(44, 242, "Traveler: Priya K. • License Verified ✓", 13, C_GREEN, "Medium"),
    button(240, 255, 106, 36, "View Details", C_SURFACE, C_WHITE, 12, 10),
    
    *floating_glass_nav(2, "passenger")
]))

# Passenger Activity Screen
screens.append(screen("Passenger Activity", 1500, y2, [
    text(24, 70, "Activity & Logs", 24, C_WHITE, "Bold"),
    
    gradient_card(24, 120, 342, 120, C_SURFACE, C_CARD, R_CARD, "Activity 1"),
    text(44, 140, "Carriage Completed: Documents Envelope", 16, C_WHITE, "Bold"),
    text(44, 162, "Delivered to Mumbai Hub • OTP Verified ✓", 13, C_GREEN, "Medium"),
    text(44, 185, "12 May 2024, 04:15 PM", 12, C_TEXT_SEC, "Regular"),
    
    gradient_card(24, 255, 342, 120, C_SURFACE, C_CARD, R_CARD, "Activity 2"),
    text(44, 275, "Cost Share Completed: Pune → Lonavala", 16, C_WHITE, "Bold"),
    text(44, 297, "Split fuel share ₹180 completed", 13, C_GREEN, "Medium"),
    text(44, 320, "08 May 2024, 11:30 AM", 12, C_TEXT_SEC, "Regular"),
    
    *floating_glass_nav(3, "passenger")
]))

# Passenger Profile Screen (with explicit verified badge & member since)
screens.append(screen("Passenger Profile", 2000, y2, [
    text(24, 70, "Commuter Profile", 24, C_WHITE, "Bold"),
    rect(145, 120, 100, 100, C_SURFACE, 50, "Profile Pic"),
    text(24, 235, "Amit Sharma", 22, C_WHITE, "Bold", w=342, align="CENTER"),
    text(24, 260, "Member since Jan 2024", 13, C_TEXT_SEC, "Medium", w=342, align="CENTER"),
    
    *verification_checklist(24, 295, completed_trips=147, member_since="Jan 2024"),
    
    gradient_card(24, 475, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 495, "Personal Details", 15, C_WHITE, "Medium"),
    gradient_card(24, 545, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 565, "Payment Split Settings", 15, C_WHITE, "Medium"),
    
    *floating_glass_nav(4, "passenger")
]))

# Route Search Sheet
screens.append(screen("Trip Search Sheet", 2500, y2, [
    rect(0, 0, 390, 500, C_SURFACE, 0, "Map UI Background"),
    rect(0, 340, 390, 504, C_BG, R_BOTTOM_SHEET, "Route Bottom Sheet", shadow=True),
    rect(170, 355, 50, 6, C_CARD, 3, "Sheet Handle"),
    
    text(24, 380, "Find a Shared Trip", 24, C_WHITE, "Bold"),
    gradient_card(24, 430, 342, 140, C_SURFACE, C_CARD, R_CARD, "Route Select Box"),
    rect(48, 460, 12, 12, C_GREEN, 6),
    text(72, 456, "Enter origin (e.g. Pune Station)", 15, C_TEXT_SEC, "Medium"),
    rect(53, 476, 2, 36, C_SURFACE),
    rect(48, 516, 12, 12, C_PRIMARY, 6),
    text(72, 512, "Enter destination (e.g. Mumbai Airport)", 15, C_WHITE, "Bold"),
    
    chip(24, 590, 100, 36, "📍 Wakad Bypass", C_SURFACE, C_WHITE, 12, 18),
    chip(132, 590, 110, 36, "📍 Hinjewadi Phase 1", C_SURFACE, C_WHITE, 12, 18),
    chip(250, 590, 90, 36, "📍 Baner Rd", C_SURFACE, C_WHITE, 12, 18),
    
    text(24, 646, "Schedule", 16, C_WHITE, "Bold"),
    chip(24, 676, 100, 36, "📅 Today", C_PRIMARY, C_WHITE, 13, 18),
    chip(132, 676, 110, 36, "📅 Tomorrow", C_SURFACE, C_TEXT_SEC, 13, 18),
    
    button(24, 740, 342, 56, "Search Available Commuters", C_PRIMARY_GLOW),
]))

# Search Results (Verified checklist & ratings)
screens.append(screen("Search Results", 3000, y2, [
    rect(0, 0, 390, 130, C_SURFACE, 0, "Top Route Indicator", shadow=True),
    text(24, 65, "Pune → Mumbai Airport", 18, C_WHITE, "Bold"),
    text(24, 90, "Today, 10:30 AM • 1 Seat needed", 13, C_TEXT_SEC, "Regular"),
    
    gradient_card(24, 150, 342, 200, C_SURFACE, C_CARD, R_CARD, "Traveler Card 1"),
    rect(44, 170, 48, 48, C_BG, 24, "Avatar Priya"),
    text(104, 172, "Priya K.", 16, C_WHITE, "Bold"),
    text(104, 192, "Identity & License Verified ✓ • 147 Completed", 12, C_GREEN, "Medium"),
    chip(260, 168, 86, 24, "★ 4.9 Rating", C_SURFACE, C_WHITE, 11, 12),
    image_card(260, 200, 95, 95, car_img, 0, "Mini Car"),
    text(44, 235, "Honda City (AC) • 2 seats left • Member since Jan 2024", 12, C_TEXT_SEC, "Regular"),
    text(44, 255, "Route Match: 96% (Direct Highway)", 13, C_GREEN, "Medium"),
    text(44, 288, "₹450", 24, C_PRIMARY_GLOW, "Bold"),
    button(246, 280, 100, 40, "Request", C_PRIMARY, C_WHITE, 13, 12),
    
    gradient_card(24, 366, 342, 200, C_SURFACE, C_CARD, R_CARD, "Traveler Card 2"),
    rect(44, 386, 48, 48, C_BG, 24, "Avatar Amit"),
    text(104, 388, "Amit Sharma", 16, C_WHITE, "Bold"),
    text(104, 408, "Identity & License Verified ✓ • 89 Completed", 12, C_GREEN, "Medium"),
    chip(260, 384, 86, 24, "★ 4.8 Rating", C_SURFACE, C_WHITE, 11, 12),
    image_card(260, 416, 95, 95, rikshaw_img, 0, "Mini Rikshaw"),
    text(44, 451, "Bajaj RE Auto • 1 seat left • Member since Feb 2024", 12, C_TEXT_SEC, "Regular"),
    text(44, 471, "Route Match: 88% (Intermediate stops)", 13, C_AMBER, "Medium"),
    text(44, 504, "₹250", 24, C_PRIMARY_GLOW, "Bold"),
    button(246, 496, 100, 40, "Request", C_PRIMARY, C_WHITE, 13, 12),
    
    *floating_glass_nav(1, "passenger")
]))

# Trip Details (Trust checklist & Timeline)
screens.append(screen("Trip Details", 3500, y2, [
    rect(0, 0, 390, 240, C_SURFACE, 0, "Trip Map Preview"),
    text(24, 70, "Trip Details", 24, C_WHITE, "Bold"),
    rect(0, 200, 390, 644, C_BG, R_BOTTOM_SHEET, "Trip Info Sheet"),
    rect(170, 212, 50, 6, C_SURFACE, 3),
    
    rect(24, 238, 56, 56, C_SURFACE, 28, "Traveler Pic"),
    text(96, 244, "Priya K.", 20, C_WHITE, "Bold"),
    text(96, 268, "Honda City • MH12-AB-9876", 13, C_TEXT_SEC, "Regular"),
    chip(280, 248, 86, 28, "License Verified ✓", {"r":0,"g":0.2,"b":0.1}, C_GREEN, 11, 14),
    
    # Timeline
    text(24, 310, "Trip Route & Stopovers", 16, C_WHITE, "Bold"),
    *timeline_progress(34, 346, [
        ("10:30 AM", "Pune Station", "Origin point"),
        ("11:10 AM", "Wakad Highway Bypass", "Stopover pick-up point"),
        ("01:45 PM", "Panvel Express Gate", "Stopover drop point"),
        ("02:15 PM", "Mumbai Airport (T2)", "Final Destination")
    ], 1),
    
    # 5. Trust & Safety Layer Before Joining Trip
    *verification_checklist(24, 595, completed_trips=147, member_since="Jan 2024"),
    
    rect(0, 740, 390, 104, C_SURFACE, 0, "Bottom Request Action"),
    text(24, 765, "SPLIT AMOUNT", 11, C_TEXT_SEC, "Bold"),
    text(24, 785, "₹450", 26, C_WHITE, "Bold"),
    button(180, 760, 186, 52, "Book Seat Now", C_PRIMARY_GLOW),
]))

# Request Seat Panel
screens.append(screen("Request Seat Panel", 4000, y2, [
    rect(0, 0, 390, 844, C_SURFACE, 0, "Background Blur Mock"),
    rect(0, 420, 390, 424, C_BG, R_BOTTOM_SHEET, "Confirm Seat Sheet", blur=True, shadow=True),
    rect(170, 432, 50, 6, C_CARD, 3),
    
    text(24, 460, "Confirm Seat Splitting", 24, C_WHITE, "Bold"),
    text(24, 492, "SPLIT RECEIPT SUMMARY", 11, C_TEXT_SEC, "Bold"),
    
    gradient_card(24, 516, 342, 120, C_SURFACE, C_CARD, R_CARD, "Receipt Breakdown"),
    text(44, 536, "Pune to Mumbai Seat Share", 14, C_WHITE, "Regular"),
    text(300, 536, "₹450", 14, C_WHITE, "Bold"),
    text(44, 560, "Spott Platform Safety Fee", 14, C_TEXT_SEC, "Regular"),
    text(300, 560, "₹35", 14, C_TEXT_SEC, "Regular"),
    text(44, 584, "Discounts (First ride)", 14, C_GREEN, "Regular"),
    text(294, 584, "- ₹50", 14, C_GREEN, "Bold"),
    
    rect(44, 614, 302, 1, C_SURFACE),
    text(44, 626, "Total split payload", 16, C_WHITE, "Bold"),
    text(290, 626, "₹435", 20, C_PRIMARY_GLOW, "Bold"),
    
    text(24, 690, "⚡ Instantly split and notify Priya", 13, C_TEXT_SEC, "Medium", w=342, align="CENTER"),
    
    button(24, 720, 342, 54, "Pay & Request Split", C_PRIMARY_GLOW),
    button(24, 782, 342, 50, "Decline / Cancel", C_CARD, C_TEXT_SEC),
]))


# --- ROW 3: Passenger Logistics (Parcel) (y=2000) ---
y3 = 2000
screens.append(screen("Send Parcel Form", 0, y3, [
    text(24, 72, "← Send Parcel", 24, C_WHITE, "Bold"),
    *hero_section(24, 120, 342, 160, parcel_img, "Same-day parcel network", "Vetted travelers carry your items securely.", "Active Deliveries"),
    
    text(24, 300, "1. WHAT ARE YOU SENDING?", 12, C_TEXT_SEC, "Bold"),
    gradient_card(24, 324, 104, 90, C_SURFACE, C_CARD, 16, "Docs Selection"),
    text(34, 344, "📄", 22, C_WHITE, "Bold"),
    text(34, 375, "Documents", 12, C_WHITE, "Bold"),
    
    gradient_card(142, 324, 104, 90, C_SURFACE, C_CARD, 16, "Box Selection"),
    text(152, 344, "📦", 22, C_WHITE, "Bold"),
    text(152, 375, "Medium Box", 12, C_TEXT_SEC, "Medium"),
    
    gradient_card(261, 324, 104, 90, C_SURFACE, C_CARD, 16, "Food Selection"),
    text(271, 344, "🥡", 22, C_WHITE, "Bold"),
    text(271, 375, "Perishable", 12, C_TEXT_SEC, "Medium"),
    
    text(24, 440, "2. TOTAL WEIGHT RANGE", 12, C_TEXT_SEC, "Bold"),
    chip(24, 464, 95, 36, "Under 1 kg", C_PRIMARY, C_WHITE, 12, 18),
    chip(129, 464, 95, 36, "1 - 5 kg", C_SURFACE, C_TEXT_SEC, 12, 18),
    chip(234, 464, 110, 36, "Over 5 kg", C_SURFACE, C_TEXT_SEC, 12, 18),
    
    text(24, 520, "3. LOGISTICS ROUTE", 12, C_TEXT_SEC, "Bold"),
    gradient_card(24, 544, 342, 110, C_SURFACE, C_CARD, R_CARD, "Route Form Card"),
    text(44, 560, "🟢 Pickup: Pune Station area", 14, C_WHITE, "Bold"),
    text(44, 610, "🔴 Dropoff: Mumbai Hub (Andheri)", 14, C_WHITE, "Bold"),
    
    button(24, 730, 342, 56, "Search Match Commuter", C_PRIMARY_GLOW),
]))

screens.append(screen("Track Parcel Timeline", 500, y3, [
    text(24, 72, "← Tracking Timeline", 24, C_WHITE, "Bold"),
    gradient_card(24, 120, 342, 110, C_SURFACE, C_CARD, R_CARD, "Timeline Status Widget"),
    text(44, 140, "Est. Arrival: 04:30 PM • Secure OTP required for handover", 12, C_TEXT_SEC, "Medium"),
    text(44, 162, "In Transit (Pune → Mumbai)", 22, C_WHITE, "Bold"),
    chip(255, 140, 95, 24, "On Time", {"r":0,"g":0.2,"b":0.1}, C_GREEN, 11, 12),
    
    text(24, 255, "TRACKING STEPS", 11, C_TEXT_SEC, "Bold"),
    *timeline_progress(34, 285, [
        ("02:00 PM", "Sender Handover", "Parcel verified by Traveler Rahul M."),
        ("02:45 PM", "Expressway Hub Passing", "Last GPS ping near Lonavala"),
        ("Pending", "Out for Delivery Hub", "Traveler reaching destination"),
        ("Pending", "Package Received", "Awaiting secure OTP from receiver")
    ], 1),
    
    gradient_card(24, 620, 342, 100, C_SURFACE, C_CARD, R_CARD, "Carrier Widget"),
    rect(44, 638, 48, 48, C_BG, 24, "Rahul Pic"),
    text(104, 642, "Rahul M. (Traveler)", 16, C_WHITE, "Bold"),
    text(104, 664, "Tata Nexon • MH12-EF-3344", 13, C_TEXT_SEC, "Regular"),
    button(250, 642, 95, 36, "Chat / Call", C_PRIMARY, C_WHITE, 12, 10),
]))

screens.append(screen("Parcel History", 1000, y3, [
    text(24, 72, "Logistics History", 24, C_WHITE, "Bold"),
    gradient_card(24, 120, 342, 130, C_SURFACE, C_CARD, R_CARD, "Past Parcel 1"),
    image_card(44, 135, 70, 70, parcel_img, 0, "Icon Parcel"),
    text(128, 140, "Document Folder (< 1kg)", 18, C_WHITE, "Bold"),
    text(128, 164, "Mumbai → Pune • Delivered", 13, C_TEXT_SEC, "Regular"),
    chip(128, 192, 110, 24, "Delivered 12 May", {"r":0,"g":0.15,"b":0.08}, C_GREEN, 11, 12),
    button(250, 190, 100, 30, "Receipt PDF", C_SURFACE, C_WHITE, 11, 10),
    
    gradient_card(24, 270, 342, 130, C_SURFACE, C_CARD, R_CARD, "Past Parcel 2"),
    image_card(44, 285, 70, 70, parcel_img, 0, "Icon Parcel"),
    text(128, 290, "Large Electronics Box", 18, C_WHITE, "Bold"),
    text(128, 314, "Pune → Bangalore • Cancelled", 13, C_TEXT_SEC, "Regular"),
    chip(128, 342, 110, 24, "Cancelled 08 May", {"r":0.2,"g":0,"b":0}, C_PRIMARY_GLOW, 11, 12),
]))

# --- ROW 4: Traveler Operations (y=3000) ---
y4 = 3000
screens.append(screen("Traveler Dashboard", 0, y4, [
    text(24, 70, "Traveler Dashboard", 28, C_WHITE, "Bold"),
    
    # 4. Traveler Availability Toggle at Top
    rect(24, 115, 342, 56, C_SURFACE, 18, "Availability Toggle Card"),
    text(44, 133, "🟢 Accepting Passengers & Parcels", 14, C_GREEN, "Bold"),
    rect(300, 130, 46, 26, C_GREEN, 13, "Toggle Switch Body"),
    rect(322, 133, 20, 20, C_WHITE, 10, "Toggle Knob"),
    
    # 2. Re-prioritize: Dashboard Hero focuses on NEXT TRIP (Not earnings first)
    gradient_card(24, 186, 342, 174, C_PRIMARY, C_PRIMARY_GLOW, R_CARD, "Next Trip Hero"),
    text(44, 206, "YOUR NEXT COMMUTE", 11, {"r":1,"g":0.8,"b":0.8}, "Bold"),
    text(44, 224, "Pune → Kolhapur", 24, C_WHITE, "Bold"),
    text(44, 252, "Today, 10:30 AM • Verna AC", 13, {"r":1,"g":0.9,"b":0.9}, "Medium"),
    
    chip(44, 284, 110, 24, "3 Seats Available", C_BG, C_WHITE, 11, 12),
    chip(160, 284, 120, 24, "2 Passengers Joined", C_BG, C_WHITE, 11, 12),
    chip(44, 314, 110, 24, "Parcel Enabled", C_BG, C_AMBER, 11, 12),
    
    # Earnings stats moved lower
    text(24, 380, "SPLITTED FUEL STATISTICS", 11, C_TEXT_SEC, "Bold"),
    *fintech_metric_card(24, 404, 342, 110, "Splitted fuel earnings", "₹4,890", "+22% this week"),
    
    gradient_card(24, 524, 163, 100, C_SURFACE, C_CARD, R_CARD, "Bento Stats 1"),
    text(40, 540, "Trips Done", 12, C_TEXT_SEC, "Medium"),
    text(40, 558, "34 Trips", 20, C_WHITE, "Bold"),
    chip(40, 588, 75, 20, "License Verified", {"r":0.1,"g":0.15,"b":0.3}, C_WHITE, 10, 8),
    
    gradient_card(203, 524, 163, 100, C_SURFACE, C_CARD, R_CARD, "Bento Stats 2"),
    text(219, 540, "Co2 Saved", 12, C_TEXT_SEC, "Medium"),
    text(219, 558, "124 kg", 20, C_GREEN, "Bold"),
    chip(219, 588, 80, 20, "Level 4 eco", {"r":0,"g":0.15,"b":0.08}, C_GREEN, 10, 8),
    
    *floating_glass_nav(0, "traveler")
]))

# Traveler Requests tab
screens.append(screen("Traveler Requests", 500, y4, [
    text(24, 70, "Commute Requests", 24, C_WHITE, "Bold"),
    
    # Passenger Request
    gradient_card(24, 120, 342, 180, C_SURFACE, C_CARD, R_CARD, "Req Passenger Card"),
    rect(44, 140, 48, 48, C_BG, 24, "User Pic"),
    text(104, 144, "Shreya Sen (Rating 4.9)", 16, C_WHITE, "Bold"),
    text(104, 166, "Identity & License Verified ✓ • 147 Completed", 12, C_GREEN, "Medium"),
    text(44, 200, "Pickup: Wakad flyover (+2 min deviation)", 13, C_TEXT_SEC, "Regular"),
    
    button(44, 240, 140, 40, "Decline", C_SURFACE, C_TEXT_SEC, 13, 12),
    button(194, 240, 152, 40, "Accept Seat", C_GREEN, C_WHITE, 13, 12),
    
    # Parcel Request
    gradient_card(24, 315, 342, 190, C_SURFACE, C_CARD, R_CARD, "Req Parcel Card"),
    image_card(44, 335, 70, 70, parcel_img, 0, "Parcel Image"),
    text(128, 337, "Documents Envelope", 18, C_WHITE, "Bold"),
    text(128, 361, "Sender: Amit S. • ID Verified ✓", 13, C_TEXT_SEC, "Regular"),
    text(128, 383, "Payout: ₹180 (No route offset)", 14, C_PRIMARY_GLOW, "Bold"),
    
    button(44, 435, 140, 40, "Decline", C_SURFACE, C_TEXT_SEC, 13, 12),
    button(194, 435, 152, 40, "Accept Carry", C_PRIMARY_GLOW, C_WHITE, 13, 12),
    
    *floating_glass_nav(1, "traveler")
]))

# Traveler Trips Tab
screens.append(screen("Traveler Trips", 1000, y4, [
    text(24, 72, "Offered Commutes", 24, C_WHITE, "Bold"),
    
    gradient_card(24, 120, 342, 170, C_SURFACE, C_CARD, R_CARD, "Manage Card 1"),
    chip(44, 140, 80, 24, "Active offering", C_PRIMARY, C_WHITE, 11, 12),
    text(44, 175, "Pune → Mumbai Express", 20, C_WHITE, "Bold"),
    text(44, 200, "Today, 10:30 AM • Verna AC", 13, C_TEXT_SEC, "Regular"),
    text(44, 225, "Seats: 3 / 4 filled", 14, C_GREEN, "Bold"),
    button(230, 220, 110, 40, "Close booking", C_SURFACE, C_WHITE, 12, 12),
    
    gradient_card(24, 305, 342, 140, C_SURFACE, C_CARD, R_CARD, "Manage Card 2"),
    chip(44, 325, 95, 24, "Trip Completed", C_CARD, C_TEXT_SEC, 11, 12),
    text(44, 360, "Mumbai → Pune Bypass", 18, C_WHITE, "Bold"),
    text(44, 382, "Completed 31 May • Earned ₹1,250", 13, C_TEXT_SEC, "Regular"),
    
    *floating_glass_nav(2, "traveler")
]))

# 8. NEW: Traveler Vehicle tab (heavily used verification screen)
screens.append(screen("Traveler Vehicle", 1500, y4, [
    text(24, 70, "Your Vehicle Profile", 24, C_WHITE, "Bold"),
    
    # Vehicle Display Card
    gradient_card(24, 120, 342, 170, C_PRIMARY, C_PRIMARY_GLOW, R_CARD, "Vehicle Banner"),
    text(44, 140, "REGISTERED COMMUTE VEHICLE", 11, {"r":1,"g":0.8,"b":0.8}, "Bold"),
    text(44, 158, "Hyundai Verna 1.5", 22, C_WHITE, "Bold"),
    text(44, 186, "License Plate: MH12-AB-9876", 13, {"r":1,"g":0.9,"b":0.9}, "Medium"),
    chip(44, 218, 110, 24, "RC Verified ✓", C_BG, C_GREEN, 11, 12),
    chip(160, 218, 120, 24, "Insurance Active ✓", C_BG, C_GREEN, 11, 12),
    image_card(250, 130, 100, 100, car_img, 0, "Car Badge"),
    
    # Vehicle Details List
    text(24, 310, "VEHICLE SPECIFICATIONS", 11, C_TEXT_SEC, "Bold"),
    gradient_card(24, 334, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 354, "Seat Capacity", 15, C_TEXT_SEC, "Medium"),
    text(280, 354, "4 Seats Max", 15, C_WHITE, "Bold"),
    
    gradient_card(24, 404, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 424, "Parcel Capacity Limit", 15, C_TEXT_SEC, "Medium"),
    text(250, 424, "Up to 15 kg (Trunk)", 15, C_WHITE, "Bold"),
    
    gradient_card(24, 474, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 494, "Amenities (AC, Music, Charger)", 15, C_TEXT_SEC, "Medium"),
    text(300, 494, "All Verified ✓", 15, C_GREEN, "Bold"),
    
    # Availability settings
    text(24, 555, "VEHICLE ACTIVE STATUS", 11, C_TEXT_SEC, "Bold"),
    gradient_card(24, 579, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 599, "Auto-match searches", 15, C_WHITE, "Medium"),
    text(280, 599, "ENABLED ✓", 14, C_GREEN, "Bold"),
    
    *floating_glass_nav(3, "traveler")
]))

# Traveler Profile Tab
screens.append(screen("Traveler Profile", 2000, y4, [
    text(24, 70, "Traveler Profile", 24, C_WHITE, "Bold"),
    rect(145, 120, 100, 100, C_SURFACE, 50, "Profile Pic"),
    text(24, 235, "Rahul Malhotra", 22, C_WHITE, "Bold", w=342, align="CENTER"),
    text(24, 262, "Member since Feb 2024", 13, C_TEXT_SEC, "Medium", w=342, align="CENTER"),
    
    *verification_checklist(24, 295, completed_trips=89, member_since="Feb 2024"),
    
    gradient_card(24, 475, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 495, "Driving History Logs", 15, C_WHITE, "Medium"),
    
    gradient_card(24, 545, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 565, "Payout Bank Account", 15, C_WHITE, "Medium"),
    
    *floating_glass_nav(4, "traveler")
]))

# Create Trip Wizard
screens.append(screen("Create Trip Wizard", 2500, y4, [
    text(24, 70, "Offer a Shared Ride", 24, C_WHITE, "Bold"),
    text(24, 102, "Progress: Route parameters (Step 1 of 5)", 13, C_PRIMARY_GLOW, "Medium"),
    rect(24, 125, 60, 5, C_PRIMARY_GLOW, 3),
    rect(88, 125, 60, 5, C_SURFACE, 3),
    rect(152, 125, 60, 5, C_SURFACE, 3),
    rect(216, 125, 60, 5, C_SURFACE, 3),
    rect(280, 125, 60, 5, C_SURFACE, 3),
    
    text(24, 160, "1. DEFINE ROUTE", 12, C_TEXT_SEC, "Bold"),
    gradient_card(24, 184, 342, 130, C_SURFACE, C_CARD, R_CARD, "Wizard Route Card"),
    rect(48, 208, 10, 10, C_GREEN, 5), text(68, 204, "Start (e.g. Baner, Pune)", 14, C_TEXT_SEC, "Medium"),
    rect(48, 268, 10, 10, C_PRIMARY_GLOW, 5), text(68, 264, "Stop (e.g. Bandra, Mumbai)", 14, C_WHITE, "Bold"),
    
    text(24, 340, "2. VEHICLE OPTIONS", 12, C_TEXT_SEC, "Bold"),
    chip(24, 364, 100, 36, "🚗 Verna (AC)", C_PRIMARY, C_WHITE, 12, 18),
    chip(132, 364, 110, 36, "🏍️ Pulsar 220", C_SURFACE, C_TEXT_SEC, 12, 18),
    
    text(24, 430, "3. SEATS CAPACITY", 12, C_TEXT_SEC, "Bold"),
    rect(24, 454, 160, 50, C_SURFACE, 14, "Capacity Stepper"),
    text(24, 468, "-   3 seats   +", 16, C_WHITE, "Bold", w=160, align="CENTER"),
    
    text(24, 530, "4. RECOMMENDED SPLIT", 12, C_TEXT_SEC, "Bold"),
    gradient_card(24, 554, 342, 80, C_SURFACE, C_CARD, R_CARD, "Pricing Rec"),
    text(44, 570, "Suggested share per seat: ₹420 - ₹480", 14, C_WHITE, "Bold"),
    text(44, 592, "Splitting at this rate fills seats 90% faster.", 12, C_GREEN, "Regular"),
    
    button(24, 730, 342, 56, "Confirm and Setup Rules", C_PRIMARY_GLOW),
]))

# --- ROW 5: Settings / Edge States (y=4000) ---
y5 = 4000
screens.append(screen("Active Trip Screen", 0, y5, [
    rect(0, 0, 390, 844, C_SURFACE, 0, "Active Map View"),
    
    rect(24, 70, 110, 90, {"r": 0, "g": 0, "b": 0, "a": 0.8}, 20, "Speedometer Widget", blur=True),
    text(24, 88, "Speed", 12, C_TEXT_SEC, "Medium", w=110, align="CENTER"),
    text(24, 108, "84 km/h", 22, C_GREEN, "Bold", w=110, align="CENTER"),
    
    rect(144, 70, 222, 90, {"r": 0, "g": 0, "b": 0, "a": 0.8}, 20, "ETA Widget", blur=True),
    text(164, 88, "Next Stop: Wakad Toll Gate", 13, C_WHITE, "Bold"),
    text(164, 112, "ETA: 12 mins • 8.4 km away", 12, C_TEXT_SEC, "Regular"),
    
    rect(0, 580, 390, 264, C_BG, R_BOTTOM_SHEET, "Active Commute Controls"),
    rect(170, 592, 50, 6, C_CARD, 3),
    text(24, 620, "En Route (Pune → Mumbai)", 22, C_WHITE, "Bold"),
    text(24, 646, "Traveler: Rahul • Verna (MH12)", 13, C_TEXT_SEC, "Regular"),
    
    button(24, 690, 342, 54, "Share Commute Link", C_CARD, C_WHITE),
    button(24, 752, 342, 54, "EMERGENCY SAFETY SOS", C_PRIMARY, C_WHITE),
]))

screens.append(screen("Safety Center", 500, y5, [
    text(24, 70, "Safety Hub", 28, C_WHITE, "Bold"),
    
    gradient_card(24, 120, 342, 150, C_PRIMARY, C_PRIMARY_GLOW, R_CARD, "SOS Pulse Card"),
    text(44, 140, "EMERGENCY ALERT SYSTEM", 11, {"r":1,"g":0.8,"b":0.8}, "Bold"),
    text(44, 160, "Instantly trigger SOS", 24, C_WHITE, "Bold"),
    text(44, 190, "Notifies local police (112) and your trusted contacts immediately.", 13, {"r":1,"g":0.9,"b":0.9}, "Regular", w=220),
    image_card(260, 140, 90, 90, safety_img, 0, "SOS Image"),
    
    gradient_card(24, 285, 342, 90, C_SURFACE, C_CARD, R_CARD, "Safety Card 1"),
    text(44, 305, "Share Live Tracking", 16, C_WHITE, "Bold"),
    text(44, 327, "Send permanent GPS tracking link to relatives.", 13, C_TEXT_SEC, "Regular"),
    
    gradient_card(24, 390, 342, 90, C_SURFACE, C_CARD, R_CARD, "Safety Card 2"),
    text(44, 410, "Trusted Contacts Hub", 16, C_WHITE, "Bold"),
    text(44, 432, "Manage up to 5 relatives who receive emergency SMS.", 13, C_TEXT_SEC, "Regular"),
    
    gradient_card(24, 495, 342, 90, C_SURFACE, C_CARD, R_CARD, "Safety Card 3"),
    text(44, 515, "Log Incident / Report", 16, C_WHITE, "Bold"),
    text(44, 537, "Flag erratic behavior, unsafe driving, or delays.", 13, C_TEXT_SEC, "Regular"),
    
    button(24, 740, 342, 56, "Access Help Desk Support", C_SURFACE, C_WHITE),
]))

screens.append(screen("Settings", 1000, y5, [
    text(24, 70, "Settings", 24, C_WHITE, "Bold"),
    
    text(24, 120, "USER PREFERENCES", 11, C_TEXT_SEC, "Bold"),
    gradient_card(24, 144, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 164, "Push Notification triggers", 15, C_WHITE, "Medium"),
    
    gradient_card(24, 214, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 234, "App Language selection", 15, C_WHITE, "Medium"),
    text(280, 234, "English", 14, C_TEXT_SEC, "Regular"),
    
    text(24, 300, "LEGAL & LOGISTICS RULES", 11, C_TEXT_SEC, "Bold"),
    gradient_card(24, 324, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 344, "Terms of Commute Service", 15, C_WHITE, "Medium"),
    
    gradient_card(24, 394, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 414, "Privacy Guidelines Hub", 15, C_WHITE, "Medium"),
    
    text(24, 480, "CARRIER SETTINGS", 11, C_TEXT_SEC, "Bold"),
    gradient_card(24, 504, 342, 60, C_SURFACE, C_CARD, 16),
    text(44, 524, "Vehicle Registration details", 15, C_WHITE, "Medium"),
    
    button(24, 730, 342, 56, "Log Out Securely", C_SURFACE, C_PRIMARY_GLOW),
]))

# --- Illustration Edge Cases ---
screens.append(screen("Empty State", 1500, y5, [
    rect(145, 240, 100, 100, C_SURFACE, 50, "Vector circle background", shadow=True),
    text(145, 275, "🔍", 36, C_WHITE, "Bold", w=100, align="CENTER"),
    
    text(24, 380, "No Active Commutes", 24, C_WHITE, "Bold", w=342, align="CENTER"),
    text(24, 415, "You don\\'t have any upcoming or active cost-sharing trips scheduled.", 14, C_TEXT_SEC, "Regular", w=342, align="CENTER"),
    
    button(75, 480, 240, 56, "Offer a Shared Ride", C_PRIMARY_GLOW),
    button(75, 546, 240, 56, "Search Available Rides", C_SURFACE, C_WHITE),
]))

# 6. Redesigned Search Results empty states to feature "Create Route Alert"
screens.append(screen("No Search Results", 2000, y5, [
    rect(145, 240, 100, 100, C_SURFACE, 50, "Vector circle background"),
    text(145, 275, "📍", 36, C_WHITE, "Bold", w=100, align="CENTER"),
    
    text(24, 380, "No Commuters Found", 24, C_WHITE, "Bold", w=342, align="CENTER"),
    text(24, 415, "We couldn\\'t find anyone traveling this route. Create an alert to get notified when a traveler posts a match.", 14, C_TEXT_SEC, "Regular", w=342, align="CENTER"),
    
    # 7. Route Alert System & Growth CTAs
    button(75, 485, 240, 54, "Create Route Alert 🔔", C_PRIMARY_GLOW),
    button(75, 548, 240, 50, "Offer My Own Trip 🚗", C_SURFACE, C_WHITE),
]))

screens.append(screen("Network Error", 2500, y5, [
    rect(145, 240, 100, 100, {"r": 0.2, "g": 0, "b": 0}, 50, "Vector circle background"),
    text(145, 275, "📶", 36, C_PRIMARY_GLOW, "Bold", w=100, align="CENTER"),
    
    text(24, 380, "Connection Interrupted", 24, C_WHITE, "Bold", w=342, align="CENTER"),
    text(24, 415, "We lost connection to the cost-splitting servers. Check your cellular data or Wi-Fi.", 14, C_TEXT_SEC, "Regular", w=342, align="CENTER"),
    
    button(75, 480, 240, 56, "Reconnect Now", C_PRIMARY_GLOW),
]))

screens.append(screen("Maintenance", 3000, y5, [
    rect(145, 240, 100, 100, C_SURFACE, 50, "Vector circle background"),
    text(145, 275, "⚙️", 36, C_WHITE, "Bold", w=100, align="CENTER"),
    
    text(24, 380, "Optimizing Platform", 24, C_WHITE, "Bold", w=342, align="CENTER"),
    text(24, 415, "Spott is undergoing backend optimizations. We\\'ll be back shortly to share fuel split payloads.", 14, C_TEXT_SEC, "Regular", w=342, align="CENTER"),
]))

screens.append(screen("Verification Pending", 3500, y5, [
    rect(145, 240, 100, 100, {"r":0,"g":0.15,"b":0.08}, 50, "Vector circle background"),
    image_card(145, 240, 100, 100, verification_img, 50, "Verification Image"),
    
    text(24, 380, "Validation In Progress", 24, C_WHITE, "Bold", w=342, align="CENTER"),
    text(24, 415, "Our compliance team is verifying your Aadhar card and driving documents (ETA 12 mins).", 14, C_TEXT_SEC, "Regular", w=342, align="CENTER"),
    
    button(75, 480, 240, 56, "Refresh Document Status", C_PRIMARY_GLOW),
]))

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

print("Compiling JS screens array...")
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
    if (base64[base64.length - 2] === '=') {
      bufferLength--;
    }
  }
  
  const arrayBuffer = new ArrayBuffer(bufferLength);
  const bytes = new Uint8Array(arrayBuffer);
  
  let p = 0;
  for (let i = 0; i < base64.length; i += 4) {
    const encoded1 = lookup[base64.charCodeAt(i)];
    const encoded2 = lookup[base64.charCodeAt(i + 1)];
    const encoded3 = lookup[base64.charCodeAt(i + 2)];
    const encoded4 = lookup[base64.charCodeAt(i + 3)];
    
    bytes[p++] = (encoded1 << 2) | (encoded2 >> 4);
    if (p < bufferLength) {
      bytes[p++] = ((encoded2 & 15) << 4) | (encoded3 >> 2);
    }
    if (p < bufferLength) {
      bytes[p++] = ((encoded3 & 3) << 6) | (encoded4 & 63);
    }
  }
  return bytes;
}

function rgba(color) {
  const safeColor = color || { r: 0, g: 0, b: 0 };
  return {
    r: safeColor.r !== undefined ? safeColor.r : 0,
    g: safeColor.g !== undefined ? safeColor.g : 0,
    b: safeColor.b !== undefined ? safeColor.b : 0,
  };
}

function createFill(color) {
  const safeFill = color || { r: 0, g: 0, b: 0 };
  const opacity = safeFill.a !== undefined ? safeFill.a : 1.0;
  return {
    type: 'SOLID',
    color: {
      r: safeFill.r !== undefined ? safeFill.r : 0,
      g: safeFill.g !== undefined ? safeFill.g : 0,
      b: safeFill.b !== undefined ? safeFill.b : 0,
    },
    opacity: opacity
  };
}

function applyTextStyles(node, item) {
  node.fontName = item.font || { family: 'Inter', style: 'Regular' };
  node.fontSize = item.fontSize || 14;
  node.fills = [{ type: 'SOLID', color: rgba(item.color || item.textColor) }];
  node.textAlignHorizontal = item.align || 'LEFT';
  node.textAlignVertical = 'TOP';
  node.textAutoResize = 'WIDTH_AND_HEIGHT';
  node.letterSpacing = { value: 0, unit: 'PIXELS' };
  node.lineHeight = { value: node.fontSize * 1.2, unit: 'PIXELS' };
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
  } else if (item.height) {
    node.resize(item.width || node.width, item.height);
  }
  return node;
}

function createRectangle(item) {
  const node = figma.createRectangle();
  node.resize(item.width, item.height);
  node.x = item.x;
  node.y = item.y;
  
  if (item.base64) {
    const bytes = base64ToBytes(item.base64);
    const image = figma.createImage(bytes);
    node.fills = [{ type: 'IMAGE', imageHash: image.hash, scaleMode: 'FILL' }];
  } else if (item.color1 && item.color2) {
    node.fills = [{
      type: 'GRADIENT_LINEAR',
      gradientTransform: [[0, 0.5, 0.5], [1, 0.5, 0.5]],
      gradientStops: [
        { position: 0, color: { r: item.color1.r, g: item.color1.g, b: item.color1.b, a: 1 } },
        { position: 1, color: { r: item.color2.r, g: item.color2.g, b: item.color2.b, a: 1 } }
      ]
    }];
  } else {
    node.fills = [createFill(item.fill)];
  }
  
  if (item.cornerRadius !== undefined) node.cornerRadius = item.cornerRadius;
  
  const effects = [];
  if (item.hasBlur) {
    effects.push({
      type: 'BACKGROUND_BLUR',
      radius: 20,
      visible: true
    });
  }
  if (item.hasShadow) {
    effects.push({
      type: 'DROP_SHADOW',
      color: { r: 0, g: 0, b: 0, a: 0.4 },
      offset: { x: 0, y: 8 },
      radius: 20,
      visible: true,
      blendMode: 'NORMAL'
    });
  }
  if (effects.length > 0) {
    node.effects = effects;
  }
  
  if (item.name) node.name = item.name;
  return node;
}

function createButton(item) {
  const button = figma.createRectangle();
  button.resize(item.width, item.height);
  button.x = 0;
  button.y = 0;
  button.fills = [createFill(item.fill)];
  button.cornerRadius = item.cornerRadius !== undefined ? item.cornerRadius : 14;

  const groupChildren = [button];
  if (item.text) {
    const label = figma.createText();
    label.characters = item.text;
    label.fontName = item.font || { family: 'Inter', style: 'Bold' };
    label.fontSize = item.fontSize || 16;
    label.textAlignHorizontal = 'CENTER';
    label.textAlignVertical = 'CENTER';
    label.textAutoResize = 'WIDTH_AND_HEIGHT';
    label.fills = [{ type: 'SOLID', color: rgba(item.textColor || { r: 1, g: 1, b: 1 }) }];
    label.resize(item.width, item.height);
    label.x = 0;
    label.y = (item.height - label.height) / 2;
    groupChildren.push(label);
  }

  const group = figma.group(groupChildren, figma.currentPage);
  group.x = item.x;
  group.y = item.y;
  group.name = item.name || 'Button';
  return group;
}

function createChip(item) {
  const chip = figma.createRectangle();
  chip.resize(item.width, item.height);
  chip.x = 0;
  chip.y = 0;
  chip.fills = [createFill(item.fill)];
  chip.cornerRadius = item.cornerRadius !== undefined ? item.cornerRadius : 14;

  const groupChildren = [chip];
  if (item.text) {
    const label = figma.createText();
    label.characters = item.text;
    label.fontName = item.font || { family: 'Inter', style: 'Medium' };
    label.fontSize = item.fontSize || 13;
    label.textAlignHorizontal = 'CENTER';
    label.textAlignVertical = 'CENTER';
    label.textAutoResize = 'WIDTH_AND_HEIGHT';
    label.fills = [{ type: 'SOLID', color: rgba(item.textColor || { r: 1, g: 1, b: 1 }) }];
    label.resize(item.width, item.height);
    label.x = 0;
    label.y = (item.height - label.height) / 2;
    groupChildren.push(label);
  }

  const group = figma.group(groupChildren, figma.currentPage);
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
  figma.closePlugin('Spotter Premium Experience UI created successfully!');
}

main();
"""

full_code = js_screens_str + js_rest

with open(code_js_path, 'w', encoding='utf-8') as f:
    f.write(full_code)

print(f"Successfully compiled code.js at: {code_js_path}")
print(f"Total premium screens: {len(screens)}")
