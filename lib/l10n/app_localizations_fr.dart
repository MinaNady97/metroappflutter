// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get locale => 'fr';

  @override
  String get departureStationTitle => 'Station de départ';

  @override
  String get arrivalStationTitle => 'Station d\'arrivée';

  @override
  String get departureStationHint => 'Sélectionnez la station de départ';

  @override
  String get arrivalStationHint => 'Sélectionnez la station d\'arrivée';

  @override
  String get destinationFieldLabel => 'Entrez votre destination';

  @override
  String get findButtonText => 'Trouver';

  @override
  String get showRoutesButtonText => 'Afficher l\'itinéraire';

  @override
  String get pleaseSelectDeparture => 'Veuillez sélectionner la station de départ.';

  @override
  String get pleaseSelectArrival => 'Veuillez sélectionner la station d\'arrivée.';

  @override
  String get selectDifferentStations => 'Veuillez sélectionner des stations différentes.';

  @override
  String get nearestStationLabel => 'Station la plus proche';

  @override
  String get addressNotFound => 'Adresse introuvable. Veuillez réessayer avec plus de détails.';

  @override
  String get invalidDataFormat => 'Format de données invalide';

  @override
  String get routeToNearest => 'Itinéraire vers la plus proche';

  @override
  String get routeToDestination => 'Itinéraire vers la destination';

  @override
  String get pleaseClickOnMyLocation => 'Veuillez d\'abord cliquer sur le bouton de localisation';

  @override
  String get mustTypeADestination => 'Vous devez d\'abord saisir une destination.';

  @override
  String get estimatedTravelTime => 'Temps de trajet estimé';

  @override
  String get ticketPrice => 'Prix du billet';

  @override
  String get noOfStations => 'Nombre de stations';

  @override
  String get changeAt => 'Vous changerez à';

  @override
  String get totalTravelTime => 'Temps total de trajet estimé';

  @override
  String get changeTime => 'Temps de trajet pour changer de ligne';

  @override
  String get firstTake => 'Premier tronçon';

  @override
  String get firstDirection => 'Première direction';

  @override
  String get firstDeparture => 'Premier départ';

  @override
  String get firstArrival => 'Première arrivée';

  @override
  String get firstIntermediateStations => 'Premières stations intermédiaires';

  @override
  String get secondTake => 'Deuxième tronçon';

  @override
  String get secondDirection => 'Deuxième direction';

  @override
  String get secondDeparture => 'Deuxième départ';

  @override
  String get secondArrival => 'Deuxième arrivée';

  @override
  String get secondIntermediateStations => 'Deuxièmes stations intermédiaires';

  @override
  String get thirdTake => 'Troisième tronçon';

  @override
  String get thirdDirection => 'Troisième direction';

  @override
  String get thirdDeparture => 'Troisième départ';

  @override
  String get thirdArrival => 'Troisième arrivée';

  @override
  String get thirdIntermediateStations => 'Troisièmes stations intermédiaires';

  @override
  String get error => 'Erreur :';

  @override
  String get mustTypeDestination => 'Vous devez d\'abord saisir une destination.';

  @override
  String get noRoutesFound => 'Aucun itinéraire trouvé';

  @override
  String get routeDetails => 'Détails de l\'itinéraire';

  @override
  String get departure => 'Départ : ';

  @override
  String get arrival => 'Arrivée : ';

  @override
  String get take => 'Prendre : ';

  @override
  String get direction => 'Direction : ';

  @override
  String get intermediateStations => 'Stations intermédiaires :';

  @override
  String egp(Object price) {
    return '$price LE';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => 'Afficher les stations';

  @override
  String get hideStations => 'Masquer les stations';

  @override
  String get showRoute => 'Afficher l\'itinéraire';

  @override
  String get metro1 => 'Ligne de Métro 1';

  @override
  String get metro2 => 'Ligne de Métro 2';

  @override
  String get metro3branch1 => 'Ligne de Métro 3 Branche ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => 'Ligne de Métro 3 Branche CAIRO UNIVERSITY';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return 'La distance jusqu\'à $stationName est de $distance mètres';
  }

  @override
  String reachedStation(Object stationName) {
    return 'Vous avez atteint $stationName';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return 'Station actuelle : $currentStationName, prochaine station : $nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return 'Station actuelle : $currentStationName, prochaine station : $nextStationName, changez pour $lineName direction $direction';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return 'Station actuelle : $currentStationName, prochaine station : $nextStationName, c\'est votre station d\'arrivée';
  }

  @override
  String get finalStationReached => 'Station d\'arrivée atteinte, trajet terminé';

  @override
  String get exchangeStation => 'Station de correspondance';

  @override
  String get intermediateStationsTitle => 'Stations intermédiaires';

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
  String get appTitle => 'Guide du Métro du Caire';

  @override
  String get welcomeTitle => 'Planifiez votre trajet en métro';

  @override
  String get welcomeSubtitle => 'Trouvez les meilleurs itinéraires, stations proches et informations';

  @override
  String get planYourRoute => 'Planifier votre trajet';

  @override
  String get findNearestStation => 'Trouver une station par adresse';

  @override
  String get scheduleLabel => 'Horaires du métro';

  @override
  String get metroMapLabel => 'Carte du métro';

  @override
  String get appInfoTitle => 'À propos du Guide du Métro du Caire';

  @override
  String get appInfoDescription => 'Le guide officiel du système de métro du Caire. Trouvez des itinéraires, stations, horaires et plus.';

  @override
  String get close => 'Fermer';

  @override
  String get languageSwitchTitle => 'Changer de langue';

  @override
  String get routeOptions => 'Options d\'itinéraire';

  @override
  String get fastestRoute => 'Itinéraire le plus rapide';

  @override
  String get shortestRoute => 'Itinéraire le plus court';

  @override
  String get fewestTransfers => 'Moins de correspondances';

  @override
  String get estimatedTime => 'Temps estimé';

  @override
  String get estimatedFare => 'Tarif estimé';

  @override
  String stationsCount(Object count) {
    return '$count stations';
  }

  @override
  String get minutesAbbr => 'min';

  @override
  String get exitDialogTitle => 'Quitter l\'application ?';

  @override
  String get exitDialogSubtitle => 'Êtes-vous sûr de vouloir quitter\nle Guide du Métro du Caire ?';

  @override
  String get exitDialogStay => 'Rester';

  @override
  String get exitDialogExit => 'Quitter';

  @override
  String get egpCurrency => 'LE';

  @override
  String get departureTime => 'Départ';

  @override
  String get arrivalTime => 'Arrivée';

  @override
  String get transferStations => 'Correspondance à :';

  @override
  String get noInternetTitle => 'Pas de connexion Internet';

  @override
  String get noInternetMessage => 'Certaines fonctionnalités peuvent ne pas être disponibles hors ligne';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get offlineMode => 'Mode hors ligne';

  @override
  String lastUpdated(Object date) {
    return 'Dernière mise à jour : $date';
  }

  @override
  String get searchHistory => 'Historique de recherche';

  @override
  String get clearHistory => 'Effacer l\'historique';

  @override
  String get noHistory => 'Aucun historique de recherche';

  @override
  String get favorites => 'Favoris';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get shareRoute => 'Partager l\'itinéraire';

  @override
  String get amenitiesTitle => 'Équipements de la station';

  @override
  String get accessibility => 'Accessibilité';

  @override
  String get parking => 'Parking';

  @override
  String get toilets => 'Toilettes';

  @override
  String get atm => 'Distributeur';

  @override
  String get refresh => 'Actualiser';

  @override
  String get loading => 'Chargement...';

  @override
  String get errorOccurred => 'Une erreur s\'est produite';

  @override
  String get retry => 'Réessayer';

  @override
  String get noResults => 'Aucun résultat trouvé';

  @override
  String get allLines => 'Toutes les lignes';

  @override
  String get line1 => 'Ligne 1';

  @override
  String get line2 => 'Ligne 2';

  @override
  String get line3 => 'Ligne 3';

  @override
  String get line4 => 'Ligne 4';

  @override
  String get operatingHours => 'Heures d\'exploitation';

  @override
  String get firstTrain => 'Premier train';

  @override
  String get lastTrain => 'Dernier train';

  @override
  String get peakHours => 'Heures de pointe';

  @override
  String get offPeakHours => 'Heures creuses';

  @override
  String get weekdays => 'Jours ouvrables';

  @override
  String get weekend => 'Week-end';

  @override
  String get holidays => 'Jours fériés';

  @override
  String get specialSchedule => 'Horaire spécial';

  @override
  String get alerts => 'Alertes de service';

  @override
  String get noAlerts => 'Aucune alerte en cours';

  @override
  String get viewAllStations => 'Voir toutes les stations';

  @override
  String get nearbyStations => 'Stations à proximité';

  @override
  String distanceAway(Object distance) {
    return '$distance km';
  }

  @override
  String walkingTime(Object minutes) {
    return '$minutes min à pied';
  }

  @override
  String get metroEtiquette => 'Étiquette du métro';

  @override
  String get safetyTips => 'Conseils de sécurité';

  @override
  String get feedback => 'Envoyer un retour';

  @override
  String get rateApp => 'Noter cette application';

  @override
  String get settings => 'Paramètres';

  @override
  String get notifications => 'Notifications';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get language => 'Langue';

  @override
  String get recentTripsLabel => 'Trajets récents';

  @override
  String get favoritesLabel => 'Favoris';

  @override
  String get metroLinesTitle => 'Lignes de métro';

  @override
  String get line1Name => 'Ligne 1';

  @override
  String get line2Name => 'Ligne 2';

  @override
  String get line3Name => 'Ligne 3';

  @override
  String get line4Name => 'Ligne 4';

  @override
  String get stationsLabel => 'stations';

  @override
  String get comingSoonLabel => 'Bientôt disponible';

  @override
  String get viewFullMap => 'Voir la carte complète';

  @override
  String get routeAllStops => 'Tous les arrêts';

  @override
  String get nearestStationFound => 'Station la plus proche trouvée';
  String nextTrainIn(int min) => 'Prochain train dans ~{min} min'.replaceAll('{min}', '$min');
  String get outsideServiceHours => 'Hors des heures de service';
  String get saveRouteLabel => 'Sauvegarder l\'itinéraire';
  String get routeSaved => 'Enregistré dans les favoris';
  String get routeUnsaved => 'Retiré des favoris';
  String get nearestStationTitle => 'Votre station la plus proche';
  String get nearestStationSubtitle => 'Détectée automatiquement par GPS';
  String get nearestStationLocating => 'Recherche de la station la plus proche…';
  String get nearestStationCaption => 'Station de métro la plus proche de votre position';
  String get getDirections => 'Obtenir un itinéraire';
  String get walkingDirections => 'À pied';
  String get drivingDirections => 'En voiture';
  String get currentLocation => 'Ma Position';
  String get useAsDeparture => 'Définir comme départ';

  @override
  String get stationFound => 'Station trouvée';

  @override
  String get accessibilityLabel => 'Accessibilité';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get allMetroLines => 'Toutes les lignes de métro';

  @override
  String get aroundStationsTitle => 'Autour des stations';

  @override
  String get station => 'Station';

  @override
  String get seeFacilities => 'Voir les équipements';

  @override
  String get subscriptionInfoTitle => 'Billets et abonnements';

  @override
  String get subscriptionInfoSubtitle => 'Tarifs, zones et où acheter';

  @override
  String get facilitiesTitle => 'Équipements de la station';

  @override
  String get parkingTitle => 'Parking';

  @override
  String get parkingDescription => 'Disponibilité des parkings';

  @override
  String get toiletsTitle => 'Toilettes';

  @override
  String get toiletsDescription => 'Disponibilité des toilettes publiques';

  @override
  String get elevatorsTitle => 'Ascenseurs';

  @override
  String get elevatorsDescription => 'Ascenseurs d\'accessibilité';

  @override
  String get shopsTitle => 'Boutiques';

  @override
  String get shopsDescription => 'Épiceries et kiosques';

  @override
  String get available => 'Disponible';

  @override
  String get notAvailable => 'Non disponible';

  @override
  String get nearbyAttractions => 'Attractions à proximité';

  @override
  String get attraction1 => 'Musée Égyptien';

  @override
  String get attraction2 => 'Khan El Khalili';

  @override
  String get attraction3 => 'Place Tahrir';

  @override
  String get attractionDescription => 'L\'un des monuments les plus célèbres du Caire, facilement accessible depuis cette station';

  @override
  String get minutes => 'minutes';

  @override
  String get walkingDistance => 'À pied';

  @override
  String get accessibilityInfoTitle => 'Fonctionnalités d\'accessibilité';

  @override
  String get wheelchairTitle => 'Accès fauteuil roulant';

  @override
  String get wheelchairDescription => 'Toutes les stations disposent d\'accès pour fauteuil roulant';

  @override
  String get hearingImpairmentTitle => 'Déficience auditive';

  @override
  String get hearingImpairmentDescription => 'Indicateurs visuels disponibles pour les malentendants';

  @override
  String get subscriptionTypes => 'Types d\'abonnement';

  @override
  String get dailyPass => 'Pass journalier';

  @override
  String get dailyPassDescription => 'Voyages illimités pendant un jour sur toutes les lignes';

  @override
  String get weeklyPass => 'Pass hebdomadaire';

  @override
  String get weeklyPassDescription => 'Voyages illimités pendant 7 jours sur toutes les lignes';

  @override
  String get monthlyPass => 'Pass mensuel';

  @override
  String get monthlyPassDescription => 'Voyages illimités pendant 30 jours sur toutes les lignes';

  @override
  String get purchaseNow => 'Acheter maintenant';

  @override
  String get zonesTitle => 'Zones tarifaires';

  @override
  String get zonesDescription => 'Le métro du Caire est divisé en zones tarifaires. Le prix dépend du nombre de zones traversées.';

  @override
  String get whereToBuyTitle => 'Où acheter';

  @override
  String get metroStations => 'Stations de métro';

  @override
  String get metroStationsDescription => 'Disponible aux guichets dans toutes les stations';

  @override
  String get authorizedVendors => 'Vendeurs autorisés';

  @override
  String get authorizedVendorsDescription => 'Kiosques et boutiques sélectionnés près des stations';

  @override
  String get touristGuideTitle => 'Guide touristique';

  @override
  String get popularDestinations => 'Destinations populaires';

  @override
  String get pyramidsTitle => 'Les Pyramides';

  @override
  String get pyramidsDescription => 'La dernière merveille du monde antique';

  @override
  String get egyptianMuseumTitle => 'Musée Égyptien';

  @override
  String get egyptianMuseumDescription => 'Abrite la plus grande collection d\'antiquités pharaoniques du monde';

  @override
  String get khanElKhaliliTitle => 'Khan El Khalili';

  @override
  String get khanElKhaliliDescription => 'Marché historique datant de 1382';

  @override
  String get essentialPhrases => 'Phrases arabes essentielles';

  @override
  String get phrase1 => 'Combien coûte le billet ?';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => 'Où est la station de métro ?';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => 'Est-ce que ça va à... ?';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => 'Conseils de voyage';

  @override
  String get peakHoursTitle => 'Heures de pointe';

  @override
  String get peakHoursDescription => 'Évitez 7h-9h et 15h-18h pour des trains moins bondés';

  @override
  String get safetyTitle => 'Sécurité';

  @override
  String get safetyDescription => 'Gardez vos objets de valeur en sécurité et soyez attentif à votre environnement';

  @override
  String get ticketsTitle => 'Billets';

  @override
  String get ticketsDescription => 'Conservez toujours votre billet jusqu\'à la sortie de la station';

  @override
  String get lengthLabel => 'Longueur';

  @override
  String get viewDetails => 'Voir les détails';

  @override
  String get whereToBuyDescription => 'Trouvez où acheter des billets, recharger votre carte ou vous abonner';

  @override
  String get ticketsBullet1 => 'Disponible à tous les guichets';

  @override
  String get ticketsBullet2 => 'Billets publics disponibles aux distributeurs automatiques (stations Haroun à Adly Mansour)';

  @override
  String get ticketsBullet3 => 'Types : Public, Personnes âgées, Besoins spéciaux';

  @override
  String get walletCardTitle => 'Carte portefeuille';

  @override
  String get walletBullet1 => 'Disponible à tous les guichets et distributeurs (Haroun à Adly Mansour)';

  @override
  String get walletBullet2 => 'Coût de la carte : 80 LE (recharge minimale de 40 LE au premier achat)';

  @override
  String get walletBullet3 => 'Plage de recharge : 20 LE à 400 LE';

  @override
  String get walletBullet4 => 'Réutilisable et transférable';

  @override
  String get walletBullet5 => 'Gain de temps par rapport aux billets simples';

  @override
  String get seasonalCardTitle => 'Carte saisonnière';

  @override
  String get seasonalBullet1 => 'Disponible pour : Grand public, Étudiants, Personnes âgées (60+), Besoins spéciaux';

  @override
  String get requirementsTitle => 'Conditions requises :';

  @override
  String get seasonalBullet2 => 'Visitez les bureaux d\'abonnement à Attaba, Abbasia, Heliopolis ou Adly Mansour';

  @override
  String get seasonalBullet3 => 'Fournir 2 photos (format 4x6)';

  @override
  String get additionalRequirementsTitle => 'Conditions supplémentaires :';

  @override
  String get studentReq => 'Étudiants : Formulaire tamponné par l\'école + CNI/acte de naissance + reçu de paiement';

  @override
  String get elderlyReq => 'Personnes âgées : Pièce d\'identité valide prouvant l\'âge';

  @override
  String get specialNeedsReq => 'Besoins spéciaux : Pièce d\'identité gouvernementale prouvant le statut';

  @override
  String get learnMore => 'En savoir plus';

  @override
  String get stationDetailsTitle => 'Détails de la station';

  @override
  String get stationMapTitle => 'Plan de la station';

  @override
  String get allOperationalLabel => 'Toutes les lignes opérationnelles';

  @override
  String get statusLiveLabel => 'En direct';

  @override
  String get homepageSubtitle => 'Votre guide intelligent pour le métro et le LRT';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get greetingAfternoon => 'Bon après-midi';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String get greetingNight => 'Bonne nuit';

  @override
  String get planYourRouteSubtitle => 'Trouvez l\'itinéraire le plus rapide entre les stations';

  @override
  String get recentSearchesLabel => 'Recherches récentes';

  @override
  String get googleMapsLinkDetected => 'Lien Google Maps détecté';

  @override
  String get pickFromMapLabel => 'Choisir sur la carte';

  @override
  String get quickActionsTitle => 'Actions rapides';

  @override
  String get tapToLocateLabel => 'Appuyez pour localiser la station la plus proche';

  @override
  String get touristHighlightsLabel => 'points d\'intérêt touristiques';

  @override
  String get viewPlansLabel => 'Voir les forfaits d\'abonnement';

  @override
  String get lrtLineName => 'Ligne LRT';

  @override
  String get exploreAreaTitle => 'Explorer la zone';

  @override
  String get exploreAreaSubtitle => 'Découvrez les lieux à proximité des stations de métro';

  @override
  String get tapToExploreLabel => 'Appuyez sur une station pour explorer';

  @override
  String get promoMonthlyTitle => 'Pass mensuel';

  @override
  String get promoMonthlySubtitle => 'Voyages illimités pendant 30 jours';

  @override
  String get promoMonthlyTag => 'Meilleure valeur';

  @override
  String get promoStudentTitle => 'Pass étudiant';

  @override
  String get promoStudentSubtitle => '50% de réduction pour les étudiants';

  @override
  String get promoStudentTag => 'Étudiant';

  @override
  String get promoFamilyTitle => 'Pass famille';

  @override
  String get promoFamilySubtitle => 'Voyagez ensemble, économisez plus';

  @override
  String get promoFamilyTag => 'Famille';

  @override
  String get buyNowLabel => 'Acheter maintenant';

  @override
  String get locateMeLabel => 'Localisation';

  @override
  String get locationServicesDisabled => 'Les services de localisation sont désactivés. Veuillez les activer dans les Paramètres.';

  @override
  String get locationPermissionDenied => 'Permission de localisation refusée. Veuillez l\'autoriser dans les paramètres de l\'application.';

  @override
  String get locationError => 'Impossible d\'obtenir votre position. Veuillez réessayer.';

  @override
  String get leaveNowLabel => 'Partir maintenant';

  @override
  String get cairoMetroNetworkLabel => 'Réseau du Métro du Caire';

  @override
  String get resetViewLabel => 'Réinitialiser la vue';

  @override
  String get mapViewSchematic => 'Schématique';

  @override
  String get mapViewGeographic => 'Carte';

  @override
  String get mapLegendLabel => 'Légende de la carte';

  @override
  String get searchStationsHint => 'Rechercher des stations...';

  @override
  String get noStationsFound => 'Aucune station trouvée';

  @override
  String get line1FullName => 'Ligne 1 — Helwan / New El-Marg';

  @override
  String get line2FullName => 'Ligne 2 — Shubra El-Kheima / El-Mounib';

  @override
  String get line3FullName => 'Ligne 3 — Adly Mansour / Kit Kat';

  @override
  String get line4FullName => 'Ligne 4';

  @override
  String get monorailEastName => 'Monorail Est';

  @override
  String get monorailWestName => 'Monorail Ouest';

  @override
  String get allLinesStationsLabel => 'stations';

  @override
  String get underConstructionLabel => 'En construction';

  @override
  String get plannedLabel => 'Prévu';

  @override
  String get transferLabel => 'Correspondance';

  @override
  String get statusMaintenanceLabel => 'Maintenance';

  @override
  String get statusDisruptionLabel => 'Perturbation';

  @override
  String get crowdCalmLabel => 'Calme';

  @override
  String get crowdModerateLabel => 'Modéré';

  @override
  String get crowdBusyLabel => 'Chargé';

  @override
  String get locationDialogNoThanks => 'Non merci';

  @override
  String get locationDialogTurnOn => 'Activer';

  @override
  String get locationDialogOpenSettings => 'Ouvrir les paramètres';

  @override
  String get touristGuidePlacesCount => 'lieux à explorer';

  @override
  String get touristGuideDisclaimer => 'Les horaires, distances et détails sont approximatifs et peuvent varier. Veuillez vérifier officiellement avant de visiter.';

  @override
  String get touristGuideSearchHint => 'Rechercher des lieux ou des stations...';

  @override
  String get touristGuideCategoryAll => 'Tout';

  @override
  String get touristGuideNoPlaces => 'Aucun lieu trouvé';

  @override
  String get touristGuideNoPlacesSub => 'Essayez une recherche ou une catégorie différente';

  @override
  String get photographyTitle => 'Photographie';

  @override
  String get photographyDescription => 'La photographie est interdite à l\'intérieur des stations de métro. Certaines attractions peuvent facturer des frais d\'appareil photo.';

  @override
  String get bestTimeTitle => 'Meilleure période pour visiter';

  @override
  String get bestTimeDescription => 'D\'octobre à avril offre le meilleur temps. Visitez les sites extérieurs tôt le matin ou en fin d\'après-midi.';

  @override
  String get phrase4 => 'Merci';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => 'Combien?';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => 'Où est...?';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => 'Je veux aller à...';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => 'C\'est loin?';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => 'Planifier l\'itinéraire';

  @override
  String get lineLabel => 'Ligne';

  @override
  String get categoryHistorical => 'Historique';

  @override
  String get categoryMuseum => 'Musées';

  @override
  String get categoryReligious => 'Religieux';

  @override
  String get categoryPark => 'Parcs';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryCulture => 'Culture';

  @override
  String get categoryNile => 'Nil';

  @override
  String get categoryHiddenGem => 'Joyaux cachés';

  @override
  String get facilityCommercial => 'Commercial';

  @override
  String get facilityCultural => 'Culturel';

  @override
  String get facilityEducational => 'Éducatif';

  @override
  String get facilityLandmarks => 'Sites emblématiques';

  @override
  String get facilityMedical => 'Médical';

  @override
  String get facilityPublicInstitutions => 'Institutions publiques';

  @override
  String get facilityPublicSpaces => 'Espaces publics';

  @override
  String get facilityReligious => 'Religieux';

  @override
  String get facilityServices => 'Services';

  @override
  String get facilitySportFacilities => 'Équipements sportifs';

  @override
  String get facilityStreets => 'Rues';

  @override
  String get facilitySearchHint => 'Rechercher des lieux...';

  @override
  String get facilityNoData => 'Aucune donnée disponible pour cette station pour l\'instant';

  @override
  String get facilityDataSoon => 'Les données seront ajoutées bientôt';

  @override
  String get facilityClearFilter => 'Effacer le filtre';

  @override
  String get facilityPlacesCount => 'lieux';

  @override
  String get facilityZoomHint => 'Pincez et faites glisser pour zoomer';

  @override
  String get facilityCategoriesLabel => 'catégories';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortStops => 'Arrêts';

  @override
  String get sortTime => 'Temps';

  @override
  String get sortFare => 'Tarif';

  @override
  String get sortLines => 'Lignes';

  @override
  String get bestRoute => 'Meilleur';

  @override
  String get accessibleRoute => 'Itinéraire Accessible';

  @override
  String get routeTypeFastest => 'Plus Rapide';

  @override
  String get routeTypeAccessible => 'Accessible';

  @override
  String get routeTypeFewestTransfers => 'Moins de Correspondances';

  @override
  String get routeTypeAlternative => 'Itinéraire alternatif';

  @override
  String get hideStops => 'Masquer les arrêts';

  @override
  String get showLabel => 'Afficher';

  @override
  String get stopsWord => 'arrêts';

  @override
  String get minuteShort => 'min';

  @override
  String get detectingLocation => 'Détection de votre position...';

  @override
  String get tapToExplore => 'Appuyez pour explorer';

  @override
  String get couldNotOpenMaps => 'Impossible d\'ouvrir Google Maps';

  @override
  String get couldNotGetLocation => 'Impossible d\'obtenir votre position. Vérifiez l\'autorisation de localisation.';

  @override
  String get googleMapsLabel => 'Google Maps';

  @override
  String get couldNotFindNearestStation => 'Impossible de trouver la station la plus proche';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String transferAtStation(Object station) {
    return 'Correspondance à $station';
  }

  @override String get onboardingSkip => 'Passer';
  @override String get onboardingNext => 'Suivant';
  @override String get onboardingGetStarted => 'Commencer';
  @override String get onboardingTitle1 => 'Planifiez votre trajet';
  @override String get onboardingSubtitle1 => 'Choisissez une station de départ et d\'arrivée — nous trouvons le chemin le plus rapide avec correspondances, durée et tarif.';
  @override String get onboardingTitle2 => 'Connaître les lignes';
  @override String get onboardingSubtitle2 => '3 lignes colorées couvrent tout Le Caire. Les icônes rondes indiquent les stations de correspondance.';
  @override String get onboardingTitle3 => 'Tout en un seul endroit';
  @override String get onboardingSubtitle3 => 'Trouvez la station la plus proche, explorez la carte en direct et découvrez les lieux autour de chaque arrêt.';
  @override String get onboardingLanguagePrompt => 'Choisir la langue';
  @override String get onboardingReplay => 'Rejouer le tour';
  @override String get onboardingLine1 => 'Ligne 1 · Helwan → New El-Marg';
  @override String get onboardingLine2 => 'Ligne 2 · El-Mounib → Shubra';
  @override String get onboardingLine3 => 'Ligne 3 · Adly Mansour → branches';
  @override String get onboardingTransfer => 'Station de correspondance';

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

  @override String get searchingOnline => 'Recherche en ligne…';
  @override String get didYouMean => 'Vouliez-vous dire ?';
  @override String get tapForTransferDetails => 'Appuyer pour les détails du transfert';
}