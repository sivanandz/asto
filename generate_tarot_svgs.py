import os
import math

SVG_WIDTH = 700
SVG_HEIGHT = 1200
BG_COLOR = "#09090b"
PRIMARY_COLOR = "#5a805b"
TEXT_COLOR = "#fafafa"

def generate_base_svg_structure(title, number_text, inner_content):
    # Common border elements
    borders = f"""
    <rect x="25" y="25" width="{SVG_WIDTH-50}" height="{SVG_HEIGHT-50}" rx="15" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="3"/>
    <rect x="40" y="40" width="{SVG_WIDTH-80}" height="{SVG_HEIGHT-80}" rx="10" fill="none" stroke="{TEXT_COLOR}" stroke-width="1" stroke-dasharray="4,4"/>

    <!-- Corner ornaments -->
    <circle cx="50" cy="50" r="10" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="2"/>
    <circle cx="{SVG_WIDTH-50}" cy="50" r="10" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="2"/>
    <circle cx="50" cy="{SVG_HEIGHT-50}" r="10" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="2"/>
    <circle cx="{SVG_WIDTH-50}" cy="{SVG_HEIGHT-50}" r="10" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="2"/>

    <!-- Inner corner arcs -->
    <path d="M 40 80 A 40 40 0 0 1 80 40" fill="none" stroke="{TEXT_COLOR}" stroke-width="1" stroke-dasharray="2,2"/>
    <path d="M {SVG_WIDTH-80} 40 A 40 40 0 0 1 {SVG_WIDTH-40} 80" fill="none" stroke="{TEXT_COLOR}" stroke-width="1" stroke-dasharray="2,2"/>
    <path d="M 40 {SVG_HEIGHT-80} A 40 40 0 0 0 80 {SVG_HEIGHT-40}" fill="none" stroke="{TEXT_COLOR}" stroke-width="1" stroke-dasharray="2,2"/>
    <path d="M {SVG_WIDTH-80} {SVG_HEIGHT-40} A 40 40 0 0 0 {SVG_WIDTH-40} {SVG_HEIGHT-80}" fill="none" stroke="{TEXT_COLOR}" stroke-width="1" stroke-dasharray="2,2"/>
    """

    # Top and bottom stars/moons pattern
    decorations = f"""
    <g fill="{TEXT_COLOR}">
        <circle cx="{SVG_WIDTH//2}" cy="80" r="4"/>
        <path d="M {SVG_WIDTH//2 - 20} 80 A 6 6 0 1 1 {SVG_WIDTH//2 - 20} 79 Z" fill="none" stroke="{TEXT_COLOR}" stroke-width="1"/>
        <path d="M {SVG_WIDTH//2 + 20} 80 A 6 6 0 1 1 {SVG_WIDTH//2 + 20} 79 Z" fill="none" stroke="{TEXT_COLOR}" stroke-width="1"/>
        <circle cx="{SVG_WIDTH//2 - 40}" cy="80" r="2"/>
        <circle cx="{SVG_WIDTH//2 + 40}" cy="80" r="2"/>

        <circle cx="{SVG_WIDTH//2}" cy="{SVG_HEIGHT-80}" r="4"/>
        <path d="M {SVG_WIDTH//2 - 20} {SVG_HEIGHT-80} A 6 6 0 1 1 {SVG_WIDTH//2 - 20} {SVG_HEIGHT-81} Z" fill="none" stroke="{TEXT_COLOR}" stroke-width="1"/>
        <path d="M {SVG_WIDTH//2 + 20} {SVG_HEIGHT-80} A 6 6 0 1 1 {SVG_WIDTH//2 + 20} {SVG_HEIGHT-81} Z" fill="none" stroke="{TEXT_COLOR}" stroke-width="1"/>
        <circle cx="{SVG_WIDTH//2 - 40}" cy="{SVG_HEIGHT-80}" r="2"/>
        <circle cx="{SVG_WIDTH//2 + 40}" cy="{SVG_HEIGHT-80}" r="2"/>
    </g>
    """

    font_import = """
    <defs>
      <style>
        @import url('https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;600&amp;display=swap');
        text {
            font-family: 'EB Garamond', serif;
        }
      </style>
    </defs>
    """

    header_text = f"""
    <text x="{SVG_WIDTH//2}" y="140" text-anchor="middle" fill="{TEXT_COLOR}" font-size="32" font-weight="600" letter-spacing="4">{number_text}</text>
    <text x="{SVG_WIDTH//2}" y="{SVG_HEIGHT-120}" text-anchor="middle" fill="{PRIMARY_COLOR}" font-size="42" font-weight="600" letter-spacing="6">{title}</text>
    """

    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {SVG_WIDTH} {SVG_HEIGHT}" width="100%" height="100%">
    {font_import}
    <rect width="{SVG_WIDTH}" height="{SVG_HEIGHT}" fill="{BG_COLOR}"/>
    {borders}
    {decorations}
    {header_text}
    <g transform="translate(0, 150)">
        {inner_content}
    </g>
