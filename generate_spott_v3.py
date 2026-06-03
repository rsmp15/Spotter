import json
import base64
import os
from io import BytesIO
from PIL import Image

# ─── DESIGN TOKENS (Premium HSL-tailored Dark Mode & Rich Palette System) ────────
# Charcoal and warm dark surfaces, pure black #000000 is avoided for components
BG           = {"r": 0.031, "g": 0.031, "b": 0.031}       # #080808 (Base Background)
SURF1        = {"r": 0.071, "g": 0.071, "b": 0.071}       # #121212 (Primary charcoal surface)
SURF2        = {"r": 0.102, "g": 0.102, "b": 0.102}       # #1A1A1A (Secondary charcoal surface)
SURF3        = {"r": 0.137, "g": 0.137, "b": 0.137}       # #232323 (Interactive/Bento card surface)
ACCENT       = {"r": 0.902, "g": 0.0,   "b": 0.137}       # #E60023 (Brand Pinterest Red)
PURPLE       = {"r": 0.545, "g": 0.361, "b": 0.965}       # #8B5CF6 (Electric Purple for Premium secondary actions)
SUCCESS      = {"r": 0.063, "g": 0.725, "b": 0.506}       # #10B981 (Emerald Success / Cost Recovery)
SAFETY       = {"r": 0.961, "g": 0.620, "b": 0.043}       # #F59E0B (Amber Gold warn/rating/safety)
INFO         = {"r": 0.024, "g": 0.714, "b": 0.831}       # #06B6D4 (Cyan Info / GPS Live updates)
GLOW         = {"r": 1.0,   "g": 0.2,   "b": 0.333}       # #FF3355 (Vibrant highlight)
WHITE        = {"r": 1.0,   "g": 1.0,   "b": 1.0}
MUTED        = {"r": 0.631, "g": 0.631, "b": 0.667}       # #A1A1AA (Zinc Muted text)
DIM          = {"r": 0.400, "g": 0.400, "b": 0.420}       # Dim text for lower emphasis
DIVIDER      = {"r": 0.145, "g": 0.145, "b": 0.155}       # Subtle grid lines
GLASS_BORDER = {"r": 0.200, "g": 0.200, "b": 0.210}       # Subtle glass border

# Tinted surface overlays for background glows
ACC_SURF     = {"r": 0.180, "g": 0.040, "b": 0.055}       # Red tint
PURP_SURF    = {"r": 0.080, "g": 0.050, "b": 0.150}       # Purple tint
SUC_SURF     = {"r": 0.040, "g": 0.145, "b": 0.075}       # Green tint
SAF_SURF     = {"r": 0.160, "g": 0.120, "b": 0.030}       # Amber tint
INF_SURF     = {"r": 0.010, "g": 0.110, "b": 0.130}       # Cyan tint

# SKELETON LOADERS COLOR TOKENS
SKEL_BG      = {"r": 0.150, "g": 0.150, "b": 0.160}       # Base skeleton grey
SKEL_HI      = {"r": 0.220, "g": 0.220, "b": 0.230}       # Highlight shimmer grey

# ─── LAYOUT CONSTANTS ───────────────────────────────────────────
SW, SH       = 390, 844  # Premium mobile screen template
PAD          = 24            # Clean outer grid margins
CW           = SW - 2*PAD    # Content width = 342

# Columns & Rows grid coordinates
COLS = [80, 520, 960, 1400, 1840, 2280]
ROWS = [220, 1150, 2080, 3010, 3940, 4870, 5800]

# ─── PRIMITIVE NODE BUILDERS ────────────────────────────────────
def T(x, y, txt, sz=14, col=WHITE, style='Regular', name=None, w=None, h=None):
    o = {"type":"text","x":x,"y":y,"text":txt,
         "font":{"family":"Inter","style":style},"fontSize":sz,"color":col,
         "name":name or txt[:15]}
    if w: o["width"]=w
    if h: o["height"]=h
    return o

def R(x, y, w, h, fill=SURF2, rad=20, name="Rect"):
    return {"type":"rect","x":x,"y":y,"width":w,"height":h,
            "fill":fill,"cornerRadius":rad,"name":name}

def B(x, y, w, h, label, fill=ACCENT, tcol=WHITE, rad=14, sz=15, name=None):
    return {"type":"button","x":x,"y":y,"width":w,"height":h,
            "fill":fill,"cornerRadius":rad,"text":label,"textColor":tcol,
            "font":{"family":"Inter","style":"Bold"},"fontSize":sz,
            "name":name or f"Btn - {label}"}

