"""
SPOTT PREMIUM UI GENERATOR — Complete Design System Rebuild
Produces a standalone Figma Plugin code.js with embedded base64 assets.
Architecture: Auto Layout everywhere, real glassmorphism, bento grids, premium typography.
"""

import sys
import os
import base64
from PIL import Image
from io import BytesIO

# Force UTF-8 output on Windows
sys.stdout.reconfigure(encoding='utf-8', errors='replace') if hasattr(sys.stdout, 'reconfigure') else None

# ─────────────────────────────────────────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────────────────────────────────────────
CODE_JS_PATH = r"D:\PROJECTS\Spotter\spotter\figma-plugin\code.js"
ASSET_DIR = r"D:\PROJECTS\Spotter\spotter"
MAX_IMAGE_DIM = 400  # px — higher quality than before

# ─────────────────────────────────────────────────────────────────────────────
# ASSET LOADER
# ─────────────────────────────────────────────────────────────────────────────
def load_asset(filename: str) -> str:
    """Load a PNG, thumbnail it, return base64 string."""
    path = os.path.join(ASSET_DIR, filename)
    if not os.path.exists(path):
        print(f"  ⚠  Asset not found: {filename}")
        return ""
    img = Image.open(path).convert("RGBA")
    img.thumbnail((MAX_IMAGE_DIM, MAX_IMAGE_DIM), Image.LANCZOS)
    buf = BytesIO()
    img.save(buf, format="PNG", optimize=True)
    data = base64.b64encode(buf.getvalue()).decode("utf-8")
    print(f"  [OK] Loaded {filename}  ({img.size[0]}x{img.size[1]})")
    return data

print("Loading PNG assets...")
ASSETS = {
    "bike":         load_asset("Bike.png"),
    "bike_clock":   load_asset("Bike_Clock.png"),
    "car":          load_asset("Car.png"),
    "car_clock":    load_asset("Car_Clock.png"),
    "parcel":       load_asset("Parcel.png"),
    "rikshaw":      load_asset("Rikshaw.png"),
    "rikshaw_clock":load_asset("Rikshaw_Clock.png"),
    "calendar":     load_asset("Calendar.png"),
    "route":        load_asset("route.png"),
    "safety":       load_asset("safety.png"),
    "verification": load_asset("verification.png"),
}
print("[OK] All assets loaded.\n")

