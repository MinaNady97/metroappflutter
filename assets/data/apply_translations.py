#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Apply all translations from translate_progress.json into full_cairo_metro_template2.json.
Re-translates ANY field that still has an English fallback.
"""
import json, time, io, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

try:
    from deep_translator import GoogleTranslator
except ImportError:
    print("pip install deep-translator")
    sys.exit(1)

JSON_FILE     = r"C:\Users\menan\Downloads\OutWork\metroappflutter\assets\data\full_cairo_metro_template2.json"
CACHE_FILE    = r"C:\Users\menan\Downloads\OutWork\metroappflutter\assets\data\translate_progress.json"

LANGS = {
    'ar': 'ar', 'de': 'de', 'es': 'es', 'fr': 'fr', 'it': 'it',
    'ja': 'ja', 'pt': 'pt', 'ru': 'ru', 'tr': 'tr', 'zh': 'zh-CN',
}
TEXT_FIELDS  = ('description', 'directions', 'map_hint')
COORD_KEYS   = {'lat', 'lng', 'latitude', 'longitude'}

print("Loading files...")
with open(JSON_FILE, encoding='utf-8') as f:
    data = json.load(f)
with open(CACHE_FILE, encoding='utf-8') as f:
    cache: dict = json.load(f)

print(f"  JSON keys: {len(data)}")
print(f"  Cache entries: {len(cache)}")


def get_translation(en_text: str, lang_prefix: str, google_lang: str) -> str:
    """Return cached translation or fetch live."""
    cached = cache.get(en_text, {}).get(lang_prefix)
    if cached is not None:
        return cached
    # Not in cache — translate now and cache it
    for attempt in range(4):
        try:
            result = GoogleTranslator(source='en', target=google_lang).translate(en_text)
            translated = result if result else en_text
            break
        except Exception as e:
            time.sleep(2 ** attempt)
            translated = en_text
    if en_text not in cache:
        cache[en_text] = {}
    cache[en_text][lang_prefix] = translated
    return translated


# ── Rebuild every non-EN/AR entry from its EN counterpart ────────────────────
print("Rebuilding all translated entries...")
rebuilt = 0
newly_translated = 0

for key in list(data.keys()):
    lang_prefix = None
    for lp in LANGS:
        if key.startswith(f'{lp}_metroStation'):
            lang_prefix = lp
            station_suffix = key[len(f'{lp}_metroStation'):]
            break
    if lang_prefix is None:
        continue  # en_ or ar_ — leave untouched

    en_key = f'en_metroStation{station_suffix}'
    if en_key not in data:
        continue

    en_entry = data[en_key]
    if 'stationName' in en_entry:
        continue  # stub

    google_lang = LANGS[lang_prefix]
    new_entry = {}

    for en_name, place in en_entry.items():
        if not isinstance(place, dict):
            continue

        cat = place.get('category', '')

        # Streets: translate the name key, keep lat/lng verbatim
        if cat == 'Streets':
            trans_street_name = get_translation(en_name, lang_prefix, google_lang)
            new_entry[trans_street_name] = dict(place)
            continue

        # Translate place-name key
        trans_name = get_translation(en_name, lang_prefix, google_lang)
        if trans_name == en_name and lang_prefix not in ('de','es','fr','it','pt','tr'):
            newly_translated += 1

        new_place = {'category': cat}

        # Translate each text field
        for f in TEXT_FIELDS:
            if f in place:
                en_val = place[f]
                if en_val:
                    new_place[f] = get_translation(en_val, lang_prefix, google_lang)
                else:
                    new_place[f] = en_val

        # Copy all coordinate and extra fields verbatim
        for k, v in place.items():
            if k in COORD_KEYS:
                new_place[k] = v
            elif k not in ('category', 'description', 'directions', 'map_hint') and k not in new_place:
                new_place[k] = v

        new_entry[trans_name] = new_place

    data[key] = new_entry
    rebuilt += 1

print(f"  Rebuilt {rebuilt} entries")
if newly_translated:
    print(f"  Fetched {newly_translated} new translations live (added to cache)")

# Save updated cache
print("Saving cache...")
with open(CACHE_FILE, 'w', encoding='utf-8') as f:
    json.dump(cache, f, ensure_ascii=False, indent=2)

# Write final JSON
print("Writing JSON...")
with open(JSON_FILE, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# ── Verification report ───────────────────────────────────────────────────────
print("\n=== Verification ===")
non_latin = {'ar', 'ja', 'ru', 'zh'}
sample_checks = [
    ('pt_metroStationMASPERO', 'pt'),
    ('ja_metroStationADLY MANSOUR', 'ja'),
    ('zh_metroStationMASPERO', 'zh'),
    ('ar_metroStationMASPERO', 'ar'),
    ('ru_metroStationMASPERO', 'ru'),
    ('de_metroStationMASPERO', 'de'),
    ('tr_metroStationMASPERO', 'tr'),
]
for key, lang in sample_checks:
    entry = data.get(key, {})
    if entry and 'stationName' not in entry:
        first_name, first_place = next(iter(entry.items()))
        desc = first_place.get('description', '')[:55]
        print(f"  [{lang}] {first_name}: {desc}")
    else:
        print(f"  [{lang}] {key}: NOT FOUND or stub")

print("\nDone.")
