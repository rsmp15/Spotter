import json
import sys
import os

sys.stdout.reconfigure(encoding='utf-8')

# Paths
figma_json_path = r"C:\Users\Ritesh Mahatme\Downloads\output.txt"
code_js_path = r"D:\PROJECTS\Spotter\spotter\figma-plugin\code.js"

# 1. Load Figma JSON
with open(figma_json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

doc = data.get("document", {})
canvas = doc.get("children", [])[0]
canvas_children = canvas.get("children", [])

# Helpers for parsing
def get_solid_fill(node):
    if not node:
        return None
    for fill in node.get("fills", []):
        if fill.get("type") == "SOLID" and fill.get("visible", True) != False:
            c = fill.get("color", {})
            return {"r": round(c.get("r", 0), 8), "g": round(c.get("g", 0), 8), "b": round(c.get("b", 0), 8)}
    for fill in node.get("background", []):
        if fill.get("type") == "SOLID" and fill.get("visible", True) != False:
            c = fill.get("color", {})
            return {"r": round(c.get("r", 0), 8), "g": round(c.get("g", 0), 8), "b": round(c.get("b", 0), 8)}
    return None

def find_first_text_child(node):
    if node.get("type") == "TEXT":
        return node
    for child in node.get("children", []):
        res = find_first_text_child(child)
        if res:
            return res
    return None

def is_status_bar(node):
    name = node.get("name", "").strip()
    if name in ("9:41", "5G Battery", "5G   Battery", "Battery", "Status Bar"):
        return True
    return False

parsed_screens = []

def parse_screen(canvas_child):
    if canvas_child.get("type") != "FRAME":
        return None
        
    name = canvas_child.get("name", "Unnamed Screen")
    bbox = canvas_child.get("absoluteBoundingBox", {})
    if not bbox:
        return None
        
    screen_x, screen_y = bbox.get("x", 0), bbox.get("y", 0)
    screen_w, screen_h = bbox.get("width", 0), bbox.get("height", 0)
    
    screen_fill = get_solid_fill(canvas_child)
    parsed_children = []
    
    def process_node(node):
        nonlocal screen_fill
        ntype = node.get("type")
        nname = node.get("name", "")
        nbbox = node.get("absoluteBoundingBox", {})
        
        if not nbbox:
            return
            
        x, y = nbbox.get("x", 0), nbbox.get("y", 0)
        w, h = nbbox.get("width", 0), nbbox.get("height", 0)
        
        # Check background frame
        if ntype == "FRAME" and x == screen_x and y == screen_y and w == screen_w and h == screen_h:
            fill_candidate = get_solid_fill(node)
            if fill_candidate:
                screen_fill = fill_candidate
            return
            
        # Exclude status bar elements
        if is_status_bar(node):
            return
            
        # Is it button or chip?
        if ntype == "FRAME" and ("Button" in nname or "button" in nname):
            fill = get_solid_fill(node) or {"r": 0.06666667, "g": 0.06666667, "b": 0.06666667}
            cornerRadius = node.get("cornerRadius", 14)
            
            text_node = find_first_text_child(node)
            text_val = text_node.get("characters", "") if text_node else ""
            text_color = get_solid_fill(text_node) if text_node else {"r": 1, "g": 1, "b": 1}
            text_style = text_node.get("style", {}) if text_node else {}
            font_family = text_style.get("fontFamily", "Inter")
            font_style = text_style.get("fontStyle", "Bold")
            font_size = text_style.get("fontSize", 16)
            
            parsed_children.append({
                "type": "button",
                "x": x, "y": y, "width": w, "height": h,
                "fill": fill,
                "cornerRadius": cornerRadius,
                "text": text_val,
                "textColor": text_color,
                "font": {"family": font_family, "style": font_style},
                "fontSize": font_size,
                "name": nname
            })
            return
            
        if ntype == "FRAME" and ("Chip" in nname or "chip" in nname):
            fill = get_solid_fill(node) or {"r": 0.05098039, "g": 0.2, "b": 0.12941177}
            cornerRadius = node.get("cornerRadius", 14)
            
            text_node = find_first_text_child(node)
            text_val = text_node.get("characters", "") if text_node else ""
            text_color = get_solid_fill(text_node) if text_node else {"r": 1, "g": 1, "b": 1}
            text_style = text_node.get("style", {}) if text_node else {}
            font_family = text_style.get("fontFamily", "Inter")
            font_style = text_style.get("fontStyle", "Regular")
            font_size = text_style.get("fontSize", 15)
            
            parsed_children.append({
                "type": "chip",
                "x": x, "y": y, "width": w, "height": h,
                "fill": fill,
                "cornerRadius": cornerRadius,
                "text": text_val,
                "textColor": text_color,
                "font": {"family": font_family, "style": font_style},
                "fontSize": font_size,
                "name": nname
            })
            return
            
        if ntype == "TEXT":
            text_val = node.get("characters", "")
            if not text_val.strip():
                return
            fill = get_solid_fill(node) or {"r": 0.10196079, "g": 0.10196079, "b": 0.10196079}
            style = node.get("style", {})
            font_family = style.get("fontFamily", "Inter")
            font_style = style.get("fontStyle", "Regular")
            font_size = style.get("fontSize", 14)
            
            parsed_children.append({
                "type": "text",
                "x": x, "y": y, "width": w, "height": h,
                "text": text_val,
                "font": {"family": font_family, "style": font_style},
                "fontSize": font_size,
                "color": fill,
                "name": nname
            })
            return
            
        if ntype == "FRAME":
            fill = get_solid_fill(node)
            cornerRadius = node.get("cornerRadius")
            
            # If the frame has fills or cornerRadius, render it as a background rect
            if fill is not None or cornerRadius is not None:
                parsed_children.append({
                    "type": "rect",
                    "x": x, "y": y, "width": w, "height": h,
                    "fill": fill or {"r": 1, "g": 1, "b": 1},
                    "cornerRadius": cornerRadius or 0,
                    "name": nname
                })
                
            for child in node.get("children", []):
                process_node(child)
                
    for child in canvas_child.get("children", []):
        process_node(child)
        
    return {
        "name": name,
        "x": screen_x, "y": screen_y,
        "width": screen_w, "height": screen_h,
        "fill": screen_fill or {"r": 0.96470588, "g": 0.96470588, "b": 0.96470588},
        "children": parsed_children
    }

for canvas_child in canvas_children:
    res = parse_screen(canvas_child)
    if res:
        parsed_screens.append(res)

# Format to custom JS output style
def format_js(obj, indent=2):
    ind = " " * indent
    if isinstance(obj, dict):
        if len(obj) == 3 and "r" in obj and "g" in obj and "b" in obj:
            return f"{{ r: {obj['r']}, g: {obj['g']}, b: {obj['b']} }}"
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

js_screens_str = "const screens = " + format_js(parsed_screens, 0) + ";\n"

# Rest of code.js helper definitions
js_rest = """
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
  node.letterSpacing = { value: 0, unit: 'PIXELS' };
  node.lineHeight = { value: item.fontSize * 1.2, unit: 'PIXELS' };
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
  node.resize(item.width, item.height);
  node.x = item.x;
  node.y = item.y;
  node.fills = [createFill(item.fill)];
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
    label.fontName = item.font || { family: 'Inter', style: 'Regular' };
    label.fontSize = item.fontSize || 16;
    label.textAlignHorizontal = 'CENTER';
    label.textAlignVertical = 'CENTER';
    label.textAutoResize = 'WIDTH_AND_HEIGHT';
    label.fills = [{ type: 'SOLID', color: rgba(item.textColor || { r: 0, g: 0, b: 0 }) }];
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
  chip.cornerRadius = 14;

  const groupChildren = [chip];
  if (item.text) {
    const label = figma.createText();
    label.characters = item.text;
    label.fontName = item.font || { family: 'Inter', style: 'Regular' };
    label.fontSize = item.fontSize || 15;
    label.textAlignHorizontal = 'CENTER';
    label.textAlignVertical = 'CENTER';
    label.textAutoResize = 'WIDTH_AND_HEIGHT';
    label.fills = [{ type: 'SOLID', color: rgba(item.textColor || { r: 0, g: 0, b: 0 }) }];
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
      font: child.font,
      fontSize: child.fontSize,
      name: child.name
    };
    let node;
    if (child.type === 'text') node = createText(childItem);
    else if (child.type === 'rect') node = createRectangle(childItem);
    else if (child.type === 'button') node = createButton(childItem);
    else if (child.type === 'chip') node = createChip(childItem);
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
  figma.closePlugin('Spotter UI plugin created the screens.');
}

main();
"""

full_code = js_screens_str + js_rest

with open(code_js_path, 'w', encoding='utf-8') as f:
    f.write(full_code)

print(f"Successfully generated code.js at: {code_js_path}")
print(f"Total parsed screens: {len(parsed_screens)}")
