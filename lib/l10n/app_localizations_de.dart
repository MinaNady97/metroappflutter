// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get locale => 'de';

  @override
  String get departureStationTitle => 'Abfahrtsbahnhof';

  @override
  String get arrivalStationTitle => 'Ankunftsbahnhof';

  @override
  String get departureStationHint => 'Abfahrtsbahnhof auswählen';

  @override
  String get arrivalStationHint => 'Ankunftsbahnhof auswählen';

  @override
  String get destinationFieldLabel => 'Ziel eingeben';

  @override
  String get findButtonText => 'Suchen';

  @override
  String get showRoutesButtonText => 'Routen anzeigen';

  @override
  String get pleaseSelectDeparture => 'Bitte Abfahrtsbahnhof auswählen.';

  @override
  String get pleaseSelectArrival => 'Bitte Ankunftsbahnhof auswählen.';

  @override
  String get selectDifferentStations => 'Bitte verschiedene Bahnhöfe auswählen.';

  @override
  String get nearestStationLabel => 'Nächste Station';

  @override
  String get addressNotFound => 'Adresse nicht gefunden. Bitte mit mehr Details versuchen.';

  @override
  String get invalidDataFormat => 'Ungültiges Datenformat';

  @override
  String get routeToNearest => 'Route zur nächsten Station';

  @override
  String get routeToDestination => 'Route zum Ziel';

  @override
  String get pleaseClickOnMyLocation => 'Bitte zuerst auf die Standort-Schaltfläche klicken';

  @override
  String get mustTypeADestination => 'Bitte zuerst ein Ziel eingeben.';

  @override
  String get estimatedTravelTime => 'Geschätzte Reisezeit';

  @override
  String get ticketPrice => 'Ticketpreis';

  @override
  String get noOfStations => 'Anzahl der Stationen';

  @override
  String get changeAt => 'Umsteigen bei';

  @override
  String get totalTravelTime => 'Geschätzte Gesamtreisezeit';

  @override
  String get changeTime => 'Geschätzte Reisezeit für Linienumsteig';

  @override
  String get firstTake => 'Erster Abschnitt';

  @override
  String get firstDirection => 'Erste Richtung';

  @override
  String get firstDeparture => 'Erste Abfahrt';

  @override
  String get firstArrival => 'Erste Ankunft';

  @override
  String get firstIntermediateStations => 'Erste Zwischenstationen';

  @override
  String get secondTake => 'Zweiter Abschnitt';

  @override
  String get secondDirection => 'Zweite Richtung';

  @override
  String get secondDeparture => 'Zweite Abfahrt';

  @override
  String get secondArrival => 'Zweite Ankunft';

  @override
  String get secondIntermediateStations => 'Zweite Zwischenstationen';

  @override
  String get thirdTake => 'Dritter Abschnitt';

  @override
  String get thirdDirection => 'Dritte Richtung';

  @override
  String get thirdDeparture => 'Dritte Abfahrt';

  @override
  String get thirdArrival => 'Dritte Ankunft';

  @override
  String get thirdIntermediateStations => 'Dritte Zwischenstationen';

  @override
  String get error => 'Fehler:';

  @override
  String get mustTypeDestination => 'Bitte zuerst ein Ziel eingeben.';

  @override
  String get noRoutesFound => 'Keine Routen gefunden';

  @override
  String get routeDetails => 'Routendetails';

  @override
  String get departure => 'Abfahrt: ';

  @override
  String get arrival => 'Ankunft: ';

  @override
  String get take => 'Nehmen: ';

  @override
  String get direction => 'Richtung: ';

  @override
  String get intermediateStations => 'Zwischenstationen:';

  @override
  String egp(Object price) {
    return '$price EGP';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => 'Stationen anzeigen';

  @override
  String get hideStations => 'Stationen ausblenden';

  @override
  String get showRoute => 'Route anzeigen';

  @override
  String get metro1 => 'U-Bahn Linie 1';

  @override
  String get metro2 => 'U-Bahn Linie 2';

  @override
  String get metro3branch1 => 'U-Bahn Linie 3 Zweig ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => 'U-Bahn Linie 3 Zweig CAIRO UNIVERSITY';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return 'Die Entfernung zu $stationName beträgt $distance Meter';
  }

  @override
  String reachedStation(Object stationName) {
    return 'Sie haben $stationName erreicht';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return 'Aktuelle Station ist $currentStationName und nächste Station ist $nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return 'Aktuelle Station ist $currentStationName und nächste Station ist $nextStationName, Sie wechseln zu $lineName Richtung $direction';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return 'Aktuelle Station ist $currentStationName und nächste Station ist $nextStationName, das ist Ihre Ankunftsstation';
  }

  @override
  String get finalStationReached => 'Ankunftsstation erreicht, Fahrt abgeschlossen';

  @override
  String get exchangeStation => 'Umsteigestation';

  @override
  String get intermediateStationsTitle => 'Zwischenstationen';

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
  String get appTitle => 'Kairo Metro Guide';

  @override
  String get welcomeTitle => 'Ihre Metro-Reise planen';

  @override
  String get welcomeSubtitle => 'Beste Routen, nächste Stationen und Metro-Informationen';

  @override
  String get planYourRoute => 'Route planen';

  @override
  String get findNearestStation => 'Nächste Station finden';

  @override
  String get scheduleLabel => 'Metro-Fahrplan';

  @override
  String get metroMapLabel => 'Metro-Karte';

  @override
  String get appInfoTitle => 'Über Kairo Metro Guide';

  @override
  String get appInfoDescription => 'Der offizielle Führer für das Kairoer U-Bahn-System. Routen, Stationen, Fahrpläne und mehr.';

  @override
  String get close => 'Schließen';

  @override
  String get languageSwitchTitle => 'Sprache ändern';

  @override
  String get routeOptions => 'Routenoptionen';

  @override
  String get fastestRoute => 'Schnellste Route';

  @override
  String get shortestRoute => 'Kürzeste Route';

  @override
  String get fewestTransfers => 'Wenigste Umstiege';

  @override
  String get estimatedTime => 'Geschätzte Zeit';

  @override
  String get estimatedFare => 'Geschätzter Fahrpreis';

  @override
  String stationsCount(Object count) {
    return '$count Stationen';
  }

  @override
  String get minutesAbbr => 'Min';

  @override
  String get exitDialogTitle => 'App verlassen?';

  @override
  String get exitDialogSubtitle => 'Möchten Sie den\nKairo Metro Navigator wirklich verlassen?';

  @override
  String get exitDialogStay => 'Bleiben';

  @override
  String get exitDialogExit => 'Verlassen';

  @override
  String get egpCurrency => 'EGP';

  @override
  String get departureTime => 'Abfahrt';

  @override
  String get arrivalTime => 'Ankunft';

  @override
  String get transferStations => 'Umsteigen bei:';

  @override
  String get noInternetTitle => 'Keine Internetverbindung';

  @override
  String get noInternetMessage => 'Einige Funktionen sind möglicherweise offline nicht verfügbar';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get offlineMode => 'Offline-Modus';

  @override
  String lastUpdated(Object date) {
    return 'Zuletzt aktualisiert: $date';
  }

  @override
  String get searchHistory => 'Suchverlauf';

  @override
  String get clearHistory => 'Verlauf löschen';

  @override
  String get noHistory => 'Noch kein Suchverlauf';

  @override
  String get favorites => 'Favoriten';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get shareRoute => 'Route teilen';

  @override
  String get amenitiesTitle => 'Bahnhofseinrichtungen';

  @override
  String get accessibility => 'Barrierefreiheit';

  @override
  String get parking => 'Parkplatz';

  @override
  String get toilets => 'Toiletten';

  @override
  String get atm => 'Geldautomat';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get loading => 'Laden...';

  @override
  String get errorOccurred => 'Ein Fehler ist aufgetreten';

  @override
  String get retry => 'Wiederholen';

  @override
  String get noResults => 'Keine Ergebnisse gefunden';

  @override
  String get allLines => 'Alle Linien';

  @override
  String get line1 => 'Linie 1';

  @override
  String get line2 => 'Linie 2';

  @override
  String get line3 => 'Linie 3';

  @override
  String get line4 => 'Linie 4';

  @override
  String get operatingHours => 'Betriebszeiten';

  @override
  String get firstTrain => 'Erster Zug';

  @override
  String get lastTrain => 'Letzter Zug';

  @override
  String get peakHours => 'Stoßzeiten';

  @override
  String get offPeakHours => 'Nebenzeiten';

  @override
  String get weekdays => 'Wochentage';

  @override
  String get weekend => 'Wochenende';

  @override
  String get holidays => 'Feiertage';

  @override
  String get specialSchedule => 'Sonderfahrplan';

  @override
  String get alerts => 'Betriebsmeldungen';

  @override
  String get noAlerts => 'Keine aktuellen Betriebsmeldungen';

  @override
  String get viewAllStations => 'Alle Stationen anzeigen';

  @override
  String get nearbyStations => 'Nahegelegene Stationen';

  @override
  String distanceAway(Object distance) {
    return '$distance km entfernt';
  }

  @override
  String walkingTime(Object minutes) {
    return '$minutes Min Fußweg';
  }

  @override
  String get metroEtiquette => 'U-Bahn-Etikette';

  @override
  String get safetyTips => 'Sicherheitstipps';

  @override
  String get feedback => 'Feedback senden';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get settings => 'Einstellungen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get language => 'Sprache';

  @override
  String get recentTripsLabel => 'Letzte Fahrten';

  @override
  String get favoritesLabel => 'Favoriten';

  @override
  String get metroLinesTitle => 'Metro-Linien';

  @override
  String get line1Name => 'Linie 1';

  @override
  String get line2Name => 'Linie 2';

  @override
  String get line3Name => 'Linie 3';

  @override
  String get line4Name => 'Linie 4';

  @override
  String get stationsLabel => 'Stationen';

  @override
  String get comingSoonLabel => 'Demnächst';

  @override
  String get viewFullMap => 'Vollständige Karte anzeigen';

  @override
  String get nearestStationFound => 'Nächste Station gefunden';

  @override
  String get stationFound => 'Station gefunden';

  @override
  String get accessibilityLabel => 'Barrierefreiheit';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get allMetroLines => 'Alle Metro-Linien';

  @override
  String get aroundStationsTitle => 'Rund um die Stationen';

  @override
  String get station => 'Station';

  @override
  String get seeFacilities => 'Einrichtungen anzeigen';

  @override
  String get subscriptionInfoTitle => 'Metro-Abonnement';

  @override
  String get subscriptionInfoSubtitle => 'Über Tarife, Zonen und Kaufmöglichkeiten';

  @override
  String get facilitiesTitle => 'Bahnhofseinrichtungen';

  @override
  String get parkingTitle => 'Parkplatz';

  @override
  String get parkingDescription => 'Verfügbarkeit von Parkmöglichkeiten';

  @override
  String get toiletsTitle => 'Toiletten';

  @override
  String get toiletsDescription => 'Verfügbarkeit öffentlicher Toiletten';

  @override
  String get elevatorsTitle => 'Aufzüge';

  @override
  String get elevatorsDescription => 'Barrierefreie Aufzüge';

  @override
  String get shopsTitle => 'Geschäfte';

  @override
  String get shopsDescription => 'Kioske und kleine Läden';

  @override
  String get available => 'Verfügbar';

  @override
  String get notAvailable => 'Nicht verfügbar';

  @override
  String get nearbyAttractions => 'Nahegelegene Sehenswürdigkeiten';

  @override
  String get attraction1 => 'Ägyptisches Museum';

  @override
  String get attraction2 => 'Khan El Khalili';

  @override
  String get attraction3 => 'Tahrir-Platz';

  @override
  String get attractionDescription => 'Eines der bekanntesten Wahrzeichen Kairos, leicht von dieser Station erreichbar';

  @override
  String get minutes => 'Minuten';

  @override
  String get walkingDistance => 'Fußweg';

  @override
  String get accessibilityInfoTitle => 'Barrierefreiheit';

  @override
  String get wheelchairTitle => 'Rollstuhlzugang';

  @override
  String get wheelchairDescription => 'Alle Stationen haben Rollstuhlzugangspunkte';

  @override
  String get hearingImpairmentTitle => 'Hörbehinderung';

  @override
  String get hearingImpairmentDescription => 'Visuelle Anzeigen für Hörgeschädigte verfügbar';

  @override
  String get subscriptionTypes => 'Abonnement-Typen';

  @override
  String get dailyPass => 'Tagesticket';

  @override
  String get dailyPassDescription => 'Unbegrenzte Fahrten für einen Tag auf allen Linien';

  @override
  String get weeklyPass => 'Wochenticket';

  @override
  String get weeklyPassDescription => 'Unbegrenzte Fahrten für 7 Tage auf allen Linien';

  @override
  String get monthlyPass => 'Monatsticket';

  @override
  String get monthlyPassDescription => 'Unbegrenzte Fahrten für 30 Tage auf allen Linien';

  @override
  String get purchaseNow => 'Jetzt kaufen';

  @override
  String get zonesTitle => 'Tarifzonen';

  @override
  String get zonesDescription => 'Die Kairoer Metro ist in Tarifzonen unterteilt. Der Preis hängt von der Anzahl der Zonen ab.';

  @override
  String get whereToBuyTitle => 'Wo kaufen';

  @override
  String get metroStations => 'Metro-Stationen';

  @override
  String get metroStationsDescription => 'An Fahrkartenschaltern aller Stationen erhältlich';

  @override
  String get authorizedVendors => 'Autorisierte Händler';

  @override
  String get authorizedVendorsDescription => 'Ausgewählte Kioske und Läden in der Nähe von Stationen';

  @override
  String get touristGuideTitle => 'Touristenführer';

  @override
  String get popularDestinations => 'Beliebte Ziele';

  @override
  String get pyramidsTitle => 'Die Pyramiden';

  @override
  String get pyramidsDescription => 'Das letzte verbleibende Weltwunder der Antike';

  @override
  String get egyptianMuseumTitle => 'Ägyptisches Museum';

  @override
  String get egyptianMuseumDescription => 'Beherbergt die weltgrößte Sammlung pharaonischer Altertümer';

  @override
  String get khanElKhaliliTitle => 'Khan El Khalili';

  @override
  String get khanElKhaliliDescription => 'Historischer Markt aus dem Jahr 1382';

  @override
  String get essentialPhrases => 'Grundlegende arabische Phrasen';

  @override
  String get phrase1 => 'Wie viel kostet das Ticket?';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => 'Wo ist die U-Bahn-Station?';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => 'Fährt das nach...?';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => 'Reisetipps';

  @override
  String get peakHoursTitle => 'Stoßzeiten';

  @override
  String get peakHoursDescription => 'Vermeiden Sie 7-9 Uhr und 15-18 Uhr für weniger volle Züge';

  @override
  String get safetyTitle => 'Sicherheit';

  @override
  String get safetyDescription => 'Wertsachen sichern und die Umgebung im Blick behalten';

  @override
  String get ticketsTitle => 'Tickets';

  @override
  String get ticketsDescription => 'Behalten Sie Ihr Ticket bis Sie die Station verlassen';

  @override
  String get lengthLabel => 'Länge';

  @override
  String get viewDetails => 'Details anzeigen';

  @override
  String get whereToBuyDescription => 'Tickets kaufen, Wallet-Karte aufladen oder Saisonkarten abonnieren';

  @override
  String get ticketsBullet1 => 'An allen Fahrkartenschaltern erhältlich';

  @override
  String get ticketsBullet2 => 'Öffentliche Tickets an Automaten (Haroun bis Adly Mansour)';

  @override
  String get ticketsBullet3 => 'Typen: Öffentlich, Senioren, Sonderbedarf';

  @override
  String get walletCardTitle => 'Wallet-Karte';

  @override
  String get walletBullet1 => 'An allen Fahrkartenschaltern und Automaten (Haroun bis Adly Mansour)';

  @override
  String get walletBullet2 => 'Kartenkosten: 80 LE (mindestens 40 LE Aufladung beim ersten Kauf)';

  @override
  String get walletBullet3 => 'Aufladungsbereich: 20 LE bis 400 LE';

  @override
  String get walletBullet4 => 'Wiederverwendbar und übertragbar';

  @override
  String get walletBullet5 => 'Spart Zeit gegenüber Einzeltickets';

  @override
  String get seasonalCardTitle => 'Saisonkarte';

  @override
  String get seasonalBullet1 => 'Für: Allgemeine Öffentlichkeit, Studenten, Senioren (60+), Sonderbedarf';

  @override
  String get requirementsTitle => 'Anforderungen:';

  @override
  String get seasonalBullet2 => 'Abonnementbüros in Attaba, Abbasia, Heliopolis oder Adly Mansour besuchen';

  @override
  String get seasonalBullet3 => '2 Fotos (4x6 Format) mitbringen';

  @override
  String get additionalRequirementsTitle => 'Zusätzliche Anforderungen:';

  @override
  String get studentReq => 'Studenten: Schulstempel-Formular + Ausweis/Geburtsurkunde + Zahlungsbeleg';

  @override
  String get elderlyReq => 'Senioren: Gültiger Ausweis mit Altersnachweis';

  @override
  String get specialNeedsReq => 'Sonderbedarf: Staatlich ausgestellter Nachweis';

  @override
  String get learnMore => 'Mehr erfahren';

  @override
  String get stationDetailsTitle => 'Stationsdetails';

  @override
  String get stationMapTitle => 'Stationsplan';

  @override
  String get allOperationalLabel => 'Alle Linien in Betrieb';

  @override
  String get statusLiveLabel => 'Live';

  @override
  String get homepageSubtitle => 'Ihr smarter Guide für Metro- und LRT-Fahrten';

  @override
  String get greetingMorning => 'Guten Morgen';

  @override
  String get greetingAfternoon => 'Guten Nachmittag';

  @override
  String get greetingEvening => 'Guten Abend';

  @override
  String get greetingNight => 'Gute Nacht';

  @override
  String get planYourRouteSubtitle => 'Schnellste Route zwischen Stationen finden';

  @override
  String get recentSearchesLabel => 'Letzte Suchen';

  @override
  String get googleMapsLinkDetected => 'Google Maps-Link erkannt';

  @override
  String get pickFromMapLabel => 'Aus Karte wählen';

  @override
  String get quickActionsTitle => 'Schnellaktionen';

  @override
  String get tapToLocateLabel => 'Tippen, um nächste Station zu finden';

  @override
  String get touristHighlightsLabel => 'Touristische Highlights';

  @override
  String get viewPlansLabel => 'Abonnementpläne anzeigen';

  @override
  String get lrtLineName => 'LRT-Linie';

  @override
  String get exploreAreaTitle => 'Umgebung erkunden';

  @override
  String get exploreAreaSubtitle => 'Nahegelegene Orte rund um Metro-Stationen entdecken';

  @override
  String get tapToExploreLabel => 'Station antippen zum Erkunden';

  @override
  String get promoMonthlyTitle => 'Monatsticket';

  @override
  String get promoMonthlySubtitle => 'Unbegrenzte Fahrten für 30 Tage';

  @override
  String get promoMonthlyTag => 'Bestes Angebot';

  @override
  String get promoStudentTitle => 'Studententicket';

  @override
  String get promoStudentSubtitle => '50% Rabatt für Studenten';

  @override
  String get promoStudentTag => 'Student';

  @override
  String get promoFamilyTitle => 'Familienticket';

  @override
  String get promoFamilySubtitle => 'Gemeinsam reisen, mehr sparen';

  @override
  String get promoFamilyTag => 'Familie';

  @override
  String get buyNowLabel => 'Jetzt kaufen';

  @override
  String get locateMeLabel => 'Wird geortet';

  @override
  String get locationServicesDisabled => 'Standortdienste sind deaktiviert. Bitte in den Einstellungen aktivieren.';

  @override
  String get locationPermissionDenied => 'Standortberechtigung verweigert. Bitte in den App-Einstellungen erlauben.';

  @override
  String get locationError => 'Standort konnte nicht ermittelt werden. Bitte erneut versuchen.';

  @override
  String get leaveNowLabel => 'Jetzt losfahren';

  @override
  String get cairoMetroNetworkLabel => 'Kairoer Metro-Netzwerk';

  @override
  String get resetViewLabel => 'Ansicht zurücksetzen';

  @override
  String get mapLegendLabel => 'Kartenlegende';

  @override
  String get searchStationsHint => 'Stationen suchen...';

  @override
  String get noStationsFound => 'Keine Stationen gefunden';

  @override
  String get line1FullName => 'Linie 1 — Helwan / New El-Marg';

  @override
  String get line2FullName => 'Linie 2 — Shubra El-Kheima / El-Mounib';

  @override
  String get line3FullName => 'Linie 3 — Adly Mansour / Kit Kat';

  @override
  String get line4FullName => 'Linie 4';

  @override
  String get monorailEastName => 'Ost-Monorail';

  @override
  String get monorailWestName => 'West-Monorail';

  @override
  String get allLinesStationsLabel => 'Stationen';

  @override
  String get underConstructionLabel => 'Im Bau';

  @override
  String get plannedLabel => 'Geplant';

  @override
  String get transferLabel => 'Umstieg';

  @override
  String get statusMaintenanceLabel => 'Wartung';

  @override
  String get statusDisruptionLabel => 'Störung';

  @override
  String get crowdCalmLabel => 'Ruhig';

  @override
  String get crowdModerateLabel => 'Mäßig';

  @override
  String get crowdBusyLabel => 'Voll';

  @override
  String get locationDialogNoThanks => 'Nein danke';

  @override
  String get locationDialogTurnOn => 'Einschalten';

  @override
  String get locationDialogOpenSettings => 'Einstellungen öffnen';

  @override
  String get touristGuidePlacesCount => 'Orte zum Erkunden';

  @override
  String get touristGuideDisclaimer => 'Zeiten, Entfernungen und Details sind ungefähr und können variieren. Bitte vor dem Besuch offiziell überprüfen.';

  @override
  String get touristGuideSearchHint => 'Orte oder Stationen suchen...';

  @override
  String get touristGuideCategoryAll => 'Alle';

  @override
  String get touristGuideNoPlaces => 'Keine Orte gefunden';

  @override
  String get touristGuideNoPlacesSub => 'Versuchen Sie eine andere Suche oder Kategorie';

  @override
  String get photographyTitle => 'Fotografie';

  @override
  String get photographyDescription => 'Fotografieren ist in U-Bahn-Stationen nicht erlaubt. Einige Sehenswürdigkeiten erheben möglicherweise Kameragebühren.';

  @override
  String get bestTimeTitle => 'Beste Reisezeit';

  @override
  String get bestTimeDescription => 'Von Oktober bis April bietet das beste Wetter. Besuchen Sie Outdoor-Standorte früh morgens oder am späten Nachmittag.';

  @override
  String get phrase4 => 'Danke';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => 'Wie viel?';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => 'Wo ist...?';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => 'Ich möchte nach... gehen';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => 'Ist es weit?';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => 'Route planen';

  @override
  String get lineLabel => 'Linie';

  @override
  String get categoryHistorical => 'Historisch';

  @override
  String get categoryMuseum => 'Museen';

  @override
  String get categoryReligious => 'Religiös';

  @override
  String get categoryPark => 'Parks';

  @override
  String get categoryShopping => 'Einkaufen';

  @override
  String get categoryCulture => 'Kultur';

  @override
  String get categoryNile => 'Nil';

  @override
  String get categoryHiddenGem => 'Versteckte Juwelen';

  @override
  String get facilityCommercial => 'Kommerziell';

  @override
  String get facilityCultural => 'Kulturell';

  @override
  String get facilityEducational => 'Bildung';

  @override
  String get facilityLandmarks => 'Sehenswürdigkeiten';

  @override
  String get facilityMedical => 'Medizinisch';

  @override
  String get facilityPublicInstitutions => 'Öffentliche Einrichtungen';

  @override
  String get facilityPublicSpaces => 'Öffentliche Räume';

  @override
  String get facilityReligious => 'Religiös';

  @override
  String get facilityServices => 'Dienstleistungen';

  @override
  String get facilitySportFacilities => 'Sporteinrichtungen';

  @override
  String get facilityStreets => 'Straßen';

  @override
  String get facilitySearchHint => 'Orte suchen...';

  @override
  String get facilityNoData => 'Noch keine Einrichtungsdaten für diese Station verfügbar';

  @override
  String get facilityDataSoon => 'Daten werden bald hinzugefügt';

  @override
  String get facilityClearFilter => 'Filter löschen';

  @override
  String get facilityPlacesCount => 'Orte';

  @override
  String get facilityZoomHint => 'Zum Zoomen zusammendrücken und ziehen';

  @override
  String get facilityCategoriesLabel => 'Kategorien';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortStops => 'Haltestellen';

  @override
  String get sortTime => 'Zeit';

  @override
  String get sortFare => 'Preis';

  @override
  String get sortLines => 'Linien';

  @override
  String get bestRoute => 'Beste';

  @override
  String get hideStops => 'Haltestellen ausblenden';

  @override
  String get showLabel => 'Anzeigen';

  @override
  String get stopsWord => 'Haltestellen';

  @override
  String get minuteShort => 'Min';

  @override
  String get detectingLocation => 'Standort wird ermittelt...';

  @override
  String get tapToExplore => 'Tippen zum Erkunden';

  @override
  String get couldNotOpenMaps => 'Google Maps konnte nicht geöffnet werden';

  @override
  String get couldNotGetLocation => 'Standort konnte nicht ermittelt werden. Überprüfen Sie die Standortberechtigung.';

  @override
  String get googleMapsLabel => 'Google Maps';

  @override
  String get couldNotFindNearestStation => 'Nächste Station konnte nicht gefunden werden';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String transferAtStation(Object station) {
    return 'Umsteigen bei $station';
  }
}
