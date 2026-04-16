// ─────────────────────────────────────────────────────────────────────────────
// Egypt city destinations — transport options + top places for 10 cities
//
// All travel times are approximate and sourced from public transport schedules.
// Prices and schedules change; users should verify before travelling.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// ── Transport App ─────────────────────────────────────────────────────────────

class TransportApp {
  final String name;
  final String? androidUrl;
  final String? iosUrl;

  const TransportApp({required this.name, this.androidUrl, this.iosUrl});
}

const kAppEgyptAir = TransportApp(
  name: 'EgyptAir',
  androidUrl:
      'https://play.google.com/store/apps/details?id=com.linkdev.egyptair.app',
  iosUrl: 'https://apps.apple.com/eg/app/egyptair/id591656508',
);

const kAppGoBus = TransportApp(
  name: 'Go Bus',
  androidUrl:
      'https://play.google.com/store/apps/details?id=com.gobuseg&pli=1',
  iosUrl: 'https://apps.apple.com/eg/app/gobus/id906296061',
);

const kAppBlueBus = TransportApp(
  name: 'Blue Bus',
  androidUrl:
      'https://play.google.com/store/apps/details?id=com.nativeapp.bluebusmobile',
  iosUrl: 'https://apps.apple.com/eg/app/blue-bus/id6670766963',
);

const kAppENR = TransportApp(
  name: 'Egyptian National Railways',
  androidUrl:
      'https://play.google.com/store/apps/details?id=enr.transit.maf&hl=en',
  iosUrl:
      'https://apps.apple.com/eg/app/egyptian-national-railway/id1486815902',
);

// ── Transport Mode ────────────────────────────────────────────────────────────

enum TransportMode {
  flight,
  sleeperTrain,
  train,
  bus,
  car,
  nileCruise,
  busFromSharm,
}

// ── Transport Option ──────────────────────────────────────────────────────────

class TransportOption {
  final TransportMode mode;

  /// Locale-keyed travel-time string.  Falls back to 'en'.
  final Map<String, String> travelTime;
  final List<TransportApp> apps;

  const TransportOption({
    required this.mode,
    required this.travelTime,
    required this.apps,
  });

  String time(String locale) => travelTime[locale] ?? travelTime['en']!;
}

// ── City Place ────────────────────────────────────────────────────────────────

class CityPlace {
  final Map<String, String> names;
  final Map<String, String> descs;
  final String image; // asset path

  const CityPlace({
    required this.names,
    required this.descs,
    required this.image,
  });

  String name(String locale) => names[locale] ?? names['en']!;
  String desc(String locale) => descs[locale] ?? descs['en']!;
}

// ── Egypt City ────────────────────────────────────────────────────────────────

class EgyptCity {
  final String id;
  final Map<String, String> names;
  final Map<String, String> descriptions;
  final List<Color> gradientColors;
  final Color accentColor;
  final String emoji;
  final String heroImage; // asset path
  final List<TransportOption> transportOptions;
  final List<CityPlace> places;

  const EgyptCity({
    required this.id,
    required this.names,
    required this.descriptions,
    required this.gradientColors,
    required this.accentColor,
    required this.emoji,
    required this.heroImage,
    required this.transportOptions,
    required this.places,
  });

  String name(String locale) => names[locale] ?? names['en']!;
  String description(String locale) =>
      descriptions[locale] ?? descriptions['en']!;
}

// ─────────────────────────────────────────────────────────────────────────────
// All 10 Egypt Destinations
// ─────────────────────────────────────────────────────────────────────────────

