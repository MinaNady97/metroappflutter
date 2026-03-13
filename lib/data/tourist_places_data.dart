// ─────────────────────────────────────────────────────────────────────────────
// Tourist Places data — 48 places near Cairo Metro stations
//
// IMPORTANT: Walking times, descriptions, and details are approximate
// estimates and may vary. Users should verify information officially
// before visiting.
// ─────────────────────────────────────────────────────────────────────────────

enum PlaceCategory {
  historical,
  museum,
  religious,
  park,
  shopping,
  culture,
  nile,
  hiddenGem,
}

class TouristPlace {
  final String id;
  final String nameEn;
  final String nameAr;
  final String descEn;
  final String descAr;
  final PlaceCategory category;
  final String image; // asset path
  final String stationEn;
  final String stationAr;
  final String line; // "1", "2", "3", "1/2", "2/3" etc.
  final int walkMinutes;
  final bool needsTransport; // true = bus/taxi after metro

  const TouristPlace({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.descEn,
    required this.descAr,
    required this.category,
    required this.image,
    required this.stationEn,
    required this.stationAr,
    required this.line,
    required this.walkMinutes,
    this.needsTransport = false,
  });

  String name(bool isAr) => isAr ? nameAr : nameEn;
  String desc(bool isAr) => isAr ? descAr : descEn;
  String station(bool isAr) => isAr ? stationAr : stationEn;
}

// ── Category helpers ────────────────────────────────────────────────────────

extension PlaceCategoryX on PlaceCategory {
  String labelEn() => switch (this) {
        PlaceCategory.historical => 'Historical',
        PlaceCategory.museum => 'Museums',
        PlaceCategory.religious => 'Religious',
        PlaceCategory.park => 'Parks',
        PlaceCategory.shopping => 'Shopping',
        PlaceCategory.culture => 'Culture',
        PlaceCategory.nile => 'Nile',
        PlaceCategory.hiddenGem => 'Hidden Gems',
      };

  String labelAr() => switch (this) {
        PlaceCategory.historical => 'تاريخي',
        PlaceCategory.museum => 'متاحف',
        PlaceCategory.religious => 'ديني',
        PlaceCategory.park => 'حدائق',
        PlaceCategory.shopping => 'تسوق',
        PlaceCategory.culture => 'ثقافي',
        PlaceCategory.nile => 'النيل',
        PlaceCategory.hiddenGem => 'جواهر خفية',
      };

  String label(bool isAr) => isAr ? labelAr() : labelEn();
}

// ── All 48 places ───────────────────────────────────────────────────────────

