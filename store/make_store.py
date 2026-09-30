"""Builds the Google Play graphic assets for Budgie.

Everything is derived from two things: the app's own launcher icon (which sets
the purple gradient) and real screenshots taken on the emulator. No stock art,
no invented UI — what is on the store is what the app actually looks like.
"""

import os
from PIL import Image, ImageDraw, ImageFilter, ImageFont

HERE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "screens")
PROJ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "play")
os.makedirs(OUT, exist_ok=True)

FONTS = "C:/flutter/bin/cache/artifacts/material_fonts"


def font(weight, size):
    return ImageFont.truetype(os.path.join(FONTS, f"roboto-{weight}.ttf"), size)


# Straight from assets/icon/icon.png.
DEEP = (0x3A, 0x1F, 0xB0)
MID = (0x63, 0x46, 0xE7)
LIGHT = (0x8E, 0x74, 0xFF)
INK = (0xFF, 0xFF, 0xFF)


def gradient(size, c1, c2):
    """Diagonal two-stop gradient, drawn small then scaled — fast and smooth."""
    w, h = size
    small = Image.new("RGB", (64, 64))
    px = small.load()
    for y in range(64):
        for x in range(64):
            t = (x + y) / 126
            px[x, y] = tuple(round(a + (b - a) * t) for a, b in zip(c1, c2))
    return small.resize((w, h), Image.BICUBIC)


def glow(img, center, radius, color, alpha):
    """Soft radial light, to keep large flat gradients from looking dead."""
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    cx, cy = center
    d.ellipse(
        [cx - radius, cy - radius, cx + radius, cy + radius],
        fill=color + (alpha,),
    )
    layer = layer.filter(ImageFilter.GaussianBlur(radius * 0.55))
    img.alpha_composite(layer)


def rounded_mask(size, radius):
    m = Image.new("L", size, 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius, 255)
    return m


def phone(shot_path, width):
    """The screenshot inside a simple dark device body."""
    shot = Image.open(shot_path).convert("RGB")
    ratio = shot.height / shot.width
    bezel = max(4, round(width * 0.022))
    inner_w = width - bezel * 2
    inner_h = round(inner_w * ratio)
    outer_h = inner_h + bezel * 2

    body = Image.new("RGBA", (width, outer_h), (0, 0, 0, 0))
    r_out = round(width * 0.115)
    ImageDraw.Draw(body).rounded_rectangle(
        [0, 0, width - 1, outer_h - 1], r_out, fill=(0x14, 0x11, 0x24, 255)
    )

    screen = shot.resize((inner_w, inner_h), Image.LANCZOS).convert("RGBA")
    screen.putalpha(rounded_mask((inner_w, inner_h), max(2, r_out - bezel)))
    body.alpha_composite(screen, (bezel, bezel))
    return body


def drop(canvas, sprite, pos, blur=34, dy=18, alpha=110):
    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    solid = Image.new("RGBA", sprite.size, (0, 0, 0, alpha))
    shadow.paste(solid, (pos[0], pos[1] + dy), sprite)
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(blur)))
    canvas.alpha_composite(sprite, pos)


def text(draw, xy, lines, f, fill=INK, leading=1.18, anchor="la"):
    x, y = xy
    step = round(f.size * leading)
    for i, line in enumerate(lines):
        draw.text((x, y + i * step), line, font=f, fill=fill, anchor=anchor)
    return y + len(lines) * step


def backdrop(size):
    img = gradient(size, DEEP, LIGHT).convert("RGBA")
    w, h = size
    glow(img, (w * 0.18, h * 0.12), w * 0.42, (0xB0, 0x9A, 0xFF), 70)
    glow(img, (w * 0.92, h * 0.85), w * 0.38, (0x2A, 0x12, 0x8A), 90)
    return img


def overlay(img):
    """A transparent layer to draw on.

    Drawing a translucent fill straight onto an RGBA image *replaces* its alpha
    instead of blending — flat white boxes where a 15 % tint was intended.
    Everything translucent goes on this layer and gets composited.
    """
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    return layer, ImageDraw.Draw(layer)


def pill(draw, xy, label, f, pad=(26, 13)):
    x, y = xy
    tw = draw.textlength(label, font=f)
    box = [x, y, x + tw + pad[0] * 2, y + f.size + pad[1] * 2]
    draw.rounded_rectangle(box, (box[3] - box[1]) / 2, fill=(255, 255, 255, 38))
    draw.text((x + pad[0], y + pad[1]), label, font=f, fill=(255, 255, 255, 235))
    return box[2]


# ── 1. Feature graphic — 1024 x 500 ───────────────────────────────────────
def feature_graphic():
    W, H = 1024, 500
    img = backdrop((W, H))
    ov, d = overlay(img)

    icon = Image.open(os.path.join(PROJ, "assets/icon/icon.png")).convert("RGBA")
    icon = icon.resize((92, 92), Image.LANCZOS)
    drop(img, icon, (64, 62), blur=22, dy=10, alpha=90)

    d.text((174, 78), "Budgie", font=font("black", 58), fill=INK)
    d.text(
        (174, 146),
        "Budget personnel",
        font=font("medium", 25),
        fill=(255, 255, 255, 205),
    )

    text(
        d,
        (64, 232),
        ["Tu sais toujours combien", "il te reste à dépenser."],
        font("bold", 46),
        leading=1.22,
    )

    x = pill(d, (64, 386), "Données locales", font("medium", 22))
    x = pill(d, (x + 14, 386), "Sans compte", font("medium", 22))
    pill(d, (x + 14, 386), "Sans pub", font("medium", 22))
    img.alpha_composite(ov)

    dev = phone(os.path.join(HERE, "shot_accueil.png"), 268)
    drop(img, dev, (700, 46), blur=40, dy=24, alpha=120)

    img.convert("RGB").save(os.path.join(OUT, "feature-graphic-1024x500.png"))
    print("feature-graphic-1024x500.png")


