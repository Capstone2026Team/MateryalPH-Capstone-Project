"""Generates the drawn demo imagery for the capstone demo vendors: store logos and SAMPLE verification documents.

Reads services/api/database/demo-assets/vendors.json and writes, next to it:
  vendors/<slug>/{logo.png, doc-registration.jpg, doc-lgu-permit.jpg, doc-bir-cor.jpg, doc-identity.jpg}

Product, banner and vehicle photos come from tools/demo-assets/fetch_demo_photos.py instead. Documents are
obviously labelled SAMPLE images, never copies of government records. Run from the repository root:

    py tools/demo-assets/generate_demo_vendor_assets.py
"""
from __future__ import annotations

import json
import random
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[2] / "services" / "api" / "database" / "demo-assets"
FONT_DIR = Path("C:/Windows/Fonts")
SS = 2  # supersampling factor for the logo canvas


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    for name in (("segoeuib.ttf", "arialbd.ttf") if bold else ("segoeui.ttf", "arial.ttf")):
        try:
            return ImageFont.truetype(str(FONT_DIR / name), size)
        except OSError:
            continue
    return ImageFont.load_default()


def rgb(hex_color: str) -> tuple[int, int, int]:
    h = hex_color.lstrip("#")
    return int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)


def shade(color: str | tuple, factor: float) -> tuple[int, int, int]:
    r, g, b = rgb(color) if isinstance(color, str) else color
    if factor >= 0:
        return tuple(int(c + (255 - c) * factor) for c in (r, g, b))  # type: ignore[return-value]
    return tuple(int(c * (1 + factor)) for c in (r, g, b))  # type: ignore[return-value]


def luminance(color: str) -> float:
    r, g, b = rgb(color)
    return 0.299 * r + 0.587 * g + 0.114 * b


def text_center(d: ImageDraw.ImageDraw, xy: tuple[float, float], text: str, fnt: ImageFont.FreeTypeFont, fill) -> None:
    d.text(xy, text, font=fnt, fill=fill, anchor="mm")


def initials(name: str) -> str:
    words = [w for w in name.replace("&", " ").split() if w[0].isalpha() and w.lower() not in {"and", "the", "of"}]
    return (words[0][0] + words[1][0]).upper() if len(words) > 1 else name[:2].upper()


def logo_image(vendor: dict, out: Path) -> None:
    primary, soft = vendor["colors"]
    s = 512 * SS
    img = Image.new("RGB", (s, s), shade(soft, 0.35))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([40, 40, s - 40, s - 40], radius=220, fill=primary)
    d.rounded_rectangle([40, s // 2 + 60, s - 40, s - 40], radius=220, fill=shade(primary, -0.18))
    d.rectangle([40, s // 2 + 60, s - 40, s // 2 + 300], fill=shade(primary, -0.18))
    d.rounded_rectangle([40, 40, s - 40, s - 40], radius=220, outline=shade(soft, 0.2), width=14)
    fg = (255, 255, 255) if luminance(primary) < 170 else (30, 30, 30)
    text_center(d, (s / 2, s / 2 - 40), initials(vendor["store_name"]), font(420, True), fg)
    d.rounded_rectangle([s / 2 - 260, s - 330, s / 2 + 260, s - 306], radius=12, fill=soft)
    img = img.resize((512, 512), Image.LANCZOS)
    out.parent.mkdir(parents=True, exist_ok=True)
    img.save(out, "PNG", optimize=True)


def document_image(vendor: dict, title: str, fields: list[tuple[str, str]], out: Path) -> None:
    w, h = 1000, 1400
    img = Image.new("RGB", (w, h), (252, 251, 247))
    d = ImageDraw.Draw(img)
    d.rectangle([30, 30, w - 30, h - 30], outline=(120, 124, 132), width=4)
    d.rectangle([60, 60, w - 60, 200], fill=(232, 235, 240))
    text_center(d, (w / 2, 110), title.upper(), font(46, True), (50, 56, 70))
    text_center(d, (w / 2, 165), "SAMPLE DOCUMENT - FICTIONAL, NOT A GOVERNMENT RECORD", font(24, True), (170, 60, 60))
    y = 270
    for label, value in fields:
        d.text((90, y), label.upper(), font=font(24, True), fill=(120, 124, 132))
        d.text((90, y + 34), value, font=font(36), fill=(30, 34, 44))
        d.line([(90, y + 88), (w - 90, y + 88)], fill=(218, 220, 226), width=2)
        y += 126
    rnd = random.Random(sum(map(ord, vendor["slug"] + title)))
    for i in range(7):
        d.rectangle([90, y + 30 + i * 34, 90 + rnd.randint(380, 800), y + 44 + i * 34], fill=(226, 228, 234))
    d.ellipse([w - 330, h - 380, w - 110, h - 160], outline=(190, 60, 60), width=6)
    text_center(d, (w - 220, h - 270), "DEMO", font(70, True), (190, 60, 60))
    layer = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    text_center(ld, (w / 2, h / 2), "SAMPLE - DEMO ONLY", font(130, True), (190, 60, 60, 46))
    layer = layer.rotate(32, resample=Image.BICUBIC)
    img.paste(layer, (0, 0), layer)
    out.parent.mkdir(parents=True, exist_ok=True)
    img.save(out, "JPEG", quality=84, optimize=True)


def main() -> int:
    data = json.loads((ROOT / "vendors.json").read_text(encoding="utf-8"))
    for vendor in data["vendors"]:
        base = ROOT / "vendors" / vendor["slug"]
        owner = vendor["owner"]
        logo_image(vendor, base / "logo.png")
        document_image(vendor, "Business Name Registration", [("Business name", vendor["store_name"]), ("Registered owner", owner), ("Business address", vendor["address"]["street"] + ", " + vendor["address"]["city"]), ("Registration no.", f"DEMO-DTI-{vendor['n']:04d}")], base / "doc-registration.jpg")
        document_image(vendor, "Mayor's Business Permit", [("Business name", vendor["store_name"]), ("Permit holder", owner), ("Location", vendor["address"]["city"]), ("Permit no.", f"DEMO-LGU-{vendor['n']:04d}")], base / "doc-lgu-permit.jpg")
        document_image(vendor, "Certificate of Registration", [("Registered name", owner), ("Trade name", vendor["store_name"]), ("Taxpayer no.", f"000-000-{vendor['n']:03d}-000"), ("Registration no.", f"DEMO-BIR-{vendor['n']:04d}")], base / "doc-bir-cor.jpg")
        document_image(vendor, "Identification Card", [("Full name", owner), ("ID number", f"DEMO-ID-{vendor['n']:06d}"), ("Issued", "2025-01-15"), ("Valid until", "2030-01-15")], base / "doc-identity.jpg")
        print(f"{vendor['slug']}: ok", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