def C(x, y, w, h, label, fill=SURF3, tcol=WHITE, sz=11, name=None):
    return {"type":"chip","x":x,"y":y,"width":w,"height":h,
            "fill":fill,"cornerRadius":rad if (rad := h//2) else 14,
            "text":label,"textColor":tcol,
            "font":{"family":"Inter","style":"Semi Bold"},"fontSize":sz,
            "name":name or f"Chip - {label}"}

def IMG_R(x, y, w, h, img_key, rad=16, name="Image"):
    return {"type":"image_rect","x":x,"y":y,"width":w,"height":h,
            "imageKey":img_key,"cornerRadius":rad,"name":name}

# ─── COMPOSITE BUILDERS ─────────────────────────────────────────
def status_bar(sx, sy):
    return [
        T(sx+28, sy+14, "9:41", sz=14, style="Semi Bold", col=WHITE),
        R(sx+145, sy+12, 100, 18, fill=BG, rad=9, name="Dynamic Island"),
        T(sx+310, sy+14, "5G 📶", sz=11, style="Semi Bold", col=MUTED),
    ]

def nav_passenger(sx, sy, active=0):
    items = ["Home","Explore","Trips","Activity","Profile"]
    icons = ["⌂","◈","▣","◷","●"]
    els = [R(sx, sy+SH-80, SW, 80, fill=SURF1, rad=0, name="Nav Bar")]
    els.append(R(sx, sy+SH-80, SW, 1, fill=DIVIDER, rad=0, name="Nav Border"))
    iw = SW // len(items)
    for i, (item, icon) in enumerate(zip(items, icons)):
        cx = sx + i*iw + iw//2
        is_active = i == active
        c = ACCENT if is_active else DIM
        els.append(T(cx-6, sy+SH-64, icon, sz=18, col=c, style="Bold", name=f"Nav Icon {item}"))
        els.append(T(cx-18, sy+SH-40, item, sz=9, col=c, style="Semi Bold" if is_active else "Regular", name=f"Nav Label {item}"))
        if is_active:
            els.append(R(cx-2, sy+SH-82, 4, 4, fill=ACCENT, rad=2, name="Active Dot"))
    return els

def nav_traveler(sx, sy, active=0):
    items = ["Dashboard","Requests","Trips","Vehicle","Profile"]
    icons = ["◉","◈","▣","🚗","●"]
    els = [R(sx, sy+SH-80, SW, 80, fill=SURF1, rad=0, name="Nav Bar")]
    els.append(R(sx, sy+SH-80, SW, 1, fill=DIVIDER, rad=0, name="Nav Border"))
    iw = SW // len(items)
    for i, (item, icon) in enumerate(zip(items, icons)):
        cx = sx + i*iw + iw//2
        is_active = i == active
        c = PURPLE if is_active else DIM
        els.append(T(cx-6, sy+SH-64, icon, sz=18, col=c, style="Bold", name=f"Nav Icon {item}"))
        els.append(T(cx-18, sy+SH-40, item, sz=9, col=c, style="Semi Bold" if is_active else "Regular", name=f"Nav Label {item}"))
        if is_active:
            els.append(R(cx-2, sy+SH-82, 4, 4, fill=PURPLE, rad=2, name="Active Dot"))
    return els

def avatar_premium(x, y, sz, initial, bg=SURF3, verified=False, ring=True, ring_color=ACCENT):
    els = []
    if ring:
        els.append(R(x-3, y-3, sz+6, sz+6, fill=ring_color, rad=(sz+6)//2, name=f"Ring {initial}"))
        els.append(R(x-2, y-2, sz+4, sz+4, fill=BG, rad=(sz+4)//2, name="Ring Space"))
    els.append(R(x, y, sz, sz, fill=bg, rad=sz//2, name=f"Avatar {initial}"))
    els.append(T(x+sz//2-5, y+sz//2-10, initial, sz=sz//2, style="Bold", col=WHITE, name=f"Initial {initial}"))
    if verified:
        els.append(R(x+sz-12, y+sz-12, 16, 16, fill=SUCCESS, rad=8, name="Verified Dot"))
        els.append(T(x+sz-9, y+sz-13, "✓", sz=9, col=WHITE, style="Bold", name="Check"))
    return els

def glass_card(sx, sy, y_start, w, h, fill=SURF2, border=True, name="Glass Card"):
    els = []
    if border:
        els.append(R(sx, sy+y_start-1, w, h+2, fill=GLASS_BORDER, rad=23, name=f"{name} Border"))
    els.append(R(sx, sy+y_start, w, h, fill=fill, rad=22, name=name))
    return els

def hero_banner(sx, sy, y_start, height=220, title="Travel Smarter", subtitle="Find verified travels", accent_line=ACCENT, orb_fill=ACC_SURF):
    return [
        # Hero Base
        R(sx+PAD, sy+y_start, CW, height, fill=SURF2, rad=28, name="Hero Base"),
        R(sx+PAD, sy+y_start, CW, height//2, fill=orb_fill, rad=28, name="Hero Gradient Glow"),
        R(sx+PAD, sy+y_start, CW, 4, fill=accent_line, rad=2, name="Hero Accent Line"),
        # Floating glow elements
        R(sx+CW-20, sy+y_start+20, 60, 60, fill=orb_fill, rad=30, name="Glow Orb 1"),
        R(sx+40, sy+y_start+height-50, 40, 40, fill=orb_fill, rad=20, name="Glow Orb 2"),
        # Typography Header
        T(sx+PAD+20, sy+y_start+24, title, sz=22, style="Bold", col=WHITE, name="Hero Title"),
        T(sx+PAD+20, sy+y_start+56, subtitle, sz=12, col=MUTED, w=CW-40, name="Hero Subtitle"),
    ]

# ─── SIGNATURE SPOTT COMPONENT: ROUTE CARD ──────────────────────
def route_card(sx, sy, y, from_city, to_city, count, price, accent_color=ACCENT, type_label="Traveler", card_name="Route Card"):
    return [
        # Card Surface
        *glass_card(sx+PAD, sy, y, CW, 145, fill=SURF2, border=True, name=card_name),
        # Route connectors visual
        R(sx+42, sy+y+35, 10, 10, fill=accent_color, rad=5, name="From Dot"),
        R(sx+46, sy+y+47, 2, 44, fill=DIVIDER, rad=0, name="Connector Line"),
        R(sx+42, sy+y+93, 10, 10, fill=SUCCESS, rad=5, name="To Dot"),
        # City labels
        T(sx+64, sy+y+30, from_city, sz=16, style="Bold", col=WHITE),
        T(sx+64, sy+y+88, to_city, sz=16, style="Bold", col=WHITE),
        # Sub-details
        T(sx+64, sy+y+60, f"{count} active {type_label}s today", sz=11, col=MUTED),
        # Pricing and Action CTA
        T(sx+SW-PAD-100, sy+y+32, f"₹{price}", sz=20, style="Bold", col=SUCCESS),
        T(sx+SW-PAD-100, sy+y+56, "cost share", sz=10, col=MUTED),
        B(sx+SW-PAD-110, sy+y+86, 90, 32, "View →", fill=SURF3, tcol=WHITE, rad=16, sz=12)
    ]

def trust_badge_row(sx, sy, y):
    return [
        R(sx+PAD, sy+y, CW, 48, fill=SURF1, rad=14, name="Trust Badges Container"),
        T(sx+PAD+15, sy+y+17, "✓ ID Verified", sz=11, col=SUCCESS, style="Semi Bold"),
        T(sx+PAD+118, sy+y+17, "✓ DL Verified", sz=11, col=SUCCESS, style="Semi Bold"),
        T(sx+PAD+215, sy+y+17, "✓ Vehicle Verified", sz=11, col=SUCCESS, style="Semi Bold")
    ]

def motion_layer_tag(sx, sy, x_off=PAD, y_off=78, motion_type="Surface Lift"):
    return [
        C(sx+SW-PAD-110, sy+y_off, 110, 22, f"⚡ {motion_type}", fill=PURP_SURF, tcol=PURPLE, sz=9, name="Motion Spec Tag")
    ]

def section_title(sx, sy, y_offset, title, subtitle=None):
    els = [T(sx+PAD, sy+y_offset, title, sz=18, style="Bold", col=WHITE)]
    if subtitle:
        els.append(T(sx+PAD, sy+y_offset+26, subtitle, sz=13, col=MUTED))
    return els

def divider(sx, sy, y_offset):
    return R(sx+PAD, sy+y_offset, CW, 1, fill=DIVIDER, rad=0, name="Divider")

def screen(name, col, row, children, fill=BG):
    return {"name":name,"x":COLS[col],"y":ROWS[row],
            "width":SW,"height":SH,"fill":fill,"children":children}

# ─── COMPRESS & ENCODE ASSETS (Optimized production workflow) ──────
base_dir = r"D:\PROJECTS\Spotter\spotter"
image_files = {
    "bike": os.path.join(base_dir, "Bike.png"),
    "calendar": os.path.join(base_dir, "Calendar.png"),
    "car": os.path.join(base_dir, "Car.png"),
    "parcel": os.path.join(base_dir, "Parcel.png"),
    "rikshaw": os.path.join(base_dir, "Rikshaw.png"),
    "route": os.path.join(base_dir, "route.png"),
    "safety": os.path.join(base_dir, "safety.png"),
    "verification": os.path.join(base_dir, "verification.png")
}

base64_images = {}
for key, filepath in image_files.items():
    if os.path.exists(filepath):
        try:
            with Image.open(filepath) as img:
                img.thumbnail((320, 320))
                buffered = BytesIO()
                img.save(buffered, format="PNG", optimize=True)
                b64_str = base64.b64encode(buffered.getvalue()).decode('utf-8')
                base64_images[key] = b64_str
                print(f"Compressed and encoded {key} (size: {len(b64_str)} chars)")
        except Exception as e:
            print(f"Failed to process {key}: {e}")
            base64_images[key] = ""
    else:
        print(f"Warning: {filepath} not found.")
        base64_images[key] = ""

# ═══════════════════════════════════════════════════════════════
#  SCREEN LIST DEFINITION (36 UNIQUE SCREENS)
# ═══════════════════════════════════════════════════════════════
screens = []

# ───────────────────────────────────────────────────────────────
# ROW 1: AUTH & ONBOARDING (y=220)
# ───────────────────────────────────────────────────────────────

# 1. SPLASH
sx, sy = COLS[0], ROWS[0]
screens.append(screen("Splash", 0, 0, [
    R(sx+105, sy+225, 180, 180, fill=ACC_SURF, rad=90, name="Glow Ring Outer"),
    R(sx+120, sy+240, 150, 150, fill=BG, rad=75, name="Glow Ring Inner"),
    IMG_R(sx+135, sy+255, 120, 120, "verification", name="Branding Badge"),
    T(sx+110, sy+440, "SPOTT", sz=52, style="Bold", col=WHITE),
    T(sx+75, sy+508, "Travel Smarter. Share Costs. Direct.", sz=15, style="Medium", col=MUTED),
    C(sx+38, sy+580, 100, 32, "Cost Share", fill=SURF2, tcol=WHITE),
    C(sx+148, sy+580, 100, 32, "Verified Only", fill=SURF2, tcol=SUCCESS),
    C(sx+258, sy+580, 105, 32, "Send Parcels", fill=SURF2, tcol=SAFETY),
    B(sx+PAD, sy+675, CW, 56, "Get Started", fill=ACCENT),
    B(sx+PAD, sy+743, CW, 56, "I already have an account", fill=SURF2, tcol=MUTED),
    *motion_layer_tag(sx, sy, y_off=82, motion_type="Connected Morph")
]))

# 2. ONBOARDING
sx, sy = COLS[1], ROWS[0]
screens.append(screen("Onboarding", 1, 0, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+60, "Choose your role", sz=28, style="Bold"),
    T(sx+PAD, sy+96, "Select how you want to travel today. Switch anytime.", sz=14, col=MUTED),
    # Passenger (Selected Glow state)
    *glass_card(sx+PAD, sy, 140, CW, 155, fill=ACC_SURF, border=True, name="Selected Passenger Card"),
    R(sx+PAD, sy+140, CW, 4, fill=ACCENT, rad=2, name="Selected Accent Line"),
    *avatar_premium(sx+40, sy+160, 48, "P", bg=SURF3, verified=True, ring=True, ring_color=ACCENT),
    T(sx+104, sy+162, "Passenger", sz=20, style="Bold"),
    T(sx+104, sy+188, "Find shared trips going your way. Save up to 75% fuel costs.", sz=12, col=MUTED, w=210),
    C(sx+104, sy+244, 95, 26, "Popular", fill=SURF3, tcol=GLOW),
    # Traveler (Unselected)
    *glass_card(sx+PAD, sy, 310, CW, 150, fill=SURF1, border=False, name="Traveler Card"),
    *avatar_premium(sx+40, sy+330, 48, "T", bg=SURF3, verified=True, ring=False),
    T(sx+104, sy+332, "Traveler", sz=20, style="Bold"),
    T(sx+104, sy+358, "Offer seats to share fuel costs & recover expenses.", sz=12, col=MUTED, w=210),
    C(sx+104, sy+410, 100, 26, "Cost Recovery", fill=SURF3, tcol=SUCCESS),
    # Parcel Sender (Unselected)
    *glass_card(sx+PAD, sy, 475, CW, 150, fill=SURF1, border=False, name="Parcel Sender Card"),
    *avatar_premium(sx+40, sy+495, 48, "S", bg=SURF3, verified=True, ring=False),
    T(sx+104, sy+497, "Parcel Sender", sz=20, style="Bold"),
    T(sx+104, sy+523, "Send direct envelopes or packages via travelers.", sz=12, col=MUTED, w=210),
    C(sx+104, sy+575, 90, 26, "Fast & Direct", fill=SURF3, tcol=SAFETY),
    B(sx+PAD, sy+675, CW, 56, "Continue as Passenger", fill=ACCENT),
    T(sx+140, sy+747, "Skip for now →", sz=14, style="Semi Bold", col=MUTED),
    *motion_layer_tag(sx, sy, y_off=60, motion_type="Role Fade")
]))

# 3. LOGIN
sx, sy = COLS[2], ROWS[0]
screens.append(screen("Login", 2, 0, [
    *status_bar(sx, sy),
    IMG_R(sx+PAD, sy+60, 36, 36, "verification", name="Mini Logo"),
    T(sx+72, sy+68, "SPOTT", sz=18, style="Bold"),
    T(sx+PAD, sy+130, "Welcome back", sz=32, style="Bold"),
    T(sx+PAD, sy+172, "Enter your mobile number to continue", sz=15, col=MUTED),
    # Phone Input Card
    *glass_card(sx+PAD, sy, 220, CW, 70, fill=SURF2, border=True, name="Phone Input"),
    T(sx+40, sy+234, "Mobile Number", sz=11, style="Semi Bold", col=DIM),
    T(sx+40, sy+252, "+91  98765 43210", sz=16, style="Medium"),
    B(sx+PAD, sy+310, CW, 56, "Send OTP", fill=ACCENT),
    # Divider
    R(sx+PAD, sy+390, 140, 1, fill=DIVIDER),
    T(sx+175, sy+383, "or", sz=13, col=DIM),
    R(sx+PAD+200, sy+390, 140, 1, fill=DIVIDER),
    B(sx+PAD, sy+420, CW, 56, "Continue with Google", fill=SURF2, tcol=WHITE),
    # Trust indicator
    *glass_card(sx+PAD, sy, 540, CW, 110, fill=SUC_SURF, border=True, name="Privacy Card"),
    IMG_R(sx+40, sy+560, 24, 24, "safety", name="Lock Icon"),
    T(sx+76, sy+560, "Your details stay private", sz=15, style="Bold", col=SUCCESS),
    T(sx+76, sy+584, "We never share your number until you confirm a seat request.", sz=12, col=MUTED, w=230),
    T(sx+65, sy+710, "By continuing you agree to our", sz=12, col=DIM),
    T(sx+88, sy+728, "Terms of Service & Privacy Policy", sz=12, style="Semi Bold", col=MUTED),
    *motion_layer_tag(sx, sy, y_off=60, motion_type="Slide Up")
]))

# 4. OTP VERIFICATION
sx, sy = COLS[3], ROWS[0]
screens.append(screen("OTP Verification", 3, 0, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+70, "← Back to Login", sz=14, style="Semi Bold", col=MUTED),
    T(sx+PAD, sy+120, "Verify Phone", sz=32, style="Bold"),
    T(sx+PAD, sy+162, "Enter the 6-digit code sent to +91 98765 43210", sz=14, col=MUTED),
    # OTP Input Boxes
    *[R(sx+PAD+i*56, sy+210, 48, 56, fill=SURF2, rad=14, name=f"Box {i}") for i in range(6)],
    *[T(sx+PAD+i*56+16, sy+226, d, sz=24, style="Bold", col=WHITE) for i, d in enumerate("381902")],
    R(sx+PAD, sy+268, 48, 3, fill=ACCENT, rad=2, name="Highlight Line"),
    B(sx+PAD, sy+300, CW, 56, "Verify & Log In"),
    # Countdown
    *glass_card(sx+PAD, sy, 400, CW, 70, fill=SURF1, border=False, name="Resend Banner"),
    T(sx+40, sy+422, "Didn't receive the OTP?", sz=14, col=MUTED),
    T(sx+195, sy+422, "Resend Code", sz=14, style="Bold", col=ACCENT),
    T(sx+290, sy+422, "01:42", sz=14, style="Semi Bold", col=DIM),
    *motion_layer_tag(sx, sy, y_off=70, motion_type="Focus Highlight")
]))

# ───────────────────────────────────────────────────────────────
# ROW 2: PASSENGER CORE & TRUST (y=1150)
# ───────────────────────────────────────────────────────────────

# 5. PASSENGER HOME (Premium Hero, Route Cards, Bento Grids)
sx, sy = COLS[0], ROWS[1]
screens.append(screen("Passenger Home", 0, 1, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Welcome Back,", sz=16, col=MUTED),
    T(sx+PAD, sy+78, "Ritesh Mahatme", sz=24, style="Bold"),
    *avatar_premium(sx+SW-PAD-42, sy+56, 42, "R", bg=ACCENT, verified=True, ring=True, ring_color=ACCENT),
    
    # Premium Emotional Hero Banner
    *hero_banner(sx, sy, 130, height=220, 
                 title="Find verified travelers.", 
                 subtitle="Save money. Travel together. Move parcels faster.", 
                 accent_line=ACCENT, orb_fill=ACC_SURF),
    IMG_R(sx+SW-PAD-140, sy+210, 120, 120, "route", name="Route Hero Illustration"),
    B(sx+40, sy+286, 130, 44, "Find a Ride", fill=ACCENT, sz=14),
    B(sx+180, sy+286, 130, 44, "Send Parcel", fill=SURF3, sz=14),
    
    # Quick Services (Bento Grid layout with unequal column heights)
    T(sx+PAD, sy+375, "QUICK SERVICES", sz=11, style="Semi Bold", col=DIM),
    # Passenger Bento (Purple Theme)
    *glass_card(sx+PAD, sy, 395, 162, 110, fill=PURP_SURF, border=True, name="Bento Passenger"),
    T(sx+40, sy+415, "🚗", sz=24),
    T(sx+40, sy+447, "Cost-Share Ride", sz=15, style="Bold"),
    T(sx+40, sy+470, "Join active routes", sz=11, col=MUTED),
    # Parcel Bento (Amber Theme)
    *glass_card(sx+PAD+174, sy, 395, 162, 110, fill=SAF_SURF, border=True, name="Bento Parcel"),
    T(sx+PAD+190, sy+415, "📦", sz=24),
    T(sx+PAD+190, sy+447, "Send Parcel", sz=15, style="Bold"),
    T(sx+PAD+190, sy+470, "Traveler delivery", sz=11, col=MUTED),
    
    # Passenger to Traveler Conversion Prompt (Emerald theme)
    *glass_card(sx+PAD, sy, 520, CW, 90, fill=SUC_SURF, border=True, name="Conversion Banner"),
    T(sx+40, sy+536, "Traveling this route yourself?", sz=15, style="Bold", col=WHITE),
    T(sx+40, sy+558, "Offer your empty seats and recover fuel costs.", sz=12, col=MUTED),
    T(sx+40, sy+580, "Become a Traveler →", sz=12, col=SUCCESS, style="Bold"),
    
    # Signature Route Card Preview
    *section_title(sx, sy, 625, "Active Passenger Routes"),
    *route_card(sx, sy, 655, "Pune, Baner", "Mumbai, BKC", "12", "450", accent_color=ACCENT, type_label="Traveler"),
    
    *nav_passenger(sx, sy, 0),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Surface Lift")
]))

# 6. EXPLORE TRIPS (With Chips and Conversion empty state check)
sx, sy = COLS[1], ROWS[1]
screens.append(screen("Explore Trips", 1, 1, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Search Trips", sz=28, style="Bold"),
    *glass_card(sx+PAD, sy, 100, CW, 140, fill=SURF2, border=True, name="Search Fields"),
    T(sx+40, sy+120, "📍 Pune, Baner", sz=15, style="Bold"),
    R(sx+40, sy+140, 260, 1, fill=DIVIDER),
    T(sx+40, sy+155, "🏁 Mumbai, Andheri west", sz=15, style="Bold"),
    divider(sx, sy, 185),
    T(sx+40, sy+200, "📅 Today, 10 Jun", sz=13, style="Semi Bold"),
    
    # Vehicle Filter Chips
    C(sx+PAD, sy+255, 60, 28, "🚗 Car", fill=ACC_SURF, tcol=GLOW, sz=11),
    C(sx+PAD+66, sy+255, 60, 28, "❄️ AC", fill=SURF3, tcol=WHITE, sz=11),
    C(sx+PAD+132, sy+255, 120, 28, "👩 Women Friendly", fill=SURF3, tcol=WHITE, sz=11),
    C(sx+PAD+258, sy+255, 84, 28, "📦 Parcel OK", fill=SUC_SURF, tcol=SUCCESS, sz=11),
    
    # Signature Route Card Result
    *section_title(sx, sy, 305, "Verified Match Results"),
    *route_card(sx, sy, 335, "Pune, Baner", "Mumbai, BKC", "3", "450", accent_color=ACCENT, type_label="Traveler", card_name="Search Route Card"),
    
    # No matches traveler conversion prompt empty state representation
    *glass_card(sx+PAD, sy, 500, CW, 150, fill=SURF1, border=False, name="Empty State Card"),
    T(sx+40, sy+518, "No direct matching routes", sz=16, style="Bold", col=SAFETY),
    T(sx+40, sy+542, "Be the first traveler on this route and save fuel, or create a Route Alert.", sz=12, col=MUTED, w=270),
    B(sx+40, sy+592, 125, 38, "Create Alert", fill=ACCENT, sz=12),
    B(sx+175, sy+592, 125, 38, "Offer Trip", fill=SURF2, tcol=WHITE, sz=12),
    
    *nav_passenger(sx, sy, 1),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Connected Transition")
]))

# 7. TRIP DETAILS (With detailed Trust Stats)
sx, sy = COLS[2], ROWS[1]
screens.append(screen("Trip Details", 2, 1, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "← Back to search", sz=14, style="Semi Bold", col=MUTED),
    *glass_card(sx+PAD, sy, 90, CW, 260, fill=SURF2, border=True, name="Traveler Profile Header"),
    R(sx+PAD, sy+90, CW, 4, fill=ACCENT, rad=2),
    *avatar_premium(sx+40, sy+114, 52, "R", bg=SURF3, verified=True, ring=True, ring_color=ACCENT),
    T(sx+104, sy+118, "Rahul Mehta", sz=20, style="Bold"),
    T(sx+104, sy+142, "Verified Traveler  •  SP-99812", sz=12, col=MUTED),
    
    # Verified stats row details
    divider(sx, sy, 185),
    T(sx+40, sy+200, "142 Trips Shared", sz=13, style="Bold", col=WHITE),
    T(sx+40, sy+218, "Member Since 2024", sz=11, col=MUTED),
    T(sx+180, sy+200, "Honda City (AC)", sz=13, style="Bold", col=WHITE),
    T(sx+180, sy+218, "License Verified ✓", sz=11, col=SUCCESS),
    divider(sx, sy, 245),
    T(sx+40, sy+260, "Cost Share per seat", sz=14, col=MUTED),
    T(sx+260, sy+256, "₹450", sz=22, style="Bold", col=SUCCESS),
    
    # Trust badge row
    *section_title(sx, sy, 370, "Trust & Safety Badges"),
    *trust_badge_row(sx, sy, 400),
    
    # Route info
    *section_title(sx, sy, 465, "Route Timeline"),
    *route_card(sx, sy, 495, "Pune, Baner", "Mumbai, BKC", "1", "450", accent_color=ACCENT, type_label="Confirmed Traveler", card_name="Detail Route Card"),
    
    B(sx+PAD, sy+675, CW, 56, "Request Seat", fill=ACCENT),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Hero Expand")
]))

# 8. TRUST & SAFETY PRE-BOOKING
sx, sy = COLS[3], ROWS[1]
screens.append(screen("Trust & Safety", 3, 1, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "← Back to details", sz=14, style="Semi Bold", col=MUTED),
    T(sx+PAD, sy+100, "Safety Checklist", sz=28, style="Bold"),
    T(sx+PAD, sy+136, "Ensure high trust and safe travel for everyone.", sz=14, col=MUTED),
    *glass_card(sx+PAD, sy, 180, CW, 80, fill=SUC_SURF, border=True, name="Safety Status HUD"),
    IMG_R(sx+40, sy+198, 44, 44, "safety", name="Safety Shield Badge"),
    T(sx+100, sy+200, "GPS Insured Trip Active", sz=15, style="Bold", col=SUCCESS),
    T(sx+100, sy+222, "Realtime route tracking enabled", sz=12, col=MUTED),
    
    # Checklist container
    *glass_card(sx+PAD, sy, 280, CW, 290, fill=SURF2, border=True, name="Checklist Container"),
    T(sx+40, sy+300, "Please verify and agree to continue:", sz=14, style="Semi Bold"),
    T(sx+40, sy+340, "☑", sz=20, col=ACCENT, style="Bold"),
    T(sx+70, sy+340, "I will verify the traveler's ID on pickup.", sz=14, w=230),
    T(sx+40, sy+395, "☑", sz=20, col=ACCENT, style="Bold"),
    T(sx+70, sy+395, "I will match the vehicle plate MH12AB1234.", sz=14, w=230),
    T(sx+40, sy+450, "☑", sz=20, col=ACCENT, style="Bold"),
    T(sx+70, sy+450, "I agree to travel code of conduct.", sz=14, w=230),
    T(sx+40, sy+505, "☑", sz=20, col=ACCENT, style="Bold"),
    T(sx+70, sy+505, "I understand this is a cost-share trip.", sz=14, w=230),
    
    *glass_card(sx+PAD, sy, 590, CW, 70, fill=SURF1, border=False, name="Info Tip"),
    T(sx+40, sy+606, "ℹ️ Need help? Read our complete community guidelines.", sz=12, col=MUTED, w=270),
    B(sx+PAD, sy+675, CW, 56, "Acknowledge & Continue", fill=ACCENT),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Check Scale")
]))