# ─────────────────────────────────────────────────────────────────────────────
# JS TEMPLATE — Figma Plugin Runtime
# This is the complete, standalone plugin. Python only supplies asset data.
# ─────────────────────────────────────────────────────────────────────────────
JS_PLUGIN = r"""
// ═══════════════════════════════════════════════════════════════════════════
//  SPOTT PREMIUM UI GENERATOR — Figma Plugin Runtime
//  Design System: Airbnb × Linear × Pinterest × Apple × Stripe
// ═══════════════════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────────
// 0. ASSET REGISTRY (Injected by Python)
// ─────────────────────────────────────────────────
const ASSETS = __ASSETS__;

// ─────────────────────────────────────────────────
// 1. DESIGN TOKENS
// ─────────────────────────────────────────────────
const T = {
  // Backgrounds
  bgBase:    {r:0.031, g:0.024, b:0.051},  // #080618 — ultra-deep
  bgMid:     {r:0.055, g:0.043, b:0.090},  // #0E0B17
  bgSurf:    {r:0.082, g:0.063, b:0.129},  // #151021
  bgCard:    {r:0.110, g:0.086, b:0.169},  // #1C162B

  // Primary — vibrant coral-red (Pinterest DNA)
  pri:       {r:0.933, g:0.200, b:0.290},  // #EE334A
  priLight:  {r:1.000, g:0.380, b:0.440},  // #FF6170
  priDark:   {r:0.647, g:0.071, b:0.161},  // #A51229
  priGlow:   {r:0.933, g:0.200, b:0.290, a:0.28},

  // Accent — electric violet (Linear DNA)
  acc:       {r:0.400, g:0.320, b:1.000},  // #6652FF
  accLight:  {r:0.565, g:0.502, b:1.000},  // #9080FF
  accGlow:   {r:0.400, g:0.320, b:1.000, a:0.20},

  // Success — emerald
  green:     {r:0.133, g:0.820, b:0.443},  // #22D171
  greenDark: {r:0.051, g:0.271, b:0.153},  // #0D4527
  greenGlow: {r:0.133, g:0.820, b:0.443, a:0.18},

  // Warning — amber gold
  amber:     {r:0.996, g:0.710, b:0.235},  // #FEB53C
  amberDark: {r:0.271, g:0.188, b:0.047},  // #45300C

  // Text
  textHi:    {r:0.973, g:0.957, b:0.988},  // #F8F4FC
  textMed:   {r:0.659, g:0.627, b:0.737},  // #A8A0BC
  textLow:   {r:0.404, g:0.369, b:0.498},  // #675E7F
  textMute:  {r:0.243, g:0.220, b:0.310},  // #3E384F

  // Glass / overlay
  glass:     {r:1.0, g:1.0, b:1.0, a:0.05},
  glassHi:   {r:1.0, g:1.0, b:1.0, a:0.10},
  glassEdge: {r:1.0, g:1.0, b:1.0, a:0.14},
  overlay:   {r:0.0, g:0.0, b:0.0, a:0.55},

  // Borders
  border:    {r:1.0, g:1.0, b:1.0, a:0.07},
  borderAcc: {r:0.400, g:0.320, b:1.000, a:0.30},
  borderPri: {r:0.933, g:0.200, b:0.290, a:0.40},
};

const R = { xs:8, sm:12, md:16, lg:20, xl:24, xxl:32, pill:50 };
const W = 390; const H = 844;

// ─────────────────────────────────────────────────
// 2. FILL / STROKE / EFFECT HELPERS
// ─────────────────────────────────────────────────
function _a(c) { return (c && c.a !== undefined) ? c.a : 1; }

function solid(c, op) {
  if (op === undefined) op = 1.0;
  return [{type:'SOLID', color:{r:c.r,g:c.g,b:c.b}, opacity: op}];
}
function gradV(c1,c2,op) {
  if (op === undefined) op = 1.0;
  return [{
    type:'GRADIENT_LINEAR',
    gradientTransform:[[0,1,0],[1,0,0]],
    gradientStops:[
      {position:0, color:{r:c1.r,g:c1.g,b:c1.b,a:_a(c1)*op}},
      {position:1, color:{r:c2.r,g:c2.g,b:c2.b,a:_a(c2)*op}}
    ]
  }];
}
function gradD(c1,c2) {
  return [{
    type:'GRADIENT_LINEAR',
    gradientTransform:[[0.707,0.707,0],[-0.707,0.707,0]],
    gradientStops:[
      {position:0, color:{r:c1.r,g:c1.g,b:c1.b,a:_a(c1)}},
      {position:1, color:{r:c2.r,g:c2.g,b:c2.b,a:_a(c2)}}
    ]
  }];
}
function noFill() { return []; }

function shadowLayer(color, dy, blur, spread, op) {
  if (spread === undefined) spread = 0;
  if (op === undefined) op = 1.0;
  return {type:'DROP_SHADOW', visible:true, blendMode:'NORMAL',
    color:{r:color.r, g:color.g, b:color.b, a:_a(color)*op},
    offset:{x:0,y:dy}, radius:blur, spread:spread};
}
function bgBlur(r) { if (r === undefined) r = 20; return {type:'BACKGROUND_BLUR', radius:r, visible:true}; }

function glassShadows(glowColor) {
  const s = [
    shadowLayer({r:0,g:0,b:0},20,48,0,0.45),
    shadowLayer({r:0,g:0,b:0},6,12,0,0.30),
  ];
  if (glowColor) s.push(shadowLayer(glowColor,8,24,0,0.35));
  return s;
}

function stroke(c, w, align) {
  if (w === undefined) w = 1;
  if (align === undefined) align = 'INSIDE';
  return {fills:solid(c), weight:w, align:align, visible:true};
}

// ─────────────────────────────────────────────────
// 3. NODE FACTORY — core primitives
// ─────────────────────────────────────────────────
async function makeFrame(name, w, h) {
  const f = figma.createFrame();
  f.name = name; f.resize(w,h); f.clipsContent=true; f.layoutMode='NONE';
  return f;
}
async function makeAutoFrame(name, w, h, dir='VERTICAL') {
  const f = figma.createFrame();
  f.name=name; f.resize(w,h);
  f.layoutMode=dir;
  f.primaryAxisSizingMode='FIXED';
  f.counterAxisSizingMode='FIXED';
  f.clipsContent=true;
  return f;
}
function makeRect(name, w, h, fills, cr=0) {
  const r = figma.createRectangle();
  r.name=name; r.resize(w,h); r.fills=fills; r.cornerRadius=cr;
  return r;
}
async function makeText(content, size, style, color, op=1.0, align='LEFT') {
  const t = figma.createText();
  await figma.loadFontAsync({family:'Inter', style:style});
  t.characters = content;
  t.fontName = {family:'Inter', style:style};
  t.fontSize = size;
  t.fills = solid(color, op);
  t.textAlignHorizontal = align;
  t.letterSpacing = {value: size>=28 ? -0.04*size : size>=18 ? -0.02*size : -0.01*size, unit:'PIXELS'};
  t.lineHeight = {value: size>=28 ? size*1.15 : size*1.4, unit:'PIXELS'};
  t.textAutoResize='WIDTH_AND_HEIGHT';
  return t;
}

// ─────────────────────────────────────────────────
// 4. GLASS CONTAINER SYSTEM
// ─────────────────────────────────────────────────
function applyGlass(frame, cr=R.xl, glowColor=null, borderOpacity=0.14) {
  frame.cornerRadius = cr;
  frame.fills = [...gradV(T.bgCard, T.bgSurf, 0.8), ...solid(T.glass)];
  frame.strokes = solid(T.glassEdge, borderOpacity>0?1:0);
  frame.strokeWeight = 1;
  frame.strokeAlign = 'INSIDE';
  frame.effects = [bgBlur(24), ...glassShadows(glowColor)];
}

function applyPrimaryCard(frame, cr=R.xl) {
  frame.cornerRadius = cr;
  frame.fills = gradD(T.pri, T.priDark);
  frame.strokes = solid(T.priLight, 0.3);
  frame.strokeWeight = 1.5;
  frame.strokeAlign = 'INSIDE';
  frame.effects = [shadowLayer(T.priGlow,12,32,0,1), shadowLayer({r:0,g:0,b:0},4,12,0,0.4)];
}

function applyAccentCard(frame, cr=R.xl) {
  frame.cornerRadius = cr;
  frame.fills = gradD(T.acc, {r:0.2,g:0.16,b:0.6});
  frame.strokes = solid(T.accLight, 0.25);
  frame.strokeWeight = 1.5;
  frame.strokeAlign = 'INSIDE';
  frame.effects = [shadowLayer(T.accGlow,12,32,0,1), shadowLayer({r:0,g:0,b:0},4,12,0,0.4)];
}

function applySuccessCard(frame, cr=R.xl) {
  frame.cornerRadius = cr;
  frame.fills = [...gradV(T.greenDark,{r:0.04,g:0.12,b:0.07}), ...solid(T.glass)];
  frame.strokes = solid(T.green, 0.3);
  frame.strokeWeight = 1;
  frame.strokeAlign = 'INSIDE';
  frame.effects = [bgBlur(12), shadowLayer(T.greenGlow,8,20,0,1)];
}

// ─────────────────────────────────────────────────
// 5. IMAGE HELPER
// ─────────────────────────────────────────────────
function makeImageFill(key) {
  const b64 = ASSETS[key];
  if (!b64) return solid(T.bgCard);
  try {
    const bytes = Uint8Array.from(atob(b64), c=>c.charCodeAt(0));
    const img = figma.createImage(bytes);
    return [{type:'IMAGE', imageHash:img.hash, scaleMode:'FILL', opacity:1}];
  } catch(e) { return solid(T.bgCard); }
}

// ─────────────────────────────────────────────────
// 6. REUSABLE COMPONENTS
// ─────────────────────────────────────────────────

// ── Status Bar ─────────────────────────────────
async function makeStatusBar(parent) {
  const bar = await makeAutoFrame('Status Bar', W, 54, 'HORIZONTAL');
  bar.fills = noFill();
  bar.primaryAxisAlignItems = 'SPACE_BETWEEN';
  bar.counterAxisAlignItems = 'CENTER';
  bar.paddingLeft=24; bar.paddingRight=24; bar.paddingTop=16;

  const time = await makeText('9:41', 15, 'Bold', T.textHi);
  const icons = await makeText('▲ 5G  ▐▐ 100%', 13, 'Medium', T.textHi, 0.7);
  bar.appendChild(time); bar.appendChild(icons);
  parent.appendChild(bar);
}

// ── Floating Glass Nav Bar ─────────────────────
async function makeFloatingNav(parent, activeIdx=0) {
  const tabs = [
    {label:'Home',    icon:'⊙'},
    {label:'Search',  icon:'◎'},
    {label:'Trips',   icon:'↗'},
    {label:'Parcels', icon:'⬡'},
    {label:'Profile', icon:'○'},
  ];
  const navW = W - 32;
  const nav = await makeAutoFrame('Floating Nav', navW, 68, 'HORIZONTAL');
  nav.x = 16; nav.y = H - 68 - 20;
  nav.cornerRadius = R.pill;
  nav.fills = [...solid(T.bgCard, 0.75), ...solid(T.glass)];
  nav.strokes = solid(T.glassEdge);
  nav.strokeWeight = 1;
  nav.strokeAlign = 'INSIDE';
  nav.effects = [bgBlur(32), shadowLayer({r:0,g:0,b:0},8,32,0,0.5)];
  nav.primaryAxisAlignItems = 'SPACE_BETWEEN';
  nav.counterAxisAlignItems = 'CENTER';
  nav.paddingLeft=24; nav.paddingRight=24;

  for (let i=0;i<tabs.length;i++) {
    const t = tabs[i];
    const item = await makeAutoFrame(`Tab: ${t.label}`, 50, 48, 'VERTICAL');
    item.fills=noFill(); item.primaryAxisAlignItems='CENTER'; item.counterAxisAlignItems='CENTER'; item.itemSpacing=2;

    const icon = await makeText(t.icon, i===activeIdx?18:15, 'Medium', i===activeIdx?T.pri:T.textLow);
    const lbl  = await makeText(t.label, 10, i===activeIdx?'Bold':'Medium', i===activeIdx?T.pri:T.textLow, i===activeIdx?1:0.5);
    item.appendChild(icon); item.appendChild(lbl);

    if (i===activeIdx) {
      const dot = figma.createEllipse();
      dot.name='Active Dot'; dot.resize(4,4);
      dot.fills = solid(T.pri);
      item.appendChild(dot);
    }
    nav.appendChild(item);
  }
  parent.appendChild(nav);
}

// ── Chip / Tag ─────────────────────────────────
async function makeChip(label, color=T.textMed, bg=T.bgCard, borderColor=null, cr=R.pill) {
  const chip = figma.createFrame();
  chip.name=`Chip: ${label}`;
  chip.layoutMode='HORIZONTAL';
  chip.primaryAxisSizingMode='AUTO';
  chip.counterAxisSizingMode='AUTO';
  chip.cornerRadius=cr;
  chip.paddingLeft=12; chip.paddingRight=12; chip.paddingTop=6; chip.paddingBottom=6;
  chip.fills = solid(bg, 0.7);
  if (borderColor) { chip.strokes=solid(borderColor, 0.4); chip.strokeWeight=1; chip.strokeAlign='INSIDE'; }
  const txt = await makeText(label,12,'Medium',color);
  chip.appendChild(txt);
  return chip;
}

// ── Primary Button ─────────────────────────────
async function makePrimaryBtn(label, w, h=52) {
  const btn = figma.createFrame();
  btn.name=`Button: ${label}`;
  btn.resize(w,h); btn.cornerRadius=h/2;
  btn.layoutMode='HORIZONTAL';
  btn.primaryAxisAlignItems='CENTER'; btn.counterAxisAlignItems='CENTER';
  btn.fills = gradD(T.pri, T.priDark);
  btn.strokes = solid(T.priLight, 0.35); btn.strokeWeight=1; btn.strokeAlign='INSIDE';
  btn.effects=[shadowLayer(T.priGlow,8,20,0,1), shadowLayer({r:0,g:0,b:0},4,8,0,0.3)];
  const lbl = await makeText(label,15,'Bold',T.textHi);
  btn.appendChild(lbl);
  return btn;
}

// ── Ghost / Secondary Button ───────────────────
async function makeGhostBtn(label, w, h=52) {
  const btn = figma.createFrame();
  btn.name=`GhostBtn: ${label}`;
  btn.resize(w,h); btn.cornerRadius=h/2;
  btn.layoutMode='HORIZONTAL';
  btn.primaryAxisAlignItems='CENTER'; btn.counterAxisAlignItems='CENTER';
  btn.fills=solid(T.glass); btn.strokes=solid(T.glassEdge); btn.strokeWeight=1; btn.strokeAlign='INSIDE';
  const lbl = await makeText(label,15,'Medium',T.textHi, 0.85);
  btn.appendChild(lbl);
  return btn;
}

// ── Verification Badge Row ─────────────────────
async function makeVerificationRow(parent) {
  const row = figma.createFrame();
  row.name='Verification Badges';
  row.layoutMode='HORIZONTAL'; row.primaryAxisSizingMode='AUTO'; row.counterAxisSizingMode='AUTO';
  row.itemSpacing=8; row.fills=noFill();

  const badges = [
    {label:'✓ ID Verified', c:T.green, bg:T.greenDark},
    {label:'✓ License', c:T.green, bg:T.greenDark},
    {label:'✓ Vehicle', c:T.green, bg:T.greenDark},
  ];
  for (const b of badges) {
    const chip = await makeChip(b.label, b.c, b.bg, T.green);
    row.appendChild(chip);
  }
  parent.appendChild(row);
}

// ── Traveler Mini Card ─────────────────────────
async function makeTravelerMiniCard(name, route, seats, price, rating, imgKey, x, y) {
  const card = await makeAutoFrame(`Traveler: ${name}`, 320, 140, 'HORIZONTAL');
  applyGlass(card, R.xl);
  card.x=x; card.y=y;
  card.itemSpacing=16; card.paddingLeft=16; card.paddingRight=16; card.paddingTop=16; card.paddingBottom=16;
  card.counterAxisAlignItems='CENTER';

  // Vehicle image
  const imgRect = makeRect('Vehicle', 100, 100, makeImageFill(imgKey), R.lg);
  card.appendChild(imgRect);

  // Text block
  const info = await makeAutoFrame('Info', 168, 108, 'VERTICAL');
  info.fills=noFill(); info.itemSpacing=6; info.counterAxisSizingMode='FIXED';

  const nm   = await makeText(name, 15, 'Bold', T.textHi);
  const rt   = await makeText(route, 12, 'Medium', T.textMed, 0.85);
  const sRow = figma.createFrame();
  sRow.layoutMode='HORIZONTAL'; sRow.primaryAxisSizingMode='AUTO'; sRow.counterAxisSizingMode='AUTO';
  sRow.itemSpacing=8; sRow.fills=noFill();
  const sChip = await makeChip(`${seats} seats`,T.textHi,T.bgSurf);
  const rChip = await makeChip(`★ ${rating}`,T.amber,T.amberDark);
  sRow.appendChild(sChip); sRow.appendChild(rChip);
  const pRow = await makeText(`₹${price} cost share`,16,'Bold',T.pri);

  info.appendChild(nm); info.appendChild(rt); info.appendChild(sRow); info.appendChild(pRow);
  card.appendChild(info);
  return card;
}

// ─────────────────────────────────────────────────
// 7. SCREENS
// ─────────────────────────────────────────────────

// ── Screen 1: SPLASH ──────────────────────────
async function buildSplash(x, y) {
  const sc = await makeFrame('Screen / Splash', W, H);
  sc.x=x; sc.y=y;
  // Rich diagonal gradient background
  sc.fills = gradD(T.bgBase, {r:0.12,g:0.05,b:0.18});

  // Radial glow behind logo
  const glow = makeRect('Glow', 300, 300, gradV(T.priGlow, {r:0,g:0,b:0,a:0}), 150);
  glow.x=(W-300)/2; glow.y=220; sc.appendChild(glow);

  // Brand mark
  const brand = await makeText('SPOTT', 56, 'Black', T.textHi);
  brand.x=W/2; brand.y=302; brand.textAlignHorizontal='CENTER';
  brand.letterSpacing={value:-3,unit:'PIXELS'};
  sc.appendChild(brand);

  const tagline = await makeText('Travel Together.\nSend Smarter.', 20, 'Medium', T.textMed, 0.8, 'CENTER');
  tagline.x=W/2; tagline.y=375; tagline.textAlignHorizontal='CENTER';
  sc.appendChild(tagline);

  // Feature chips row
  const chipRow = figma.createFrame();
  chipRow.name='Feature Chips'; chipRow.layoutMode='HORIZONTAL'; chipRow.primaryAxisSizingMode='AUTO';
  chipRow.counterAxisSizingMode='AUTO'; chipRow.itemSpacing=10; chipRow.fills=noFill();

  const feats = ['⚡ Cost Sharing','📦 Parcel Delivery','🛡 Verified'];
  for (const f of feats) {
    const c = await makeChip(f, T.textMed, T.bgCard, T.glassEdge);
    chipRow.appendChild(c);
  }
  chipRow.x=(W - 300)/2 - 10; chipRow.y=440;
  sc.appendChild(chipRow);

  // CTA buttons
  const cta = await makePrimaryBtn('Get Started', W-48, 56);
  cta.x=24; cta.y=680; sc.appendChild(cta);

  const ghost = await makeGhostBtn('I already have an account', W-48, 48);
  ghost.x=24; ghost.y=748; sc.appendChild(ghost);

  await makeStatusBar(sc);
  return sc;
}

// ── Screen 2: ROLE SELECTOR ───────────────────
async function buildRoleSelector(x, y) {
  const sc = await makeFrame('Screen / Role Selector', W, H);
  sc.x=x; sc.y=y; sc.fills=solid(T.bgBase);

  await makeStatusBar(sc);

  const title = await makeText('How will you\nuse Spott?', 38, 'Black', T.textHi);
  title.x=24; title.y=80; sc.appendChild(title);

  const sub = await makeText('You can switch anytime', 15, 'Medium', T.textMed, 0.7);
  sub.x=24; sub.y=170; sc.appendChild(sub);

  // Passenger Card
  const passengerCard = await makeAutoFrame('Passenger Card', W-48, 175, 'HORIZONTAL');
  applyGlass(passengerCard, R.xl);
  passengerCard.x=24; passengerCard.y=210;
  passengerCard.itemSpacing=0; passengerCard.counterAxisAlignItems='CENTER';

  const carImg = makeRect('Car Asset', 150, 145, makeImageFill('car'), R.lg);
  carImg.layoutGrow=0;

  const pInfo = await makeAutoFrame('Passenger Info', 170, 145, 'VERTICAL');
  pInfo.fills=noFill(); pInfo.itemSpacing=8; pInfo.paddingLeft=20; pInfo.paddingTop=24;
  pInfo.primaryAxisAlignItems='SPACE_BETWEEN';

  const pLabel = await makeText('Passenger', 11, 'Bold', T.pri, 0.9);
  const pTitle = await makeText('Find &\nJoin Trips', 22, 'Black', T.textHi);
  const pSub   = await makeText('Ride with\nverified travelers', 12, 'Medium', T.textMed, 0.7);
  pInfo.appendChild(pLabel); pInfo.appendChild(pTitle); pInfo.appendChild(pSub);

  passengerCard.appendChild(carImg); passengerCard.appendChild(pInfo);
  sc.appendChild(passengerCard);

  // Traveler Card
  const travelerCard = await makeAutoFrame('Traveler Card', W-48, 175, 'HORIZONTAL');
  applyGlass(travelerCard, R.xl, T.accGlow);
  travelerCard.x=24; travelerCard.y=403;
  travelerCard.itemSpacing=0; travelerCard.counterAxisAlignItems='CENTER';

  const bikeImg = makeRect('Bike Asset', 150, 145, makeImageFill('bike'), R.lg);
  const tInfo = await makeAutoFrame('Traveler Info', 170, 145, 'VERTICAL');
  tInfo.fills=noFill(); tInfo.itemSpacing=8; tInfo.paddingLeft=20; tInfo.paddingTop=24;
  tInfo.primaryAxisAlignItems='SPACE_BETWEEN';

  const tLabel = await makeText('Traveler', 11, 'Bold', T.acc, 0.9);
  const tTitle = await makeText('Offer &\nShare Trips', 22, 'Black', T.textHi);
  const tSub   = await makeText('Recover costs,\nmeet co-travelers', 12, 'Medium', T.textMed, 0.7);
  tInfo.appendChild(tLabel); tInfo.appendChild(tTitle); tInfo.appendChild(tSub);

  travelerCard.appendChild(bikeImg); travelerCard.appendChild(tInfo);
  sc.appendChild(travelerCard);

  // Parcel Sender Card (smaller)
  const parcelCard = await makeAutoFrame('Parcel Sender Card', W-48, 130, 'HORIZONTAL');
  applyGlass(parcelCard, R.xl, T.accGlow);
  parcelCard.x=24; parcelCard.y=596;
  parcelCard.itemSpacing=0; parcelCard.counterAxisAlignItems='CENTER';

  const parcelImg = makeRect('Parcel Asset', 110, 100, makeImageFill('parcel'), R.lg);
  const paInfo = await makeAutoFrame('Parcel Info', 190, 100, 'VERTICAL');
  paInfo.fills=noFill(); paInfo.itemSpacing=6; paInfo.paddingLeft=20; paInfo.paddingTop=16;

  const paLabel = await makeText('Parcel Sender', 11, 'Bold', T.amber, 0.9);
  const paTitle = await makeText('Ship via\nTravelers', 20, 'Black', T.textHi);
  const paSub   = await makeText('Affordable • Fast • Tracked', 12, 'Medium', T.textMed, 0.7);
  paInfo.appendChild(paLabel); paInfo.appendChild(paTitle); paInfo.appendChild(paSub);

  parcelCard.appendChild(parcelImg); parcelCard.appendChild(paInfo);
  sc.appendChild(parcelCard);

  return sc;
}

// ── Screen 3: PASSENGER HOME ──────────────────
async function buildPassengerHome(x, y) {
  const sc = await makeFrame('Screen / Passenger Home', W, H);
  sc.x=x; sc.y=y; sc.fills=solid(T.bgBase);

  await makeStatusBar(sc);

  // Greeting
  const hi = await makeText('Good evening, Ritesh 👋', 14, 'Medium', T.textMed, 0.8);
  hi.x=24; hi.y=62; sc.appendChild(hi);
  const where = await makeText('Where to?', 36, 'Black', T.textHi);
  where.x=24; where.y=82; sc.appendChild(where);

  // ── HERO SEARCH PANEL (Uber Reserve style) ─────
  const searchPanel = await makeAutoFrame('Search Panel', W-48, 72, 'HORIZONTAL');
  applyGlass(searchPanel, R.xl);
  searchPanel.x=24; searchPanel.y=145;
  searchPanel.counterAxisAlignItems='CENTER'; searchPanel.itemSpacing=12;
  searchPanel.paddingLeft=20; searchPanel.paddingRight=16;

  const searchIcon = await makeText('⊙', 20, 'Bold', T.pri);
  const searchTxt  = await makeText('Search destination…', 16, 'Medium', T.textLow, 0.7);
  const searchBtn  = await makePrimaryBtn('Go', 52, 42);
  searchBtn.cornerRadius=R.lg;

  searchPanel.appendChild(searchIcon); searchPanel.appendChild(searchTxt); searchPanel.appendChild(searchBtn);
  sc.appendChild(searchPanel);

  // ── VEHICLE CHIP ROW ─────────────────────────
  const chipRow = figma.createFrame();
  chipRow.name='Vehicle Chips'; chipRow.layoutMode='HORIZONTAL'; chipRow.primaryAxisSizingMode='AUTO';
  chipRow.counterAxisSizingMode='AUTO'; chipRow.itemSpacing=8; chipRow.fills=noFill();
  chipRow.x=24; chipRow.y=232;
  const vehicles = [
    {label:'🛵 Bike', active:true},
    {label:'🚗 Car', active:false},
    {label:'🛺 Rikshaw', active:false},
    {label:'📦 Parcel', active:false},
  ];
  for (const v of vehicles) {
    const c = await makeChip(v.label, v.active?T.textHi:T.textMed, v.active?T.pri:T.bgCard, v.active?null:T.border);
    chipRow.appendChild(c);
  }
  sc.appendChild(chipRow);

  // ── BENTO GRID ───────────────────────────────
  // Row 1: Trip finder (large) + Parcel (small)
  const bentoGap = 14;
  const leftW = Math.floor((W-48-bentoGap)*0.58);
  const rightW = W-48-bentoGap-leftW;
  const bentoY = 290;

  // Left: Find Trip hero card
  const findCard = await makeAutoFrame('Bento: Find Trip', leftW, 220, 'VERTICAL');
  applyPrimaryCard(findCard, R.xl);
  findCard.x=24; findCard.y=bentoY;
  findCard.primaryAxisAlignItems='SPACE_BETWEEN';
  findCard.paddingLeft=18; findCard.paddingRight=18; findCard.paddingTop=20; findCard.paddingBottom=16;

  const bikeImg2 = makeRect('Bike', leftW-36, 110, makeImageFill('bike_clock'), R.lg);
  const findTitle = await makeText('Find\nYour Trip', 22, 'Black', T.textHi);
  const findBtn   = await makePrimaryBtn('Search Now', leftW-36, 42);
  findBtn.fills=solid(T.glass); findBtn.strokes=solid(T.glassEdge); findBtn.strokeWeight=1;
  findBtn.effects=[];

  findCard.appendChild(bikeImg2);
  findCard.appendChild(findTitle);
  findCard.appendChild(findBtn);
  sc.appendChild(findCard);

  // Right: Send Parcel card
  const parcelCard2 = await makeAutoFrame('Bento: Parcel', rightW, 220, 'VERTICAL');
  applyGlass(parcelCard2, R.xl, T.accGlow);
  parcelCard2.x=24+leftW+bentoGap; parcelCard2.y=bentoY;
  parcelCard2.primaryAxisAlignItems='SPACE_BETWEEN';
  parcelCard2.paddingLeft=14; parcelCard2.paddingRight=14; parcelCard2.paddingTop=18; parcelCard2.paddingBottom=14;

  const parcelImg2 = makeRect('Parcel', rightW-28, 100, makeImageFill('parcel'), R.lg);
  const parcelTitle = await makeText('Send\nParcel', 18, 'Bold', T.textHi);
  const parcelSub   = await makeText('Via travelers', 11, 'Medium', T.textMed, 0.7);

  parcelCard2.appendChild(parcelImg2); parcelCard2.appendChild(parcelTitle); parcelCard2.appendChild(parcelSub);
  sc.appendChild(parcelCard2);

  // Row 2: Safety Widget (full width)
  const safetyCard = await makeAutoFrame('Bento: Safety', W-48, 96, 'HORIZONTAL');
  applySuccessCard(safetyCard, R.xl);
  safetyCard.x=24; safetyCard.y=bentoY+220+bentoGap;
  safetyCard.counterAxisAlignItems='CENTER'; safetyCard.itemSpacing=16;
  safetyCard.paddingLeft=20; safetyCard.paddingRight=20; safetyCard.paddingTop=16; safetyCard.paddingBottom=16;

  const safetyImg = makeRect('Safety', 64, 64, makeImageFill('safety'), R.lg);
  const safetyInfo = figma.createFrame();
  safetyInfo.layoutMode='VERTICAL'; safetyInfo.primaryAxisSizingMode='AUTO'; safetyInfo.counterAxisSizingMode='AUTO';
  safetyInfo.itemSpacing=4; safetyInfo.fills=noFill();
  const sTitle = await makeText('Safety Center', 16, 'Bold', T.textHi);
  const sSub   = await makeText('SOS • Trusted Contacts • Live Sharing', 12, 'Medium', T.textMed, 0.75);
  safetyInfo.appendChild(sTitle); safetyInfo.appendChild(sSub);

  const arrowBtn = await makeText('→', 22, 'Bold', T.green);

  safetyCard.appendChild(safetyImg);
  safetyCard.appendChild(safetyInfo);
  safetyCard.appendChild(arrowBtn);
  sc.appendChild(safetyCard);

  // ── NEARBY TRIPS HEADER ──────────────────────
  const nearbyHeader = await makeText('Nearby Trips', 18, 'Bold', T.textHi);
  nearbyHeader.x=24; nearbyHeader.y=bentoY+220+bentoGap+96+24; sc.appendChild(nearbyHeader);
  const seeAll = await makeText('See all →', 13, 'Medium', T.pri);
  seeAll.x=W-24-60; seeAll.y=bentoY+220+bentoGap+96+28; sc.appendChild(seeAll);

  // Mini trip card
  const tripCard = await makeTravelerMiniCard('Arjun K.','Pune → Kolhapur','3','850','4.8','car_clock',24,
    bentoY+220+bentoGap+96+58);
  sc.appendChild(tripCard);

  await makeFloatingNav(sc, 0);
  return sc;
}

// ── Screen 4: TRIP SEARCH RESULTS ─────────────
async function buildSearchResults(x, y) {
  const sc = await makeFrame('Screen / Search Results', W, H);
  sc.x=x; sc.y=y; sc.fills=solid(T.bgBase);

  await makeStatusBar(sc);

  // Back + title
  const back = await makeText('← Search Results', 17, 'Bold', T.textHi);
  back.x=24; back.y=64; sc.appendChild(back);

  // Route summary chip
  const routeRow = figma.createFrame();
  routeRow.layoutMode='HORIZONTAL'; routeRow.primaryAxisSizingMode='AUTO'; routeRow.counterAxisSizingMode='AUTO';
  routeRow.itemSpacing=8; routeRow.fills=noFill(); routeRow.x=24; routeRow.y=100;

  const fromChip = await makeChip('📍 Pune', T.textHi, T.bgCard, T.border, R.lg);
  const arrow2   = await makeText('→', 18, 'Bold', T.pri);
  const toChip   = await makeChip('🏁 Kolhapur', T.textHi, T.bgCard, T.border, R.lg);
  routeRow.appendChild(fromChip); routeRow.appendChild(arrow2); routeRow.appendChild(toChip);
  sc.appendChild(routeRow);

  // Filter chips
  const filterRow = figma.createFrame();
  filterRow.layoutMode='HORIZONTAL'; filterRow.primaryAxisSizingMode='AUTO'; filterRow.counterAxisSizingMode='AUTO';
  filterRow.itemSpacing=8; filterRow.fills=noFill(); filterRow.x=24; filterRow.y=148;
  const filters = [
    {l:'All', active:true}, {l:'🚗 Car'}, {l:'🛵 Bike'}, {l:'Women Friendly'}, {l:'AC'}
  ];
  for (const f of filters) {
    const c = await makeChip(f.l, f.active?T.textHi:T.textMed, f.active?T.pri:T.bgCard, f.active?null:T.border);
    filterRow.appendChild(c);
  }
  sc.appendChild(filterRow);

  // Result cards
  const results = [
    {name:'Arjun K.',    route:'Pune → Kolhapur',     seats:'2 left', price:'850', rating:'4.9', img:'car_clock',     y:190},
    {name:'Priya M.',    route:'Pune → Kolhapur',     seats:'1 left', price:'700', rating:'4.7', img:'bike_clock',    y:348},
    {name:'Ravi S.',     route:'Pune → Kolhapur',     seats:'3 left', price:'950', rating:'4.6', img:'rikshaw_clock', y:506},
  ];

  for (const r of results) {
    const card = await makeAutoFrame(`Result: ${r.name}`, W-48, 142, 'HORIZONTAL');
    applyGlass(card, R.xl);
    card.x=24; card.y=r.y;
    card.counterAxisAlignItems='CENTER'; card.itemSpacing=14;
    card.paddingLeft=14; card.paddingRight=14; card.paddingTop=14; card.paddingBottom=14;

    const img = makeRect('Vehicle', 106, 106, makeImageFill(r.img), R.lg);
    card.appendChild(img);

    const info = await makeAutoFrame('Info', 210, 110, 'VERTICAL');
    info.fills=noFill(); info.itemSpacing=6;

    const topRow = figma.createFrame();
    topRow.layoutMode='HORIZONTAL'; topRow.primaryAxisSizingMode='AUTO'; topRow.counterAxisSizingMode='AUTO';
    topRow.itemSpacing=8; topRow.fills=noFill();
    const nameT = await makeText(r.name, 15, 'Bold', T.textHi);
    const ratingChip = await makeChip(`★ ${r.rating}`, T.amber, T.amberDark);
    topRow.appendChild(nameT); topRow.appendChild(ratingChip);

    const routeT = await makeText(r.route, 12, 'Medium', T.textMed, 0.8);
    const midRow = figma.createFrame();
    midRow.layoutMode='HORIZONTAL'; midRow.primaryAxisSizingMode='AUTO'; midRow.counterAxisSizingMode='AUTO';
    midRow.itemSpacing=8; midRow.fills=noFill();
    const seatsC = await makeChip(r.seats, T.green, T.greenDark, T.green);
    const priceT = await makeText(`₹${r.price}`, 17, 'Bold', T.pri);
    midRow.appendChild(seatsC); midRow.appendChild(priceT);

    const reqBtn = await makePrimaryBtn('Request Seat', 200, 38);
    reqBtn.cornerRadius=R.lg;

    info.appendChild(topRow); info.appendChild(routeT); info.appendChild(midRow); info.appendChild(reqBtn);
    card.appendChild(info);
    sc.appendChild(card);
  }

  await makeFloatingNav(sc, 1);
  return sc;
}

// ── Screen 5: TRAVELER DASHBOARD ──────────────
async function buildTravelerDashboard(x, y) {
  const sc = await makeFrame('Screen / Traveler Dashboard', W, H);
  sc.x=x; sc.y=y; sc.fills=solid(T.bgBase);

  await makeStatusBar(sc);

  // Header
  const headerRow = figma.createFrame();
  headerRow.layoutMode='HORIZONTAL'; headerRow.primaryAxisSizingMode='FIXED'; headerRow.counterAxisSizingMode='AUTO';
  headerRow.resize(W-48,40); headerRow.primaryAxisAlignItems='SPACE_BETWEEN'; headerRow.counterAxisAlignItems='CENTER';
  headerRow.fills=noFill(); headerRow.x=24; headerRow.y=62;

  const hTitle = await makeText('Traveler Mode', 24, 'Black', T.textHi);
  const modeChip = await makeChip('● Active', T.green, T.greenDark, T.green);
  headerRow.appendChild(hTitle); headerRow.appendChild(modeChip);
  sc.appendChild(headerRow);

  // ── NEXT TRIP HERO CARD ───────────────────────
  const heroCard = await makeAutoFrame('Hero: Next Trip', W-48, 170, 'VERTICAL');
  applyGlass(heroCard, R.xl);
  heroCard.x=24; heroCard.y=116;
  heroCard.primaryAxisAlignItems='SPACE_BETWEEN';
  heroCard.paddingLeft=20; heroCard.paddingRight=20; heroCard.paddingTop=20; heroCard.paddingBottom=20;

  const heroTop = figma.createFrame();
  heroTop.layoutMode='HORIZONTAL'; heroTop.primaryAxisSizingMode='FIXED'; heroTop.counterAxisSizingMode='AUTO';
  heroTop.resize(W-88,20); heroTop.primaryAxisAlignItems='SPACE_BETWEEN'; heroTop.fills=noFill();
  const heroLabel = await makeText('Your Next Trip', 12, 'Medium', T.textMed, 0.8);
  const timeChip  = await makeChip('Today, 4:30 PM', T.pri, T.priDark, T.pri, R.lg);
  heroTop.appendChild(heroLabel); heroTop.appendChild(timeChip);

  const routeBig = await makeText('Pune → Kolhapur', 28, 'Black', T.textHi);
  const routeSub = await makeText('3 Seats Available   •   Parcel Enabled', 13, 'Medium', T.textMed, 0.8);

  heroCard.appendChild(heroTop);
  heroCard.appendChild(routeBig);
  heroCard.appendChild(routeSub);
  sc.appendChild(heroCard);

  // ── STATS BENTO (2×2 equal) ──────────────────
  const gap = 14;
  const hw = Math.floor((W-48-gap)/2);
  const statY = 300;

  const stats = [
    {label:'Passengers Joined', val:'2',    sub:'On this trip', color:T.acc,   glow:T.accGlow,   img:null},
    {label:'Cost Recovery',     val:'₹850', sub:'This trip',    color:T.green, glow:T.greenGlow,  img:null},
  ];

  for (let i=0;i<stats.length;i++) {
    const s = stats[i];
    const statCard = await makeAutoFrame(`Stat: ${s.label}`, hw, 140, 'VERTICAL');
    applyGlass(statCard, R.xl, s.glow);
    statCard.x = 24 + i*(hw+gap); statCard.y=statY;
    statCard.primaryAxisAlignItems='SPACE_BETWEEN';
    statCard.paddingLeft=18; statCard.paddingRight=18; statCard.paddingTop=18; statCard.paddingBottom=18;

    const valTxt = await makeText(s.val, 32, 'Black', s.color);
    const lblTxt = await makeText(s.label, 13, 'Bold', T.textHi, 0.9);
    const subTxt = await makeText(s.sub, 11, 'Medium', T.textMed, 0.7);

    statCard.appendChild(valTxt); statCard.appendChild(lblTxt); statCard.appendChild(subTxt);
    sc.appendChild(statCard);
  }

  // ── QUICK ACTIONS ROW ────────────────────────
  const actY = statY+140+gap;
  const actions = [
    {label:'+ Offer Trip',  active:true},
    {label:'Manage Trips',  active:false},
    {label:'Requests 2',    active:false},
  ];
  const actW = Math.floor((W-48 - gap*2)/3);
  for (let i=0;i<actions.length;i++) {
    const a = actions[i];
    const actBtn = await makeAutoFrame(`Action: ${a.label}`, actW, 52, 'HORIZONTAL');
    actBtn.cornerRadius=R.pill;
    actBtn.fills = a.active ? gradD(T.pri,T.priDark) : solid(T.bgCard);
    actBtn.strokes = a.active ? solid(T.priLight,0.3) : solid(T.border);
    actBtn.strokeWeight=1; actBtn.strokeAlign='INSIDE';
    if (a.active) actBtn.effects=[shadowLayer(T.priGlow,6,16,0,1)];
    actBtn.primaryAxisAlignItems='CENTER'; actBtn.counterAxisAlignItems='CENTER';
    actBtn.x=24+i*(actW+gap); actBtn.y=actY;
    const aLbl = await makeText(a.label, 12, a.active?'Bold':'Medium', a.active?T.textHi:T.textMed);
    actBtn.appendChild(aLbl);
    sc.appendChild(actBtn);
  }

  // ── VEHICLE CARD ─────────────────────────────
  const vehCard = await makeAutoFrame('Vehicle Card', W-48, 120, 'HORIZONTAL');
  applyGlass(vehCard, R.xl, T.accGlow);
  vehCard.x=24; vehCard.y=actY+52+gap;
  vehCard.counterAxisAlignItems='CENTER'; vehCard.itemSpacing=16;
  vehCard.paddingLeft=16; vehCard.paddingRight=20; vehCard.paddingTop=16; vehCard.paddingBottom=16;

  const vehImg = makeRect('Vehicle', 90, 88, makeImageFill('car_clock'), R.lg);
  const vehInfo = await makeAutoFrame('Veh Info', W-48-90-16-36-32, 80, 'VERTICAL');
  vehInfo.fills=noFill(); vehInfo.itemSpacing=4;
  vehInfo.appendChild(await makeText('My Vehicle', 11, 'Bold', T.acc, 0.9));
  vehInfo.appendChild(await makeText('Honda Activa 6G', 17, 'Bold', T.textHi));
  vehInfo.appendChild(await makeText('MH-09 AB 1234  •  ✓ Verified', 12, 'Medium', T.textMed, 0.8));
  const editBtn = await makeText('Edit →', 13, 'Bold', T.acc);

  vehCard.appendChild(vehImg); vehCard.appendChild(vehInfo); vehCard.appendChild(editBtn);
  sc.appendChild(vehCard);

  await makeFloatingNav(sc, 0);
  return sc;
}

// ── Screen 6: PARCEL BOOKING ──────────────────
async function buildParcelBooking(x, y) {
  const sc = await makeFrame('Screen / Parcel Booking', W, H);
  sc.x=x; sc.y=y; sc.fills=solid(T.bgBase);

  await makeStatusBar(sc);

  // Hero
  const heroParcel = await makeAutoFrame('Parcel Hero', W, 240, 'VERTICAL');
  heroParcel.fills = gradD(T.bgBase, {r:0.15,g:0.08,b:0.02});
  heroParcel.x=0; heroParcel.y=0;
  heroParcel.primaryAxisAlignItems='CENTER'; heroParcel.counterAxisAlignItems='CENTER'; heroParcel.itemSpacing=0;

  const parcelBigImg = makeRect('Parcel Hero Image', 200, 160, makeImageFill('parcel'), R.xl);
  parcelBigImg.x=(W-200)/2; parcelBigImg.y=54;
  heroParcel.appendChild(parcelBigImg);
  sc.appendChild(heroParcel);

  const heroTitle = await makeText('Send a Parcel', 30, 'Black', T.textHi);
  heroTitle.x=24; heroTitle.y=254; sc.appendChild(heroTitle);
  const heroSub = await makeText('Via trusted travelers on your route', 14, 'Medium', T.textMed, 0.75);
  heroSub.x=24; heroSub.y=292; sc.appendChild(heroSub);

  // Package type picker
  const pkgLabel = await makeText('Package Type', 13, 'Bold', T.textMed, 0.7);
  pkgLabel.x=24; pkgLabel.y=334; sc.appendChild(pkgLabel);

  const pkgRow = figma.createFrame();
  pkgRow.layoutMode='HORIZONTAL'; pkgRow.primaryAxisSizingMode='AUTO'; pkgRow.counterAxisSizingMode='AUTO';
  pkgRow.itemSpacing=12; pkgRow.fills=noFill(); pkgRow.x=24; pkgRow.y=360;

  const pkgs = [
    {icon:'📄', label:'Documents', desc:'≤1 kg', active:false},
    {icon:'📦', label:'Medium Box', desc:'≤5 kg', active:true},
    {icon:'🍎', label:'Perishable', desc:'Food', active:false},
    {icon:'💊', label:'Medicine',   desc:'Health', active:false},
  ];
  for (const p of pkgs) {
    const pkgCard = await makeAutoFrame(`Pkg: ${p.label}`, 88, 96, 'VERTICAL');
    pkgCard.cornerRadius=R.xl;
    pkgCard.fills = p.active ? [...solid(T.pri,0.15),...solid(T.glass)] : solid(T.bgCard,0.7);
    pkgCard.strokes = p.active ? solid(T.pri,0.6) : solid(T.border);
    pkgCard.strokeWeight = p.active?1.5:1; pkgCard.strokeAlign='INSIDE';
    if (p.active) pkgCard.effects=[shadowLayer(T.priGlow,6,16,0,0.6)];
    pkgCard.primaryAxisAlignItems='CENTER'; pkgCard.counterAxisAlignItems='CENTER'; pkgCard.itemSpacing=4;

    const pkgIcon  = await makeText(p.icon, 24, 'Regular', T.textHi);
    const pkgLbl   = await makeText(p.label, 11, 'Bold', p.active?T.pri:T.textHi, 0.9);
    const pkgDesc  = await makeText(p.desc, 10, 'Medium', T.textMed, 0.6);

    pkgCard.appendChild(pkgIcon); pkgCard.appendChild(pkgLbl); pkgCard.appendChild(pkgDesc);
    pkgRow.appendChild(pkgCard);
  }
  sc.appendChild(pkgRow);

  // Route inputs
  const routeCard = await makeAutoFrame('Route Card', W-48, 130, 'VERTICAL');
  applyGlass(routeCard, R.xl);
  routeCard.x=24; routeCard.y=476;
  routeCard.itemSpacing=0; routeCard.paddingLeft=20; routeCard.paddingRight=20; routeCard.paddingTop=8; routeCard.paddingBottom=8;

  const pickup = await makeAutoFrame('Pickup Row', W-88, 52, 'HORIZONTAL');
  pickup.fills=noFill(); pickup.counterAxisAlignItems='CENTER'; pickup.itemSpacing=12;
  pickup.appendChild(await makeText('⊙', 18, 'Bold', T.green));
  const pickupTxt = await makeAutoFrame('Pickup Fields', 100, 40, 'VERTICAL');
  pickupTxt.fills=noFill();
  pickupTxt.appendChild(await makeText('PICKUP', 9, 'Bold', T.textLow, 0.7));
  pickupTxt.appendChild(await makeText('Shivaji Nagar, Pune', 14, 'Medium', T.textHi));
  pickup.appendChild(pickupTxt);
  routeCard.appendChild(pickup);

  const divLine = makeRect('Divider', W-88, 1, solid(T.border), 0);
  routeCard.appendChild(divLine);

  const drop = await makeAutoFrame('Drop Row', W-88, 52, 'HORIZONTAL');
  drop.fills=noFill(); drop.counterAxisAlignItems='CENTER'; drop.itemSpacing=12;
  drop.appendChild(await makeText('●', 18, 'Bold', T.pri));
  const dropTxt = await makeAutoFrame('Drop Fields', 100, 40, 'VERTICAL');
  dropTxt.fills=noFill();
  dropTxt.appendChild(await makeText('DROP', 9, 'Bold', T.textLow, 0.7));
  dropTxt.appendChild(await makeText('Rajaram Puri, Kolhapur', 14, 'Medium', T.textHi));
  drop.appendChild(dropTxt);
  routeCard.appendChild(drop);
  sc.appendChild(routeCard);

  // CTA
  const cta = await makePrimaryBtn('Find Traveler Match', W-48, 56);
  cta.x=24; cta.y=H-72-24; sc.appendChild(cta);

  await makeStatusBar(sc);
  return sc;
}

// ── Screen 7: PARCEL TRACKING ─────────────────
async function buildParcelTracking(x, y) {
  const sc = await makeFrame('Screen / Parcel Tracking', W, H);
  sc.x=x; sc.y=y; sc.fills=solid(T.bgBase);

  await makeStatusBar(sc);

  const back = await makeText('← Track Parcel', 17, 'Bold', T.textHi);
  back.x=24; back.y=64; sc.appendChild(back);

  // Status hero card
  const statusCard = await makeAutoFrame('Status Card', W-48, 110, 'HORIZONTAL');
  applySuccessCard(statusCard, R.xl);
  statusCard.x=24; statusCard.y=104;
  statusCard.counterAxisAlignItems='CENTER'; statusCard.itemSpacing=16;
  statusCard.paddingLeft=20; statusCard.paddingRight=20; statusCard.paddingTop=16; statusCard.paddingBottom=16;

  const routeImg = makeRect('Route', 78, 78, makeImageFill('route'), R.lg);
  statusCard.appendChild(routeImg);
  const statusInfo = await makeAutoFrame('Status Info', W-48-78-16-40-16, 78, 'VERTICAL');
  statusInfo.fills=noFill(); statusInfo.itemSpacing=4;
  statusInfo.appendChild(await makeText('In Transit', 20, 'Black', T.green));
  statusInfo.appendChild(await makeText('Pune → Kolhapur', 13, 'Medium', T.textMed, 0.8));
  statusInfo.appendChild(await makeText('Est. Delivery: 4:00 PM', 12, 'Medium', T.textMed, 0.65));
  statusCard.appendChild(statusInfo);
  sc.appendChild(statusCard);

  // Timeline
  const tlLabel = await makeText('Tracking Timeline', 16, 'Bold', T.textHi);
  tlLabel.x=24; tlLabel.y=234; sc.appendChild(tlLabel);

  const tlSteps = [
    {title:'Parcel Booked',         time:'10:00 AM',  done:true,   active:false},
    {title:'Traveler Assigned',     time:'10:45 AM',  done:true,   active:false},
    {title:'Picked Up',             time:'11:30 AM',  done:true,   active:false},
    {title:'In Transit',            time:'12:15 PM',  done:false,  active:true},
    {title:'Out for Delivery',      time:'Est. 3 PM',  done:false,  active:false},
    {title:'Delivered',             time:'Pending',   done:false,  active:false},
  ];

  let tlY = 270;
  for (let i=0; i<tlSteps.length; i++) {
    const s = tlSteps[i];
    // Node circle
    const nodeCircle = figma.createEllipse();
    nodeCircle.name=`TL Node ${i}`;
    nodeCircle.resize(16,16);
    nodeCircle.x=24+4; nodeCircle.y=tlY+2;
    if (s.done)         nodeCircle.fills=solid(T.green);
    else if (s.active)  { nodeCircle.fills=solid(T.pri); nodeCircle.effects=[shadowLayer(T.priGlow,0,12,4,1)]; }
    else                nodeCircle.fills=solid(T.textMute);
    sc.appendChild(nodeCircle);

    // Connecting line (not for last)
    if (i < tlSteps.length-1) {
      const line = makeRect(`TL Line ${i}`, 2, 36, solid(s.done?T.green:T.border), 1);
      line.x=24+4+7; line.y=tlY+16;
      sc.appendChild(line);
    }

    // Text
    const stepTitle = await makeText(s.title, 14, s.active?'Bold':'Medium', s.done||s.active?T.textHi:T.textLow, s.done||s.active?1:0.5);
    stepTitle.x=24+28; stepTitle.y=tlY;
    const stepTime = await makeText(s.time, 11, 'Medium', s.done?T.green:T.textMute, s.active?0.9:0.55);
    stepTime.x=24+28; stepTime.y=tlY+18;
    sc.appendChild(stepTitle); sc.appendChild(stepTime);

    tlY += 52;
  }

  // Traveler info card at bottom
  const travCard = await makeAutoFrame('Traveler Info', W-48, 80, 'HORIZONTAL');
  applyGlass(travCard, R.xl);
  travCard.x=24; travCard.y=H-110;
  travCard.counterAxisAlignItems='CENTER'; travCard.itemSpacing=14;
  travCard.paddingLeft=16; travCard.paddingRight=16; travCard.paddingTop=14; travCard.paddingBottom=14;

  const travImg = makeRect('Traveler', 52, 52, makeImageFill('car_clock'), R.pill);
  travCard.appendChild(travImg);
  const travInfo = await makeAutoFrame('Traveler Details', W-48-52-14-80-14, 54, 'VERTICAL');
  travInfo.fills=noFill(); travInfo.itemSpacing=4;
  travInfo.appendChild(await makeText('Your Traveler', 10, 'Bold', T.textMed, 0.7));
  travInfo.appendChild(await makeText('Arjun Kulkarni', 15, 'Bold', T.textHi));
  travInfo.appendChild(await makeText('★ 4.9  •  147 trips', 11, 'Medium', T.amber, 0.9));
  travCard.appendChild(travInfo);
  const callBtn = await makePrimaryBtn('Call', 72, 44);
  callBtn.cornerRadius=R.lg;
  travCard.appendChild(callBtn);
  sc.appendChild(travCard);

  return sc;
}

// ── Screen 8: SAFETY CENTER ───────────────────
async function buildSafetyCenter(x, y) {
  const sc = await makeFrame('Screen / Safety Center', W, H);
  sc.x=x; sc.y=y; sc.fills=solid(T.bgBase);

  await makeStatusBar(sc);

  const title = await makeText('Safety Center', 28, 'Black', T.textHi);
  title.x=24; title.y=64; sc.appendChild(title);
  const sub = await makeText('Your safety is our top priority', 14, 'Medium', T.textMed, 0.7);
  sub.x=24; sub.y=100; sc.appendChild(sub);

  // SOS Emergency Card (Red-glow variant)
  const sosCard = await makeAutoFrame('SOS Emergency', W-48, 100, 'HORIZONTAL');
  sosCard.cornerRadius=R.xl;
  sosCard.fills = [...solid(T.priDark, 0.8), ...solid(T.pri, 0.15)];
  sosCard.strokes = solid(T.pri, 0.5); sosCard.strokeWeight=1.5; sosCard.strokeAlign='INSIDE';
  sosCard.effects = [bgBlur(20), shadowLayer(T.priGlow,12,28,0,1), shadowLayer({r:0,g:0,b:0},4,12,0,0.4)];
  sosCard.x=24; sosCard.y=134;
  sosCard.counterAxisAlignItems='CENTER'; sosCard.itemSpacing=0;
  sosCard.paddingLeft=20; sosCard.paddingRight=20; sosCard.paddingTop=16; sosCard.paddingBottom=16;
  sosCard.primaryAxisAlignItems='SPACE_BETWEEN';

  const sosLeft = await makeAutoFrame('SOS Left', 200, 68, 'VERTICAL');
  sosLeft.fills=noFill(); sosLeft.itemSpacing=4;
  sosLeft.appendChild(await makeText('🚨  Emergency SOS', 17, 'Black', T.textHi));
  sosLeft.appendChild(await makeText('Alerts contacts & shares location', 12, 'Medium', T.priLight, 0.9));
  sosCard.appendChild(sosLeft);

  const sosBtn = await makeAutoFrame('SOS Button', 90, 44, 'HORIZONTAL');
  sosBtn.cornerRadius=R.lg; sosBtn.fills=solid(T.pri);
  sosBtn.primaryAxisAlignItems='CENTER'; sosBtn.counterAxisAlignItems='CENTER';
  sosBtn.effects=[shadowLayer(T.priGlow,6,14,0,1)];
  sosBtn.appendChild(await makeText('HOLD SOS', 11, 'Black', T.textHi));
  sosCard.appendChild(sosBtn);
  sc.appendChild(sosCard);

  // Info cards
  const infoCards = [
    {icon:'👥', title:'Trusted Contacts',    desc:'3 contacts added',              y:250, color:T.acc,   glow:T.accGlow},
    {icon:'📍', title:'Live Trip Sharing',   desc:'Share link with anyone',        y:336, color:T.green, glow:T.greenGlow},
    {icon:'🛡',  title:'Trip Verification',  desc:'All travelers ID verified',     y:422, color:T.green, glow:T.greenGlow},
    {icon:'⚠',  title:'Report an Issue',     desc:'Raise concern about a trip',    y:508, color:T.amber, glow:{r:T.amber.r,g:T.amber.g,b:T.amber.b,a:0.18}},
  ];

  for (const c of infoCards) {
    const card = await makeAutoFrame(`Safety: ${c.title}`, W-48, 78, 'HORIZONTAL');
    applyGlass(card, R.xl, c.glow);
    card.x=24; card.y=c.y;
    card.counterAxisAlignItems='CENTER'; card.itemSpacing=16;
    card.paddingLeft=20; card.paddingRight=20; card.paddingTop=14; card.paddingBottom=14;

    const iconFrame = await makeAutoFrame('Icon', 48, 48, 'HORIZONTAL');
    iconFrame.cornerRadius=R.lg; iconFrame.fills=solid(c.color,0.12);
    iconFrame.primaryAxisAlignItems='CENTER'; iconFrame.counterAxisAlignItems='CENTER';
    iconFrame.appendChild(await makeText(c.icon, 22, 'Regular', c.color));

    const info2 = await makeAutoFrame('Info', W-48-48-16-20-20-24, 48, 'VERTICAL');
    info2.fills=noFill(); info2.itemSpacing=4;
    info2.appendChild(await makeText(c.title, 15, 'Bold', T.textHi));
    info2.appendChild(await makeText(c.desc, 12, 'Medium', T.textMed, 0.8));

    card.appendChild(iconFrame); card.appendChild(info2);
    card.appendChild(await makeText('→', 18, 'Bold', c.color, 0.7));
    sc.appendChild(card);
  }

  // Safety Image
  const safetyHeroImg = makeRect('Safety Hero', W-48, 80, makeImageFill('safety'), R.xl);
  safetyHeroImg.x=24; safetyHeroImg.y=604; sc.appendChild(safetyHeroImg);

  await makeFloatingNav(sc, 4);
  return sc;
}

// ── Screen 9: PROFILE ─────────────────────────
async function buildProfile(x, y) {
  const sc = await makeFrame('Screen / Profile', W, H);
  sc.x=x; sc.y=y; sc.fills=solid(T.bgBase);

  await makeStatusBar(sc);

  // Profile hero
  const heroRect = await makeAutoFrame('Profile Hero', W, 210, 'VERTICAL');
  heroRect.fills = gradD(T.bgMid, T.bgBase);
  heroRect.x=0; heroRect.y=0;
  heroRect.primaryAxisAlignItems='CENTER'; heroRect.counterAxisAlignItems='CENTER'; heroRect.itemSpacing=0;

  const avatarBg = figma.createEllipse();
  avatarBg.name='Avatar'; avatarBg.resize(80,80);
  avatarBg.x=(W-80)/2; avatarBg.y=64;
  avatarBg.fills = solid(T.pri, 0.3);
  avatarBg.strokes = solid(T.pri, 0.7); avatarBg.strokeWeight=2;
  sc.appendChild(avatarBg);

  const avatarInitial = await makeText('R', 32, 'Black', T.textHi);
  avatarInitial.x=(W-18)/2; avatarInitial.y=82; avatarInitial.textAlignHorizontal='CENTER';
  sc.appendChild(avatarInitial);

  const pName = await makeText('Ritesh Mahatme', 22, 'Black', T.textHi, 1,'CENTER');
  pName.x=W/2; pName.y=154; pName.textAlignHorizontal='CENTER';
  sc.appendChild(pName);

  const pPhone = await makeText('+91 98765 43210', 13, 'Medium', T.textMed, 0.7, 'CENTER');
  pPhone.x=W/2; pPhone.y=182; pPhone.textAlignHorizontal='CENTER';
  sc.appendChild(pPhone);

  sc.appendChild(heroRect);

  // Verification card
  const vCard = await makeAutoFrame('Verification', W-48, 100, 'VERTICAL');
  applySuccessCard(vCard, R.xl);
  vCard.x=24; vCard.y=222;
  vCard.paddingLeft=20; vCard.paddingRight=20; vCard.paddingTop=16; vCard.paddingBottom=16; vCard.itemSpacing=10;

  vCard.appendChild(await makeText('Verification Status', 13, 'Bold', T.green, 0.8));
  await makeVerificationRow(vCard);
  sc.appendChild(vCard);

  // Stats row
  const statY2 = 338;
  const sGap = 14;
  const sW = Math.floor((W-48-sGap*2)/3);
  const pStats = [
    {val:'147', label:'Trips'},
    {val:'4.9', label:'Rating'},
    {val:'₹0',  label:'Pending'},
  ];
  for (let i=0;i<pStats.length;i++) {
    const sCard = await makeAutoFrame(`Stat: ${pStats[i].label}`, sW, 76, 'VERTICAL');
    applyGlass(sCard, R.lg);
    sCard.x=24+i*(sW+sGap); sCard.y=statY2;
    sCard.primaryAxisAlignItems='CENTER'; sCard.counterAxisAlignItems='CENTER'; sCard.itemSpacing=4;
    sCard.appendChild(await makeText(pStats[i].val, 22, 'Black', T.textHi));
    sCard.appendChild(await makeText(pStats[i].label, 11, 'Medium', T.textMed, 0.7));
    sc.appendChild(sCard);
  }

  // Settings list
  const settingsY = 430;
  const settingsItems = [
    {icon:'🚗', label:'My Vehicle',      desc:'Honda Activa 6G'},
    {icon:'🛡',  label:'Safety Settings', desc:'Contacts & SOS'},
    {icon:'💳', label:'Payment',         desc:'UPI: user@upi'},
    {icon:'⚙', label:'App Settings',    desc:'Notifications, Theme'},
    {icon:'❓', label:'Help & Support',  desc:'FAQs & Chat'},
  ];
  for (let i=0;i<settingsItems.length;i++) {
    const item = settingsItems[i];
    const row = await makeAutoFrame(`Setting: ${item.label}`, W-48, 64, 'HORIZONTAL');
    applyGlass(row, R.lg);
    row.x=24; row.y=settingsY+i*78;
    row.counterAxisAlignItems='CENTER'; row.itemSpacing=16;
    row.paddingLeft=16; row.paddingRight=16; row.paddingTop=12; row.paddingBottom=12;

    const iconF = await makeAutoFrame('Icon', 40, 40, 'HORIZONTAL');
    iconF.cornerRadius=R.sm; iconF.fills=solid(T.bgCard,0.8);
    iconF.primaryAxisAlignItems='CENTER'; iconF.counterAxisAlignItems='CENTER';
    iconF.appendChild(await makeText(item.icon, 18, 'Regular', T.textHi));

    const rowInfo = await makeAutoFrame('Row Info', W-48-40-16-24-32, 44, 'VERTICAL');
    rowInfo.fills=noFill(); rowInfo.itemSpacing=2;
    rowInfo.appendChild(await makeText(item.label, 14, 'Bold', T.textHi));
    rowInfo.appendChild(await makeText(item.desc, 11, 'Medium', T.textMed, 0.7));

    row.appendChild(iconF); row.appendChild(rowInfo);
    row.appendChild(await makeText('›', 20, 'Bold', T.textMed, 0.5));
    sc.appendChild(row);
  }

  await makeFloatingNav(sc, 4);
  return sc;
}

// ── Screen 10: VERIFICATION PENDING ──────────
async function buildVerificationPending(x, y) {
  const sc = await makeFrame('Screen / Verification Pending', W, H);
  sc.x=x; sc.y=y; sc.fills=solid(T.bgBase);

  await makeStatusBar(sc);

  const heroImg = makeRect('Verification Illustration', W-96, W-96, makeImageFill('verification'), R.xxl);
  heroImg.x=48; heroImg.y=100; sc.appendChild(heroImg);

  const t1 = await makeText('Verification\nIn Progress', 34, 'Black', T.textHi, 1, 'CENTER');
  t1.x=W/2; t1.y=420; t1.textAlignHorizontal='CENTER'; sc.appendChild(t1);

  const t2 = await makeText('We are reviewing your documents.\nUsually takes 2-4 hours.', 15, 'Medium', T.textMed, 0.75, 'CENTER');
  t2.x=W/2; t2.y=494; t2.textAlignHorizontal='CENTER'; sc.appendChild(t2);

  // Progress steps
  const steps = [
    {label:'Identity Submitted',  done:true},
    {label:'License Under Review',done:false},
    {label:'Vehicle RC Pending',  done:false},
  ];
  let stY=560;
  for (const s of steps) {
    const stepRow = figma.createFrame();
    stepRow.layoutMode='HORIZONTAL'; stepRow.primaryAxisSizingMode='AUTO'; stepRow.counterAxisSizingMode='AUTO';
    stepRow.itemSpacing=12; stepRow.fills=noFill(); stepRow.x=(W-220)/2; stepRow.y=stY;

    const dot = figma.createEllipse();
    dot.resize(12,12); dot.fills=solid(s.done?T.green:T.textMute);
    if (s.done) dot.effects=[shadowLayer(T.greenGlow,0,8,2,1)];
    stepRow.appendChild(dot);
    stepRow.appendChild(await makeText(s.label, 13, s.done?'Bold':'Medium', s.done?T.green:T.textLow));
    sc.appendChild(stepRow);
    stY+=36;
  }

  const cta2 = await makeGhostBtn('Check Status', W-48, 52);
  cta2.x=24; cta2.y=700; sc.appendChild(cta2);

  return sc;
}

// ─────────────────────────────────────────────────
// 8. MAIN EXECUTION
// ─────────────────────────────────────────────────
async function main() {
  await figma.loadFontAsync({family:'Inter', style:'Regular'});
  await figma.loadFontAsync({family:'Inter', style:'Medium'});
  await figma.loadFontAsync({family:'Inter', style:'Bold'});
  await figma.loadFontAsync({family:'Inter', style:'Black'});

  const GAP = 80;
  const ROW_H = H + 120;

  const screens = [];

  // Row 0: Auth & Onboarding
  screens.push(await buildSplash(0, 0));
  screens.push(await buildRoleSelector(W+GAP, 0));

  // Row 1: Passenger flow
  screens.push(await buildPassengerHome(0, ROW_H));
  screens.push(await buildSearchResults(W+GAP, ROW_H));

  // Row 2: Traveler + Parcel
  screens.push(await buildTravelerDashboard(0, ROW_H*2));
  screens.push(await buildParcelBooking(W+GAP, ROW_H*2));
  screens.push(await buildParcelTracking((W+GAP)*2, ROW_H*2));

  // Row 3: Safety + Profile + Verification
  screens.push(await buildSafetyCenter(0, ROW_H*3));
  screens.push(await buildProfile(W+GAP, ROW_H*3));
  screens.push(await buildVerificationPending((W+GAP)*2, ROW_H*3));

  screens.forEach(s => figma.currentPage.appendChild(s));
  figma.viewport.scrollAndZoomIntoView(screens);
  figma.closePlugin(`✨ Spott Premium UI — ${screens.length} screens generated.`);
}

main().catch(e => { console.error(e); figma.closePlugin('❌ Error: ' + e.message); });
""".strip()

# ─────────────────────────────────────────────────────────────────────────────
# INJECT ASSETS & WRITE
# ─────────────────────────────────────────────────────────────────────────────
assets_js = "{\n"
for key, b64 in ASSETS.items():
    assets_js += f'  "{key}": "{b64}",\n'
assets_js += "}"

final_js = JS_PLUGIN.replace("__ASSETS__", assets_js)

print("Writing code.js ...")
with open(CODE_JS_PATH, "w", encoding="utf-8") as f:
    f.write(final_js)

size_kb = os.path.getsize(CODE_JS_PATH) / 1024
print(f"[OK] code.js written ({size_kb:.0f} KB)")
print("Done. Run the Figma plugin to generate the UI.")
