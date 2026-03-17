#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Batch-translate all street names, then rebuild JSON with translations.
Uses numbered-tag batching for speed. Saves cache after each language.
"""
import json, time, re, io, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

try:
    from deep_translator import GoogleTranslator
except ImportError:
    print("pip install deep-translator"); sys.exit(1)

JSON_FILE  = r"C:\Users\menan\Downloads\OutWork\metroappflutter\assets\data\full_cairo_metro_template2.json"
CACHE_FILE = r"C:\Users\menan\Downloads\OutWork\metroappflutter\assets\data\translate_progress.json"

LANGS = {'ar':'ar','de':'de','es':'es','fr':'fr','it':'it',
         'ja':'ja','pt':'pt','ru':'ru','tr':'tr','zh':'zh-CN'}
TEXT_FIELDS  = ('description','directions','map_hint')
COORD_KEYS   = {'lat','lng','latitude','longitude'}
MAX_CHARS    = 4500
SLEEP        = 0.3

# ── Batched translation ────────────────────────────────────────────────────────
def batch_translate(texts, google_lang):
    if not texts: return []
    results = [''] * len(texts)

    def make_block(i, t): return f"\u276c{i}\u276d {t}"

    batches, cur, cur_len = [], [], 0
    for i, t in enumerate(texts):
        b = make_block(i, t)
        if cur and cur_len + len(b) + 1 > MAX_CHARS:
            batches.append(cur); cur, cur_len = [], 0
        cur.append((i, t)); cur_len += len(b) + 1
    if cur: batches.append(cur)

    for batch in batches:
        joined = '\n'.join(make_block(i, t) for i, t in batch)
        for attempt in range(4):
            try:
                raw = GoogleTranslator(source='en', target=google_lang).translate(joined)
                raw = raw or joined; break
            except Exception as e:
                time.sleep(2**attempt); raw = joined

        parts = re.split(r'\u276c(\d+)\u276d\s*', raw)
        parsed = {}
        i = 1
        while i + 1 < len(parts):
            try: parsed[int(parts[i])] = parts[i+1].strip()
            except ValueError: pass
            i += 2

        if all(oi in parsed for oi, _ in batch):
            for oi, _ in batch: results[oi] = parsed[oi]
        else:
            for oi, t in batch:
                for attempt in range(3):
                    try:
                        r = GoogleTranslator(source='en', target=google_lang).translate(t)
                        results[oi] = r or t; break
                    except Exception:
                        if attempt == 2: results[oi] = t
                        time.sleep(1)
        time.sleep(SLEEP)

    return results

# ── Load data ──────────────────────────────────────────────────────────────────
print("Loading files...")
with open(JSON_FILE, encoding='utf-8') as f: data = json.load(f)
try:
    with open(CACHE_FILE, encoding='utf-8') as f: cache = json.load(f)
except FileNotFoundError: cache = {}
print(f"  JSON: {len(data)} keys, cache: {len(cache)} entries")

# ── Collect all unique strings (POI names + text fields + street names) ────────
print("Collecting all unique strings...")
all_unique = set()
for key, entry in data.items():
    if not key.startswith('en_metroStation'): continue
    if not isinstance(entry, dict) or 'stationName' in entry: continue
    for name, place in entry.items():
        if not isinstance(place, dict): continue
        all_unique.add(name)  # place name (including streets)
        for f in TEXT_FIELDS:
            v = place.get(f, '')
            if v: all_unique.add(v)

unique_list = sorted(all_unique)
print(f"  {len(unique_list)} unique strings total")

# ── Translate missing strings per language ─────────────────────────────────────
for lang_prefix, google_lang in LANGS.items():
    missing = [t for t in unique_list if cache.get(t, {}).get(lang_prefix) is None]
    if not missing:
        print(f"  [{lang_prefix}] all cached")
        continue
    print(f"  [{lang_prefix}] translating {len(missing)} strings...", end='', flush=True)
    translated = batch_translate(missing, google_lang)
    for src, tgt in zip(missing, translated):
        if src not in cache: cache[src] = {}
        cache[src][lang_prefix] = tgt
    with open(CACHE_FILE, 'w', encoding='utf-8') as f:
        json.dump(cache, f, ensure_ascii=False, indent=2)
    print(f" saved ({len(missing)} new)")

print("All translations done.")

# ── Rebuild all non-EN/AR entries ─────────────────────────────────────────────
print("Rebuilding JSON entries...")
rebuilt = 0
for key in list(data.keys()):
    lang_prefix = None
    for lp in LANGS:
        if key.startswith(f'{lp}_metroStation'):
            lang_prefix = lp
            station_suffix = key[len(f'{lp}_metroStation'):]
            break
    if lang_prefix is None: continue

    en_key = f'en_metroStation{station_suffix}'
    if en_key not in data: continue
    en_entry = data[en_key]
    if 'stationName' in en_entry: continue

    new_entry = {}
    for en_name, place in en_entry.items():
        if not isinstance(place, dict): continue
        cat = place.get('category', '')
        trans_name = cache.get(en_name, {}).get(lang_prefix, en_name)

        if cat == 'Streets':
            new_entry[trans_name] = dict(place)
            continue

        new_place = {'category': cat}
        for f in TEXT_FIELDS:
            if f in place:
                en_val = place[f]
                new_place[f] = cache.get(en_val, {}).get(lang_prefix, en_val) if en_val else en_val
        for k, v in place.items():
            if k in COORD_KEYS:
                new_place[k] = v
            elif k not in ('category','description','directions','map_hint') and k not in new_place:
                new_place[k] = v
        new_entry[trans_name] = new_place

    data[key] = new_entry
    rebuilt += 1

print(f"  Rebuilt {rebuilt} entries")

print("Writing JSON...")
with open(JSON_FILE, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# ── Verify ────────────────────────────────────────────────────────────────────
print("\n=== Spot checks ===")
checks = [('ar','ar_metroStationADLY MANSOUR'),('zh','zh_metroStationMASPERO'),
          ('ja','ja_metroStationMASPERO'),('ru','ru_metroStationADLY MANSOUR')]
for lang, key in checks:
    entry = data.get(key, {})
    streets = [(n, p) for n, p in entry.items() if isinstance(p,dict) and p.get('category')=='Streets']
    pois    = [(n, p) for n, p in entry.items() if isinstance(p,dict) and p.get('category')!='Streets']
    s_name = streets[0][0] if streets else 'none'
    p_name = pois[0][0] if pois else 'none'
    p_desc = pois[0][1].get('description','')[:50] if pois else ''
    print(f"  [{lang}] street={s_name} | poi={p_name}: {p_desc}")

print("\nComplete!")