# 9. CONFIRM REQUEST
sx, sy = COLS[4], ROWS[1]
screens.append(screen("Confirm Request", 4, 1, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "← Back to safety", sz=14, style="Semi Bold", col=MUTED),
    T(sx+PAD, sy+100, "Confirm seat request", sz=28, style="Bold"),
    T(sx+PAD, sy+136, "Rahul Mehta  •  Honda City", sz=14, col=MUTED),
    
    # Seats selector
    *glass_card(sx+PAD, sy, 180, CW, 80, fill=SURF2, border=True, name="Seat Selector Wrapper"),
    T(sx+40, sy+208, "Number of Seats", sz=16, style="Semi Bold"),
    R(sx+220, sy+200, 36, 36, fill=SURF3, rad=18),
    T(sx+232, sy+208, "−", sz=18, style="Bold", col=MUTED),
    T(sx+272, sy+208, "1", sz=18, style="Bold"),
    R(sx+300, sy+200, 36, 36, fill=ACCENT, rad=18),
    T(sx+312, sy+208, "+", sz=18, style="Bold"),
    
    # Cost share breakdown
    *glass_card(sx+PAD, sy, 280, CW, 180, fill=SURF2, border=True, name="Cost Breakdown Wrapper"),
    T(sx+40, sy+300, "Cost Breakdown", sz=14, style="Bold", col=MUTED),
    T(sx+40, sy+335, "Fuel Cost Share (1 Seat)", sz=14),
    T(sx+280, sy+335, "₹450", sz=14, style="Semi Bold"),
    T(sx+40, sy+365, "Platform Booking Fee", sz=14),
    T(sx+280, sy+365, "₹25", sz=14, style="Semi Bold"),
    divider(sx, sy, 395),
    T(sx+40, sy+415, "Total shared cost", sz=16, style="Bold"),
    T(sx+270, sy+410, "₹475", sz=22, style="Bold", col=SUCCESS),
    
    # Payment Mode Box
    *glass_card(sx+PAD, sy, 480, CW, 70, fill=SUC_SURF, border=True, name="Payment Method Box"),
    T(sx+40, sy+496, "Payment Mode", sz=11, col=DIM, style="Semi Bold"),
    T(sx+40, sy+514, "💳 UPI / NetBanking / Cards", sz=14, style="Semi Bold"),
    T(sx+300, sy+506, "Change", sz=12, col=ACCENT, style="Semi Bold"),
    
    *glass_card(sx+PAD, sy, 570, CW, 70, fill=ACC_SURF, border=True, name="Booking Note"),
    T(sx+40, sy+586, "🔒 Money is only processed after your traveler accepts the request.", sz=12, col=GLOW, w=270),
    B(sx+PAD, sy+675, CW, 56, "Confirm Request — ₹475", fill=ACCENT),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Slide Transition")
]))

# ───────────────────────────────────────────────────────────────
# ROW 3: PASSENGER SECONDARY & ALERTS (y=2080)
# ───────────────────────────────────────────────────────────────

# 10. PASSENGER TRIPS
sx, sy = COLS[0], ROWS[2]
screens.append(screen("Passenger Trips", 0, 2, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "My Trips", sz=28, style="Bold"),
    C(sx+PAD, sy+100, 80, 32, "Active", fill=ACCENT, tcol=WHITE),
    C(sx+PAD+88, sy+100, 90, 32, "Scheduled", fill=SURF2, tcol=MUTED),
    C(sx+PAD+186, sy+100, 90, 32, "Completed", fill=SURF2, tcol=MUTED),
    
    # Signature Route Card representing active trip
    *section_title(sx, sy, 155, "Active Cost-Share Ride"),
    *route_card(sx, sy, 185, "Pune, Baner", "Mumbai, BKC", "1", "450", accent_color=ACCENT, type_label="Confirmed Traveler", card_name="Active Trip Route Card"),
    
    # Trip meta details
    *glass_card(sx+PAD, sy, 350, CW, 140, fill=SURF2, border=True, name="Active Trip Meta Box"),
    T(sx+40, sy+370, "Traveler Details", sz=14, style="Bold", col=MUTED),
    *avatar_premium(sx+40, sy+395, 36, "R", bg=SURF3, verified=True, ring=False),
    T(sx+88, sy+395, "Rahul Mehta  •  Honda City (White)", sz=13, style="Bold"),
    T(sx+88, sy+415, "Leaves pickup point at 5:00 PM today", sz=11, col=MUTED),
    divider(sx, sy, 445),
    T(sx+40, sy+460, "Seat confirmed", sz=12, col=SUCCESS, style="Semi Bold"),
    T(sx+260, sy+460, "Track Live →", sz=12, col=ACCENT, style="Bold"),
    
    # Scheduled Trip Preview
    *section_title(sx, sy, 510, "Scheduled Routes"),
    *route_card(sx, sy, 540, "Mumbai, Andheri", "Pune, Baner", "0", "420", accent_color=PURPLE, type_label="Scheduled Traveler", card_name="Scheduled Trip Route Card"),
    
    *nav_passenger(sx, sy, 2),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Tab Shift")
]))

# 11. PASSENGER ACTIVITY
sx, sy = COLS[1], ROWS[2]
screens.append(screen("Passenger Activity", 1, 2, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "History & Activity", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Consolidated history of your shared routes.", sz=14, col=MUTED),
    
    # Route Card History Item 1
    *section_title(sx, sy, 130, "Recent Passenger Trip"),
    *route_card(sx, sy, 160, "Pune, Baner", "Mumbai, BKC", "1", "450", accent_color=SUCCESS, type_label="Completed Traveler", card_name="History Route Card 1"),
    
    # Route Card History Item 2 (Parcel)
    *section_title(sx, sy, 325, "Recent Parcel Delivery"),
    *route_card(sx, sy, 355, "Pune, Baner", "Mumbai, BKC", "1", "80", accent_color=SAFETY, type_label="Delivered Traveler", card_name="History Route Card 2"),
    
    # Detailed log
    *glass_card(sx+PAD, sy, 520, CW, 90, fill=SURF2, border=True, name="Activity Stat summary"),
    T(sx+40, sy+536, "Activity Summary", sz=14, style="Bold", col=MUTED),
    T(sx+40, sy+560, "12 Completed Rides", sz=12, col=WHITE),
    T(sx+40, sy+578, "3 Saved Shipments", sz=12, col=SUCCESS),
    T(sx+180, sy+560, "Total cost recovered: ₹5,450", sz=12, col=SUCCESS, style="Bold"),
    
    *nav_passenger(sx, sy, 3),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Collapse History")
]))

# 12. ROUTE ALERTS SCREEN
sx, sy = COLS[2], ROWS[2]
screens.append(screen("Route Alerts", 2, 2, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Search Alerts", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Get notified when a traveler matches your route.", sz=14, col=MUTED),
    
    # Active Route Alert 1
    *section_title(sx, sy, 130, "Active Alerts"),
    *route_card(sx, sy, 160, "Pune, Baner", "Mumbai, BKC", "12", "450", accent_color=ACCENT, type_label="Daily Matcher", card_name="Alert Route Card 1"),
    
    # Active Route Alert 2
    *route_card(sx, sy, 325, "Mumbai, BKC", "Bangalore, Indiranagar", "2", "1200", accent_color=PURPLE, type_label="Weekend Matcher", card_name="Alert Route Card 2"),
    
    B(sx+PAD, sy+675, CW, 56, "+ Create New Search Alert", fill=ACCENT),
    *nav_passenger(sx, sy, 1),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Toggle Expand")
]))

