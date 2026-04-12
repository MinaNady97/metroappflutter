import csv

# Arabic station names
stations_ar = [
"محطة المشير طنطاوى","محطة كايرو فستيفال سيتى","محطة أكاديمية الشرطة",
"محطة طريق السويس","محطة عدلي منصور","محطة موقف العاشر من رمضان",
"محطة غرب الرشاح","محطة التروللي","محطة مؤسسة الزكاة",
"محطة مصرف بلبيس","محطة متولي الشعراوي","محطة أحمد عرابي",
"محطة عزبة الجزيرة","محطة العصار","محطة أرض اللواء",
"محطة المرج","محطة منطي","محطة محور 26 يوليو",
"محطة رشاح والخصوص","محطة إسكندرية الزراعي","محطة المعتمدية",
"محطة مسطرد","محطة بسوس","محطة زنين",
"محطة البحر الأعظم","محطة بسوس القناطر","محطة صفط اللبن",
"محطة الزهراء","محطة الوراق","محطة منشية البكاري",
"محطة العزبة","محطة تحيا مصر","محطة النور",
"محطة محور الحضارة","محطة مترو إمبابة","محطة مسجد المدينة",
"محطة الجزائر","محطة بشتيل","محطة فيصل",
"محطة الأوتوستراد","محطة الطالبية","محطة الهرم",
"محطة الهضبة الوسطى","محطة المنيب","محطة ترسا",
"محطة سيتي سنتر المعادي","محطة الطالبية","محطة مصر للطيران",
"محطة الصيد","محطة البروان","محطة محور الشهيد"
]

# simple Arabic → English map (can extend later)
translations = {
"المشير طنطاوى":"Field Marshal Tantawi",
"كايرو فستيفال سيتى":"Cairo Festival City",
"أكاديمية الشرطة":"Police Academy",
"طريق السويس":"Suez Road",
"عدلي منصور":"Adly Mansour",
"موقف العاشر من رمضان":"10th of Ramadan",
"غرب الرشاح":"West Rashah",
"التروللي":"Trolley",
"مؤسسة الزكاة":"Zakat Foundation",
"مصرف بلبيس":"Belbeis Canal",
"متولي الشعراوي":"Metwally El Shaarawi",
"أحمد عرابي":"Ahmed Orabi",
"عزبة الجزيرة":"Ezbet El Gezira",
"العصار":"Al Assar",
"أرض اللواء":"Ard El Lewa",
"المرج":"El Marg",
"منطي":"Manti",
"محور 26 يوليو":"26 July Corridor",
"رشاح والخصوص":"Rashah Khosos",
"إسكندرية الزراعي":"Alexandria Agricultural Road",
"المعتمدية":"Al Mutamadiyah",
"مسطرد":"Mostorod",
"بسوس":"Bsous",
"زنين":"Zenin",
"البحر الأعظم":"Bahr Al Aazam",
"بسوس القناطر":"Bsous Qanater",
"صفط اللبن":"Saft El Laban",
"الزهراء":"Al Zahraa",
"الوراق":"Al Warraq",
"منشية البكاري":"Mansheyet Al Bakari",
"العزبة":"Al Ezba",
"تحيا مصر":"Tahya Misr",
"النور":"Al Nour",
"محور الحضارة":"Hadara Axis",
"مترو إمبابة":"Imbaba Metro",
"مسجد المدينة":"Al Madina Mosque",
"الجزائر":"Al Gazayer",
"بشتيل":"Bashtil",
"فيصل":"Faisal",
"الأوتوستراد":"Autostrad",
"الطالبية":"Talabiya",
"الهرم":"Al Haram",
"الهضبة الوسطى":"Hadaba Wusta",
"المنيب":"Al Munib",
"ترسا":"Tersa",
"سيتي سنتر المعادي":"Maadi City Center",
"مصر للطيران":"EgyptAir",
"الصيد":"Al Seid",
"البروان":"Al Barwan",
"محور الشهيد":"Shaheed Axis"
}

rows = []

for ar in stations_ar:

    name = ar.replace("محطة ","")

    en = translations.get(name,"")

    rows.append({
        "name_ar": ar,
        "name_en": en,
        "latitude": "",
        "longitude": ""
    })

with open("brt_stations.csv","w",newline="",encoding="utf-8-sig") as f:

    writer = csv.DictWriter(
        f,
        fieldnames=["name_ar","name_en","latitude","longitude"]
    )

    writer.writeheader()
    writer.writerows(rows)

print("CSV created: brt_stations.csv")