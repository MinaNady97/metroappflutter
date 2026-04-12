/// Compile-time localisation table for all guided-tour step texts.
///
/// Falls back to English when a translation is missing.
/// Add new languages by inserting a new locale key into each step map.
abstract class TourL10n {
  TourL10n._();

  static String title(String stepId, String locale) =>
      _d[stepId]?['title']?[locale] ??
      _d[stepId]?['title']?['en'] ??
      stepId;

  static String description(String stepId, String locale) =>
      _d[stepId]?['desc']?[locale] ??
      _d[stepId]?['desc']?['en'] ??
      '';

  // ── Translation table ─────────────────────────────────────────────────────

  static const _d = <String, Map<String, Map<String, String>>>{

    // ── Welcome ───────────────────────────────────────────────────────────────
    'welcome': {
      'title': {
        'en': 'Welcome to Cairo Metro',
        'ar': 'مرحباً بمترو القاهرة',
        'fr': 'Bienvenue dans le Métro du Caire',
        'es': 'Bienvenido al Metro de El Cairo',
        'de': 'Willkommen in der Kairoer Metro',
        'ru': 'Добро пожаловать в Каирское метро',
        'it': 'Benvenuto nella Metro del Cairo',
        'pt': 'Bem-vindo ao Metrô do Cairo',
        'zh': '欢迎使用开罗地铁',
        'tr': 'Kahire Metrosuna Hoş Geldiniz',
        'ja': 'カイロ地下鉄へようこそ',
      },
      'desc': {
        'en': 'Let us show you the key features in under a minute.',
        'ar': 'دعنا نريك أهم الميزات في أقل من دقيقة.',
        'fr': 'Laissez-nous vous présenter les fonctionnalités clés en moins d\'une minute.',
        'es': 'Permítenos mostrarte las funciones principales en menos de un minuto.',
        'de': 'Wir zeigen dir die wichtigsten Funktionen in weniger als einer Minute.',
        'ru': 'Мы покажем вам ключевые функции менее чем за минуту.',
        'it': 'Ti mostreremo le funzionalità principali in meno di un minuto.',
        'pt': 'Vamos mostrar os principais recursos em menos de um minuto.',
        'zh': '让我们在一分钟内向您展示主要功能。',
        'tr': 'Temel özellikleri bir dakikadan kısa sürede gösterelim.',
        'ja': '主な機能を1分以内にご紹介します。',
      },
    },

    // ── Nearest station ───────────────────────────────────────────────────────
    'nearestStation': {
      'title': {
        'en': 'Your Nearest Station',
        'ar': 'أقرب محطة إليك',
        'fr': 'Votre Station la Plus Proche',
        'es': 'Tu Estación Más Cercana',
        'de': 'Nächste Station',
        'ru': 'Ближайшая Станция',
        'it': 'La Stazione Più Vicina',
        'pt': 'Estação Mais Próxima',
        'zh': '最近的车站',
        'tr': 'En Yakın İstasyon',
        'ja': '最寄り駅',
      },
      'desc': {
        'en': 'We use GPS to find the closest metro station to you automatically and keep it updated as you move.',
        'ar': 'نستخدم GPS للعثور على أقرب محطة مترو إليك تلقائياً وتحديثها أثناء تنقلك.',
        'fr': 'Nous utilisons le GPS pour trouver automatiquement la station la plus proche et la mettre à jour lors de vos déplacements.',
        'es': 'Usamos GPS para encontrar la estación más cercana automáticamente y actualizarla mientras te mueves.',
        'de': 'Wir nutzen GPS, um die nächstgelegene Metrostation automatisch zu finden und sie während deiner Fahrt zu aktualisieren.',
        'ru': 'GPS определяет ближайшую станцию автоматически и обновляет её по мере вашего движения.',
        'it': 'Usiamo il GPS per trovare automaticamente la stazione più vicina e aggiornarla mentre ti sposti.',
        'pt': 'Usamos GPS para encontrar a estação mais próxima automaticamente e atualizá-la conforme você se move.',
        'zh': '我们使用GPS自动找到距您最近的地铁站，并随您的移动实时更新。',
        'tr': 'GPS\'i kullanarak en yakın metro istasyonunu otomatik olarak bulur ve siz hareket ettikçe güncelliyoruz.',
        'ja': 'GPSを使って最寄りの地下鉄駅を自動的に見つけ、移動に合わせて更新します。',
      },
    },

    // ── Route planner ─────────────────────────────────────────────────────────
    'routePlanner': {
      'title': {
        'en': 'Plan Your Route',
        'ar': 'خطط لرحلتك',
        'fr': 'Planifiez Votre Trajet',
        'es': 'Planifica Tu Ruta',
        'de': 'Route Planen',
        'ru': 'Планируйте Маршрут',
        'it': 'Pianifica il Percorso',
        'pt': 'Planeje Sua Rota',
        'zh': '规划路线',
        'tr': 'Rotanızı Planlayın',
        'ja': 'ルートを計画',
      },
      'desc': {
        'en': 'Type your departure and arrival stations. Use the swap button to reverse the journey in one tap.',
        'ar': 'أدخل محطة الانطلاق والوصول. استخدم زر التبديل لعكس الرحلة بنقرة واحدة.',
        'fr': 'Saisissez vos stations de départ et d\'arrivée. Utilisez le bouton d\'échange pour inverser le trajet en un tap.',
        'es': 'Escribe tus estaciones de salida y llegada. Usa el botón de intercambio para invertir el viaje en un toque.',
        'de': 'Gib deine Abfahrts- und Ankunftsstation ein. Nutze den Tausch-Button, um die Fahrt mit einem Tippen umzukehren.',
        'ru': 'Введите станции отправления и прибытия. Используйте кнопку обмена для смены направления одним нажатием.',
        'it': 'Inserisci le stazioni di partenza e arrivo. Usa il pulsante di scambio per invertire il percorso con un tap.',
        'pt': 'Digite as estações de partida e chegada. Use o botão de troca para inverter a viagem com um toque.',
        'zh': '输入出发站和到达站，点击交换按钮一键反转行程。',
        'tr': 'Kalkış ve varış istasyonlarını yazın. Tek dokunuşla yolculuğu ters çevirmek için değiştir düğmesini kullanın.',
        'ja': '出発駅と到着駅を入力してください。スワップボタンでワンタップで旅程を逆転できます。',
      },
    },

    // ── Arrival / destination finder ──────────────────────────────────────────
    'arrivalFinder': {
      'title': {
        'en': 'Door-to-Door Search',
        'ar': 'بحث من الباب إلى الباب',
        'fr': 'Recherche Porte-à-Porte',
        'es': 'Búsqueda Puerta a Puerta',
        'de': 'Tür-zu-Tür Suche',
        'ru': 'Поиск «от двери до двери»',
        'it': 'Ricerca da Porta a Porta',
        'pt': 'Busca Porta a Porta',
        'zh': '门到门搜索',
        'tr': 'Kapıdan Kapıya Arama',
        'ja': 'ドア・ツー・ドア検索',
      },
      'desc': {
        'en': 'Type any place in Cairo — we find the nearest metro station to it and give you walking or driving directions to the door.',
        'ar': 'اكتب أي مكان في القاهرة — سنجد أقرب محطة مترو إليه ونوفر اتجاهات مشياً أو بالسيارة حتى الباب.',
        'fr': 'Tapez n\'importe quel lieu au Caire — nous trouvons la station la plus proche et vous donnons les directions à pied ou en voiture.',
        'es': 'Escribe cualquier lugar en El Cairo — encontramos la estación más cercana y te damos indicaciones a pie o en coche.',
        'de': 'Gib einen beliebigen Ort in Kairo ein — wir finden die nächste Station und geben dir Fuß- oder Fahrtrouten.',
        'ru': 'Введите любое место в Каире — мы найдём ближайшую станцию и дадим маршрут пешком или на машине.',
        'it': 'Digita qualsiasi posto al Cairo — troviamo la stazione più vicina e ti diamo indicazioni a piedi o in auto.',
        'pt': 'Digite qualquer lugar no Cairo — encontramos a estação mais próxima e damos direções a pé ou de carro.',
        'zh': '输入开罗任何地点——我们找到距其最近的地铁站，并提供步行或驾车到达的路线。',
        'tr': 'Kahire\'de herhangi bir yer yazın — en yakın metro istasyonunu buluyor ve yürüyüş veya sürüş yönlendirmesi sunuyoruz.',
        'ja': 'カイロの任意の場所を入力すると、最寄り駅を見つけ、徒歩または車での案内を提供します。',
      },
    },

    // ── Tourist guide ─────────────────────────────────────────────────────────
    'touristGuide': {
      'title': {
        'en': 'Explore Cairo',
        'ar': 'استكشف القاهرة',
        'fr': 'Explorer Le Caire',
        'es': 'Explorar El Cairo',
        'de': 'Kairo Entdecken',
        'ru': 'Исследуйте Каир',
        'it': 'Esplora Il Cairo',
        'pt': 'Explorar o Cairo',
        'zh': '探索开罗',
        'tr': 'Kahire\'yi Keşfedin',
        'ja': 'カイロを探索',
      },
      'desc': {
        'en': 'Discover 48 landmarks, museums, and attractions — all reachable by metro. Perfect for tourists and curious locals.',
        'ar': 'اكتشف 48 معلماً وأثراً ومتحفاً — كلها في متناول المترو. مثالية للسياح والمقيمين الفضوليين.',
        'fr': 'Découvrez 48 monuments, musées et attractions — tous accessibles en métro. Parfait pour les touristes et les curieux.',
        'es': 'Descubre 48 monumentos, museos y atracciones — todos accesibles en metro. Perfecto para turistas y curiosos.',
        'de': 'Entdecke 48 Sehenswürdigkeiten, Museen und Attraktionen — alle per Metro erreichbar. Perfekt für Touristen und Neugierige.',
        'ru': '48 достопримечательностей, музеев и объектов — все доступны на метро. Идеально для туристов и любопытных местных.',
        'it': 'Scopri 48 monumenti, musei e attrazioni — tutti raggiungibili in metro. Perfetto per turisti e curiosi.',
        'pt': 'Descubra 48 pontos turísticos, museus e atrações — todos acessíveis de metrô. Perfeito para turistas e curiosos.',
        'zh': '探索48个地标、博物馆和景点——均可乘地铁到达。适合游客和好奇的本地居民。',
        'tr': '48 tarihi yer, müze ve çekicilik — hepsi metro ile ulaşılabilir. Turistler ve meraklılar için mükemmel.',
        'ja': '48の名所、博物館、観光スポットを発見——すべて地下鉄でアクセス可能。観光客や好奇心旺盛な地元民に最適。',
      },
    },

    // ── Search button ─────────────────────────────────────────────────────────
    'searchButton': {
      'title': {
        'en': 'Show Routes',
        'ar': 'عرض المسارات',
        'fr': 'Afficher les Trajets',
        'es': 'Mostrar Rutas',
        'de': 'Routen Anzeigen',
        'ru': 'Показать Маршруты',
        'it': 'Mostra Percorsi',
        'pt': 'Mostrar Rotas',
        'zh': '显示路线',
        'tr': 'Güzergahları Göster',
        'ja': 'ルートを表示',
      },
      'desc': {
        'en': 'Tap here to see every available route — time, fare, and transfers. Watch us demo the full journey.',
        'ar': 'اضغط هنا لرؤية جميع المسارات المتاحة — الوقت والتذكرة والتحويلات. شاهد العرض التجريبي للرحلة كاملة.',
        'fr': 'Appuyez ici pour voir tous les trajets disponibles — durée, tarif et correspondances. Regardez notre démonstration.',
        'es': 'Toca aquí para ver todas las rutas disponibles — tiempo, tarifa y transbordos. Mira nuestra demostración.',
        'de': 'Tippe hier, um alle verfügbaren Routen zu sehen — Zeit, Preis und Umstiege. Sieh dir unsere Demo an.',
        'ru': 'Нажмите здесь, чтобы увидеть все доступные маршруты — время, стоимость и пересадки. Смотрите демонстрацию.',
        'it': 'Premi qui per vedere tutti i percorsi disponibili — tempo, tariffa e cambi. Guarda la nostra dimostrazione.',
        'pt': 'Toque aqui para ver todas as rotas disponíveis — tempo, tarifa e baldeações. Veja nossa demonstração.',
        'zh': '点击这里查看所有可用路线——时间、票价和换乘次数。观看我们的完整演示。',
        'tr': 'Tüm mevcut güzergahları görmek için buraya dokunun — süre, ücret ve aktarmalar. Tam demomuzu izleyin.',
        'ja': 'すべての利用可能なルートを確認するにはここをタップ——時間、運賃、乗り換え。デモをご覧ください。',
      },
    },

    // ── Route card ────────────────────────────────────────────────────────────
    'routeCard': {
      'title': {
        'en': 'Route Options',
        'ar': 'خيارات المسار',
        'fr': 'Options de Trajet',
        'es': 'Opciones de Ruta',
        'de': 'Routenoptionen',
        'ru': 'Варианты Маршрута',
        'it': 'Opzioni Percorso',
        'pt': 'Opções de Rota',
        'zh': '路线选项',
        'tr': 'Güzergah Seçenekleri',
        'ja': 'ルートオプション',
      },
      'desc': {
        'en': 'Each card shows the full breakdown: stations, line changes, estimated time and fare.',
        'ar': 'تُظهر كل بطاقة التفاصيل الكاملة: المحطات وتغييرات الخطوط والوقت والسعر.',
        'fr': 'Chaque carte montre le détail complet : stations, changements de ligne, durée et tarif.',
        'es': 'Cada tarjeta muestra el desglose completo: estaciones, cambios de línea, tiempo estimado y tarifa.',
        'de': 'Jede Karte zeigt die vollständige Aufschlüsselung: Haltestellen, Linienwechsel, geschätzte Zeit und Preis.',
        'ru': 'Каждая карточка показывает полную разбивку: станции, пересадки, время и стоимость.',
        'it': 'Ogni scheda mostra la ripartizione completa: stazioni, cambi di linea, tempo stimato e tariffa.',
        'pt': 'Cada cartão mostra o detalhamento completo: estações, mudanças de linha, tempo estimado e tarifa.',
        'zh': '每张卡片显示完整信息：站点、换乘、预计时间和票价。',
        'tr': 'Her kart tam dökümü gösterir: istasyonlar, hat değişiklikleri, tahmini süre ve ücret.',
        'ja': '各カードには詳細情報が表示されます：駅、乗り換え、所要時間、運賃。',
      },
    },

    // ── Directions / last-mile ────────────────────────────────────────────────
    'directions': {
      'title': {
        'en': 'Door-to-Door',
        'ar': 'من الباب إلى الباب',
        'fr': 'De Porte en Porte',
        'es': 'De Puerta a Puerta',
        'de': 'Von Tür zu Tür',
        'ru': 'От Двери до Двери',
        'it': 'Da Porta a Porta',
        'pt': 'Porta a Porta',
        'zh': '门到门',
        'tr': 'Kapıdan Kapıya',
        'ja': 'ドア・ツー・ドア',
      },
      'desc': {
        'en': 'Get walking or driving directions to the departure station — and from the arrival station to your final destination.',
        'ar': 'احصل على اتجاهات مشياً أو بالسيارة إلى محطة الانطلاق — ومن محطة الوصول إلى وجهتك النهائية.',
        'fr': 'Obtenez des directions à pied ou en voiture vers la station de départ — et de la station d\'arrivée à votre destination finale.',
        'es': 'Obtén indicaciones a pie o en coche hasta la estación de salida — y desde la estación de llegada a tu destino final.',
        'de': 'Erhalte Fuß- oder Fahrtrouten zur Abfahrtsstation — und von der Ankunftsstation zu deinem Endziel.',
        'ru': 'Получите маршрут пешком или на машине до станции отправления — и от станции прибытия до конечной цели.',
        'it': 'Ottieni indicazioni a piedi o in auto fino alla stazione di partenza — e dalla stazione di arrivo alla tua destinazione finale.',
        'pt': 'Obtenha rotas a pé ou de carro até a estação de partida — e da estação de chegada ao seu destino final.',
        'zh': '获取步行或驾车到出发站的路线——以及从到达站到最终目的地的路线。',
        'tr': 'Kalkış istasyonuna yürüyüş veya sürüş yönlendirmesi alın — ve varış istasyonundan son hedefinize kadar.',
        'ja': '出発駅への徒歩または車での案内を取得——到着駅から最終目的地までも。',
      },
    },

  };
}