const egyptCities = <EgyptCity>[
  // ── 1. Alexandria ────────────────────────────────────────────────────────────
  EgyptCity(
    id: 'alexandria',
    names: {
      'en': 'Alexandria',
      'ar': 'الإسكندرية',
      'de': 'Alexandria',
      'fr': 'Alexandrie',
      'es': 'Alejandría',
      'it': 'Alessandria d\'Egitto',
      'pt': 'Alexandria',
      'ru': 'Александрия',
      'tr': 'İskenderiye',
      'ja': 'アレクサンドリア',
      'zh': '亚历山大',
    },
    descriptions: {
      'en':
          'Egypt\'s Pearl of the Mediterranean — Bibliotheca Alexandrina, the Citadel of Qaitbay, catacombs, and a stunning 20 km corniche overlooking the sea.',
      'ar':
          'لؤلؤة البحر المتوسط — مكتبة الإسكندرية وقلعة قايتباي والمقابر الرومانية وكورنيش رائع بطول 20 كيلومترًا يطل على البحر.',
      'de':
          'Ägyptens Perle des Mittelmeers — Bibliotheca Alexandrina, Zitadelle von Qaitbay, Katakomben und eine 20 km lange Uferpromenade.',
      'fr':
          'La Perle de la Méditerranée — Bibliotheca Alexandrina, citadelle de Qaitbay, catacombes et une corniche de 20 km face à la mer.',
      'es':
          'La Perla del Mediterráneo — Bibliotheca Alexandrina, Ciudadela de Qaitbay, catacumbas y una corniche de 20 km frente al mar.',
      'it':
          'La Perla del Mediterraneo — Bibliotheca Alexandrina, Cittadella di Qaitbay, catacombe e una corniche di 20 km affacciata sul mare.',
      'pt':
          'A Pérola do Mediterrâneo — Bibliotheca Alexandrina, Cidadela de Qaitbay, catacumbas e uma bela avenida costeira de 20 km.',
      'ru':
          'Жемчужина Средиземноморья — Александрийская библиотека, крепость Кайт-бей, катакомбы и 20-километровая набережная.',
      'tr':
          'Akdeniz\'in İncisi — Bibliotheca Alexandrina, Kayıtbay Kalesi, katakombler ve 20 km\'lik deniz manzaralı kordon.',
      'ja':
          '地中海の真珠——アレクサンドリア図書館、カーイトバーイの要塞、カタコンベ、20キロのコルニーシュが魅力。',
      'zh': '地中海明珠——亚历山大图书馆、盖特贝城堡、地下墓穴和20公里的滨海大道。',
    },
    gradientColors: [Color(0xFF005F87), Color(0xFF0096C7)],
    accentColor: Color(0xFF0096C7),
    emoji: '🏛️',
    heroImage: 'assets/images/tourist/Alexandria/Bibliotheca_Alexandrina.jpg',
    transportOptions: [
      TransportOption(
        mode: TransportMode.train,
        travelTime: {'en': '~2.5 hours', 'ar': '~٢.٥ ساعات'},
        apps: [kAppENR],
      ),
      TransportOption(
        mode: TransportMode.bus,
        travelTime: {'en': '~3 hours', 'ar': '~٣ ساعات'},
        apps: [kAppGoBus],
      ),
    ],
    places: [
      CityPlace(
        names: {
          'en': 'Bibliotheca Alexandrina',
          'ar': 'مكتبة الإسكندرية',
          'de': 'Bibliotheca Alexandrina',
          'fr': 'Bibliotheca Alexandrina',
          'es': 'Bibliotheca Alexandrina',
          'it': 'Bibliotheca Alexandrina',
          'pt': 'Bibliotheca Alexandrina',
          'ru': 'Библиотека Александрина',
          'tr': 'Bibliotheca Alexandrina',
          'ja': 'アレクサンドリア図書館',
          'zh': '亚历山大图书馆',
        },
        descs: {
          'en':
              'Modern marvel built on the site of the ancient Library of Alexandria — hosts millions of books, museums, and art galleries.',
          'ar':
              'تحفة معمارية حديثة على موقع المكتبة الأسطورية القديمة — تضم ملايين الكتب والمتاحف وقاعات العرض.',
          'de':
              'Moderne Ikone am Ort der antiken Bibliothek von Alexandria — beherbergt Millionen Bücher, Museen und Kunstgalerien.',
          'fr':
              'Merveille moderne sur le site de l\'antique bibliothèque d\'Alexandrie — des millions de livres, musées et galeries d\'art.',
          'es':
              'Maravilla moderna en el emplazamiento de la antigua Biblioteca de Alejandría — millones de libros, museos y galerías de arte.',
          'it':
              'Capolavoro moderno sul sito dell\'antica Biblioteca di Alessandria — milioni di libri, musei e gallerie d\'arte.',
          'pt':
              'Maravilha moderna no local da antiga Biblioteca de Alexandria — milhões de livros, museus e galerias de arte.',
          'ru':
              'Современный шедевр на месте древней Александрийской библиотеки — миллионы книг, музеи и художественные галереи.',
          'tr':
              'Antik İskenderiye Kütüphanesi\'nin bulunduğu yerde modern bir harika — milyonlarca kitap, müze ve sanat galerisi.',
          'ja':
              '古代アレクサンドリア図書館の跡に建つ現代の驚異——数百万の蔵書、博物館、アートギャラリー。',
          'zh': '建于古亚历山大图书馆遗址上的现代奇迹——藏书数百万，并设有博物馆与美术馆。',
        },
        image:
            'assets/images/tourist/Alexandria/Bibliotheca_Alexandrina.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Citadel of Qaitbay',
          'ar': 'قلعة قايتباي',
          'de': 'Zitadelle von Qaitbay',
          'fr': 'Citadelle de Qaitbay',
          'es': 'Ciudadela de Qaitbay',
          'it': 'Cittadella di Qaitbay',
          'pt': 'Cidadela de Qaitbay',
          'ru': 'Цитадель Кайт-бей',
          'tr': 'Kayıtbay Kalesi',
          'ja': 'カーイトバーイの要塞',
          'zh': '盖特贝城堡',
        },
        descs: {
          'en':
              '15th-century Mamluk fortress on the Mediterranean, built on the exact site of the ancient Pharos lighthouse.',
          'ar':
              'قلعة مملوكية من القرن 15 على البحر المتوسط، شُيّدت فوق موقع فنار الإسكندرية القديم بالضبط.',
          'de':
              'Mamlukenfestung aus dem 15. Jh. am Mittelmeer, errichtet genau am Standort des antiken Pharos-Leuchtturms.',
          'fr':
              'Forteresse mamlouke du XVe siècle sur la Méditerranée, érigée à l\'emplacement exact de l\'ancien phare de Pharos.',
          'es':
              'Fortaleza mameluca del siglo XV en el Mediterráneo, construida en el mismo lugar del antiguo faro de Faro.',
          'it':
              'Fortezza mamelucca del XV secolo sul Mediterraneo, edificata sul sito esatto dell\'antico faro di Faro.',
          'pt':
              'Fortaleza maméluca do século XV no Mediterrâneo, erguida no local exato do antigo farol de Faros.',
          'ru':
              'Мамлюкская крепость XV века на Средиземном море, построена точно на месте древнего Фаросского маяка.',
          'tr':
              'Akdeniz kıyısında 15. yüzyıl Memlük kalesi, antik Faros fenerinin tam üzerine inşa edilmiştir.',
          'ja':
              '15世紀のマムルーク朝の要塞。地中海に面し、古代ファロス灯台があった正確な場所に建つ。',
          'zh': '15世纪马穆鲁克要塞，位于地中海畔，建在古法罗斯灯塔的原址上。',
        },
        image: 'assets/images/tourist/Alexandria/Citadel_of_Qaitbay.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Roman Amphitheatre',
          'ar': 'المدرج الروماني (كوم الدكة)',
          'de': 'Römisches Amphitheater (Kom el-Dikka)',
          'fr': 'Amphithéâtre romain (Kom el-Dikka)',
          'es': 'Anfiteatro romano (Kom el-Dikka)',
          'it': 'Anfiteatro romano (Kom el-Dikka)',
          'pt': 'Anfiteatro romano (Kom el-Dikka)',
          'ru': 'Римский амфитеатр (Ком эль-Дикка)',
          'tr': 'Roma Amfitiyatrosu (Kom el-Dikka)',
          'ja': 'ローマ円形劇場（コム・エル＝ディッカ）',
          'zh': '罗马圆形剧场（科姆埃尔迪卡）',
        },
        descs: {
          'en':
              'Egypt\'s only intact Roman theatre with 13 terraced marble rows, dating from the 4th century AD.',
          'ar':
              'المسرح الروماني الوحيد المحفوظ في مصر بـ13 صفًا من الرخام المتدرج، يعود للقرن الرابع الميلادي.',
          'de':
              'Ägyptens einziges erhaltenes römisches Theater mit 13 Marmorrängen aus dem 4. Jahrhundert n. Chr.',
          'fr':
              'Le seul théâtre romain intact d\'Égypte, avec 13 gradins en marbre datant du IVe siècle apr. J.-C.',
          'es':
              'El único teatro romano intacto de Egipto, con 13 gradas de mármol del siglo IV d. C.',
          'it':
              'L\'unico teatro romano intatto d\'Egitto, con 13 file di marmo a terrazze del IV secolo d.C.',
          'pt':
              'O único teatro romano intacto do Egito, com 13 fileiras de mármore do século IV d.C.',
          'ru':
              'Единственный сохранившийся римский театр Египта с 13 мраморными рядами, IV век н. э.',
          'tr':
              'Mısır\'daki tek sağlam Roma tiyatrosu; 13 mermer sıra, MS 4. yüzyıldan.',
          'ja':
              'エジプトで唯一残るローマ劇場。大理石の13段の観客席、4世紀の遺構。',
          'zh': '埃及唯一保存完好的罗马剧场，有13排大理石阶梯座位，可追溯至公元4世纪。',
        },
        image:
            'assets/images/tourist/Alexandria/Roman_Amphitheatre_Kom_El_Dikka.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Catacombs of Kom El Shoqafa',
          'ar': 'مقابر كوم الشقافة',
          'de': 'Katakomben von Kom el-Schukafa',
          'fr': 'Catacombes de Kom el-Choqafa',
          'es': 'Catacumbas de Kom el Shoqafa',
          'it': 'Catacombe di Kom el Shoqafa',
          'pt': 'Catacumbas de Kom el Shoqafa',
          'ru': 'Катакомбы Ком-эш-Шукафа',
          'tr': 'Kom eş-Şukafe Yeraltı Mezarlığı',
          'ja': 'コム・エル・ショカファの地下墓地',
          'zh': '考姆舒卡法地下墓穴',
        },
        descs: {
          'en':
              'Multi-level Roman burial complex blending Egyptian, Greek, and Roman art — one of the Seven Wonders of the Middle Ages.',
          'ar':
              'مجمع جنائزي متعدد الطوابق يمزج الفنون المصرية واليونانية والرومانية — أحد عجائب العصور الوسطى السبع.',
          'de':
              'Mehrstufiger römischer Grabkomplex mit ägyptischer, griechischer und römischer Kunst — eines der sieben Wunder des Mittelalters.',
          'fr':
              'Complexe funéraire romain à plusieurs niveaux mêlant l\'art égyptien, grec et romain — l\'une des sept merveilles du Moyen Âge.',
          'es':
              'Complejo funerario romano de varios niveles que fusiona arte egipcio, griego y romano — una de las Siete Maravillas de la Edad Media.',
          'it':
              'Complesso funerario romano su più livelli che fonde arte egizia, greca e romana — una delle sette meraviglie del Medioevo.',
          'pt':
              'Complexo funerário romano em vários níveis que mistura arte egípcia, grega e romana — uma das Sete Maravilhas da Idade Média.',
          'ru':
              'Многоуровневый римский некрополь, сочетающий египетское, греческое и римское искусство — одно из семи чудес Средневековья.',
          'tr':
              'Mısır, Yunan ve Roma sanatını harmanlayan çok katlı Roma mezarlığı — Ortaçağ\'ın yedi harikasından biri.',
          'ja':
              'エジプト・ギリシャ・ローマの芸術が融合した多層のローマ時代の地下墓地——中世七不思議の一つ。',
          'zh': '多层罗马墓葬群，融合埃及、希腊与罗马艺术——中世纪七大奇迹之一。',
        },
        image:
            'assets/images/tourist/Alexandria/Catacombs_of_Kom_El_Shoqafa.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Montaza Palace & Gardens',
          'ar': 'قصر وحدائق المنتزه',
          'de': 'Montaza-Palast & Gärten',
          'fr': 'Palais et jardins de Montaza',
          'es': 'Palacio y jardines de Montaza',
          'it': 'Palazzo e giardini di Montaza',
          'pt': 'Palácio e jardins de Montaza',
          'ru': 'Дворец и сады Монтазы',
          'tr': 'Montaza Sarayı ve Bahçeleri',
          'ja': 'モンタザ宮殿と庭園',
          'zh': '蒙塔扎宫与花园',
        },
        descs: {
          'en':
              'Royal gardens and Khedival palaces on a beautiful seafront headland — perfect for a peaceful afternoon stroll.',
          'ar':
              'حدائق ملكية وقصور خديوية على رأس بحري خلاب — رائعة للتنزه في أجواء هادئة.',
          'de':
              'Königliche Gärten und Khedivenpaläste auf einer malerischen Landzunge am Meer — ideal für einen ruhigen Nachmittagsspaziergang.',
          'fr':
              'Jardins royaux et palais khédiviaux sur une presqu\'île maritime magnifique — parfaits pour une promenade tranquille.',
          'es':
              'Jardines reales y palacios jedivales en un cabo marítimo precioso — perfectos para un paseo tranquilo por la tarde.',
          'it':
              'Giardini reali e palazzi khedivali su un promontorio sul mare — ideali per una passeggiata pomeridiana in pace.',
          'pt':
              'Jardins reais e palácios chedivais num cabo marítimo deslumbrante — perfeitos para um passeio tranquilo à tarde.',
          'ru':
              'Королевские сады и дворцы хедивов на живописном морском мысе — идеально для неспешной прогулки.',
          'tr':
              'Denize uzanan güzel bir burunda kraliyet bahçeleri ve hidiv sarayları — huzurlu bir öğleden sonra yürüyüşü için ideal.',
          'ja':
              '美しい海岬にある王室の庭園とヘディーヴ朝の宮殿——穏やかな午後の散歩に最適。',
          'zh': '海滨半岛上的皇家花园与赫迪夫宫殿——适合悠闲午后漫步。',
        },
        image: 'assets/images/tourist/Alexandria/Montaza_Palace.jpg',
      ),
      CityPlace(
        names: {
          'en': "Pompey's Pillar",
          'ar': 'عمود بومبي',
          'de': 'Pompeius-Säule',
          'fr': 'Colonne de Pompée',
          'es': 'Columna de Pompeyo',
          'it': 'Colonna di Pompeo',
          'pt': 'Coluna de Pompeu',
          'ru': 'Колонна Помпея',
          'tr': 'Pompey Sütunu',
          'ja': 'ポンペイの柱',
          'zh': '庞培柱',
        },
        descs: {
          'en':
              'A 27 m Roman victory column of red Aswan granite — one of the tallest monolithic columns ever erected.',
          'ar':
              'عمود روماني نصر بارتفاع 27 مترًا من الجرانيت الأسواني الأحمر — من أطول الأعمدة المنفردة في التاريخ.',
          'de':
              '27 m hohe römische Siegessäule aus rotem Assuan-Granit — eine der höchsten je errichteten Monolithsäulen.',
          'fr':
              'Colonne romaine de victoire de 27 m en granite rouge d\'Assouan — l\'une des plus hautes colonnes monolithiques jamais érigées.',
          'es':
              'Columna romana de victoria de 27 m de granito rojo de Asuán — una de las columnas monolíticas más altas jamás erigidas.',
          'it':
              'Colonna romana di vittoria alta 27 m in granito rosso di Assuan — tra le colonne monolitiche più alte mai erette.',
          'pt':
              'Coluna romana de vitória de 27 m em granito vermelho de Assuã — uma das colunas monolíticas mais altas já erguidas.',
          'ru':
              'Римская триумфальная колонна высотой 27 м из красного асванского гранита — одна из самых высоких монолитных колонн в истории.',
          'tr':
              'Kırmızı Asvan granitinden 27 m yüksekliğinde Roma zafer sütunu — tarihin en yüksek monolit sütunlarından biri.',
          'ja':
              'アスワンの赤御影石で造られた高さ27mのローマの記念柱——史上最高クラスの一枚岩の柱の一つ。',
          'zh': '高27米的罗马胜利柱，红色阿斯旺花岗岩——史上最高的独石柱之一。',
        },
        image: "assets/images/tourist/Alexandria/Pompey's_Pillar.jpg",
      ),
      CityPlace(
        names: {
          'en': 'Stanley Bridge',
          'ar': 'كوبري ستانلي',
          'de': 'Stanley-Brücke',
          'fr': 'Pont Stanley',
          'es': 'Puente Stanley',
          'it': 'Ponte Stanley',
          'pt': 'Ponte Stanley',
          'ru': 'Мост Стэнли',
          'tr': 'Stanley Köprüsü',
          'ja': 'スタンレー橋',
          'zh': '斯坦利桥',
        },
        descs: {
          'en':
              'Iconic seafront bridge framing a postcard beach — the most photographed spot on the Alexandria corniche.',
          'ar':
              'جسر بحري أيقوني يؤطر شاطئًا مذهلًا — الموقع الأكثر تصويرًا على كورنيش الإسكندرية.',
          'de':
              'Ikonische Uferbrücke mit Postkartenstrand — der meistfotografierte Ort an der Alexandriner Corniche.',
          'fr':
              'Pont emblématique sur le front de mer encadrant une plage de carte postale — le lieu le plus photographié de la corniche d\'Alexandrie.',
          'es':
              'Puente costero icónico que enmarca una playa de postal — el rincón más fotografiado del paseo marítimo de Alejandría.',
          'it':
              'Iconico ponte sul lungomare che incornicia una spiaggio da cartolina — il punto più fotografato del lungomare di Alessandria.',
          'pt':
              'Ponte icónica à beira-mar que emoldura uma praia de postal — o local mais fotografado da Corniche de Alexandria.',
          'ru':
              'Знаменитый морской мост с видом на пляж как на открытке — самое фотографируемое место александрийской набережной.',
          'tr':
              'Kartpostallık plajı çerçeveleyen simgesel sahil köprüsü — İskenderiye kordonunun en çok fotoğraflanan noktası.',
          'ja':
              '絵葉書のようなビーチを望む海辺の名橋——アレクサンドリア・コルニーシュで最も写真に収められるスポット。',
          'zh': '标志性的海滨大桥，框住明信片般的海滩——亚历山大滨海大道上最常被拍摄的地点。',
        },
        image: 'assets/images/tourist/Alexandria/Stanley_Bridge.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Abu Abbas Al-Mursi Mosque',
          'ar': 'مسجد أبو العباس المرسي',
          'de': 'Moschee Abu el-Abbas el-Mursi',
          'fr': 'Mosquée Abu el-Abbas el-Morsi',
          'es': 'Mezquita Abu el-Abbas al-Mursi',
          'it': 'Moschea Abu el-Abbas al-Mursi',
          'pt': 'Mesquita Abu el-Abbas al-Mursi',
          'ru': 'Мечеть Абу аль-Аббаса аль-Мурси',
          'tr': 'Ebu\'l-Abbas el-Mursi Camii',
          'ja': 'アブ・アル＝アッバース・アル＝ムルシー清真寺',
          'zh': '阿布阿巴斯穆尔西清真寺',
        },
        descs: {
          'en':
              'One of the largest and most beautiful mosques in Alexandria, with stunning Andalusian-inspired architecture.',
          'ar':
              'من أكبر وأجمل مساجد الإسكندرية، بهندسة معمارية أندلسية أخّاذة.',
          'de':
              'Eine der größten und schönsten Moscheen Alexandriens mit beeindruckender andalusisch inspirierter Architektur.',
          'fr':
              'L\'une des plus grandes et plus belles mosquées d\'Alexandrie, à l\'architecture d\'inspiration andalouse saisissante.',
          'es':
              'Una de las mezquitas más grandes y hermosas de Alejandría, con una arquitectura de inspiración andaluza espectacular.',
          'it':
              'Una delle più grandi e belle moschee di Alessandria, con un\'architettura di ispirazione andalusa mozzafiato.',
          'pt':
              'Uma das maiores e mais belas mesquitas de Alexandria, com arquitetura de inspiração andaluza deslumbrante.',
          'ru':
              'Одна из крупнейших и красивейших мечетей Александрии с потрясающей архитектурой в андалузском духе.',
          'tr':
              'İskenderiye\'nin en büyük ve en güzel camilerinden biri; etkileyici Endülüs esintili mimari.',
          'ja':
              'アレクサンドリア最大級で美しいモスクの一つ。アンダルシア風の壮麗な建築。',
          'zh': '亚历山大最大、最美的清真寺之一，建筑带有动人的安达卢西亚风格。',
        },
        image: 'assets/images/tourist/Alexandria/Abu_Abbas_Mosque.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Alexandria Corniche',
          'ar': 'كورنيش الإسكندرية',
          'de': 'Alexandria Corniche',
          'fr': 'Corniche d\'Alexandrie',
          'es': 'Corniche de Alejandría',
          'it': 'Corniche di Alessandria',
          'pt': 'Corniche de Alexandria',
          'ru': 'Александрийская набережная',
          'tr': 'İskenderiye Kordonu',
          'ja': 'アレクサンドリア・コルニーシュ',
          'zh': '亚历山大滨海大道',
        },
        descs: {
          'en':
              'A 20 km seafront promenade lined with historic hotels, cafés, and uninterrupted Mediterranean views.',
          'ar':
              'كورنيش بحري بطول 20 كيلومترًا تصطف على جانبيه الفنادق التاريخية والمقاهي مع إطلالات متوسطية بلا حدود.',
          'de':
              '20 km lange Uferpromenade mit historischen Hotels, Cafés und ununterbrochenem Mittelmeerblick.',
          'fr':
              'Promenade maritime de 20 km bordée d\'hôtels historiques, de cafés et de vues ininterrompues sur la Méditerranée.',
          'es':
              'Paseo marítimo de 20 km con hoteles históricos, cafés y vistas ininterrumpidas al Mediterráneo.',
          'it':
              'Lungomare di 20 km con hotel storici, caffè e vista continua sul Mediterraneo.',
          'pt':
              'Avenida costeira de 20 km com hotéis históricos, cafés e vista ininterrupta para o Mediterrâneo.',
          'ru':
              '20-километровая набережная с историческими отелями, кафе и непрерывным видом на Средиземное море.',
          'tr':
              'Tarihi oteller, kafeler ve kesintisiz Akdeniz manzarasıyla 20 km sahil yürüyüş yolu.',
          'ja':
              '歴史あるホテルやカフェが並ぶ20kmの海辺の遊歩道——途切れない地中海の眺望。',
          'zh': '20公里海滨步道，两旁是历史酒店与咖啡馆，地中海风光一览无遗。',
        },
        image: 'assets/images/tourist/Alexandria/Corniche_Alexandria.jpg',
      ),
    ],
  ),

  // ── 2. Luxor ─────────────────────────────────────────────────────────────────
  EgyptCity(
    id: 'luxor',
    names: {
      'en': 'Luxor',
      'ar': 'الأقصر',
      'de': 'Luxor',
      'fr': 'Louxor',
      'es': 'Luxor',
      'it': 'Luxor',
      'pt': 'Luxor',
      'ru': 'Луксор',
      'tr': 'Lüksör',
      'ja': 'ルクソール',
      'zh': '卢克索',
    },
    descriptions: {
      'en':
          'The world\'s greatest open-air museum — Valley of the Kings, Karnak Temple, and centuries of Pharaonic glory await on both banks of the Nile.',
      'ar':
          'أعظم متحف مكشوف في العالم — وادي الملوك ومعبد الكرنك وقرون من الأمجاد الفرعونية تنتظرك على ضفتي النيل.',
      'de':
          'Das größte Freilichtmuseum der Welt — Tal der Könige, Karnak-Tempel und Jahrhunderte pharaonischer Pracht auf beiden Nilufern.',
      'fr':
          'Le plus grand musée à ciel ouvert du monde — Vallée des Rois, temple de Karnak et des siècles de splendeur pharaonique sur les deux rives du Nil.',
      'es':
          'El mayor museo al aire libre del mundo — Valle de los Reyes, Templo de Karnak y siglos de gloria faraónica en ambas orillas del Nilo.',
      'it':
          'Il più grande museo a cielo aperto del mondo — Valle dei Re, Tempio di Karnak e secoli di gloria faraonica su entrambe le sponde del Nilo.',
      'pt':
          'O maior museu ao ar livre do mundo — Vale dos Reis, Templo de Karnak e séculos de glória faraónica em ambas as margens do Nilo.',
      'ru':
          'Крупнейший в мире музей под открытым небом — Долина царей, Карнакский храм и величие фараонов на обоих берегах Нила.',
      'tr':
          'Dünyanın en büyük açık hava müzesi — Krallar Vadisi, Karnak Tapınağı ve Nil\'in her iki yakasında yüzyıllık firavun ihtişamı.',
      'ja':
          '世界最大の野外博物館——王家の谷、カルナック神殿、ナイル川両岸に広がる数千年のファラオの栄光。',
      'zh': '世界最大露天博物馆——帝王谷、卡纳克神庙，尼罗河两岸千年法老荣耀。',
    },
    gradientColors: [Color(0xFF8B4513), Color(0xFFC87941)],
    accentColor: Color(0xFFC87941),
    emoji: '🏺',
    heroImage: 'assets/images/tourist/Luxor/Karnak_Temple_Complex.jpg',
    transportOptions: [
      TransportOption(
        mode: TransportMode.flight,
        travelTime: {'en': '~1 hr 15 min', 'ar': '~ساعة و١٥ دقيقة'},
        apps: [kAppEgyptAir],
      ),
      TransportOption(
        mode: TransportMode.sleeperTrain,
        travelTime: {'en': '9–12 hours (overnight)', 'ar': '٩–١٢ ساعة (ليلي)'},
        apps: [kAppENR],
      ),
      TransportOption(
        mode: TransportMode.bus,
        travelTime: {'en': '10–12 hours', 'ar': '١٠–١٢ ساعة'},
        apps: [kAppGoBus],
      ),
    ],
    places: [
      CityPlace(
        names: {
          'en': 'Karnak Temple Complex',
          'ar': 'مجمع معابد الكرنك',
          'de': 'Karnak-Tempelanlage',
          'fr': 'Complexe du temple de Karnak',
          'es': 'Complejo del templo de Karnak',
          'it': 'Complesso templare di Karnak',
          'pt': 'Complexo do templo de Karnak',
          'ru': 'Карнакский храмовый комплекс',
          'tr': 'Karnak Tapınak Kompleksi',
          'ja': 'カルナック神殿複合体',
          'zh': '卡纳克神庙建筑群',
        },
        descs: {
          'en':
              'The world\'s largest ancient religious site — a vast forest of columns, obelisks, and sanctuaries built over 2,000 years.',
          'ar':
              'أكبر موقع ديني قديم في العالم — غابة شاسعة من الأعمدة والمسلات والمقدسات بُنيت على مدى 2000 عام.',
          'de':
              'Die größte antike Kultstätte der Welt — ein gewaltiger Wald aus Säulen, Obelisken und Heiligtümern, über 2.000 Jahre entstanden.',
          'fr':
              'Le plus grand site religieux antique au monde — une forêt immense de colonnes, obélisques et sanctuaires érigés sur plus de 2 000 ans.',
          'es':
              'El mayor yacimiento religioso antiguo del mundo — un vasto bosque de columnas, obeliscos y santuarios construido en más de 2.000 años.',
          'it':
              'Il più grande sito religioso antico al mondo — una vasta foresta di colonne, obelischi e santuari costruiti in oltre 2.000 anni.',
          'pt':
              'O maior sítio religioso antigo do mundo — uma vasta floresta de colunas, obeliscos e santuários erguidos ao longo de mais de 2.000 anos.',
          'ru':
              'Крупнейший древний культовый комплекс в мире — лес колонн, обелисков и святилищ, создававшийся более 2000 лет.',
          'tr':
              'Dünyanın en büyük antik dini alanı — 2.000 yılı aşkın sürede inşa edilmiş sütunlar, dikilitaşlar ve tapınaklardan oluşan devasa bir kompleks.',
          'ja':
              '世界最大の古代宗教遺跡——2000年以上にわたり築かれた柱、方尖塔、聖域の森。',
          'zh': '全球最大的古代宗教遗址——两千余年间建成的柱林、方尖碑与圣所群。',
        },
        image: 'assets/images/tourist/Luxor/Karnak_Temple_Complex.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Luxor Temple',
          'ar': 'معبد الأقصر',
          'de': 'Luxor-Tempel',
          'fr': 'Temple de Louxor',
          'es': 'Templo de Luxor',
          'it': 'Tempio di Luxor',
          'pt': 'Templo de Luxor',
          'ru': 'Луксорский храм',
          'tr': 'Luksor Tapınağı',
          'ja': 'ルクソール神殿',
          'zh': '卢克索神庙',
        },
        descs: {
          'en':
              'Ancient temple beautifully illuminated at night, standing at the heart of the modern city — connected to Karnak by the Avenue of Sphinxes.',
          'ar':
              'معبد قديم مضاء ليلًا بصورة رائعة، يقع في قلب المدينة الحديثة — يربطه بالكرنك طريق الكباش.',
          'de':
              'Antiker Tempel, nachts wunderschön beleuchtet, im Herzen der modernen Stadt — mit Karnak durch die Sphinx-Allee verbunden.',
          'fr':
              'Temple antique magnifiquement illuminé la nuit, au cœur de la ville moderne — relié à Karnak par l\'allée des sphinx.',
          'es':
              'Templo antiguo bellamente iluminado por la noche, en el corazón de la ciudad moderna — unido a Karnak por la Avenida de las Esfinges.',
          'it':
              'Antico tempio splendidamente illuminato di notte, nel cuore della città moderna — collegato a Karnak dal Viale delle Sfingi.',
          'pt':
              'Templo antigo belamente iluminado à noite, no coração da cidade moderna — ligado a Karnak pela Avenida das Esfinges.',
          'ru':
              'Древний храм с великолепной ночной подсветкой в центре современного города — соединён с Карнаком Аллеей сфинксов.',
          'tr':
              'Gece muhteşem ışıklandırılan antik tapınak, modern şehrin kalbinde — Sfenks Yolu ile Karnak\'a bağlı.',
          'ja':
              '夜は美しくライトアップされる古代神殿。現代都市の中心にあり、スフィンクス並木道でカルナックとつながる。',
          'zh': '夜晚灯光璀璨的古代神庙，位于现代市中心——经斯芬克斯大道与卡纳克相连。',
        },
        image: 'assets/images/tourist/Luxor/Luxor_Temple.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Valley of the Kings',
          'ar': 'وادي الملوك',
          'de': 'Tal der Könige',
          'fr': 'Vallée des Rois',
          'es': 'Valle de los Reyes',
          'it': 'Valle dei Re',
          'pt': 'Vale dos Reis',
          'ru': 'Долина царей',
          'tr': 'Krallar Vadisi',
          'ja': '王家の谷',
          'zh': '帝王谷',
        },
        descs: {
          'en':
              'Royal necropolis with 63 tombs — including the legendary tomb of Tutankhamun, adorned with vivid painted wall scenes.',
          'ar':
              'مقبرة ملكية تضم 63 مقبرة — بينها مقبرة توت عنخ آمون الأسطورية المزيّنة بمشاهد حائطية ملونة.',
          'de':
              'Königsnekropole mit 63 Gräbern — darunter das legendäre Grab des Tutanchamun mit farbenprächtigen Wandmalereien.',
          'fr':
              'Nécropole royale de 63 tombes — dont la légendaire tombe de Toutânkhamon ornée de scènes peintes vibrantes.',
          'es':
              'Necrópolis real con 63 tumbas — incluida la legendaria de Tutankamón, decorada con vivas escenas pintadas en las paredes.',
          'it':
              'Necropoli reale con 63 tombe — inclusa la leggendaria tomba di Tutankhamon con vivaci scene dipinte sulle pareti.',
          'pt':
              'Necrópole real com 63 túmulos — incluindo o lendário de Tutancâmon, com cenas pintadas nas paredes.',
          'ru':
              'Царский некрополь из 63 гробниц — включая легендарную гробницу Тутанхамона с яркими настенными росписями.',
          'tr':
              '63 mezarlı kraliyet nekropolü — canlı duvar resimleriyle süslü efsanevi Tutankamon mezarı dahil.',
          'ja':
              '63基の王墓がある王家墓地——鮮やかな壁画で知られる伝説のツタンカーメン墓を含む。',
          'zh': '拥有63座陵墓的王室墓地——包括绘有生动壁画的传奇图坦卡蒙墓。',
        },
        image: 'assets/images/tourist/Luxor/Valley_of_the_Kings.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Valley of the Queens',
          'ar': 'وادي الملكات',
          'de': 'Tal der Königinnen',
          'fr': 'Vallée des Reines',
          'es': 'Valle de las Reinas',
          'it': 'Valle delle Regine',
          'pt': 'Vale das Rainhas',
          'ru': 'Долина цариц',
          'tr': 'Kraliçeler Vadisi',
          'ja': '王妃の谷',
          'zh': '王后谷',
        },
        descs: {
          'en':
              'Resting place of queens and royal children, home to the breathtaking painted tomb of Queen Nefertari.',
          'ar':
              'مثوى الملكات وأبناء الفراعنة، وبه المقبرة الرائعة للملكة نفرتاري بجدارياتها الملونة.',
          'de':
              'Ruhestätte von Königinnen und königlichen Kindern — mit dem atemberaubend bemalten Grab der Königin Nefertari.',
          'fr':
              'Lieu de repos des reines et des enfants royaux, abritant la tombe peinte époustouflante de la reine Néfertari.',
          'es':
              'Lugar de descanso de reinas y hijos reales, hogar de la impresionante tumba pintada de la reina Nefertari.',
          'it':
              'Luogo di riposo di regine e figli reali, con la mozzafiato tomba dipinta della regina Nefertari.',
          'pt':
              'Local de repouso de rainhas e filhos reais, com a deslumbrante tumba pintada da rainha Nefertari.',
          'ru':
              'Покой цариц и царевичей — здесь находится потрясающая расписная гробница царицы Нефертари.',
          'tr':
              'Kraliçelerin ve kraliyet çocuklarının istirahatgahı — Kraliçe Nefertari\'nin nefes kesen boyalı mezarı.',
          'ja':
              '王妃と王族の子らの眠る地——王妃ネフェルタリの壮麗な彩色墓がある。',
          'zh': '王后与王嗣的长眠之地——拥有王后奈费尔塔利令人惊叹的彩绘墓。',
        },
        image: 'assets/images/tourist/Luxor/Valley_of_the_Queens.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Temple of Hatshepsut',
          'ar': 'معبد حتشبسوت',
          'de': 'Tempel der Hatschepsut',
          'fr': 'Temple d\'Hatchepsout',
          'es': 'Templo de Hatshepsut',
          'it': 'Tempio di Hatshepsut',
          'pt': 'Templo de Hatshepsut',
          'ru': 'Храм Хатшепсут',
          'tr': 'Hatşepsut Tapınağı',
          'ja': 'ハトシェプスト女王葬祭殿',
          'zh': '哈特谢普苏特神庙',
        },
        descs: {
          'en':
              'Striking three-tiered mortuary temple of Egypt\'s most famous female pharaoh, carved into the limestone cliffs.',
          'ar':
              'معبد جنائزي مذهل من ثلاثة طوابق للفرعونة الأشهر في مصر، منحوت في صخور الحجر الجيري.',
          'de':
              'Eindrucksvoller dreistufiger Totentempel der berühmtesten Pharaonin Ägyptens, in die Kalksteinklippen gehauen.',
          'fr':
              'Saisissant temple funéraire à trois terrasses de la pharaonne la plus célèbre d\'Égypte, taillé dans les falaises calcaires.',
          'es':
              'Impresionante templo funerario de tres niveles de la faraona más famosa de Egipto, tallado en los acantilados de caliza.',
          'it':
              'Imponente tempio funerario a tre terrazze della più famosa faraona d\'Egitto, scavato nelle scogliere calcaree.',
          'pt':
              'Imponente templo funerário de três níveis da mais famosa faraó do Egito, esculpido nos penhascos de calcário.',
          'ru':
              'Потрясающий трёхъярусный заупокойный храм самой знаменитой царицы-фараона, высеченный в известняковых скалах.',
          'tr':
              'Mısır\'ın en ünlü kadın firavununun kayaya oyulmuş üç katlı görkemli cenaze tapınağı.',
          'ja':
              'エジプトで最も有名な女王ファラオの、石灰岩の崖に刻まれた印象的な三段の葬祭殿。',
          'zh': '埃及最著名的女法老的三层陵庙，开凿于石灰岩峭壁之上。',
        },
        image: 'assets/images/tourist/Luxor/Temple_of_Hatshepsut.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Colossi of Memnon',
          'ar': 'تمثالا ممنون',
          'de': 'Memnonkolosse',
          'fr': 'Colosses de Memnon',
          'es': 'Colosos de Memnón',
          'it': 'Colossi di Memnone',
          'pt': 'Colossos de Memnon',
          'ru': 'Колоссы Мемнона',
          'tr': 'Memnon Devleri',
          'ja': 'メムノンの巨像',
          'zh': '门农巨像',
        },
        descs: {
          'en':
              'Two 18-metre stone colossi of Amenhotep III standing guard over the Theban necropolis for 3,400 years.',
          'ar':
              'تمثالان حجريان ضخمان بارتفاع 18 مترًا لأمنحتب الثالث يحرسان نيكروبوليس طيبة منذ 3400 عام.',
          'de':
              'Zwei 18 m hohe Steinstatuen Amenophis III. bewachen seit 3.400 Jahren die thebanische Nekropole.',
          'fr':
              'Deux colosses de pierre de 18 m d\'Aménophis III veillent sur la nécropole thébaine depuis 3 400 ans.',
          'es':
              'Dos colosos de piedra de 18 m de Amenofis III custodian la necrópolis tebana durante 3.400 años.',
          'it':
              'Due colossi in pietra alti 18 m di Amenhotep III vegliano sulla necropoli tebana da 3.400 anni.',
          'pt':
              'Dois colossos de pedra de 18 m de Amenófis III guardam a necrópole tebana há 3.400 anos.',
          'ru':
              'Два 18-метровых каменных колосса Аменхотепа III стерегут фиванский некрополь уже 3400 лет.',
          'tr':
              'Tebas nekropolünü 3.400 yıldır koruyan III. Amenhotep\'e ait 18 metrelik iki taş dev heykel.',
          'ja':
              '高さ18メートルのアメンホテプ3世の石像が二体、3400年間テーベの墓地を見守る。',
          'zh': '阿蒙霍特普三世的两座18米高石像，三千四百年来守护着底比斯墓地。',
        },
        image: 'assets/images/tourist/Luxor/Colossi_of_Memnon.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Medinet Habu',
          'ar': 'مدينة هابو',
          'de': 'Medinet Habu',
          'fr': 'Médinet Habou',
          'es': 'Medinet Habu',
          'it': 'Medinet Habu',
          'pt': 'Medinet Habu',
          'ru': 'Мединет-Абу',
          'tr': 'Medinet Habu',
          'ja': 'メディネト・ハブ',
          'zh': '哈布城',
        },
        descs: {
          'en':
              'Massive mortuary temple of Ramesses III with remarkably well-preserved vivid painted reliefs.',
          'ar':
              'معبد جنائزي ضخم لرمسيس الثالث بنقوش بارزة ملونة محفوظة بشكل استثنائي.',
          'de':
              'Riesiger Totentempel Ramses III. mit außergewöhnlich gut erhaltenen farbigen Reliefs.',
          'fr':
              'Immense temple funéraire de Ramsès III aux reliefs peints remarquablement conservés.',
          'es':
              'Enorme templo funerario de Ramsés III con relieves pintados sorprendentemente bien conservados.',
          'it':
              'Immenso tempio funerario di Ramses III con rilievi dipinti straordinariamente conservati.',
          'pt':
              'Imenso templo funerário de Ramsés III com relevos pintados notavelmente bem conservados.',
          'ru':
              'Гигантский заупокойный храм Рамсеса III с удивительно сохранившимися яркими раскрашенными рельефами.',
          'tr':
              'III. Ramses\'in olağanüstü derecede iyi korunmuş canlı boyalı kabartmalarıyla devasa cenaze tapınağı.',
          'ja':
              'ラムセス3世の巨大な葬祭殿。色彩豊かなレリーフが驚くほどよく残る。',
          'zh': '拉美西斯三世的宏大陵庙，彩绘浮雕保存得极为完好。',
        },
        image: 'assets/images/tourist/Luxor/Medinet_Habu.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Temple of Seti I',
          'ar': 'معبد سيتي الأول',
          'de': 'Tempel Sethos I.',
          'fr': 'Temple de Séthi Ier',
          'es': 'Templo de Seti I',
          'it': 'Tempio di Sethi I',
          'pt': 'Templo de Seti I',
          'ru': 'Храм Сети I',
          'tr': 'I. Seti Tapınağı',
          'ja': 'セティ1世神殿',
          'zh': '塞提一世神庙',
        },
        descs: {
          'en':
              'One of the finest temples in Egypt with exquisite painted reliefs and a serene atmosphere away from crowds.',
          'ar':
              'من أروع المعابد في مصر بنقوش بارزة ومرسومة خلّابة وأجواء هادئة بعيدًا عن الزحام.',
          'de':
              'Einer der schönsten Tempel Ägyptens mit exquisiten bemalten Reliefs und ruhiger Atmosphäre abseits der Massen.',
          'fr':
              'L\'un des plus beaux temples d\'Égypte, aux reliefs peints exquis et à l\'atmosphère sereine, loin des foules.',
          'es':
              'Uno de los mejores templos de Egipto, con relieves pintados exquisitos y un ambiente sereno lejos de las multitudes.',
          'it':
              'Uno dei più bei templi d\'Egitto, con rilievi dipinti squisiti e atmosfera serena lontano dalla folla.',
          'pt':
              'Um dos mais belos templos do Egito, com relevos pintados requintados e ambiente sereno longe das multidões.',
          'ru':
              'Один из лучших храмов Египта с изысканными раскрашенными рельефами и умиротворяющей атмосферой вдали от толп.',
          'tr':
              'İnce işlemeli boyalı kabartmaları ve kalabalıktan uzak dingin atmosferiyle Mısır\'ın en güzel tapınaklarından biri.',
          'ja':
              '精緻な彩色レリーフと人混みを離れた静かな雰囲気が魅力の、エジプト屈指の神殿。',
          'zh': '埃及最精美的神庙之一，彩绘浮雕细腻，远离人群的宁静氛围。',
        },
        image: 'assets/images/tourist/Luxor/Temple_of_Seti_I.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Luxor Museum',
          'ar': 'متحف الأقصر',
          'de': 'Luxor-Museum',
          'fr': 'Musée de Louxor',
          'es': 'Museo de Luxor',
          'it': 'Museo di Luxor',
          'pt': 'Museu de Luxor',
          'ru': 'Луксорский музей',
          'tr': 'Luksor Müzesi',
          'ja': 'ルクソール博物館',
          'zh': '卢克索博物馆',
        },
        descs: {
          'en':
              'World-class museum with superbly displayed Pharaonic statues, mummies, and Islamic artifacts.',
          'ar':
              'متحف عالمي المستوى يعرض تماثيل فرعونية ومومياوات وقطعًا إسلامية نادرة بأسلوب استثنائي.',
          'de':
              'Museum von Weltrang mit hervorragend präsentierten pharaonischen Statuen, Mumien und islamischen Objekten.',
          'fr':
              'Musée de classe mondiale présentant superbement statues pharaoniques, momies et objets islamiques.',
          'es':
              'Museo de clase mundial con estatuas faraónicas, momias y piezas islámicas magníficamente expuestas.',
          'it':
              'Museo di livello mondiale con statue faraoniche, mummie e reperti islamici esposti in modo superbo.',
          'pt':
              'Museu de classe mundial com estátuas faraónicas, múmias e artefactos islâmicos soberbamente expostos.',
          'ru':
              'Музей мирового уровня с превосходной экспозицией фараонских статуй, мумий и исламских артефактов.',
          'tr':
              'Firavun heykelleri, mumyalar ve İslami eserlerin üstün sergilendiği dünya standartlarında bir müze.',
          'ja':
              'ファラオ像、ミイラ、イスラム文物を見事に展示する世界水準の博物館。',
          'zh': '世界级博物馆，法老雕像、木乃伊与伊斯兰文物陈列极佳。',
        },
        image: 'assets/images/tourist/Luxor/Luxor_Museum.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Mummification Museum',
          'ar': 'متحف التحنيط',
          'de': 'Mumifizierungsmuseum',
          'fr': 'Musée de la momification',
          'es': 'Museo de la momificación',
          'it': 'Museo della mummificazione',
          'pt': 'Museu da mumificação',
          'ru': 'Музей мумификации',
          'tr': 'Mumyalama Müzesi',
          'ja': 'ミイラ作り博物館',
          'zh': '木乃伊博物馆',
        },
        descs: {
          'en':
              'Unique museum revealing the ancient Egyptian art of mummification — with real mummies, tools, and canopic jars.',
          'ar':
              'متحف فريد يكشف أسرار التحنيط المصري القديم — بمومياوات حقيقية وأدواتها وجرار القانوب.',
          'de':
              'Einzigartiges Museum zur altägyptischen Mumifizierungskunst — mit echten Mumien, Werkzeugen und Kanopen.',
          'fr':
              'Musée unique sur l\'art égyptien de la momification — avec de vraies momies, outils et vases canopes.',
          'es':
              'Museo único sobre el arte egipcio de la momificación — con momias reales, herramientas y vasos canópicos.',
          'it':
              'Museo unico sull\'arte egizia della mummificazione — con vere mummie, strumenti e vasi canopici.',
          'pt':
              'Museu único sobre a arte egípcia da mumificação — com múmias reais, ferramentas e vasos canópicos.',
          'ru':
              'Уникальный музей древнеегипетского искусства мумификации — настоящие мумии, инструменты и канопы.',
          'tr':
              'Antik Mısır mumyalama sanatını gerçek mumyalar, aletler ve kanopos kaplarıyla sergileyen eşsiz müze.',
          'ja':
              '古代エジプトのミイラ製作を実物のミイラ、道具、カノプス壺で紹介するユニークな博物館。',
          'zh': '独特的博物馆，展示古埃及木乃伊制作技艺——真木乃伊、工具与卡诺匹斯罐。',
        },
        image: 'assets/images/tourist/Luxor/Mummification_Museum.jpg',
      ),
    ],
  ),

  // ── 3. Aswan ──────────────────────────────────────────────────────────────────
  EgyptCity(
    id: 'aswan',
    names: {
      'en': 'Aswan',
      'ar': 'أسوان',
      'de': 'Assuan',
      'fr': 'Assouan',
      'es': 'Asuán',
      'it': 'Assuan',
      'pt': 'Assuã',
      'ru': 'Асуан',
      'tr': 'Asvan',
      'ja': 'アスワン',
      'zh': '阿斯旺',
    },
    descriptions: {
      'en':
          'Egypt\'s southern gem — Nubian warmth, the great High Dam, the island temple of Philae, and felucca rides on the Nile at golden hour.',
      'ar':
          'جوهرة مصر الجنوبية — الدفء النوبي والسد العالي ومعبد فيلة ورحلات الفلوكة على النيل وقت الغروب.',
      'de':
          'Ägyptens südliches Juwel — nubische Herzlichkeit, der Assuan-Staudamm, der Insel-Tempel von Philae und Fellucken-Fahrten bei Sonnenuntergang.',
      'fr':
          'Le joyau du sud de l\'Égypte — chaleur nubienne, le grand Haut-Barrage, le temple insulaire de Philae et des promenades en felouque au coucher du soleil.',
      'es':
          'La joya del sur de Egipto — calidez nubia, la gran presa Alta, el templo insular de Filé y paseos en faluca al atardecer.',
      'it':
          'Il gioiello del sud dell\'Egitto — calore nubiano, la grande Alta Diga, il tempio insulare di File e gite in feluca al tramonto.',
      'pt':
          'A joia do sul do Egito — calor nubiano, a grande Alta Barragem, o templo insular de Filae e passeios de faluca ao pôr do sol.',
      'ru':
          'Южная жемчужина Египта — нубийское гостеприимство, Асуанская плотина, островной храм Филе и прогулки на фелюге на закате.',
      'tr':
          'Mısır\'ın güney mücevheri — Nubya sıcaklığı, büyük Yüksek Baraj, Philae\'nin ada tapınağı ve gün batımında Nil\'de yelkenli gezileri.',
      'ja':
          'エジプト南の宝石——ヌビアの温かさ、アスワン・ハイ・ダム、島に建つフィラエ神殿、黄金の夕暮れのナイル・フェルッカ乗り。',
      'zh': '埃及南部的宝石——努比亚的温情、阿斯旺高坝、菲莱岛神庙和黄昏时分的尼罗河帆船游。',
    },
    gradientColors: [Color(0xFF7A4B10), Color(0xFFB8731E)],
    accentColor: Color(0xFFB8731E),
    emoji: '⛵',
    heroImage: 'assets/images/tourist/Aswan/Philae_Temple.jpg',
    transportOptions: [
      TransportOption(
        mode: TransportMode.flight,
        travelTime: {'en': '~1 hr 45 min', 'ar': '~ساعة و٤٥ دقيقة'},
        apps: [kAppEgyptAir],
      ),
      TransportOption(
        mode: TransportMode.sleeperTrain,
        travelTime: {'en': '~12 hours (overnight)', 'ar': '~١٢ ساعة (ليلي)'},
        apps: [kAppENR],
      ),
    ],
    places: [
      CityPlace(
        names: {
          'en': 'Philae Temple',
          'ar': 'معبد فيلة',
          'de': 'Philae-Tempel',
          'fr': 'Temple de Philæ',
          'es': 'Templo de File',
          'it': 'Tempio di File',
          'pt': 'Templo de Filae',
          'ru': 'Храм Филы',
          'tr': 'Filae Tapınağı',
          'ja': 'フィラエ神殿',
          'zh': '菲莱神庙',
        },
        descs: {
          'en':
              'Island temple of the goddess Isis — relocated stone by stone to save it from rising Nile waters after the High Dam was built.',
          'ar':
              'معبد الإلهة إيزيس على جزيرتها — نُقل حجرًا حجرًا إنقاذًا له من مياه النيل بعد بناء السد العالي.',
          'de':
              'Inseltempel der Göttin Isis — Stein für Stein versetzt, um ihn vor steigendem Nil nach dem Hochdamm zu retten.',
          'fr':
              'Temple insulaire d\'Isis — déplacé pierre par pierre pour le sauver des crues du Nil après la construction du barrage.',
          'es':
              'Templo insular de la diosa Isis — trasladado piedra a piedra para salvarlo de las crecidas del Nilo tras la presa alta.',
          'it':
              'Tempio sull\'isola della dea Iside — spostato pietra su pietra per salvarlo dalle piene del Nilo dopo la diga alta.',
          'pt':
              'Templo insular da deusa Ísis — realocado pedra a pedra para o salvar das cheias do Nilo após a barragem alta.',
          'ru':
              'Островной храм богини Исиды — перенесён по камням, чтобы спасти от подъёма вод Нила после постройки высотной плотины.',
          'tr':
              'İsis tanrıçasının ada tapınağı — Yüksek Baraj sonrası yükselen Nil sularından korumak için taş taşın yerinden taşındı.',
          'ja':
              'イシス女神の島にあった神殿——高ダム後のナイル水位上昇から守るため石ごと移築された。',
          'zh': '伊西斯女神的岛庙——高坝建成后为躲避上涨的尼罗河水而整块迁建。',
        },
        image: 'assets/images/tourist/Aswan/Philae_Temple.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Aswan High Dam',
          'ar': 'السد العالي',
          'de': 'Assuan-Hochdamm',
          'fr': 'Haut barrage d\'Assouan',
          'es': 'Presa Alta de Asuán',
          'it': 'Alta diga di Assuan',
          'pt': 'Alta Barragem de Assuã',
          'ru': 'Асуанская высотная плотина',
          'tr': 'Asvan Yüksek Barajı',
          'ja': 'アスワン・ハイ・ダム',
          'zh': '阿斯旺高坝',
        },
        descs: {
          'en':
              'One of the world\'s largest embankment dams — an engineering wonder that transformed Egypt and created Lake Nasser.',
          'ar':
              'من أضخم سدود الردم في العالم — معجزة هندسية غيّرت وجه مصر وأوجدت بحيرة ناصر.',
          'de':
              'Einer der größten Erddämme der Welt — ein technisches Wunder, das Ägypten veränderte und den Nassersee schuf.',
          'fr':
              'L\'un des plus grands barrages en remblai au monde — prouesse d\'ingénierie qui a transformé l\'Égypte et créé le lac Nasser.',
          'es':
              'Una de las mayores presas de materiales del mundo — maravilla de ingeniería que transformó Egipto y creó el lago Nasser.',
          'it':
              'Una delle più grandi dighe a terra del mondo — capolavoro ingegneristico che trasformò l\'Egitto e creò il lago Nasser.',
          'pt':
              'Uma das maiores barragens de aterro do mundo — maravilha de engenharia que transformou o Egito e criou o Lago Nasser.',
          'ru':
              'Одна из крупнейших насыпных плотин мира — инженерное чудо, изменившее Египет и создавшее озеро Насер.',
          'tr':
              'Dünyanın en büyük dolgu barajlarından biri — Mısır\'ı dönüştüren ve Nasır Gölü\'nü yaratan mühendislik harikası.',
          'ja':
              '世界最大級の盛土ダム——エジプトを変え、ナセル湖を生んだ工学の偉業。',
          'zh': '世界最大型的土石坝之一——改变埃及面貌并造就纳赛尔湖的工程奇迹。',
        },
        image: 'assets/images/tourist/Aswan/Aswan_High_Dam.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Abu Simbel Temples',
          'ar': 'معبدا أبو سمبل',
          'de': 'Tempel von Abu Simbel',
          'fr': 'Temples d\'Abou Simbel',
          'es': 'Templos de Abu Simbel',
          'it': 'Templi di Abu Simbel',
          'pt': 'Templos de Abu Simbel',
          'ru': 'Храмы Абу-Симбел',
          'tr': 'Abu Simbel Tapınakları',
          'ja': 'アブ・シンベル大神殿',
          'zh': '阿布辛贝神庙',
        },
        descs: {
          'en':
              'Two colossal rock-cut temples of Ramesses II — UNESCO World Heritage and one of Egypt\'s most iconic sights (day trip from Aswan).',
          'ar':
              'معبدان ضخمان منحوتان في الصخر لرمسيس الثاني — تراث عالمي يونسكو ومن أشهر المعالم المصرية (رحلة يومية من أسوان).',
          'de':
              'Zwei gewaltige in den Fels gehauene Tempel Ramses II. — UNESCO-Welterbe und Wahrzeichen Ägyptens (Tagesausflug von Assuan).',
          'fr':
              'Deux temples colossaux taillés dans le roc de Ramsès II — patrimoine mondial de l\'UNESCO et icône de l\'Égypte (excursion depuis Assouan).',
          'es':
              'Dos templos colosales excavados en la roca de Ramsés II — Patrimonio de la UNESCO y emblema de Egipto (excursión desde Asuán).',
          'it':
              'Due colossali templi rupestri di Ramses II — patrimonio UNESCO e icona dell\'Egitto (gita da Assuan).',
          'pt':
              'Dois colossais templos rupestres de Ramsés II — Património Mundial da UNESCO e ícone do Egito (excursão de Assuã).',
          'ru':
              'Два колоссальных скальных храма Рамсеса II — объект ЮНЕСКО и символ Египта (однодневная поездка из Асуана).',
          'tr':
              'II. Ramses\'e ait iki devasa kaya tapınağı — UNESCO Dünya Mirası ve Mısır\'ın simgelerinden biri (Asvan\'dan günübirlik).',
          'ja':
              'ラムセス2世の巨大な岩窟神殿2基——ユネスコ世界遺産、エジプトの象徴の一つ（アスワン発日帰り）。',
          'zh': '拉美西斯二世的两座巨型岩窟神庙——世界遗产与埃及标志景点之一（可从阿斯旺当日往返）。',
        },
        image: 'assets/images/tourist/Aswan/Abu_Simbel_Temples.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Nubian Village',
          'ar': 'القرى النوبية',
          'de': 'Nubisches Dorf',
          'fr': 'Village nubien',
          'es': 'Pueblo nubio',
          'it': 'Villaggio nubiano',
          'pt': 'Aldeia núbia',
          'ru': 'Нубийская деревня',
          'tr': 'Nubyalı Köy',
          'ja': 'ヌビアの村',
          'zh': '努比亚村落',
        },
        descs: {
          'en':
              'Vibrant, colourful villages along the Nile banks offering traditional Nubian music, cuisine, and handicrafts.',
          'ar':
              'قرى حيوية ملونة على ضفاف النيل تقدم الموسيقى النوبية الأصيلة والمطبخ والحرف التقليدية.',
          'de':
              'Lebendige, farbenfrohe Dörfer am Nilufer mit traditioneller nubischer Musik, Küche und Handwerk.',
          'fr':
              'Villages colorés et animés le long du Nil — musique, cuisine et artisanat nubiens traditionnels.',
          'es':
              'Pueblos vivos y coloridos a orillas del Nilo con música, cocina y artesanía nubias tradicionales.',
          'it':
              'Villaggi vivaci e colorati sulle rive del Nilo con musica, cucina e artigianato nubiani tradizionali.',
          'pt':
              'Aldeias vibrantes e coloridas às margens do Nilo com música, culinária e artesanato núbios tradicionais.',
          'ru':
              'Яркие красочные деревни на берегах Нила — традиционная нубийская музыка, кухня и ремёсла.',
          'tr':
              'Nil kıyılarında geleneksel Nubyalı müzik, mutfak ve el sanatları sunan canlı, renkli köyler.',
          'ja':
              'ナイル川岸の色彩豊かな村々——伝統的なヌビアの音楽、料理、手工芸。',
          'zh': '尼罗河沿岸色彩缤纷的村落——传统努比亚音乐、美食与手工艺。',
        },
        image: 'assets/images/tourist/Aswan/Nubian_Village.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Elephantine Island',
          'ar': 'جزيرة الفنتين',
          'de': 'Elephantine-Insel',
          'fr': 'Éléphantine',
          'es': 'Isla Elefantina',
          'it': 'Isola Elefantina',
          'pt': 'Ilha Elefantina',
          'ru': 'Остров Элефантина',
          'tr': 'Fil Adası (Elefantin)',
          'ja': 'エレファンティーヌ島',
          'zh': '象岛',
        },
        descs: {
          'en':
              'Ancient island in the heart of the Nile with ruins of a pre-Pharaonic settlement, a Nilometer, and the Nubian Museum.',
          'ar':
              'جزيرة عريقة في قلب النيل بها بقايا مستوطنة ما قبل الفراعنة وميقاس النيل ومتحف النوبة.',
          'de':
              'Antike Insel im Herzen des Nils mit Ruinen einer vorpharaonischen Siedlung, einem Nilometer und dem Nubischen Museum.',
          'fr':
              'Île antique au cœur du Nil — ruines d\'un habitat pré-pharaonique, nilomètre et musée nubien.',
          'es':
              'Isla antigua en el corazón del Nilo con ruinas prefaráonicas, un nilómetro y el Museo Nubio.',
          'it':
              'Isola antica nel cuore del Nilo con rovine pre-faraoniche, nilometro e Museo Nubiano.',
          'pt':
              'Ilha antiga no coração do Nilo com ruínas pré-faraónicas, nilómetro e Museu Núbio.',
          'ru':
              'Древний остров в сердце Нила — руины дофараонического поселения, нилометр и Нубийский музей.',
          'tr':
              'Nil\'in kalbindeki antik ada — firavun öncesi yerleşim kalıntıları, nilometre ve Nübye Müzesi.',
          'ja':
              'ナイル川の中心にある古代の島——前王朝時代の集落跡、ナイル水位計、ヌビア博物館。',
          'zh': '尼罗河中心的古岛——有法老时代前的聚落遗址、尼罗河水位计和努比亚博物馆。',
        },
        image: 'assets/images/tourist/Aswan/Elephantine_Island.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Aswan Botanical Garden',
          'ar': 'حديقة أسوان النباتية',
          'de': 'Botanischer Garten Assuan',
          'fr': 'Jardin botanique d\'Assouan',
          'es': 'Jardín botánico de Asuán',
          'it': 'Giardino botanico di Assuan',
          'pt': 'Jardim botânico de Assuã',
          'ru': 'Асуанский ботанический сад',
          'tr': 'Asvan Botanik Bahçesi',
          'ja': 'アスワン植物園',
          'zh': '阿斯旺植物园',
        },
        descs: {
          'en':
              'Lush tropical garden on Kitchener\'s Island with rare exotic plants from Africa and Asia — a peaceful Nile retreat.',
          'ar':
              'حديقة استوائية خضراء في جزيرة كيتشنر بنباتات نادرة من أفريقيا وآسيا — ملاذ هادئ على النيل.',
          'de':
              'Üppiger tropischer Garten auf Kitcheners Insel mit seltenen exotischen Pflanzen aus Afrika und Asien — ruhiger Nil-Rückzugsort.',
          'fr':
              'Jardin tropical luxuriant sur l\'île Kitchener, plantes rares d\'Afrique et d\'Asie — havre de paix sur le Nil.',
          'es':
              'Jardín tropical exuberante en la isla Kitchener con plantas exóticas raras de África y Asia — refugio tranquilo en el Nilo.',
          'it':
              'Giardino tropicale rigoglioso sull\'isola Kitchener con rare piante esotiche da Africa e Asia — rifugio tranquillo sul Nilo.',
          'pt':
              'Jardim tropical exuberante na ilha Kitchener com plantas exóticas raras da África e Ásia — refúgio tranquilo no Nilo.',
          'ru':
              'Пышный тропический сад на острове Китченера с редкими экзотическими растениями из Африки и Азии — тихий уголок на Ниле.',
          'tr':
              'Afrika ve Asya\'dan nadir egzotik bitkilerle Kitchener Adası\'nda yemyeşil tropik bahçe — Nil\'de huzurlu bir sığınak.',
          'ja':
              'キッチナー島の緑豊かな熱帯庭園——アフリカとアジアの希少な植物、ナイルの静かな憩いの場。',
          'zh': '基奇纳岛上的茂盛热带花园——来自亚非的珍稀植物，尼罗河畔的宁静去处。',
        },
        image: 'assets/images/tourist/Aswan/Aswan_Botanical_Garden.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Unfinished Obelisk',
          'ar': 'المسلة الناقصة',
          'de': 'Unvollendeter Obelisk',
          'fr': 'Obélisque inachevé',
          'es': 'Obelisco inacabado',
          'it': 'Obelisco incompiuto',
          'pt': 'Obelisco inacabado',
          'ru': 'Незаконченный обелиск',
          'tr': 'Yarım Kalan Dikilitaş',
          'ja': '未完成のオベリスク',
          'zh': '未完成的方尖碑',
        },
        descs: {
          'en':
              'Ancient quarry with an abandoned colossus that would have been the world\'s largest obelisk — reveals exactly how Egyptians carved them.',
          'ar':
              'مقلع قديم بمسلة مهجورة كانت ستكون الأكبر في العالم — يكشف بالضبط كيف كان المصريون ينحتونها.',
          'de':
              'Antiker Steinbruch mit aufgegebenem Riesenobelisk — zeigt genau, wie die Ägypter sie meißelten.',
          'fr':
              'Carrière antique avec un obélisque abandonné qui aurait été le plus grand du monde — montre comment les Égyptiens les tailaient.',
          'es':
              'Cantera antigua con un obelisco abandonado que habría sido el más grande del mundo — muestra cómo los egipcios los tallaban.',
          'it':
              'Cava antica con obelisco abbandonato che sarebbe stato il più grande al mondo — mostra come gli egiziani li scolpivano.',
          'pt':
              'Pedreira antiga com obelisco abandonado que seria o maior do mundo — revela como os egípcios os talhavam.',
          'ru':
              'Древний карьер с заброшенным гигантским обелиском — наглядно показывает, как египтяне их высекали.',
          'tr':
              'Dünyanın en büyük dikilitaşı olacak terk edilmiş devle antik taş ocağı — Mısırlıların nasıl yonttuğunu gösterir.',
          'ja':
              '世界最大級になるはずだった放棄された巨体の採石場——古代エジプト人の削り方がわかる。',
          'zh': '古代采石场中未完工的巨碑——本将成为世界最大方尖碑，展示古埃及人的开凿工艺。',
        },
        image: 'assets/images/tourist/Aswan/Unfinished_Obelisk.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Temple of Edfu',
          'ar': 'معبد إدفو',
          'de': 'Tempel von Edfu',
          'fr': 'Temple d\'Edfou',
          'es': 'Templo de Edfu',
          'it': 'Tempio di Edfu',
          'pt': 'Templo de Edfu',
          'ru': 'Храм в Эдфу',
          'tr': 'İdfu Tapınağı',
          'ja': 'エドフ神殿',
          'zh': '埃德富神庙',
        },
        descs: {
          'en':
              'The best-preserved ancient temple in Egypt — Ptolemaic masterpiece dedicated to the falcon god Horus.',
          'ar':
              'أحسن معبد قديم محفوظًا في مصر — تحفة بطلمية مكرسة لإله الصقر حورس.',
          'de':
              'Der am besten erhaltene antike Tempel Ägyptens — ptolemäisches Meisterwerk dem Falkengott Horus geweiht.',
          'fr':
              'Le mieux conservé des temples antiques d\'Égypte — chef-d\'œuvre ptolémaïque dédié au dieu faucon Horus.',
          'es':
              'El templo antiguo mejor conservado de Egipto — obra maestra ptolemaica dedicada al dios halcón Horus.',
          'it':
              'Il tempio antico meglio conservato d\'Egitto — capolavoro tolemaico dedicato al dio falco Horus.',
          'pt':
              'O templo antigo melhor conservado do Egito — obra-prima ptolomaica dedicada ao deus falcão Hórus.',
          'ru':
              'Лучше всего сохранившийся древний храм Египта — шедевр эпохи Птолемеев, посвящённый богу-соколу Гору.',
          'tr':
              'Mısır\'ın en iyi korunmuş antik tapınağı — şahin tanrı Horus\'a adanmış Ptolemaios dönemi başyapıtı.',
          'ja':
              'エジプトで最も保存状態の良い古代神殿——鷹神ホルスに捧げられたプトレマイオス朝の傑作。',
          'zh': '埃及保存最完好的古代神庙——托勒密王朝的杰作，供奉鹰神荷鲁斯。',
        },
        image: 'assets/images/tourist/Aswan/Temple_of_Edfu.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Temple of Kom Ombo',
          'ar': 'معبد كوم أمبو',
          'de': 'Tempel von Kom Ombo',
          'fr': 'Temple de Kom Ombo',
          'es': 'Templo de Kom Ombo',
          'it': 'Tempio di Kom Ombo',
          'pt': 'Templo de Kom Ombo',
          'ru': 'Храм Ком Омбо',
          'tr': 'Kom Ombo Tapınağı',
          'ja': 'コム・オンボ神殿',
          'zh': '康翁波神庙',
        },
        descs: {
          'en':
              'Unique double temple perched dramatically on the Nile bank — dedicated to two gods simultaneously, with a gallery of crocodile mummies.',
          'ar':
              'معبد مزدوج فريد يطل على ضفة النيل — مكرس لإلهين في آنٍ واحد، ويضم معرض مومياوات التماسيح.',
          'de':
              'Einzigartiger Doppeltempel dramatisch am Nilufer — zwei Gottheiten zugleich, mit einer Galerie von Krokodilmumien.',
          'fr':
              'Temple double unique dominant le Nil — dédié à deux dieux à la fois, avec une galerie de momies de crocodiles.',
          'es':
              'Templo doble único sobre el Nilo — dedicado a dos dioses a la vez, con galería de momias de cocodrilo.',
          'it':
              'Unico tempio doppio sul Nilo — dedicato a due divinità insieme, con galleria di mummie di coccodrilli.',
          'pt':
              'Templo duplo único sobre o Nilo — dedicado a dois deuses ao mesmo tempo, com galeria de múmias de crocodilo.',
          'ru':
              'Уникальный двойной храм на берегу Нила — посвящён двум богам сразу, с залом мумий крокодилов.',
          'tr':
              'Nil kıyısında görkemli konumlanmış eşsiz çift tapınak — aynı anda iki tanrıya adanmış, timsah mumyaları galerisiyle.',
          'ja':
              'ナイル川岸にそびえる珍しい二神一体の神殿——ワニのミイラのギャラリーも。',
          'zh': '尼罗河畔独特的双神庙——同时供奉两位神祇，并藏有鳄鱼木乃伊展廊。',
        },
        image: 'assets/images/tourist/Aswan/Temple_of_Kom_Ombo.jpg',
      ),
    ],
  ),

  // ── 4. Sharm El-Sheikh & Sinai ────────────────────────────────────────────────
  EgyptCity(
    id: 'sharm',
    names: {
      'en': 'Sharm El-Sheikh & Sinai',
      'ar': 'شرم الشيخ وسيناء',
      'de': 'Scharm el-Scheich & Sinai',
      'fr': 'Charm el-Cheikh & Sinaï',
      'es': 'Sharm el-Sheij & Sinaí',
      'it': 'Sharm el-Sheikh & Sinai',
      'pt': 'Sharm el-Sheikh & Sinai',
      'ru': 'Шарм-эль-Шейх & Синай',
      'tr': 'Şarm el-Şeyh & Sina',
      'ja': 'シャルム・エル・シェイク & シナイ',
      'zh': '沙姆沙伊赫 & 西奈',
    },
    descriptions: {
      'en':
          'Egypt\'s premier Red Sea resort meets the biblical Sinai Peninsula — world-class reefs, Naama Bay, and the ancient monastery of Saint Catherine.',
      'ar':
          'أفضل منتجعات البحر الأحمر في مصر تلتقي بشبه جزيرة سيناء الإبراهيمية — شعاب مرجانية عالمية وخليج نعمة ودير سانت كاترين العريق.',
      'de':
          'Ägyptens erstklassiges Rotes-Meer-Resort trifft auf die biblische Sinai-Halbinsel — Weltklasse-Riffe, Naama Bay und das Kloster der Heiligen Katharina.',
      'fr':
          'La principale station balnéaire de la mer Rouge rencontre la péninsule biblique du Sinaï — récifs de classe mondiale, Naama Bay et le monastère Sainte-Catherine.',
      'es':
          'El principal resort del Mar Rojo de Egipto se encuentra con la bíblica Península del Sinaí — arrecifes de clase mundial, Bahía Naama y el monasterio de Santa Catalina.',
      'it':
          'Il principale resort del Mar Rosso d\'Egitto incontra la biblica Penisola del Sinai — barriere coralline di livello mondiale, Naama Bay e il monastero di Santa Caterina.',
      'pt':
          'A principal estância balnear do Mar Vermelho do Egito encontra a bíblica Península do Sinai — recifes de classe mundial, Naama Bay e o mosteiro de Santa Catarina.',
      'ru':
          'Лучший курорт Красного моря Египта встречается с библейским Синайским полуостровом — рифы мирового класса, бухта Наама и монастырь Святой Екатерины.',
      'tr':
          'Mısır\'ın en iyi Kızıldeniz tatil beldesi, kutsal Sina Yarımadası\'yla buluşuyor — dünya standartlarında resifler, Naama Körfezi ve Aziz Katarina Manastırı.',
      'ja':
          'エジプト随一の紅海リゾートと聖書に登場するシナイ半島——世界レベルのリーフ、ナアマ湾、聖カトリーナ修道院。',
      'zh': '埃及首屈一指的红海度假胜地与圣经中的西奈半岛相遇——世界级珊瑚礁、纳阿玛湾和圣凯瑟琳修道院。',
    },
    gradientColors: [Color(0xFF0A7A62), Color(0xFF15B899)],
    accentColor: Color(0xFF15B899),
    emoji: '🤿',
    heroImage:
        'assets/images/tourist/Sharm_El\u2011Sheikh/Ras_Mohammed_National_Park.jpg',
    transportOptions: [
      TransportOption(
        mode: TransportMode.flight,
        travelTime: {'en': '~1 hour', 'ar': '~ساعة واحدة'},
        apps: [kAppEgyptAir],
      ),
      TransportOption(
        mode: TransportMode.bus,
        travelTime: {'en': '6–8 hours', 'ar': '٦–٨ ساعات'},
        apps: [kAppGoBus],
      ),
    ],
    places: [
      CityPlace(
        names: {
          'en': 'Ras Mohammed National Park',
          'ar': 'منتزه رأس محمد الوطني',
          'de': 'Nationalpark Ras Mohammed',
          'fr': 'Parc national de Ras Mohammed',
          'es': 'Parque nacional de Ras Mohammed',
          'it': 'Parco nazionale di Ras Mohammed',
          'pt': 'Parque nacional de Ras Mohammed',
          'ru': 'Национальный парк Рас-Мохаммед',
          'tr': 'Ras Muhammed Milli Parkı',
          'ja': 'ラス・モハメド国立公園',
          'zh': '穆罕默德角国家公园',
        },
        descs: {
          'en':
              'Egypt\'s premier marine protected area at the tip of Sinai — home to some of the world\'s most diverse and pristine coral reefs.',
          'ar':
              'أفضل منطقة بحرية محمية في مصر عند رأس سيناء — تضم شعابًا مرجانية من أكثر شعاب العالم تنوعًا وبكارةً.',
          'de':
              'Ägyptens führendes Meeresschutzgebiet an der Sinai-Spitze — Heimat einiger der vielfältigsten und intaktesten Korallenriffe der Welt.',
          'fr':
              'La principaire aire marine protégée d\'Égypte à la pointe du Sinaï — abrite certains des récifs coralliens les plus divers et préservés au monde.',
          'es':
              'La principal área marina protegida de Egipto en la punta del Sinaí — hogar de algunos de los arrecifes de coral más diversos y vírgenes del mundo.',
          'it':
              'La principale area marina protetta d\'Egitto alla punta del Sinai — ospita alcune delle barriere coralline più diversificate e intatte al mondo.',
          'pt':
              'A principal área marinha protegida do Egito na ponta do Sinai — lar de alguns dos recifes de coral mais diversos e intocados do mundo.',
          'ru':
              'Главная морская охраняемая зона Египта на оконечности Синая — здесь одни из самых разнообразных и нетронутых коралловых рифов в мире.',
          'tr':
              'Sina burnundaki Mısır\'ın önde gelen deniz koruma alanı — dünyanın en çeşitli ve el değmemiş mercan resiflerinden bazılarına ev sahipliği yapar.',
          'ja':
              'シナイ半島南端のエジプト随一の海洋保護区——世界でも有数の多様で手つかずのサンゴ礁。',
          'zh': '埃及在西奈半岛尖端的旗舰海洋保护区——拥有世界上最多样、最原始的部分珊瑚礁。',
        },
        image:
            'assets/images/tourist/Sharm_El\u2011Sheikh/Ras_Mohammed_National_Park.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Naama Bay',
          'ar': 'خليج نعمة',
          'de': 'Naama Bay',
          'fr': 'Baie de Naama',
          'es': 'Bahía Naama',
          'it': 'Baia di Naama',
          'pt': 'Baía de Naama',
          'ru': 'Бухта Наама',
          'tr': 'Naama Körfezi',
          'ja': 'ナアマ湾',
          'zh': '纳阿玛湾',
        },
        descs: {
          'en':
              'The vibrant heart of Sharm El-Sheikh — beachfront promenade, world-class dive centres, restaurants, and nightlife.',
          'ar':
              'قلب شرم الشيخ النابض — كورنيش شاطئي ومراكز غوص عالمية المستوى ومطاعم وحياة ليلية.',
          'de':
              'Das pulsierende Herz von Scharm el-Scheich — Strandpromenade, Tauchzentren von Weltklasse, Restaurants und Nachtleben.',
          'fr':
              'Le cœur animé de Charm el-Cheikh — promenade en bord de mer, centres de plongée de classe mondiale, restaurants et vie nocturne.',
          'es':
              'El vibrante corazón de Sharm el-Sheij — paseo marítimo, centros de buceo de clase mundial, restaurantes y vida nocturna.',
          'it':
              'Il cuore vivace di Sharm el-Sheikh — lungomare, centri immersione di livello mondiale, ristoranti e vita notturna.',
          'pt':
              'O coração vibrante de Sharm el-Sheikh — passeio à beira-mar, centros de mergulho de classe mundial, restaurantes e vida noturna.',
          'ru':
              'Живой центр Шарм-эль-Шейха — набережная, дайв-центры мирового класса, рестораны и ночная жизнь.',
          'tr':
              'Şarm el-Şeyh\'in hareketli kalbi — sahil yürüyüş yolu, dünya standartlarında dalış merkezleri, restoranlar ve gece hayatı.',
          'ja':
              'シャルム・エル・シェイクの賑やかな中心部——海辺の遊歩道、一流ダイブセンター、レストラン、ナイトライフ。',
          'zh': '沙姆沙伊赫的活力中心——海滨步道、世界级潜水中心、餐厅与夜生活。',
        },
        image: 'assets/images/tourist/Sharm_El\u2011Sheikh/Naama_Bay.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Tiran Island',
          'ar': 'جزيرة تيران',
          'de': 'Insel Tiran',
          'fr': 'Île de Tiran',
          'es': 'Isla Tirán',
          'it': 'Isola di Tiran',
          'pt': 'Ilha de Tiran',
          'ru': 'Остров Тиран',
          'tr': 'Tiran Adası',
          'ja': 'ティラン島',
          'zh': '蒂朗岛',
        },
        descs: {
          'en':
              'Famous for four world-class dive sites at the entrance of the Gulf of Aqaba — a UNESCO-listed island teeming with marine life.',
          'ar':
              'مشهورة بأربعة مواقع غوص عالمية عند مدخل خليج العقبة — جزيرة مدرجة على قائمة اليونسكو تزخر بالحياة البحرية.',
          'de':
              'Berühmt für vier Tauchspots von Weltklasse am Eingang zum Golf von Akaba — UNESCO-Insel voller Meereslebewesen.',
          'fr':
              'Célèbre pour quatre sites de plongée de classe mondiale à l\'entrée du golfe d\'Aqaba — île classée à l\'UNESCO grouillant de vie marine.',
          'es':
              'Famosa por cuatro sitios de buceo de clase mundial a la entrada del golfo de Aqaba — isla UNESCO repleta de vida marina.',
          'it':
              'Famosa per quattro siti di immersione di livello mondiale all\'ingresso del Golfo di Aqaba — isola UNESCO ricca di vita marina.',
          'pt':
              'Famosa por quatro locais de mergulho de classe mundial à entrada do Golfo de Aqaba — ilha UNESCO cheia de vida marinha.',
          'ru':
              'Известна четырьмя дайв-сайтами мирового класса у входа в залив Акаба — остров ЮНЕСКО с богатой морской жизнью.',
          'tr':
              'Akabe Körfezi girişinde dört dünya standartlarında dalış noktasıyla ünlü — deniz canlılarıyla dolu UNESCO adası.',
          'ja':
              'アカバ湾口に世界級のダイブスポットが4つ——ユネスコ登録の島で海洋生物が豊富。',
          'zh': '亚喀巴湾入口处有四个世界级潜水点——列入世界遗产名录、海洋生物繁盛的岛屿。',
        },
        image: 'assets/images/tourist/Sharm_El\u2011Sheikh/Tiran_Island.jpg',
      ),
      CityPlace(
        names: {
          'en': "Shark's Bay",
          'ar': 'خليج القرش',
          'de': 'Shark\'s Bay',
          'fr': 'Baie des Requins',
          'es': 'Bahía de los Tiburones',
          'it': 'Baia degli Squali',
          'pt': 'Baía dos Tubarões',
          'ru': 'Акулья бухта',
          'tr': 'Köpekbalığı Koyu',
          'ja': 'シャークス・ベイ',
          'zh': '鲨鱼湾',
        },
        descs: {
          'en':
              'Calm sheltered bay with shallow, crystal-clear water — ideal for snorkelling, spotting sea turtles, and first-time divers.',
          'ar':
              'خليج هادئ محمي بمياه شفافة ضحلة — مثالي للغوص السطحي ومشاهدة السلاحف البحرية والغاطسين المبتدئين.',
          'de':
              'Ruhige, geschützte Bucht mit flachem, kristallklarem Wasser — ideal zum Schnorcheln, Schildkröten beobachten und für Tauchanfänger.',
          'fr':
              'Baie calme et abritée aux eaux peu profondes et cristallines — idéale pour le tuba, observer les tortues marines et les débutants en plongée.',
          'es':
              'Bahía tranquila y resguardada con aguas poco profundas y cristalinas — ideal para snorkel, tortugas marinas y buceadores primerizos.',
          'it':
              'Baia calma e riparata con acqua bassa e cristallina — ideale per snorkeling, tartarughe marine e sub principianti.',
          'pt':
              'Baía calma e abrigada com águas rasas e cristalinas — ideal para snorkel, tartarugas marinhas e mergulhadores iniciantes.',
          'ru':
              'Спокойная защищённая бухта с мелкой прозрачной водой — идеально для снорклинга, черепах и начинающих дайверов.',
          'tr':
              'Sığ ve berrak sularıyla sakin, korunaklı koy — şnorkel, deniz kaplumbağaları ve yeni başlayan dalgıçlar için ideal.',
          'ja':
              '浅く澄んだ穏やかな湾——シュノーケル、ウミガメ観察、初心者ダイビングに最適。',
          'zh': '平静避风的浅湾，海水清澈——适合浮潜、观赏海龟和初次潜水者。',
        },
        image: "assets/images/tourist/Sharm_El\u2011Sheikh/Shark's_Bay.jpg",
      ),
      CityPlace(
        names: {
          'en': 'SOHO Square',
          'ar': 'ساحة سوهو',
          'de': 'SOHO Square',
          'fr': 'SOHO Square',
          'es': 'SOHO Square',
          'it': 'SOHO Square',
          'pt': 'SOHO Square',
          'ru': 'Площадь SOHO',
          'tr': 'SOHO Meydanı',
          'ja': 'SOHOスクエア',
          'zh': 'SOHO广场',
        },
        descs: {
          'en':
              'Open-air entertainment, shopping, and dining complex with an ice rink, performances, and a lively evening atmosphere.',
          'ar':
              'مجمع ترفيهي وتسوق وطعام مفتوح مع حلبة جليد وعروض ترفيهية وأجواء مسائية نابضة.',
          'de':
              'Freiluft-Komplex für Unterhaltung, Shopping und Essen mit Eislaufbahn, Shows und lebendiger Abendstimmung.',
          'fr':
              'Complexe de plein air pour loisirs, shopping et restauration — patinoire, spectacles et ambiance animée le soir.',
          'es':
              'Complejo al aire libre de ocio, compras y gastronomía con pista de hielo, espectáculos y ambiente nocturno animado.',
          'it':
              'Complesso all\'aperto per intrattenimento, shopping e ristorazione — pista di ghiaccio, spettacoli e serate vivaci.',
          'pt':
              'Complexo ao ar livre de entretenimento, compras e refeições — pista de gelo, espetáculos e ambiente noturno animado.',
          'ru':
              'Открытый комплекс развлечений, шопинга и ресторанов — каток, шоу и оживлённая вечерняя атмосфера.',
          'tr':
              'Buz pisti, gösteriler ve hareketli akşam atmosferiyle açık hava eğlence, alışveriş ve yemek kompleksi.',
          'ja':
              'アイスリンク、パフォーマンス、にぎやかな夜の雰囲気——屋外型の娯楽・ショッピング・ダイニング複合施設。',
          'zh': '露天娱乐、购物与餐饮综合体——含溜冰场、演出和热闹的夜间氛围。',
        },
        image: 'assets/images/tourist/Sharm_El\u2011Sheikh/SOHO_Square_Sharm.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Old Market Sharm',
          'ar': 'السوق القديمة',
          'de': 'Alter Markt Sharm',
          'fr': 'Vieux marché de Sharm',
          'es': 'Mercado viejo de Sharm',
          'it': 'Vecchio mercato di Sharm',
          'pt': 'Mercado velho de Sharm',
          'ru': 'Старый рынок Шарма',
          'tr': 'Şarm Eski Çarşı',
          'ja': 'シャルム旧市場',
          'zh': '沙姆老市场',
        },
        descs: {
          'en':
              'Traditional bazaar with souvenirs, Egyptian spices, hand-crafted jewellery, and the authentic flavour of Sharm.',
          'ar':
              'سوق تقليدية بها هدايا تذكارية وتوابل مصرية ومجوهرات يدوية ونكهة شرم الشيخ الأصيلة.',
          'de':
              'Traditioneller Basar mit Souvenirs, ägyptischen Gewürzen, handgefertigtem Schmuck und authentischem Flair von Sharm.',
          'fr':
              'Bazar traditionnel avec souvenirs, épices égyptiennes, bijoux artisanaux et saveur authentique de Sharm.',
          'es':
              'Zoco tradicional con recuerdos, especias egipcias, joyería artesanal y el sabor auténtico de Sharm.',
          'it':
              'Bazar tradizionale con souvenir, spezie egiziane, gioielli artigianali e il gusto autentico di Sharm.',
          'pt':
              'Bazar tradicional com lembranças, especiarias egípcias, joalharia artesanal e o sabor autêntico de Sharm.',
          'ru':
              'Традиционный базар с сувенирами, египетскими специями, украшениями ручной работы и аутентичной атмосферой Шарма.',
          'tr':
              'Hediyelik eşya, Mısır baharatları, el yapımı takı ve Şarm\'ın otantik havasıyla geleneksel çarşı.',
          'ja':
              'お土産、エジプト香辛料、手作りアクセサリー——シャルムらしい雰囲気の伝統バザール。',
          'zh': '传统集市——纪念品、埃及香料、手工珠宝，充满沙姆的本土风情。',
        },
        image:
            'assets/images/tourist/Sharm_El\u2011Sheikh/Old_Market_Sharm.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Saint Catherine Monastery',
          'ar': 'دير سانت كاترين',
          'de': 'Katharinenkloster',
          'fr': 'Monastère Sainte-Catherine',
          'es': 'Monasterio de Santa Catalina',
          'it': 'Monastero di Santa Caterina',
          'pt': 'Mosteiro de Santa Catarina',
          'ru': 'Монастырь Святой Екатерины',
          'tr': 'Aziz Katarina Manastırı',
          'ja': '聖カトリーナ修道院',
          'zh': '圣凯瑟琳修道院',
        },
        descs: {
          'en':
              'The world\'s oldest continuously operating monastery, built in the 6th century AD at the foot of Mount Sinai — a UNESCO World Heritage Site.',
          'ar':
              'أقدم دير عامل في العالم بلا انقطاع، بُني في القرن السادس الميلادي عند سفح جبل موسى — موقع تراث عالمي.',
          'de':
              'Das älteste ununterbrochen betriebene Kloster der Welt, erbaut im 6. Jh. n. Chr. am Fuß des Sinai — UNESCO-Welterbe.',
          'fr':
              'Le plus ancien monastère encore en activité au monde, fondé au VIe siècle au pied du mont Sinaï — site du patrimoine mondial de l\'UNESCO.',
          'es':
              'El monasterio en funcionamiento más antiguo del mundo, del siglo VI d. C. al pie del monte Sinaí — Patrimonio de la UNESCO.',
          'it':
              'Il monastero più antico ancora attivo al mondo, VI secolo d.C. ai piedi del Monte Sinai — patrimonio UNESCO.',
          'pt':
              'O mosteiro em funcionamento mais antigo do mundo, do século VI d.C. ao pé do Monte Sinai — Património Mundial da UNESCO.',
          'ru':
              'Древнейший непрерывно действующий монастырь в мире, VI век н. э. у подножия Синая — объект Всемирного наследия ЮНЕСКО.',
          'tr':
              'Sina Dağı eteğinde MS 6. yüzyılda kurulan, kesintisiz faaliyet gösteren dünyanın en eski manastırı — UNESCO Dünya Mirası.',
          'ja':
              '6世紀にシナイ山麓に建つ、世界で最も古く活動が続く修道院——ユネスコ世界遺産。',
          'zh': '世界最古老且仍在使用的修道院，建于6世纪，位于西奈山脚下——联合国教科文组织世界遗产。',
        },
        image:
            'assets/images/tourist/Sharm_El\u2011Sheikh/Saint_Catherine_Monastery.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Mount Sinai (Jebel Musa)',
          'ar': 'جبل موسى (سيناء)',
          'de': 'Berg Sinai (Dschabal Mūsā)',
          'fr': 'Mont Sinaï (Jebel Moussa)',
          'es': 'Monte Sinaí (Jebel Musa)',
          'it': 'Monte Sinai (Jebel Musa)',
          'pt': 'Monte Sinai (Jebel Musa)',
          'ru': 'Гора Синай (Джебель Муса)',
          'tr': 'Sina Dağı (Cebel Musa)',
          'ja': 'シナイ山（ジェベル・ムーサー）',
          'zh': '西奈山（摩西山）',
        },
        descs: {
          'en':
              'Biblical mountain where Moses received the Ten Commandments — the pre-dawn hike to the summit for sunrise is a transformative experience.',
          'ar':
              'الجبل الإبراهيمي الذي تلقى عليه موسى الوصايا العشر — التسلق قبيل الفجر للشروق تجربة لا تُنسى.',
          'de':
              'Biblischer Berg, auf dem Mose die Zehn Gebote erhielt — die Wanderung vor Sonnenaufgang zum Gipfel ist ein eindrucksvolles Erlebnis.',
          'fr':
              'Montagne biblique où Moïse reçut les Dix Commandements — l\'ascension avant l\'aube pour le lever du soleil est une expérience inoubliable.',
          'es':
              'Monte bíblico donde Moisés recibió los Diez Mandamientos — subir antes del amanecer para ver el sol nacer es inolvidable.',
          'it':
              'Montagna biblica dove Mosè ricevette i Dieci Comandamenti — l\'ascesa prima dell\'alba per l\'alba è un\'esperienza indimenticabile.',
          'pt':
              'Montanha bíblica onde Moisés recebeu os Dez Mandamentos — a caminhada antes do amanhecer para o nascer do sol é inesquecível.',
          'ru':
              'Библейская гора, где Моисей получил Скрижали Завета — восхождение до рассвета к восходу солнца незабываемо.',
          'tr':
              'Musa\'nın On Emir\'i aldığı kutsal dağ — gün doğumunu görmek için şafak öncesi zirve yürüyüşü unutulmaz bir deneyim.',
          'ja':
              'モーセが十戒を授かった聖書の山——夜明け前に登頂して日の出を見る体験は格別。',
          'zh': '摩西领受十诫的圣经之山——黎明前徒步登顶观日出，是难忘的体验。',
        },
        image: 'assets/images/tourist/Sharm_El\u2011Sheikh/Mount_Sinai.jpg',
      ),
    ],
  ),

  // ── 5. Hurghada ───────────────────────────────────────────────────────────────
  EgyptCity(
    id: 'hurghada',
    names: {
      'en': 'Hurghada',
      'ar': 'الغردقة',
      'de': 'Hurghada',
      'fr': 'Hurghada',
      'es': 'Hurghada',
      'it': 'Hurghada',
      'pt': 'Hurghada',
      'ru': 'Хургада',
      'tr': 'Hurgada',
      'ja': 'フルガダ',
      'zh': '赫尔格达',
    },
    descriptions: {
      'en':
          'A diver\'s paradise on the Red Sea — crystal-clear waters teeming with marine life, pristine coral reefs, and year-round sunshine.',
      'ar':
          'جنة الغواصين على البحر الأحمر — مياه شفافة تعج بالحياة البحرية وشعاب مرجانية بكر وشمس مشرقة طوال العام.',
      'de':
          'Ein Paradies für Taucher am Roten Meer — kristallklares Wasser voller Meereslebewesen, unberührte Korallenriffe und Sonnenschein das ganze Jahr.',
      'fr':
          'Un paradis pour les plongeurs en mer Rouge — eaux cristallines grouillant de vie marine, récifs coralliens vierges et soleil toute l\'année.',
      'es':
          'Un paraíso para buceadores en el Mar Rojo — aguas cristalinas repletas de vida marina, arrecifes de coral vírgenes y sol durante todo el año.',
      'it':
          'Un paradiso per i subacquei nel Mar Rosso — acque cristalline brulicanti di vita marina, barriere coralline incontaminate e sole tutto l\'anno.',
      'pt':
          'Um paraíso para mergulhadores no Mar Vermelho — águas cristalinas repletas de vida marinha, recifes de coral intocados e sol durante todo o ano.',
      'ru':
          'Рай для дайверов на Красном море — кристально чистые воды с богатой морской жизнью, нетронутые коралловые рифы и солнце круглый год.',
      'tr':
          'Kızıldeniz\'de dalış cenneti — deniz canlılarıyla dolu kristal berraklığında sular, bozulmamış mercan resifleri ve yıl boyunca güneş.',
      'ja':
          '紅海のダイバーの楽園——海洋生物が豊富なクリスタルクリアの海、手つかずのサンゴ礁、年間を通じた日差し。',
      'zh': '红海潜水者的天堂——清澈见底的海水中海洋生物丰富，原始的珊瑚礁和全年灿烂的阳光。',
    },
    gradientColors: [Color(0xFF005F8A), Color(0xFF0096C7)],
    accentColor: Color(0xFF0096C7),
    emoji: '🐠',
    heroImage: 'assets/images/tourist/Hurghada/Giftun_Island.jpg',
    transportOptions: [
      TransportOption(
        mode: TransportMode.flight,
        travelTime: {'en': '~1 hour', 'ar': '~ساعة واحدة'},
        apps: [kAppEgyptAir],
      ),
      TransportOption(
        mode: TransportMode.bus,
        travelTime: {'en': '5–6 hours', 'ar': '٥–٦ ساعات'},
        apps: [kAppGoBus, kAppBlueBus],
      ),
    ],
    places: [
      CityPlace(
        names: {
          'en': 'Giftun Island',
          'ar': 'جزيرة جفتون',
          'de': 'Insel Giftun',
          'fr': 'Île Giftun',
          'es': 'Isla Giftun',
          'it': 'Isola Giftun',
          'pt': 'Ilha Giftun',
          'ru': 'Остров Гифтун',
          'tr': 'Giftun Adası',
          'ja': 'ギフトゥン島',
          'zh': '吉夫顿岛',
        },
        descs: {
          'en':
              'Protected island park with pristine white-sand beaches and crystal-clear snorkelling waters inside Giftun National Park.',
          'ar':
              'جزيرة محمية بشواطئ رملية بيضاء بكر ومياه شفافة رائعة للغوص السطحي ضمن منتزه جفتون الوطني.',
          'de':
              'Geschützte Insel mit weißen Sandstränden und kristallklarem Schnorchelwasser im Nationalpark Giftun.',
          'fr':
              'Île protégée avec plages de sable blanc immaculées et eaux cristallines pour le tuba dans le parc national de Giftun.',
          'es':
              'Isla protegida con playas de arena blanca vírgenes y aguas cristalinas para snorkel en el parque nacional de Giftun.',
          'it':
              'Isola protetta con spiagge bianche incontaminate e acque cristalline per lo snorkeling nel parco nazionale di Giftun.',
          'pt':
              'Ilha protegida com praias de areia branca intocadas e águas cristalinas para snorkel no parque nacional de Giftun.',
          'ru':
              'Охраняемый остров с нетронутыми белыми пляжами и прозрачной водой для снорклинга в национальном парке Гифтун.',
          'tr':
              'Giftun Milli Parkı içinde el değmemiş beyaz kumlu plajlar ve şeffaf şnorkel sularıyla korunan ada.',
          'ja':
              'ギフトゥン国立公園内の保護島——真っ白な砂浜とシュノーケルに最適な澄んだ海。',
          'zh': '吉夫顿国家公园内的保护岛屿——原始白沙滩与清澈浮潜水域。',
        },
        image: 'assets/images/tourist/Hurghada/Giftun_Island.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Hurghada Marina',
          'ar': 'مارينا الغردقة',
          'de': 'Hurghada Marina',
          'fr': 'Marina d\'Hurghada',
          'es': 'Marina de Hurghada',
          'it': 'Marina di Hurghada',
          'pt': 'Marina de Hurghada',
          'ru': 'Марина Хургады',
          'tr': 'Hurgada Marina',
          'ja': 'フルガダ・マリーナ',
          'zh': '赫尔格达游艇港',
        },
        descs: {
          'en':
              'Lively waterfront marina with an array of restaurants, boutiques, dive centres, and evening boat trips.',
          'ar':
              'مارينا واجهة مائية حيوية بمطاعم وبوتيكات ومراكز غوص ورحلات قاربية مسائية.',
          'de':
              'Lebhafte Marina mit Restaurants, Boutiquen, Tauchzentren und abendlichen Bootstouren.',
          'fr':
              'Marina animée en bord de mer avec restaurants, boutiques, centres de plongée et sorties en bateau le soir.',
          'es':
              'Marina animada frente al mar con restaurantes, boutiques, centros de buceo y paseos en barco por la noche.',
          'it':
              'Marina vivace sul lungomare con ristoranti, boutique, centri immersione e uscite in barca serali.',
          'pt':
              'Marina animada à beira-mar com restaurantes, boutiques, centros de mergulho e passeios de barco ao entardecer.',
          'ru':
              'Оживлённая марина на набережной — рестораны, бутики, дайв-центры и вечерние морские прогулки.',
          'tr':
              'Restoranlar, butikler, dalış merkezleri ve akşam tekne turlarıyla canlı bir sahil marinası.',
          'ja':
              'レストラン、ブティック、ダイブセンター、夜のボートクルーズ——にぎやかな海辺のマリーナ。',
          'zh': '热闹的海滨游艇码头——餐厅、精品店、潜水中心和晚间乘船游览。',
        },
        image: 'assets/images/tourist/Hurghada/Hurghada_Marina.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Mahmya Beach',
          'ar': 'شاطئ محميا',
          'de': 'Strand Mahmya',
          'fr': 'Plage de Mahmya',
          'es': 'Playa Mahmya',
          'it': 'Spiaggia di Mahmya',
          'pt': 'Praia Mahmya',
          'ru': 'Пляж Махмья',
          'tr': 'Mahmya Plajı',
          'ja': 'マフミヤ・ビーチ',
          'zh': '马赫米亚海滩',
        },
        descs: {
          'en':
              'Stunning private-island beach experience within Giftun National Park — voted one of Egypt\'s most beautiful beaches.',
          'ar':
              'تجربة شاطئ جزيرة خاصة مذهلة ضمن منتزه جفتون — مصنّف من أجمل شواطئ مصر.',
          'de':
              'Beeindruckender Privatinsel-Strand im Nationalpark Giftun — zu den schönsten Stränden Ägyptens gezählt.',
          'fr':
              'Magnifique plage d\'île privée dans le parc national de Giftun — parmi les plus belles plages d\'Égypte.',
          'es':
              'Espectacular playa de isla privada en el parque nacional de Giftun — considerada una de las más bellas de Egipto.',
          'it':
              'Splendida spiaggia su isola privata nel parco nazionale di Giftun — tra le più belle d\'Egitto.',
          'pt':
              'Deslumbrante praia de ilha privada no parque nacional de Giftun — entre as mais bonitas do Egito.',
          'ru':
              'Потрясающий пляж на частном острове в национальном парке Гифтун — один из красивейших пляжей Египта.',
          'tr':
              'Giftun Milli Parkı içinde özel ada plajı deneyimi — Mısır\'ın en güzel plajlarından biri sayılır.',
          'ja':
              'ギフトゥン国立公園内のプライベート島ビーチ——エジプト最美のビーチの一つ。',
          'zh': '吉夫顿国家公园内的私人岛海滩体验——被誉为埃及最美海滩之一。',
        },
        image: 'assets/images/tourist/Hurghada/Mahmya_Beach.jpg',
      ),
      CityPlace(
        names: {
          'en': 'El Gouna',
          'ar': 'الجونة',
          'de': 'El Gouna',
          'fr': 'El Gouna',
          'es': 'El Gouna',
          'it': 'El Gouna',
          'pt': 'El Gouna',
          'ru': 'Эль-Гуна',
          'tr': 'El Guna',
          'ja': 'エル・グナ',
          'zh': '艾尔古纳',
        },
        descs: {
          'en':
              'Exclusive lagoon resort town 30 min from Hurghada — canals, water taxis, boutique hotels, and world-class golf courses.',
          'ar':
              'مدينة منتجعية فاخرة على اللاجونات على بُعد 30 دقيقة من الغردقة — قنوات وتاكسي مائي وفنادق بوتيك وملاعب جولف.',
          'de':
              'Exklusive Lagunen-Resortstadt 30 Min. von Hurghada — Kanäle, Wassertaxis, Boutique-Hotels und Golfplätze von Weltklasse.',
          'fr':
              'Station balnéaire exclusive sur lagune à 30 min d\'Hurghada — canaux, taxis aquatiques, hôtels-boutiques et golfs de classe mondiale.',
          'es':
              'Ciudad resort exclusiva en laguna a 30 min de Hurghada — canales, taxis acuáticos, hoteles boutique y campos de golf de primer nivel.',
          'it':
              'Esclusiva città resort sulla laguna a 30 min da Hurghada — canali, taxi acquatici, hotel boutique e campi da golf di livello mondiale.',
          'pt':
              'Cidade-balneário exclusiva em lagoa a 30 min de Hurghada — canais, táxis aquáticos, hotéis boutique e campos de golfe de classe mundial.',
          'ru':
              'Элитный курортный город на лагуне в 30 минутах от Хургады — каналы, водные такси, бутик-отели и поля для гольфа мирового класса.',
          'tr':
              'Hurgada\'ya 30 dk mesafede lagün üzerinde seçkin tatil kasabası — kanallar, su taksi butik oteller ve dünya standartlarında golf sahaları.',
          'ja':
              'フルガダから30分のラグーン型高級リゾート——運河、水上タクシー、ブティックホテル、世界級ゴルフ場。',
          'zh': '距赫尔格达30分钟的泻湖度假城——运河、水上出租车、精品酒店与一流高尔夫球场。',
        },
        image: 'assets/images/tourist/Hurghada/El_Gouna.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Abu Ramada Island',
          'ar': 'جزيرة أبو رمادة',
          'de': 'Insel Abu Ramada',
          'fr': 'Île Abu Ramada',
          'es': 'Isla Abu Ramada',
          'it': 'Isola Abu Ramada',
          'pt': 'Ilha Abu Ramada',
          'ru': 'Остров Абу-Рамада',
          'tr': 'Abu Ramada Adası',
          'ja': 'アブ・ラマダ島',
          'zh': '阿布拉马达岛',
        },
        descs: {
          'en':
              'Spectacular coral garden island — one of Hurghada\'s finest snorkelling and diving day-trip destinations.',
          'ar':
              'جزيرة ذات حديقة مرجانية رائعة — من أفضل وجهات رحلات الغوص والغوص السطحي اليومية في الغردقة.',
          'de':
              'Spektakuläre Korallengarten-Insel — eines der besten Tagesausflugsziele zum Schnorcheln und Tauchen in Hurghada.',
          'fr':
              'Île-jardin de coraux spectaculaire — l\'une des meilleures excursions d\'une journée pour tuba et plongée depuis Hurghada.',
          'es':
              'Isla jardín de coral espectacular — uno de los mejores destinos de excursión de un día para snorkel y buceo desde Hurghada.',
          'it':
              'Isola-giardino corallino spettacolare — tra le migliori mete giornaliere per snorkeling e immersioni da Hurghada.',
          'pt':
              'Ilha-jardim de corais espetacular — um dos melhores destinos de passeio de um dia para snorkel e mergulho a partir de Hurghada.',
          'ru':
              'Захватывающий «коралловый сад» — одно из лучших мест для дневных поездок на снорклинг и дайвинг из Хургады.',
          'tr':
              'Muhteşem mercan bahçesi adası — Hurgada\'dan şnorkel ve dalış günübirlik gezileri için en iyi duraklardan biri.',
          'ja':
              '壮観なサンゴの庭の島——フルガダ発日帰りシュノーケル・ダイビングの名所。',
          'zh': '壮观的珊瑚花园岛——赫尔格达出发一日浮潜与潜水的最佳目的地之一。',
        },
        image: 'assets/images/tourist/Hurghada/Abu_Ramada_Island.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Desert Safari',
          'ar': 'سفاري الصحراء',
          'de': 'Wüstensafari',
          'fr': 'Safari dans le désert',
          'es': 'Safari por el desierto',
          'it': 'Safari nel deserto',
          'pt': 'Safari no deserto',
          'ru': 'Пустынное сафари',
          'tr': 'Çöl Safarisi',
          'ja': 'デザート・サファリ',
          'zh': '沙漠越野',
        },
        descs: {
          'en':
              'ATV and quad-bike adventures through the Eastern Desert dunes, with a sunset Bedouin camp experience.',
          'ar':
              'مغامرات رباعية الدفع وكواد بايك عبر كثبان الصحراء الشرقية مع تجربة مخيم بدوي عند الغروب.',
          'de':
              'ATV- und Quad-Touren durch die Dünen der Östlichen Wüste mit Beduinenlager-Erlebnis bei Sonnenuntergang.',
          'fr':
              'Aventures en quad et VTT dans les dunes du désert oriental, avec campement bédouin au coucher du soleil.',
          'es':
              'Aventuras en quad y ATV por las dunas del desierto oriental, con campamento beduino al atardecer.',
          'it':
              'Avventure in quad e ATV tra le dune del deserto orientale, con accampamento beduino al tramonto.',
          'pt':
              'Aventuras de quad e ATV pelas dunas do deserto oriental, com acampamento beduíno ao pôr do sol.',
          'ru':
              'Приключения на квадроциклах по дюнам Восточной пустыни с бедуинским лагерем на закате.',
          'tr':
              'Doğu Çölü kumullarında ATV ve quad maceraları, gün batımında Bedevi kampı deneyimiyle.',
          'ja':
              '東部砂漠の砂丘をATV・四輪バイクで横断——夕暮れのベドウィンキャンプ体験付き。',
          'zh': '驾驶ATV与四轮摩托穿越东部沙漠沙丘，并体验日落时的贝都因营地。',
        },
        image: 'assets/images/tourist/Hurghada/Desert_Safari_Hurghada.jpg',
      ),
    ],
  ),

  // ── 6. Dahab ──────────────────────────────────────────────────────────────────
  EgyptCity(
    id: 'dahab',
    names: {
      'en': 'Dahab',
      'ar': 'دهب',
      'de': 'Dahab',
      'fr': 'Dahab',
      'es': 'Dahab',
      'it': 'Dahab',
      'pt': 'Dahab',
      'ru': 'Дахаб',
      'tr': 'Dahab',
      'ja': 'ダハブ',
      'zh': '达哈布',
    },
    descriptions: {
      'en':
          'A laid-back Bedouin beach village on the Gulf of Aqaba — legendary dive sites like the Blue Hole, world-class windsurfing, and a truly relaxed vibe.',
      'ar':
          'قرية شاطئية بدوية هادئة على خليج العقبة — مواقع غوص أسطورية كالثقب الأزرق وركوب أمواج الرياح العالمي وأجواء متراخية حقيقية.',
      'de':
          'Ein entspanntes Beduinendorf am Golf von Akaba — legendäre Tauchplätze wie das Blaue Loch, weltklasse Windsurfen und eine wirklich entspannte Atmosphäre.',
      'fr':
          'Un village bédouin détendu sur le golfe d\'Aqaba — sites de plongée légendaires comme le Blue Hole, windsurf de classe mondiale et une ambiance vraiment décontractée.',
      'es':
          'Un tranquilo pueblo beduino en el Golfo de Aqaba — lugares de buceo legendarios como el Blue Hole, windsurf de clase mundial y un ambiente verdaderamente relajado.',
      'it':
          'Un villaggio beduino rilassato sul Golfo di Aqaba — siti di immersione leggendari come la Buca Blu, windsurf di livello mondiale e un\'atmosfera davvero rilassata.',
      'pt':
          'Uma tranquila aldeia beduína no Golfo de Aqaba — locais de mergulho lendários como o Blue Hole, windsurf de classe mundial e um ambiente verdadeiramente descontraído.',
      'ru':
          'Спокойная бедуинская деревня в заливе Акаба — легендарные места для дайвинга, такие как Голубая дыра, виндсёрфинг мирового класса и поистине расслабленная атмосфера.',
      'tr':
          'Akabe Körfezi\'nde sakin bir Bedevi köyü — Mavi Delik gibi efsanevi dalış noktaları, dünya standartlarında rüzgâr sörfü ve gerçekten rahat bir ortam.',
      'ja':
          'アカバ湾の落ち着いたベドウィンの村——ブルーホールなど伝説のダイブサイト、世界レベルのウィンドサーフィン、本当にのんびりした雰囲気。',
      'zh': '亚喀巴湾悠闲的贝都因海滩村落——蓝洞等传奇潜水胜地、世界级风帆冲浪和真正轻松的氛围。',
    },
    gradientColors: [Color(0xFF8B5E1A), Color(0xFFB8872A)],
    accentColor: Color(0xFFB8872A),
    emoji: '🌊',
    heroImage: 'assets/images/tourist/Dahab/Blue_Hole_Dahab.jpg',
    transportOptions: [
      TransportOption(
        mode: TransportMode.flight,
        travelTime: {
          'en': 'Fly to Sharm (~1 hr), then bus ~1.5 hrs',
          'ar': 'طيران لشرم (~ساعة)، ثم أتوبيس ~١.٥ ساعة',
        },
        apps: [kAppEgyptAir],
      ),
      TransportOption(
        mode: TransportMode.busFromSharm,
        travelTime: {'en': '~1.5 hours from Sharm', 'ar': '~١.٥ ساعة من شرم'},
        apps: [kAppGoBus],
      ),
    ],
    places: [
      CityPlace(
        names: {
          'en': 'Blue Hole',
          'ar': 'الثقب الأزرق',
          'de': 'Blue Hole',
          'fr': 'Blue Hole',
          'es': 'Blue Hole',
          'it': 'Blue Hole',
          'pt': 'Blue Hole',
          'ru': 'Голубая дыра',
          'tr': 'Mavi Delik',
          'ja': 'ブルーホール',
          'zh': '蓝洞',
        },
        descs: {
          'en':
              'World-famous 160 m underwater sinkhole with a 26 m underwater arch — one of Egypt\'s most iconic (and challenging) dive sites.',
          'ar':
              'هوّة مائية أسطورية عالميًا بعمق 160 مترًا وقوس تحت الماء بعمق 26 مترًا — أحد أشهر مواقع الغوص في مصر وأكثرها صعوبةً.',
          'de':
              'Weltberühmte 160 m tiefe Unterwasser-Doline mit 26 m Unterwasserbogen — einer der ikonischsten (und anspruchsvollsten) Tauchplätze Ägyptens.',
          'fr':
              'Doline sous-marine mondialement célèbre de 160 m avec arche à 26 m de profondeur — l\'un des sites de plongée les plus emblématiques (et exigeants) d\'Égypte.',
          'es':
              'Sumidero submarino mundialmente famoso de 160 m con arco a 26 m — uno de los sitios de buceo más icónicos (y exigentes) de Egipto.',
          'it':
              'Sinkhole sottomarino mondiale di 160 m con arco a 26 m — uno dei siti di immersione più iconici (e impegnativi) d\'Egitto.',
          'pt':
              'Buraco subaquático mundialmente famoso de 160 m com arco a 26 m — um dos locais de mergulho mais icónicos (e exigentes) do Egito.',
          'ru':
              'Всемирно известная 160-метровая подводная воронка с аркой на глубине 26 м — один из самых знаменитых (и сложных) дайв-сайтов Египта.',
          'tr':
              '26 m sualtı kemeriyle dünyaca ünlü 160 m sualtı çukuru — Mısır\'ın en simgesel (ve zorlu) dalış noktalarından biri.',
          'ja':
              '水深160mの世界的に有名な水中陥没孔と水深26mのアーチ——エジプトで最も象徴的で難易度の高いダイブサイトの一つ。',
          'zh': '世界闻名的160米深水下 sinkhole，含26米深水下拱门——埃及最具标志性和挑战性的潜水点之一。',
        },
        image: 'assets/images/tourist/Dahab/Blue_Hole_Dahab.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Blue Lagoon',
          'ar': 'البحيرة الزرقاء',
          'de': 'Blue Lagoon',
          'fr': 'Blue Lagoon',
          'es': 'Blue Lagoon',
          'it': 'Blue Lagoon',
          'pt': 'Blue Lagoon',
          'ru': 'Голубая лагуна',
          'tr': 'Mavi Lagün',
          'ja': 'ブルー・ラグーン',
          'zh': '蓝湖',
        },
        descs: {
          'en':
              'A perfect shallow turquoise lagoon — the go-to spot for windsurfing, kitesurfing, and learning water sports in calm conditions.',
          'ar':
              'لاجون فيروزي ضحل رائع — الوجهة المثلى لرياضة الشراع والكايتسيرف وتعلم الرياضات المائية في أجواء هادئة.',
          'de':
              'Perfekte flache türkisfarbene Lagune — Hotspot für Windsurfen, Kitesurfen und Wassersport bei ruhigen Bedingungen.',
          'fr':
              'Parfaite lagune turquoise peu profonde — le lieu incontournable pour planche à voile, kitesurf et sports nautiques au calme.',
          'es':
              'Perfecta laguna turquesa y poco profunda — el sitio ideal para windsurf, kitesurf y deportes acuáticos en calma.',
          'it':
              'Perfetta laguna turchese e bassa — meta per windsurf, kitesurf e sport acquatici in condizioni calme.',
          'pt':
              'Perfeita lagoa turquesa e rasa — o local ideal para windsurf, kitesurf e desportos aquáticos em calmaria.',
          'ru':
              'Идеальная мелкая бирюзовая лагуна — лучшее место для виндсёрфинга, кайтсёрфинга и спокойного обучения водным видам спорта.',
          'tr':
              'Mükemmel sığ turkuaz lagün — sakin koşullarda rüzgâr sörfü, uçurtma sörfü ve su sporları öğrenmek için gözde nokta.',
          'ja':
              '浅く透き通ったターコイズの潟——穏やかな海況でウィンドサーフ、カイトサーフ、水上スポーツ習得に最適。',
          'zh': '完美的浅绿松石色泻湖——风帆、风筝冲浪及平静条件下学习水上运动的首选地。',
        },
        image: 'assets/images/tourist/Dahab/Blue_Lagoon_Dahab.png',
      ),
      CityPlace(
        names: {
          'en': 'Lighthouse Reef',
          'ar': 'شعب الفنار',
          'de': 'Lighthouse Reef',
          'fr': 'Récif du phare',
          'es': 'Arrecife del Faro',
          'it': 'Barriera del Faro',
          'pt': 'Recife do Farol',
          'ru': 'Риф у маяка',
          'tr': 'Fener Resifi',
          'ja': '灯台礁',
          'zh': '灯塔礁',
        },
        descs: {
          'en':
              'Colourful shallow reef right in the town centre — great for beginner snorkellers and night divers, with abundant reef fish.',
          'ar':
              'شعاب مرجانية ملونة ضحلة في وسط البلدة — رائعة للغطس السطحي والغوص الليلي وكثيرة الأسماك المرجانية.',
          'de':
              'Bunter flacher Riff direkt im Stadtzentrum — ideal für Schnorchelanfänger und Nachttaucher, mit vielen Rifffischen.',
          'fr':
              'Récif coloré et peu profond en plein centre-ville — idéal pour débutants en tuba et plongée de nuit, poissons de récif abondants.',
          'es':
              'Arrecife colorido y poco profundo en el centro — ideal para snorkel principiantes y buceo nocturno, con muchos peces de arrecife.',
          'it':
              'Barriera colorata e bassa in centro — ottima per snorkeling principianti e immersioni notturne, con abbondanti pesci della barriera.',
          'pt':
              'Recife colorido e raso no centro — ótimo para snorkel iniciante e mergulho noturno, com muitos peixes de recife.',
          'ru':
              'Красочный мелкий риф в центре города — отлично для начинающих сноркелистов и ночных дайверов, много рифовых рыб.',
          'tr':
              'Şehir merkezinde renkli sığ resif — başlangıç şnorkeli ve gece dalgıçları için harika, mercan balıkları bol.',
          'ja':
              '街の中心にある色鮮やかな浅い礁——初心者シュノーケルとナイトダイビングに適し、礁の魚が豊富。',
          'zh': '位于镇中心的彩色浅礁——适合浮潜新手与夜潜，礁鱼丰富。',
        },
        image: 'assets/images/tourist/Dahab/Lighthouse_Reef_Dahab.jpg',
      ),
      CityPlace(
        names: {
          'en': 'The Canyon (Three Pools)',
          'ar': 'الكانيون (التجمعات الثلاث)',
          'de': 'Der Canyon (Three Pools)',
          'fr': 'Le Canyon (Three Pools)',
          'es': 'El Cañón (Three Pools)',
          'it': 'Il Canyon (Three Pools)',
          'pt': 'O Cânion (Three Pools)',
          'ru': 'Каньон (Три бассейна)',
          'tr': 'Kanyon (Üç Havuz)',
          'ja': 'キャニオン（スリープール）',
          'zh': '峡谷（三池）',
        },
        descs: {
          'en':
              'Stunning geological canyon with interconnected natural pools — perfect for snorkelling, free-diving, and exploring underwater crevices.',
          'ar':
              'كانيون جيولوجي مذهل بمسابح طبيعية متصلة — مثالي للغطس السطحي والغوص الحر واستكشاف التجاويف تحت الماء.',
          'de':
              'Spektakuläre geologische Schlucht mit verbundenen natürlichen Pools — perfekt zum Schnorcheln, Apnoetauchen und Erkunden von Unterwasserritzen.',
          'fr':
              'Canyon géologique saisissant avec bassins naturels reliés — parfait pour tuba, apnée et exploration des fissures sous-marines.',
          'es':
              'Impresionante cañón geológico con pozas naturales interconectadas — perfecto para snorkel, apnea y grietas submarinas.',
          'it':
              'Spettacolare canyon geologico con pozze naturali collegate — perfetto per snorkeling, apnea ed esplorazione di crepe sottomarine.',
          'pt':
              'Cânion geológico deslumbrante com piscinas naturais interligadas — perfeito para snorkel, mergulho livre e fendas subaquáticas.',
          'ru':
              'Потрясающий геологический каньон со связанными природными бассейнами — идеально для снорклинга, фридайвинга и исследования подводных расщелин.',
          'tr':
              'Birbirine bağlı doğal havuzlarla çarpıcı jeolojik kanyon — şnorkel, serbest dalış ve su altı yarıklarını keşfetmek için mükemmel.',
          'ja':
              'つながった自然のプールがある壮観な地質の峡谷——シュノーケル、フリーダイビング、水中の裂け目探検に最適。',
          'zh': '壮观的地质峡谷与相连的天然水池——浮潜、自由潜与探索水下裂缝的绝佳去处。',
        },
        image: 'assets/images/tourist/Dahab/Three_Pools_Dahab.jpg',
      ),
    ],
  ),

  // ── 7. Siwa Oasis ─────────────────────────────────────────────────────────────
  EgyptCity(
    id: 'siwa',
    names: {
      'en': 'Siwa Oasis',
      'ar': 'واحة سيوة',
      'de': 'Oase Siwa',
      'fr': 'Oasis de Siwa',
      'es': 'Oasis de Siwa',
      'it': 'Oasi di Siwa',
      'pt': 'Oásis de Siwa',
      'ru': 'Оазис Сива',
      'tr': 'Siwa Vadisi',
      'ja': 'シワ・オアシス',
      'zh': '锡瓦绿洲',
    },
    descriptions: {
      'en':
          'A remote desert oasis near Libya — where Alexander the Great consulted the oracle; today it offers salt lakes, golden dunes, and Berber culture.',
      'ar':
          'واحة صحراوية نائية قرب ليبيا — جاء إليها الإسكندر الأكبر ليستشير العرافة؛ اليوم تقدم بحيرات ملحية وكثبانًا ذهبية وثقافة أمازيغية.',
      'de':
          'Eine abgelegene Wüstenoase nahe Libyen — wo Alexander der Große das Orakel befragte; heute mit Salzseen, goldenen Dünen und Berberkultur.',
      'fr':
          'Une oasis désertique isolée près de la Libye — où Alexandre le Grand consulta l\'oracle ; aujourd\'hui avec des lacs salés, des dunes dorées et une culture berbère.',
      'es':
          'Un oasis desértico remoto cerca de Libia — donde Alejandro Magno consultó el oráculo; hoy ofrece lagos salados, dunas doradas y cultura bereber.',
      'it':
          'Un\'oasi desertica remota vicino alla Libia — dove Alessandro Magno consultò l\'oracolo; oggi offre laghi salati, dune dorate e cultura berbera.',
      'pt':
          'Um oásis desértico remoto perto da Líbia — onde Alexandre, o Grande, consultou o oráculo; hoje oferece lagos salgados, dunas douradas e cultura berbere.',
      'ru':
          'Отдалённый пустынный оазис вблизи Ливии — где Александр Македонский вопрошал оракула; сегодня здесь солёные озёра, золотые дюны и берберская культура.',
      'tr':
          'Libya yakınlarında ıssız bir çöl vahası — Büyük İskender\'in kehaneti sorduğu yer; bugün tuz gölleri, altın kum tepeleri ve Berber kültürü sunuyor.',
      'ja':
          'リビア近くの人里離れた砂漠のオアシス——アレクサンダー大王が神託を求めた地。今は塩湖、黄金の砂丘、ベルベル文化が魅力。',
      'zh': '靠近利比亚的偏远沙漠绿洲——亚历山大大帝曾在此问神谕；今日有盐湖、金色沙丘和柏柏尔文化。',
    },
    gradientColors: [Color(0xFF2D6B3F), Color(0xFF3E9050)],
    accentColor: Color(0xFF3E9050),
    emoji: '🌴',
    heroImage: 'assets/images/tourist/Siwa_Oasis/Temple_of_the_Oracle.jpg',
    transportOptions: [
      TransportOption(
        mode: TransportMode.bus,
        travelTime: {'en': '10–12 hours', 'ar': '١٠–١٢ ساعة'},
        apps: [kAppGoBus],
      ),
    ],
    places: [
      CityPlace(
        names: {
          'en': 'Temple of the Oracle',
          'ar': 'معبد العرّاف',
          'de': 'Orakel-Tempel',
          'fr': 'Temple de l\'oracle',
          'es': 'Templo del oráculo',
          'it': 'Tempio dell\'oracolo',
          'pt': 'Templo do oráculo',
          'ru': 'Храм оракула',
          'tr': 'Kâhin Tapınağı',
          'ja': '神託所神殿',
          'zh': '神谕庙',
        },
        descs: {
          'en':
              'Ancient hilltop oracle sanctuary where Alexander the Great was reportedly declared the son of the god Ammon in 331 BC.',
          'ar':
              'معبد أوراكل قديم على التلة حيث أُعلن الإسكندر الأكبر ابنًا للإله آمون عام 331 قبل الميلاد.',
          'de':
              'Antikes Orakelheiligtum auf dem Hügel — hier soll Alexander der Große 331 v. Chr. zum Sohn des Gottes Ammon erklärt worden sein.',
          'fr':
              'Sanctuaire oraculaire antique sur la colline où Alexandre le Grand fut déclaré fils du dieu Amon en 331 av. J.-C.',
          'es':
              'Santuario del oráculo antiguo en la colina donde se dice que Alejandro Magno fue declarado hijo del dios Amón en el 331 a. C.',
          'it':
              'Antico santuario dell\'oracolo sulla collina dove Alessandro Magno fu dichiarato figlio del dio Ammone nel 331 a.C.',
          'pt':
              'Santuário do oráculo antigo no monte onde Alexandre, o Grande, foi declarado filho do deus Amón em 331 a.C.',
          'ru':
              'Древнее оракульное святилище на холме — здесь в 331 г. до н. э. Александра Македонского провозгласили сыном бога Амона.',
          'tr':
              'MÖ 331\'de Büyük İskender\'in tanrı Amon\'un oğlu ilan edildiği söylenen antik tepe üstü kehanet kutsal alanı.',
          'ja':
              '紀元前331年、アレクサンダー大王が神アモンの子と宣言されたという丘の上の古代神託所。',
          'zh': '古代山顶神谕圣地——相传公元前331年亚历山大大帝在此被宣布为阿蒙神之子。',
        },
        image: 'assets/images/tourist/Siwa_Oasis/Temple_of_the_Oracle.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Shali Fortress',
          'ar': 'قلعة شالي',
          'de': 'Festung Shali',
          'fr': 'Forteresse de Shali',
          'es': 'Fortaleza de Shali',
          'it': 'Fortezza di Shali',
          'pt': 'Fortaleza de Shali',
          'ru': 'Крепость Шали',
          'tr': 'Şali Kalesi',
          'ja': 'シャリ要塞',
          'zh': '沙利堡',
        },
        descs: {
          'en':
              'Ruined medieval fortress built from kershef (salt and clay) offering panoramic views over the oasis and surrounding dunes.',
          'ar':
              'قلعة قروسطية مهجورة مبنية من الكرشيف (ملح وطين) توفر إطلالات بانورامية على الواحة والكثبان المحيطة.',
          'de':
              'Ruinierte mittelalterliche Festung aus Kerschef (Salz und Lehm) mit Panoramablick auf die Oase und die Dünen.',
          'fr':
              'Forteresse médiévale en ruine en kershef (sel et argile) avec vue panoramique sur l\'oasis et les dunes.',
          'es':
              'Fortaleza medieval en ruinas de kershef (sal y arcilla) con vistas panorámicas al oasis y las dunas.',
          'it':
              'Fortificazione medievale in rovina in kershef (sale e argilla) con vista panoramica sull\'oasi e sulle dune.',
          'pt':
              'Fortaleza medieval em ruínas de kershef (sal e barro) com vista panorâmica sobre o oásis e as dunas.',
          'ru':
              'Разрушенная средневековая крепость из кершифа (соль и глина) — панорама оазиса и окружающих дюн.',
          'tr':
              'Kershef (tuz ve kil) ile yapılmış harap ortaçağ kalesi — vaha ve çevredeki kumullara panoramik manzara.',
          'ja':
              'ケルシェフ（塩と粘土）で造られた中世要塞の墟——オアシスと周囲の砂丘を一望できる。',
          'zh': '用盐土坯（kershef）建造的中世纪要塞废墟——可俯瞰绿洲与周围沙丘。',
        },
        image: 'assets/images/tourist/Siwa_Oasis/Shali_Fortress.jpg',
      ),
      CityPlace(
        names: {
          'en': "Cleopatra's Spring",
          'ar': 'عين كليوباترا',
          'de': 'Kleopatras Quelle',
          'fr': 'Source de Cléopâtre',
          'es': 'Manantial de Cleopatra',
          'it': 'Sorgente di Cleopatra',
          'pt': 'Nascente de Cleópatra',
          'ru': 'Родник Клеопатры',
          'tr': 'Kleopatra Pınarı',
          'ja': 'クレオパトラの泉',
          'zh': '克利奥帕特拉泉',
        },
        descs: {
          'en':
              'A natural freshwater spring pool where locals believe Cleopatra bathed — a refreshing dip in the desert.',
          'ar':
              'ينبوع مياه عذبة طبيعي يعتقد أهل الواحة أن كليوباترا كانت تستحم فيه — سباحة منعشة في الصحراء.',
          'de':
              'Natürlicher Süßwasserbrunnen, an dem die Einheimischen glauben, Kleopatra gebadet zu haben — erfrischendes Bad in der Wüste.',
          'fr':
              'Source d\'eau douce naturelle où, selon la tradition locale, Cléopâtre se baignait — baignade revigorante au désert.',
          'es':
              'Manantial natural de agua dulce donde los lugareños creen que se bañaba Cleopatra — un chapuzón refrescante en el desierto.',
          'it':
              'Sorgente naturale d\'acqua dolce dove si crede che si bagnasse Cleopatra — tuffo rinfrescante nel deserto.',
          'pt':
              'Nascente natural de água doce onde se acredita que Cleópatra se banhava — mergulho revigorante no deserto.',
          'ru':
              'Природный пресноводный источник, где, по местным преданиям, купалась Клеопатра — освежающее купание в пустыне.',
          'tr':
              'Yerlilerin Kleopatra\'nın yıkandığına inandığı doğal tatlı su kaynağı — çölde ferahlatıcı bir yüzme.',
          'ja':
              '地元の人がクレオパトラの入浴地と信じる天然淡水の泉——砂漠の中での爽やかなひと泳ぎ。',
          'zh': '当地人相信克利奥帕特拉曾在此沐浴的天然淡水泉池——沙漠中畅泳消暑。',
        },
        image: "assets/images/tourist/Siwa_Oasis/Cleopatra's_Spring.jpg",
      ),
      CityPlace(
        names: {
          'en': 'Great Sand Sea',
          'ar': 'البحر الرملي العظيم',
          'de': 'Großes Sandmeer',
          'fr': 'Grande mer de sable',
          'es': 'Gran mar de arena',
          'it': 'Grande mare di sabbia',
          'pt': 'Grande mar de areia',
          'ru': 'Великое песчаное море',
          'tr': 'Büyük Kum Denizi',
          'ja': '大砂海',
          'zh': '大沙海',
        },
        descs: {
          'en':
              'Vast, golden sand sea stretching to the Libyan border — sandboarding, 4×4 safaris, and camping under a blanket of stars.',
          'ar':
              'بحر رملي ذهبي شاسع يمتد حتى الحدود الليبية — ركوب الرمال وسفاري الدفع الرباعي والتخييم تحت سماء مرصعة بالنجوم.',
          'de':
              'Weite goldene Sandwüste bis zur libyschen Grenze — Sandboarding, 4×4-Safaris und Campen unter einem Sternenhimmel.',
          'fr':
              'Immense mer de sable dorée jusqu\'à la frontière libyenne — sandboard, safaris 4×4 et bivouac sous un ciel étoilé.',
          'es':
              'Vasto mar de arena dorada hasta la frontera libia — sandboard, safaris 4×4 y acampada bajo un manto de estrellas.',
          'it':
              'Vasto mare di sabbia dorata fino al confine libico — sandboard, safari 4×4 e campeggio sotto un cielo stellato.',
          'pt':
              'Vasto mar de areia dourada até à fronteira líbia — sandboard, safaris 4×4 e campismo sob um manto de estrelas.',
          'ru':
              'Обширное золотое «песчаное море» до ливийской границы — сэндбординг, сафари на 4×4 и кемпинг под звёздным небом.',
          'tr':
              'Libya sınırına uzanan geniş altın kum denizi — kum tahtası, 4×4 safarileri ve yıldızlı gökyüzü altında kamp.',
          'ja':
              'リビア国境まで続く広大な金色の砂の海——サンドボード、四駆サファリ、満天の星の下のキャンプ。',
          'zh': '延伸至利比亚边境的浩瀚金色沙海——滑沙、四驱越野与星空下的露营。',
        },
        image: 'assets/images/tourist/Siwa_Oasis/Great_Sand_Sea.jpg',
      ),
    ],
  ),

  // ── 8. Fayoum ─────────────────────────────────────────────────────────────────
  EgyptCity(
    id: 'fayoum',
    names: {
      'en': 'Fayoum',
      'ar': 'الفيوم',
      'de': 'Fajjum',
      'fr': 'Fayoum',
      'es': 'Fayum',
      'it': 'Fayyūm',
      'pt': 'Fayoum',
      'ru': 'Эль-Файюм',
      'tr': 'Fayum',
      'ja': 'ファイユーム',
      'zh': '法尤姆',
    },
    descriptions: {
      'en':
          'Egypt\'s largest oasis, just 2 hours from Cairo — the roaring Wadi El Rayan waterfalls, whale fossils at Wadi Al Hitan, and the ancient Qarun Lake.',
      'ar':
          'أكبر واحات مصر على بُعد ساعتين من القاهرة — شلالات وادي الريان الهادرة وحفريات الحيتان بوادي الحيتان وبحيرة قارون القديمة.',
      'de':
          'Ägyptens größte Oase, nur 2 Stunden von Kairo — die tosenden Wasserfälle von Wadi El Rayan, Walfossilien in Wadi Al Hitan und der antike Qarun-See.',
      'fr':
          'La plus grande oasis d\'Égypte, à seulement 2 heures du Caire — les cascades grondantes de Wadi El Rayan, des fossiles de baleines à Wadi Al Hitan et l\'antique lac Qarun.',
      'es':
          'El mayor oasis de Egipto, a solo 2 horas de El Cairo — las rugientes cataratas de Wadi El Rayan, fósiles de ballenas en Wadi Al Hitan y el antiguo lago Qarun.',
      'it':
          'La più grande oasi d\'Egitto, a solo 2 ore dal Cairo — le fragorose cascate di Wadi El Rayan, i fossili di balene al Wadi Al Hitan e l\'antico lago Qarun.',
      'pt':
          'O maior oásis do Egito, a apenas 2 horas do Cairo — as ruidosas cataratas de Wadi El Rayan, fósseis de baleias em Wadi Al Hitan e o antigo Lago Qarun.',
      'ru':
          'Крупнейший оазис Египта в 2 часах от Каира — шумные водопады Вади эль-Райян, ископаемые киты в Вади аль-Хитан и древнее озеро Карун.',
      'tr':
          'Mısır\'ın en büyük vahası, Kahire\'ye yalnızca 2 saat uzaklıkta — Wadi El Rayan\'ın gümbürdüyen şelaleleri, Wadi Al Hitan\'daki balina fosilleri ve antik Qarun Gölü.',
      'ja':
          'エジプト最大のオアシス、カイロからわずか2時間——ワディ・エル・ライヤンの轟く滝、ワディ・アル・ヒタンのクジラ化石、古代カルーン湖。',
      'zh': '埃及最大的绿洲，距开罗仅2小时——瓦迪埃尔赖延的壮观瀑布、瓦迪阿尔希坦的鲸鱼化石和古老的卡伦湖。',
    },
    gradientColors: [Color(0xFF2E6B50), Color(0xFF3E9070)],
    accentColor: Color(0xFF3E9070),
    emoji: '🦕',
    heroImage: 'assets/images/tourist/Fayoum/Wadi_El_Rayan.jpg',
    transportOptions: [
      TransportOption(
        mode: TransportMode.bus,
        travelTime: {'en': '~2 hours', 'ar': '~ساعتان'},
        apps: [kAppGoBus],
      ),
    ],
    places: [
      CityPlace(
        names: {
          'en': 'Wadi El Rayan',
          'ar': 'وادي الريان',
          'de': 'Wadi El Rayan',
          'fr': 'Wadi El Rayan',
          'es': 'Wadi El Rayan',
          'it': 'Wadi El Rayan',
          'pt': 'Wadi El Rayan',
          'ru': 'Вади эль-Райян',
          'tr': 'Vadi er-Rayyan',
          'ja': 'ワディ・エル・ライヤン',
          'zh': '瓦迪埃尔赖延',
        },
        descs: {
          'en':
              'Egypt\'s only natural waterfall — spectacular cascades tumble between two desert lakes surrounded by dramatic rocky cliffs.',
          'ar':
              'الشلال الطبيعي الوحيد في مصر — شلالات مذهلة تتدفق بين بحيرتين صحراويتين محاطتين بجروف صخرية.',
          'de':
              'Ägyptens einziger natürlicher Wasserfall — spektakuläre Kaskaden zwischen zwei Wüstenseen mit dramatischen Felsklippen.',
          'fr':
              'La seule cascade naturelle d\'Égypte — des cascades spectaculaires entre deux lacs désertiques entourés de falaises.',
          'es':
              'La única cascada natural de Egipto — espectaculares saltos entre dos lagos del desierto rodeados de acantilados.',
          'it':
              'L\'unica cascata naturale d\'Egitto — spettacolari cascate tra due laghi desertici tra scogliere rocciose.',
          'pt':
              'A única cascata natural do Egito — cascatas espetaculares entre dois lagos do deserto rodeados de falésias.',
          'ru':
              'Единственный природный водопад Египта — зрелищные каскады между двумя пустынными озёрами среди скал.',
          'tr':
              'Mısır\'ın tek doğal şelalesi — dramatik kayalık uçurumlarla çevrili iki çöl gölü arasında muhteşem şelaleler.',
          'ja':
              'エジプト唯一の自然の滝——劇的な岩崖に囲まれた二つの砂漠の湖の間を流れる壮観なカスケード。',
          'zh': '埃及唯一的天然瀑布——壮观水流泻落于两座沙漠湖泊之间，四周是峻峭岩崖。',
        },
        image: 'assets/images/tourist/Fayoum/Wadi_El_Rayan.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Wadi Al Hitan (Valley of the Whales)',
          'ar': 'وادي الحيتان',
          'de': 'Wadi al-Hitan (Tal der Wale)',
          'fr': 'Wadi al-Hitan (Vallée des Baleines)',
          'es': 'Wadi al-Hitan (Valle de las Ballenas)',
          'it': 'Wadi al-Hitan (Valle delle Balene)',
          'pt': 'Wadi al-Hitan (Vale das Baleias)',
          'ru': 'Вади аль-Хитан (Долина китов)',
          'tr': 'Vadi el-Hitan (Balinalar Vadisi)',
          'ja': 'ワディ・アル・ヒタン（クジラの谷）',
          'zh': '瓦迪阿尔希坦（鲸鱼谷）',
        },
        descs: {
          'en':
              'UNESCO World Heritage Site preserving 40-million-year-old whale fossils in the desert — one of the most important palaeontological sites on Earth.',
          'ar':
              'موقع تراث عالمي يحفظ حفريات الحيتان البالغة 40 مليون سنة في الصحراء — من أهم المواقع الجيولوجية على وجه الأرض.',
          'de':
              'UNESCO-Welterbe mit 40 Millionen Jahre alten Walfossilien in der Wüste — eine der wichtigsten paläontologischen Stätten der Erde.',
          'fr':
              'Site du patrimoine mondial de l\'UNESCO avec fossiles de baleines vieux de 40 millions d\'années dans le désert — l\'un des plus importants sites paléontologiques.',
          'es':
              'Patrimonio de la UNESCO con fósiles de ballenas de 40 millones de años en el desierto — uno de los yacimientos paleontológicos más importantes.',
          'it':
              'Patrimonio UNESCO con fossili di balene nel deserto di 40 milioni di anni — uno dei più importanti siti paleontologici al mondo.',
          'pt':
              'Património Mundial da UNESCO com fósseis de baleias no deserto com 40 milhões de anos — um dos mais importantes sítios paleontológicos.',
          'ru':
              'Объект Всемирного наследия ЮНЕСКО с 40-миллионными ископаемыми китами в пустыне — один из главных палеонтологических объектов Земли.',
          'tr':
              'Çölde 40 milyon yıllık balina fosillerini koruyan UNESCO Dünya Mirası — Dünya\'nın en önemli paleontolojik alanlarından biri.',
          'ja':
              '砂漠に4000万年前のクジラ化石を残すユネスコ世界遺産——地球でも最重要級の古生物学サイトの一つ。',
          'zh': '联合国教科文组织世界遗产，沙漠中保存四千万年前的鲸鱼化石——全球最重要的古生物学遗址之一。',
        },
        image: 'assets/images/tourist/Fayoum/Wadi_Al_Hitan.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Qarun Lake',
          'ar': 'بحيرة قارون',
          'de': 'Qarun-See',
          'fr': 'Lac Qarun',
          'es': 'Lago Qarun',
          'it': 'Lago Qarun',
          'pt': 'Lago Qarun',
          'ru': 'Озеро Карун',
          'tr': 'Karun Gölü',
          'ja': 'カルーン湖',
          'zh': '加伦湖',
        },
        descs: {
          'en':
              'One of Egypt\'s oldest lakes, a haven for migratory birds and flamingos, with ruins of the ancient Greco-Roman town Karanis on its shores.',
          'ar':
              'إحدى أقدم البحيرات في مصر، ملاذ للطيور المهاجرة والفلامنجو، وعلى شواطئها آثار المدينة اليونانية الرومانية القديمة كرانيس.',
          'de':
              'Einer der ältesten Seen Ägyptens — Rastplatz für Zugvögel und Flamingos, mit Ruinen der antiken griechisch-römischen Stadt Karanis am Ufer.',
          'fr':
              'L\'un des plus anciens lacs d\'Égypte — refuge pour oiseaux migrateurs et flamants, avec les ruines de la ville gréco-romaine Karanis sur ses rives.',
          'es':
              'Uno de los lagos más antiguos de Egipto — refugio de aves migratorias y flamencos, con ruinas de la ciudad grecorromana Karanis en sus orillas.',
          'it':
              'Uno dei laghi più antichi d\'Egitto — rifugio per uccelli migratori e fenicotteri, con rovine della città greco-romana Karanis sulle rive.',
          'pt':
              'Um dos lagos mais antigos do Egito — refúgio de aves migratórias e flamingos, com ruínas da cidade greco-romana Karanis nas margens.',
          'ru':
              'Одно из древнейших озёр Египта — убежище перелётных птиц и фламинго, на берегу руины древнегреко-римского города Каранис.',
          'tr':
              'Mısır\'ın en eski göllerinden biri — göçmen kuşlar ve flamingolar için sığınak; kıyılarında antik Greko-Romen Karanis kalıntıları.',
          'ja':
              'エジプト最古の湖の一つ——渡り鳥とフラミンゴの宝庫。岸には古代ギリシャ・ローマ都市カラニスの遺跡。',
          'zh': '埃及最古老的湖泊之一——候鸟与火烈鸟的栖息地，岸边有古希腊罗马城镇卡拉尼斯遗址。',
        },
        image: 'assets/images/tourist/Fayoum/Qarun_Lake.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Tunis Village',
          'ar': 'قرية تونس',
          'de': 'Tunis (Fayoum)',
          'fr': 'Village de Tunis',
          'es': 'Pueblo de Tunis',
          'it': 'Villaggio di Tunis',
          'pt': 'Aldeia de Tunis',
          'ru': 'Деревня Тунис',
          'tr': 'Tunus Köyü',
          'ja': 'チュニス村',
          'zh': '突尼斯村（法尤姆）',
        },
        descs: {
          'en':
              'Charming pottery village on the lake shore, famous for its handicraft workshops and the colourful hand-made ceramics of local artists.',
          'ar':
              'قرية فخار ساحرة على ضفة البحيرة، مشهورة بورش الحرف اليدوية والخزفيات الملونة المصنوعة يدويًا.',
          'de':
              'Charmantes Töpferdorf am Seeufer — bekannt für Handwerkswerkstätten und farbenfrohe handgemachte Keramik lokaler Künstler.',
          'fr':
              'Charmant village de potiers au bord du lac — célèbre pour ses ateliers d\'artisanat et la céramique colorée faite main.',
          'es':
              'Encantador pueblo alfarero a orillas del lago — famoso por talleres artesanales y cerámica colorida hecha a mano.',
          'it':
              'Affascinante villaggio di ceramisti sul lago — famoso per laboratori artigiani e ceramiche colorate fatte a mano.',
          'pt':
              'Encantadora aldeia de oleiros à beira do lago — famosa por oficinas de artesanato e cerâmica colorida feita à mão.',
          'ru':
              'Очаровательная гончарная деревня на берегу озера — известна мастерскими ремёсел и яркой керамикой местных мастеров.',
          'tr':
              'Göl kıyısındaki büyüleyici çömlekçi köyü — el sanatları atölyeleri ve yerel sanatçıların renkli el yapımı seramikleriyle ünlü.',
          'ja':
              '湖畔の陶芸の村——工房と地元作家のカラフルな手作り陶器で知られる。',
          'zh': '湖畔迷人的陶艺村——以手工艺作坊和当地艺术家色彩鲜艳的手工陶瓷闻名。',
        },
        image: 'assets/images/tourist/Fayoum/Tunis_Village_Fayoum.jpg',
      ),
    ],
  ),

  // ── 9. Marsa Alam ──────────────────────────────────────────────────────────────
  EgyptCity(
    id: 'marsa_alam',
    names: {
      'en': 'Marsa Alam',
      'ar': 'مرسى علم',
      'de': 'Marsa Alam',
      'fr': 'Marsa Alam',
      'es': 'Marsa Alam',
      'it': 'Marsa Alam',
      'pt': 'Marsa Alam',
      'ru': 'Марса-Алам',
      'tr': 'Marsa Alam',
      'ja': 'マルサ・アラム',
      'zh': '马尔萨阿拉姆',
    },
    descriptions: {
      'en':
          'An unspoiled Red Sea paradise — spot wild dugongs at Abu Dabbab, dive with hammerheads at Elphinstone, and swim with dolphins at Sataya Reef.',
      'ar':
          'جنة البحر الأحمر البكر — شاهد أبقار البحر البرية في أبو دباب واغطس مع أسماك المطرقة عند إلفنستون وسبح مع الدلافين عند رأس سطايا.',
      'de':
          'Ein unberührtes Rotes-Meer-Paradies — wilde Dugongs in Abu Dabbab, Hammerhai-Tauchen bei Elphinstone, Delfinenschwimmen am Sataya-Riff.',
      'fr':
          'Un paradis vierge de la mer Rouge — dugongs sauvages à Abu Dabbab, plongée avec des requins-marteaux à Elphinstone, nage avec des dauphins au récif Sataya.',
      'es':
          'Un paraíso virgen del Mar Rojo — dugongos salvajes en Abu Dabbab, buceo con tiburones martillo en Elphinstone y natación con delfines en el arrecife Sataya.',
      'it':
          'Un paradiso incontaminato del Mar Rosso — dugonghi selvatici ad Abu Dabbab, immersioni con squali martello a Elphinstone e nuoto con delfini alla Barriera di Sataya.',
      'pt':
          'Um paraíso intocado do Mar Vermelho — dugongos selvagens em Abu Dabbab, mergulho com tubarões-martelo em Elphinstone e natação com golfinhos no recife Sataya.',
      'ru':
          'Нетронутый рай Красного моря — дикие дюгони в Абу-Даббабе, ныряние с акулами-молотами у Элфинстона, плавание с дельфинами на рифе Сатая.',
      'tr':
          'El değmemiş bir Kızıldeniz cenneti — Abu Dabbab\'da yabani dugonglar, Elphinstone\'da çekiçbaşı köpekbalıklarıyla dalış ve Sataya Resifi\'nde yunuslarla yüzme.',
      'ja':
          '手つかずの紅海の楽園——アブ・ダッバブでジュゴンと遭遇、エルフィンストーンでシュモクザメとダイビング、サタヤ礁でイルカと泳ごう。',
      'zh': '原始的红海天堂——阿布达巴布的野生儒艮、埃尔芬斯通的双髻鲨潜水、萨塔亚礁的海豚游泳。',
    },
    gradientColors: [Color(0xFF005F6B), Color(0xFF007A8A)],
    accentColor: Color(0xFF007A8A),
    emoji: '🐬',
    heroImage: 'assets/images/tourist/Marsa_Alam/Elphinstone_Reef.jpg',
    transportOptions: [
      TransportOption(
        mode: TransportMode.flight,
        travelTime: {'en': '~1 hr 45 min', 'ar': '~ساعة و٤٥ دقيقة'},
        apps: [kAppEgyptAir],
      ),
      TransportOption(
        mode: TransportMode.bus,
        travelTime: {'en': '8–9 hours', 'ar': '٨–٩ ساعات'},
        apps: [kAppBlueBus, kAppGoBus],
      ),
    ],
    places: [
      CityPlace(
        names: {
          'en': 'Elphinstone Reef',
          'ar': 'رأس إلفنستون',
          'de': 'Elphinstone-Riff',
          'fr': 'Récif d\'Elphinstone',
          'es': 'Arrecife Elphinstone',
          'it': 'Barriera di Elphinstone',
          'pt': 'Recife Elphinstone',
          'ru': 'Риф Элфинстон',
          'tr': 'Elphinstone Resifi',
          'ja': 'エルフィンストーン礁',
          'zh': '埃尔芬斯通礁',
        },
        descs: {
          'en':
              'World-famous dive site with dramatic wall dives and regular sightings of oceanic white-tip sharks and hammerheads.',
          'ar':
              'موقع غوص عالمي الشهرة بغوصات حائطية مثيرة ومشاهدات منتظمة لأسماك القرش ذات الطرف الأبيض وأسماك المطرقة.',
          'de':
              'Weltbekannter Tauchplatz mit spektakulären Wandtauchgängen und regelmäßigen Begegnungen mit Weißspitzen-Hochseehaien und Hammerhaien.',
          'fr':
              'Site de plongée mondialement connu avec plongées en mur et observations fréquentes de requins océaniques à pointes blanches et requins-marteaux.',
          'es':
              'Sitio de buceo mundialmente famoso con inmersiones en pared y avistamientos frecuentes de tiburones oceánicos de puntas blancas y martillo.',
          'it':
              'Sito di immersione famoso nel mondo con pareti spettacolari e avvistamenti regolari di squali oceanici pinna bianca e martello.',
          'pt':
              'Local de mergulho mundialmente famoso com mergulhos em parede e avistamentos frequentes de tubarões-de-pontas-brancas oceânicos e martelo.',
          'ru':
              'Всемирно известный дайв-сайт со стеновыми погружениями и частыми встречами океанических белопёрых и молотоголовых акул.',
          'tr':
              'Dramatik duvar dalışları ve okyanik ak beyazlı köpekbalıkları ile çekiçbaşı köpekbalıklarının düzenli görüldüğü dünyaca ünlü dalış noktası.',
          'ja':
              'ドラマチックな壁潜りと远洋性ホワイトチップシャーク・シュモクザメの遭遇が多い世界的ダイブサイト。',
          'zh': '世界著名的潜水点——壮观的壁潜，常能见到远洋白鳍鲨与双髻鲨。',
        },
        image: 'assets/images/tourist/Marsa_Alam/Elphinstone_Reef.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Sataya Reef (Dolphin House)',
          'ar': 'رأس سطايا (بيت الدلافين)',
          'de': 'Sataya-Riff (Delfinhaus)',
          'fr': 'Récif Sataya (Maison des dauphins)',
          'es': 'Arrecife Sataya (Casa de los delfines)',
          'it': 'Barriera di Sataya (Casa dei delfini)',
          'pt': 'Recife Sataya (Casa dos golfinhos)',
          'ru': 'Риф Сатая (Дом дельфинов)',
          'tr': 'Sataya Resifi (Yunus Evi)',
          'ja': 'サタヤ礁（ドルフィンハウス）',
          'zh': '萨塔亚礁（海豚屋）',
        },
        descs: {
          'en':
              'Resident pod of 80+ spinner dolphins makes this the best place in Egypt to snorkel alongside wild dolphins in their natural habitat.',
          'ar':
              'قرن يضم أكثر من 80 دلفينًا دوّارًا يجعل هذا المكان أفضل موقع في مصر للغطس مع الدلافين البرية في موطنها الطبيعي.',
          'de':
              'Standort mit 80+ Spinnerdelfinen — der beste Ort in Ägypten, um neben wilden Delfinen in ihrem natürlichen Lebensraum zu schnorcheln.',
          'fr':
              'Groupe résident de plus de 80 dauphins à long bec — le meilleur endroit en Égypte pour nager avec des dauphins sauvages dans leur habitat.',
          'es':
              'Manada residente de más de 80 delfines rotadores — el mejor lugar de Egipto para hacer snorkel junto a delfines salvajes en su hábitat.',
          'it':
              'Branco residente di oltre 80 delfini striati — il miglior posto in Egitto per lo snorkeling con delfini selvatici nel loro habitat.',
          'pt':
              'Grupo residente de mais de 80 golfinhos-roazes — o melhor local no Egito para snorkel com golfinhos selvagens no habitat natural.',
          'ru':
              'Постоянная группа из 80+ крутящихся дельфинов — лучшее место в Египте для снорклинга рядом с дикими дельфинами.',
          'tr':
              '80\'den fazla dönücü yunustan oluşan yerleşik sürü — yabani yunuslarla doğal yaşam alanlarında şnorkel için Mısır\'daki en iyi yer.',
          'ja':
              '80頭以上のハセイルカの定住群——野生のイルカと自然生息地でシュノーケルできるエジプト屈指のスポット。',
          'zh': '常年栖息80余头长吻原海豚——在埃及与野生海豚在其自然栖息地同游浮潜的最佳地点。',
        },
        image: 'assets/images/tourist/Marsa_Alam/Sataya_Reef.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Abu Dabbab Beach',
          'ar': 'شاطئ أبو دباب',
          'de': 'Strand Abu Dabbab',
          'fr': 'Plage d\'Abu Dabbab',
          'es': 'Playa Abu Dabbab',
          'it': 'Spiaggia di Abu Dabbab',
          'pt': 'Praia de Abu Dabbab',
          'ru': 'Пляж Абу-Даббаб',
          'tr': 'Abu Dabbab Plajı',
          'ja': 'アブ・ダッバブ・ビーチ',
          'zh': '阿布达巴布海滩',
        },
        descs: {
          'en':
              'One of the few beaches in the world with resident dugongs (sea cows) in the shallows, alongside sea turtles and reef fish.',
          'ar':
              'أحد المواقع النادرة عالميًا التي يقطنها أبقار البحر (الدوجونج) في الضحل، إلى جانب السلاحف البحرية وأسماك الشعاب.',
          'de':
              'Einer der wenigen Strände weltweit mit ansässigen Dugongs (Seekühen) in den Flachwassern — dazu Meeresschildkröten und Rifffische.',
          'fr':
              'L\'une des rares plages au monde avec des dugongs résidents en eau peu profonde — ainsi que tortues marines et poissons de récif.',
          'es':
              'Una de las pocas playas del mundo con dugongos residentes en lo poco profundo — además tortugas marinas y peces de arrecife.',
          'it':
              'Una delle poche spiagge al mondo con dugongo residenti in bassofondo — insieme a tartarughe marine e pesci della barriera.',
          'pt':
              'Uma das poucas praias do mundo com dugongos residentes em águas rasas — juntamente com tartarugas marinhas e peixes de recife.',
          'ru':
              'Один из немногих пляжей в мире с постоянными дюгонями на мели — также морские черепахи и рифовые рыбы.',
          'tr':
              'Sığ sularda yerleşik dugongların (deniz inekleri) olduğu dünyada az sayıdaki plajlardan biri — deniz kaplumbağaları ve mercan balıklarıyla birlikte.',
          'ja':
              '浅場にジュゴンが定住する世界でも数少ないビーチの一つ——ウミガメと礁の魚も。',
          'zh': '全球少数几个浅滩有常驻儒艮（海牛）的海滩之一——还有海龟与礁鱼。',
        },
        image: 'assets/images/tourist/Marsa_Alam/Abu_Dabbab_Beach.jpg',
      ),
      CityPlace(
        names: {
          'en': 'Wadi El Gemal National Park',
          'ar': 'محمية وادي الجمال الوطنية',
          'de': 'Nationalpark Wadi el-Gemal',
          'fr': 'Parc national de Wadi el-Gemal',
          'es': 'Parque nacional de Wadi el-Gemal',
          'it': 'Parco nazionale di Wadi el-Gemal',
          'pt': 'Parque nacional de Wadi el-Gemal',
          'ru': 'Национальный парк Вади-эль-Джемаль',
          'tr': 'Vadi el-Cemal Milli Parkı',
          'ja': 'ワディ・エル・ジャマル国立公園',
          'zh': '瓦迪杰马勒国家公园',
        },
        descs: {
          'en':
              'Pristine national park encompassing desert wadis, mangrove forests, and spectacular coral reefs — one of Egypt\'s last true wildernesses.',
          'ar':
              'محمية طبيعية بكر تضم أودية صحراوية وغابات المانجروف وشعابًا مرجانية رائعة — إحدى آخر البرية الحقيقية في مصر.',
          'de':
              'Unberührter Nationalpark mit Wüstenwadis, Mangrovenwäldern und spektakulären Korallenriffen — eine der letzten Wildnisregionen Ägyptens.',
          'fr':
              'Parc national vierge englobant wadis désertiques, mangroves et récifs spectaculaires — l\'une des dernières véritables wilderness d\'Égypte.',
          'es':
              'Parque nacional virgen con uadis desérticos, manglares y arrecifes espectaculares — una de las últimas auténticas zonas salvajes de Egipto.',
          'it':
              'Parco nazionale intatto con wadi desertici, mangrovie e barriere spettacolari — tra le ultime vere wilderness d\'Egitto.',
          'pt':
              'Parque nacional intocado com uádis desertos, manguezais e recifes espetaculares — uma das últimas verdadeiras regiões selvagens do Egito.',
          'ru':
              'Нетронутый национальный парк — пустынные вади, мангры и великолепные рифы — одна из последних подлинных диких мест Египта.',
          'tr':
              'Çöl vadileri, mangrov ormanları ve muhteşem mercan resiflerini kapsayan el değmemiş milli park — Mısır\'ın son gerçek vahşi doğalarından biri.',
          'ja':
              '砂漠のワディ、マングローブ林、壮観なサンゴ礁を含む手つかずの国立公園——エジプトに残る数少ない真の大自然の一つ。',
          'zh': '原始国家公园，涵盖沙漠干谷、红树林与壮观珊瑚礁——埃及仅存的真正荒野之一。',
        },
        image: 'assets/images/tourist/Marsa_Alam/Wadi_El_Gemal_National_Park.jpg',
      ),
    ],
  ),
];