const touristPlaces = <TouristPlace>[
  // ══════════════════════════════════════════════════════════════════════════
  // HISTORICAL & ARCHAEOLOGICAL
  // ══════════════════════════════════════════════════════════════════════════
  TouristPlace(
    id: 'pyramids_giza',
    nameEn: 'Pyramids of Giza & Great Sphinx',
    nameAr: 'أهرامات الجيزة وأبو الهول',
    descEn:
        'The last surviving Wonder of the Ancient World. Three iconic pyramids and the Great Sphinx, dating back over 4,500 years.',
    descAr:
        'آخر عجائب الدنيا السبع الباقية. ثلاثة أهرامات أيقونية وأبو الهول، يعود تاريخها لأكثر من 4500 عام.',
    category: PlaceCategory.historical,
    image: 'assets/images/tourist/pyramids_giza.jpg',
    stationEn: 'GIZA',
    stationAr: 'الجيزة',
    line: '2',
    walkMinutes: 20,
    needsTransport: true,
  ),
  TouristPlace(
    id: 'coptic_cairo',
    nameEn: 'Coptic Cairo (Old Cairo)',
    nameAr: 'القاهرة القبطية (مصر القديمة)',
    descEn:
        'Ancient Christian quarter with churches, a synagogue, and a mosque, all dating back centuries. A UNESCO heritage area.',
    descAr:
        'حي مسيحي قديم يضم كنائس وكنيساً يهودياً ومسجداً، يعود تاريخها لقرون. منطقة تراث عالمي لليونسكو.',
    category: PlaceCategory.historical,
    image: 'assets/images/tourist/coptic_cairo.jpg',
    stationEn: 'MAR GIRGIS',
    stationAr: 'مار جرجس',
    line: '1',
    walkMinutes: 2,
  ),
  TouristPlace(
    id: 'citadel_saladin',
    nameEn: 'The Citadel of Saladin',
    nameAr: 'قلعة صلاح الدين',
    descEn:
        'Medieval Islamic fortress built by Saladin in 1176, offering panoramic views of Cairo and housing several museums and mosques.',
    descAr:
        'قلعة إسلامية من العصور الوسطى بناها صلاح الدين عام 1176، توفر إطلالات بانورامية على القاهرة وتضم عدة متاحف ومساجد.',
    category: PlaceCategory.historical,
    image: 'assets/images/tourist/citadel_saladin.jpg',
    stationEn: 'SAYEDA ZEINAB',
    stationAr: 'السيدة زينب',
    line: '1',
    walkMinutes: 10,
    needsTransport: true,
  ),
  TouristPlace(
    id: 'al_muizz_street',
    nameEn: 'Al-Muizz Street (Historic Cairo)',
    nameAr: 'شارع المعز (القاهرة التاريخية)',
    descEn:
        'One of the oldest streets in Cairo — a mile-long open-air museum lined with medieval mosques, madrasas, and fountains.',
    descAr:
        'من أقدم شوارع القاهرة — متحف مفتوح بطول ميل تصطف عليه مساجد ومدارس ونوافير من العصور الوسطى.',
    category: PlaceCategory.historical,
    image: 'assets/images/tourist/al_muizz_street.jpg',
    stationEn: 'BAB EL-SHARIA',
    stationAr: 'باب الشعرية',
    line: '3',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'baron_palace',
    nameEn: 'Baron Empain Palace',
    nameAr: 'قصر البارون إمبان',
    descEn:
        'A stunning Hindu temple-inspired palace built between 1907–1911 by Belgian industrialist Baron Empain. Recently restored and open to visitors.',
    descAr:
        'قصر مذهل مستوحى من المعابد الهندوسية بناه البارون إمبان البلجيكي بين 1907–1911. تم ترميمه مؤخراً ومفتوح للزوار.',
    category: PlaceCategory.historical,
    image: 'assets/images/tourist/baron_palace.jpg',
    stationEn: 'HELIOPOLIS',
    stationAr: 'هليوبوليس',
    line: '3',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'bab_zuweila',
    nameEn: 'Bab Zuweila',
    nameAr: 'باب زويلة',
    descEn:
        'The last remaining southern gate of medieval Cairo\'s fortified walls, built in 1092. Climb the twin minarets for stunning city views.',
    descAr:
        'آخر بوابة جنوبية متبقية من أسوار القاهرة المحصنة، بُنيت عام 1092. يمكن تسلق المئذنتين لرؤية المدينة.',
    category: PlaceCategory.historical,
    image: 'assets/images/tourist/bab_zuweila.jpg',
    stationEn: 'ATABA',
    stationAr: 'العتبة',
    line: '2/3',
    walkMinutes: 12,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // MUSEUMS
  // ══════════════════════════════════════════════════════════════════════════
  TouristPlace(
    id: 'egyptian_museum',
    nameEn: 'Egyptian Museum (Tahrir)',
    nameAr: 'المتحف المصري (التحرير)',
    descEn:
        'Home to the world\'s largest collection of Pharaonic antiquities, with over 120,000 artifacts including Tutankhamun treasures.',
    descAr:
        'يضم أكبر مجموعة في العالم من الآثار الفرعونية، مع أكثر من 120,000 قطعة أثرية بما في ذلك كنوز توت عنخ آمون.',
    category: PlaceCategory.museum,
    image: 'assets/images/tourist/egyptian_museum.jpg',
    stationEn: 'SADAT',
    stationAr: 'السادات',
    line: '1/2',
    walkMinutes: 3,
  ),
  TouristPlace(
    id: 'grand_egyptian_museum',
    nameEn: 'Grand Egyptian Museum (GEM)',
    nameAr: 'المتحف المصري الكبير',
    descEn:
        'The world\'s largest archaeological museum near the Pyramids. Houses Tutankhamun\'s complete collection of over 5,000 artifacts.',
    descAr:
        'أكبر متحف أثري في العالم بالقرب من الأهرامات. يضم مجموعة توت عنخ آمون الكاملة بأكثر من 5000 قطعة.',
    category: PlaceCategory.museum,
    image: 'assets/images/tourist/grand_egyptian_museum.jpg',
    stationEn: 'GIZA',
    stationAr: 'الجيزة',
    line: '2',
    walkMinutes: 25,
    needsTransport: true,
  ),
  TouristPlace(
    id: 'nmec_museum',
    nameEn: 'National Museum of Egyptian Civilization',
    nameAr: 'المتحف القومي للحضارة المصرية',
    descEn:
        'Home to the Royal Mummies Hall. Traces 5,000 years of Egyptian civilization from prehistoric times to the modern era.',
    descAr:
        'يضم قاعة المومياوات الملكية. يتتبع 5000 عام من الحضارة المصرية من عصور ما قبل التاريخ إلى العصر الحديث.',
    category: PlaceCategory.museum,
    image: 'assets/images/tourist/nmec_museum.jpg',
    stationEn: 'EL-MALEK EL-SALEH',
    stationAr: 'الملك الصالح',
    line: '1',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'islamic_art_museum',
    nameEn: 'Museum of Islamic Art',
    nameAr: 'متحف الفن الإسلامي',
    descEn:
        'One of the world\'s greatest collections of Islamic art, housing over 100,000 artifacts spanning 1,300 years.',
    descAr:
        'واحدة من أعظم مجموعات الفن الإسلامي في العالم، تضم أكثر من 100,000 قطعة أثرية تمتد على 1300 عام.',
    category: PlaceCategory.museum,
    image: 'assets/images/tourist/islamic_art_museum.jpg',
    stationEn: 'BAB EL-SHARIA',
    stationAr: 'باب الشعرية',
    line: '3',
    walkMinutes: 5,
  ),
  TouristPlace(
    id: 'coptic_museum',
    nameEn: 'Coptic Museum',
    nameAr: 'المتحف القبطي',
    descEn:
        'The world\'s largest collection of Coptic Christian artifacts, set within the ancient Babylon Fortress in Old Cairo.',
    descAr:
        'أكبر مجموعة في العالم من الآثار القبطية المسيحية، داخل حصن بابليون القديم في مصر القديمة.',
    category: PlaceCategory.museum,
    image: 'assets/images/tourist/coptic_museum.jpg',
    stationEn: 'MAR GIRGIS',
    stationAr: 'مار جرجس',
    line: '1',
    walkMinutes: 2,
  ),
  TouristPlace(
    id: 'abdeen_palace',
    nameEn: 'Abdeen Palace Museum',
    nameAr: 'متحف قصر عابدين',
    descEn:
        '19th-century royal palace, now a museum showcasing presidential gifts, military collections, and royal silver.',
    descAr:
        'قصر ملكي من القرن التاسع عشر، الآن متحف يعرض الهدايا الرئاسية والمجموعات العسكرية والفضيات الملكية.',
    category: PlaceCategory.museum,
    image: 'assets/images/tourist/abdeen_palace.jpg',
    stationEn: 'MOHAMED NAGUIB',
    stationAr: 'محمد نجيب',
    line: '2',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'gayer_anderson_museum',
    nameEn: 'Gayer-Anderson Museum',
    nameAr: 'متحف جاير أندرسون',
    descEn:
        'Two beautifully restored 16th–17th century houses joined together, filled with art, antiques, and oriental furnishings.',
    descAr:
        'منزلان من القرن 16–17 تم ترميمهما وضُما معاً، مليئان بالفنون والتحف والأثاث الشرقي.',
    category: PlaceCategory.museum,
    image: 'assets/images/tourist/gayer_anderson_museum.jpg',
    stationEn: 'SAYEDA ZEINAB',
    stationAr: 'السيدة زينب',
    line: '1',
    walkMinutes: 15,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // MOSQUES & RELIGIOUS SITES
  // ══════════════════════════════════════════════════════════════════════════
  TouristPlace(
    id: 'hanging_church',
    nameEn: 'Hanging Church (Al-Muallaqa)',
    nameAr: 'الكنيسة المعلقة',
    descEn:
        'One of the oldest churches in Egypt, built atop the southern gate of Babylon Fortress. Dates to the 3rd–4th century.',
    descAr:
        'واحدة من أقدم الكنائس في مصر، بُنيت فوق البوابة الجنوبية لحصن بابليون. يعود تاريخها للقرن الثالث والرابع.',
    category: PlaceCategory.religious,
    image: 'assets/images/tourist/hanging_church.jpg',
    stationEn: 'MAR GIRGIS',
    stationAr: 'مار جرجس',
    line: '1',
    walkMinutes: 3,
  ),
  TouristPlace(
    id: 'st_george_church',
    nameEn: 'Church of St. George',
    nameAr: 'كنيسة القديس جرجس',
    descEn:
        'A distinctive circular Greek Orthodox church, one of the few round churches in the Middle East, with stunning interiors.',
    descAr:
        'كنيسة يونانية أرثوذكسية دائرية مميزة، واحدة من الكنائس الدائرية القليلة في الشرق الأوسط.',
    category: PlaceCategory.religious,
    image: 'assets/images/tourist/st_george_church.jpg',
    stationEn: 'MAR GIRGIS',
    stationAr: 'مار جرجس',
    line: '1',
    walkMinutes: 2,
  ),
  TouristPlace(
    id: 'ben_ezra_synagogue',
    nameEn: 'Ben Ezra Synagogue',
    nameAr: 'معبد بن عزرا',
    descEn:
        'Cairo\'s oldest synagogue, dating to the 9th century. Famous as the site of the Cairo Geniza manuscript discovery.',
    descAr:
        'أقدم كنيس يهودي في القاهرة، يعود للقرن التاسع. اشتُهر كموقع اكتشاف مخطوطات جنيزة القاهرة.',
    category: PlaceCategory.religious,
    image: 'assets/images/tourist/ben_ezra_synagogue.jpg',
    stationEn: 'MAR GIRGIS',
    stationAr: 'مار جرجس',
    line: '1',
    walkMinutes: 5,
  ),
  TouristPlace(
    id: 'al_azhar_mosque',
    nameEn: 'Al-Azhar Mosque & University',
    nameAr: 'الجامع الأزهر والجامعة',
    descEn:
        'Founded in 970 AD, one of the world\'s oldest universities and a masterpiece of Fatimid architecture.',
    descAr:
        'تأسس عام 970 م، من أقدم الجامعات في العالم وتحفة من العمارة الفاطمية.',
    category: PlaceCategory.religious,
    image: 'assets/images/tourist/al_azhar_mosque.jpg',
    stationEn: 'BAB EL-SHARIA',
    stationAr: 'باب الشعرية',
    line: '3',
    walkMinutes: 12,
  ),
  TouristPlace(
    id: 'al_hussein_mosque',
    nameEn: 'Al-Hussein Mosque',
    nameAr: 'مسجد الحسين',
    descEn:
        'One of the holiest Islamic sites in Egypt, believed to house the head of Husayn ibn Ali. Vibrant surrounding square at night.',
    descAr:
        'من أقدس المواقع الإسلامية في مصر، يُعتقد أنه يضم رأس الحسين بن علي. ميدان نابض بالحياة ليلاً.',
    category: PlaceCategory.religious,
    image: 'assets/images/tourist/al_hussein_mosque.jpg',
    stationEn: 'ATABA',
    stationAr: 'العتبة',
    line: '2/3',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'sultan_hassan_mosque',
    nameEn: 'Sultan Hassan Mosque-Madrasa',
    nameAr: 'مسجد ومدرسة السلطان حسن',
    descEn:
        'Mamluk-era masterpiece from 1356, one of the largest mosques in the world with extraordinary architecture.',
    descAr:
        'تحفة معمارية من العصر المملوكي عام 1356، واحد من أكبر المساجد في العالم بعمارة استثنائية.',
    category: PlaceCategory.religious,
    image: 'assets/images/tourist/sultan_hassan_mosque.jpg',
    stationEn: 'SAYEDA ZEINAB',
    stationAr: 'السيدة زينب',
    line: '1',
    walkMinutes: 15,
    needsTransport: true,
  ),
  TouristPlace(
    id: 'ibn_tulun_mosque',
    nameEn: 'Ibn Tulun Mosque',
    nameAr: 'مسجد ابن طولون',
    descEn:
        'The oldest mosque in Cairo surviving in its original form (879 AD). Famous for its unique spiral minaret.',
    descAr:
        'أقدم مسجد في القاهرة بشكله الأصلي (879 م). اشتُهر بمئذنته اللولبية الفريدة.',
    category: PlaceCategory.religious,
    image: 'assets/images/tourist/ibn_tulun_mosque.jpg',
    stationEn: 'SAYEDA ZEINAB',
    stationAr: 'السيدة زينب',
    line: '1',
    walkMinutes: 15,
    needsTransport: true,
  ),
  TouristPlace(
    id: 'amr_mosque',
    nameEn: 'Amr Ibn El-As Mosque',
    nameAr: 'مسجد عمرو بن العاص',
    descEn:
        'The first mosque built in Egypt and all of Africa, founded in 642 AD after the Arab conquest of Egypt.',
    descAr:
        'أول مسجد بُني في مصر وأفريقيا، أسسه عمرو بن العاص عام 642 م بعد الفتح العربي لمصر.',
    category: PlaceCategory.religious,
    image: 'assets/images/tourist/amr_mosque.jpg',
    stationEn: 'MAR GIRGIS',
    stationAr: 'مار جرجس',
    line: '1',
    walkMinutes: 8,
  ),
  TouristPlace(
    id: 'sayeda_zeinab_mosque',
    nameEn: 'Sayeda Zeinab Mosque',
    nameAr: 'مسجد السيدة زينب',
    descEn:
        'Important shrine dedicated to Zeinab, granddaughter of Prophet Muhammad. A major spiritual center in Cairo.',
    descAr:
        'ضريح مهم مخصص للسيدة زينب حفيدة النبي محمد. مركز روحي رئيسي في القاهرة.',
    category: PlaceCategory.religious,
    image: 'assets/images/tourist/sayeda_zeinab_mosque.jpg',
    stationEn: 'SAYEDA ZEINAB',
    stationAr: 'السيدة زينب',
    line: '1',
    walkMinutes: 3,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // PARKS & GARDENS
  // ══════════════════════════════════════════════════════════════════════════
  TouristPlace(
    id: 'al_azhar_park',
    nameEn: 'Al-Azhar Park',
    nameAr: 'حديقة الأزهر',
    descEn:
        'A 30-hectare hilltop oasis with stunning views over Islamic Cairo, restaurants, and lush gardens. One of the world\'s 60 great public spaces.',
    descAr:
        'واحة على تل بمساحة 30 فداناً مع إطلالات مذهلة على القاهرة الإسلامية ومطاعم وحدائق خضراء.',
    category: PlaceCategory.park,
    image: 'assets/images/tourist/al_azhar_park.jpg',
    stationEn: 'BAB EL-SHARIA',
    stationAr: 'باب الشعرية',
    line: '3',
    walkMinutes: 15,
    needsTransport: true,
  ),
  TouristPlace(
    id: 'giza_zoo',
    nameEn: 'Giza Zoo (Cairo Zoo)',
    nameAr: 'حديقة حيوان الجيزة',
    descEn:
        'One of the oldest zoos in Africa, established in 1891. Home to rare animals and beautiful 19th-century gardens.',
    descAr:
        'واحدة من أقدم حدائق الحيوان في أفريقيا، أُسست عام 1891. تضم حيوانات نادرة وحدائق من القرن 19.',
    category: PlaceCategory.park,
    image: 'assets/images/tourist/giza_zoo.jpg',
    stationEn: 'CAIRO UNIVERSITY',
    stationAr: 'جامعة القاهرة',
    line: '2',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'orman_garden',
    nameEn: 'Orman Botanical Garden',
    nameAr: 'حديقة الأورمان النباتية',
    descEn:
        'Beautiful botanical garden with rare plants from around the world, established in 1875 as part of the Khedive\'s palace grounds.',
    descAr:
        'حديقة نباتية جميلة بها نباتات نادرة من حول العالم، أُسست عام 1875 كجزء من أراضي قصر الخديوي.',
    category: PlaceCategory.park,
    image: 'assets/images/tourist/orman_garden.jpg',
    stationEn: 'EL-DOKKI',
    stationAr: 'الدقي',
    line: '2',
    walkMinutes: 5,
  ),
  TouristPlace(
    id: 'japanese_garden',
    nameEn: 'Japanese Garden (Helwan)',
    nameAr: 'الحديقة اليابانية (حلوان)',
    descEn:
        'A unique Japanese-style garden with Buddha statues, bridges, and pagodas. Built in 1919, it offers a peaceful escape.',
    descAr:
        'حديقة فريدة على الطراز الياباني بها تماثيل بوذا وجسور ومعابد. بُنيت عام 1919 وتوفر ملاذاً هادئاً.',
    category: PlaceCategory.park,
    image: 'assets/images/tourist/japanese_garden.jpg',
    stationEn: 'AIN HELWAN',
    stationAr: 'عين حلوان',
    line: '1',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'al_fustat_garden',
    nameEn: 'Al-Fustat Garden',
    nameAr: 'حديقة الفسطاط',
    descEn:
        'One of Cairo\'s newest and largest parks, near Coptic Cairo, with open spaces, playgrounds, and walking paths.',
    descAr:
        'واحدة من أحدث وأكبر حدائق القاهرة، بالقرب من القاهرة القبطية، مع مساحات مفتوحة ومسارات للمشي.',
    category: PlaceCategory.park,
    image: 'assets/images/tourist/al_fustat_garden.jpg',
    stationEn: 'MAR GIRGIS',
    stationAr: 'مار جرجس',
    line: '1',
    walkMinutes: 8,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // SHOPPING & MARKETS
  // ══════════════════════════════════════════════════════════════════════════
  TouristPlace(
    id: 'khan_el_khalili',
    nameEn: 'Khan El Khalili',
    nameAr: 'خان الخليلي',
    descEn:
        'Cairo\'s legendary bazaar dating to 1382. Endless alleys of jewelry, spices, perfumes, lamps, and handcrafted souvenirs.',
    descAr:
        'بازار القاهرة الأسطوري الذي يعود لعام 1382. أزقة لا تنتهي من المجوهرات والتوابل والعطور والتحف.',
    category: PlaceCategory.shopping,
    image: 'assets/images/tourist/khan_el_khalili.jpg',
    stationEn: 'ATABA',
    stationAr: 'العتبة',
    line: '2/3',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'ataba_market',
    nameEn: 'Ataba Market',
    nameAr: 'سوق العتبة',
    descEn:
        'One of Cairo\'s busiest local markets. Great for electronics, books, stationery, and experiencing everyday Cairo life.',
    descAr:
        'من أكثر أسواق القاهرة ازدحاماً. رائع للإلكترونيات والكتب والقرطاسية وتجربة الحياة القاهرية اليومية.',
    category: PlaceCategory.shopping,
    image: 'assets/images/tourist/ataba_market.jpg',
    stationEn: 'ATABA',
    stationAr: 'العتبة',
    line: '2/3',
    walkMinutes: 2,
  ),
  TouristPlace(
    id: 'downtown_shopping',
    nameEn: 'Downtown Cairo (Talaat Harb)',
    nameAr: 'وسط البلد (طلعت حرب)',
    descEn:
        'Art deco streets with fashion shops, bookstores, and iconic cafes. The heart of modern Cairo\'s cultural and shopping scene.',
    descAr:
        'شوارع بطراز آرت ديكو بها محلات أزياء ومكتبات ومقاهٍ أيقونية. قلب مشهد الثقافة والتسوق في القاهرة.',
    category: PlaceCategory.shopping,
    image: 'assets/images/tourist/downtown_shopping.jpg',
    stationEn: 'SADAT',
    stationAr: 'السادات',
    line: '1/2',
    walkMinutes: 3,
  ),
  TouristPlace(
    id: 'wekalet_el_balah',
    nameEn: 'Wekalet El Balah',
    nameAr: 'وكالة البلح',
    descEn:
        'Famous market for fabrics, vintage clothing, curtains, and bargain shopping. A favorite for locals looking for great deals.',
    descAr:
        'سوق شهير للأقمشة والملابس القديمة والستائر والتسوق بأسعار مخفضة. مفضل للباحثين عن صفقات جيدة.',
    category: PlaceCategory.shopping,
    image: 'assets/images/tourist/wekalet_el_balah.jpg',
    stationEn: 'ROUD EL-FARAG',
    stationAr: 'روض الفرج',
    line: '2',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'el_fishawy_cafe',
    nameEn: 'El-Fishawy Cafe',
    nameAr: 'مقهى الفيشاوي',
    descEn:
        'Cairo\'s oldest cafe, open since 1773. Famous for mint tea, Turkish coffee, and shisha in the heart of Khan El Khalili.',
    descAr:
        'أقدم مقهى في القاهرة، مفتوح منذ 1773. مشهور بالشاي بالنعناع والقهوة التركية والشيشة في قلب خان الخليلي.',
    category: PlaceCategory.shopping,
    image: 'assets/images/tourist/el_fishawy_cafe.jpg',
    stationEn: 'ATABA',
    stationAr: 'العتبة',
    line: '2/3',
    walkMinutes: 10,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // CULTURE & ENTERTAINMENT
  // ══════════════════════════════════════════════════════════════════════════
  TouristPlace(
    id: 'cairo_opera_house',
    nameEn: 'Cairo Opera House',
    nameAr: 'دار الأوبرا المصرية',
    descEn:
        'Egypt\'s premier performing arts venue on Gezira Island. Hosts concerts, ballet, opera, and art exhibitions year-round.',
    descAr:
        'أهم مكان للفنون المسرحية في مصر بجزيرة الزمالك. يستضيف حفلات موسيقية وباليه وأوبرا ومعارض فنية.',
    category: PlaceCategory.culture,
    image: 'assets/images/tourist/cairo_opera_house.jpg',
    stationEn: 'OPERA',
    stationAr: 'الأوبرا',
    line: '2',
    walkMinutes: 5,
  ),
  TouristPlace(
    id: 'cairo_tower',
    nameEn: 'Cairo Tower',
    nameAr: 'برج القاهرة',
    descEn:
        'A 187-meter tower on Gezira Island offering 360° panoramic views of Cairo. Best visited at sunset.',
    descAr:
        'برج بارتفاع 187 متراً في جزيرة الزمالك يوفر إطلالات بانورامية 360° على القاهرة. يُفضل زيارته عند الغروب.',
    category: PlaceCategory.culture,
    image: 'assets/images/tourist/cairo_tower.jpg',
    stationEn: 'OPERA',
    stationAr: 'الأوبرا',
    line: '2',
    walkMinutes: 12,
  ),
  TouristPlace(
    id: 'tahrir_square',
    nameEn: 'Tahrir Square',
    nameAr: 'ميدان التحرير',
    descEn:
        'Cairo\'s most famous public square, a historic and cultural landmark. Recently renovated with the Ramses II obelisk.',
    descAr:
        'أشهر ميدان عام في القاهرة، معلم تاريخي وثقافي. تم تجديده مؤخراً مع مسلة رمسيس الثاني.',
    category: PlaceCategory.culture,
    image: 'assets/images/tourist/tahrir_square.jpg',
    stationEn: 'SADAT',
    stationAr: 'السادات',
    line: '1/2',
    walkMinutes: 1,
  ),
  TouristPlace(
    id: 'zamalek_district',
    nameEn: 'Zamalek District',
    nameAr: 'حي الزمالك',
    descEn:
        'Upscale island neighborhood with art galleries, boutique shops, international restaurants, and tree-lined streets.',
    descAr:
        'حي راقٍ في جزيرة بها معارض فنية ومحلات بوتيك ومطاعم عالمية وشوارع تصطف عليها الأشجار.',
    category: PlaceCategory.culture,
    image: 'assets/images/tourist/zamalek_district.jpg',
    stationEn: 'OPERA',
    stationAr: 'الأوبرا',
    line: '2',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'maspero_triangle',
    nameEn: 'Maspero Arts & Culture Triangle',
    nameAr: 'مثلث ماسبيرو للفنون والثقافة',
    descEn:
        'Newly developed area along the Nile with restaurants, cultural venues, and stunning riverfront views.',
    descAr:
        'منطقة حديثة التطوير على النيل بها مطاعم وأماكن ثقافية وإطلالات نهرية مذهلة.',
    category: PlaceCategory.culture,
    image: 'assets/images/tourist/maspero_triangle.jpg',
    stationEn: 'MASPERO',
    stationAr: 'ماسبيرو',
    line: '3',
    walkMinutes: 3,
  ),
  TouristPlace(
    id: 'beit_el_suhaymi',
    nameEn: 'Beit El-Suhaymi',
    nameAr: 'بيت السحيمي',
    descEn:
        'A beautifully restored 17th-century Ottoman-era house on Al-Muizz Street, showcasing traditional Cairo domestic architecture.',
    descAr:
        'منزل عثماني جميل من القرن 17 تم ترميمه في شارع المعز، يعرض العمارة المنزلية القاهرية التقليدية.',
    category: PlaceCategory.culture,
    image: 'assets/images/tourist/beit_el_suhaymi.jpg',
    stationEn: 'BAB EL-SHARIA',
    stationAr: 'باب الشعرية',
    line: '3',
    walkMinutes: 15,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // NILE EXPERIENCES
  // ══════════════════════════════════════════════════════════════════════════
  TouristPlace(
    id: 'nile_corniche',
    nameEn: 'Nile Corniche Walk',
    nameAr: 'كورنيش النيل',
    descEn:
        'Scenic riverside promenade perfect for sunset walks, street food, and views of Cairo\'s skyline along the Nile.',
    descAr:
        'كورنيش نهري خلاب مثالي للمشي عند الغروب وطعام الشارع ومناظر أفق القاهرة على النيل.',
    category: PlaceCategory.nile,
    image: 'assets/images/tourist/nile_corniche.jpg',
    stationEn: 'OPERA',
    stationAr: 'الأوبرا',
    line: '2',
    walkMinutes: 3,
  ),
  TouristPlace(
    id: 'felucca_ride',
    nameEn: 'Felucca Rides',
    nameAr: 'ركوب الفلوكة',
    descEn:
        'Traditional Egyptian sailboat experience on the Nile. Especially beautiful at sunset. Boats available near Gezira docks.',
    descAr:
        'تجربة قارب شراعي مصري تقليدي على النيل. جميلة بشكل خاص عند الغروب. القوارب متاحة بالقرب من أرصفة الجزيرة.',
    category: PlaceCategory.nile,
    image: 'assets/images/tourist/felucca_ride.jpg',
    stationEn: 'OPERA',
    stationAr: 'الأوبرا',
    line: '2',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'nile_dinner_cruise',
    nameEn: 'Nile Dinner Cruise',
    nameAr: 'رحلة عشاء نيلية',
    descEn:
        'Evening dinner cruises with live music, belly dancing, and views of illuminated Cairo from the river.',
    descAr:
        'رحلات عشاء مسائية مع موسيقى حية ورقص شرقي ومناظر القاهرة المضاءة من النهر.',
    category: PlaceCategory.nile,
    image: 'assets/images/tourist/nile_dinner_cruise.jpg',
    stationEn: 'SADAT',
    stationAr: 'السادات',
    line: '1/2',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'qasr_el_nil_bridge',
    nameEn: 'Qasr El Nil Bridge',
    nameAr: 'كوبري قصر النيل',
    descEn:
        'Famous bridge with iconic lion statues, connecting Tahrir Square to Gezira Island. Popular for evening walks and photos.',
    descAr:
        'جسر شهير بتماثيل الأسود الأيقونية، يربط ميدان التحرير بجزيرة الزمالك. شائع للمشي المسائي والتصوير.',
    category: PlaceCategory.nile,
    image: 'assets/images/tourist/qasr_el_nil_bridge.jpg',
    stationEn: 'SADAT',
    stationAr: 'السادات',
    line: '1/2',
    walkMinutes: 5,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // HIDDEN GEMS & LOCAL FAVORITES
  // ══════════════════════════════════════════════════════════════════════════
  TouristPlace(
    id: 'manial_palace',
    nameEn: 'Manial Palace Museum',
    nameAr: 'متحف قصر المنيل',
    descEn:
        'Elegant royal palace on Roda Island built in early 1900s, with diverse architectural styles and beautiful gardens.',
    descAr:
        'قصر ملكي أنيق في جزيرة الروضة بُني في أوائل القرن العشرين، بأنماط معمارية متنوعة وحدائق جميلة.',
    category: PlaceCategory.hiddenGem,
    image: 'assets/images/tourist/manial_palace.jpg',
    stationEn: 'SAQYET MAKKI',
    stationAr: 'ساقية مكي',
    line: '2',
    walkMinutes: 15,
  ),
  TouristPlace(
    id: 'nilometer',
    nameEn: 'Nilometer (Roda Island)',
    nameAr: 'مقياس النيل (جزيرة الروضة)',
    descEn:
        'Ancient instrument used to measure the Nile\'s water level, dating to 861 AD. One of the oldest Islamic-era structures in Egypt.',
    descAr:
        'أداة قديمة لقياس منسوب مياه النيل، تعود لعام 861 م. واحدة من أقدم المنشآت في العصر الإسلامي بمصر.',
    category: PlaceCategory.hiddenGem,
    image: 'assets/images/tourist/nilometer.jpg',
    stationEn: 'EL-MALEK EL-SALEH',
    stationAr: 'الملك الصالح',
    line: '1',
    walkMinutes: 15,
  ),
  TouristPlace(
    id: 'heliopolis_basilica',
    nameEn: 'Basilica of Our Lady (Heliopolis)',
    nameAr: 'كنيسة البازيليك (مصر الجديدة)',
    descEn:
        'Beautiful basilica with Byzantine-Romanesque architecture, built in 1910 in the heart of historic Heliopolis.',
    descAr:
        'كنيسة جميلة بعمارة بيزنطية رومانسكية، بُنيت عام 1910 في قلب مصر الجديدة التاريخية.',
    category: PlaceCategory.hiddenGem,
    image: 'assets/images/tourist/heliopolis_basilica.jpg',
    stationEn: 'KOLLEYET EL-BANAT',
    stationAr: 'كلية البنات',
    line: '3',
    walkMinutes: 10,
  ),
  TouristPlace(
    id: 'helwan_wax_museum',
    nameEn: 'Helwan Wax Museum',
    nameAr: 'متحف الشمع بحلوان',
    descEn:
        'A small but fascinating wax museum depicting key moments in Egyptian history from ancient Pharaohs to the modern era.',
    descAr:
        'متحف شمع صغير لكنه رائع يصور لحظات رئيسية في التاريخ المصري من الفراعنة القدماء إلى العصر الحديث.',
    category: PlaceCategory.hiddenGem,
    image: 'assets/images/tourist/helwan_wax_museum.jpg',
    stationEn: 'AIN HELWAN',
    stationAr: 'عين حلوان',
    line: '1',
    walkMinutes: 12,
  ),
  TouristPlace(
    id: 'ain_shams_obelisk',
    nameEn: 'Obelisk of Senusret I (Ancient Heliopolis)',
    nameAr: 'مسلة سنوسرت الأول (هليوبوليس القديمة)',
    descEn:
        'Site of the ancient city of Heliopolis, one of the oldest cities of antiquity. The obelisk of Senusret I still stands after 4,000 years.',
    descAr:
        'موقع مدينة هليوبوليس القديمة، واحدة من أقدم مدن العصور القديمة. لا تزال مسلة سنوسرت الأول قائمة منذ 4000 عام.',
    category: PlaceCategory.hiddenGem,
    image: 'assets/images/tourist/ain_shams_obelisk.jpg',
    stationEn: 'AIN SHAMS',
    stationAr: 'عين شمس',
    line: '1',
    walkMinutes: 8,
  ),
  TouristPlace(
    id: 'corniche_maadi',
    nameEn: 'Corniche El Maadi',
    nameAr: 'كورنيش المعادي',
    descEn:
        'Riverside promenade in the leafy Maadi district, popular with families. Nearby restaurants, shops, and river views.',
    descAr:
        'كورنيش نهري في حي المعادي الأخضر، شائع بين العائلات. مطاعم ومحلات ومناظر نهرية قريبة.',
    category: PlaceCategory.hiddenGem,
    image: 'assets/images/tourist/corniche_maadi.jpg',
    stationEn: 'MAADI',
    stationAr: 'المعادي',
    line: '1',
    walkMinutes: 10,
  ),
];