# ── 2. Phone screenshots — 1080 x 1920 ────────────────────────────────────
SLIDES = [
    ("shot_accueil.png", ["Combien il te reste.", "Tout de suite."],
     "Un anneau, un chiffre : ce que tu peux encore dépenser."),
    ("shot_abos.png", ["Tes abonnements,", "en deux taps."],
     "Netflix, Spotify, Claude… la date et le montant, c'est tout."),
    ("shot_recap.png", ["Ton mois entier,", "dès la première minute."],
     "Le parcours d'accueil construit ton budget avec toi."),
    ("shot_budgets.png", ["Des plafonds qui", "te préviennent."],
     "Enveloppes, charges fixes, échéances à payer."),
    ("shot_saisie.png", ["Noter une dépense :", "trois secondes."],
     "Montant, catégorie, terminé. Ou scanne le ticket."),
    ("shot_transactions.png", ["Chaque dépense", "à sa place."],
     "Groupées par jour, avec recherche et filtres."),
    ("shot_stats.png", ["Vois où part", "vraiment ton argent."],
     "Répartition par catégorie, mois après mois."),
]


def slides():
    W, H = 1080, 1920
    for i, (shot, head, sub) in enumerate(SLIDES, start=1):
        img = backdrop((W, H))
        ov, d = overlay(img)

        y = text(d, (78, 132), head, font("black", 74), leading=1.16)
        d.text((78, y + 26), sub, font=font("regular", 33), fill=(255, 255, 255, 210))
        img.alpha_composite(ov)

        dev = phone(os.path.join(HERE, shot), 700)
        drop(img, dev, ((W - 700) // 2, 500), blur=48, dy=30, alpha=125)

        name = f"screenshot-{i}-{os.path.splitext(shot)[0].replace('shot_', '')}.png"
        img.convert("RGB").save(os.path.join(OUT, name))
        print(name)


# ── 3. Tablet screenshots — 16:9 landscape ────────────────────────────────
# Play wants 16:9 or 9:16 for tablets. Reusing the portrait phone slides is
# accepted but leaves a lone narrow phone in a wide frame, so these are laid
# out for the shape: copy on the left, two screens on the right.
TABLETS = [
    (
        ["Tu sais toujours combien", "il te reste à dépenser."],
        "Un anneau, un chiffre, et le détail juste en dessous.",
        ("shot_accueil.png", "shot_transactions.png"),
    ),
    (
        ["Ton mois entier,", "dès la première minute."],
        "Abonnements, charges fixes, budgets : le parcours d'accueil construit tout avec toi.",
        ("shot_abos.png", "shot_recap.png"),
    ),
    (
        ["Des plafonds qui", "te préviennent."],
        "Enveloppes, échéances à payer, et où part vraiment ton argent.",
        ("shot_budgets.png", "shot_stats.png"),
    ),
    (
        ["Noter une dépense :", "trois secondes."],
        "Montant, catégorie, terminé. Ou scanne le ticket.",
        ("shot_saisie.png", "shot_accueil.png"),
    ),
]


def tablets():
    W, H = 2560, 1440  # 16:9, the 10-inch size; the 7-inch is this, downscaled
    for i, (head, sub, (a, b)) in enumerate(TABLETS, start=1):
        img = backdrop((W, H))

        icon = Image.open(os.path.join(PROJ, "assets/icon/icon.png")).convert("RGBA")
        icon = icon.resize((104, 104), Image.LANCZOS)
        drop(img, icon, (140, 128), blur=24, dy=12, alpha=90)

        ov, d = overlay(img)
        d.text((272, 146), "Budgie", font=font("black", 64), fill=INK)

        y = text(d, (140, 430), head, font("black", 96), leading=1.18)
        text(
            d,
            (140, y + 42),
            wrap(sub, font("regular", 44), 1120),
            font("regular", 44),
            fill=(255, 255, 255, 210),
            leading=1.34,
        )
        img.alpha_composite(ov)

        # Back one first so the front one overlaps it.
        back = phone(os.path.join(HERE, b), 470)
        drop(img, back, (1930, 430), blur=52, dy=32, alpha=125)
        front = phone(os.path.join(HERE, a), 540)
        drop(img, front, (1420, 300), blur=52, dy=32, alpha=140)

        stem = f"{i}-{os.path.splitext(a)[0].replace('shot_', '')}"
        rgb = img.convert("RGB")
        rgb.save(os.path.join(OUT, f"tablet10-{stem}-2560x1440.png"))
        rgb.resize((1920, 1080), Image.LANCZOS).save(
            os.path.join(OUT, f"tablet7-{stem}-1920x1080.png")
        )
        print(f"tablet10-{stem}-2560x1440.png + tablet7-{stem}-1920x1080.png")


def wrap(sentence, f, max_width):
    """Greedy word wrap — the copy is short, nothing smarter is warranted."""
    probe = ImageDraw.Draw(Image.new("RGB", (1, 1)))
    lines, current = [], ""
    for word in sentence.split():
        trial = f"{current} {word}".strip()
        if probe.textlength(trial, font=f) <= max_width:
            current = trial
        else:
            lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines


# ── 4. Play store icon — 512 x 512 ────────────────────────────────────────
def store_icon():
    icon = Image.open(os.path.join(PROJ, "assets/icon/icon.png")).convert("RGBA")
    icon.resize((512, 512), Image.LANCZOS).save(
        os.path.join(OUT, "icon-512x512.png")
    )
    print("icon-512x512.png")


if __name__ == "__main__":
    feature_graphic()
    slides()
    tablets()
    store_icon()