# 13. CREATE ROUTE ALERT
sx, sy = COLS[3], ROWS[2]
screens.append(screen("Create Route Alert", 3, 2, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "← Back to alerts", sz=14, style="Semi Bold", col=MUTED),
    T(sx+PAD, sy+100, "Create Search Alert", sz=28, style="Bold"),
    T(sx+PAD, sy+136, "We will ping you when a route matches.", sz=14, col=MUTED),
    
    # Inputs
    *glass_card(sx+PAD, sy, 180, CW, 130, fill=SURF2, border=True, name="Form Wrapper"),
    R(sx+40, sy+205, 8, 8, fill=ACCENT, rad=4),
    T(sx+58, sy+198, "Departure City", sz=11, col=DIM, style="Semi Bold"),
    T(sx+58, sy+215, "Pune", sz=15, style="Medium"),
    R(sx+44, sy+225, 2, 20, fill=DIVIDER),
    R(sx+40, sy+255, 8, 8, fill=SUCCESS, rad=4),
    T(sx+58, sy+248, "Destination City", sz=11, col=DIM, style="Semi Bold"),
    T(sx+58, sy+265, "Mumbai", sz=15, style="Medium"),
    
    # Preferences
    *section_title(sx, sy, 330, "Preferences"),
    *glass_card(sx+PAD, sy, 360, CW, 60, fill=SURF2, border=True, name="Toggle Card"),
    T(sx+40, sy+380, "Notify for Cars only", sz=14, style="Semi Bold"),
    R(sx+310, sy+378, 44, 24, fill=SUCCESS, rad=12),
    R(sx+332, sy+382, 16, 16, fill=WHITE, rad=8),
    
    *glass_card(sx+PAD, sy, 430, CW, 60, fill=SURF2, border=True, name="Option Card"),
    T(sx+40, sy+450, "Preferred Departure: Morning", sz=14, style="Semi Bold"),
    T(sx+320, sy+450, "Change", sz=12, col=ACCENT),
    
    B(sx+PAD, sy+675, CW, 56, "Create Alert", fill=ACCENT),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Slide Down")
]))

# 14. ROUTE ALERT DETAILS
sx, sy = COLS[4], ROWS[2]
screens.append(screen("Alert Details", 4, 2, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "← Search Alerts", sz=14, style="Semi Bold", col=MUTED),
    T(sx+PAD, sy+100, "Alert Configuration", sz=28, style="Bold"),
    
    # Main card
    *glass_card(sx+PAD, sy, 150, CW, 140, fill=SURF2, border=True, name="Configuration Card"),
    T(sx+40, sy+170, "Pune → Mumbai", sz=20, style="Bold"),
    T(sx+40, sy+198, "Weekly frequency  •  Any vehicle  •  Any time", sz=13, col=MUTED),
    divider(sx, sy, 230),
    T(sx+40, sy+250, "12 matches detected this week", sz=13, col=SUCCESS, style="Semi Bold"),
    
    # Status toggle
    *glass_card(sx+PAD, sy, 310, CW, 70, fill=SURF2, border=True, name="Alert Enable Card"),
    T(sx+40, sy+335, "Enable Search Alert", sz=15, style="Semi Bold"),
    R(sx+310, sy+333, 44, 24, fill=SUCCESS, rad=12),
    R(sx+332, sy+337, 16, 16, fill=WHITE, rad=8),
    
    B(sx+PAD, sy+605, CW, 56, "Pause Notifications", fill=SURF2, tcol=WHITE),
    B(sx+PAD, sy+675, CW, 56, "Delete Alert", fill=SURF2, tcol=GLOW),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Button scale")
]))

# ───────────────────────────────────────────────────────────────
# ROW 4: PARCEL EXPERIENCE FLOW (y=3010) (Amber Safety/Warning Theme)
# ───────────────────────────────────────────────────────────────

# 15. PARCEL STEP 1: PACKAGE TYPE
sx, sy = COLS[0], ROWS[3]
screens.append(screen("Parcel: Type", 0, 3, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Send Parcel", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Step 1 of 4: Select package category", sz=13, col=SAFETY, style="Semi Bold"),
    R(sx+PAD, sy+114, CW, 4, fill=SURF3, rad=2),
    R(sx+PAD, sy+114, CW//4, 4, fill=SAFETY, rad=2),
    
    # Options Grid (Unequal weights - Dribbble visual style)
    *glass_card(sx+PAD, sy, 140, 162, 110, fill=SAF_SURF, border=True, name="Bento Docs"),
    T(sx+40, sy+160, "📄", sz=24),
    T(sx+40, sy+192, "Documents", sz=16, style="Bold", col=SAFETY),
    T(sx+40, sy+214, "Envelopes, folders", sz=11, col=MUTED),
    
    *glass_card(sx+PAD+174, sy, 140, 162, 110, fill=SURF1, border=False, name="Bento Electro"),
    T(sx+PAD+190, sy+160, "💻", sz=24),
    T(sx+PAD+190, sy+192, "Electronics", sz=16, style="Bold"),
    T(sx+PAD+190, sy+214, "Devices, accessories", sz=11, col=MUTED),
    
    *glass_card(sx+PAD, sy, 264, 162, 110, fill=SURF1, border=False, name="Bento Clothes"),
    T(sx+40, sy+284, "👕", sz=24),
    T(sx+40, sy+316, "Clothing", sz=16, style="Bold"),
    T(sx+40, sy+338, "Apparel, laundry", sz=11, col=MUTED),
    
    *glass_card(sx+PAD+174, sy, 264, 162, 110, fill=SURF1, border=False, name="Bento Gifts"),
    T(sx+PAD+190, sy+284, "💐", sz=24),
    T(sx+PAD+190, sy+316, "Gifts & Flowers", sz=16, style="Bold"),
    T(sx+PAD+190, sy+338, "Bouquets, gift wraps", sz=11, col=MUTED),
    
    # Helper Illustration Card
    *glass_card(sx+PAD, sy, 394, CW, 140, fill=SURF2, border=True, name="Parcel graphic card"),
    IMG_R(sx+40, sy+410, 108, 108, "parcel", name="Parcel Graphic View"),
    T(sx+164, sy+420, "Traveler Delivery", sz=16, style="Bold"),
    T(sx+164, sy+444, "Verified travelers carry your parcel along their route.", sz=12, col=MUTED, w=150),
    
    *glass_card(sx+PAD, sy, 554, CW, 60, fill=SAF_SURF, border=True, name="Warning Note"),
    T(sx+40, sy+574, "⚠️ Prohibited: Fragile, high-value, or hazardous items.", sz=12, col=SAFETY),
    
    B(sx+PAD, sy+675, CW, 56, "Next: Package Weight", fill=SAFETY),
    *nav_passenger(sx, sy, 2),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Bento Press")
]))

# 16. PARCEL STEP 2: WEIGHT
sx, sy = COLS[1], ROWS[3]
screens.append(screen("Parcel: Weight", 1, 3, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Package Weight", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Step 2 of 4: Select package weight", sz=13, col=SAFETY, style="Semi Bold"),
    R(sx+PAD, sy+114, CW, 4, fill=SURF3, rad=2),
    R(sx+PAD, sy+114, CW//2, 4, fill=SAFETY, rad=2),
    
    # Slider
    *glass_card(sx+PAD, sy, 140, CW, 170, fill=SURF2, border=True, name="Slider Card"),
    T(sx+130, sy+170, "Package Weight Limit", sz=13, col=MUTED, style="Semi Bold"),
    T(sx+140, sy+192, "1.5 kg", sz=36, style="Bold", col=WHITE),
    R(sx+40, sy+250, 262, 6, fill=SURF3, rad=3),
    R(sx+40, sy+250, 100, 6, fill=SAFETY, rad=3),
    R(sx+134, sy+243, 20, 20, fill=WHITE, rad=10, name="Slider Handle"),
    
    # Guides
    *section_title(sx, sy, 330, "Package Size Reference Guide"),
    *glass_card(sx+PAD, sy, 365, CW, 70, fill=SURF1, border=False, name="Small Size Guide"),
    T(sx+40, sy+381, "✉️  Small (Under 1 kg)", sz=14, style="Semi Bold"),
    T(sx+40, sy+401, "Fits in glovebox or side pocket. e.g. keys, docs.", sz=11, col=MUTED),
    
    *glass_card(sx+PAD, sy, 445, CW, 70, fill=SAF_SURF, border=True, name="Medium Size Guide Selected"),
    T(sx+40, sy+461, "📦  Medium (1 to 3 kg)", sz=14, style="Semi Bold", col=WHITE),
    T(sx+40, sy+481, "Fits on traveler's seat. e.g. shoe box, laptop bags.", sz=11, col=MUTED),
    
    *glass_card(sx+PAD, sy, 525, CW, 70, fill=SURF1, border=False, name="Large Size Guide"),
    T(sx+40, sy+541, "🧳  Large (3 to 5 kg)", sz=14, style="Semi Bold"),
    T(sx+40, sy+561, "Fits in car trunk. e.g. backpacks, large carton.", sz=11, col=MUTED),
    
    B(sx+PAD, sy+675, CW, 56, "Next: Route Address Details", fill=SAFETY),
    *nav_passenger(sx, sy, 2),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Slide Weight")
]))

# 17. PARCEL STEP 3: PICKUP & DROP
sx, sy = COLS[2], ROWS[3]
screens.append(screen("Parcel: Address", 2, 3, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Route & Schedule", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Step 3 of 4: Enter parcel addresses", sz=13, col=SAFETY, style="Semi Bold"),
    R(sx+PAD, sy+114, CW, 4, fill=SURF3, rad=2),
    R(sx+PAD, sy+114, 3*CW//4, 4, fill=SAFETY, rad=2),
    
    # Address inputs
    *glass_card(sx+PAD, sy, 140, CW, 160, fill=SURF2, border=True, name="Address Form Container"),
    R(sx+40, sy+168, 8, 8, fill=SAFETY, rad=4),
    T(sx+58, sy+160, "Pickup Address", sz=11, col=DIM, style="Semi Bold"),
    T(sx+58, sy+178, "Pune, Baner Highstreet Gate 1", sz=15, style="Medium"),
    R(sx+43, sy+184, 2, 36, fill=DIVIDER),
    R(sx+40, sy+230, 8, 8, fill=SUCCESS, rad=4),
    T(sx+58, sy+222, "Dropoff Address", sz=11, col=DIM, style="Semi Bold"),
    T(sx+58, sy+240, "Mumbai, BKC Diamond Bourse", sz=15, style="Medium"),
    
    # Calendar bento
    *section_title(sx, sy, 320, "Delivery Date"),
    *glass_card(sx+PAD, sy, 350, CW, 90, fill=SURF2, border=True, name="Calendar Bento Container"),
    IMG_R(sx+40, sy+370, 48, 48, "calendar", name="Calendar Icon"),
    T(sx+100, sy+373, "Shipment Date", sz=14, style="Semi Bold"),
    T(sx+100, sy+395, "Today, 10 Jun (Earliest dispatch)", sz=12, col=SUCCESS),
    
    # Description
    *section_title(sx, sy, 460, "Item Details"),
    *glass_card(sx+PAD, sy, 490, CW, 70, fill=SURF2, border=True, name="Item Desc Card"),
    T(sx+40, sy+506, "Item Description", sz=11, col=DIM, style="Semi Bold"),
    T(sx+40, sy+524, "Important office documents, signed envelope.", sz=14),
    
    B(sx+PAD, sy+675, CW, 56, "Next: Receiver details", fill=SAFETY),
    *nav_passenger(sx, sy, 2),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Calendar pop")
]))

# 18. PARCEL STEP 4: RECEIVER DETAILS
sx, sy = COLS[3], ROWS[3]
screens.append(screen("Parcel: Receiver", 3, 3, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Receiver Info", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Step 4 of 4: Recipient contact info", sz=13, col=SAFETY, style="Semi Bold"),
    R(sx+PAD, sy+114, CW, 4, fill=SURF3, rad=2),
    R(sx+PAD, sy+114, CW, 4, fill=SAFETY, rad=2),
    
    # Form fields
    *glass_card(sx+PAD, sy, 140, CW, 240, fill=SURF2, border=True, name="Receiver Form Wrapper"),
    T(sx+40, sy+160, "Receiver Name", sz=11, col=DIM, style="Semi Bold"),
    T(sx+40, sy+178, "Karan Malhotra", sz=15, style="Medium"),
    divider(sx, sy, 210),
    T(sx+40, sy+230, "Receiver Mobile", sz=11, col=DIM, style="Semi Bold"),
    T(sx+40, sy+248, "+91  98765 09876", sz=15, style="Medium"),
    divider(sx, sy, 280),
    T(sx+40, sy+300, "Optional Notes", sz=11, col=DIM, style="Semi Bold"),
    T(sx+40, sy+318, "Handover only to recipient. Ask for ID.", sz=14),
    
    # Handover PIN banner
    *glass_card(sx+PAD, sy, 400, CW, 80, fill=SAF_SURF, border=True, name="Secure Handover Hub"),
    T(sx+40, sy+420, "🔑 Secure Handover PIN Enabled", sz=15, style="Bold", col=SAFETY),
    T(sx+40, sy+442, "Recipient must share delivery OTP with traveler to retrieve.", sz=11, col=MUTED),
    
    B(sx+PAD, sy+675, CW, 56, "Find Matching Travelers", fill=SAFETY),
    *nav_passenger(sx, sy, 2),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Form input focus")
]))

