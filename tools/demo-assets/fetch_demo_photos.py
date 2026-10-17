"""Downloads and normalizes the demo marketplace photos listed in services/api/database/demo-assets/photo-sources.json.

Product photos are manufacturer/retailer images of real Philippine-market products; banners, vehicles and a few
commodity photos are openly licensed (Wikimedia Commons / Openverse) and carry their credit and license in the
manifest. None of these files are committed: they are written to the git-ignored folder

  services/api/database/demo-assets/photos/
    products/<slug>/<SKU>-<n>.jpg   (square, 1200 px, padded with the photo's own background)
    vendors/<slug>/banner.jpg       (1600 x 500)
    vendors/<slug>/vehicle.jpg      (1200 x 800)

Re-running skips files that already exist; pass --force to rebuild them. Run from the repository root:

    py tools/demo-assets/fetch_demo_photos.py
"""
from __future__ import annotations

import io
import json
import sys
import time
import urllib.request
from pathlib import Path
from statistics import median

from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parents[2] / "services" / "api" / "database" / "demo-assets"
OUT = ROOT / "photos"
# Wikimedia asks for a descriptive agent; retail CDNs accept it as well.
AGENT = "MateryalPH-capstone-demo-photo-fetch/1.0 (academic demonstration; https://meta.wikimedia.org/wiki/User-Agent_policy)"
BROWSER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"


def download(url: str) -> bytes:
    last: Exception | None = None
    for attempt in range(4):
        agent = AGENT if "wikimedia.org" in url else BROWSER_AGENT
        request = urllib.request.Request(url, headers={"User-Agent": agent, "Accept": "image/avif,image/webp,image/*,*/*;q=0.8"})
        try:
            with urllib.request.urlopen(request, timeout=60) as response:
                return response.read()
        except Exception as error:  # noqa: BLE001 - retried, then reported
            last = error
            time.sleep(2 + attempt * 3)
    raise RuntimeError(f"download failed: {url} ({last})")


def open_rgb(data: bytes) -> Image.Image:
    image = ImageOps.exif_transpose(Image.open(io.BytesIO(data)))
    if image.mode in ("RGBA", "LA", "P"):
        image = image.convert("RGBA")
        canvas = Image.new("RGBA", image.size, (255, 255, 255, 255))
        canvas.alpha_composite(image)
        image = canvas
    return image.convert("RGB")


def crop_fraction(image: Image.Image, box: list[float] | None) -> Image.Image:
    if not box:
        return image
    w, h = image.size
    left, top, right, bottom = box
    return image.crop((round(w * left), round(h * top), round(w * right), round(h * bottom)))


def edge_color(image: Image.Image) -> tuple[int, int, int]:
    small = image.resize((64, 64))
    px = small.load()
    edge = [px[x, y] for x in range(64) for y in (0, 63)] + [px[x, y] for y in range(64) for x in (0, 63)]
    return tuple(int(median(c[i] for c in edge)) for i in range(3))  # type: ignore[return-value]


def square(image: Image.Image, size: int = 1200, margin: float = 0.04) -> Image.Image:
    inner = round(size * (1 - 2 * margin))
    fitted = ImageOps.contain(image, (inner, inner), Image.LANCZOS)
    canvas = Image.new("RGB", (size, size), edge_color(image))
    canvas.paste(fitted, ((size - fitted.width) // 2, (size - fitted.height) // 2))
    return canvas


def cover(image: Image.Image, width: int, height: int, focus: list[float] | None) -> Image.Image:
    return ImageOps.fit(image, (width, height), Image.LANCZOS, centering=tuple(focus or (0.5, 0.5)))


def collage(slug: str, names: list[str], background: str) -> Image.Image:
    """A 1600 x 500 banner of the store's own product photos, for stores without a suitable store photo."""
    h = background.lstrip("#")
    canvas = Image.new("RGB", (1600, 500), tuple(int(h[i:i + 2], 16) for i in (0, 2, 4)))
    tile, gap = 290, (1600 - 290 * len(names)) // (len(names) + 1)
    for n, name in enumerate(names):
        photo = Image.open(OUT / "products" / slug / f"{name}.jpg").convert("RGB").resize((tile, tile), Image.LANCZOS)
        canvas.paste(photo, (gap + n * (tile + gap), (500 - tile) // 2))
    return canvas


def save(image: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, "JPEG", quality=86, optimize=True, progressive=True)


def main(argv: list[str]) -> int:
    force = "--force" in argv
    manifest = json.loads((ROOT / "photo-sources.json").read_text(encoding="utf-8"))
    colors = {v["slug"]: v["colors"][1] for v in json.loads((ROOT / "vendors.json").read_text(encoding="utf-8"))["vendors"]}
    jobs: list[tuple[Path, dict, str]] = []
    for key, photos in manifest["products"].items():
        slug, sku = key.split("/", 1)
        for n, photo in enumerate(photos, start=1):
            jobs.append((OUT / "products" / slug / f"{sku}-{n}.jpg", photo, "product"))
    for slug, entries in manifest["vendors"].items():
        for kind, photo in entries.items():
            jobs.append((OUT / "vendors" / slug / f"{kind}.jpg", photo, kind))

    failures = 0
    for path, photo, kind in jobs:
        if path.exists() and not force:
            continue
        try:
            if "collage" in photo:
                save(collage(path.parent.name, photo["collage"], colors[path.parent.name]), path)
                print(f"ok   {path.relative_to(OUT)}", flush=True)
                continue
            image = crop_fraction(open_rgb(download(photo["url"])), photo.get("crop"))
            if kind == "banner":
                image = cover(image, 1600, 500, photo.get("focus"))
            elif kind == "vehicle":
                image = cover(image, 1200, 800, photo.get("focus"))
            else:
                image = square(image)
            save(image, path)
            print(f"ok   {path.relative_to(OUT)}", flush=True)
        except Exception as error:  # noqa: BLE001 - keep going, report at the end
            failures += 1
            print(f"FAIL {path.relative_to(OUT)}: {error}", flush=True)
    print(f"{len(jobs) - failures} of {len(jobs)} photos ready in {OUT}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
