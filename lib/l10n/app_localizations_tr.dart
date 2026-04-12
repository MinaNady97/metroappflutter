// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get locale => 'tr';

  @override
  String get departureStationTitle => 'Kalkış İstasyonu';

  @override
  String get arrivalStationTitle => 'Varış İstasyonu';

  @override
  String get departureStationHint => 'Kalkış istasyonunu seçin';

  @override
  String get arrivalStationHint => 'Varış istasyonunu seçin';

  @override
  String get destinationFieldLabel => 'Hedefi girin';

  @override
  String get findButtonText => 'Bul';

  @override
  String get showRoutesButtonText => 'Güzergahları Göster';

  @override
  String get pleaseSelectDeparture => 'Lütfen kalkış istasyonunu seçin.';

  @override
  String get pleaseSelectArrival => 'Lütfen varış istasyonunu seçin.';

  @override
  String get selectDifferentStations => 'Lütfen farklı istasyonlar seçin.';

  @override
  String get nearestStationLabel => 'En Yakın İstasyon';

  @override
  String get addressNotFound => 'Adres bulunamadı. Lütfen daha fazla ayrıntı ile deneyin.';

  @override
  String get invalidDataFormat => 'Geçersiz veri formatı';

  @override
  String get routeToNearest => 'En Yakına Güzergah';

  @override
  String get routeToDestination => 'Hedefe Güzergah';

  @override
  String get pleaseClickOnMyLocation => 'Lütfen önce konum düğmesine tıklayın';

  @override
  String get mustTypeADestination => 'Önce bir hedef girin.';

  @override
  String get estimatedTravelTime => 'Tahmini seyahat süresi';

  @override
  String get ticketPrice => 'Bilet Fiyatı';

  @override
  String get noOfStations => 'İstasyon sayısı';

  @override
  String get changeAt => 'Aktarma yapacaksınız';

  @override
  String get totalTravelTime => 'Tahmini toplam seyahat süresi';

  @override
  String get changeTime => 'Hat değişimi için tahmini süre';

  @override
  String get firstTake => 'Birinci bölüm';

  @override
  String get firstDirection => 'Birinci Yön';

  @override
  String get firstDeparture => 'Birinci Kalkış';

  @override
  String get firstArrival => 'Birinci Varış';

  @override
  String get firstIntermediateStations => 'Birinci Ara İstasyonlar';

  @override
  String get secondTake => 'İkinci bölüm';

  @override
  String get secondDirection => 'İkinci Yön';

  @override
  String get secondDeparture => 'İkinci Kalkış';

  @override
  String get secondArrival => 'İkinci Varış';

  @override
  String get secondIntermediateStations => 'İkinci Ara İstasyonlar';

  @override
  String get thirdTake => 'Üçüncü bölüm';

  @override
  String get thirdDirection => 'Üçüncü Yön';

  @override
  String get thirdDeparture => 'Üçüncü Kalkış';

  @override
  String get thirdArrival => 'Üçüncü Varış';

  @override
  String get thirdIntermediateStations => 'Üçüncü Ara İstasyonlar';

  @override
  String get error => 'Hata:';

  @override
  String get mustTypeDestination => 'Önce bir hedef girin.';

  @override
  String get noRoutesFound => 'Güzergah bulunamadı';

  @override
  String get routeDetails => 'Güzergah Detayları';

  @override
  String get departure => 'Kalkış: ';

  @override
  String get arrival => 'Varış: ';

  @override
  String get take => 'Bin: ';

  @override
  String get direction => 'Yön: ';

  @override
  String get intermediateStations => 'Ara İstasyonlar:';

  @override
  String egp(Object price) {
    return '$price EGP';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => 'İstasyonları Göster';

  @override
  String get hideStations => 'İstasyonları Gizle';

  @override
  String get showRoute => 'Güzergahı Göster';

  @override
  String get metro1 => 'Metro Hattı 1';

  @override
  String get metro2 => 'Metro Hattı 2';

  @override
  String get metro3branch1 => 'Metro Hattı 3 Kolu ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => 'Metro Hattı 3 Kolu CAIRO UNIVERSITY';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return '$stationName istasyonuna mesafe $distance metredir';
  }

  @override
  String reachedStation(Object stationName) {
    return '$stationName istasyonuna ulaştınız';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return 'Mevcut istasyon $currentStationName, sonraki istasyon $nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return 'Mevcut istasyon $currentStationName, sonraki $nextStationName, $lineName hattına $direction yönünde aktarma yapacaksınız';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return 'Mevcut istasyon $currentStationName, sonraki $nextStationName varış istasyonunuzdur';
  }

  @override
  String get finalStationReached => 'Varış istasyonuna ulaşıldı, yolculuk tamamlandı';

  @override
  String get exchangeStation => 'Aktarma İstasyonu';

  @override
  String get intermediateStationsTitle => 'Ara İstasyonlar';

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
  String get appTitle => 'Kahire Metro Rehberi';

  @override
  String get welcomeTitle => 'Metro Yolculuğunuzu Planlayın';

  @override
  String get welcomeSubtitle => 'En iyi güzergahlar, en yakın istasyonlar ve metro bilgileri';

  @override
  String get planYourRoute => 'Güzergah Planla';

  @override
  String get findNearestStation => 'Adrese Göre İstasyon Bul';

  @override
  String get scheduleLabel => 'Metro Tarifeleri';

  @override
  String get metroMapLabel => 'Metro Haritası';

  @override
  String get appInfoTitle => 'Kahire Metro Rehberi Hakkında';

  @override
  String get appInfoDescription => 'Kahire Metro sistemi için resmi rehber. Güzergahlar, istasyonlar, tarifeler ve daha fazlası.';

  @override
  String get close => 'Kapat';

  @override
  String get languageSwitchTitle => 'Dil Değiştir';

  @override
  String get routeOptions => 'Güzergah Seçenekleri';

  @override
  String get fastestRoute => 'En Hızlı Güzergah';

  @override
  String get shortestRoute => 'En Kısa Güzergah';

  @override
  String get fewestTransfers => 'En Az Aktarma';

  @override
  String get estimatedTime => 'Tahmini Süre';

  @override
  String get estimatedFare => 'Tahmini Ücret';

  @override
  String stationsCount(Object count) {
    return '$count istasyon';
  }

  @override
  String get minutesAbbr => 'dk';

  @override
  String get exitDialogTitle => 'Uygulamadan Çıkılsın mı?';

  @override
  String get exitDialogSubtitle => 'Kahire Metro Navigasyonu\'ndan\nçıkmak istediğinizden emin misiniz?';

  @override
  String get exitDialogStay => 'Kal';

  @override
  String get exitDialogExit => 'Çık';

  @override
  String get egpCurrency => 'EGP';

  @override
  String get departureTime => 'Kalkış';

  @override
  String get arrivalTime => 'Varış';

  @override
  String get transferStations => 'Aktarma:';

  @override
  String get noInternetTitle => 'İnternet Bağlantısı Yok';

  @override
  String get noInternetMessage => 'Bazı özellikler çevrimdışında kullanılamayabilir';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String get offlineMode => 'Çevrimdışı Mod';

  @override
  String lastUpdated(Object date) {
    return 'Son güncelleme: $date';
  }

  @override
  String get searchHistory => 'Arama Geçmişi';

  @override
  String get clearHistory => 'Geçmişi Temizle';

  @override
  String get noHistory => 'Henüz arama geçmişi yok';

  @override
  String get favorites => 'Favoriler';

  @override
  String get addToFavorites => 'Favorilere Ekle';

  @override
  String get removeFromFavorites => 'Favorilerden Kaldır';

  @override
  String get shareRoute => 'Güzergahı Paylaş';

  @override
  String get amenitiesTitle => 'İstasyon Olanakları';

  @override
  String get accessibility => 'Erişilebilirlik';

  @override
  String get parking => 'Otopark';

  @override
  String get toilets => 'Tuvaletler';

  @override
  String get atm => 'ATM';

  @override
  String get refresh => 'Yenile';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get errorOccurred => 'Bir hata oluştu';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get noResults => 'Sonuç bulunamadı';

  @override
  String get allLines => 'Tüm Hatlar';

  @override
  String get line1 => 'Hat 1';

  @override
  String get line2 => 'Hat 2';

  @override
  String get line3 => 'Hat 3';

  @override
  String get line4 => 'Hat 4';

  @override
  String get operatingHours => 'Çalışma Saatleri';

  @override
  String get firstTrain => 'İlk Tren';

  @override
  String get lastTrain => 'Son Tren';

  @override
  String get peakHours => 'Yoğun Saatler';

  @override
  String get offPeakHours => 'Sakin Saatler';

  @override
  String get weekdays => 'Hafta İçi';

  @override
  String get weekend => 'Hafta Sonu';

  @override
  String get holidays => 'Tatil Günleri';

  @override
  String get specialSchedule => 'Özel Tarife';

  @override
  String get alerts => 'Servis Uyarıları';

  @override
  String get noAlerts => 'Mevcut servis uyarısı yok';

  @override
  String get viewAllStations => 'Tüm İstasyonları Gör';

  @override
  String get nearbyStations => 'Yakın İstasyonlar';

  @override
  String distanceAway(Object distance) {
    return '$distance km uzakta';
  }

  @override
  String walkingTime(Object minutes) {
    return '$minutes dk yürüyüş';
  }

  @override
  String get metroEtiquette => 'Metro Görgü Kuralları';

  @override
  String get safetyTips => 'Güvenlik İpuçları';

  @override
  String get feedback => 'Geri Bildirim Gönder';

  @override
  String get rateApp => 'Uygulamayı Değerlendir';

  @override
  String get settings => 'Ayarlar';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get language => 'Dil';

  @override
  String get recentTripsLabel => 'Son Seyahatler';

  @override
  String get favoritesLabel => 'Favoriler';

  @override
  String get metroLinesTitle => 'Metro Hatları';

  @override
  String get line1Name => 'Hat 1';

  @override
  String get line2Name => 'Hat 2';

  @override
  String get line3Name => 'Hat 3';

  @override
  String get line4Name => 'Hat 4';

  @override
  String get stationsLabel => 'istasyon';

  @override
  String get comingSoonLabel => 'Yakında';

  @override
  String get viewFullMap => 'Tam Haritayı Gör';

  @override
  String get routeAllStops => 'Tüm Duraklar';

  @override
  String get nearestStationFound => 'En Yakın İstasyon Bulundu';
  String nextTrainIn(int min) => 'Sonraki tren ~{min} dk içinde'.replaceAll('{min}', '$min');
  String get outsideServiceHours => 'Hizmet saatleri dışında';
  String get saveRouteLabel => 'Güzergahı kaydet';
  String get routeSaved => 'Favorilere kaydedildi';
  String get routeUnsaved => 'Favorilerden kaldırıldı';
  String get nearestStationTitle => 'Size En Yakın İstasyon';
  String get nearestStationSubtitle => 'GPS ile otomatik tespit edildi';
  String get nearestStationLocating => 'En yakın istasyon aranıyor…';
  String get nearestStationCaption => 'Konumunuza en yakın metro istasyonu';
  String get getDirections => 'Yol tarifi al';
  String get walkingDirections => 'Yürüyerek';
  String get drivingDirections => 'Arabayla';
  String get currentLocation => 'Konumum';
  String get useAsDeparture => 'Kalkış olarak ayarla';

  @override
  String get stationFound => 'İstasyon Bulundu';

  @override
  String get accessibilityLabel => 'Erişilebilirlik';

  @override
  String get seeAll => 'Tümünü Gör';

  @override
  String get allMetroLines => 'Tüm Metro Hatları';

  @override
  String get aroundStationsTitle => 'İstasyonlar Çevresinde';

  @override
  String get station => 'İstasyon';

  @override
  String get seeFacilities => 'Tesisleri Gör';

  @override
  String get subscriptionInfoTitle => 'Metro Aboneliği';

  @override
  String get subscriptionInfoSubtitle => 'Ücretler, bölgeler ve nereden satın alınır';

  @override
  String get facilitiesTitle => 'İstasyon Tesisleri';

  @override
  String get parkingTitle => 'Otopark';

  @override
  String get parkingDescription => 'Otopark imkânı';

  @override
  String get toiletsTitle => 'Tuvaletler';

  @override
  String get toiletsDescription => 'Umumi tuvalet durumu';

  @override
  String get elevatorsTitle => 'Asansörler';

  @override
  String get elevatorsDescription => 'Erişilebilirlik asansörleri';

  @override
  String get shopsTitle => 'Dükkanlar';

  @override
  String get shopsDescription => 'Market ve büfeler';

  @override
  String get available => 'Mevcut';

  @override
  String get notAvailable => 'Mevcut Değil';

  @override
  String get nearbyAttractions => 'Yakın Turistik Yerler';

  @override
  String get attraction1 => 'Mısır Müzesi';

  @override
  String get attraction2 => 'Han El Halili';

  @override
  String get attraction3 => 'Tahrir Meydanı';

  @override
  String get attractionDescription => 'Kahire\'nin en ünlü simge yapılarından biri, bu istasyondan kolayca ulaşılabilir';

  @override
  String get minutes => 'dakika';

  @override
  String get walkingDistance => 'Yürüme mesafesi';

  @override
  String get accessibilityInfoTitle => 'Erişilebilirlik Özellikleri';

  @override
  String get wheelchairTitle => 'Tekerlekli Sandalye Erişimi';

  @override
  String get wheelchairDescription => 'Tüm istasyonlarda tekerlekli sandalye erişim noktaları mevcuttur';

  @override
  String get hearingImpairmentTitle => 'İşitme Engeli';

  @override
  String get hearingImpairmentDescription => 'İşitme engelliler için görsel göstergeler mevcuttur';

  @override
  String get subscriptionTypes => 'Abonelik Türleri';

  @override
  String get dailyPass => 'Günlük Pas';

  @override
  String get dailyPassDescription => 'Tüm hatlarda bir gün sınırsız seyahat';

  @override
  String get weeklyPass => 'Haftalık Pas';

  @override
  String get weeklyPassDescription => 'Tüm hatlarda 7 gün sınırsız seyahat';

  @override
  String get monthlyPass => 'Aylık Pas';

  @override
  String get monthlyPassDescription => 'Tüm hatlarda 30 gün sınırsız seyahat';

  @override
  String get purchaseNow => 'Şimdi Satın Al';

  @override
  String get zonesTitle => 'Ücret Bölgeleri';

  @override
  String get zonesDescription => 'Kahire Metrosu ücret bölgelerine ayrılmıştır. Fiyat geçilen bölge sayısına bağlıdır.';

  @override
  String get whereToBuyTitle => 'Nereden Satın Alınır';

  @override
  String get metroStations => 'Metro İstasyonları';

  @override
  String get metroStationsDescription => 'Tüm istasyonlardaki bilet gişelerinde mevcuttur';

  @override
  String get authorizedVendors => 'Yetkili Satıcılar';

  @override
  String get authorizedVendorsDescription => 'İstasyon yakınındaki seçilmiş büfeler ve mağazalar';

  @override
  String get touristGuideTitle => 'Turist Rehberi';

  @override
  String get popularDestinations => 'Popüler Destinasyonlar';

  @override
  String get pyramidsTitle => 'Piramitler';

  @override
  String get pyramidsDescription => 'Antik dünyanın son kalan harikası';

  @override
  String get egyptianMuseumTitle => 'Mısır Müzesi';

  @override
  String get egyptianMuseumDescription => 'Dünyanın en büyük Firavun eserler koleksiyonuna ev sahipliği yapar';

  @override
  String get khanElKhaliliTitle => 'Khan El Khalili';

  @override
  String get khanElKhaliliDescription => '1382\'ye dayanan tarihi çarşı';

  @override
  String get essentialPhrases => 'Temel Arapça İfadeler';

  @override
  String get phrase1 => 'Bilet kaç para?';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => 'Metro istasyonu nerede?';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => 'Bu ... \'a gidiyor mu?';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => 'Seyahat İpuçları';

  @override
  String get peakHoursTitle => 'Yoğun Saatler';

  @override
  String get peakHoursDescription => 'Daha az kalabalık trenler için sabah 7-9 ve öğleden sonra 3-6\'dan kaçının';

  @override
  String get safetyTitle => 'Güvenlik';

  @override
  String get safetyDescription => 'Değerli eşyalarınızı güvende tutun ve çevrenize dikkat edin';

  @override
  String get ticketsTitle => 'Biletler';

  @override
  String get ticketsDescription => 'İstasyondan çıkana kadar biletinizi saklayın';

  @override
  String get lengthLabel => 'Uzunluk';

  @override
  String get viewDetails => 'Detayları Gör';

  @override
  String get whereToBuyDescription => 'Bilet alın, cüzdan kartı doldurun veya sezonluk kart aboneliği yapın';

  @override
  String get ticketsBullet1 => 'Tüm gişelerde mevcuttur';

  @override
  String get ticketsBullet2 => 'Otomat biletleri (Haroun\'dan Adly Mansour\'a kadar)';

  @override
  String get ticketsBullet3 => 'Türler: Genel, Yaşlı, Özel İhtiyaç';

  @override
  String get walletCardTitle => 'Cüzdan Kartı';

  @override
  String get walletBullet1 => 'Gişe ve otomatlarda mevcuttur (Haroun\'dan Adly Mansour\'a)';

  @override
  String get walletBullet2 => 'Kart ücreti: 80 LE (ilk alımda minimum 40 LE yükleme)';

  @override
  String get walletBullet3 => 'Yükleme aralığı: 20 LE - 400 LE';

  @override
  String get walletBullet4 => 'Tekrar kullanılabilir ve devredilebilir';

  @override
  String get walletBullet5 => 'Tek biletlere göre zaman tasarrufu sağlar';

  @override
  String get seasonalCardTitle => 'Sezonluk Kart';

  @override
  String get seasonalBullet1 => 'Şunlar için: Genel Halk, Öğrenciler, Yaşlılar (60+), Özel İhtiyaç';

  @override
  String get requirementsTitle => 'Gereksinimler:';

  @override
  String get seasonalBullet2 => 'Attaba, Abbasia, Heliopolis veya Adly Mansour\'daki abonelik ofislerini ziyaret edin';

  @override
  String get seasonalBullet3 => '2 fotoğraf sağlayın (4x6 format)';

  @override
  String get additionalRequirementsTitle => 'Ek gereksinimler:';

  @override
  String get studentReq => 'Öğrenciler: Okul mühürlü form + kimlik/nüfus cüzdanı + ödeme makbuzu';

  @override
  String get elderlyReq => 'Yaşlılar: Yaşı belgeleyen geçerli kimlik';

  @override
  String get specialNeedsReq => 'Özel İhtiyaç: Durumu belgeleyen resmi kimlik';

  @override
  String get learnMore => 'Daha Fazla Bilgi';

  @override
  String get stationDetailsTitle => 'İstasyon Detayları';

  @override
  String get stationMapTitle => 'İstasyon Haritası';

  @override
  String get allOperationalLabel => 'Tüm hatlar aktif';

  @override
  String get statusLiveLabel => 'Canlı';

  @override
  String get homepageSubtitle => 'Metro ve LRT seyahatleri için akıllı rehberiniz';

  @override
  String get greetingMorning => 'Günaydın';

  @override
  String get greetingAfternoon => 'İyi öğleden sonralar';

  @override
  String get greetingEvening => 'İyi akşamlar';

  @override
  String get greetingNight => 'İyi geceler';

  @override
  String get planYourRouteSubtitle => 'İstasyonlar arasında en hızlı güzergahı bulun';

  @override
  String get recentSearchesLabel => 'Son Aramalar';

  @override
  String get googleMapsLinkDetected => 'Google Haritalar bağlantısı algılandı';

  @override
  String get pickFromMapLabel => 'Haritadan Seç';

  @override
  String get quickActionsTitle => 'Hızlı İşlemler';

  @override
  String get tapToLocateLabel => 'En yakın istasyonu bulmak için dokun';

  @override
  String get touristHighlightsLabel => 'Turistik Öne Çıkanlar';

  @override
  String get viewPlansLabel => 'Abonelik planlarını gör';

  @override
  String get lrtLineName => 'LRT Hattı';

  @override
  String get exploreAreaTitle => 'Bölgeyi Keşfet';

  @override
  String get exploreAreaSubtitle => 'Metro istasyonları çevresindeki yerleri keşfedin';

  @override
  String get tapToExploreLabel => 'Keşfetmek için istasyona dokun';

  @override
  String get promoMonthlyTitle => 'Aylık Pas';

  @override
  String get promoMonthlySubtitle => '30 gün sınırsız seyahat';

  @override
  String get promoMonthlyTag => 'En İyi Değer';

  @override
  String get promoStudentTitle => 'Öğrenci Pası';

  @override
  String get promoStudentSubtitle => 'Öğrencilere %50 indirim';

  @override
  String get promoStudentTag => 'Öğrenci';

  @override
  String get promoFamilyTitle => 'Aile Pası';

  @override
  String get promoFamilySubtitle => 'Birlikte seyahat edin, daha fazla tasarruf edin';

  @override
  String get promoFamilyTag => 'Aile';

  @override
  String get buyNowLabel => 'Şimdi Al';

  @override
  String get locateMeLabel => 'Konumlanıyor';

  @override
  String get locationServicesDisabled => 'Konum servisleri devre dışı. Lütfen Ayarlar\'dan etkinleştirin.';

  @override
  String get locationPermissionDenied => 'Konum izni reddedildi. Lütfen uygulama ayarlarından izin verin.';

  @override
  String get locationError => 'Konumunuz alınamadı. Lütfen tekrar deneyin.';

  @override
  String get leaveNowLabel => 'Şimdi Ayrıl';

  @override
  String get cairoMetroNetworkLabel => 'Kahire Metro Ağı';

  @override
  String get resetViewLabel => 'Görünümü Sıfırla';

  @override
  String get mapViewSchematic => 'Şematik';

  @override
  String get mapViewGeographic => 'Harita';

  @override
  String get mapLegendLabel => 'Harita Açıklaması';

  @override
  String get searchStationsHint => 'İstasyon ara...';

  @override
  String get noStationsFound => 'İstasyon bulunamadı';

  @override
  String get line1FullName => 'Hat 1 — Helwan / New El-Marg';

  @override
  String get line2FullName => 'Hat 2 — Shubra El-Kheima / El-Mounib';

  @override
  String get line3FullName => 'Hat 3 — Adly Mansour / Kit Kat';

  @override
  String get line4FullName => 'Hat 4';

  @override
  String get monorailEastName => 'Doğu Monorayı';

  @override
  String get monorailWestName => 'Batı Monorayı';

  @override
  String get allLinesStationsLabel => 'istasyon';

  @override
  String get underConstructionLabel => 'Yapım Aşamasında';

  @override
  String get plannedLabel => 'Planlandı';

  @override
  String get transferLabel => 'Aktarma';

  @override
  String get statusMaintenanceLabel => 'Bakım';

  @override
  String get statusDisruptionLabel => 'Kesinti';

  @override
  String get crowdCalmLabel => 'Sakin';

  @override
  String get crowdModerateLabel => 'Orta';

  @override
  String get crowdBusyLabel => 'Kalabalık';

  @override
  String get locationDialogNoThanks => 'Hayır teşekkürler';

  @override
  String get locationDialogTurnOn => 'Aç';

  @override
  String get locationDialogOpenSettings => 'Ayarları Aç';

  @override
  String get touristGuidePlacesCount => 'keşfedilecek yer';

  @override
  String get touristGuideDisclaimer => 'Süreler, mesafeler ve ayrıntılar yaklaşık olup değişebilir. Lütfen ziyaretten önce resmi olarak doğrulayın.';

  @override
  String get touristGuideSearchHint => 'Yer veya istasyon ara...';

  @override
  String get touristGuideCategoryAll => 'Tümü';

  @override
  String get touristGuideNoPlaces => 'Yer bulunamadı';

  @override
  String get touristGuideNoPlacesSub => 'Farklı bir arama veya kategori deneyin';

  @override
  String get photographyTitle => 'Fotoğrafçılık';

  @override
  String get photographyDescription => 'Metro istasyonlarının içinde fotoğraf çekmek yasaktır. Bazı turistik yerlerde kamera ücreti alınabilir.';

  @override
  String get bestTimeTitle => 'Ziyaret İçin En İyi Zaman';

  @override
  String get bestTimeDescription => 'Ekim\'den Nisan\'a kadar en iyi hava koşulları yaşanır. Açık hava alanlarını sabahın erken saatlerinde veya öğleden sonra geç saatlerde ziyaret edin.';

  @override
  String get phrase4 => 'Teşekkürler';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => 'Ne kadar?';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => '...nerede?';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => '...ya gitmek istiyorum';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => 'Uzak mı?';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => 'Rota planla';

  @override
  String get lineLabel => 'Hat';

  @override
  String get categoryHistorical => 'Tarihi';

  @override
  String get categoryMuseum => 'Müzeler';

  @override
  String get categoryReligious => 'Dini';

  @override
  String get categoryPark => 'Parklar';

  @override
  String get categoryShopping => 'Alışveriş';

  @override
  String get categoryCulture => 'Kültür';

  @override
  String get categoryNile => 'Nil';

  @override
  String get categoryHiddenGem => 'Gizli Hazineler';

  @override
  String get facilityCommercial => 'Ticari';

  @override
  String get facilityCultural => 'Kültürel';

  @override
  String get facilityEducational => 'Eğitim';

  @override
  String get facilityLandmarks => 'Tarihi Yerler';

  @override
  String get facilityMedical => 'Tıbbi';

  @override
  String get facilityPublicInstitutions => 'Kamu Kurumları';

  @override
  String get facilityPublicSpaces => 'Kamusal Alanlar';

  @override
  String get facilityReligious => 'Dini';

  @override
  String get facilityServices => 'Hizmetler';

  @override
  String get facilitySportFacilities => 'Spor Tesisleri';

  @override
  String get facilityStreets => 'Sokaklar';

  @override
  String get facilitySearchHint => 'Yer ara...';

  @override
  String get facilityNoData => 'Bu istasyon için henüz tesis verisi mevcut değil';

  @override
  String get facilityDataSoon => 'Veriler yakında eklenecek';

  @override
  String get facilityClearFilter => 'Filtreyi temizle';

  @override
  String get facilityPlacesCount => 'yer';

  @override
  String get facilityZoomHint => 'Yakınlaştırmak için sıkıştırın ve sürükleyin';

  @override
  String get facilityCategoriesLabel => 'kategori';

  @override
  String get sortBy => 'Sırala';

  @override
  String get sortStops => 'Duraklar';

  @override
  String get sortTime => 'Süre';

  @override
  String get sortFare => 'Ücret';

  @override
  String get sortLines => 'Hatlar';

  @override
  String get bestRoute => 'En İyi';

  @override
  String get accessibleRoute => 'Erişilebilir Rota';

  @override
  String get routeTypeFastest => 'En Hızlı';

  @override
  String get routeTypeAccessible => 'Erişilebilir';

  @override
  String get routeTypeFewestTransfers => 'En Az Aktarma';

  @override
  String get routeTypeAlternative => 'Alternatif Güzergah';

  @override
  String get hideStops => 'Durakları gizle';

  @override
  String get showLabel => 'Göster';

  @override
  String get stopsWord => 'durak';

  @override
  String get minuteShort => 'dk';

  @override
  String get detectingLocation => 'Konumunuz tespit ediliyor...';

  @override
  String get tapToExplore => 'Keşfetmek için dokunun';

  @override
  String get couldNotOpenMaps => 'Google Haritalar açılamadı';

  @override
  String get couldNotGetLocation => 'Konumunuz alınamadı. Konum iznini kontrol edin.';

  @override
  String get googleMapsLabel => 'Google Haritalar';

  @override
  String get couldNotFindNearestStation => 'En yakın istasyon bulunamadı';

  @override
  String get zoomLabel => 'Yakınlaştır';

  @override
  String transferAtStation(Object station) {
    return '$station istasyonunda aktarma';
  }

  @override String get onboardingSkip => 'Geç';
  @override String get onboardingNext => 'İleri';
  @override String get onboardingGetStarted => 'Başla';
  @override String get onboardingTitle1 => 'Rotanı Planla';
  @override String get onboardingSubtitle1 => 'Kalkış ve varış istasyonunu seç — saniyeler içinde aktarma, süre ve ücretle en hızlı yolu buluruz.';
  @override String get onboardingTitle2 => 'Hatları Tanı';
  @override String get onboardingSubtitle2 => 'Kahire\'nin tamamını kaplayan 3 renkli hat. Daire simgeler aktarma istasyonlarını gösterir.';
  @override String get onboardingTitle3 => 'Her Şey Bir Arada';
  @override String get onboardingSubtitle3 => 'En yakın istasyonu bul, canlı haritayı keşfet ve her durağın çevresindeki yerleri keşfet.';
  @override String get onboardingLanguagePrompt => 'Dil seçin';
  @override String get onboardingReplay => 'Turu tekrarla';
  @override String get onboardingLine1 => 'Hat 1 · Helvan → Yeni El-Merc';
  @override String get onboardingLine2 => 'Hat 2 · El-Munib → Şubra';
  @override String get onboardingLine3 => 'Hat 3 · Adli Mansur → kollar';
  @override String get onboardingTransfer => 'Aktarma istasyonu';

  @override String get transferExitCarriage => 'Exit the carriage and head to the center of the platform';
  @override String get transferFollowSigns => "Follow the 'Transfer' signs inside the station";
  @override String get transferWalkCorridor => 'Walk through the underground transfer corridor';
  @override String get transferCheckDirection => 'Check the direction board before boarding';
  @override String get transferBoardTrain => 'Board the next train in your direction';
  @override String get transferNoRevalidate => 'No re-validation needed — same paid zone';
  @override String get transferCheckBranch => 'Check the branch display — trains split here for different destinations';
  @override String get transferExitSurface => 'Use the stairs or escalator to reach street level';
  @override String get transferNoteSadat => 'Sadat connects Line 1 & Line 2 beneath Tahrir Square. Platforms are on separate perpendicular levels';
  @override String get transferNoteElShohadaa => "El Shohadaa (Ramses Sq.) connects Line 1 & Line 2 — one of Cairo's busiest interchange stations";
  @override String get transferNoteGamalNasser => 'Gamal Abd El Nasser connects Line 1 and Line 3 via an underground passage (~200 m)';
  @override String get transferNoteAtaba => 'Ataba connects Line 2 and Line 3 — follow the connecting corridor between platforms';
  @override String get transferNoteKitKat => 'Kit Kat is the L3 junction — trains split here. Check the branch display for Rod El-Farag or Cairo University';
  @override String get transferNoteCairoUniversity => 'Cairo University connects Line 2 and the L3B branch at street level — a short surface walk is needed';

  @override String get searchingOnline => 'Çevrimiçi aranıyor…';
  @override String get didYouMean => 'Bunu mu demek istediniz?';
  @override String get tapForTransferDetails => 'Aktarma detayları için dokunun';
}