# 19. PARCEL STEP 5: TRAVELER MATCH
sx, sy = COLS[4], ROWS[3]
screens.append(screen("Parcel: Matches", 4, 3, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Matched Travelers", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Verified travelers going your parcel route.", sz=14, col=MUTED),
    
    # Match Result 1 (Using Signature Route Cards adapted for parcel)
    *section_title(sx, sy, 130, "Primary Matches"),
    *route_card(sx, sy, 160, "Pune, Baner Highstreet", "Mumbai, BKC", "1", "80", accent_color=SAFETY, type_label="Verified Carrier", card_name="Match Route Card 1"),
    
    # Match Result 2
    *route_card(sx, sy, 325, "Pune, Baner Highstreet", "Mumbai, BKC", "1", "60", accent_color=PURPLE, type_label="Carrier in Yamaha Pulsar", card_name="Match Route Card 2"),
    
    # Detailed comparison
    *glass_card(sx+PAD, sy, 490, CW, 90, fill=SURF1, border=False, name="Cargo space details"),
    T(sx+40, sy+506, "Cargo Capacity details", sz=11, col=DIM, style="Semi Bold"),
    T(sx+40, sy+525, "Rahul Mehta has 80% trunk space available.", sz=13, style="Bold", col=SUCCESS),
    T(sx+40, sy+545, "Amit S. offers backpack carrying capacity.", sz=12, col=MUTED),
    
    *nav_passenger(sx, sy, 2),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Matched Pop")
]))

# 20. PARCEL STEP 6: CONFIRMATION & TRACKING
sx, sy = COLS[5], ROWS[3]
screens.append(screen("Parcel: Tracking", 5, 3, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Track Shipment", sz=28, style="Bold"),
    
    # Signature Route Tracking Card
    *route_card(sx, sy, 100, "Pune Highstreet", "BKC Diamond Bourse", "1", "80", accent_color=SAFETY, type_label="Active Carrier", card_name="Tracking Route Card"),
    
    # Timeline details
    *glass_card(sx+PAD, sy, 265, CW, 250, fill=SURF2, border=True, name="Tracking Timeline Box"),
    # Step 1
    R(sx+44, sy+290, 8, 8, fill=SUCCESS, rad=4),
    T(sx+60, sy+285, "Shipment Booked", sz=12, col=SUCCESS, style="Semi Bold"),
    R(sx+47, sy+298, 2, 20, fill=SUCCESS),
    # Step 2
    R(sx+44, sy+320, 8, 8, fill=SUCCESS, rad=4),
    T(sx+60, sy+315, "Picked Up & Verified", sz=12, col=SUCCESS, style="Semi Bold"),
    R(sx+47, sy+328, 2, 20, fill=SAFETY),
    # Step 3
    R(sx+42, sy+349, 12, 12, fill=SAFETY, rad=6),
    T(sx+60, sy+345, "In Transit (ETA: ~1h 30m)", sz=12, col=SAFETY, style="Bold"),
    R(sx+47, sy+361, 2, 20, fill=DIVIDER),
    # Step 4
    R(sx+44, sy+383, 8, 8, fill=SURF3, rad=4),
    T(sx+60, sy+378, "Out for Delivery", sz=12, col=DIM),
    R(sx+47, sy+391, 2, 20, fill=DIVIDER),
    # Step 5
    R(sx+44, sy+413, 8, 8, fill=SURF3, rad=4),
    T(sx+60, sy+408, "Delivered Successfully", sz=12, col=DIM),
    
    # Secure OTP Handover Box
    *glass_card(sx+PAD, sy, 530, 162, 70, fill=SAF_SURF, border=True, name="Pickup OTP box"),
    T(sx+40, sy+544, "Pickup OTP (For start)", sz=10, col=DIM, style="Semi Bold"),
    T(sx+40, sy+560, "1234", sz=20, style="Bold", col=SAFETY),
    
    *glass_card(sx+PAD+174, sy, 530, 162, 70, fill=SUC_SURF, border=True, name="Delivery OTP box"),
    T(sx+PAD+190, sy+544, "Delivery OTP (For drop)", sz=10, col=DIM, style="Semi Bold"),
    T(sx+PAD+190, sy+560, "5678", sz=20, style="Bold", col=SUCCESS),
    
    B(sx+PAD, sy+620, 162, 44, "Call Traveler", fill=SURF2, tcol=WHITE, sz=13),
    B(sx+PAD+174, sy+620, 162, 44, "Share Tracking", fill=SURF2, tcol=WHITE, sz=13),
    
    *nav_passenger(sx, sy, 2),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Timeline Draw")
]))

# ───────────────────────────────────────────────────────────────
# ROW 5: TRAVELER CORE (y=3940)
# ───────────────────────────────────────────────────────────────

# 21. TRAVELER DASHBOARD
sx, sy = COLS[0], ROWS[4]
screens.append(screen("Traveler Dashboard", 0, 4, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Traveler Dashboard", sz=28, style="Bold"),
    *avatar_premium(sx+SW-PAD-42, sy+60, 42, "R", bg=PURPLE, verified=True, ring=True, ring_color=PURPLE),
    
    # Fuel savings hero (Purple gradient theme)
    *hero_banner(sx, sy, 110, height=140,
                 title="Cost Recovered This Month",
                 subtitle="Your shared empty seats have recovered significant fuel expenses.",
                 accent_line=PURPLE, orb_fill=PURP_SURF),
    T(sx+40, sy+155, "₹12,450", sz=36, style="Bold", col=WHITE),
    
    # Dashboard Toggles
    *glass_card(sx+PAD, sy, 265, CW, 90, fill=SURF2, border=True, name="Control switches"),
    T(sx+40, sy+282, "Accept Passengers", sz=14, style="Semi Bold"),
    R(sx+290, sy+278, 44, 24, fill=SUCCESS, rad=12),
    R(sx+312, sy+282, 16, 16, fill=WHITE, rad=8),
    T(sx+40, sy+318, "Accept Parcels along route", sz=14, style="Semi Bold"),
    R(sx+290, sy+314, 44, 24, fill=SUCCESS, rad=12),
    R(sx+312, sy+318, 16, 16, fill=WHITE, rad=8),
    
    # Upcoming trip Route Card
    *section_title(sx, sy, 370, "Your Active Shared Route"),
    *route_card(sx, sy, 400, "Pune, Baner", "Mumbai, BKC", "2 confirmed", "450", accent_color=PURPLE, type_label="Passenger Seat", card_name="Dashboard Active Route Card"),
    
    # Traveler stats bento
    *section_title(sx, sy, 560, "Trip Statistics"),
    *glass_card(sx+PAD, sy, 590, 162, 85, fill=SURF2, border=True, name="Bento Stat Rating"),
    T(sx+30, sy+606, "Traveler Rating", sz=11, col=DIM, style="Semi Bold"),
    T(sx+30, sy+628, "4.8 ★", sz=22, style="Bold", col=SAFETY),
    
    *glass_card(sx+PAD+174, sy, 590, 162, 85, fill=SUC_SURF, border=True, name="Bento Stat Saved"),
    T(sx+PAD+20, sy+606, "CO2 Prevented", sz=11, col=DIM, style="Semi Bold"),
    T(sx+PAD+20, sy+628, "142 kg", sz=22, style="Bold", col=SUCCESS),
    
    *nav_traveler(sx, sy, 0),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Surface Lift")
]))

# 22. TRAVELER REQUESTS QUEUE
sx, sy = COLS[1], ROWS[4]
screens.append(screen("Traveler Requests", 1, 4, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Requests Queue", sz=28, style="Bold"),
    C(sx+PAD, sy+100, 90, 30, "Passengers", fill=PURPLE, tcol=WHITE),
    C(sx+PAD+98, sy+100, 75, 30, "Parcels", fill=SURF2, tcol=MUTED),
    
    # Passenger Request Card
    *glass_card(sx+PAD, sy, 150, CW, 180, fill=SURF2, border=True, name="Seat Req Wrapper"),
    *avatar_premium(sx+40, sy+170, 44, "A", bg=SURF3, verified=True, ring=True, ring_color=PURPLE),
    T(sx+94, sy+172, "Amit Kumar", sz=16, style="Bold"),
    T(sx+270, sy+172, "+₹450", sz=18, style="Bold", col=SUCCESS),
    T(sx+94, sy+198, "Pune ➔ Mumbai  •  1 Seat requested", sz=12, col=MUTED),
    divider(sx, sy, 230),
    T(sx+40, sy+242, "Note: Traveling for work, only hand luggage.", sz=11, col=MUTED),
    B(sx+40, sy+272, 140, 38, "Decline", fill=SURF3, tcol=MUTED, sz=13),
    B(sx+190, sy+272, 140, 38, "Accept Request", fill=PURPLE, sz=13),
    
    # Parcel Request Card
    *glass_card(sx+PAD, sy, 345, CW, 180, fill=SURF2, border=True, name="Parcel Req Wrapper"),
    T(sx+40, sy+365, "📦", sz=24),
    T(sx+74, sy+367, "Office Documents (1 kg)", sz=16, style="Bold"),
    T(sx+270, sy+367, "+₹80", sz=18, style="Bold", col=SUCCESS),
    T(sx+74, sy+393, "Pickup: Baner Gate 1  ➔  Drop: BKC Bourse", sz=11, col=MUTED),
    divider(sx, sy, 425),
    T(sx+40, sy+438, "Sender: Meera K.  •  KYC ID verified", sz=11, col=MUTED),
    B(sx+40, sy+468, 140, 38, "Decline", fill=SURF3, tcol=MUTED, sz=13),
    B(sx+190, sy+468, 140, 38, "Accept Parcel", fill=PURPLE, sz=13),
    
    *nav_traveler(sx, sy, 1),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Accept Swivel")
]))

# 23. TRAVELER TRIPS MANAGE
sx, sy = COLS[2], ROWS[4]
screens.append(screen("Traveler Trips", 2, 4, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Shared Trips", sz=28, style="Bold"),
    C(sx+PAD, sy+100, 75, 30, "Active", fill=PURPLE, tcol=WHITE),
    C(sx+PAD+83, sy+100, 95, 30, "Scheduled", fill=SURF2, tcol=MUTED),
    C(sx+PAD+186, sy+100, 70, 30, "Past", fill=SURF2, tcol=MUTED),
    
    # Active Shared Trip
    *section_title(sx, sy, 150, "Active Sharing Route"),
    *route_card(sx, sy, 180, "Pune, Baner", "Mumbai, BKC", "2 confirmed", "900", accent_color=PURPLE, type_label="Passenger Seat", card_name="Trips Manage Active Route Card"),
    
    # Passengers detail
    *glass_card(sx+PAD, sy, 345, CW, 130, fill=SURF2, border=True, name="Passenger Avatars Box"),
    T(sx+40, sy+365, "Confirmed Travelers sharing cost:", sz=11, col=DIM, style="Semi Bold"),
    *avatar_premium(sx+40, sy+385, 32, "A", bg=SURF3, verified=True, ring=False),
    *avatar_premium(sx+80, sy+385, 32, "S", bg=SURF3, verified=True, ring=False),
    T(sx+125, sy+392, "Amit Kumar & Sneha P. confirmed", sz=12, col=WHITE),
    divider(sx, sy, 430),
    T(sx+40, sy+445, "1 Parcel delivery also matches this route (+₹80)", sz=11, col=SUCCESS, style="Semi Bold"),
    
    B(sx+PAD, sy+490, CW, 44, "Update Trip Status", fill=PURPLE, sz=13),
    
    *nav_traveler(sx, sy, 2),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Status Expand")
]))

