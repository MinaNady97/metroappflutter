// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get locale => 'ja';

  @override
  String get departureStationTitle => '出発駅';

  @override
  String get arrivalStationTitle => '到着駅';

  @override
  String get departureStationHint => '出発駅を選択';

  @override
  String get arrivalStationHint => '到着駅を選択';

  @override
  String get destinationFieldLabel => '目的地を入力';

  @override
  String get findButtonText => '検索';

  @override
  String get showRoutesButtonText => 'ルートを表示';

  @override
  String get pleaseSelectDeparture => '出発駅を選択してください。';

  @override
  String get pleaseSelectArrival => '到着駅を選択してください。';

  @override
  String get selectDifferentStations => '異なる駅を選択してください。';

  @override
  String get nearestStationLabel => '最寄り駅';

  @override
  String get addressNotFound => '住所が見つかりません。詳細情報を入力して再試行してください。';

  @override
  String get invalidDataFormat => '無効なデータ形式';

  @override
  String get routeToNearest => '最寄り駅へのルート';

  @override
  String get routeToDestination => '目的地へのルート';

  @override
  String get pleaseClickOnMyLocation => '先に現在地ボタンをタップしてください';

  @override
  String get mustTypeADestination => '先に目的地を入力してください。';

  @override
  String get estimatedTravelTime => '所要時間の目安';

  @override
  String get ticketPrice => '運賃';

  @override
  String get noOfStations => '駅数';

  @override
  String get changeAt => '乗り換え駅';

  @override
  String get totalTravelTime => '合計所要時間の目安';

  @override
  String get changeTime => '乗り換え所要時間の目安';

  @override
  String get firstTake => '第1区間';

  @override
  String get firstDirection => '第1方向';

  @override
  String get firstDeparture => '第1出発';

  @override
  String get firstArrival => '第1到着';

  @override
  String get firstIntermediateStations => '第1途中駅';

  @override
  String get secondTake => '第2区間';

  @override
  String get secondDirection => '第2方向';

  @override
  String get secondDeparture => '第2出発';

  @override
  String get secondArrival => '第2到着';

  @override
  String get secondIntermediateStations => '第2途中駅';

  @override
  String get thirdTake => '第3区間';

  @override
  String get thirdDirection => '第3方向';

  @override
  String get thirdDeparture => '第3出発';

  @override
  String get thirdArrival => '第3到着';

  @override
  String get thirdIntermediateStations => '第3途中駅';

  @override
  String get error => 'エラー：';

  @override
  String get mustTypeDestination => '先に目的地を入力してください。';

  @override
  String get noRoutesFound => 'ルートが見つかりません';

  @override
  String get routeDetails => 'ルート詳細';

  @override
  String get departure => '出発：';

  @override
  String get arrival => '到着：';

  @override
  String get take => '乗車：';

  @override
  String get direction => '方向：';

  @override
  String get intermediateStations => '途中駅：';

  @override
  String egp(Object price) {
    return '$price EGP';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => '駅を表示';

  @override
  String get hideStations => '駅を非表示';

  @override
  String get showRoute => 'ルートを表示';

  @override
  String get metro1 => '地下鉄1号線';

  @override
  String get metro2 => '地下鉄2号線';

  @override
  String get metro3branch1 => '地下鉄3号線支線 ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => '地下鉄3号線支線 CAIRO UNIVERSITY';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return '$stationNameまでの距離は$distanceメートルです';
  }

  @override
  String reachedStation(Object stationName) {
    return '$stationNameに到着しました';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return '現在駅$currentStationName、次の駅$nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return '現在駅$currentStationName、次の駅$nextStationName、$lineNameの$direction方面に乗り換えます';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return '現在駅$currentStationName、次の駅$nextStationNameが到着駅です';
  }

  @override
  String get finalStationReached => '到着駅に到着しました。旅程完了';

  @override
  String get exchangeStation => '乗り換え駅';

  @override
  String get intermediateStationsTitle => '途中駅';

  @override
  String get metroStationHELWAN => 'HELWAN';

  @override
  String get metroStationAIN_HELWAN => 'AIN HELWAN';

  @override
  String get metroStationHELWAN_UNIVERSITY => 'HELWAN UNIVERSITY';

  @override
  String get metroStationWADI_HOF => 'WADI HOF';

  @override
  String get metroStationHADAYEK_HELWAN => 'HADAYEK HELWAN';

  @override
  String get metroStationEL_MAASARA => 'EL-MAASARA';

  @override
  String get metroStationTORA_EL_ASMANT => 'TORA EL-ASMANT';

  @override
  String get metroStationKOZZIKA => 'KOZZIKA';

  @override
  String get metroStationTORA_EL_BALAD => 'TORA EL-BALAD';

  @override
  String get metroStationTHAKANAT_EL_MAADI => 'THAKANAT EL-MAADI';

  @override
  String get metroStationMAADI => 'MAADI';

  @override
  String get metroStationHADAYEK_EL_MAADI => 'HADAYEK EL-MAADI';

  @override
  String get metroStationDAR_EL_SALAM => 'DAR EL-SALAM';

  @override
  String get metroStationEL_ZAHRAA => 'EL-ZAHRAA';

  @override
  String get metroStationMAR_GIRGIS => 'MAR GIRGIS';

  @override
  String get metroStationEL_MALEK_EL_SALEH => 'EL-MALEK EL-SALEH';

  @override
  String get metroStationSAYEDA_ZEINAB => 'SAYEDA ZEINAB';

  @override
  String get metroStationSAAD_ZAGHLOUL => 'SAAD ZAGHLOUL';

  @override
  String get metroStationSADAT => 'SADAT';

  @override
  String get metroStationGAMAL_ABD_EL_NASSER => 'GAMAL ABD EL-NASSER';

  @override
  String get metroStationORABI => 'ORABI';

  @override
  String get metroStationEL_SHOHADAAH => 'EL-SHOHADAAH';

  @override
  String get metroStationGHAMRA => 'GHAMRA';

  @override
  String get metroStationEL_DEMERDASH => 'EL-DEMERDASH';

  @override
  String get metroStationMANSHIET_EL_SADR => 'MANSHIET EL-SADR';

  @override
  String get metroStationKOBRI_EL_QOBBA => 'KOBRI EL-QOBBA';

  @override
  String get metroStationHAMMAMAT_EL_QOBBA => 'HAMMAMAT EL-QOBBA';

  @override
  String get metroStationSARAY_EL_QOBBA => 'SARAY EL-QOBBA';

  @override
  String get metroStationHADAYEK_EL_ZAITOUN => 'HADAYEK EL-ZAITOUN';

  @override
  String get metroStationHELMEYET_EL_ZAITOUN => 'HELMEYET EL-ZAITOUN';

  @override
  String get metroStationEL_MATARYA => 'EL-MATARYA';

  @override
  String get metroStationAIN_SHAMS => 'AIN SHAMS';

  @override
  String get metroStationEZBET_EL_NAKHL => 'EZBET EL-NAKHL';

  @override
  String get metroStationEL_MARG => 'EL-MARG';

  @override
  String get metroStationNEW_EL_MARG => 'NEW EL-MARG';

  @override
  String get metroStationEL_MOUNIB => 'EL-MOUNIB';

  @override
  String get metroStationSAQYET_MAKKI => 'SAQYET MAKKI';

  @override
  String get metroStationOM_EL_MASRYEEN => 'OM EL-MASRYEEN';

  @override
  String get metroStationGIZA => 'GIZA';

  @override
  String get metroStationFEISAL => 'FEISAL';

  @override
  String get metroStationCAIRO_UNIVERSITY => 'CAIRO UNIVERSITY';

  @override
  String get metroStationEL_BEHOUS => 'EL-BEHOUS';

  @override
  String get metroStationEL_DOKKI => 'EL-DOKKI';

  @override
  String get metroStationOPERA => 'OPERA';

  @override
  String get metroStationMOHAMED_NAGUIB => 'MOHAMED NAGUIB';

  @override
  String get metroStationATABA => 'ATABA';

  @override
  String get metroStationMASARA => 'MASARA';

  @override
  String get metroStationROUD_EL_FARAG => 'ROUD EL-FARAG';

  @override
  String get metroStationSAINT_TERESA => 'SAINT TERESA';

  @override
  String get metroStationKHALAFAWEY => 'KHALAFAWEY';

  @override
  String get metroStationMEZALLAT => 'MEZALLAT';

  @override
  String get metroStationKOLLEYET_EL_ZERA3A => 'KOLLEYET EL-ZERA3A';

  @override
  String get metroStationSHOUBRA_EL_KHEIMA => 'SHOUBRA EL-KHEIMA';

  @override
  String get metroStationADLY_MANSOUR => 'ADLY MANSOUR';

  @override
  String get metroStationEL_HAYKSTEP => 'EL-HAYKSTEP';

  @override
  String get metroStationOMAR_IBN_EL_KHATTAB => 'OMAR IBN EL-KHATTAB';

  @override
  String get metroStationQOBA => 'QOBA';

  @override
  String get metroStationHESHAM_BARAKAT => 'HESHAM BARAKAT';

  @override
  String get metroStationEL_NOZHA => 'EL-NOZHA';

  @override
  String get metroStationNADI_EL_SHAMS => 'NADI EL-SHAMS';

  @override
  String get metroStationALF_MASKAN => 'ALF MASKAN';

  @override
  String get metroStationHELIOPOLIS => 'HELIOPOLIS';

  @override
  String get metroStationHAROUN => 'HAROUN';

  @override
  String get metroStationEL_AHRAM => 'EL-AHRAM';

  @override
  String get metroStationKOLLEYET_EL_BANAT => 'KOLLEYET EL-BANAT';

  @override
  String get metroStationEL_ESTAD => 'EL-ESTAD';

  @override
  String get metroStationARD_EL_MAARD => 'ARD EL-MAARD';

  @override
  String get metroStationABASIA => 'ABASIA';

  @override
  String get metroStationABDO_BASHA => 'ABDO BASHA';

  @override
  String get metroStationEL_GEISH => 'EL-GEISH';

  @override
  String get metroStationBAB_EL_SHARIA => 'BAB EL-SHARIA';

  @override
  String get metroStationMASPERO => 'MASPERO';

  @override
  String get metroStationSAFAA_HEGAZI => 'SAFAA HEGAZI';

  @override
  String get metroStationKIT_KAT => 'KIT KAT';

  @override
  String get metroStationSUDAN => 'SUDAN';

  @override
  String get metroStationIMBABA => 'IMBABA';

  @override
  String get metroStationEL_BOHY => 'EL-BOHY';

  @override
  String get metroStationEL_QAWMEYA => 'EL-QAWMEYA';

  @override
  String get metroStationEL_TARIQ_EL_DAIRY => 'EL-TARIQ EL-DAIRY';

  @override
  String get metroStationROD_EL_FARAG_AXIS => 'ROD EL-FARAG AXIS';

  @override
  String get metroStationEL_TOUFIQIA => 'EL-TOUFIQIA';

  @override
  String get metroStationWADI_EL_NIL => 'WADI EL-NIL';

  @override
  String get metroStationGAMAET_EL_DOWL_EL_ARABIA => 'GAMAET EL-DOWL EL-ARABIA';

  @override
  String get metroStationBOLAK_EL_DAKROUR => 'BOLAK EL-DAKROUR';

  @override
  String get en_metroStationADLY_MANSOUR => 'ADLY MANSOUR';

  @override
  String get en_metroStationEL_HAYKSTEP => 'EL-HAYKSTEP';

  @override
  String get en_metroStationOMAR_IBN_EL_KHATTAB => 'OMAR IBN EL-KHATTAB';

  @override
  String get en_metroStationQOBA => 'QOBA';

  @override
  String get en_metroStationHESHAM_BARAKAT => 'HESHAM BARAKAT';

  @override
  String get en_metroStationEL_NOZHA => 'EL-NOZHA';

  @override
  String get en_metroStationNADI_EL_SHAMS => 'NADI EL-SHAMS';

  @override
  String get en_metroStationALF_MASKAN => 'ALF MASKAN';

  @override
  String get en_metroStationHELIOPOLIS => 'HELIOPOLIS';

  @override
  String get en_metroStationHAROUN => 'HAROUN';

  @override
  String get en_metroStationEL_AHRAM => 'EL-AHRAM';

  @override
  String get en_metroStationKOLLEYET_EL_BANAT => 'KOLLEYET EL-BANAT';

  @override
  String get en_metroStationEL_ESTAD => 'EL-ESTAD';

  @override
  String get en_metroStationARD_EL_MAARD => 'ARD EL-MAARD';

  @override
  String get en_metroStationABASIA => 'ABASIA';

  @override
  String get en_metroStationABDO_BASHA => 'ABDO BASHA';

  @override
  String get en_metroStationEL_GEISH => 'EL-GEISH';

  @override
  String get en_metroStationBAB_EL_SHARIA => 'BAB EL-SHARIA';

  @override
  String get en_metroStationATABA => 'ATABA';

  @override
  String get en_metroStationGAMAL_ABD_EL_NASSER => 'GAMAL ABD EL-NASSER';

  @override
  String get en_metroStationMASPERO => 'MASPERO';

  @override
  String get en_metroStationSAFAA_HEGAZI => 'SAFAA HEGAZI';

  @override
  String get en_metroStationKIT_KAT => 'KIT KAT';

  @override
  String get en_metroStationSUDAN => 'SUDAN';

  @override
  String get en_metroStationIMBABA => 'IMBABA';

  @override
  String get en_metroStationEL_BOHY => 'EL-BOHY';

  @override
  String get en_metroStationEL_QAWMEYA => 'EL-QAWMEYA';

  @override
  String get en_metroStationEL_TARIQ_EL_DAIRY => 'EL-TARIQ EL-DAIRY';

  @override
  String get en_metroStationROD_EL_FARAG_AXIS => 'ROD EL-FARAG AXIS';

  @override
  String get en_metroStationEL_TOUFIQIA => 'EL-TOUFIQIA';

  @override
  String get en_metroStationWADI_EL_NIL => 'WADI EL-NIL';

  @override
  String get en_metroStationGAMAET_EL_DOWL_EL_ARABIA => 'GAMAET EL-DOWL EL-ARABIA';

  @override
  String get en_metroStationBOLAK_EL_DAKROUR => 'BOLAK EL-DAKROUR';

  @override
  String get en_metroStationCAIRO_UNIVERSITY => 'CAIRO UNIVERSITY';

  @override
  String get appTitle => 'カイロ地下鉄ガイド';

  @override
  String get welcomeTitle => '地下鉄の旅を計画しよう';

  @override
  String get welcomeSubtitle => '最適なルート、最寄り駅、地下鉄情報';

  @override
  String get planYourRoute => 'ルートを計画';

  @override
  String get findNearestStation => '最寄り駅を探す';

  @override
  String get scheduleLabel => '地下鉄時刻表';

  @override
  String get metroMapLabel => '地下鉄路線図';

  @override
  String get appInfoTitle => 'カイロ地下鉄ガイドについて';

  @override
  String get appInfoDescription => 'カイロの地下鉄システムの公式ガイド。ルート、駅、時刻表など。';

  @override
  String get close => '閉じる';

  @override
  String get languageSwitchTitle => '言語を変更';

  @override
  String get routeOptions => 'ルートオプション';

  @override
  String get fastestRoute => '最速ルート';

  @override
  String get shortestRoute => '最短ルート';

  @override
  String get fewestTransfers => '乗り換え最少';

  @override
  String get estimatedTime => '所要時間';

  @override
  String get estimatedFare => '運賃の目安';

  @override
  String stationsCount(Object count) {
    return '$count駅';
  }

  @override
  String get minutesAbbr => '分';

  @override
  String get exitDialogTitle => 'アプリを終了しますか？';

  @override
  String get exitDialogSubtitle => 'カイロ地下鉄ナビゲーターを\n終了してよろしいですか？';

  @override
  String get exitDialogStay => '残る';

  @override
  String get exitDialogExit => '終了';

  @override
  String get egpCurrency => 'EGP';

  @override
  String get departureTime => '出発';

  @override
  String get arrivalTime => '到着';

  @override
  String get transferStations => '乗り換え：';

  @override
  String get noInternetTitle => 'インターネット接続なし';

  @override
  String get noInternetMessage => 'オフライン時は一部機能が使えない場合があります';

  @override
  String get tryAgain => '再試行';

  @override
  String get offlineMode => 'オフラインモード';

  @override
  String lastUpdated(Object date) {
    return '最終更新：$date';
  }

  @override
  String get searchHistory => '検索履歴';

  @override
  String get clearHistory => '履歴を消去';

  @override
  String get noHistory => '検索履歴がありません';

  @override
  String get favorites => 'お気に入り';

  @override
  String get addToFavorites => 'お気に入りに追加';

  @override
  String get removeFromFavorites => 'お気に入りから削除';

  @override
  String get shareRoute => 'ルートを共有';

  @override
  String get amenitiesTitle => '駅の設備';

  @override
  String get accessibility => 'アクセシビリティ';

  @override
  String get parking => '駐車場';

  @override
  String get toilets => 'トイレ';

  @override
  String get atm => 'ATM';

  @override
  String get refresh => '更新';

  @override
  String get loading => '読み込み中...';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String get retry => '再試行';

  @override
  String get noResults => '結果が見つかりません';

  @override
  String get allLines => '全路線';

  @override
  String get line1 => '1号線';

  @override
  String get line2 => '2号線';

  @override
  String get line3 => '3号線';

  @override
  String get line4 => '4号線';

  @override
  String get operatingHours => '運行時間';

  @override
  String get firstTrain => '始発';

  @override
  String get lastTrain => '終電';

  @override
  String get peakHours => 'ラッシュ時';

  @override
  String get offPeakHours => 'オフピーク時';

  @override
  String get weekdays => '平日';

  @override
  String get weekend => '週末';

  @override
  String get holidays => '祝日';

  @override
  String get specialSchedule => '特別ダイヤ';

  @override
  String get alerts => '運行情報';

  @override
  String get noAlerts => '現在の運行情報はありません';

  @override
  String get viewAllStations => '全駅を表示';

  @override
  String get nearbyStations => '近くの駅';

  @override
  String distanceAway(Object distance) {
    return '${distance}km先';
  }

  @override
  String walkingTime(Object minutes) {
    return '徒歩$minutes分';
  }

  @override
  String get metroEtiquette => '地下鉄のマナー';

  @override
  String get safetyTips => '安全のヒント';

  @override
  String get feedback => 'フィードバックを送る';

  @override
  String get rateApp => 'アプリを評価';

  @override
  String get settings => '設定';

  @override
  String get notifications => '通知';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get language => '言語';

  @override
  String get recentTripsLabel => '最近の旅程';

  @override
  String get favoritesLabel => 'お気に入り';

  @override
  String get metroLinesTitle => '地下鉄路線';

  @override
  String get line1Name => '1号線';

  @override
  String get line2Name => '2号線';

  @override
  String get line3Name => '3号線';

  @override
  String get line4Name => '4号線';

  @override
  String get stationsLabel => '駅';

  @override
  String get comingSoonLabel => '近日開通';

  @override
  String get viewFullMap => '全路線図を表示';

  @override
  String get routeAllStops => '全停車駅';

  @override
  String get nearestStationFound => '最寄り駅が見つかりました';

  @override
  String nextTrainIn(int min) {
    return '次の電車まで約$min分';
  }

  @override
  String get outsideServiceHours => '運行時間外';

  @override
  String get saveRouteLabel => 'ルートを保存';

  @override
  String get routeSaved => 'お気に入りに保存しました';

  @override
  String get routeUnsaved => 'お気に入りから削除しました';

  @override
  String get nearestStationTitle => '最寄りの地下鉄駅';

  @override
  String get nearestStationSubtitle => 'タップして最寄り駅を検索';

  @override
  String get nearestStationLocating => '最寄り駅を検索中…';

  @override
  String get nearestStationCaption => 'あなたの場所に最も近い地下鉄駅';

  @override
  String get stationFound => '駅が見つかりました';

  @override
  String get accessibilityLabel => 'アクセシビリティ';

  @override
  String get seeAll => '全て見る';

  @override
  String get allMetroLines => '全地下鉄路線';

  @override
  String get aroundStationsTitle => '駅周辺';

  @override
  String get station => '駅';

  @override
  String get seeFacilities => '設備を見る';

  @override
  String get subscriptionInfoTitle => '定期券情報';

  @override
  String get subscriptionInfoSubtitle => '運賃、エリア、購入場所について';

  @override
  String get facilitiesTitle => '駅の設備';

  @override
  String get parkingTitle => '駐車場';

  @override
  String get parkingDescription => '駐車場の有無';

  @override
  String get toiletsTitle => 'トイレ';

  @override
  String get toiletsDescription => '公共トイレの有無';

  @override
  String get elevatorsTitle => 'エレベーター';

  @override
  String get elevatorsDescription => 'バリアフリーエレベーター';

  @override
  String get shopsTitle => 'ショップ';

  @override
  String get shopsDescription => 'コンビニや売店';

  @override
  String get available => '利用可能';

  @override
  String get notAvailable => '利用不可';

  @override
  String get nearbyAttractions => '近くの観光スポット';

  @override
  String get attraction1 => 'エジプト考古学博物館';

  @override
  String get attraction2 => 'ハン・エル＝ハリーリ';

  @override
  String get attraction3 => 'タハリール広場';

  @override
  String get attractionDescription => 'カイロで最も有名な観光スポットの一つ、この駅から簡単にアクセスできます';

  @override
  String get minutes => '分';

  @override
  String get walkingDistance => '徒歩距離';

  @override
  String get accessibilityInfoTitle => 'アクセシビリティ機能';

  @override
  String get wheelchairTitle => '車椅子対応';

  @override
  String get wheelchairDescription => '全駅に車椅子アクセスポイントがあります';

  @override
  String get hearingImpairmentTitle => '聴覚障害者対応';

  @override
  String get hearingImpairmentDescription => '聴覚障害者向けの視覚インジケーターが利用可能';

  @override
  String get subscriptionTypes => '定期券の種類';

  @override
  String get dailyPass => '1日券';

  @override
  String get dailyPassDescription => '全路線1日乗り放題';

  @override
  String get weeklyPass => '週間券';

  @override
  String get weeklyPassDescription => '全路線7日間乗り放題';

  @override
  String get monthlyPass => '月間券';

  @override
  String get monthlyPassDescription => '全路線30日間乗り放題';

  @override
  String get purchaseNow => '今すぐ購入';

  @override
  String get zonesTitle => '運賃ゾーン';

  @override
  String get zonesDescription => 'カイロ地下鉄は運賃ゾーンに分かれています。料金は通過するゾーン数により異なります。';

  @override
  String get whereToBuyTitle => '購入場所';

  @override
  String get metroStations => '地下鉄駅';

  @override
  String get metroStationsDescription => '全駅の窓口で購入可能';

  @override
  String get authorizedVendors => '認定販売業者';

  @override
  String get authorizedVendorsDescription => '駅近くの厳選されたキオスクと店舗';

  @override
  String get touristGuideTitle => '観光ガイド';

  @override
  String get popularDestinations => '人気スポット';

  @override
  String get pyramidsTitle => 'ピラミッド';

  @override
  String get pyramidsDescription => '古代世界の7不思議で唯一現存する建造物';

  @override
  String get egyptianMuseumTitle => 'エジプト考古学博物館';

  @override
  String get egyptianMuseumDescription => '世界最大のファラオの古物コレクション';

  @override
  String get khanElKhaliliTitle => 'ハン・エル＝ハリーリ';

  @override
  String get khanElKhaliliDescription => '1382年に遡る歴史的な市場';

  @override
  String get essentialPhrases => '基本アラビア語フレーズ';

  @override
  String get phrase1 => '切符はいくらですか？';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => '地下鉄の駅はどこですか？';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => 'これは...行きですか？';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => '旅行のヒント';

  @override
  String get peakHoursTitle => 'ラッシュ時';

  @override
  String get peakHoursDescription => '混雑を避けるには7〜9時と15〜18時を避けてください';

  @override
  String get safetyTitle => '安全';

  @override
  String get safetyDescription => '貴重品を安全に保管し、周囲に注意してください';

  @override
  String get ticketsTitle => '乗車券';

  @override
  String get ticketsDescription => '改札を出るまで切符を保管してください';

  @override
  String get lengthLabel => '距離';

  @override
  String get viewDetails => '詳細を見る';

  @override
  String get whereToBuyDescription => '乗車券の購入、ICカードのチャージ、定期券の購入';

  @override
  String get ticketsBullet1 => '全駅の窓口で購入可能';

  @override
  String get ticketsBullet2 => '自動券売機（Haroun駅〜Adly Mansour駅）';

  @override
  String get ticketsBullet3 => '種類：一般、高齢者、障害者';

  @override
  String get walletCardTitle => 'ICカード';

  @override
  String get walletBullet1 => '窓口・自動券売機（Haroun〜Adly Mansour）';

  @override
  String get walletBullet2 => 'カード代：80LE（初回最低40LEチャージ）';

  @override
  String get walletBullet3 => 'チャージ範囲：20LE〜400LE';

  @override
  String get walletBullet4 => '繰り返し使用・譲渡可能';

  @override
  String get walletBullet5 => '都度券より時間節約';

  @override
  String get seasonalCardTitle => '定期券';

  @override
  String get seasonalBullet1 => '対象：一般、学生、高齢者（60歳以上）、障害者';

  @override
  String get requirementsTitle => '必要書類：';

  @override
  String get seasonalBullet2 => 'Attaba、Abbasia、HelopolisまたはAdly Mansourの定期券窓口へ';

  @override
  String get seasonalBullet3 => '写真2枚（4×6サイズ）';

  @override
  String get additionalRequirementsTitle => '追加要件：';

  @override
  String get studentReq => '学生：学校印鑑の書類＋身分証/出生証明書＋支払い証明';

  @override
  String get elderlyReq => '高齢者：年齢を証明する有効な身分証';

  @override
  String get specialNeedsReq => '障害者：障害を証明する公的証明書';

  @override
  String get learnMore => 'もっと見る';

  @override
  String get stationDetailsTitle => '駅の詳細';

  @override
  String get stationMapTitle => '駅構内図';

  @override
  String get allOperationalLabel => '全路線運行中';

  @override
  String get statusLiveLabel => 'リアルタイム';

  @override
  String get homepageSubtitle => '地下鉄・LRT旅行のスマートガイド';

  @override
  String get greetingMorning => 'おはようございます';

  @override
  String get greetingAfternoon => 'こんにちは';

  @override
  String get greetingEvening => 'こんばんは';

  @override
  String get greetingNight => 'おやすみなさい';

  @override
  String get planYourRouteSubtitle => '駅間の最速ルートを見つける';

  @override
  String get recentSearchesLabel => '最近の検索';

  @override
  String get googleMapsLinkDetected => 'Googleマップのリンクを検出';

  @override
  String get pickFromMapLabel => '地図から選択';

  @override
  String get quickActionsTitle => 'クイックアクション';

  @override
  String get tapToLocateLabel => '最寄り駅を探すためにタップ';

  @override
  String get touristHighlightsLabel => '観光スポット';

  @override
  String get viewPlansLabel => '定期券プランを見る';

  @override
  String get lrtLineName => 'LRT路線';

  @override
  String get exploreAreaTitle => '周辺を探索';

  @override
  String get exploreAreaSubtitle => '地下鉄駅周辺の観光スポットを発見';

  @override
  String get tapToExploreLabel => '探索するために駅をタップ';

  @override
  String get promoMonthlyTitle => '月間券';

  @override
  String get promoMonthlySubtitle => '30日間乗り放題';

  @override
  String get promoMonthlyTag => 'お得';

  @override
  String get promoStudentTitle => '学生券';

  @override
  String get promoStudentSubtitle => '学生50%割引';

  @override
  String get promoStudentTag => '学生';

  @override
  String get promoFamilyTitle => '家族券';

  @override
  String get promoFamilySubtitle => '一緒に旅して節約';

  @override
  String get promoFamilyTag => '家族';

  @override
  String get buyNowLabel => '今すぐ購入';

  @override
  String get locateMeLabel => '現在地取得中';

  @override
  String get locationServicesDisabled => '位置情報サービスが無効です。設定から有効にしてください。';

  @override
  String get locationPermissionDenied => '位置情報の権限が拒否されました。アプリ設定から許可してください。';

  @override
  String get locationError => '現在地を取得できませんでした。再試行してください。';

  @override
  String get leaveNowLabel => '今すぐ出発';

  @override
  String get cairoMetroNetworkLabel => 'カイロ地下鉄ネットワーク';

  @override
  String get resetViewLabel => '表示をリセット';

  @override
  String get mapLegendLabel => '地図の凡例';

  @override
  String get searchStationsHint => '駅を検索...';

  @override
  String get noStationsFound => '駅が見つかりません';

  @override
  String get line1FullName => '1号線 — Helwan / New El-Marg';

  @override
  String get line2FullName => '2号線 — Shubra El-Kheima / El-Mounib';

  @override
  String get line3FullName => '3号線 — Adly Mansour / Kit Kat';

  @override
  String get line4FullName => '4号線';

  @override
  String get monorailEastName => '東部モノレール';

  @override
  String get monorailWestName => '西部モノレール';

  @override
  String get allLinesStationsLabel => '駅';

  @override
  String get underConstructionLabel => '建設中';

  @override
  String get plannedLabel => '計画中';

  @override
  String get transferLabel => '乗り換え';

  @override
  String get statusMaintenanceLabel => 'メンテナンス';

  @override
  String get statusDisruptionLabel => '運行障害';

  @override
  String get crowdCalmLabel => '空いている';

  @override
  String get crowdModerateLabel => '普通';

  @override
  String get crowdBusyLabel => '混雑';

  @override
  String get locationDialogNoThanks => '結構です';

  @override
  String get locationDialogTurnOn => 'オンにする';

  @override
  String get locationDialogOpenSettings => '設定を開く';

  @override
  String get touristGuidePlacesCount => '件の探索スポット';

  @override
  String get touristGuideDisclaimer => '時間、距離、詳細は概算であり、変動する場合があります。訪問前に公式に確認してください。';

  @override
  String get touristGuideSearchHint => 'スポットや駅を検索...';

  @override
  String get touristGuideCategoryAll => 'すべて';

  @override
  String get touristGuideNoPlaces => 'スポットが見つかりません';

  @override
  String get touristGuideNoPlacesSub => '別の検索またはカテゴリを試してください';

  @override
  String get photographyTitle => '写真撮影';

  @override
  String get photographyDescription => '地下鉄駅内での撮影は禁止されています。一部の観光地ではカメラ料金が発生する場合があります。';

  @override
  String get bestTimeTitle => '訪問に最適な時期';

  @override
  String get bestTimeDescription => '10月から4月が最も気候が良いです。屋外スポットは早朝または夕方遅くに訪れましょう。';

  @override
  String get phrase4 => 'ありがとう';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => 'いくら？';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => '...はどこですか？';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => '...に行きたい';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => '遠いですか？';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => 'ルートを計画';

  @override
  String get lineLabel => '線';

  @override
  String get categoryHistorical => '歴史的';

  @override
  String get categoryMuseum => '博物館';

  @override
  String get categoryReligious => '宗教的';

  @override
  String get categoryPark => '公園';

  @override
  String get categoryShopping => 'ショッピング';

  @override
  String get categoryCulture => '文化';

  @override
  String get categoryNile => 'ナイル川';

  @override
  String get categoryHiddenGem => '隠れた名所';

  @override
  String get facilityCommercial => '商業';

  @override
  String get facilityCultural => '文化';

  @override
  String get facilityEducational => '教育';

  @override
  String get facilityLandmarks => 'ランドマーク';

  @override
  String get facilityMedical => '医療';

  @override
  String get facilityPublicInstitutions => '公共機関';

  @override
  String get facilityPublicSpaces => '公共スペース';

  @override
  String get facilityReligious => '宗教';

  @override
  String get facilityServices => 'サービス';

  @override
  String get facilitySportFacilities => 'スポーツ施設';

  @override
  String get facilityStreets => '街路';

  @override
  String get facilitySearchHint => '場所を検索...';

  @override
  String get facilityNoData => 'この駅の施設データはまだありません';

  @override
  String get facilityDataSoon => 'データは近日追加予定です';

  @override
  String get facilityClearFilter => 'フィルターをクリア';

  @override
  String get facilityPlacesCount => '件';

  @override
  String get facilityZoomHint => 'ピンチしてドラッグしてズーム';

  @override
  String get facilityCategoriesLabel => 'カテゴリ';

  @override
  String get sortBy => '並べ替え';

  @override
  String get sortStops => '停車駅';

  @override
  String get sortTime => '時間';

  @override
  String get sortFare => '運賃';

  @override
  String get sortLines => '路線';

  @override
  String get bestRoute => '最良';

  @override
  String get hideStops => '駅を非表示';

  @override
  String get showLabel => '表示';

  @override
  String get stopsWord => '駅';

  @override
  String get minuteShort => '分';

  @override
  String get detectingLocation => '現在地を検出中...';

  @override
  String get tapToExplore => 'タップして探索';

  @override
  String get couldNotOpenMaps => 'Googleマップを開けませんでした';

  @override
  String get couldNotGetLocation => '現在地を取得できませんでした。位置情報の許可を確認してください。';

  @override
  String get googleMapsLabel => 'Google マップ';

  @override
  String get couldNotFindNearestStation => '最寄り駅が見つかりませんでした';

  @override
  String get zoomLabel => 'ズーム';

  @override
  String transferAtStation(Object station) {
    return '$stationで乗り換え';
  }

  @override
  String get discoverEgyptTitle => 'エジプトを探索';

  @override
  String get discoverEgyptSubtitle => 'カイロ以外の都市・観光地';

  @override
  String get gettingThereTitle => 'カイロからのアクセス';

  @override
  String get transportNote => 'カイロからの所要時間（目安）';

  @override
  String get bookTicketsTitle => 'チケットを予約';

  @override
  String get thingsToDoTitle => 'おすすめスポット';

  @override
  String get transportFlight => '飛行機';

  @override
  String get transportSleeperTrain => '寝台列車';

  @override
  String get transportTrain => '電車';

  @override
  String get transportBus => 'バス';

  @override
  String get transportCar => 'プライベートカー';

  @override
  String get transportNileCruise => 'ナイルクルーズ（ルクソール発）';

  @override
  String get transportBusFromSharm => 'シャルム・エル・シェイクからバス';

  @override
  String get getOnPlayStore => 'Android';

  @override
  String get getOnAppStore => 'iOS';

  @override
  String get onboardingLanguagePrompt => '言語を選択';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingTitle1 => 'ルートを計画';

  @override
  String get onboardingSubtitle1 => 'カイロのネットワークで任意の2駅間の最速地下鉄ルートを検索。';

  @override
  String get onboardingTitle2 => '路線を探索';

  @override
  String get onboardingSubtitle2 => '3本の地下鉄路線と便利な乗り換え駅を為になれ。';

  @override
  String get onboardingTitle3 => 'スマート機能';

  @override
  String get onboardingSubtitle3 => '最寻駅を検索し、観光スポットを探索し、バリアフリールートを取得。';

  @override
  String get onboardingGetStarted => '始める';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingLine1 => '1号線';

  @override
  String get onboardingLine2 => '2号線';

  @override
  String get onboardingLine3 => '3号線';

  @override
  String get onboardingTransfer => '乗り換え';

  @override
  String get accessibleRoute => 'バリアフリールート';

  @override
  String get onboardingReplay => 'チュートリアルを再生';

  @override
  String get mapViewSchematic => '路線図';

  @override
  String get mapViewGeographic => '地理図';

  @override
  String get walkingDirections => '徒歩';

  @override
  String get getDirections => 'ナビゲーション';

  @override
  String get currentLocation => '現在地';

  @override
  String get drivingDirections => '車';

  @override
  String get useAsDeparture => '出発地に設定';

  @override
  String get searchingOnline => 'オンライン検索中…';

  @override
  String get didYouMean => 'もしかして？';

  @override
  String get routeTypeFastest => '最速';

  @override
  String get routeTypeAccessible => 'バリアフリー';

  @override
  String get routeTypeFewestTransfers => '乗り換え最少';

  @override
  String get routeTypeAlternative => '代替ルート';

  @override
  String get transferExitCarriage => '車両を降りる';

  @override
  String get transferFollowSigns => '标識に従う';

  @override
  String get transferCheckDirection => 'ホームの方向を確認';

  @override
  String get transferBoardTrain => '列車に乗る';

  @override
  String get transferWalkCorridor => '通路を歩く';

  @override
  String get transferNoRevalidate => '切符の再打小不要';

  @override
  String get transferCheckBranch => '支線方向を確認';

  @override
  String get transferExitSurface => '地上に出る';

  @override
  String get transferNoteSadat => 'サダト: L1 ↔ L2 — ホーム間得筙3分。';

  @override
  String get transferNoteElShohadaa => 'エル・シュハダ: L1 ↔ L2 — 約3分。';

  @override
  String get transferNoteGamalNasser => 'ガマール・アブド・エル・ナスル: L1 ↔ L3 — 約5分。';

  @override
  String get transferNoteAtaba => 'アタバ: L2 ↔ L3 — 約4分。';

  @override
  String get transferNoteKitKat => 'キットカット: L3分岐点 — 約2分。';

  @override
  String get transferNoteCairoUniversity => 'カイロ大学: L2 ↔ L3B — 約5分。';
}
