// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get locale => 'en';

  @override
  String get departureStationTitle => 'Departure Station';

  @override
  String get arrivalStationTitle => 'Arrival Station';

  @override
  String get departureStationHint => 'Select departure station';

  @override
  String get arrivalStationHint => 'Select arrival station';

  @override
  String get destinationFieldLabel => 'Enter destination address';

  @override
  String get findButtonText => 'Find Station';

  @override
  String get showRoutesButtonText => 'Show Route';

  @override
  String get pleaseSelectDeparture => 'Please select departure station';

  @override
  String get pleaseSelectArrival => 'Please select arrival station';

  @override
  String get selectDifferentStations => 'Please select different stations';

  @override
  String get nearestStationLabel => 'Nearest Station';

  @override
  String get addressNotFound => 'Address not found, please try again';

  @override
  String get invalidDataFormat => 'Invalid data format';

  @override
  String get routeToNearest => 'Route to Nearest';

  @override
  String get routeToDestination => 'Route to Destination';

  @override
  String get pleaseClickOnMyLocation => 'Please click on my location button first';

  @override
  String get mustTypeADestination => 'Must type a destination first.';

  @override
  String get estimatedTravelTime => 'Estimated travel time';

  @override
  String get ticketPrice => 'Ticket Price';

  @override
  String get noOfStations => 'No. of stations';

  @override
  String get changeAt => 'You will change at';

  @override
  String get totalTravelTime => 'Estimated total travel time';

  @override
  String get changeTime => 'Estimated travel time for changing lines';

  @override
  String get firstTake => 'First take';

  @override
  String get firstDirection => 'First Direction';

  @override
  String get firstDeparture => 'First Departure';

  @override
  String get firstArrival => 'First Arrival';

  @override
  String get firstIntermediateStations => 'First Intermediate Stations';

  @override
  String get secondTake => 'Second take';

  @override
  String get secondDirection => 'Second Direction';

  @override
  String get secondDeparture => 'Second Departure';

  @override
  String get secondArrival => 'Second Arrival';

  @override
  String get secondIntermediateStations => 'Second Intermediate Stations';

  @override
  String get thirdTake => 'Third take';

  @override
  String get thirdDirection => 'Third Direction';

  @override
  String get thirdDeparture => 'Third Departure';

  @override
  String get thirdArrival => 'Third Arrival';

  @override
  String get thirdIntermediateStations => 'Third Intermediate Stations';

  @override
  String get error => 'Error:';

  @override
  String get mustTypeDestination => 'Must type a destination first.';

  @override
  String get noRoutesFound => 'No routes found';

  @override
  String get routeDetails => 'Route Details';

  @override
  String get departure => 'Departure: ';

  @override
  String get arrival => 'Arrival: ';

  @override
  String get take => 'Take: ';

  @override
  String get direction => 'Direction: ';

  @override
  String get intermediateStations => 'Intermediate Stations:';

  @override
  String egp(Object price) {
    return '$price EGP';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => 'Show Stations';

  @override
  String get hideStations => 'Hide Stations';

  @override
  String get showRoute => 'Show Route';

  @override
  String get metro1 => 'Metro Line 1';

  @override
  String get metro2 => 'Metro Line 2';

  @override
  String get metro3branch1 => 'Metro Line 3 Branch ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => 'Metro Line 3 Branch CAIRO UNIVERSITY ';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return 'The distance to $stationName is $distance meters';
  }

  @override
  String reachedStation(Object stationName) {
    return 'You have reached $stationName';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return 'Current station is $currentStationName and next station is $nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return 'Current station is $currentStationName and next station is $nextStationName you will change to  $lineName direction $direction';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return 'Current station is $currentStationName and next station is $nextStationName it is your arrival station';
  }

  @override
  String get finalStationReached => 'Reached arrival station, trip completed';

  @override
  String get exchangeStation => 'Exchange Station';

  @override
  String get intermediateStationsTitle => 'Intermediate Stations';

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
  String get appTitle => 'Cairo Metro Guide';

  @override
  String get welcomeTitle => 'Plan Your Metro Journey';

  @override
  String get welcomeSubtitle => 'Find the best routes, nearest stations, and metro information';

  @override
  String get planYourRoute => 'Plan Your Route';

  @override
  String get findNearestStation => 'Find Nearest Station';

  @override
  String get scheduleLabel => 'Schedule';

  @override
  String get metroMapLabel => 'Metro Map';

  @override
  String get appInfoTitle => 'About Cairo Metro Guide';

  @override
  String get appInfoDescription => 'The official guide for Cairo Metro system. Find routes, stations, schedules and more.';

  @override
  String get close => 'Close';

  @override
  String get languageSwitchTitle => 'Change Language';

  @override
  String get routeOptions => 'Route Options';

  @override
  String get fastestRoute => 'Fastest Route';

  @override
  String get shortestRoute => 'Shortest Route';

  @override
  String get fewestTransfers => 'Fewest Transfers';

  @override
  String get estimatedTime => 'Estimated Time';

  @override
  String get estimatedFare => 'Estimated Fare';

  @override
  String stationsCount(Object count) {
    return '$count stations';
  }

  @override
  String get minutesAbbr => 'min';

  @override
  String get egpCurrency => 'EGP';

  @override
  String get departureTime => 'Departure';

  @override
  String get arrivalTime => 'Arrival';

  @override
  String get transferStations => 'Transfer at:';

  @override
  String get noInternetTitle => 'No Internet Connection';

  @override
  String get noInternetMessage => 'Some features may not be available offline';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String lastUpdated(Object date) {
    return 'Last updated: $date';
  }

  @override
  String get searchHistory => 'Search History';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get noHistory => 'No search history yet';

  @override
  String get favorites => 'Favorites';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get shareRoute => 'Share Route';

  @override
  String get amenitiesTitle => 'Station Amenities';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get parking => 'Parking';

  @override
  String get toilets => 'Toilets';

  @override
  String get atm => 'ATM';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading...';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get noResults => 'No results found';

  @override
  String get allLines => 'All Lines';

  @override
  String get line1 => 'Line 1';

  @override
  String get line2 => 'Line 2';

  @override
  String get line3 => 'Line 3';

  @override
  String get line4 => 'Line 4';

  @override
  String get operatingHours => 'Operating Hours';

  @override
  String get firstTrain => 'First Train';

  @override
  String get lastTrain => 'Last Train';

  @override
  String get peakHours => 'Peak Hours';

  @override
  String get offPeakHours => 'Off-Peak Hours';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get weekend => 'Weekend';

  @override
  String get holidays => 'Holidays';

  @override
  String get specialSchedule => 'Special Schedule';

  @override
  String get alerts => 'Service Alerts';

  @override
  String get noAlerts => 'No current service alerts';

  @override
  String get viewAllStations => 'View All Stations';

  @override
  String get nearbyStations => 'Nearby Stations';

  @override
  String distanceAway(Object distance) {
    return '$distance km away';
  }

  @override
  String walkingTime(Object minutes) {
    return '$minutes min walk';
  }

  @override
  String get metroEtiquette => 'Metro Etiquette';

  @override
  String get safetyTips => 'Safety Tips';

  @override
  String get feedback => 'Send Feedback';

  @override
  String get rateApp => 'Rate This App';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get recentTripsLabel => 'Recent Trips';

  @override
  String get favoritesLabel => 'Favorites';

  @override
  String get metroLinesTitle => 'Metro Lines';

  @override
  String get line1Name => 'Line 1';

  @override
  String get line2Name => 'Line 2';

  @override
  String get line3Name => 'Line 3';

  @override
  String get line4Name => 'Line 4';

  @override
  String get stationsLabel => 'stations';

  @override
  String get comingSoonLabel => 'Coming Soon';

  @override
  String get viewFullMap => 'View Full Map';

  @override
  String get nearestStationFound => 'Nearest Station Found';

  @override
  String get stationFound => 'Station Found';

  @override
  String get accessibilityLabel => 'Accessibility';

  @override
  String get seeAll => 'See All';

  @override
  String get allMetroLines => 'All Metro Lines';

  @override
  String get aroundStationsTitle => 'Around Stations';

  @override
  String get station => 'Station';

  @override
  String get seeFacilities => 'See Facilities';

  @override
  String get subscriptionInfoTitle => 'Ticket & Subscription Info';

  @override
  String get subscriptionInfoSubtitle => 'Learn about fares, zones and where to buy';

  @override
  String get facilitiesTitle => 'Station Facilities';

  @override
  String get parkingTitle => 'Parking';

  @override
  String get parkingDescription => 'Availability of parking facilities';

  @override
  String get toiletsTitle => 'Toilets';

  @override
  String get toiletsDescription => 'Public restroom availability';

  @override
  String get elevatorsTitle => 'Elevators';

  @override
  String get elevatorsDescription => 'Accessibility elevators';

  @override
  String get shopsTitle => 'Shops';

  @override
  String get shopsDescription => 'Convenience stores and kiosks';

  @override
  String get available => 'Available';

  @override
  String get notAvailable => 'Not Available';

  @override
  String get nearbyAttractions => 'Nearby Attractions';

  @override
  String get attraction1 => 'Egyptian Museum';

  @override
  String get attraction2 => 'Khan El Khalili';

  @override
  String get attraction3 => 'Tahrir Square';

  @override
  String get attractionDescription => 'One of Cairo\'s most famous landmarks, easily accessible from this station';

  @override
  String get minutes => 'minutes';

  @override
  String get walkingDistance => 'Walking distance';

  @override
  String get accessibilityInfoTitle => 'Accessibility Features';

  @override
  String get wheelchairTitle => 'Wheelchair Access';

  @override
  String get wheelchairDescription => 'All stations have wheelchair access points';

  @override
  String get hearingImpairmentTitle => 'Hearing Impairment';

  @override
  String get hearingImpairmentDescription => 'Visual indicators available for hearing impaired';

  @override
  String get subscriptionTypes => 'Subscription Types';

  @override
  String get dailyPass => 'Daily Pass';

  @override
  String get dailyPassDescription => 'Unlimited travel for one day on all lines';

  @override
  String get weeklyPass => 'Weekly Pass';

  @override
  String get weeklyPassDescription => 'Unlimited travel for 7 days on all lines';

  @override
  String get monthlyPass => 'Monthly Pass';

  @override
  String get monthlyPassDescription => 'Unlimited travel for 30 days on all lines';

  @override
  String get purchaseNow => 'Purchase Now';

  @override
  String get zonesTitle => 'Fare Zones';

  @override
  String get zonesDescription => 'Cairo Metro is divided into fare zones. The price depends on how many zones you travel through.';

  @override
  String get whereToBuyTitle => 'Where to Buy';

  @override
  String get metroStations => 'Metro Stations';

  @override
  String get metroStationsDescription => 'Available at ticket offices in all stations';

  @override
  String get authorizedVendors => 'Authorized Vendors';

  @override
  String get authorizedVendorsDescription => 'Selected kiosks and shops near stations';

  @override
  String get touristGuideTitle => 'Tourist Guide';

  @override
  String get popularDestinations => 'Popular Destinations';

  @override
  String get pyramidsTitle => 'The Pyramids';

  @override
  String get pyramidsDescription => 'The last remaining wonder of the ancient world';

  @override
  String get egyptianMuseumTitle => 'Egyptian Museum';

  @override
  String get egyptianMuseumDescription => 'Home to the world\'s largest collection of Pharaonic antiquities';

  @override
  String get khanElKhaliliTitle => 'Khan El Khalili';

  @override
  String get khanElKhaliliDescription => 'Historic market dating back to 1382';

  @override
  String get essentialPhrases => 'Essential Arabic Phrases';

  @override
  String get phrase1 => 'How much is the ticket?';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => 'Where is the metro station?';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => 'Does this go to...?';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => 'Travel Tips';

  @override
  String get peakHoursTitle => 'Peak Hours';

  @override
  String get peakHoursDescription => 'Avoid 7-9am and 3-6pm for less crowded trains';

  @override
  String get safetyTitle => 'Safety';

  @override
  String get safetyDescription => 'Keep valuables secure and be aware of your surroundings';

  @override
  String get ticketsTitle => 'Tickets';

  @override
  String get ticketsDescription => 'Always keep your ticket until you exit the station';

  @override
  String get lengthLabel => 'Length';

  @override
  String get viewDetails => 'View Details';

  @override
  String get whereToBuyDescription => 'Find where to buy tickets, recharge your wallet card or subscribe to monthly/quarterly/annual Seasonal cards';

  @override
  String get ticketsBullet1 => 'Available at all ticket offices';

  @override
  String get ticketsBullet2 => 'Public tickets available at vending machines (Haroun to Adly Mansour stations)';

  @override
  String get ticketsBullet3 => 'Types: Public, Elderly, Special Needs';

  @override
  String get walletCardTitle => 'Wallet Card';

  @override
  String get walletBullet1 => 'Available at all ticket offices and vending machines (Haroun to Adly Mansour)';

  @override
  String get walletBullet2 => 'Card cost: 80 LE (minimum 40 LE top-up on first purchase)';

  @override
  String get walletBullet3 => 'Top-up range: 20 LE to 400 LE';

  @override
  String get walletBullet4 => 'Reusable and transferable';

  @override
  String get walletBullet5 => 'Saves time compared to single tickets';

  @override
  String get seasonalCardTitle => 'Seasonal Card';

  @override
  String get seasonalBullet1 => 'Available for: General Public, Students, Elderly (60+), Special Needs';

  @override
  String get requirementsTitle => 'Requirements:';

  @override
  String get seasonalBullet2 => 'Visit subscription offices at Attaba, Abbasia, Heliopolis or Adly Mansour';

  @override
  String get seasonalBullet3 => 'Provide 2 photographs (4x6 format)';

  @override
  String get additionalRequirementsTitle => 'Additional requirements:';

  @override
  String get studentReq => 'Students: School-stamped form + ID/birth certificate + payment receipt';

  @override
  String get elderlyReq => 'Elderly: Valid ID proving age';

  @override
  String get specialNeedsReq => 'Special Needs: Government-issued ID proving status';

  @override
  String get learnMore => 'Learn More';

  @override
  String get stationDetailsTitle => 'Station Details';

  @override
  String get stationMapTitle => 'Station Map';
}
