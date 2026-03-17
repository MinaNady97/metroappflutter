// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get locale => 'it';

  @override
  String get departureStationTitle => 'Stazione di partenza';

  @override
  String get arrivalStationTitle => 'Stazione di arrivo';

  @override
  String get departureStationHint => 'Seleziona la stazione di partenza';

  @override
  String get arrivalStationHint => 'Seleziona la stazione di arrivo';

  @override
  String get destinationFieldLabel => 'Inserisci la destinazione';

  @override
  String get findButtonText => 'Cerca';

  @override
  String get showRoutesButtonText => 'Mostra percorsi';

  @override
  String get pleaseSelectDeparture => 'Seleziona la stazione di partenza.';

  @override
  String get pleaseSelectArrival => 'Seleziona la stazione di arrivo.';

  @override
  String get selectDifferentStations => 'Seleziona stazioni diverse.';

  @override
  String get nearestStationLabel => 'Stazione più vicina';

  @override
  String get addressNotFound => 'Indirizzo non trovato. Riprova con più dettagli.';

  @override
  String get invalidDataFormat => 'Formato dati non valido';

  @override
  String get routeToNearest => 'Percorso alla più vicina';

  @override
  String get routeToDestination => 'Percorso alla destinazione';

  @override
  String get pleaseClickOnMyLocation => 'Clicca prima sul pulsante della posizione';

  @override
  String get mustTypeADestination => 'Inserisci prima una destinazione.';

  @override
  String get estimatedTravelTime => 'Tempo di viaggio stimato';

  @override
  String get ticketPrice => 'Prezzo del biglietto';

  @override
  String get noOfStations => 'Numero di stazioni';

  @override
  String get changeAt => 'Cambio a';

  @override
  String get totalTravelTime => 'Tempo totale stimato';

  @override
  String get changeTime => 'Tempo stimato per il cambio linea';

  @override
  String get firstTake => 'Prima tratta';

  @override
  String get firstDirection => 'Prima direzione';

  @override
  String get firstDeparture => 'Prima partenza';

  @override
  String get firstArrival => 'Primo arrivo';

  @override
  String get firstIntermediateStations => 'Prime stazioni intermedie';

  @override
  String get secondTake => 'Seconda tratta';

  @override
  String get secondDirection => 'Seconda direzione';

  @override
  String get secondDeparture => 'Seconda partenza';

  @override
  String get secondArrival => 'Secondo arrivo';

  @override
  String get secondIntermediateStations => 'Seconde stazioni intermedie';

  @override
  String get thirdTake => 'Terza tratta';

  @override
  String get thirdDirection => 'Terza direzione';

  @override
  String get thirdDeparture => 'Terza partenza';

  @override
  String get thirdArrival => 'Terzo arrivo';

  @override
  String get thirdIntermediateStations => 'Terze stazioni intermedie';

  @override
  String get error => 'Errore:';

  @override
  String get mustTypeDestination => 'Inserisci prima una destinazione.';

  @override
  String get noRoutesFound => 'Nessun percorso trovato';

  @override
  String get routeDetails => 'Dettagli percorso';

  @override
  String get departure => 'Partenza: ';

  @override
  String get arrival => 'Arrivo: ';

  @override
  String get take => 'Prendi: ';

  @override
  String get direction => 'Direzione: ';

  @override
  String get intermediateStations => 'Stazioni intermedie:';

  @override
  String egp(Object price) {
    return '$price EGP';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => 'Mostra stazioni';

  @override
  String get hideStations => 'Nascondi stazioni';

  @override
  String get showRoute => 'Mostra percorso';

  @override
  String get metro1 => 'Linea Metro 1';

  @override
  String get metro2 => 'Linea Metro 2';

  @override
  String get metro3branch1 => 'Linea Metro 3 Ramo ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => 'Linea Metro 3 Ramo CAIRO UNIVERSITY';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return 'La distanza da $stationName è $distance metri';
  }

  @override
  String reachedStation(Object stationName) {
    return 'Sei arrivato a $stationName';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return 'Stazione attuale $currentStationName, prossima stazione $nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return 'Stazione attuale $currentStationName, prossima $nextStationName, cambio a $lineName direzione $direction';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return 'Stazione attuale $currentStationName, prossima $nextStationName è la tua stazione di arrivo';
  }

  @override
  String get finalStationReached => 'Raggiunta la stazione di arrivo, viaggio completato';

  @override
  String get exchangeStation => 'Stazione di cambio';

  @override
  String get intermediateStationsTitle => 'Stazioni intermedie';

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
  String get appTitle => 'Guida Metro Cairo';

  @override
  String get welcomeTitle => 'Pianifica il tuo viaggio in metro';

  @override
  String get welcomeSubtitle => 'I migliori percorsi, le stazioni più vicine e informazioni sulla metro';

  @override
  String get planYourRoute => 'Pianifica il percorso';

  @override
  String get findNearestStation => 'Trova la stazione più vicina';

  @override
  String get scheduleLabel => 'Orari metro';

  @override
  String get metroMapLabel => 'Mappa metro';

  @override
  String get appInfoTitle => 'Informazioni su Guida Metro Cairo';

  @override
  String get appInfoDescription => 'La guida ufficiale della metro del Cairo. Percorsi, stazioni, orari e altro.';

  @override
  String get close => 'Chiudi';

  @override
  String get languageSwitchTitle => 'Cambia lingua';

  @override
  String get routeOptions => 'Opzioni percorso';

  @override
  String get fastestRoute => 'Percorso più veloce';

  @override
  String get shortestRoute => 'Percorso più breve';

  @override
  String get fewestTransfers => 'Meno cambi';

  @override
  String get estimatedTime => 'Tempo stimato';

  @override
  String get estimatedFare => 'Tariffa stimata';

  @override
  String stationsCount(Object count) {
    return '$count stazioni';
  }

  @override
  String get minutesAbbr => 'min';

  @override
  String get exitDialogTitle => 'Uscire dall\'app?';

  @override
  String get exitDialogSubtitle => 'Sei sicuro di voler uscire\nda Cairo Metro Navigator?';

  @override
  String get exitDialogStay => 'Rimani';

  @override
  String get exitDialogExit => 'Esci';

  @override
  String get egpCurrency => 'EGP';

  @override
  String get departureTime => 'Partenza';

  @override
  String get arrivalTime => 'Arrivo';

  @override
  String get transferStations => 'Cambio a:';

  @override
  String get noInternetTitle => 'Nessuna connessione Internet';

  @override
  String get noInternetMessage => 'Alcune funzioni potrebbero non essere disponibili offline';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get offlineMode => 'Modalità offline';

  @override
  String lastUpdated(Object date) {
    return 'Ultimo aggiornamento: $date';
  }

  @override
  String get searchHistory => 'Cronologia ricerche';

  @override
  String get clearHistory => 'Cancella cronologia';

  @override
  String get noHistory => 'Nessuna cronologia di ricerca';

  @override
  String get favorites => 'Preferiti';

  @override
  String get addToFavorites => 'Aggiungi ai preferiti';

  @override
  String get removeFromFavorites => 'Rimuovi dai preferiti';

  @override
  String get shareRoute => 'Condividi percorso';

  @override
  String get amenitiesTitle => 'Servizi della stazione';

  @override
  String get accessibility => 'Accessibilità';

  @override
  String get parking => 'Parcheggio';

  @override
  String get toilets => 'Servizi igienici';

  @override
  String get atm => 'Bancomat';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get loading => 'Caricamento...';

  @override
  String get errorOccurred => 'Si è verificato un errore';

  @override
  String get retry => 'Riprova';

  @override
  String get noResults => 'Nessun risultato trovato';

  @override
  String get allLines => 'Tutte le linee';

  @override
  String get line1 => 'Linea 1';

  @override
  String get line2 => 'Linea 2';

  @override
  String get line3 => 'Linea 3';

  @override
  String get line4 => 'Linea 4';

  @override
  String get operatingHours => 'Orari di servizio';

  @override
  String get firstTrain => 'Primo treno';

  @override
  String get lastTrain => 'Ultimo treno';

  @override
  String get peakHours => 'Ore di punta';

  @override
  String get offPeakHours => 'Ore fuori punta';

  @override
  String get weekdays => 'Giorni feriali';

  @override
  String get weekend => 'Fine settimana';

  @override
  String get holidays => 'Festività';

  @override
  String get specialSchedule => 'Orario speciale';

  @override
  String get alerts => 'Avvisi di servizio';

  @override
  String get noAlerts => 'Nessun avviso di servizio attuale';

  @override
  String get viewAllStations => 'Vedi tutte le stazioni';

  @override
  String get nearbyStations => 'Stazioni vicine';

  @override
  String distanceAway(Object distance) {
    return '$distance km di distanza';
  }

  @override
  String walkingTime(Object minutes) {
    return '$minutes min a piedi';
  }

  @override
  String get metroEtiquette => 'Galateo in metro';

  @override
  String get safetyTips => 'Consigli di sicurezza';

  @override
  String get feedback => 'Invia feedback';

  @override
  String get rateApp => 'Valuta l\'app';

  @override
  String get settings => 'Impostazioni';

  @override
  String get notifications => 'Notifiche';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get language => 'Lingua';

  @override
  String get recentTripsLabel => 'Viaggi recenti';

  @override
  String get favoritesLabel => 'Preferiti';

  @override
  String get metroLinesTitle => 'Linee metro';

  @override
  String get line1Name => 'Linea 1';

  @override
  String get line2Name => 'Linea 2';

  @override
  String get line3Name => 'Linea 3';

  @override
  String get line4Name => 'Linea 4';

  @override
  String get stationsLabel => 'stazioni';

  @override
  String get comingSoonLabel => 'Prossimamente';

  @override
  String get viewFullMap => 'Vedi mappa completa';

  @override
  String get nearestStationFound => 'Stazione più vicina trovata';

  @override
  String get stationFound => 'Stazione trovata';

  @override
  String get accessibilityLabel => 'Accessibilità';

  @override
  String get seeAll => 'Vedi tutto';

  @override
  String get allMetroLines => 'Tutte le linee metro';

  @override
  String get aroundStationsTitle => 'Intorno alle stazioni';

  @override
  String get station => 'Stazione';

  @override
  String get seeFacilities => 'Vedi servizi';

  @override
  String get subscriptionInfoTitle => 'Abbonamento metro';

  @override
  String get subscriptionInfoSubtitle => 'Tariffe, zone e dove acquistare';

  @override
  String get facilitiesTitle => 'Servizi della stazione';

  @override
  String get parkingTitle => 'Parcheggio';

  @override
  String get parkingDescription => 'Disponibilità di parcheggi';

  @override
  String get toiletsTitle => 'Servizi igienici';

  @override
  String get toiletsDescription => 'Disponibilità di bagni pubblici';

  @override
  String get elevatorsTitle => 'Ascensori';

  @override
  String get elevatorsDescription => 'Ascensori per l\'accessibilità';

  @override
  String get shopsTitle => 'Negozi';

  @override
  String get shopsDescription => 'Negozi di convenienza e chioschi';

  @override
  String get available => 'Disponibile';

  @override
  String get notAvailable => 'Non disponibile';

  @override
  String get nearbyAttractions => 'Attrazioni nelle vicinanze';

  @override
  String get attraction1 => 'Museo Egizio';

  @override
  String get attraction2 => 'Khan El Khalili';

  @override
  String get attraction3 => 'Piazza Tahrir';

  @override
  String get attractionDescription => 'Uno dei monumenti più famosi del Cairo, facilmente accessibile da questa stazione';

  @override
  String get minutes => 'minuti';

  @override
  String get walkingDistance => 'Distanza a piedi';

  @override
  String get accessibilityInfoTitle => 'Funzioni di accessibilità';

  @override
  String get wheelchairTitle => 'Accesso in sedia a rotelle';

  @override
  String get wheelchairDescription => 'Tutte le stazioni hanno punti di accesso per sedie a rotelle';

  @override
  String get hearingImpairmentTitle => 'Ipoacusia';

  @override
  String get hearingImpairmentDescription => 'Indicatori visivi disponibili per non udenti';

  @override
  String get subscriptionTypes => 'Tipi di abbonamento';

  @override
  String get dailyPass => 'Giornaliero';

  @override
  String get dailyPassDescription => 'Viaggi illimitati per un giorno su tutte le linee';

  @override
  String get weeklyPass => 'Settimanale';

  @override
  String get weeklyPassDescription => 'Viaggi illimitati per 7 giorni su tutte le linee';

  @override
  String get monthlyPass => 'Mensile';

  @override
  String get monthlyPassDescription => 'Viaggi illimitati per 30 giorni su tutte le linee';

  @override
  String get purchaseNow => 'Acquista ora';

  @override
  String get zonesTitle => 'Zone tariffarie';

  @override
  String get zonesDescription => 'La metro del Cairo è divisa in zone tariffarie. Il prezzo dipende dalle zone attraversate.';

  @override
  String get whereToBuyTitle => 'Dove acquistare';

  @override
  String get metroStations => 'Stazioni metro';

  @override
  String get metroStationsDescription => 'Disponibile negli uffici biglietteria di tutte le stazioni';

  @override
  String get authorizedVendors => 'Rivenditori autorizzati';

  @override
  String get authorizedVendorsDescription => 'Chioschi e negozi selezionati vicino alle stazioni';

  @override
  String get touristGuideTitle => 'Guida turistica';

  @override
  String get popularDestinations => 'Destinazioni popolari';

  @override
  String get pyramidsTitle => 'Le Piramidi';

  @override
  String get pyramidsDescription => 'L\'ultima meraviglia del mondo antico';

  @override
  String get egyptianMuseumTitle => 'Museo Egizio';

  @override
  String get egyptianMuseumDescription => 'La più grande collezione mondiale di antichità faraoniche';

  @override
  String get khanElKhaliliTitle => 'Khan El Khalili';

  @override
  String get khanElKhaliliDescription => 'Mercato storico che risale al 1382';

  @override
  String get essentialPhrases => 'Frasi essenziali in arabo';

  @override
  String get phrase1 => 'Quanto costa il biglietto?';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => 'Dov\'è la stazione della metro?';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => 'Questo va a...?';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => 'Consigli di viaggio';

  @override
  String get peakHoursTitle => 'Ore di punta';

  @override
  String get peakHoursDescription => 'Evita le 7-9 e le 15-18 per treni meno affollati';

  @override
  String get safetyTitle => 'Sicurezza';

  @override
  String get safetyDescription => 'Custodisci i tuoi oggetti di valore e fai attenzione all\'ambiente';

  @override
  String get ticketsTitle => 'Biglietti';

  @override
  String get ticketsDescription => 'Conserva sempre il biglietto fino all\'uscita dalla stazione';

  @override
  String get lengthLabel => 'Lunghezza';

  @override
  String get viewDetails => 'Vedi dettagli';

  @override
  String get whereToBuyDescription => 'Acquista biglietti, ricarica la carta o abbonati a card stagionali';

  @override
  String get ticketsBullet1 => 'Disponibili in tutte le biglietterie';

  @override
  String get ticketsBullet2 => 'Biglietti pubblici alle macchinette (da Haroun a Adly Mansour)';

  @override
  String get ticketsBullet3 => 'Tipi: pubblico, anziani, disabili';

  @override
  String get walletCardTitle => 'Carta wallet';

  @override
  String get walletBullet1 => 'Disponibile in biglietterie e macchinette (da Haroun a Adly Mansour)';

  @override
  String get walletBullet2 => 'Costo carta: 80 LE (ricarica minima 40 LE al primo acquisto)';

  @override
  String get walletBullet3 => 'Range di ricarica: da 20 a 400 LE';

  @override
  String get walletBullet4 => 'Riutilizzabile e trasferibile';

  @override
  String get walletBullet5 => 'Risparmia tempo rispetto ai biglietti singoli';

  @override
  String get seasonalCardTitle => 'Card stagionale';

  @override
  String get seasonalBullet1 => 'Per: pubblico generale, studenti, anziani (60+), disabili';

  @override
  String get requirementsTitle => 'Requisiti:';

  @override
  String get seasonalBullet2 => 'Visita gli uffici abbonamenti ad Attaba, Abbasia, Heliopolis o Adly Mansour';

  @override
  String get seasonalBullet3 => 'Fornisci 2 fotografie (formato 4x6)';

  @override
  String get additionalRequirementsTitle => 'Requisiti aggiuntivi:';

  @override
  String get studentReq => 'Studenti: modulo timbrato dalla scuola + documento/certificato di nascita + ricevuta';

  @override
  String get elderlyReq => 'Anziani: documento valido che attesti l\'età';

  @override
  String get specialNeedsReq => 'Disabili: documento governativo che attesti lo status';

  @override
  String get learnMore => 'Scopri di più';

  @override
  String get stationDetailsTitle => 'Dettagli stazione';

  @override
  String get stationMapTitle => 'Mappa della stazione';

  @override
  String get allOperationalLabel => 'Tutte le linee operative';

  @override
  String get statusLiveLabel => 'Live';

  @override
  String get homepageSubtitle => 'La tua guida smart per metro e LRT';

  @override
  String get greetingMorning => 'Buongiorno';

  @override
  String get greetingAfternoon => 'Buon pomeriggio';

  @override
  String get greetingEvening => 'Buonasera';

  @override
  String get greetingNight => 'Buonanotte';

  @override
  String get planYourRouteSubtitle => 'Trova il percorso più veloce tra le stazioni';

  @override
  String get recentSearchesLabel => 'Ricerche recenti';

  @override
  String get googleMapsLinkDetected => 'Link Google Maps rilevato';

  @override
  String get pickFromMapLabel => 'Scegli dalla mappa';

  @override
  String get quickActionsTitle => 'Azioni rapide';

  @override
  String get tapToLocateLabel => 'Tocca per trovare la stazione più vicina';

  @override
  String get touristHighlightsLabel => 'Attrazioni turistiche';

  @override
  String get viewPlansLabel => 'Vedi piani abbonamento';

  @override
  String get lrtLineName => 'Linea LRT';

  @override
  String get exploreAreaTitle => 'Esplora la zona';

  @override
  String get exploreAreaSubtitle => 'Scopri i luoghi vicini alle stazioni metro';

  @override
  String get tapToExploreLabel => 'Tocca la stazione per esplorare';

  @override
  String get promoMonthlyTitle => 'Mensile';

  @override
  String get promoMonthlySubtitle => 'Corse illimitate per 30 giorni';

  @override
  String get promoMonthlyTag => 'Miglior valore';

  @override
  String get promoStudentTitle => 'Studente';

  @override
  String get promoStudentSubtitle => 'Sconto 50% per studenti';

  @override
  String get promoStudentTag => 'Studente';

  @override
  String get promoFamilyTitle => 'Famiglia';

  @override
  String get promoFamilySubtitle => 'Viaggia insieme, risparmia di più';

  @override
  String get promoFamilyTag => 'Famiglia';

  @override
  String get buyNowLabel => 'Acquista';

  @override
  String get locateMeLabel => 'Localizzazione';

  @override
  String get locationServicesDisabled => 'Servizi di localizzazione disabilitati. Abilitali nelle impostazioni.';

  @override
  String get locationPermissionDenied => 'Autorizzazione posizione negata. Consentila nelle impostazioni app.';

  @override
  String get locationError => 'Impossibile ottenere la posizione. Riprova.';

  @override
  String get leaveNowLabel => 'Parti ora';

  @override
  String get cairoMetroNetworkLabel => 'Rete Metro del Cairo';

  @override
  String get resetViewLabel => 'Reimposta vista';

  @override
  String get mapLegendLabel => 'Legenda mappa';

  @override
  String get searchStationsHint => 'Cerca stazioni...';

  @override
  String get noStationsFound => 'Nessuna stazione trovata';

  @override
  String get line1FullName => 'Linea 1 — Helwan / New El-Marg';

  @override
  String get line2FullName => 'Linea 2 — Shubra El-Kheima / El-Mounib';

  @override
  String get line3FullName => 'Linea 3 — Adly Mansour / Kit Kat';

  @override
  String get line4FullName => 'Linea 4';

  @override
  String get monorailEastName => 'Monorotaia Est';

  @override
  String get monorailWestName => 'Monorotaia Ovest';

  @override
  String get allLinesStationsLabel => 'stazioni';

  @override
  String get underConstructionLabel => 'In costruzione';

  @override
  String get plannedLabel => 'Pianificato';

  @override
  String get transferLabel => 'Cambio';

  @override
  String get statusMaintenanceLabel => 'Manutenzione';

  @override
  String get statusDisruptionLabel => 'Interruzione';

  @override
  String get crowdCalmLabel => 'Tranquillo';

  @override
  String get crowdModerateLabel => 'Moderato';

  @override
  String get crowdBusyLabel => 'Affollato';

  @override
  String get locationDialogNoThanks => 'No grazie';

  @override
  String get locationDialogTurnOn => 'Attiva';

  @override
  String get locationDialogOpenSettings => 'Apri impostazioni';

  @override
  String get touristGuidePlacesCount => 'luoghi da esplorare';

  @override
  String get touristGuideDisclaimer => 'Orari, distanze e dettagli sono approssimativi e possono variare. Si prega di verificare ufficialmente prima della visita.';

  @override
  String get touristGuideSearchHint => 'Cerca luoghi o stazioni...';

  @override
  String get touristGuideCategoryAll => 'Tutti';

  @override
  String get touristGuideNoPlaces => 'Nessun luogo trovato';

  @override
  String get touristGuideNoPlacesSub => 'Prova una ricerca o una categoria diversa';

  @override
  String get photographyTitle => 'Fotografia';

  @override
  String get photographyDescription => 'La fotografia non è consentita all\'interno delle stazioni della metropolitana. Alcune attrazioni potrebbero addebitare una tariffa per la fotocamera.';

  @override
  String get bestTimeTitle => 'Periodo migliore per visitare';

  @override
  String get bestTimeDescription => 'Da ottobre ad aprile offre il clima migliore. Visita i siti all\'aperto la mattina presto o nel tardo pomeriggio.';

  @override
  String get phrase4 => 'Grazie';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => 'Quanto?';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => 'Dov\'è...?';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => 'Voglio andare a...';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => 'È lontano?';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => 'Pianifica percorso';

  @override
  String get lineLabel => 'Linea';

  @override
  String get categoryHistorical => 'Storico';

  @override
  String get categoryMuseum => 'Musei';

  @override
  String get categoryReligious => 'Religioso';

  @override
  String get categoryPark => 'Parchi';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryCulture => 'Cultura';

  @override
  String get categoryNile => 'Nilo';

  @override
  String get categoryHiddenGem => 'Gemme nascoste';

  @override
  String get facilityCommercial => 'Commerciale';

  @override
  String get facilityCultural => 'Culturale';

  @override
  String get facilityEducational => 'Educativo';

  @override
  String get facilityLandmarks => 'Luoghi di interesse';

  @override
  String get facilityMedical => 'Medico';

  @override
  String get facilityPublicInstitutions => 'Istituzioni pubbliche';

  @override
  String get facilityPublicSpaces => 'Spazi pubblici';

  @override
  String get facilityReligious => 'Religioso';

  @override
  String get facilityServices => 'Servizi';

  @override
  String get facilitySportFacilities => 'Impianti sportivi';

  @override
  String get facilityStreets => 'Strade';

  @override
  String get facilitySearchHint => 'Cerca luoghi...';

  @override
  String get facilityNoData => 'Nessun dato sulle strutture disponibile per questa stazione';

  @override
  String get facilityDataSoon => 'I dati verranno aggiunti presto';

  @override
  String get facilityClearFilter => 'Cancella filtro';

  @override
  String get facilityPlacesCount => 'luoghi';

  @override
  String get facilityZoomHint => 'Pizzica e trascina per ingrandire';

  @override
  String get facilityCategoriesLabel => 'categorie';

  @override
  String get sortBy => 'Ordina per';

  @override
  String get sortStops => 'Fermate';

  @override
  String get sortTime => 'Tempo';

  @override
  String get sortFare => 'Tariffa';

  @override
  String get sortLines => 'Linee';

  @override
  String get bestRoute => 'Migliore';

  @override
  String get hideStops => 'Nascondi fermate';

  @override
  String get showLabel => 'Mostra';

  @override
  String get stopsWord => 'fermate';

  @override
  String get minuteShort => 'min';

  @override
  String get detectingLocation => 'Rilevamento della posizione...';

  @override
  String get tapToExplore => 'Tocca per esplorare';

  @override
  String get couldNotOpenMaps => 'Impossibile aprire Google Maps';

  @override
  String get couldNotGetLocation => 'Impossibile ottenere la posizione. Controlla l\'autorizzazione alla posizione.';

  @override
  String get googleMapsLabel => 'Google Maps';

  @override
  String get couldNotFindNearestStation => 'Impossibile trovare la stazione più vicina';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String transferAtStation(Object station) {
    return 'Trasferimento a $station';
  }

  @override String get onboardingSkip => 'Salta';
  @override String get onboardingNext => 'Avanti';
  @override String get onboardingGetStarted => 'Inizia';
  @override String get onboardingTitle1 => 'Pianifica il percorso';
  @override String get onboardingSubtitle1 => 'Scegli stazione di partenza e arrivo — troviamo il percorso più veloce con cambi, durata e tariffa in secondi.';
  @override String get onboardingTitle2 => 'Conosci le linee';
  @override String get onboardingSubtitle2 => '3 linee a colori coprono tutta Il Cairo. Le icone circolari indicano le stazioni di cambio.';
  @override String get onboardingTitle3 => 'Tutto in un posto';
  @override String get onboardingSubtitle3 => 'Trova la stazione più vicina, esplora la mappa in tempo reale e scopri i luoghi vicino a ogni fermata.';
  @override String get onboardingLanguagePrompt => 'Scegli la lingua';
  @override String get onboardingReplay => 'Ripeti il tour';
  @override String get onboardingLine1 => 'Linea 1 · Helwan → New El-Marg';
  @override String get onboardingLine2 => 'Linea 2 · El-Mounib → Shubra';
  @override String get onboardingLine3 => 'Linea 3 · Adly Mansour → diramazioni';
  @override String get onboardingTransfer => 'Stazione di cambio';
}