# 24. CREATE TRIP FORM
sx, sy = COLS[3], ROWS[4]
screens.append(screen("Create Trip Form", 3, 4, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Offer Seats", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Trip details & route settings", sz=13, col=PURPLE, style="Semi Bold"),
    R(sx+PAD, sy+114, CW, 4, fill=SURF3, rad=2),
    R(sx+PAD, sy+114, 3*CW//4, 4, fill=PURPLE, rad=2),
    
    # Address form
    *glass_card(sx+PAD, sy, 140, CW, 120, fill=SURF2, border=True, name="Form Fields"),
    R(sx+40, sy+162, 8, 8, fill=PURPLE, rad=4),
    T(sx+58, sy+155, "Leaving from", sz=11, col=DIM, style="Semi Bold"),
    T(sx+58, sy+172, "Pune", sz=16, style="Medium"),
    R(sx+43, sy+178, 2, 20, fill=DIVIDER),
    R(sx+40, sy+208, 8, 8, fill=SUCCESS, rad=4),
    T(sx+58, sy+201, "Going to", sz=11, col=DIM, style="Semi Bold"),
    T(sx+58, sy+218, "Mumbai", sz=16, style="Medium"),
    
    # Date Picker
    *glass_card(sx+PAD, sy, 275, 162, 70, fill=SURF2, border=True, name="Date Picker Form"),
    T(sx+40, sy+291, "Departure Date", sz=10, col=DIM, style="Semi Bold"),
    T(sx+40, sy+309, "Today, 10 Jun", sz=14, style="Semi Bold"),
    
    # Time Picker
    *glass_card(sx+PAD+174, sy, 275, 162, 70, fill=SURF2, border=True, name="Time Picker Form"),
    T(sx+PAD+20, sy+291, "Departure Time", sz=10, col=DIM, style="Semi Bold"),
    T(sx+PAD+20, sy+309, "5:00 PM", sz=14, style="Semi Bold"),
    
    # Settings count & cost
    *glass_card(sx+PAD, sy, 360, 162, 70, fill=SURF2, border=True, name="Seats available Box"),
    T(sx+40, sy+376, "Seats available", sz=10, col=DIM, style="Semi Bold"),
    T(sx+40, sy+394, "4 Seats", sz=15, style="Bold"),
    
    *glass_card(sx+PAD+174, sy, 360, 162, 70, fill=SUC_SURF, border=True, name="Cost share Box"),
    T(sx+PAD+20, sy+376, "Cost share / seat", sz=10, col=DIM, style="Semi Bold"),
    T(sx+PAD+20, sy+394, "₹450", sz=15, style="Bold", col=SUCCESS),
    
    # Allow parcels switch
    *glass_card(sx+PAD, sy, 445, CW, 60, fill=SURF2, border=True, name="Parcel Switch Wrapper"),
    T(sx+40, sy+465, "Allow parcel delivery requests", sz=14, style="Semi Bold"),
    R(sx+290, sy+463, 44, 24, fill=SUCCESS, rad=12),
    R(sx+312, sy+467, 16, 16, fill=WHITE, rad=8),
    
    B(sx+PAD, sy+675, CW, 56, "Publish Trip Offer", fill=PURPLE),
    *nav_traveler(sx, sy, 2),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Form Slide")
]))

# 25. TRAVELER VEHICLE
sx, sy = COLS[4], ROWS[4]
screens.append(screen("Traveler Vehicle", 4, 4, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "← Back to settings", sz=14, style="Semi Bold", col=MUTED),
    T(sx+PAD, sy+100, "My Vehicle Details", sz=28, style="Bold"),
    
    # Large car image carousel
    *glass_card(sx+PAD, sy, 150, CW, 180, fill=SURF2, border=True, name="Vehicle Photo Carousel"),
    IMG_R(sx+PAD, sy+150, CW, 180, "car", name="Vehicle Image View"),
    # Indicators
    R(sx+160, sy+315, 6, 6, fill=PURPLE, rad=3),
    R(sx+172, sy+315, 6, 6, fill=SURF3, rad=3),
    R(sx+184, sy+315, 6, 6, fill=SURF3, rad=3),
    
    # Specs
    *glass_card(sx+PAD, sy, 340, CW, 110, fill=SURF2, border=True, name="Vehicle Specs details"),
    T(sx+40, sy+356, "Honda City (MH12 AB 1234)", sz=18, style="Bold"),
    T(sx+40, sy+382, "Pearl White  •  Air Conditioning (AC)  •  4 Seats", sz=12, col=MUTED),
    T(sx+40, sy+412, "✓ Registration RC Verified", sz=11, col=SUCCESS, style="Semi Bold"),
    T(sx+200, sy+412, "✓ Insurance Verified", sz=11, col=SUCCESS, style="Semi Bold"),
    
    # Trunk Capacity visual representation
    *section_title(sx, sy, 465, "Trunk Parcel Capacity"),
    *glass_card(sx+PAD, sy, 495, CW, 90, fill=SURF2, border=True, name="Capacity Box"),
    T(sx+40, sy+515, "Available Trunk Cargo Space", sz=14, style="Semi Bold"),
    R(sx+40, sy+540, 262, 10, fill=SURF3, rad=5),
    R(sx+40, sy+540, 210, 10, fill=SUCCESS, rad=5),
    T(sx+40, sy+558, "[████░] 80% Cargo Space Available", sz=11, col=SUCCESS, style="Semi Bold"),
    
    B(sx+PAD, sy+610, 162, 44, "Edit Details", fill=SURF3, tcol=WHITE, sz=13),
    B(sx+PAD+174, sy+610, 162, 44, "Verification documents", fill=SURF3, tcol=WHITE, sz=13),
    
    *nav_traveler(sx, sy, 3),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Carousel Swipe")
]))

# ───────────────────────────────────────────────────────────────
# ROW 6: SHARED & EXPLORE UPGRADES (y=4870)
# ───────────────────────────────────────────────────────────────

# 26. SHARED PROFILE
sx, sy = COLS[0], ROWS[5]
screens.append(screen("Shared Profile", 0, 5, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Account Profile", sz=28, style="Bold"),
    
    *glass_card(sx+PAD, sy, 105, CW, 180, fill=SURF2, border=True, name="Profile details"),
    *avatar_premium(sx+40, sy+125, 56, "R", bg=ACCENT, verified=True, ring=True, ring_color=ACCENT),
    T(sx+108, sy+130, "Ritesh Mahatme", sz=20, style="Bold"),
    T(sx+108, sy+154, "Member since: Jan 2024", sz=12, col=MUTED),
    C(sx+108, sy+176, 110, 22, "KYC Fully Verified", fill=SUC_SURF, tcol=SUCCESS, sz=10),
    divider(sx, sy, 215),
    T(sx+40, sy+230, "Trips Completed", sz=10, col=DIM, style="Semi Bold"),
    T(sx+40, sy+246, "12 Completed", sz=14, style="Bold"),
    T(sx+160, sy+230, "Parcels Sent", sz=10, col=DIM, style="Semi Bold"),
    T(sx+160, sy+246, "3 Sent", sz=14, style="Bold", col=SUCCESS),
    T(sx+270, sy+230, "Rating", sz=10, col=DIM, style="Semi Bold"),
    T(sx+270, sy+246, "4.9 ★", sz=14, style="Bold", col=SAFETY),
    
    # Profile List Menu Items
    *glass_card(sx+PAD, sy, 300, CW, 60, fill=SURF2, border=True, name="KYC Menu Item"),
    T(sx+40, sy+320, "🪪  KYC Verification Status", sz=15, style="Semi Bold"),
    T(sx+280, sy+322, "Verified ✓", sz=12, col=SUCCESS),
    
    *glass_card(sx+PAD, sy, 368, CW, 60, fill=SURF2, border=True, name="Preferences Menu Item"),
    T(sx+40, sy+388, "⚙️  System Preferences", sz=15, style="Semi Bold"),
    
    *glass_card(sx+PAD, sy, 436, CW, 60, fill=SURF2, border=True, name="Trust Menu Item"),
    T(sx+40, sy+456, "🛡️  Trust & Verification Center", sz=15, style="Semi Bold"),
    T(sx+280, sy+458, "Manage →", sz=12, col=ACCENT),
    
    *glass_card(sx+PAD, sy, 504, CW, 60, fill=SURF2, border=True, name="Notif Menu Item"),
    T(sx+40, sy+524, "🔔  Global Notification Center", sz=15, style="Semi Bold"),
    
    B(sx+PAD, sy+675, CW, 48, "Log Out of Account", fill=SURF2, tcol=GLOW, sz=14),
    *nav_passenger(sx, sy, 4),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Surface Lift")
]))

# 27. SAFETY HUB
sx, sy = COLS[1], ROWS[5]
screens.append(screen("Safety Hub", 1, 5, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Safety Hub", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Emergency services & trusted location sharing", sz=14, col=MUTED),
    
    # SOS Large alert panel
    *glass_card(sx+PAD, sy, 130, CW, 140, fill=ACC_SURF, border=True, name="SOS Alert Panel"),
    R(sx+PAD, sy+130, CW, 4, fill=ACCENT, rad=2),
    T(sx+50, sy+155, "🚨", sz=36),
    T(sx+105, sy+158, "Emergency SOS", sz=20, style="Bold", col=WHITE),
    T(sx+105, sy+184, "Instantly notify authorities and alert your trusted contacts with coordinates.", sz=12, col=MUTED, w=210),
    
    # Action List
    *glass_card(sx+PAD, sy, 285, CW, 80, fill=SURF2, border=True, name="Contacts Hub Item"),
    T(sx+40, sy+305, "👥", sz=22),
    T(sx+74, sy+303, "Trusted Contacts", sz=16, style="Bold"),
    T(sx+74, sy+325, "Manage 3 contacts receiving alerts", sz=12, col=MUTED),
    T(sx+320, sy+312, "➔", sz=15, col=MUTED),
    
    *glass_card(sx+PAD, sy, 375, CW, 80, fill=SURF2, border=True, name="Location Sharing Item"),
    T(sx+40, sy+395, "📍", sz=22),
    T(sx+74, sy+393, "Live Location Sharing", sz=16, style="Bold"),
    T(sx+74, sy+415, "Share tracking URL with family", sz=12, col=MUTED),
    T(sx+320, sy+402, "➔", sz=15, col=MUTED),
    
    *glass_card(sx+PAD, sy, 465, CW, 80, fill=SURF2, border=True, name="Incident Reporting Item"),
    T(sx+40, sy+485, "⚠️", sz=22),
    T(sx+74, sy+483, "Report Route Incident", sz=16, style="Bold"),
    T(sx+74, sy+505, "Report traveler / safety concern", sz=12, col=MUTED),
    T(sx+320, sy+492, "➔", sz=15, col=MUTED),
    
    *glass_card(sx+PAD, sy, 675, CW, 60, fill=SUC_SURF, border=True, name="Security Info"),
    T(sx+40, sy+695, "🔒 All trips are GPS tracked & monitored 24/7", sz=12, col=SUCCESS),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Pulsing Press")
]))

# 28. CHAT BOTTOM SHEET
sx, sy = COLS[2], ROWS[5]
screens.append(screen("Chat Overlay", 2, 5, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "← Back to trip", sz=14, style="Semi Bold", col=MUTED),
    
    *glass_card(sx+PAD, sy, 90, CW, 70, fill=SURF2, border=True, name="Chat Header Details"),
    *avatar_premium(sx+40, sy+110, 30, "R", bg=SURF3, verified=True, ring=False),
    T(sx+82, sy+113, "Rahul Mehta (Traveler)", sz=15, style="Bold"),
    T(sx+82, sy+132, "Active Trip: Pune to Mumbai", sz=11, col=MUTED),
    
    # Message logs
    *glass_card(sx+100, sy, 180, CW-80, 60, fill=SURF3, border=False, name="Traveler bubble"),
    T(sx+116, sy+192, "Hi Ritesh, I will pick you up at the Baner Highway gate at 5:00 PM.", sz=12, w=210),
    T(sx+310, sy+245, "4:15 PM", sz=10, col=DIM),
    
    *glass_card(sx+PAD, sy, 260, CW-80, 50, fill=ACC_SURF, border=True, name="Passenger bubble"),
    T(sx+40, sy+272, "Perfect, I am on my way there. Wearing a blue cap.", sz=12, w=210),
    T(sx+40, sy+315, "4:18 PM  •  Read", sz=10, col=DIM),
    
    # Quick reply chips overlay
    C(sx+PAD, sy+510, 108, 30, "I'm at pickup", fill=SURF3, tcol=WHITE),
    C(sx+PAD+114, sy+510, 108, 30, "Running late", fill=SURF3, tcol=WHITE),
    C(sx+PAD, sy+546, 108, 30, "Please call", fill=SURF3, tcol=WHITE),
    C(sx+PAD+114, sy+546, 108, 30, "Reached", fill=SUC_SURF, tcol=SUCCESS),
    
    *glass_card(sx+PAD, sy, 600, CW, 56, fill=SURF2, border=True, name="Input Box Container"),
    T(sx+40, sy+618, "Type your message...", sz=14, col=DIM),
    T(sx+300, sy+618, "🏁", sz=16),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Slide Sheet")
]))

# 29. TRIP COMPLETION CELEBRATION
sx, sy = COLS[3], ROWS[5]
screens.append(screen("Trip Completed", 3, 5, [
    *status_bar(sx, sy),
    R(sx+105, sy+90, 180, 180, fill=SUC_SURF, rad=90, name="Glow Outer"),
    R(sx+120, sy+100, 150, 150, fill=BG, rad=75, name="Glow Inner"),
    IMG_R(sx+135, sy+115, 120, 120, "verification", name="Verification Badge Overlay"),
    
    T(sx+82, sy+290, "Trip Completed! 🎉", sz=28, style="Bold", col=WHITE),
    T(sx+88, sy+326, "Shared cost settled successfully", sz=14, col=MUTED),
    
    # Savings bento celebration (Emerald Success Theme)
    *hero_banner(sx, sy, 370, height=130,
                 title="Saved ₹450 Saved",
                 subtitle="You shared fuel & tolls with 1 traveler on this route.",
                 accent_line=SUCCESS, orb_fill=SUC_SURF),
    
    *section_title(sx, sy, 520, "Rate your trip experience"),
    T(sx+110, sy+560, "⭐ ⭐ ⭐ ⭐ ⭐", sz=28),
    
    *glass_card(sx+PAD, sy, 605, CW, 56, fill=SURF2, border=True, name="Comment field wrapper"),
    T(sx+40, sy+624, "Leave a review comment (optional)...", sz=13, col=DIM),
    
    B(sx+PAD, sy+675, CW, 56, "Submit Review & Exit", fill=ACCENT),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Celebrate Pop")
]))

