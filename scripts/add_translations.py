#!/usr/bin/env python3
"""
Adds 9 language translations (fr, es, de, ru, it, pt, zh, tr, ja) to
full_cairo_metro_template2.json for all metro station facility entries.

Rules:
- category values stay in English (used as programmatic keys)
- lat/lng values are never changed
- Streets items (no text) are copied verbatim
- Proper Cairo place names are kept in transliterated form across all langs
- Description, directions, map_hint are translated per language
"""

import json, copy, re

SRC = r"assets/data/full_cairo_metro_template2.json"
DST = r"assets/data/full_cairo_metro_template2.json"

LANGS = ["fr", "es", "de", "ru", "it", "pt", "zh", "tr", "ja"]

# ---------------------------------------------------------------------------
# Translation table
# Key structure: TRANSLATIONS[station_suffix][en_item_key][lang_code]
#   = dict with optional: name, description, directions, map_hint
# If a field is absent the English value is used as fallback.
# ---------------------------------------------------------------------------

TRANSLATIONS = {

# ── ADLY MANSOUR ──────────────────────────────────────────────────────────
"ADLY MANSOUR": {
  "El Hegra Mosque": {
    "fr":{"name":"Mosquée El Hegra","description":"Une mosquée paisible desservant la communauté locale pour les prières quotidiennes et du vendredi.","directions":"Rue El Hegra, à 5 min à pied au sud-est de la station.","map_hint":"Près de l'entrée du tunnel El Salam."},
    "es":{"name":"Mezquita El Hegra","description":"Una tranquila mezquita que sirve a la comunidad local para las oraciones diarias y del viernes.","directions":"En la calle El Hegra, a 5 minutos caminando al sureste de la estación.","map_hint":"Cerca de la entrada del túnel El Salam."},
    "de":{"name":"El Hegra Moschee","description":"Eine ruhige Moschee für das tägliche Freitagsgebet der lokalen Gemeinschaft.","directions":"El Hegra Straße, ca. 5 Gehminuten südöstlich vom Bahnhof.","map_hint":"In der Nähe des Eingangs zum El Salam-Tunnel."},
    "ru":{"name":"Мечеть Эль-Хегра","description":"Тихая мечеть, обслуживающая местных жителей для ежедневных и пятничных молитв.","directions":"Улица Эль-Хегра, около 5 минут ходьбы на юго-восток от станции.","map_hint":"Рядом с входом в тоннель Эль-Салам."},
    "it":{"name":"Moschea El Hegra","description":"Una tranquilla moschea al servizio della comunità locale per le preghiere quotidiane e del venerdì.","directions":"Via El Hegra, a circa 5 minuti a piedi a sud-est della stazione.","map_hint":"Vicino all'ingresso del tunnel El Salam."},
    "pt":{"name":"Mesquita El Hegra","description":"Uma mesquita tranquila servindo a comunidade local para orações diárias e de sexta-feira.","directions":"Rua El Hegra, a cerca de 5 minutos a pé a sudeste da estação.","map_hint":"Perto da entrada do túnel El Salam."},
    "zh":{"name":"埃尔赫格拉清真寺","description":"一座宁静的清真寺，为当地社区提供每日礼拜和周五礼拜服务。","directions":"位于埃尔赫格拉街，距车站东南方向约5分钟步行路程。","map_hint":"靠近埃尔萨拉姆隧道入口。"},
    "tr":{"name":"El Hegra Camii","description":"Yerel topluma günlük ve Cuma namazları için hizmet veren huzurlu bir cami.","directions":"El Hegra Caddesi'nde, istasyondan güneydoğuya yaklaşık 5 dakika yürüme mesafesinde.","map_hint":"El Salam Tüneli girişinin yakınında."},
    "ja":{"name":"エル・ヘグラ・モスク","description":"地域コミュニティの日常礼拝と金曜礼拝に奉仕する静かなモスク。","directions":"エル・ヘグラ通り、駅から南東へ徒歩約5分。","map_hint":"エル・サラムトンネル入口付近。"},
  },
  "Shopping Mall": {
    "fr":{"name":"Centre commercial","description":"Un centre commercial moderne avec boutiques, restaurants et cinéma.","directions":"Suivre la Route du Périphérique vers le nord sur 300 m, le centre est à droite.","map_hint":"À côté du dépôt de métro."},
    "es":{"name":"Centro comercial","description":"Un moderno centro comercial con tiendas, restaurantes y cine.","directions":"Dirigirse al norte por la Carretera de Circunvalación 300 m, el centro está a la derecha.","map_hint":"Junto al complejo del garaje del metro."},
    "de":{"name":"Einkaufszentrum","description":"Ein modernes Einkaufszentrum mit Einzelhandel, Restaurants und Kino.","directions":"300 m nördlich auf der Ringstraße, das Einkaufszentrum liegt auf der rechten Seite.","map_hint":"Neben dem Metro-Depotgebäude."},
    "ru":{"name":"Торговый центр","description":"Современный торговый центр с магазинами, ресторанами и кинотеатром.","directions":"Двигайтесь на север по кольцевой дороге 300 м — торговый центр будет справа.","map_hint":"Рядом с депо метро."},
    "it":{"name":"Centro commerciale","description":"Un moderno centro commerciale con negozi, ristoranti e cinema.","directions":"Dirigersi a nord sulla strada del raccordo per 300 m, il centro è sulla destra.","map_hint":"Accanto al complesso del deposito della metropolitana."},
    "pt":{"name":"Shopping center","description":"Um moderno shopping com lojas, restaurantes e cinema.","directions":"Siga pela Estrada do Anel para o norte por 300 m, o shopping fica à direita.","map_hint":"Ao lado do complexo da garagem do metrô."},
    "zh":{"name":"购物中心","description":"一座现代化购物中心，设有零售店、餐厅和电影院。","directions":"沿环城公路向北300米，购物中心在右侧。","map_hint":"紧邻地铁车库综合楼。"},
    "tr":{"name":"Alışveriş merkezi","description":"Perakende mağazaları, restoranlar ve sinema kompleksi olan modern bir alışveriş merkezi.","directions":"Çevre Yolu'nda 300 m kuzeye gidin, alışveriş merkezi sağda.","map_hint":"Metro Garajı kompleksinin yanında."},
    "ja":{"name":"ショッピングモール","description":"小売店、レストラン、映画館を備えた近代的なモール。","directions":"環状道路を北に300m進むと、右手にモールがあります。","map_hint":"メトロ車庫複合施設の隣。"},
  },
  "Ahmed Orabi Industrial School": {
    "fr":{"name":"École industrielle Ahmed Orabi","description":"Un lycée professionnel proposant une formation industrielle dans plusieurs disciplines.","directions":"Prendre la route Galaxo vers l'ouest sur environ 800 m.","map_hint":"Près du carrefour avec la rue Ali Ebn Abi Taleb."},
    "es":{"name":"Escuela Industrial Ahmed Orabi","description":"Un instituto vocacional que ofrece formación industrial en varias disciplinas.","directions":"Tomar la Carretera Galaxo hacia el oeste unos 800 m.","map_hint":"Cerca del cruce con la calle Ali Ebn Abi Taleb."},
    "de":{"name":"Ahmed Orabi Industrieschule","description":"Eine Berufsschule mit industrieller Ausbildung in verschiedenen Fachrichtungen.","directions":"Galaxo-Straße ca. 800 m westlich vom Bahnhof folgen.","map_hint":"In der Nähe der Kreuzung mit der Ali Ebn Abi Taleb Straße."},
    "ru":{"name":"Промышленная школа Ахмеда Ораби","description":"Профессиональная школа с промышленной подготовкой по нескольким специальностям.","directions":"Двигайтесь на запад по дороге Галаксо около 800 м.","map_hint":"Рядом с перекрёстком с улицей Али ибн Аби Талиб."},
    "it":{"name":"Scuola industriale Ahmed Orabi","description":"Una scuola professionale che offre formazione industriale in diverse discipline.","directions":"Seguire la strada Galaxo verso ovest per circa 800 m.","map_hint":"Vicino all'incrocio con via Ali Ebn Abi Taleb."},
    "pt":{"name":"Escola Industrial Ahmed Orabi","description":"Uma escola profissional que oferece formação industrial em várias disciplinas.","directions":"Siga a Estrada Galaxo para o oeste por cerca de 800 m.","map_hint":"Perto do cruzamento com a Rua Ali Ebn Abi Taleb."},
    "zh":{"name":"艾哈迈德·奥拉比工业学校","description":"一所提供多学科工业培训的职业高中。","directions":"从车站沿盖拉克索公路向西约800米。","map_hint":"靠近阿里·本·阿比·塔利卜街交叉口。"},
    "tr":{"name":"Ahmed Orabi Endüstri Okulu","description":"Çeşitli disiplinlerde endüstriyel eğitim sunan bir meslek lisesi.","directions":"İstasyondan Galaxo Yolu'nu batıya doğru yaklaşık 800 m izleyin.","map_hint":"Ali Ebn Abi Taleb Caddesi kavşağına yakın."},
    "ja":{"name":"アフメド・オラビ工業学校","description":"複数の分野で工業訓練を提供する職業高校。","directions":"駅からガラクソ道路を西に約800m進みます。","map_hint":"アリー・イブン・アビー・ターリブ通りとの交差点付近。"},
  },
  "Police Academy": {
    "fr":{"name":"Académie de police","description":"L'académie nationale égyptienne pour la formation des forces de police et de sécurité.","directions":"Situé au nord-est de la station sur la route Othman Ebn Affan.","map_hint":"Adjacent à la zone militaire."},
    "es":{"name":"Academia de Policía","description":"La academia nacional de Egipto para la formación de fuerzas policiales y de seguridad.","directions":"Al noreste de la estación, en la carretera Othman Ebn Affan.","map_hint":"Junto a la zona de la institución militar."},
    "de":{"name":"Polizeiakademie","description":"Ägyptens nationale Akademie für die Ausbildung der Polizei- und Sicherheitskräfte.","directions":"Nordöstlich des Bahnhofs an der Othman Ebn Affan Straße.","map_hint":"Neben dem Militärgelände."},
    "ru":{"name":"Полицейская академия","description":"Национальная академия Египта по подготовке полицейских и сотрудников безопасности.","directions":"Северо-восток от станции на дороге Усман ибн Аффан.","map_hint":"Рядом с военным объектом."},
    "it":{"name":"Accademia di Polizia","description":"L'accademia nazionale egiziana per la formazione delle forze di polizia e sicurezza.","directions":"A nord-est della stazione sulla strada Othman Ebn Affan.","map_hint":"Adiacente all'area militare."},
    "pt":{"name":"Academia de Polícia","description":"A academia nacional do Egito para treinamento das forças policiais e de segurança.","directions":"A nordeste da estação na Estrada Othman Ebn Affan.","map_hint":"Adjacente à área da instituição militar."},
    "zh":{"name":"警察学院","description":"埃及国家警察和安全部队培训学院。","directions":"位于车站东北方向的奥斯曼·本·阿凡路。","map_hint":"毗邻军事机构区域。"},
    "tr":{"name":"Polis Akademisi","description":"Mısır'ın polis ve güvenlik güçleri eğitimi için ulusal akademisi.","directions":"İstasyonun kuzeydoğusunda Othman Ebn Affan Yolu üzerinde.","map_hint":"Askeri tesis alanına bitişik."},
    "ja":{"name":"警察学校","description":"エジプトの警察・安保部隊訓練のための国立学校。","directions":"駅北東のオスマン・イブン・アッファン通り沿い。","map_hint":"軍事施設エリアに隣接。"},
  },
  "Cemetry": {
    "fr":{"name":"Cimetière","description":"Un cimetière tranquille et bien entretenu au service de la population locale.","directions":"Au sud-ouest de la station, près de la route désertique Le Caire-Ismaïlia.","map_hint":"Derrière le carrefour de la route Galaxo."},
    "es":{"name":"Cementerio","description":"Un cementerio tranquilo y bien conservado al servicio de la población local.","directions":"Al suroeste de la estación, cerca de la carretera desértica El Cairo-Ismailia.","map_hint":"Detrás del desvío de la carretera Galaxo."},
    "de":{"name":"Friedhof","description":"Ein ruhig und respektvoll gepflegter Friedhof für die lokale Bevölkerung.","directions":"Südwestlich des Bahnhofs, nahe der Wüstenstraße Kairo-Ismailia.","map_hint":"Hinter der Galaxo-Straßenabzweigung."},
    "ru":{"name":"Кладбище","description":"Тихое и ухоженное кладбище для местного населения.","directions":"К юго-западу от станции у пустынной дороги Каир–Исмаилия.","map_hint":"За поворотом на дорогу Галаксо."},
    "it":{"name":"Cimitero","description":"Un cimitero tranquillo e rispettosamente curato al servizio della popolazione locale.","directions":"A sud-ovest della stazione vicino alla strada desertica Il Cairo-Ismailia.","map_hint":"Dietro lo svincolo della strada Galaxo."},
    "pt":{"name":"Cemitério","description":"Um cemitério tranquilo e bem conservado servindo a população local.","directions":"A sudoeste da estação, perto da estrada desértica Cairo-Ismaília.","map_hint":"Atrás da curva da estrada Galaxo."},
    "zh":{"name":"公墓","description":"一处安静且保养良好的公墓，为当地居民服务。","directions":"位于车站西南方，靠近开罗-伊斯梅利亚沙漠公路。","map_hint":"在盖拉克索公路岔路口后方。"},
    "tr":{"name":"Mezarlık","description":"Yerel halka hizmet eden sakin ve bakımlı bir mezarlık.","directions":"İstasyonun güneybatısında, Kahire-İsmailia Çöl Yolu yakınında.","map_hint":"Galaxo Yolu sapağının arkasında."},
    "ja":{"name":"墓地","description":"地域の人々に奉仕する静かで丁寧に管理された墓地。","directions":"駅南西、カイロ・イスマイリア砂漠道路付近。","map_hint":"ガラクソ道路の分岐点の裏側。"},
  },
  "Light Rail Train Station (LRT)": {
    "fr":{"name":"Gare de tramway léger (LRT)","description":"Un nœud d'échange reliant le métro au réseau de tramway léger.","directions":"Directement relié au terminal de la station de métro Adly Mansour.","map_hint":"Visible immédiatement à la sortie du métro."},
    "es":{"name":"Estación de tren ligero (LRT)","description":"Un importante intercambiador que conecta el metro con el tren ligero.","directions":"Directamente conectado al complejo terminal del metro Adly Mansour.","map_hint":"Visible nada más salir del metro."},
    "de":{"name":"Stadtbahnhof (LRT)","description":"Ein wichtiger Umsteigebahnhof, der Metro und Stadtbahn verbindet.","directions":"Direkt an den Endbahnhof Adly Mansour angebunden.","map_hint":"Sofort beim Verlassen der Metro sichtbar."},
    "ru":{"name":"Станция лёгкого метро (LRT)","description":"Ключевой пересадочный узел, связывающий метро с трамвайной линией.","directions":"Непосредственно связана с терминалом станции метро Адли Мансур.","map_hint":"Видна сразу при выходе из метро."},
    "it":{"name":"Stazione della ferrovia leggera (LRT)","description":"Un nodo di interscambio che collega la metropolitana alla ferrovia leggera.","directions":"Direttamente collegata al terminal della metropolitana Adly Mansour.","map_hint":"Visibile subito all'uscita dalla metropolitana."},
    "pt":{"name":"Estação de trem leve (LRT)","description":"Um importante hub de integração conectando o metrô ao trem leve.","directions":"Diretamente conectado ao terminal do metrô Adly Mansour.","map_hint":"Visível imediatamente ao sair do metrô."},
    "zh":{"name":"轻轨车站（LRT）","description":"连接地铁与轻轨系统的重要换乘枢纽。","directions":"直接连通阿德利·曼苏尔地铁终点站综合楼。","map_hint":"走出地铁即可看到。"},
    "tr":{"name":"Hafif Raylı Sistem İstasyonu (LRT)","description":"Metroyu hafif raylı sisteme bağlayan önemli bir aktarma merkezi.","directions":"Adly Mansour Metro terminali ile doğrudan bağlantılıdır.","map_hint":"Metrodan çıkınca hemen görülür."},
    "ja":{"name":"ライトレール駅（LRT）","description":"地下鉄と路面電車を結ぶ重要な乗換ハブ。","directions":"アドリ・マンスール地下鉄ターミナルと直結。","map_hint":"地下鉄を出てすぐに見えます。"},
  },
  "Metro Garage": {
    "fr":{"name":"Dépôt de métro","description":"Dépôt opérationnel pour la maintenance et le stockage des trains de la ligne 3.","directions":"Au nord de la station, accessible via la voie de service près de la route du Périphérique.","map_hint":"Derrière le centre commercial."},
    "es":{"name":"Garaje de metro","description":"Depósito operativo para mantenimiento y almacenamiento de trenes de la línea 3.","directions":"Al norte de la estación, accesible por la vía de servicio cerca de la Carretera de Circunvalación.","map_hint":"Detrás del centro comercial."},
    "de":{"name":"Metro-Depot","description":"Betriebsdepot für Wartung und Lagerung der Züge der Linie 3.","directions":"Nördlich des Bahnhofs über die Servicestraße in der Nähe der Ringstraße erreichbar.","map_hint":"Hinter dem Einkaufszentrum."},
    "ru":{"name":"Депо метро","description":"Эксплуатационное депо для обслуживания и хранения поездов линии 3.","directions":"К северу от станции, доступно по сервисной дороге у кольцевой.","map_hint":"За торговым центром."},
    "it":{"name":"Deposito metro","description":"Deposito operativo per manutenzione e stoccaggio dei treni della linea 3.","directions":"A nord della stazione, accessibile dalla strada di servizio vicino alla strada del raccordo.","map_hint":"Dietro il centro commerciale."},
    "pt":{"name":"Garagem do metrô","description":"Depósito operacional para manutenção e armazenamento dos trens da Linha 3.","directions":"Ao norte da estação, acessível pela via de serviço perto da Estrada do Anel.","map_hint":"Atrás do shopping center."},
    "zh":{"name":"地铁车库","description":"3号线地铁列车的维修和存放运营仓库。","directions":"位于车站北侧，经环城公路附近的服务道路可达。","map_hint":"在购物中心后方。"},
    "tr":{"name":"Metro Garajı","description":"3. Hat metro trenlerinin bakım ve depolanmasına yönelik işletme deposu.","directions":"İstasyonun kuzeyinde, Çevre Yolu yakınındaki servis yolundan erişilebilir.","map_hint":"Alışveriş merkezinin arkasında."},
    "ja":{"name":"メトロ車庫","description":"3号線の列車保守・格納のための運転車庫。","directions":"駅北側、環状道路付近のサービス道路からアクセス可能。","map_hint":"ショッピングモールの裏。"},
  },
  "Military Institution": {
    "fr":{"name":"Institution militaire","description":"Un établissement administratif militaire sécurisé dans la région.","directions":"À l'est de la station le long de la rue Othman Ebn Affan.","map_hint":"Près de l'académie de police."},
    "es":{"name":"Institución militar","description":"Una instalación administrativa militar asegurada en la zona.","directions":"Al este de la estación a lo largo de la calle Othman Ebn Affan.","map_hint":"Cerca de la academia de policía."},
    "de":{"name":"Militärische Einrichtung","description":"Eine gesicherte militärische Verwaltungsanlage in der Gegend.","directions":"Östlich des Bahnhofs entlang der Othman Ebn Affan Straße.","map_hint":"In der Nähe der Polizeiakademie."},
    "ru":{"name":"Военное учреждение","description":"Охраняемый военно-административный объект в данном районе.","directions":"К востоку от станции вдоль улицы Усман ибн Аффан.","map_hint":"Рядом с полицейской академией."},
    "it":{"name":"Istituzione militare","description":"Un impianto amministrativo militare protetto nell'area.","directions":"A est della stazione lungo via Othman Ebn Affan.","map_hint":"Vicino all'accademia di polizia."},
    "pt":{"name":"Instituição militar","description":"Uma instalação administrativa militar protegida na área.","directions":"A leste da estação ao longo da Rua Othman Ebn Affan.","map_hint":"Perto da academia de polícia."},
    "zh":{"name":"军事机构","description":"该地区一处有安保的军事行政设施。","directions":"沿奥斯曼·本·阿凡街向车站东侧行进。","map_hint":"靠近警察学院。"},
    "tr":{"name":"Askeri Kurum","description":"Bölgedeki güvenli bir askeri idari tesis.","directions":"İstasyonun doğusunda Othman Ebn Affan Caddesi boyunca.","map_hint":"Polis Akademisi'ne yakın."},
    "ja":{"name":"軍事施設","description":"このエリアにある警備された軍事行政施設。","directions":"駅東側、オスマン・イブン・アッファン通り沿い。","map_hint":"警察学校付近。"},
  },
},

# ── EL-HAYKSTEP ───────────────────────────────────────────────────────────
"EL-HAYKSTEP": {
  "El Herafeyeen Mosque": {
    "fr":{"name":"Mosquée El Herafeyeen","description":"Une mosquée locale du quartier Herafeyeen, connue pour son minaret distinctif et ses prières quotidiennes.","directions":"Sortir de la station de métro et se diriger vers l'est le long de la rue Joseph Tito.","map_hint":""},
    "es":{"name":"Mezquita El Herafeyeen","description":"Una mezquita local que sirve a la zona de Herafeyeen, conocida por su distintivo minarete.","directions":"Salir de la estación y dirigirse al este por la calle Joseph Tito.","map_hint":""},
    "de":{"name":"El Herafeyeen Moschee","description":"Eine lokale Moschee im Herafeyeen-Viertel, bekannt für ihr markantes Minarett.","directions":"Den Bahnhof verlassen und die Joseph Tito Straße Richtung Osten entlanggehen.","map_hint":""},
    "ru":{"name":"Мечеть Эль-Харафийин","description":"Местная мечеть квартала Харафийин, известная своим характерным минаретом.","directions":"Выйти со станции и идти на восток по улице Йозеф Тито.","map_hint":""},
    "it":{"name":"Moschea El Herafeyeen","description":"Una moschea locale che serve la zona di Herafeyeen, nota per il suo caratteristico minareto.","directions":"Uscire dalla stazione e dirigersi a est lungo via Joseph Tito.","map_hint":""},
    "pt":{"name":"Mesquita El Herafeyeen","description":"Uma mesquita local que serve a área de Herafeyeen, conhecida por seu minarete distinto.","directions":"Sair da estação e seguir para leste ao longo da rua Joseph Tito.","map_hint":""},
    "zh":{"name":"埃尔赫拉菲因清真寺","description":"服务于赫拉菲因地区的当地清真寺，以其独特的宣礼塔闻名。","directions":"出地铁站后，沿约瑟夫·提托街向东走。","map_hint":""},
    "tr":{"name":"El Herafeyeen Camii","description":"Herafeyeen bölgesine hizmet eden, ayırt edici minaresiyle tanınan yerel bir cami.","directions":"İstasyondan çıkıp Joseph Tito Caddesi boyunca doğuya yürüyün.","map_hint":""},
    "ja":{"name":"エル・ヘラフィーン・モスク","description":"ヘラフィーン地区に奉仕する地域のモスク。独特のミナレットで知られる。","directions":"駅を出てジョセフ・ティト通りを東へ進む。","map_hint":""},
  },
  "Ammar Ibn Yasser Elementary School": {
    "fr":{"name":"École primaire Ammar Ibn Yasser","description":"Une école primaire publique offrant l'enseignement de base aux enfants du quartier Haykstep.","directions":"Marcher le long de la rue Ahmed Shawki El Keel, l'école est à gauche près du carrefour.","map_hint":""},
    "es":{"name":"Escuela primaria Ammar Ibn Yasser","description":"Una escuela primaria pública que brinda educación básica a los niños del distrito Haykstep.","directions":"Caminar por la calle Ahmed Shawki El Keel, la escuela estará a la izquierda cerca del cruce.","map_hint":""},
    "de":{"name":"Grundschule Ammar Ibn Yasser","description":"Eine öffentliche Grundschule für Kinder im Haykstep-Viertel.","directions":"Ahmed Shawki El Keel Straße entlanggehen, die Schule liegt links nahe der Kreuzung.","map_hint":""},
    "ru":{"name":"Начальная школа Аммара ибн Ясира","description":"Государственная начальная школа для детей района Хайкстеп.","directions":"Идти по улице Ахмед Шауки Эль-Кил, школа слева у перекрёстка.","map_hint":""},
    "it":{"name":"Scuola elementare Ammar Ibn Yasser","description":"Una scuola elementare pubblica che offre istruzione di base ai bambini del distretto di Haykstep.","directions":"Percorrere la via Ahmed Shawki El Keel, la scuola è sulla sinistra vicino all'incrocio.","map_hint":""},
    "pt":{"name":"Escola primária Ammar Ibn Yasser","description":"Uma escola primária pública que oferece educação básica às crianças do bairro Haykstep.","directions":"Caminhar pela rua Ahmed Shawki El Keel, a escola fica à esquerda perto do cruzamento.","map_hint":""},
    "zh":{"name":"阿马尔·本·亚西尔小学","description":"为海克斯泰普区儿童提供基础教育的公立小学。","directions":"沿艾哈迈德·沙乌基·艾尔-基尔街行走，学校在交叉口附近的左侧。","map_hint":""},
    "tr":{"name":"Ammar Ibn Yasser İlköğretim Okulu","description":"Haykstep bölgesindeki çocuklara temel eğitim sunan devlet ilköğretim okulu.","directions":"Ahmed Shawki El Keel Caddesi boyunca yürüyün, okul kavşağa yakın sol tarafta.","map_hint":""},
    "ja":{"name":"アンマール・イブン・ヤーシル小学校","description":"ハイクステップ地区の子どもたちに基礎教育を提供する公立小学校。","directions":"アフメド・シャウキー・エル・キール通りを歩くと、交差点近くの左側に学校があります。","map_hint":""},
  },
  "Cairo International Airport": {
    "fr":{"name":"Aéroport international du Caire","description":"Le principal aéroport international du Caire, offrant des vols intérieurs et internationaux.","directions":"Prendre un taxi vers l'ouest par la rue Joseph Tito en suivant les panneaux vers les terminaux.","map_hint":""},
    "es":{"name":"Aeropuerto Internacional de El Cairo","description":"El principal aeropuerto internacional de El Cairo con vuelos nacionales e internacionales.","directions":"Tomar un taxi hacia el oeste por la calle Joseph Tito siguiendo las señales hacia las terminales.","map_hint":""},
    "de":{"name":"Internationaler Flughafen Kairo","description":"Der Hauptflughafen Kairos für In- und Auslandsflüge.","directions":"Taxi nach Westen entlang der Joseph Tito Straße in Richtung Terminal 1 oder 3.","map_hint":""},
    "ru":{"name":"Каирский международный аэропорт","description":"Главный международный аэропорт Каира с внутренними и международными рейсами.","directions":"Такси на запад по улице Йозеф Тито по указателям к терминалам.","map_hint":""},
    "it":{"name":"Aeroporto internazionale del Cairo","description":"Il principale aeroporto internazionale del Cairo con voli nazionali e internazionali.","directions":"Prendere un taxi verso ovest lungo via Joseph Tito seguendo le indicazioni per i terminal.","map_hint":""},
    "pt":{"name":"Aeroporto Internacional do Cairo","description":"O principal aeroporto internacional do Cairo com voos domésticos e internacionais.","directions":"Pegar um táxi para o oeste pela rua Joseph Tito seguindo as placas para os terminais.","map_hint":""},
    "zh":{"name":"开罗国际机场","description":"开罗主要国际机场，提供国内和国际航班。","directions":"沿约瑟夫·提托街向西乘出租车，按指示牌前往1号或3号航站楼。","map_hint":""},
    "tr":{"name":"Kahire Uluslararası Havalimanı","description":"Kahire'nin iç ve uluslararası uçuşlara hizmet veren ana uluslararası havalimanı.","directions":"Joseph Tito Caddesi'nden batıya doğru terminal tabelalarını takip ederek taksiyle ulaşın.","map_hint":""},
    "ja":{"name":"カイロ国際空港","description":"国内線・国際線を運航するカイロの主要国際空港。","directions":"ジョセフ・ティト通りを西へタクシーで向かい、ターミナル標識に従ってください。","map_hint":""},
  },
  "Car Service Center": {
    "fr":{"name":"Centre de service automobile","description":"Un centre de maintenance automobile proposant réparation et diagnostic pour diverses marques.","directions":"Descendre la rue Gesr El Suez, puis tourner à droite vers le centre de service.","map_hint":""},
    "es":{"name":"Centro de servicio de automóviles","description":"Un centro de mantenimiento de automóviles que ofrece reparación y diagnóstico para varias marcas.","directions":"Bajar por la calle Gesr El Suez, luego doblar a la derecha hacia el área del centro de servicio.","map_hint":""},
    "de":{"name":"Kfz-Servicezentrum","description":"Ein Kfz-Wartungszentrum für Reparatur und Diagnose verschiedener Automarken.","directions":"Die Gesr El Suez Straße hinunter, dann rechts zum Servicebereich.","map_hint":""},
    "ru":{"name":"Автосервисный центр","description":"Центр технического обслуживания автомобилей с диагностикой и ремонтом различных марок.","directions":"Вниз по улице Гисер Эль-Суэйс, затем повернуть направо к сервисному центру.","map_hint":""},
    "it":{"name":"Centro servizi auto","description":"Un centro di manutenzione auto che offre riparazione e diagnostica per vari marchi.","directions":"Scendere la via Gesr El Suez, poi girare a destra verso l'area del centro servizi.","map_hint":""},
    "pt":{"name":"Centro de serviço automotivo","description":"Um centro de manutenção automotiva com reparação e diagnóstico para várias marcas.","directions":"Descer a rua Gesr El Suez, depois virar à direita em direção à área do centro de serviço.","map_hint":""},
    "zh":{"name":"汽车服务中心","description":"提供各品牌汽车维修和诊断的汽车保养中心。","directions":"沿盖斯尔·苏伊士街向下行走，然后向右转到达服务中心区域。","map_hint":""},
    "tr":{"name":"Araç Servis Merkezi","description":"Çeşitli araba markaları için tamir ve teşhis sunan bir oto bakım merkezi.","directions":"Gesr El Suez Caddesi'nden inin, ardından sağa dönerek servis merkezi alanına gidin.","map_hint":""},
    "ja":{"name":"カーサービスセンター","description":"様々なブランドの修理・診断を行う自動車整備センター。","directions":"ゲスル・エル・スエズ通りを下り、右折してサービスセンターへ。","map_hint":""},
  },
  "Police Station El Herafeyeen": {
    "fr":{"name":"Poste de police El Herafeyeen","description":"Bureau de police local gérant la sécurité dans la zone Herafeyeen.","directions":"Avancer vers le nord sur la rue Gamal El Deen Zaki, le poste est adjacent au dépôt de bus.","map_hint":""},
    "es":{"name":"Comisaría de El Herafeyeen","description":"Oficina de policía local que gestiona la seguridad en la zona de Herafeyeen.","directions":"Dirigirse al norte por la calle Gamal El Deen Zaki, la comisaría está junto al depósito de autobuses.","map_hint":""},
    "de":{"name":"Polizeistation El Herafeyeen","description":"Lokales Polizeibüro für Sicherheit im Herafeyeen-Bereich.","directions":"Nördlich der Gamal El Deen Zaki Straße, neben dem Busdepot.","map_hint":""},
    "ru":{"name":"Полицейский участок Эль-Харафийин","description":"Местное полицейское управление, отвечающее за безопасность в районе Харафийин.","directions":"К северу по улице Гамаль Эль-Дин Заки, участок рядом с автобусным депо.","map_hint":""},
    "it":{"name":"Stazione di Polizia El Herafeyeen","description":"Ufficio di polizia locale che gestisce sicurezza nella zona di Herafeyeen.","directions":"Procedere a nord lungo via Gamal El Deen Zaki, la stazione è adiacente al deposito degli autobus.","map_hint":""},
    "pt":{"name":"Delegacia de El Herafeyeen","description":"Delegacia local que gerencia a segurança na zona de Herafeyeen.","directions":"Dirigir-se ao norte pela rua Gamal El Deen Zaki, a delegacia fica ao lado do depósito de ônibus.","map_hint":""},
    "zh":{"name":"埃尔赫拉菲因警察局","description":"负责赫拉菲因区安全执法的当地警察局。","directions":"沿贾马勒·丁·扎基街向北行走，警察局位于公共汽车车库旁边。","map_hint":""},
    "tr":{"name":"El Herafeyeen Polis Karakolu","description":"Herafeyeen bölgesinin güvenliğini sağlayan yerel polis ofisi.","directions":"Gamal El Deen Zaki Caddesi'nde kuzeye ilerleyin, karakol otobüs deposunun yanındadır.","map_hint":""},
    "ja":{"name":"エル・ヘラフィーン警察署","description":"ヘラフィーン地区のセキュリティを管轄する地元警察署。","directions":"ガマール・エル・ディーン・ザキ通りを北へ、警察署はバスデポの隣。","map_hint":""},
  },
  "Military Services": {
    "fr":{"name":"Services militaires","description":"Zone administrative militaire offrant des services officiels au personnel.","directions":"Accès restreint, généralement visible depuis le pont Haykstep vers l'est.","map_hint":""},
    "es":{"name":"Servicios militares","description":"Área administrativa militar que ofrece servicios oficiales al personal.","directions":"Acceso restringido, generalmente visible desde el puente Haykstep hacia el este.","map_hint":""},
    "de":{"name":"Militärdienste","description":"Militärischer Verwaltungsbereich für offizielle und logistische Dienste für Personal.","directions":"Eingeschränkter Zugang – sichtbar vom Haykstep-Bridge-Bereich Richtung Osten.","map_hint":""},
    "ru":{"name":"Военные службы","description":"Военно-административный район с официальными и логистическими услугами для персонала.","directions":"Ограниченный доступ — виден с моста Хайкстеп на восток.","map_hint":""},
    "it":{"name":"Servizi militari","description":"Area amministrativa militare che offre servizi ufficiali al personale.","directions":"Accesso limitato, visibile in genere dal ponte Haykstep verso est.","map_hint":""},
    "pt":{"name":"Serviços militares","description":"Área administrativa militar que oferece serviços oficiais ao pessoal.","directions":"Acesso restrito, geralmente visível da ponte Haykstep em direção ao leste.","map_hint":""},
    "zh":{"name":"军事服务","description":"为军事人员提供官方和后勤服务的军事行政区域。","directions":"限制进入——通常可从海克斯泰普桥向东看到。","map_hint":""},
    "tr":{"name":"Askeri Hizmetler","description":"Personele resmi ve lojistik hizmetler sunan askeri idari alan.","directions":"Kısıtlı erişim - genellikle Haykstep Köprüsü bölgesinden doğuya doğru görülebilir.","map_hint":""},
    "ja":{"name":"軍事サービス","description":"軍人向けの公式・物流サービスを提供する軍事行政区域。","directions":"立入制限あり — ハイクステップ橋エリアから東側が見渡せます。","map_hint":""},
  },
},

# ── OMAR IBN EL-KHATTAB ───────────────────────────────────────────────────
"OMAR IBN EL-KHATTAB": {
  "El Rahman Mosque": {
    "fr":{"name":"Mosquée El Rahman","description":"Une mosquée de quartier desservant la communauté musulmane locale avec des services réguliers.","directions":"Rue de la Mosquée El Rahman, quelques mètres au nord de la station.","map_hint":""},
    "es":{"name":"Mezquita El Rahman","description":"Una mezquita del barrio que sirve a la comunidad musulmana local con servicios regulares.","directions":"Calle de la Mezquita El Rahman, a pocos metros al norte de la estación.","map_hint":""},
    "de":{"name":"El Rahman Moschee","description":"Eine Stadtteilmoschee für die lokale muslimische Gemeinschaft.","directions":"El Rahman Moscheestraße, kurze Gehstrecke nördlich des Bahnhofs.","map_hint":""},
    "ru":{"name":"Мечеть Эль-Рахман","description":"Квартальная мечеть для местной мусульманской общины.","directions":"Улица мечети Эль-Рахман, небольшая прогулка к северу от станции.","map_hint":""},
    "it":{"name":"Moschea El Rahman","description":"Una moschea di quartiere per la comunità musulmana locale con servizi regolari.","directions":"Via della Moschea El Rahman, breve passeggiata a nord della stazione.","map_hint":""},
    "pt":{"name":"Mesquita El Rahman","description":"Uma mesquita do bairro servindo a comunidade muçulmana local com serviços regulares.","directions":"Rua da Mesquita El Rahman, curta caminhada ao norte da estação.","map_hint":""},
    "zh":{"name":"埃尔·拉赫曼清真寺","description":"为当地穆斯林社区提供定期礼拜服务的社区清真寺。","directions":"埃尔拉赫曼清真寺街，距车站北侧不远处。","map_hint":""},
    "tr":{"name":"El Rahman Camii","description":"Yerel Müslüman topluluğuna düzenli hizmetler sunan bir mahalle camii.","directions":"El Rahman Cami Caddesi, istasyonun kuzeyinde kısa yürüme mesafesinde.","map_hint":""},
    "ja":{"name":"エル・ラフマン・モスク","description":"地域のムスリムコミュニティに定期礼拝を提供する地域モスク。","directions":"エル・ラフマン・モスク通り、駅北側から徒歩すぐ。","map_hint":""},
  },
  "Police Sports Club": {
    "fr":{"name":"Club sportif de la Police","description":"Un complexe récréatif offrant diverses installations sportives, principalement pour le personnel de police et les familles.","directions":"Marcher vers l'ouest sur la rue Omar Ibn El Khattab et tourner au sud à la rue Tawakol.","map_hint":""},
    "es":{"name":"Club Deportivo de la Policía","description":"Un complejo recreativo con diversas instalaciones deportivas, principalmente para el personal policial y sus familias.","directions":"Caminar al oeste por la calle Omar Ibn El Khattab y girar al sur en la calle Tawakol.","map_hint":""},
    "de":{"name":"Polizei-Sportclub","description":"Freizeitzentrum mit verschiedenen Sportanlagen, hauptsächlich für Polizeibeamte und Familien.","directions":"Westlich der Omar Ibn El Khattab Straße, links auf die Tawakol Straße abbiegen.","map_hint":""},
    "ru":{"name":"Полицейский спортивный клуб","description":"Спортивный комплекс с различными объектами, в основном для сотрудников полиции и семей.","directions":"Идти на запад по улице Омар ибн Эль-Хаттаб, повернуть на юг на улице Таваколь.","map_hint":""},
    "it":{"name":"Club sportivo della Polizia","description":"Un complesso ricreativo con varie strutture sportive, principalmente per il personale di polizia e le famiglie.","directions":"Camminare a ovest su via Omar Ibn El Khattab e girare a sud alla via Tawakol.","map_hint":""},
    "pt":{"name":"Clube Esportivo da Polícia","description":"Um complexo recreativo com diversas instalações esportivas, principalmente para policiais e familiares.","directions":"Caminhar a oeste pela rua Omar Ibn El Khattab e virar ao sul na rua Tawakol.","map_hint":""},
    "zh":{"name":"警察体育俱乐部","description":"主要为警察人员和家属提供各类体育设施的休闲综合体。","directions":"沿奥马尔·本·哈塔卜街向西走，在塔瓦科勒街向南转。","map_hint":""},
    "tr":{"name":"Polis Spor Kulübü","description":"Başta polis personeli ve aileleri için çeşitli spor tesisleri sunan bir rekreasyon kompleksi.","directions":"Omar Ibn El Khattab Caddesi'nde batıya yürüyün, Tawakol Caddesi'nde güneye dönün.","map_hint":""},
    "ja":{"name":"警察スポーツクラブ","description":"主に警察官とその家族向けの各種スポーツ施設を備えたレクリエーション複合施設。","directions":"オマル・イブン・エル・ハッタブ通りを西へ進み、タワコル通りで南へ曲がる。","map_hint":""},
  },
  "As Salam High Institute for Engineering and Technology": {
    "fr":{"name":"Institut supérieur El Salam d'ingénierie et technologie","description":"Un établissement privé d'enseignement supérieur accrédité proposant des programmes d'ingénierie et de technologie.","directions":"Le long de la rue Gesr El Suez, près du pont autoroutier Gesr El Suez.","map_hint":""},
    "es":{"name":"Instituto Superior El Salam de Ingeniería y Tecnología","description":"Una institución privada de educación superior acreditada que ofrece programas de ingeniería y tecnología.","directions":"A lo largo de la calle Gesr El Suez, cerca del paso elevado Gesr El Suez.","map_hint":""},
    "de":{"name":"As Salam Hochschulinstitut für Ingenieurwesen und Technologie","description":"Eine akkreditierte private Hochschule mit Ingenieur- und Technologieprogrammen.","directions":"Entlang der Gesr El Suez Straße nahe der Gesr El Suez-Autobahnbrücke.","map_hint":""},
    "ru":{"name":"Высший институт Эль-Салам инженерии и технологий","description":"Аккредитованный частный вуз с программами по инженерии и технологиям.","directions":"Вдоль улицы Гесер Эль-Суэйс, у путепровода Гесер Эль-Суэйс.","map_hint":""},
    "it":{"name":"Istituto superiore As Salam di ingegneria e tecnologia","description":"Un istituto privato di istruzione superiore accreditato con programmi di ingegneria e tecnologia.","directions":"Lungo via Gesr El Suez, vicino al cavalcavia Gesr El Suez.","map_hint":""},
    "pt":{"name":"Instituto Superior As Salam de Engenharia e Tecnologia","description":"Uma instituição privada de ensino superior acreditada com programas de engenharia e tecnologia.","directions":"Ao longo da rua Gesr El Suez, perto do viaduto Gesr El Suez.","map_hint":""},
    "zh":{"name":"萨拉姆高等工程技术学院","description":"提供工程和技术专业课程的认证私立高等教育机构。","directions":"沿盖斯尔·苏伊士街，靠近盖斯尔·苏伊士立交桥。","map_hint":""},
    "tr":{"name":"As Salam Mühendislik ve Teknoloji Yüksek Enstitüsü","description":"Mühendislik ve teknoloji programları sunan akredite bir özel yükseköğretim kurumu.","directions":"Gesr El Suez Caddesi boyunca, Gesr El Suez köprüsünün yakınında.","map_hint":""},
    "ja":{"name":"アス・サラーム工学・技術高等研究所","description":"工学・技術プログラムを提供する認定私立高等教育機関。","directions":"ゲスル・エル・スエズ通り沿い、ゲスル・エル・スエズ高架橋付近。","map_hint":""},
  },
  "El Farouqeya Buildings": {
    "fr":{"name":"Immeubles El Farouqeya","description":"Grand complexe résidentiel et commercial dans la zone.","directions":"Le long de la rue Abu Bakr El Sedeek, au nord-est de la station.","map_hint":""},
    "es":{"name":"Edificios El Farouqeya","description":"Un gran complejo residencial y comercial en la zona.","directions":"A lo largo de la calle Abu Bakr El Sedeek, al noreste de la estación.","map_hint":""},
    "de":{"name":"El Farouqeya Gebäude","description":"Ein großer Wohn- und Gewerbekomplex in der Gegend.","directions":"Entlang der Abu Bakr El Sedeek Straße, nordöstlich des Bahnhofs.","map_hint":""},
    "ru":{"name":"Здания Эль-Фаруция","description":"Большой жилой и торговый комплекс в районе.","directions":"Вдоль улицы Абу Бакр Эль-Сиддик, к северо-востоку от станции.","map_hint":""},
    "it":{"name":"Edifici El Farouqeya","description":"Un grande complesso residenziale e commerciale nella zona.","directions":"Lungo via Abu Bakr El Sedeek, a nord-est della stazione.","map_hint":""},
    "pt":{"name":"Edifícios El Farouqeya","description":"Um grande complexo residencial e comercial na área.","directions":"Ao longo da rua Abu Bakr El Sedeek, a nordeste da estação.","map_hint":""},
    "zh":{"name":"埃尔法鲁基亚建筑群","description":"该地区一处大型住宅和商业综合体。","directions":"沿阿布·贝克尔·西迪克街，位于车站东北方向。","map_hint":""},
    "tr":{"name":"El Farouqeya Binaları","description":"Bölgedeki büyük bir konut ve ticaret kompleksi.","directions":"Abu Bakr El Sedeek Caddesi boyunca, istasyonun kuzeydoğusunda.","map_hint":""},
    "ja":{"name":"エル・ファルキヤ建築群","description":"このエリアにある大型住宅・商業複合施設。","directions":"アブー・バクル・エル・シッディーク通り沿い、駅北東。","map_hint":""},
  },
  "Security Aides Institute Gesr El Suez": {
    "fr":{"name":"Institut des aides de sécurité de Gesr El Suez","description":"Centre de formation pour les agents de police auxiliaires en Égypte.","directions":"Se diriger vers le nord le long de la rue Gesr El Suez, après l'institut As Salam.","map_hint":""},
    "es":{"name":"Instituto de ayudantes de seguridad de Gesr El Suez","description":"Centro de formación para agentes de policía auxiliares en Egipto.","directions":"Dirigirse al norte por la calle Gesr El Suez, pasado el Instituto As Salam.","map_hint":""},
    "de":{"name":"Institut für Sicherheitshilfskräfte Gesr El Suez","description":"Ausbildungseinrichtung für Hilfspolizeibeamte in Ägypten.","directions":"Nördlich der Gesr El Suez Straße, hinter dem As Salam Institut.","map_hint":""},
    "ru":{"name":"Институт помощников службы безопасности Гесер Эль-Суэйс","description":"Учебное заведение для помощников сотрудников полиции Египта.","directions":"К северу по улице Гесер Эль-Суэйс, мимо института Эль-Салам.","map_hint":""},
    "it":{"name":"Istituto degli ausiliari della sicurezza di Gesr El Suez","description":"Struttura di formazione per agenti di polizia ausiliari in Egitto.","directions":"Dirigersi a nord lungo via Gesr El Suez, oltre l'istituto As Salam.","map_hint":""},
    "pt":{"name":"Instituto de Auxiliares de Segurança de Gesr El Suez","description":"Estabelecimento de formação para policiais auxiliares do Egito.","directions":"Seguir ao norte pela rua Gesr El Suez, depois do Instituto As Salam.","map_hint":""},
    "zh":{"name":"盖斯尔苏伊士安全辅助学院","description":"埃及警察辅助官员的教育培训机构。","directions":"沿盖斯尔·苏伊士街向北，经过萨拉姆学院之后。","map_hint":""},
    "tr":{"name":"Gesr El Suez Güvenlik Yardımcıları Enstitüsü","description":"Mısır'da yardımcı polis memurları için eğitim tesisi.","directions":"Gesr El Suez Caddesi boyunca kuzeye gidin, As Salam Enstitüsü'nü geçtikten sonra.","map_hint":""},
    "ja":{"name":"ゲスル・エル・スエズ警備補助員研究所","description":"エジプトの補助警察官のための訓練施設。","directions":"ゲスル・エル・スエズ通りを北へ、アス・サラーム研究所を過ぎた先。","map_hint":""},
  },
},

# ── QOBA ──────────────────────────────────────────────────────────────────
"QOBA": {
  "Virgin Mary Church": {
    "fr":{"name":"Église de la Vierge Marie","description":"Une église copte orthodoxe au service de la communauté chrétienne locale.","directions":"Rue Joseph Tito, près de l'arrêt de bus principal.","map_hint":""},
    "es":{"name":"Iglesia de la Virgen María","description":"Una iglesia copto ortodoxa que sirve a la comunidad cristiana local.","directions":"Calle Joseph Tito, cerca de la parada de autobús principal.","map_hint":""},
    "de":{"name":"Kirche der Jungfrau Maria","description":"Eine koptisch-orthodoxe Kirche für die lokale christliche Gemeinde.","directions":"Joseph Tito Straße, nahe der Hauptbushaltestelle.","map_hint":""},
    "ru":{"name":"Церковь Девы Марии","description":"Коптская православная церковь для местной христианской общины.","directions":"Улица Йозеф Тито, рядом с главной автобусной остановкой.","map_hint":""},
    "it":{"name":"Chiesa della Vergine Maria","description":"Una chiesa copta ortodossa che serve la comunità cristiana locale.","directions":"Via Joseph Tito, vicino alla fermata principale degli autobus.","map_hint":""},
    "pt":{"name":"Igreja da Virgem Maria","description":"Uma igreja copta ortodoxa servindo a comunidade cristã local.","directions":"Rua Joseph Tito, perto do ponto de ônibus principal.","map_hint":""},
    "zh":{"name":"圣母玛利亚教堂","description":"为当地基督徒社区服务的科普特正教教堂。","directions":"约瑟夫·提托街，靠近主要公交站。","map_hint":""},
    "tr":{"name":"Bakire Meryem Kilisesi","description":"Yerel Hristiyan topluluğuna hizmet eden Kıpti Ortodoks kilisesi.","directions":"Joseph Tito Caddesi, ana otobüs durağının yanında.","map_hint":""},
    "ja":{"name":"聖母マリア教会","description":"地域のキリスト教コミュニティに奉仕するコプト正教会。","directions":"ジョセフ・ティト通り、メインバス停付近。","map_hint":""},
  },
  "Saudi German Hospital Cairo": {
    "fr":{"name":"Hôpital Saudi German du Caire","description":"Un hôpital privé de premier plan offrant des soins médicaux spécialisés et des services d'urgence.","directions":"Au nord-ouest de la station sur la rue Gesr El Suez, près du carrefour de la rue Ideal.","map_hint":""},
    "es":{"name":"Hospital Saudi German del Cairo","description":"Un hospital privado líder que ofrece atención médica especializada y servicios de emergencia.","directions":"Al noroeste de la estación en la calle Gesr El Suez, cerca del cruce de la calle Ideal.","map_hint":""},
    "de":{"name":"Saudi German Hospital Kairo","description":"Ein führendes Privatkrankenhaus mit spezialisierter Versorgung und Notaufnahme.","directions":"Nordwestlich des Bahnhofs in der Gesr El Suez Straße nahe der Kreuzung Ideal Straße.","map_hint":""},
    "ru":{"name":"Саудовско-немецкий госпиталь в Каире","description":"Ведущая частная больница со специализированной медицинской помощью и экстренными службами.","directions":"К северо-западу от станции на улице Гесер Эль-Суэйс, у перекрёстка с улицей Идеал.","map_hint":""},
    "it":{"name":"Ospedale Saudi German del Cairo","description":"Un ospedale privato leader con cure mediche specializzate e servizi di emergenza.","directions":"A nord-ovest della stazione su via Gesr El Suez, vicino all'incrocio con via Ideal.","map_hint":""},
    "pt":{"name":"Hospital Saudi German do Cairo","description":"Um hospital privado líder com atendimento médico especializado e serviços de emergência.","directions":"A noroeste da estação na rua Gesr El Suez, perto do cruzamento com a rua Ideal.","map_hint":""},
    "zh":{"name":"开罗沙特德国医院","description":"提供专科医疗和急诊服务的顶级私立医院。","directions":"位于车站西北方向盖斯尔·苏伊士街，靠近艾迪亚尔街交叉口。","map_hint":""},
    "tr":{"name":"Kahire Saudi German Hastanesi","description":"Uzmanlaşmış tıbbi bakım ve acil servis sunan önde gelen özel hastane.","directions":"İstasyonun kuzeybatısında Gesr El Suez Caddesi'nde, Ideal Caddesi kavşağına yakın.","map_hint":""},
    "ja":{"name":"カイロ・サウジ・ドイツ病院","description":"専門医療と救急サービスを提供する大手私立病院。","directions":"駅北西のゲスル・エル・スエズ通り、アイデアル通りとの交差点付近。","map_hint":""},
  },
  "General Authority for Literacy and Adult Education": {
    "fr":{"name":"Autorité générale pour l'alphabétisation et l'éducation des adultes","description":"Agence gouvernementale dédiée à la lutte contre l'analphabétisme et aux programmes d'éducation des adultes.","directions":"À l'est du métro le long de la route Taha Hussein.","map_hint":""},
    "es":{"name":"Autoridad General para la Alfabetización y la Educación de Adultos","description":"Agencia gubernamental dedicada a combatir el analfabetismo y proporcionar programas de educación para adultos.","directions":"Al este del metro a lo largo de la Av. Taha Hussein.","map_hint":""},
    "de":{"name":"Allgemeine Behörde für Alphabetisierung und Erwachsenenbildung","description":"Staatliche Behörde zur Bekämpfung von Analphabetismus und zur Förderung der Erwachsenenbildung.","directions":"Östlich des Bahnhofs entlang der Taha Hussein Straße.","map_hint":""},
    "ru":{"name":"Главное управление по ликвидации неграмотности и образованию взрослых","description":"Государственный орган по борьбе с безграмотностью и развитию образования взрослых.","directions":"К востоку от метро вдоль улицы Таха Хусейн.","map_hint":""},
    "it":{"name":"Autorità generale per l'alfabetizzazione e l'istruzione degli adulti","description":"Agenzia governativa per combattere l'analfabetismo e fornire programmi educativi per adulti.","directions":"A est della metropolitana lungo la via Taha Hussein.","map_hint":""},
    "pt":{"name":"Autoridade Geral para Alfabetização e Educação de Adultos","description":"Agência governamental dedicada a combater o analfabetismo e fornecer programas de educação de adultos.","directions":"A leste do metrô ao longo da Avenida Taha Hussein.","map_hint":""},
    "zh":{"name":"扫盲及成人教育总局","description":"致力于消除文盲并提供成人教育项目的政府机构。","directions":"地铁站东侧，沿塔哈·侯赛因路。","map_hint":""},
    "tr":{"name":"Okuryazarlık ve Yetişkin Eğitimi Genel Müdürlüğü","description":"Okuma-yazma bilmezliğiyle mücadele eden ve yetişkin eğitim programları sunan devlet kurumu.","directions":"Taha Hussein Bulvarı boyunca metronun doğusunda.","map_hint":""},
    "ja":{"name":"識字・成人教育総局","description":"非識字問題に取り組み、成人教育プログラムを提供する政府機関。","directions":"地下鉄東側、タハ・フセイン通り沿い。","map_hint":""},
  },
},

# ── HESHAM BARAKAT ────────────────────────────────────────────────────────
"HESHAM BARAKAT": {
  "Badr Park": {
    "fr":{"name":"Parc Badr","description":"Un parc public offrant des espaces verts, des bancs et une aire de jeux pour les familles.","directions":"Sortir de la station et marcher vers l'est le long de la rue El Khamseen.","map_hint":""},
    "es":{"name":"Parque Badr","description":"Un parque público con espacios verdes, bancos y área de juegos para familias.","directions":"Salir de la estación y caminar al este por la calle El Khamseen.","map_hint":""},
    "de":{"name":"Badr Park","description":"Ein öffentlicher Park mit Grünflächen, Bänken und Spielplatz für Familien.","directions":"Den Bahnhof verlassen und Richtung Osten die El Khamseen Straße entlanggehen.","map_hint":""},
    "ru":{"name":"Парк Бадр","description":"Общественный парк с газонами, скамейками и детской площадкой для семей.","directions":"Выйти из станции и идти на восток по улице Эль-Хамсин.","map_hint":""},
    "it":{"name":"Parco Badr","description":"Un parco pubblico con spazi verdi, panchine e un'area giochi per le famiglie.","directions":"Uscire dalla stazione e camminare verso est lungo via El Khamseen.","map_hint":""},
    "pt":{"name":"Parque Badr","description":"Um parque público com espaços verdes, bancos e área de lazer para famílias.","directions":"Sair da estação e caminhar para leste pela rua El Khamseen.","map_hint":""},
    "zh":{"name":"巴德尔公园","description":"一座公共公园，设有绿地、长椅和儿童游乐区，适合家庭休闲。","directions":"出站后沿艾尔-哈姆辛街向东步行。","map_hint":""},
    "tr":{"name":"Badr Parkı","description":"Aileler için yeşil alanlar, banklar ve oyun alanı sunan halka açık park.","directions":"İstasyondan çıkıp El Khamseen Caddesi boyunca doğuya yürüyün.","map_hint":""},
    "ja":{"name":"バドル公園","description":"緑地、ベンチ、遊び場を備えた家族向けの公共公園。","directions":"駅を出てエル・ハムスィーン通りを東へ進む。","map_hint":""},
  },
  "Computer Qualifying Center": {
    "fr":{"name":"Centre de qualification informatique","description":"Un centre professionnel proposant des cours de formation informatique et des certifications.","directions":"Au sud de la station sur la rue Ahmed Zaki, en face de la Compagnie de Transport Direct.","map_hint":""},
    "es":{"name":"Centro de calificación informática","description":"Un centro vocacional que ofrece cursos de formación en TI y certificaciones.","directions":"Al sur de la estación en la calle Ahmed Zaki, frente a la Compañía de Transporte Directo.","map_hint":""},
    "de":{"name":"Computer-Qualifikationszentrum","description":"Berufsbildungszentrum für IT-Kurse und Zertifizierungen.","directions":"Südlich des Bahnhofs in der Ahmed Zaki Straße, gegenüber dem Direkttransportunternehmen.","map_hint":""},
    "ru":{"name":"Центр компьютерной квалификации","description":"Профессиональный центр с курсами ИТ и сертификацией.","directions":"К югу от станции по улице Ахмед Заки, напротив компании Direct Transport.","map_hint":""},
    "it":{"name":"Centro di qualificazione informatica","description":"Un centro professionale con corsi di formazione IT e certificazioni.","directions":"A sud della stazione in via Ahmed Zaki, di fronte alla Compagnia di Trasporto Diretto.","map_hint":""},
    "pt":{"name":"Centro de qualificação em informática","description":"Um centro vocacional com cursos de formação em TI e certificações.","directions":"Ao sul da estação na rua Ahmed Zaki, em frente à Companhia de Transporte Direto.","map_hint":""},
    "zh":{"name":"计算机培训中心","description":"提供IT培训课程和认证的职业中心。","directions":"位于车站南侧艾哈迈德·扎基街，正对直达运输公司。","map_hint":""},
    "tr":{"name":"Bilgisayar Yeterliliği Merkezi","description":"IT eğitimi ve sertifika kursları sunan mesleki merkez.","directions":"İstasyonun güneyinde Ahmed Zaki Caddesi'nde, Doğrudan Ulaşım Şirketi'nin karşısında.","map_hint":""},
    "ja":{"name":"コンピュータ資格センター","description":"IT研修コースと資格認定を提供する職業センター。","directions":"駅南、アフメド・ザキ通り、ダイレクト・トランスポート社の向かい。","map_hint":""},
  },
  "Pioneer Language School": {
    "fr":{"name":"École de langues Pioneer","description":"École privée offrant un enseignement bilingue axé sur les programmes modernes.","directions":"À l'ouest de la station, rue Belal Ibn Rabah, près de la rue Zahret El Madan.","map_hint":""},
    "es":{"name":"Escuela de Idiomas Pioneer","description":"Una escuela privada que ofrece educación bilingüe y currículos modernos.","directions":"Al oeste de la estación, calle Belal Ibn Rabah, cerca de la calle Zahret El Madan.","map_hint":""},
    "de":{"name":"Pioneer Sprachschule","description":"Privatschule mit zweisprachigem Unterricht und modernen Lehrplänen.","directions":"Westlich des Bahnhofs, Belal Ibn Rabah Straße, nahe der Zahret El Madan Straße.","map_hint":""},
    "ru":{"name":"Языковая школа Pioneer","description":"Частная школа с двуязычным обучением и современными учебными программами.","directions":"К западу от станции, улица Билаль ибн Рабах, рядом с улицей Захрет Эль-Мадан.","map_hint":""},
    "it":{"name":"Scuola di lingue Pioneer","description":"Scuola privata con istruzione bilingue e curricola moderni.","directions":"A ovest della stazione, via Belal Ibn Rabah, vicino alla via Zahret El Madan.","map_hint":""},
    "pt":{"name":"Escola de Idiomas Pioneer","description":"Escola privada com ensino bilíngue e currículo moderno.","directions":"A oeste da estação, rua Belal Ibn Rabah, perto da rua Zahret El Madan.","map_hint":""},
    "zh":{"name":"先锋语言学校","description":"提供双语教育和现代课程的私立学校。","directions":"车站西侧，贝拉勒·本·拉巴赫街，靠近扎赫雷特·麦丹街。","map_hint":""},
    "tr":{"name":"Pioneer Dil Okulu","description":"İkili dil eğitimi ve modern müfredat sunan özel okul.","directions":"İstasyonun batısında, Belal Ibn Rabah Caddesi'nde, Zahret El Madan Caddesi yakınında.","map_hint":""},
    "ja":{"name":"パイオニア語学学校","description":"バイリンガル教育と現代的なカリキュラムを提供する私立学校。","directions":"駅西側、ベラル・イブン・ラバフ通り、ザフレト・エル・マダン通り付近。","map_hint":""},
  },
  "Schools' Complex": {
    "fr":{"name":"Complexe scolaire","description":"Un pôle éducatif comprenant plusieurs écoles primaires et préparatoires.","directions":"Au nord le long de la rue El Quds El Shareef près de la zone Masnaa El Warak.","map_hint":""},
    "es":{"name":"Complejo escolar","description":"Un centro educativo que incluye varias escuelas primarias y preparatorias.","directions":"Al norte por la calle El Quds El Shareef cerca de la zona Masnaa El Warak.","map_hint":""},
    "de":{"name":"Schulkomplex","description":"Ein Bildungszentrum mit mehreren Grund- und Vorbereitungsschulen.","directions":"Nördlich entlang der El Quds El Shareef Straße nahe dem Gebiet Masnaa El Warak.","map_hint":""},
    "ru":{"name":"Школьный комплекс","description":"Образовательный центр, включающий несколько начальных и подготовительных школ.","directions":"К северу вдоль улицы Эль-Кудс Эль-Шариф у района Маснаа Эль-Варак.","map_hint":""},
    "it":{"name":"Complesso scolastico","description":"Un polo educativo con più scuole elementari e medie.","directions":"A nord lungo via El Quds El Shareef vicino all'area Masnaa El Warak.","map_hint":""},
    "pt":{"name":"Complexo escolar","description":"Um polo educacional com várias escolas primárias e preparatórias.","directions":"Ao norte pela rua El Quds El Shareef perto da área Masnaa El Warak.","map_hint":""},
    "zh":{"name":"学校综合体","description":"包含多所小学和初中的教育中心。","directions":"沿艾尔-库德斯·沙里夫街向北，靠近马斯纳阿·瓦拉克区域。","map_hint":""},
    "tr":{"name":"Okul Kompleksi","description":"Birden fazla ilk ve orta okul içeren eğitim merkezi.","directions":"El Quds El Shareef Caddesi boyunca kuzeyde, Masnaa El Warak alanına yakın.","map_hint":""},
    "ja":{"name":"学校複合施設","description":"複数の小学校・中学校を含む教育センター。","directions":"エル・クドス・エル・シャリーフ通りを北へ、マスナア・エル・ワラク地区付近。","map_hint":""},
  },
  "Direct Transport Company": {
    "fr":{"name":"Compagnie de transport direct","description":"Fournit des services de transport en bus locaux publics et privés dans toute la ville.","directions":"En face de la station sur la rue Gesr El Suez.","map_hint":""},
    "es":{"name":"Compañía de Transporte Directo","description":"Proporciona servicios de transporte en autobús local público y privado en toda la ciudad.","directions":"Frente a la estación en la calle Gesr El Suez.","map_hint":""},
    "de":{"name":"Direktes Transportunternehmen","description":"Bietet lokale öffentliche und private Busverkehrsdienste in der ganzen Stadt an.","directions":"Gegenüber dem Bahnhof an der Gesr El Suez Straße.","map_hint":""},
    "ru":{"name":"Компания прямого транспорта","description":"Предоставляет услуги местных общественных и частных автобусов по всему городу.","directions":"Напротив станции на улице Гесер Эль-Суэйс.","map_hint":""},
    "it":{"name":"Compagnia di trasporto diretto","description":"Fornisce servizi di trasporto in autobus locali pubblici e privati in tutta la città.","directions":"Di fronte alla stazione su via Gesr El Suez.","map_hint":""},
    "pt":{"name":"Companhia de Transporte Direto","description":"Oferece serviços de ônibus locais públicos e privados por toda a cidade.","directions":"Em frente à estação na rua Gesr El Suez.","map_hint":""},
    "zh":{"name":"直达运输公司","description":"提供全市本地公共和私人巴士运输服务。","directions":"位于盖斯尔·苏伊士街，车站对面。","map_hint":""},
    "tr":{"name":"Doğrudan Ulaşım Şirketi","description":"Şehir genelinde yerel kamu ve özel otobüs ulaşım hizmetleri sağlar.","directions":"İstasyonun karşısında, Gesr El Suez Caddesi'nde.","map_hint":""},
    "ja":{"name":"ダイレクト・トランスポート社","description":"市内全域で地域の公共・民間バス輸送サービスを提供。","directions":"ゲスル・エル・スエズ通り、駅の向かい側。","map_hint":""},
  },
},

# ── NADI EL-SHAMS ─────────────────────────────────────────────────────────
"NADI EL-SHAMS": {
  "El Arab Mosque": {
    "fr":{"name":"Mosquée El Arab","description":"Une mosquée centrale desservant la zone avec des prières régulières et des événements communautaires.","directions":"Rue El Arab, près de l'entrée principale du parc à thème El Arab.","map_hint":""},
    "es":{"name":"Mezquita El Arab","description":"Una mezquita central que sirve a la zona con oraciones regulares y eventos comunitarios.","directions":"Calle El Arab, cerca de la entrada principal del parque temático El Arab.","map_hint":""},
    "de":{"name":"El Arab Moschee","description":"Eine zentrale Moschee mit regelmäßigen Gebeten und Gemeinschaftsveranstaltungen.","directions":"El Arab Straße nahe des Haupteingangs des El Arab Freizeitparks.","map_hint":""},
    "ru":{"name":"Мечеть Эль-Араб","description":"Центральная мечеть с регулярными молитвами и общественными мероприятиями.","directions":"Улица Эль-Араб, рядом с главным входом в тематический парк Эль-Араб.","map_hint":""},
    "it":{"name":"Moschea El Arab","description":"Una moschea centrale con preghiere regolari ed eventi comunitari.","directions":"Via El Arab, vicino all'ingresso principale del parco a tema El Arab.","map_hint":""},
    "pt":{"name":"Mesquita El Arab","description":"Uma mesquita central servindo a área com orações regulares e eventos comunitários.","directions":"Rua El Arab, perto da entrada principal do parque temático El Arab.","map_hint":""},
    "zh":{"name":"埃尔阿拉伯清真寺","description":"为该地区提供定期礼拜和社区活动的中心清真寺。","directions":"埃尔阿拉伯街，靠近埃尔阿拉伯主题公园的主入口。","map_hint":""},
    "tr":{"name":"El Arab Camii","description":"Düzenli ibadet ve toplum etkinlikleriyle bölgeye hizmet eden merkezi cami.","directions":"El Arab Caddesi, El Arab tema parkının ana girişine yakın.","map_hint":""},
    "ja":{"name":"エル・アラブ・モスク","description":"定期礼拝と地域イベントで地区に奉仕する中心的なモスク。","directions":"エル・アラブ通り、エル・アラブ・テーマパークのメイン入口付近。","map_hint":""},
  },
  "El Shams Club": {
    "fr":{"name":"Club El Shams","description":"L'un des plus grands clubs sportifs et sociaux du Caire avec des installations étendues.","directions":"Directement à côté de la station de métro sur la rue Gesr El Suez.","map_hint":""},
    "es":{"name":"Club El Shams","description":"Uno de los clubes deportivos y sociales más grandes de El Cairo con extensas instalaciones.","directions":"Directamente junto a la estación de metro en la calle Gesr El Suez.","map_hint":""},
    "de":{"name":"El Shams Club","description":"Einer der größten Sport- und Gesellschaftsclubs Kairos mit umfangreichen Einrichtungen.","directions":"Direkt neben der Metrostation an der Gesr El Suez Straße.","map_hint":""},
    "ru":{"name":"Клуб Эль-Шамс","description":"Один из крупнейших спортивных и общественных клубов Каира с обширными объектами.","directions":"Непосредственно рядом со станцией метро на улице Гесер Эль-Суэйс.","map_hint":""},
    "it":{"name":"Club El Shams","description":"Uno dei più grandi club sportivi e sociali del Cairo con strutture estese.","directions":"Direttamente accanto alla stazione della metropolitana su via Gesr El Suez.","map_hint":""},
    "pt":{"name":"Clube El Shams","description":"Um dos maiores clubes esportivos e sociais do Cairo com extensas instalações.","directions":"Diretamente ao lado da estação de metrô na rua Gesr El Suez.","map_hint":""},
    "zh":{"name":"太阳俱乐部","description":"开罗最大的体育和社交俱乐部之一，设施齐全。","directions":"紧邻地铁站，位于盖斯尔·苏伊士街。","map_hint":""},
    "tr":{"name":"El Shams Kulübü","description":"Kahire'nin kapsamlı tesisleriyle en büyük spor ve sosyal kulüplerinden biri.","directions":"Gesr El Suez Caddesi'nde metro istasyonunun hemen yanında.","map_hint":""},
    "ja":{"name":"エル・シャムス・クラブ","description":"広大な施設を持つカイロ最大級のスポーツ・社交クラブの一つ。","directions":"ゲスル・エル・スエズ通り、地下鉄駅のすぐ隣。","map_hint":""},
  },
  "El Arab Theme Park": {
    "fr":{"name":"Parc El Arab","description":"Un petit parc d'attractions avec manèges et activités pour toute la famille.","directions":"Au nord-ouest de la station, à côté de la mosquée El Arab, rue El Arab.","map_hint":""},
    "es":{"name":"Parque temático El Arab","description":"Un pequeño parque de atracciones con atracciones y actividades para toda la familia.","directions":"Al noroeste de la estación, junto a la Mezquita El Arab, en la calle El Arab.","map_hint":""},
    "de":{"name":"El Arab Freizeitpark","description":"Ein kleiner Vergnügungspark mit Fahrgeschäften und Familienattraktionen.","directions":"Nordwestlich des Bahnhofs, neben der El Arab Moschee, El Arab Straße.","map_hint":""},
    "ru":{"name":"Тематический парк Эль-Араб","description":"Небольшой парк развлечений с аттракционами для всей семьи.","directions":"К северо-западу от станции, рядом с мечетью Эль-Араб, улица Эль-Араб.","map_hint":""},
    "it":{"name":"Parco a tema El Arab","description":"Un piccolo parco divertimenti con giostre e attrazioni per famiglie.","directions":"A nord-ovest della stazione, accanto alla Moschea El Arab, via El Arab.","map_hint":""},
    "pt":{"name":"Parque temático El Arab","description":"Um pequeno parque de diversões com brinquedos e atrações para toda a família.","directions":"A noroeste da estação, ao lado da Mesquita El Arab, rua El Arab.","map_hint":""},
    "zh":{"name":"埃尔阿拉伯主题公园","description":"设有游乐设施和家庭娱乐项目的小型游乐园。","directions":"车站西北方向，毗邻埃尔阿拉伯清真寺，位于埃尔阿拉伯街。","map_hint":""},
    "tr":{"name":"El Arab Tema Parkı","description":"Aileler için oyun alanları ve eğlence tesisleri olan küçük bir eğlence parkı.","directions":"İstasyonun kuzeybatısında, El Arab Camii'nin yanında, El Arab Caddesi'nde.","map_hint":""},
    "ja":{"name":"エル・アラブ・テーマパーク","description":"乗り物やファミリー向けアトラクションを備えた小型遊園地。","directions":"駅北西、エル・アラブ・モスク隣接、エル・アラブ通り。","map_hint":""},
  },
  "Public Taxes Authority": {
    "fr":{"name":"Administration fiscale publique","description":"Institution gouvernementale responsable de l'administration fiscale locale.","directions":"Rue Khalid Ibn El Walid, près du carrefour Gesr El Suez.","map_hint":""},
    "es":{"name":"Autoridad de impuestos públicos","description":"Institución gubernamental responsable de la administración tributaria local.","directions":"Calle Khalid Ibn El Walid, cerca del cruce Gesr El Suez.","map_hint":""},
    "de":{"name":"Öffentliche Steuerbehörde","description":"Staatliche Institution für die lokale Steuerverwaltung.","directions":"Khalid Ibn El Walid Straße nahe der Gesr El Suez Kreuzung.","map_hint":""},
    "ru":{"name":"Налоговая служба","description":"Государственный орган, ответственный за местное налоговое администрирование.","directions":"Улица Халид ибн Эль-Валид, у перекрёстка Гесер Эль-Суэйс.","map_hint":""},
    "it":{"name":"Autorità fiscale pubblica","description":"Istituzione governativa responsabile dell'amministrazione fiscale locale.","directions":"Via Khalid Ibn El Walid, vicino al bivio Gesr El Suez.","map_hint":""},
    "pt":{"name":"Autoridade tributária pública","description":"Instituição governamental responsável pela administração tributária local.","directions":"Rua Khalid Ibn El Walid, perto do cruzamento Gesr El Suez.","map_hint":""},
    "zh":{"name":"公共税务局","description":"负责地方税务管理的政府机构。","directions":"哈立德·本·瓦利德街，靠近盖斯尔·苏伊士交叉口。","map_hint":""},
    "tr":{"name":"Kamu Vergileri Dairesi","description":"Yerel vergi idaresinden sorumlu devlet kurumu.","directions":"Khalid Ibn El Walid Caddesi, Gesr El Suez kavşağına yakın.","map_hint":""},
    "ja":{"name":"公共税務局","description":"地方税務行政を担う政府機関。","directions":"ハーリド・イブン・エル・ワリード通り、ゲスル・エル・スエズ交差点付近。","map_hint":""},
  },
},

# ── ALF MASKAN ────────────────────────────────────────────────────────────
"ALF MASKAN": {
  "Fatima Zahra Mosque": {
    "fr":{"name":"Mosquée Fatima Zahra","description":"Une mosquée bien décorée desservant la communauté locale pour les prières quotidiennes.","directions":"À environ 300 m à l'ouest de la station, rue Ahmed Ismail.","map_hint":""},
    "es":{"name":"Mezquita Fatima Zahra","description":"Una mezquita bien decorada que sirve a la comunidad local para las oraciones diarias.","directions":"A unos 300 m al oeste de la estación, en la calle Ahmed Ismail.","map_hint":""},
    "de":{"name":"Fatima Zahra Moschee","description":"Eine gut dekorierte Moschee für das tägliche Gebet der lokalen Gemeinschaft.","directions":"Ca. 300 m westlich des Bahnhofs, Ahmed Ismail Straße.","map_hint":""},
    "ru":{"name":"Мечеть Фатимы Захры","description":"Украшенная мечеть для ежедневных молитв местной общины.","directions":"Примерно в 300 м к западу от станции, улица Ахмед Исмаил.","map_hint":""},
    "it":{"name":"Moschea Fatima Zahra","description":"Una moschea ben decorata al servizio della comunità locale per le preghiere quotidiane.","directions":"A circa 300 m a ovest della stazione, via Ahmed Ismail.","map_hint":""},
    "pt":{"name":"Mesquita Fatima Zahra","description":"Uma mesquita bem decorada servindo a comunidade local para orações diárias.","directions":"A cerca de 300 m a oeste da estação, rua Ahmed Ismail.","map_hint":""},
    "zh":{"name":"法蒂玛·扎赫拉清真寺","description":"装饰精美的清真寺，为当地社区提供每日礼拜服务。","directions":"位于车站西侧约300米处，艾哈迈德·伊斯梅尔街。","map_hint":""},
    "tr":{"name":"Fatima Zahra Camii","description":"Yerel topluluğa günlük ibadetler için hizmet eden güzel dekore edilmiş cami.","directions":"İstasyonun yaklaşık 300 m batısında, Ahmed Ismail Caddesi'nde.","map_hint":""},
    "ja":{"name":"ファーティマ・ザフラー・モスク","description":"地域コミュニティの日常礼拝に奉仕する美しく装飾されたモスク。","directions":"駅西約300m、アフメド・イスマイル通り。","map_hint":""},
  },
  "Heliopolis Specialized Hospital": {
    "fr":{"name":"Hôpital spécialisé d'Héliopolis","description":"Un hôpital proposant des services spécialisés ambulatoires et hospitaliers.","directions":"Marcher vers le sud sur la rue Gesr El Suez, l'hôpital est à gauche après 400 m.","map_hint":""},
    "es":{"name":"Hospital especializado de Heliópolis","description":"Un hospital que ofrece servicios especializados ambulatorios e internados.","directions":"Caminar hacia el sur por la calle Gesr El Suez, el hospital está a la izquierda después de 400 m.","map_hint":""},
    "de":{"name":"Spezialkrankenhaus Heliopolis","description":"Krankenhaus mit spezialisierten ambulanten und stationären Diensten.","directions":"Südlich der Gesr El Suez Straße, das Krankenhaus ist links nach 400 m.","map_hint":""},
    "ru":{"name":"Специализированный госпиталь Гелиополис","description":"Больница со специализированными амбулаторными и стационарными услугами.","directions":"К югу по улице Гесер Эль-Суэйс, больница слева через 400 м.","map_hint":""},
    "it":{"name":"Ospedale specializzato di Heliopolis","description":"Ospedale con servizi specializzati ambulatoriali e ospedalieri.","directions":"Andare a sud su via Gesr El Suez, l'ospedale è sulla sinistra dopo 400 m.","map_hint":""},
    "pt":{"name":"Hospital Especializado de Heliópolis","description":"Hospital com serviços especializados ambulatoriais e hospitalares.","directions":"Caminhar para o sul pela rua Gesr El Suez, o hospital fica à esquerda após 400 m.","map_hint":""},
    "zh":{"name":"赫利奥波利斯专科医院","description":"提供专科门诊和住院服务的医院。","directions":"沿盖斯尔·苏伊士街向南步行，400米后医院在左侧。","map_hint":""},
    "tr":{"name":"Heliopolis Uzmanlaşmış Hastanesi","description":"Uzmanlaşmış ayakta tedavi ve yatılı hizmetler sunan hastane.","directions":"Gesr El Suez Caddesi'nde güneye yürüyün, 400 m sonra hastane sol tarafta.","map_hint":""},
    "ja":{"name":"ヘリオポリス専門病院","description":"専門外来・入院サービスを提供する病院。","directions":"ゲスル・エル・スエズ通りを南へ、400m後左手に病院があります。","map_hint":""},
  },
  "Alf Maskan Square": {
    "fr":{"name":"Place Alf Maskan","description":"Une place publique animée et lieu emblématique au cœur de la station.","directions":"Directement au-dessus de l'entrée de la station.","map_hint":""},
    "es":{"name":"Plaza Alf Maskan","description":"Una concurrida plaza pública y punto de referencia local en el corazón de la estación.","directions":"Directamente sobre la entrada de la estación.","map_hint":""},
    "de":{"name":"Alf Maskan Platz","description":"Ein belebter öffentlicher Platz und lokales Wahrzeichen im Herzen der Bahnhofsumgebung.","directions":"Direkt über dem Bahnhofseingang.","map_hint":""},
    "ru":{"name":"Площадь Альф Маскан","description":"Оживлённая общественная площадь и местный ориентир в центре района.","directions":"Прямо над входом на станцию.","map_hint":""},
    "it":{"name":"Piazza Alf Maskan","description":"Una vivace piazza pubblica e punto di riferimento locale nel cuore della stazione.","directions":"Direttamente sopra l'ingresso della stazione.","map_hint":""},
    "pt":{"name":"Praça Alf Maskan","description":"Uma movimentada praça pública e ponto de referência local no coração da estação.","directions":"Diretamente acima da entrada da estação.","map_hint":""},
    "zh":{"name":"阿尔夫·马斯坎广场","description":"位于车站核心地带的热闹公共广场，当地地标。","directions":"正对车站入口上方。","map_hint":""},
    "tr":{"name":"Alf Maskan Meydanı","description":"İstasyonun merkezinde kalabalık bir kamu meydanı ve yerel simge.","directions":"Doğrudan istasyon girişinin üzerinde.","map_hint":""},
    "ja":{"name":"アルフ・マスカン広場","description":"駅の中心部にある賑やかな公共広場、地元のランドマーク。","directions":"駅入口の真上。","map_hint":""},
  },
},

# ── HELIOPOLIS ────────────────────────────────────────────────────────────
"HELIOPOLIS": {
  "Heliopolis Hospital": {
    "fr":{"name":"Hôpital d'Héliopolis","description":"Grand hôpital privé offrant un large éventail de services spécialisés.","directions":"Rue El Nozha, à 600 m au nord-est — visible de la route.","map_hint":""},
    "es":{"name":"Hospital Heliópolis","description":"Gran hospital privado que ofrece una amplia gama de servicios especializados.","directions":"Calle El Nozha, a 600 m al noreste — visible desde la carretera.","map_hint":""},
    "de":{"name":"Heliopolis Krankenhaus","description":"Großes Privatkrankenhaus mit einer Vielzahl von Fachdienstleistungen.","directions":"El Nozha Straße, 600 m nordöstlich — von der Straße sichtbar.","map_hint":""},
    "ru":{"name":"Больница Гелиополис","description":"Крупная частная больница с широким спектром специализированных услуг.","directions":"Улица Эль-Нозха, 600 м на северо-востоке — видна с дороги.","map_hint":""},
    "it":{"name":"Ospedale Heliopolis","description":"Grande ospedale privato che offre un'ampia gamma di servizi specializzati.","directions":"Via El Nozha, a 600 m a nord-est — visibile dalla strada.","map_hint":""},
    "pt":{"name":"Hospital Heliópolis","description":"Grande hospital privado oferecendo ampla gama de serviços especializados.","directions":"Rua El Nozha, a 600 m a nordeste — visível da estrada.","map_hint":""},
    "zh":{"name":"赫利奥波利斯医院","description":"提供多种专科服务的大型私立医院。","directions":"艾尔-诺扎街，东北方向600米——从路上可见。","map_hint":""},
    "tr":{"name":"Heliopolis Hastanesi","description":"Geniş uzman hizmetleri sunan büyük özel hastane.","directions":"El Nozha Caddesi, kuzeydoğuda 600 m — yoldan görülebilir.","map_hint":""},
    "ja":{"name":"ヘリオポリス病院","description":"幅広い専門サービスを提供する大型私立病院。","directions":"エル・ノズハ通り、北東600m — 道路から見えます。","map_hint":""},
  },
  "Heliopolis Square": {
    "fr":{"name":"Place d'Héliopolis","description":"Rond-point emblématique et lieu de rencontre construit au début du XXe siècle.","directions":"Directement au-dessus de la station sur la rue El Nozha.","map_hint":""},
    "es":{"name":"Plaza de Heliópolis","description":"Emblemática rotonda y punto de encuentro construido a principios del siglo XX.","directions":"Directamente sobre la estación en la calle El Nozha.","map_hint":""},
    "de":{"name":"Heliopolis Platz","description":"Ikonischer Verkehrskreisel und Treffpunkt aus dem frühen 20. Jahrhundert.","directions":"Direkt über der Station an der El Nozha Straße.","map_hint":""},
    "ru":{"name":"Площадь Гелиополис","description":"Знаковый перекрёсток и место встреч, построенное в начале XX века.","directions":"Прямо над станцией на улице Эль-Нозха.","map_hint":""},
    "it":{"name":"Piazza Heliopolis","description":"Iconico incrocio e punto d'incontro costruito all'inizio del XX secolo.","directions":"Direttamente sopra la stazione su via El Nozha.","map_hint":""},
    "pt":{"name":"Praça Heliópolis","description":"Rotatória icônica e ponto de encontro construído no início do século XX.","directions":"Diretamente sobre a estação na rua El Nozha.","map_hint":""},
    "zh":{"name":"赫利奥波利斯广场","description":"建于20世纪初的标志性环岛和聚会地点。","directions":"正对地铁站上方，位于艾尔-诺扎街。","map_hint":""},
    "tr":{"name":"Heliopolis Meydanı","description":"Erken 20. yüzyılda inşa edilmiş ikonik trafik kavşağı ve buluşma noktası.","directions":"El Nozha Caddesi'nde istasyonun doğrudan üzerinde.","map_hint":""},
    "ja":{"name":"ヘリオポリス広場","description":"20世紀初頭に建設された象徴的なロータリーと待ち合わせスポット。","directions":"エル・ノズハ通り、駅の真上。","map_hint":""},
  },
},

}  # end TRANSLATIONS