</svg>"""

def get_star(cx, cy, size, color=TEXT_COLOR):
    return f"""<path d="M {cx} {cy-size} Q {cx} {cy} {cx+size} {cy} Q {cx} {cy} {cx} {cy+size} Q {cx} {cy} {cx-size} {cy} Q {cx} {cy} {cx} {cy-size} Z" fill="{color}"/>"""

def get_planet(cx, cy, r, angle, color=TEXT_COLOR):
    return f"""
    <g transform="translate({cx}, {cy}) rotate({angle})">
        <circle cx="0" cy="0" r="{r}" fill="none" stroke="{color}" stroke-width="2"/>
        <ellipse cx="0" cy="0" rx="{r*1.8}" ry="{r*0.4}" fill="none" stroke="{color}" stroke-width="1" stroke-dasharray="3,3"/>
        <circle cx="{r*1.8}" cy="0" r="{r*0.2}" fill="{color}"/>
    </g>
    """

def get_moon(cx, cy, r, color=TEXT_COLOR):
    return f"""
    <path d="M {cx-r*0.2} {cy-r} A {r} {r} 0 1 0 {cx-r*0.2} {cy+r} A {r*0.8} {r*0.8} 0 1 1 {cx-r*0.2} {cy-r} Z" fill="none" stroke="{color}" stroke-width="2"/>
    <circle cx="{cx+r*0.3}" cy="{cy}" r="{r*0.1}" fill="{color}"/>
    <circle cx="{cx+r*0.6}" cy="{cy-r*0.3}" r="{r*0.05}" fill="{color}"/>
    <circle cx="{cx+r*0.6}" cy="{cy+r*0.3}" r="{r*0.05}" fill="{color}"/>
    """

def get_eye(cx, cy, w, h, color=TEXT_COLOR):
    return f"""
    <path d="M {cx-w} {cy} Q {cx} {cy-h} {cx+w} {cy} Q {cx} {cy+h} {cx-w} {cy} Z" fill="none" stroke="{color}" stroke-width="2"/>
    <circle cx="{cx}" cy="{cy}" r="{h*0.5}" fill="none" stroke="{color}" stroke-width="2"/>
    <circle cx="{cx}" cy="{cy}" r="{h*0.2}" fill="{color}"/>
    """

def get_sun(cx, cy, r, rays, color=TEXT_COLOR):
    ray_paths = ""
    for i in range(rays):
        angle = (i * 360 / rays) * (math.pi / 180)
        x1 = cx + r * 1.2 * math.cos(angle)
        y1 = cy + r * 1.2 * math.sin(angle)
        x2 = cx + r * 2.0 * math.cos(angle)
        y2 = cy + r * 2.0 * math.sin(angle)
        if i % 2 == 0:
            ray_paths += f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{color}" stroke-width="2"/>'
        else:
            ray_paths += f'<path d="M {x1} {y1} L {cx + r*1.6*math.cos(angle - 0.1)} {cy + r*1.6*math.sin(angle - 0.1)} L {x2} {y2} L {cx + r*1.6*math.cos(angle + 0.1)} {cy + r*1.6*math.sin(angle + 0.1)} Z" fill="none" stroke="{color}" stroke-width="1"/>'
    return f"""
    <circle cx="{cx}" cy="{cy}" r="{r}" fill="none" stroke="{color}" stroke-width="2"/>
    <circle cx="{cx}" cy="{cy}" r="{r*0.8}" fill="none" stroke="{color}" stroke-width="1" stroke-dasharray="4,4"/>
    {ray_paths}
    """

def get_suit_wand(cx, cy, scale=1.0):
    return f"""
    <g transform="translate({cx}, {cy}) scale({scale})">
        <line x1="0" y1="-50" x2="0" y2="50" stroke="{PRIMARY_COLOR}" stroke-width="6" stroke-linecap="round"/>
        <line x1="-10" y1="-30" x2="10" y2="-40" stroke="{TEXT_COLOR}" stroke-width="2" stroke-linecap="round"/>
        <line x1="-10" y1="10" x2="10" y2="0" stroke="{TEXT_COLOR}" stroke-width="2" stroke-linecap="round"/>
        <circle cx="0" cy="-55" r="4" fill="{TEXT_COLOR}"/>
        <circle cx="0" cy="55" r="4" fill="{TEXT_COLOR}"/>
    </g>
    """

def get_suit_cup(cx, cy, scale=1.0):
    return f"""
    <g transform="translate({cx}, {cy}) scale({scale})">
        <path d="M -25 -20 C -25 15, -10 30, 0 30 C 10 30, 25 15, 25 -20 Z" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>
        <line x1="0" y1="30" x2="0" y2="50" stroke="{PRIMARY_COLOR}" stroke-width="4"/>
        <line x1="-15" y1="50" x2="15" y2="50" stroke="{PRIMARY_COLOR}" stroke-width="4" stroke-linecap="round"/>
        <path d="M -30 -20 Q 0 -10 30 -20" fill="none" stroke="{TEXT_COLOR}" stroke-width="2"/>
    </g>
    """

def get_suit_sword(cx, cy, scale=1.0):
    return f"""
    <g transform="translate({cx}, {cy}) scale({scale})">
        <path d="M 0 -60 L 5 -50 L 5 20 L -5 20 L -5 -50 Z" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="3"/>
        <line x1="0" y1="-60" x2="0" y2="20" stroke="{TEXT_COLOR}" stroke-width="1"/>
        <line x1="-20" y1="20" x2="20" y2="20" stroke="{PRIMARY_COLOR}" stroke-width="4" stroke-linecap="round"/>
        <line x1="0" y1="20" x2="0" y2="40" stroke="{PRIMARY_COLOR}" stroke-width="4"/>
        <circle cx="0" cy="45" r="5" fill="{TEXT_COLOR}"/>
    </g>
    """

def get_suit_pentacle(cx, cy, scale=1.0):
    return f"""
    <g transform="translate({cx}, {cy}) scale({scale})">
        <circle cx="0" cy="0" r="30" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>
        <circle cx="0" cy="0" r="24" fill="none" stroke="{TEXT_COLOR}" stroke-width="1" stroke-dasharray="2,2"/>
        <path d="M 0 -18 L 17 5 L -14 -8 L 14 -8 L -17 5 Z" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="2"/>
    </g>
    """

major_arcana = [
    (0, "THE FOOL"), (1, "THE MAGICIAN"), (2, "THE HIGH PRIESTESS"), (3, "THE EMPRESS"),
    (4, "THE EMPEROR"), (5, "THE HIEROPHANT"), (6, "THE LOVERS"), (7, "THE CHARIOT"),
    (8, "STRENGTH"), (9, "THE HERMIT"), (10, "WHEEL OF FORTUNE"), (11, "JUSTICE"),
    (12, "THE HANGED MAN"), (13, "DEATH"), (14, "TEMPERANCE"), (15, "THE DEVIL"),
    (16, "THE TOWER"), (17, "THE STAR"), (18, "THE MOON"), (19, "THE SUN"),
    (20, "JUDGEMENT"), (21, "THE WORLD")
]

def to_roman(num):
    if num == 0: return "0"
    val = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    syb = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
    roman_num = ''
    i = 0
    while  num > 0:
        for _ in range(num // val[i]):
            roman_num += syb[i]
            num -= val[i]
        i += 1
    return roman_num

def generate_major_arcana(card_num, title):
    roman = to_roman(card_num)
    cx, cy = SVG_WIDTH//2, 380
    content = ""

    if card_num == 0:
        content += get_star(cx, cy, 60, PRIMARY_COLOR)
        content += get_planet(cx-80, cy+100, 20, 15)
        content += get_star(cx+80, cy-120, 20)
    elif card_num == 1:
        content += f'<path d="M {cx-40} {cy-60} L {cx+40} {cy-60} L {cx+40} {cy+60} L {cx-40} {cy+60} Z" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>'
        content += f'<circle cx="{cx}" cy="{cy}" r="30" fill="none" stroke="{TEXT_COLOR}" stroke-width="2"/>'
        content += f'<path d="M {cx-30} {cy} L {cx+30} {cy}" stroke="{TEXT_COLOR}" stroke-width="2"/>'
        content += f'<path d="M {cx} {cy-30} L {cx} {cy+30}" stroke="{TEXT_COLOR}" stroke-width="2"/>'
    elif card_num == 2:
        content += get_moon(cx, cy-40, 60, PRIMARY_COLOR)
        content += f'<line x1="{cx-80}" y1="{cy-80}" x2="{cx-80}" y2="{cy+180}" stroke="{TEXT_COLOR}" stroke-width="8"/>'
        content += f'<line x1="{cx+80}" y1="{cy-80}" x2="{cx+80}" y2="{cy+180}" stroke="{TEXT_COLOR}" stroke-width="8"/>'
    elif card_num == 3:
        content += f'<path d="M {cx} {cy-80} L {cx+70} {cy+40} L {cx-70} {cy+40} Z" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>'
        content += f'<circle cx="{cx}" cy="{cy+80}" r="25" fill="none" stroke="{TEXT_COLOR}" stroke-width="3"/>'
        content += f'<line x1="{cx}" y1="{cy+105}" x2="{cx}" y2="{cy+135}" stroke="{TEXT_COLOR}" stroke-width="3"/>'
        content += f'<line x1="{cx-15}" y1="{cy+120}" x2="{cx+15}" y2="{cy+120}" stroke="{TEXT_COLOR}" stroke-width="3"/>'
    elif card_num == 4:
        content += f'<rect x="{cx-60}" y="{cy-80}" width="120" height="120" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>'
        content += f'<path d="M {cx-60} {cy-80} L {cx} {cy-140} L {cx+60} {cy-80}" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>'
        content += get_eye(cx, cy-20, 30, 20)
    elif card_num == 10:
        content += f'<circle cx="{cx}" cy="{cy}" r="90" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="6"/>'
        content += f'<circle cx="{cx}" cy="{cy}" r="70" fill="none" stroke="{TEXT_COLOR}" stroke-width="2"/>'
        content += f'<circle cx="{cx}" cy="{cy}" r="30" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>'
        for i in range(8):
            angle = i * 45 * math.pi / 180
            content += f'<line x1="{cx + 30*math.cos(angle)}" y1="{cy + 30*math.sin(angle)}" x2="{cx + 70*math.cos(angle)}" y2="{cy + 70*math.sin(angle)}" stroke="{TEXT_COLOR}" stroke-width="2"/>'
    elif card_num == 13:
        content += f'<path d="M {cx} {cy-80} C {cx+60} {cy-80}, {cx+60} {cy}, {cx} {cy+60} C {cx-60} {cy}, {cx-60} {cy-80}, {cx} {cy-80} Z" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>'
        content += f'<line x1="{cx-80}" y1="{cy+100}" x2="{cx+80}" y2="{cy-20}" stroke="{TEXT_COLOR}" stroke-width="4"/>'
    elif card_num == 16:
        content += f'<rect x="{cx-40}" y="{cy-40}" width="80" height="160" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>'
        content += f'<path d="M {cx-50} {cy-40} L {cx-30} {cy-80} L {cx-10} {cy-40} L {cx+10} {cy-80} L {cx+30} {cy-40} L {cx+50} {cy-40} Z" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="4"/>'
        content += f'<path d="M {cx-80} {cy-120} L {cx} {cy-60} L {cx+20} {cy-100} L {cx+40} {cy-40}" fill="none" stroke="{TEXT_COLOR}" stroke-width="3"/>'
    elif card_num == 17:
        content += get_star(cx, cy, 80, PRIMARY_COLOR)
        content += get_star(cx-70, cy-70, 20)
        content += get_star(cx+70, cy-40, 30)
        content += get_star(cx-50, cy+80, 25)
        content += get_star(cx+60, cy+70, 15)
        content += get_star(cx, cy+110, 20)
        content += get_star(cx-90, cy+10, 15)
        content += get_star(cx+90, cy-100, 20)
    elif card_num == 18:
        content += get_moon(cx, cy, 80, PRIMARY_COLOR)
        content += f'<path d="M {cx-100} {cy+120} C {cx-50} {cy+80}, {cx+50} {cy+160}, {cx+100} {cy+120}" fill="none" stroke="{TEXT_COLOR}" stroke-width="2"/>'
        content += f'<path d="M {cx-120} {cy+150} C {cx-60} {cy+110}, {cx+60} {cy+190}, {cx+120} {cy+150}" fill="none" stroke="{TEXT_COLOR}" stroke-width="2"/>'
        content += get_star(cx, cy-120, 20)
    elif card_num == 19:
        content += get_sun(cx, cy, 60, 16, PRIMARY_COLOR)
    elif card_num == 21:
        content += f'<ellipse cx="{cx}" cy="{cy}" rx="70" ry="120" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="6"/>'
        content += f'<ellipse cx="{cx}" cy="{cy}" rx="50" ry="100" fill="none" stroke="{TEXT_COLOR}" stroke-width="2" stroke-dasharray="4,4"/>'
        content += f'<circle cx="{cx}" cy="{cy}" r="20" fill="none" stroke="{TEXT_COLOR}" stroke-width="3"/>'
        content += get_star(cx-100, cy-140, 20)
        content += get_star(cx+100, cy-140, 20)
        content += get_star(cx-100, cy+140, 20)
        content += get_star(cx+100, cy+140, 20)
    else:
        content += f'<path d="M {cx} {cy-100} L {cx+80} {cy+60} L {cx-80} {cy+60} Z" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="3"/>'
        content += f'<path d="M {cx} {cy+100} L {cx+80} {cy-60} L {cx-80} {cy-60} Z" fill="none" stroke="{PRIMARY_COLOR}" stroke-width="3"/>'
        content += get_eye(cx, cy, 40, 25, TEXT_COLOR)
        content += get_star(cx-100, cy-100, 15)
        content += get_star(cx+100, cy+100, 15)

    return generate_base_svg_structure(title, roman, content)

suits = ["WANDS", "CUPS", "SWORDS", "PENTACLES"]

def get_suit_element(suit, cx, cy, scale=1.0):
    if suit == "WANDS": return get_suit_wand(cx, cy, scale)
    if suit == "CUPS": return get_suit_cup(cx, cy, scale)
    if suit == "SWORDS": return get_suit_sword(cx, cy, scale)
    if suit == "PENTACLES": return get_suit_pentacle(cx, cy, scale)
    return ""

def generate_minor_arcana(suit, num):
    roman_num = to_roman(num) if num <= 10 else ""
    if num == 1: roman_num = "ACE"
    if num == 11: roman_num = "PAGE"
    if num == 12: roman_num = "KNIGHT"
    if num == 13: roman_num = "QUEEN"
    if num == 14: roman_num = "KING"

    cx, cy = SVG_WIDTH//2, 380
    content = ""

    if num <= 10:
        positions = []
        if num == 1: positions = [(cx, cy)]
        elif num == 2: positions = [(cx, cy-80), (cx, cy+80)]
        elif num == 3: positions = [(cx, cy-100), (cx-60, cy+60), (cx+60, cy+60)]
        elif num == 4: positions = [(cx-60, cy-80), (cx+60, cy-80), (cx-60, cy+80), (cx+60, cy+80)]
        elif num == 5: positions = [(cx-60, cy-80), (cx+60, cy-80), (cx, cy), (cx-60, cy+80), (cx+60, cy+80)]
        elif num == 6: positions = [(cx-60, cy-100), (cx+60, cy-100), (cx-60, cy), (cx+60, cy), (cx-60, cy+100), (cx+60, cy+100)]
        elif num == 7: positions = [(cx-60, cy-100), (cx+60, cy-100), (cx, cy-30), (cx-60, cy+40), (cx+60, cy+40), (cx-60, cy+120), (cx+60, cy+120)]
        elif num == 8: positions = [(cx-60, cy-120), (cx+60, cy-120), (cx-60, cy-40), (cx+60, cy-40), (cx-60, cy+40), (cx+60, cy+40), (cx-60, cy+120), (cx+60, cy+120)]
        elif num == 9: positions = [(cx-60, cy-120), (cx+60, cy-120), (cx-60, cy-40), (cx+60, cy-40), (cx, cy), (cx-60, cy+40), (cx+60, cy+40), (cx-60, cy+120), (cx+60, cy+120)]
        elif num == 10: positions = [(cx-60, cy-150), (cx+60, cy-150), (cx, cy-100), (cx-60, cy-50), (cx+60, cy-50), (cx-60, cy+50), (cx+60, cy+50), (cx, cy+100), (cx-60, cy+150), (cx+60, cy+150)]

        for px, py in positions:
            content += get_suit_element(suit, px, py, 0.8)
    else:
        content += get_suit_element(suit, cx, cy, 1.2)
        if num == 11:
            content += get_star(cx, cy-100, 25, TEXT_COLOR)
        elif num == 12:
            content += f'<path d="M {cx} {cy-140} L {cx+30} {cy-90} L {cx} {cy-40} L {cx-30} {cy-90} Z" fill="none" stroke="{TEXT_COLOR}" stroke-width="3"/>'
        elif num == 13:
            content += f'<path d="M {cx-60} {cy-90} Q {cx} {cy-50} {cx+60} {cy-90} Q {cx} {cy-130} {cx-60} {cy-90} Z" fill="none" stroke="{TEXT_COLOR}" stroke-width="3"/>'
            content += f'<circle cx="{cx}" cy="{cy-110}" r="10" fill="{TEXT_COLOR}"/>'
        elif num == 14:
            content += f'<rect x="{cx-40}" y="{cy-130}" width="80" height="40" fill="none" stroke="{TEXT_COLOR}" stroke-width="3"/>'
            content += f'<path d="M {cx-40} {cy-130} L {cx-40} {cy-160} L {cx-20} {cy-130} L {cx} {cy-170} L {cx+20} {cy-130} L {cx+40} {cy-160} L {cx+40} {cy-130}" fill="none" stroke="{TEXT_COLOR}" stroke-width="3"/>'

    content += get_star(cx-120, cy-180, 10)
    content += get_star(cx+130, cy-120, 15)
    content += get_star(cx-140, cy+140, 12)
    content += get_star(cx+120, cy+180, 8)

    full_title = f"{roman_num} OF {suit}" if num > 1 else f"ACE OF {suit}"
    return generate_base_svg_structure(full_title, roman_num, content)

def main():
    out_dir = "assets/tarot_cards"
    if not os.path.exists(out_dir):
        os.makedirs(out_dir)

    for card_num, title in major_arcana:
        svg_content = generate_major_arcana(card_num, title)
        filename = f"major_{card_num:02d}_{title.lower().replace(' ', '_')}.svg"
        with open(os.path.join(out_dir, filename), "w") as f:
            f.write(svg_content)
        print(f"Generated {filename}")

    for suit in suits:
        for num in range(1, 15):
            if num == 1: name = "ace"
            elif num == 11: name = "page"
            elif num == 12: name = "knight"
            elif num == 13: name = "queen"
            elif num == 14: name = "king"
            else: name = f"{num:02d}"

            svg_content = generate_minor_arcana(suit, num)
            filename = f"minor_{suit.lower()}_{name}.svg"
            with open(os.path.join(out_dir, filename), "w") as f:
                f.write(svg_content)
            print(f"Generated {filename}")

if __name__ == "__main__":
    main()
