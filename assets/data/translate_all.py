#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Translate all text fields in full_cairo_metro_template2.json from English
into all non-EN languages using deep-translator (Google Translate).

Fields translated: description, directions, map_hint, place-name keys.
Streets entries and stub entries are skipped.
Progress is saved to translate_progress.json after each language.
"""

import json, time, sys

try:
    from deep_translator import GoogleTranslator
except ImportError:
    print("Run: pip install deep-translator")
    sys.exit(1)

INPUT_FILE    = r"C:\Users\menan\Downloads\OutWork\metroappflutter\assets\data\full_cairo_metro_template2.json"
OUTPUT_FILE   = INPUT_FILE
PROGRESS_FILE = r"C:\Users\menan\Downloads\OutWork\metroappflutter\assets\data\translate_progress.json"

LANGS = {
    'ar': 'ar',
    'de': 'de',
    'es': 'es',
    'fr': 'fr',
    'it': 'it',
    'ja': 'ja',
    'pt': 'pt',
    'ru': 'ru',
    'tr': 'tr',
    'zh': 'zh-CN',
}

SLEEP = 0.25   # seconds between API calls
MAX_CHARS = 4500

# ──────────────────────────────────────────────────────────────────────────────
def translate_one(text: str, google_lang: str) -> str:
    """Translate a single text string with retry."""
    for attempt in range(4):
        try:
            result = GoogleTranslator(source='en', target=google_lang).translate(text)
            return result if result else text
        except Exception as e:
            wait = 2 ** attempt
            print(f"\n    ! retry {attempt+1} ({e}) waiting {wait}s …", end='', flush=True)
            time.sleep(wait)
    return text  # fallback


def translate_batch_numbered(texts: list[str], google_lang: str) -> list[str]:
    """
    Translate a list using numbered tags like ⟨1⟩ text ⟨2⟩ text …
    The angle-bracket Unicode chars are in Private Use Area and will not be
    altered by Google Translate, so splitting is reliable.
    """
    if not texts:
        return []

    # Build numbered blocks; split into sub-batches by char count
    def make_block(i, t):
        return f"\u276c{i}\u276d {t}"

    results = [''] * len(texts)

    # Group into batches ≤ MAX_CHARS
    batches = []     # list of list of (original_index, text)
    cur, cur_len = [], 0
    for i, t in enumerate(texts):
        block = make_block(i, t)
        if cur and cur_len + len(block) + 1 > MAX_CHARS:
            batches.append(cur)
            cur, cur_len = [], 0
        cur.append((i, t))
        cur_len += len(block) + 1
    if cur:
        batches.append(cur)

    for batch in batches:
        joined = '\n'.join(make_block(i, t) for i, t in batch)
        for attempt in range(4):
            try:
                raw = GoogleTranslator(source='en', target=google_lang).translate(joined)
                if raw is None:
                    raw = joined
                break
            except Exception as e:
                wait = 2 ** attempt
                print(f"\n    ! batch retry {attempt+1} ({e}) …", end='', flush=True)
                time.sleep(wait)
                raw = joined

        # Parse numbered tags back
        import re
        parts = re.split(r'\u276c(\d+)\u276d\s*', raw)
        # parts is like: ['', '0', 'text0', '1', 'text1', ...]
        parsed = {}
        i = 1
        while i + 1 < len(parts):
            try:
                idx = int(parts[i])
                parsed[idx] = parts[i+1].strip()
            except ValueError:
                pass
            i += 2

        # If parsing worked for all items use it; otherwise fall back individually
        if all(orig_i in parsed for orig_i, _ in batch):
            for orig_i, _ in batch:
                results[orig_i] = parsed[orig_i]
        else:
            # Fall back to individual translations for this batch
            for orig_i, t in batch:
                results[orig_i] = translate_one(t, google_lang)
                time.sleep(SLEEP)

        time.sleep(SLEEP)

    return results


# ──────────────────────────────────────────────────────────────────────────────
print("Loading JSON …")
with open(INPUT_FILE, encoding='utf-8') as f:
    data = json.load(f)
print(f"  {len(data)} top-level keys")

print("Collecting English strings …")
TEXT_FIELDS = ('description', 'directions', 'map_hint')
unique_texts = set()

for key, entry in data.items():
    if not key.startswith('en_metroStation'):
        continue
    if not isinstance(entry, dict) or 'stationName' in entry:
        continue
    for place_name, place in entry.items():
        if not isinstance(place, dict):
            continue
        if place.get('category', '') == 'Streets':
            continue
        unique_texts.add(place_name)
        for f in TEXT_FIELDS:
            v = place.get(f, '')
            if v:
                unique_texts.add(v)

unique_list = sorted(unique_texts)
print(f"  {len(unique_list)} unique strings to translate")

# Load progress cache
try:
    with open(PROGRESS_FILE, encoding='utf-8') as pf:
        cache: dict = json.load(pf)
    existing = sum(len(v) for v in cache.values())
    print(f"  Loaded progress cache ({existing} entries)")
except FileNotFoundError:
    cache = {}

def save_cache():
    with open(PROGRESS_FILE, 'w', encoding='utf-8') as pf:
        json.dump(cache, pf, ensure_ascii=False, indent=2)

# ── Translate each language ───────────────────────────────────────────────────
for lang_prefix, google_lang in LANGS.items():
    missing = [t for t in unique_list if cache.get(t, {}).get(lang_prefix) is None]
    if not missing:
        print(f"  [{lang_prefix}] all {len(unique_list)} cached – skipping")
        continue

    print(f"  [{lang_prefix}] translating {len(missing)} strings …", end='', flush=True)
    translated = translate_batch_numbered(missing, google_lang)

    for src, tgt in zip(missing, translated):
        if src not in cache:
            cache[src] = {}
        cache[src][lang_prefix] = tgt

    save_cache()
    print(f" done")

print("All translations complete.")

# ── Rebuild JSON entries ──────────────────────────────────────────────────────
print("Rebuilding non-EN/non-AR JSON entries …")
COORD_KEYS = {'lat', 'lng', 'latitude', 'longitude'}
rebuilt = 0

for key in list(data.keys()):
    lang_prefix = None
    for lp in LANGS:
        if key.startswith(f'{lp}_metroStation'):
            lang_prefix = lp
            station_suffix = key[len(f'{lp}_metroStation'):]
            break
    if lang_prefix is None:
        continue

    en_key = f'en_metroStation{station_suffix}'
    if en_key not in data:
        continue
    en_entry = data[en_key]
    if 'stationName' in en_entry:
        continue  # stub – leave as-is

    new_entry = {}
    for en_name, place in en_entry.items():
        if not isinstance(place, dict):
            continue
        cat = place.get('category', '')
        if cat == 'Streets':
            new_entry[en_name] = dict(place)
            continue

        trans_name = cache.get(en_name, {}).get(lang_prefix, en_name)

        new_place = {'category': cat}
        for f in TEXT_FIELDS:
            if f in place:
                en_val = place[f]
                new_place[f] = cache.get(en_val, {}).get(lang_prefix, en_val)

        for k, v in place.items():
            if k in COORD_KEYS:
                new_place[k] = v
            elif k not in ('category', 'description', 'directions', 'map_hint') and k not in new_place:
                new_place[k] = v

        new_entry[trans_name] = new_place

    data[key] = new_entry
    rebuilt += 1

print(f"  Rebuilt {rebuilt} entries")

print("Writing output …")
with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
print(f"Done! → {OUTPUT_FILE}")
