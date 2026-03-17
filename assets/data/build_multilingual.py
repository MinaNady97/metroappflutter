#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Build multilingual Cairo Metro station facilities JSON.
Adds fr_, es_, de_, ru_, it_, pt_, zh_, tr_, ja_ entries after each ar_ entry.
Run: py build_multilingual.py
"""

import json, re

INPUT  = r"C:\Users\menan\Downloads\OutWork\metroappflutter\assets\data\full_cairo_metro_template2.json"
OUTPUT = r"C:\Users\menan\Downloads\OutWork\metroappflutter\assets\data\full_cairo_metro_template2.json"
LANGS  = ['fr','es','de','ru','it','pt','zh','tr','ja']

# ── Stub station-name translations ──────────────────────────────────────────
STUB_NAMES = {
    "SUDAN":                    {"fr":"SOUDAN","es":"SUDÁN","de":"SUDAN","ru":"СУДАН","it":"SUDAN","pt":"SUDÃO","zh":"苏丹","tr":"SUDAN","ja":"スーダン"},
    "IMBABA":                   {"fr":"IMBABA","es":"IMBABA","de":"IMBABA","ru":"ИМБАБА","it":"IMBABA","pt":"IMBABA","zh":"因巴巴","tr":"İMBABA","ja":"インババ"},
    "EL_BOHY":                  {"fr":"EL BOHY","es":"EL BOHY","de":"EL BOHY","ru":"ЭЛЬ-БУХИ","it":"EL BOHY","pt":"EL BOHY","zh":"布希","tr":"EL BOHY","ja":"エル・ボヒ"},
    "EL_QAWMEYA":               {"fr":"EL QAWMEYA","es":"EL QAWMEYA","de":"EL QAWMEYA","ru":"ЭЛЬ-КАВМЕЙЯ","it":"EL QAWMEYA","pt":"EL QAWMEYA","zh":"国民大道","tr":"EL QAWMEYA","ja":"エル・カウメイヤ"},
    "EL_TARIQ_EL_DAIRY":        {"fr":"EL TARIQ EL DAIRY","es":"EL TARIQ EL DAIRY","de":"EL TARIQ EL DAIRY","ru":"ЭЛЬ-ТАРИК ЭЛЬ-ДЕЙРИ","it":"EL TARIQ EL DAIRY","pt":"EL TARIQ EL DAIRY","zh":"环形公路","tr":"EL TARIQ EL DAIRY","ja":"エル・タリク・エル・デイリー"},
    "ROD_EL_FARAG_AXIS":        {"fr":"ROD EL FARAG AXIS","es":"ROD EL FARAG AXIS","de":"ROD EL FARAG AXIS","ru":"РОД ЭЛЬ-ФАРАГ АКС","it":"ROD EL FARAG AXIS","pt":"ROD EL FARAG AXIS","zh":"罗德·法拉格轴","tr":"ROD EL FARAG AXIS","ja":"ロード・エル・ファラグ・アクシス"},
    "EL_TOUFIQIA":              {"fr":"EL TOUFIQIA","es":"EL TOUFIQIA","de":"EL TOUFIQIA","ru":"ЭЛЬ-ТУФИКИЯ","it":"EL TOUFIQIA","pt":"EL TOUFIQIA","zh":"图菲基亚","tr":"EL TOUFIQIA","ja":"エル・トゥフィキア"},
    "WADI_EL_NIL":              {"fr":"WADI EL NIL","es":"WADI EL NIL","de":"WADI EL NIL","ru":"ВАДИ ЭЛЬ-НИЛ","it":"WADI EL NIL","pt":"WADI EL NIL","zh":"尼罗河谷","tr":"WADI EL NIL","ja":"ワーディー・エル・ニール"},
    "GAMAET_EL_DOWL_EL_ARABIA": {"fr":"GAMAET EL DOWL EL ARABIA","es":"GAMAET EL DOWL EL ARABIA","de":"GAMAET EL DOWL EL ARABIA","ru":"ГАМАЭТ ЭЛЬ-ДУВАЛ ЭЛЬ-АРАБИЙЯ","it":"GAMAET EL DOWL EL ARABIA","pt":"GAMAET EL DOWL EL ARABIA","zh":"阿拉伯国家联盟大街","tr":"GAMAET EL DOWL EL ARABIA","ja":"ガマエット・エル・ドゥウル・エル・アラビア"},
    "BOLAK_EL_DAKROUR":         {"fr":"BOLAK EL DAKROUR","es":"BOLAK EL DAKROUR","de":"BOLAK EL DAKROUR","ru":"БУЛАК ЭЛЬ-ДАКРУР","it":"BOLAK EL DAKROUR","pt":"BOLAK EL DAKROUR","zh":"布拉克·达克鲁尔","tr":"BOLAK EL DAKROUR","ja":"ブラク・エル・ダクルール"},
    "CAIRO_UNIVERSITY":         {"fr":"UNIVERSITÉ DU CAIRE","es":"UNIVERSIDAD DE EL CAIRO","de":"UNIVERSITÄT KAIRO","ru":"КАИРСКИЙ УНИВЕРСИТЕТ","it":"UNIVERSITÀ DEL CAIRO","pt":"UNIVERSIDADE DO CAIRO","zh":"开罗大学","tr":"KAHİRE ÜNİVERSİTESİ","ja":"カイロ大学"},
}

# ── Main translation DB ──────────────────────────────────────────────────────
# T[station][en_place_name][lang] = {place_name, description, directions, [map_hint]}
T = {}
exec(open(r"C:\Users\menan\Downloads\OutWork\metroappflutter\assets\data\translations_db.py", encoding='utf-8').read())

# ── Helpers ──────────────────────────────────────────────────────────────────
COORD_KEYS = {'lat','lng','latitude','longitude'}

def is_stub(entry):
    return 'stationName' in entry

def make_translated_entry(station, en_entry, lang):
    new_entry = {}
    station_db = T.get(station, {})
    for en_name, place in en_entry.items():
        if not isinstance(place, dict):
            continue
        cat = place.get('category','')
        if cat == 'Streets':
            new_entry[en_name] = dict(place)
            continue
        db = station_db.get(en_name, {}).get(lang, {})
        trans_name = db.get('place_name', en_name)
        new_place = {}
        new_place['category'] = cat
        new_place['description'] = db.get('description', place.get('description',''))
        new_place['directions']  = db.get('directions',  place.get('directions',''))
        if 'map_hint' in place:
            new_place['map_hint'] = db.get('map_hint', place['map_hint'])
        for k,v in place.items():
            if k in COORD_KEYS or (k not in ('category','description','directions','map_hint')):
                if k not in new_place:
                    new_place[k] = v
        new_entry[trans_name] = new_place
    return new_entry

def make_stub_entry(station_suffix, en_entry, lang):
    new_entry = {}
    orig_name = en_entry.get('stationName', station_suffix)
    new_entry['stationName'] = STUB_NAMES.get(orig_name, {}).get(lang, orig_name)
    for k, v in en_entry.items():
        if k != 'stationName':
            new_entry[k] = v
    return new_entry

# ── Build output ─────────────────────────────────────────────────────────────
print("Reading …")
with open(INPUT, encoding='utf-8') as f:
    raw = f.read()
data = json.loads(raw)
print(f"  {len(data)} entries loaded")

new_data = {}
keys = list(data.keys())
for key in keys:
    new_data[key] = data[key]
    if key.startswith('ar_metroStation'):
        suffix = key[len('ar_metroStation'):]
        en_key = f'en_metroStation{suffix}'
        if en_key not in data:
            continue
        en_entry = data[en_key]
        stub = is_stub(en_entry)
        for lang in LANGS:
            lk = f'{lang}_metroStation{suffix}'
            if stub:
                new_data[lk] = make_stub_entry(suffix, en_entry, lang)
            else:
                new_data[lk] = make_translated_entry(suffix, en_entry, lang)

print(f"  {len(new_data)} entries after expansion")
print("Writing …")
with open(OUTPUT, 'w', encoding='utf-8') as f:
    json.dump(new_data, f, ensure_ascii=False, indent=2)
print("Done.")