# ---------------------------------------------------------------------------
# Helper function: get translation for an item
# ---------------------------------------------------------------------------
def get_translation(station_suffix, en_item_key, lang, field):
    """Return translated field value or None if not found."""
    s = TRANSLATIONS.get(station_suffix, {})
    i = s.get(en_item_key, {})
    l = i.get(lang, {})
    v = l.get(field)
    return v  # None means "use English fallback"


# ---------------------------------------------------------------------------
# Main processing
# ---------------------------------------------------------------------------
with open(SRC, "r", encoding="utf-8") as f:
    data = json.load(f)

new_data = {}

for key, station_value in data.items():
    # Only keep original en_ and ar_ entries; translated entries are regenerated
    prefix = key.split("_")[0]
    if prefix not in ("en", "ar"):
        continue  # skip old generated translations; we'll regenerate them
    new_data[key] = station_value

    # Only process en_ entries to generate new translations
    if not key.startswith("en_"):
        continue

    station_suffix = key[len("en_metroStation"):]  # e.g. "ADLY MANSOUR"

    for lang in LANGS:
        full_suffix = key[3:]  # "metroStationADLY MANSOUR"
        lang_key = f"{lang}_{full_suffix}"

        # Skip only if this was an ORIGINAL key (ar_) not one we generated
        # We always regenerate translated entries from en_ source
        pass

        lang_station = {}

        for item_key, item_val in station_value.items():
            if not isinstance(item_val, dict):
                continue

            category = item_val.get("category", "")

            # Build new item
            new_item = {}

            # category always stays in English
            new_item["category"] = category

            # Translate description
            if "description" in item_val:
                translated = get_translation(station_suffix, item_key, lang, "description")
                new_item["description"] = translated if translated is not None else item_val["description"]

            # Translate directions
            if "directions" in item_val:
                translated = get_translation(station_suffix, item_key, lang, "directions")
                new_item["directions"] = translated if translated is not None else item_val["directions"]

            # Translate map_hint
            if "map_hint" in item_val:
                translated = get_translation(station_suffix, item_key, lang, "map_hint")
                val = translated if translated is not None else item_val["map_hint"]
                if val:  # only include if non-empty
                    new_item["map_hint"] = val

            # Copy coordinates
            for coord_key in ("lat", "lng", "latitude", "longitude"):
                if coord_key in item_val:
                    new_item[coord_key] = item_val[coord_key]

            # Determine translated item key name
            translated_name = get_translation(station_suffix, item_key, lang, "name")
            final_key = translated_name if translated_name else item_key

            lang_station[final_key] = new_item

        new_data[lang_key] = lang_station

# Write output
with open(DST, "w", encoding="utf-8") as f:
    json.dump(new_data, f, ensure_ascii=False, indent=2)

print(f"Done. Total keys: {len(new_data)}")