# 30. EXPLORE SCREEN (Pinterest Layout Upgrade)
sx, sy = COLS[4], ROWS[5]
screens.append(screen("Explore Screen", 4, 5, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Explore Spott", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Find shared routes, plans & top destinations", sz=14, col=MUTED),
    
    # Popular routes carousel (Unequal Bento Grid visual styling)
    *section_title(sx, sy, 130, "Popular Routes Today"),
    *glass_card(sx+PAD, sy, 165, 160, 110, fill=SURF2, border=True, name="Pop Card 1"),
    T(sx+30, sy+185, "Mumbai ➔ Pune", sz=14, style="Bold"),
    T(sx+30, sy+205, "12 Travelers active", sz=11, col=SUCCESS),
    T(sx+30, sy+235, "From ₹400", sz=15, style="Bold", col=WHITE),
    
    *glass_card(sx+PAD+172, sy, 165, 160, 110, fill=SURF2, border=True, name="Pop Card 2"),
    T(sx+PAD+188, sy+185, "Bangalore ➔ Mys", sz=14, style="Bold"),
    T(sx+PAD+188, sy+205, "8 Travelers active", sz=11, col=SUCCESS),
    T(sx+PAD+188, sy+235, "From ₹250", sz=15, style="Bold", col=WHITE),
    
    # Weekend Getaway (Bento style highlight with Purple accent)
    *section_title(sx, sy, 290, "Weekend Getaways (Recommended)"),
    *glass_card(sx+PAD, sy, 325, CW, 110, fill=PURP_SURF, border=True, name="Weekend Card Highlight"),
    T(sx+40, sy+345, "⛰️ Lonavala Monsoon Travel Specials", sz=16, style="Bold", col=WHITE),
    T(sx+40, sy+370, "Join Pune travelers going to Lonavala hill stations.", sz=12, col=MUTED),
    T(sx+40, sy+395, "Explore active Pune-Lonavala routes →", sz=12, col=PURPLE, style="Semi Bold"),
    
    # Historical route card based search suggest
    *section_title(sx, sy, 450, "Based on search history"),
    *route_card(sx, sy, 480, "Pune, Baner", "Mumbai, BKC", "12", "450", accent_color=ACCENT, type_label="Traveler", card_name="Explore Suggest Card"),
    
    B(sx+PAD, sy+675, CW, 56, "Search Custom Route", fill=ACCENT),
    *nav_passenger(sx, sy, 1),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Pinterest masonry")
]))

# 31. GLOBAL NOTIFICATION CENTER
sx, sy = COLS[5], ROWS[5]
screens.append(screen("Global Notifications", 5, 5, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Notifications Center", sz=28, style="Bold"),
    
    # Notif 1 (Trip Update - Purple)
    *glass_card(sx+PAD, sy, 100, CW, 80, fill=PURP_SURF, border=True, name="Notif 1 Card"),
    T(sx+40, sy+115, "🚗", sz=18),
    T(sx+70, sy+113, "Trip Update: Rahul accepted seat request", sz=13, style="Bold"),
    T(sx+70, sy+132, "Your shared trip to Mumbai starts today at 5:00 PM.", sz=11, col=MUTED, w=230),
    T(sx+70, sy+152, "Trip Updates • 5 min ago", sz=9, col=PURPLE, style="Semi Bold"),
    
    # Notif 2 (Route Match - Green Success)
    *glass_card(sx+PAD, sy, 190, CW, 80, fill=SUC_SURF, border=True, name="Notif 2 Card"),
    T(sx+40, sy+205, "🔔", sz=18),
    T(sx+70, sy+203, "Route Match: Pune ➔ Mumbai matched!", sz=13, style="Bold"),
    T(sx+70, sy+222, "Traveler Amit S. is leaving Baner at 5:30 PM.", sz=11, col=MUTED, w=230),
    T(sx+70, sy+242, "Route Matches • 1 hour ago", sz=9, col=SUCCESS, style="Semi Bold"),
    
    # Notif 3 (Parcel Update - Amber Safety)
    *glass_card(sx+PAD, sy, 280, CW, 80, fill=SAF_SURF, border=True, name="Notif 3 Card"),
    T(sx+40, sy+295, "📦", sz=18),
    T(sx+70, sy+293, "Parcel Update: Document in transit", sz=13, style="Bold"),
    T(sx+70, sy+312, "Rahul Mehta has scanned your pickup OTP verification code.", sz=11, col=MUTED, w=230),
    T(sx+70, sy+332, "Parcel Updates • 2 hours ago", sz=9, col=SAFETY, style="Semi Bold"),
    
    # Notif 4 (Safety Alert - Cyan Info)
    *glass_card(sx+PAD, sy, 370, CW, 80, fill=INF_SURF, border=True, name="Notif 4 Card"),
    T(sx+40, sy+385, "🚨", sz=18),
    T(sx+70, sy+383, "Safety Alert: GPS live-share active", sz=13, style="Bold", col=WHITE),
    T(sx+70, sy+402, "Family is tracking your active ride. Safety lock on.", sz=11, col=MUTED, w=230),
    T(sx+70, sy+422, "Safety Alerts • 4 hours ago", sz=9, col=INFO, style="Semi Bold"),
    
    # Notif 5 (Verification Update - Receded Default)
    *glass_card(sx+PAD, sy, 460, CW, 80, fill=SURF2, border=True, name="Notif 5 Card"),
    T(sx+40, sy+475, "✓", sz=18, col=SUCCESS, style="Bold"),
    T(sx+70, sy+473, "Verification Approved: RC document", sz=13, style="Bold"),
    T(sx+70, sy+492, "Your vehicle document registration check completed.", sz=11, col=MUTED, w=230),
    T(sx+70, sy+512, "Verification Updates • Yesterday", sz=9, col=MUTED, style="Semi Bold"),
    
    *nav_passenger(sx, sy, 4),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Slide Feed")
]))

# ───────────────────────────────────────────────────────────────
# ROW 7: VERIFICATION & STATE VARIATIONS (y=5800)
# ───────────────────────────────────────────────────────────────

# 32. TRUST & VERIFICATION CENTER
sx, sy = COLS[0], ROWS[6]
screens.append(screen("Trust Center", 0, 6, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "← Back to profile", sz=14, style="Semi Bold", col=MUTED),
    T(sx+PAD, sy+100, "Trust & Verification", sz=28, style="Bold"),
    T(sx+PAD, sy+136, "Single source of truth for your safety status.", sz=14, col=MUTED),
    
    # Verification lists
    *glass_card(sx+PAD, sy, 175, CW, 65, fill=SUC_SURF, border=True, name="Identity status card"),
    T(sx+40, sy+190, "✓ Identity verification status", sz=14, style="Semi Bold"),
    T(sx+40, sy+210, "Government KYC Checked & Cleared", sz=11, col=SUCCESS),
    T(sx+280, sy+198, "Approved", sz=12, col=SUCCESS, style="Bold"),
    
    *glass_card(sx+PAD, sy, 250, CW, 65, fill=SUC_SURF, border=True, name="License status card"),
    T(sx+40, sy+265, "✓ Driving License verification", sz=14, style="Semi Bold"),
    T(sx+40, sy+285, "Licence MH12-20120102 checked", sz=11, col=SUCCESS),
    T(sx+280, sy+273, "Approved", sz=12, col=SUCCESS, style="Bold"),
    
    *glass_card(sx+PAD, sy, 325, CW, 65, fill=SAF_SURF, border=True, name="Vehicle status card"),
    T(sx+40, sy+340, "⚡ Vehicle status (RC Check)", sz=14, style="Semi Bold"),
    T(sx+40, sy+360, "Registration book details in queue", sz=11, col=SAFETY),
    T(sx+260, sy+348, "Pending Review", sz=11, col=SAFETY, style="Bold"),
    
    *glass_card(sx+PAD, sy, 400, CW, 65, fill=ACC_SURF, border=True, name="Insurance status card"),
    T(sx+40, sy+415, "⚠️ Insurance document status", sz=14, style="Semi Bold"),
    T(sx+40, sy+435, "File blur or expired coverage date.", sz=11, col=GLOW),
    T(sx+240, sy+423, "Needs Resubmit", sz=11, col=GLOW, style="Bold"),
    
    # Checklist
    *section_title(sx, sy, 480, "Safety Checklists"),
    *glass_card(sx+PAD, sy, 510, CW, 120, fill=SURF2, border=True, name="Safety Guide bento"),
    T(sx+40, sy+530, "🛡️ Community Safety Standard Tips", sz=15, style="Bold", col=WHITE),
    T(sx+40, sy+552, "1. Always inspect vehicle plates.\n2. Verify traveler face matches system.\n3. Make payments exclusively on SPOTT platform.", sz=12, col=MUTED, w=270, h=60),
    
    B(sx+PAD, sy+680, CW, 56, "Resubmit Documents", fill=ACCENT),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Resubmit morph")
]))

# 33. EMPTY STATES DEMO
sx, sy = COLS[1], ROWS[6]
screens.append(screen("Empty States Demo", 1, 6, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Empty States Preview", sz=28, style="Bold"),
    
    # Empty state card representation
    *glass_card(sx+PAD, sy, 110, CW, 130, fill=SURF2, border=True, name="Empty Card 1"),
    T(sx+40, sy+130, "No active cost-share trips found", sz=15, style="Bold"),
    T(sx+40, sy+152, "Be the first traveler to share your route details or create search alert.", sz=12, col=MUTED, w=270),
    B(sx+40, sy+188, 120, 34, "Offer a Trip", fill=ACCENT, sz=12),
    B(sx+170, sy+188, 120, 34, "Create Alert", fill=SURF3, sz=12),
    
    *glass_card(sx+PAD, sy, 255, CW, 110, fill=SURF2, border=True, name="Empty Card 2"),
    T(sx+40, sy+275, "No search alerts configured", sz=15, style="Bold"),
    T(sx+40, sy+297, "Get matching updates when travelers publish active Pune-Mumbai routes.", sz=12, col=MUTED, w=270),
    
    *glass_card(sx+PAD, sy, 380, CW, 100, fill=SURF2, border=True, name="Empty Card 3"),
    T(sx+40, sy+400, "No pending parcel shipments", sz=15, style="Bold"),
    T(sx+40, sy+422, "Match weight and categories with active routes.", sz=12, col=MUTED, w=270),
    
    *glass_card(sx+PAD, sy, 495, CW, 90, fill=SURF2, border=True, name="Empty Card 4"),
    T(sx+40, sy+515, "Requests queue is empty", sz=15, style="Bold"),
    T(sx+40, sy+537, "Incoming passenger or parcel requests show here.", sz=12, col=MUTED, w=270),
    
    *glass_card(sx+PAD, sy, 600, CW, 90, fill=SURF2, border=True, name="Empty Card 5"),
    T(sx+40, sy+620, "No trusted contacts registered", sz=15, style="Bold"),
    T(sx+40, sy+642, "Alert loved ones in emergencies automatically.", sz=12, col=MUTED, w=270),
    
    B(sx+PAD, sy+705, CW, 50, "Add Trusted Contacts", fill=ACCENT, sz=13),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Empty State fade")
]))

# 34. LOADING & SKELETON STATES
sx, sy = COLS[2], ROWS[6]
screens.append(screen("Skeletons Loading", 2, 6, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Skeletons Loading", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Visual loading placeholders during request latency", sz=14, col=MUTED),
    
    # Card Skel
    *glass_card(sx+PAD, sy, 130, CW, 140, fill=SURF2, border=True, name="Skel 1"),
    R(sx+40, sy+150, 40, 40, fill=SKEL_BG, rad=20),
    R(sx+94, sy+155, 120, 14, fill=SKEL_BG, rad=4),
    R(sx+94, sy+175, 80, 10, fill=SKEL_BG, rad=4),
    divider(sx, sy, 205),
    R(sx+40, sy+220, 200, 12, fill=SKEL_HI, rad=4),
    
    # Trip search skel
    *glass_card(sx+PAD, sy, 285, CW, 160, fill=SURF2, border=True, name="Skel 2"),
    R(sx+40, sy+305, 52, 52, fill=SKEL_BG, rad=26),
    R(sx+104, sy+315, 150, 15, fill=SKEL_BG, rad=4),
    R(sx+104, sy+335, 100, 10, fill=SKEL_BG, rad=4),
    divider(sx, sy, 375),
    R(sx+40, sy+390, 180, 12, fill=SKEL_BG, rad=4),
    R(sx+40, sy+410, 120, 12, fill=SKEL_HI, rad=4),
    
    # Parcel tracking skel
    *glass_card(sx+PAD, sy, 460, CW, 130, fill=SURF2, border=True, name="Skel 3"),
    R(sx+40, sy+480, 100, 16, fill=SKEL_HI, rad=4),
    R(sx+40, sy+505, 200, 10, fill=SKEL_BG, rad=4),
    R(sx+40, sy+525, 260, 8, fill=SKEL_BG, rad=4),
    
    # Profile skel
    *glass_card(sx+PAD, sy, 605, CW, 150, fill=SURF2, border=True, name="Skel 4"),
    R(sx+SW//2-30, sy+625, 60, 60, fill=SKEL_BG, rad=30),
    R(sx+SW//2-70, sy+695, 140, 14, fill=SKEL_HI, rad=4),
    R(sx+SW//2-50, sy+715, 100, 10, fill=SKEL_BG, rad=4),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Shimmer Loop")
]))

# 35. VERIFICATION STATUS FLOW
sx, sy = COLS[3], ROWS[6]
screens.append(screen("Verification Status", 3, 6, [
    *status_bar(sx, sy),
    T(sx+PAD, sy+55, "Verification Flow", sz=28, style="Bold"),
    T(sx+PAD, sy+92, "Explicit states for uploaded documents", sz=14, col=MUTED),
    
    # Pending
    *glass_card(sx+PAD, sy, 130, CW, 110, fill=SAF_SURF, border=True, name="State Pending"),
    T(sx+40, sy+150, "📝 Identity Document (Aadhaar)", sz=16, style="Bold"),
    T(sx+40, sy+174, "Your verification is currently under review by trust center.", sz=12, col=MUTED),
    C(sx+40, sy+200, 120, 24, "Pending Review", fill=SURF3, tcol=SAFETY, sz=10),
    
    # Approved
    *glass_card(sx+PAD, sy, 255, CW, 110, fill=SUC_SURF, border=True, name="State Approved"),
    T(sx+40, sy+275, "🚗 Vehicle Registration RC", sz=16, style="Bold"),
    T(sx+40, sy+299, "Your vehicle document registration verified successfully.", sz=12, col=MUTED),
    C(sx+40, sy+325, 80, 24, "Approved", fill=SURF3, tcol=SUCCESS, sz=10),
    
    # Rejected
    *glass_card(sx+PAD, sy, 380, CW, 120, fill=ACC_SURF, border=True, name="State Rejected"),
    T(sx+40, sy+400, "🪪 Driving License (DL)", sz=16, style="Bold"),
    T(sx+40, sy+424, "Verification rejected. Text is blurry or expired.", sz=12, col=MUTED),
    C(sx+40, sy+450, 75, 24, "Rejected", fill=SURF3, tcol=GLOW, sz=10),
    B(sx+240, sy+445, 90, 28, "Resubmit", fill=ACCENT, rad=14, sz=11),
    
    # Needs Resubmission
    *glass_card(sx+PAD, sy, 515, CW, 110, fill=SURF2, border=True, name="State Resubmit"),
    T(sx+40, sy+535, "🛡️ Vehicle Insurance Policy", sz=16, style="Bold"),
    T(sx+40, sy+559, "Upload updated vehicle liability proof of coverage.", sz=12, col=MUTED),
    C(sx+40, sy+585, 130, 24, "Needs Resubmission", fill=SURF3, tcol=WHITE, sz=10),
    
    *nav_passenger(sx, sy, 4),
    *motion_layer_tag(sx, sy, y_off=55, motion_type="Slide Transition")
]))

# 36. LIVE TRACKING SCREEN (Map, controls, and trip status timeline)
sx, sy = COLS[4], ROWS[6]
screens.append(screen("Live Ride Tracking", 4, 6, [
    # Custom dark map backdrop
    R(sx, sy, SW, 310, fill={"r":0.05,"g":0.06,"b":0.065}, rad=0, name="Map Backdrop"),
    
    # Connected Route connector visual
    R(sx+60, sy+155, 14, 14, fill=ACCENT, rad=7, name="Map Origin Dot"),
    R(sx+310, sy+155, 14, 14, fill=SUCCESS, rad=7, name="Map Dest Dot"),
    R(sx+74, sy+160, 236, 4, fill=ACCENT, rad=2, name="Map Route Connector Line"),
    # Live traveler locator indicator
    R(sx+170, sy+147, 28, 28, fill=WHITE, rad=14, name="Locator Ring"),
    T(sx+177, sy+153, "🚗", sz=13, name="Locator Icon"),
    
    # Floating glass HUD card
    *glass_card(sx+PAD, sy, 20, CW, 70, fill=SURF1, border=True, name="Floating ETA HUD Card"),
    R(sx+PAD, sy+20, CW, 4, fill=SUCCESS, rad=2, name="HUD Glow Line"),
    T(sx+40, sy+35, "Arriving in 23 minutes", sz=16, style="Bold", col=WHITE),
    T(sx+40, sy+55, "Rahul Mehta  •  1.4 km away  •  Honda City", sz=12, col=MUTED),
    
    # Tracking Status Timeline
    *section_title(sx, sy, 325, "Trip Progress Timeline"),
    *glass_card(sx+PAD, sy, 355, CW, 215, fill=SURF2, border=True, name="Timeline Container Box"),
    # Timeline Step 1
    R(sx+44, sy+380, 8, 8, fill=SUCCESS, rad=4),
    T(sx+60, sy+375, "Trip Created ➔ Seat Requested", sz=12, col=SUCCESS, style="Semi Bold"),
    R(sx+47, sy+388, 2, 20, fill=SUCCESS),
    # Timeline Step 2
    R(sx+44, sy+410, 8, 8, fill=SUCCESS, rad=4),
    T(sx+60, sy+405, "Seat Approved (Confirmed)", sz=12, col=SUCCESS, style="Semi Bold"),
    R(sx+47, sy+418, 2, 20, fill=SUCCESS),
    # Timeline Step 3 (active)
    R(sx+42, sy+439, 12, 12, fill=ACCENT, rad=6),
    T(sx+60, sy+435, "Traveler En Route (ETA 23m)", sz=12, col=ACCENT, style="Bold"),
    R(sx+47, sy+451, 2, 20, fill=DIVIDER),
    # Timeline Step 4
    R(sx+44, sy+473, 8, 8, fill=SURF3, rad=4),
    T(sx+60, sy+468, "Pickup Complete ➔ Trip in Progress", sz=12, col=DIM),
    R(sx+47, sy+481, 2, 20, fill=DIVIDER),
    # Timeline Step 5
    R(sx+44, sy+503, 8, 8, fill=SURF3, rad=4),
    T(sx+60, sy+498, "Completed & Settled", sz=12, col=DIM),
    
    # Action CTA Row
    B(sx+PAD, sy+585, 76, 44, "🚨 SOS", fill=ACCENT, sz=12),
    B(sx+PAD+82, sy+585, 82, 44, "📞 Call", fill=SURF3, tcol=WHITE, sz=12),
    B(sx+PAD+170, sy+585, 82, 44, "💬 Chat", fill=SURF3, tcol=WHITE, sz=12),
    B(sx+PAD+258, sy+585, 84, 44, "📍 Share", fill=SURF3, tcol=WHITE, sz=12),
    B(sx+PAD, sy+645, CW, 44, "Cancel Seat Booking Request", fill=SURF1, tcol=GLOW, sz=13),
    *motion_layer_tag(sx, sy, y_off=325, motion_type="Route Line Draw")
]))

# ═══════════════════════════════════════════════════════════════
#  GENERATING JAVASCRIPT BUNDLE FOR FIGMA PLUGIN
# ═══════════════════════════════════════════════════════════════
screens_json = json.dumps(screens, indent=2)
base64_images_json = json.dumps(base64_images, indent=2)

rendering_engine = r"""
const fontRequests = [
  { family: 'Inter', style: 'Regular' },
  { family: 'Inter', style: 'Medium' },
  { family: 'Inter', style: 'Semi Bold' },
  { family: 'Inter', style: 'Bold' }
];

function rgba(color) {
  const safeColor = color || { r: 0, g: 0, b: 0 };
  return {
    r: safeColor.r !== undefined ? safeColor.r : 0,
    g: safeColor.g !== undefined ? safeColor.g : 0,
    b: safeColor.b !== undefined ? safeColor.b : 0,
  };
}

function createFill(color) {
  return { type: 'SOLID', color: rgba(color) };
}

function applyTextStyles(node, item) {
  node.fontName = item.font;
  node.fontSize = item.fontSize;
  node.fills = [{ type: 'SOLID', color: rgba(item.color || item.textColor) }];
  node.textAlignHorizontal = 'LEFT';
  node.textAlignVertical = 'TOP';
  node.textAutoResize = 'WIDTH_AND_HEIGHT';
  node.letterSpacing = { value: -0.2, unit: 'PIXELS' };
  node.lineHeight = { value: item.fontSize * 1.35, unit: 'PIXELS' };
}

function createText(item) {
  const node = figma.createText();
  node.characters = item.text;
  applyTextStyles(node, item);
  node.x = item.x;
  node.y = item.y;
  if (item.name) node.name = item.name;
  if (item.width || item.height) {
    node.resize(item.width || node.width, item.height || node.height);
  }
  return node;
}

function createRectangle(item) {
  const node = figma.createRectangle();
  node.resize(Math.max(1, item.width), Math.max(1, item.height));
  node.x = item.x;
  node.y = item.y;
  node.fills = [createFill(item.fill)];
  if (item.cornerRadius !== undefined) node.cornerRadius = item.cornerRadius;
  if (item.name) node.name = item.name;
  return node;
}

function createImageRectangle(item) {
  const node = figma.createRectangle();
  node.resize(Math.max(1, item.width), Math.max(1, item.height));
  node.x = item.x;
  node.y = item.y;
  
  const img = imagesMap[item.imageKey];
  if (img) {
    node.fills = [{ type: 'IMAGE', imageHash: img.hash, scaleMode: 'FILL' }];
  } else {
    // Soft fallback visual surface
    node.fills = [createFill(item.fill || { r: 0.14, g: 0.14, b: 0.15 })];
  }
  if (item.cornerRadius !== undefined) node.cornerRadius = item.cornerRadius;
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
    label.fontSize = item.fontSize || 15;
    label.textAlignHorizontal = 'CENTER';
    label.textAlignVertical = 'CENTER';
    label.textAutoResize = 'WIDTH_AND_HEIGHT';
    label.fills = [{ type: 'SOLID', color: rgba(item.textColor || { r: 1, g: 1, b: 1 }) }];
    label.resize(item.width - 32, item.height);
    label.x = 16;
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
  chip.cornerRadius = item.cornerRadius || 14;

  const groupChildren = [chip];
  if (item.text) {
    const label = figma.createText();
    label.characters = item.text;
    label.fontName = item.font || { family: 'Inter', style: 'Semi Bold' };
    label.fontSize = item.fontSize || 11;
    label.textAlignHorizontal = 'CENTER';
    label.textAlignVertical = 'CENTER';
    label.textAutoResize = 'WIDTH_AND_HEIGHT';
    label.fills = [{ type: 'SOLID', color: rgba(item.textColor || { r: 1, g: 1, b: 1 }) }];
    label.resize(item.width - 16, item.height);
    label.x = 8;
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
    const childItem = {
      type: child.type,
      x: child.x - item.x,
      y: child.y - item.y,
      width: child.width,
      height: child.height,
      fill: child.fill,
      cornerRadius: child.cornerRadius,
      text: child.text,
      textColor: child.textColor,
      color: child.color,
      font: child.font,
      fontSize: child.fontSize,
      name: child.name,
      imageKey: child.imageKey
    };
    
    let node;
    if (child.type === 'text') node = createText(childItem);
    else if (child.type === 'rect') node = createRectangle(childItem);
    else if (child.type === 'image_rect') node = createImageRectangle(childItem);
    else if (child.type === 'button') node = createButton(childItem);
    else if (child.type === 'chip') node = createChip(childItem);
    
    if (node) frame.appendChild(node);
  });
  return frame;
}

function base64ToBytes(base64) {
  const binaryString = atob(base64);
  const len = binaryString.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes;
}

const imagesMap = {};

async function main() {
  for (const font of fontRequests) {
    await figma.loadFontAsync(font);
  }

  // Load and decode base64 assets to figma images
  for (const [key, base64Str] of Object.entries(base64Images)) {
    if (base64Str) {
      try {
        const bytes = base64ToBytes(base64Str);
        imagesMap[key] = figma.createImage(bytes);
      } catch (err) {
        console.error("Error creating figma image: " + key, err);
      }
    }
  }

  const createdFrames = screens.map(createFrame);
  createdFrames.forEach(frame => figma.currentPage.appendChild(frame));

  figma.viewport.scrollAndZoomIntoView(createdFrames);
  figma.closePlugin('Spott V1 Premium UI Rebuilt — ' + screens.length + ' layout screens generated.');
}

main();
"""

output = f"const base64Images = {base64_images_json};\nconst screens = {screens_json};\n{rendering_engine}"

with open(r"D:\PROJECTS\Spotter\spotter\figma-plugin\code.js", "w", encoding="utf-8") as f:
    f.write(output)

print(f"Successfully generated code.js with {len(screens)} screens.")
print(f"Target path: D:\\PROJECTS\\Spotter\\spotter\\figma-plugin\\code.js")
