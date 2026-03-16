import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh')
  ];

  /// No description provided for @locale.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get locale;

  /// No description provided for @departureStationTitle.
  ///
  /// In en, this message translates to:
  /// **'Departure Station'**
  String get departureStationTitle;

  /// No description provided for @arrivalStationTitle.
  ///
  /// In en, this message translates to:
  /// **'Arrival Station'**
  String get arrivalStationTitle;

  /// No description provided for @departureStationHint.
  ///
  /// In en, this message translates to:
  /// **'Select departure station'**
  String get departureStationHint;

  /// No description provided for @arrivalStationHint.
  ///
  /// In en, this message translates to:
  /// **'Select arrival station'**
  String get arrivalStationHint;

  /// No description provided for @destinationFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter destination address'**
  String get destinationFieldLabel;

  /// No description provided for @findButtonText.
  ///
  /// In en, this message translates to:
  /// **'Find Station'**
  String get findButtonText;

  /// No description provided for @showRoutesButtonText.
  ///
  /// In en, this message translates to:
  /// **'Show Route'**
  String get showRoutesButtonText;

  /// No description provided for @pleaseSelectDeparture.
  ///
  /// In en, this message translates to:
  /// **'Please select departure station'**
  String get pleaseSelectDeparture;

  /// No description provided for @pleaseSelectArrival.
  ///
  /// In en, this message translates to:
  /// **'Please select arrival station'**
  String get pleaseSelectArrival;

  /// No description provided for @selectDifferentStations.
  ///
  /// In en, this message translates to:
  /// **'Please select different stations'**
  String get selectDifferentStations;

  /// No description provided for @nearestStationLabel.
  ///
  /// In en, this message translates to:
  /// **'Nearest Station'**
  String get nearestStationLabel;

  /// No description provided for @addressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found, please try again'**
  String get addressNotFound;

  /// No description provided for @invalidDataFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid data format'**
  String get invalidDataFormat;

  /// No description provided for @routeToNearest.
  ///
  /// In en, this message translates to:
  /// **'Route to Nearest'**
  String get routeToNearest;

  /// No description provided for @routeToDestination.
  ///
  /// In en, this message translates to:
  /// **'Route to Destination'**
  String get routeToDestination;

  /// No description provided for @pleaseClickOnMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Please click on my location button first'**
  String get pleaseClickOnMyLocation;

  /// No description provided for @mustTypeADestination.
  ///
  /// In en, this message translates to:
  /// **'Must type a destination first.'**
  String get mustTypeADestination;

  /// No description provided for @estimatedTravelTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated travel time'**
  String get estimatedTravelTime;

  /// No description provided for @ticketPrice.
  ///
  /// In en, this message translates to:
  /// **'Ticket Price'**
  String get ticketPrice;

  /// No description provided for @noOfStations.
  ///
  /// In en, this message translates to:
  /// **'No. of stations'**
  String get noOfStations;

  /// No description provided for @changeAt.
  ///
  /// In en, this message translates to:
  /// **'You will change at'**
  String get changeAt;

  /// No description provided for @totalTravelTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated total travel time'**
  String get totalTravelTime;

  /// No description provided for @changeTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated travel time for changing lines'**
  String get changeTime;

  /// No description provided for @firstTake.
  ///
  /// In en, this message translates to:
  /// **'First take'**
  String get firstTake;

  /// No description provided for @firstDirection.
  ///
  /// In en, this message translates to:
  /// **'First Direction'**
  String get firstDirection;

  /// No description provided for @firstDeparture.
  ///
  /// In en, this message translates to:
  /// **'First Departure'**
  String get firstDeparture;

  /// No description provided for @firstArrival.
  ///
  /// In en, this message translates to:
  /// **'First Arrival'**
  String get firstArrival;

  /// No description provided for @firstIntermediateStations.
  ///
  /// In en, this message translates to:
  /// **'First Intermediate Stations'**
  String get firstIntermediateStations;

  /// No description provided for @secondTake.
  ///
  /// In en, this message translates to:
  /// **'Second take'**
  String get secondTake;

  /// No description provided for @secondDirection.
  ///
  /// In en, this message translates to:
  /// **'Second Direction'**
  String get secondDirection;

  /// No description provided for @secondDeparture.
  ///
  /// In en, this message translates to:
  /// **'Second Departure'**
  String get secondDeparture;

  /// No description provided for @secondArrival.
  ///
  /// In en, this message translates to:
  /// **'Second Arrival'**
  String get secondArrival;

  /// No description provided for @secondIntermediateStations.
  ///
  /// In en, this message translates to:
  /// **'Second Intermediate Stations'**
  String get secondIntermediateStations;

  /// No description provided for @thirdTake.
  ///
  /// In en, this message translates to:
  /// **'Third take'**
  String get thirdTake;

  /// No description provided for @thirdDirection.
  ///
  /// In en, this message translates to:
  /// **'Third Direction'**
  String get thirdDirection;

  /// No description provided for @thirdDeparture.
  ///
  /// In en, this message translates to:
  /// **'Third Departure'**
  String get thirdDeparture;

  /// No description provided for @thirdArrival.
  ///
  /// In en, this message translates to:
  /// **'Third Arrival'**
  String get thirdArrival;

  /// No description provided for @thirdIntermediateStations.
  ///
  /// In en, this message translates to:
  /// **'Third Intermediate Stations'**
  String get thirdIntermediateStations;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get error;

  /// No description provided for @mustTypeDestination.
  ///
  /// In en, this message translates to:
  /// **'Must type a destination first.'**
  String get mustTypeDestination;

  /// No description provided for @noRoutesFound.
  ///
  /// In en, this message translates to:
  /// **'No routes found'**
  String get noRoutesFound;

  /// No description provided for @routeDetails.
  ///
  /// In en, this message translates to:
  /// **'Route Details'**
  String get routeDetails;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure: '**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival: '**
  String get arrival;

  /// No description provided for @take.
  ///
  /// In en, this message translates to:
  /// **'Take: '**
  String get take;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction: '**
  String get direction;

  /// No description provided for @intermediateStations.
  ///
  /// In en, this message translates to:
  /// **'Intermediate Stations:'**
  String get intermediateStations;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'{price} EGP'**
  String egp(Object price);

  /// No description provided for @travelTime.
  ///
  /// In en, this message translates to:
  /// **'{time}'**
  String travelTime(Object time);

  /// No description provided for @showStations.
  ///
  /// In en, this message translates to:
  /// **'Show Stations'**
  String get showStations;

  /// No description provided for @hideStations.
  ///
  /// In en, this message translates to:
  /// **'Hide Stations'**
  String get hideStations;

  /// No description provided for @showRoute.
  ///
  /// In en, this message translates to:
  /// **'Show Route'**
  String get showRoute;

  /// No description provided for @metro1.
  ///
  /// In en, this message translates to:
  /// **'Metro Line 1'**
  String get metro1;

  /// No description provided for @metro2.
  ///
  /// In en, this message translates to:
  /// **'Metro Line 2'**
  String get metro2;

  /// No description provided for @metro3branch1.
  ///
  /// In en, this message translates to:
  /// **'Metro Line 3 Branch ROD EL FARAG AXIS'**
  String get metro3branch1;

  /// No description provided for @metro3branch2.
  ///
  /// In en, this message translates to:
  /// **'Metro Line 3 Branch CAIRO UNIVERSITY '**
  String get metro3branch2;

  /// No description provided for @distanceToStation.
  ///
  /// In en, this message translates to:
  /// **'The distance to {stationName} is {distance} meters'**
  String distanceToStation(Object distance, Object stationName);

  /// No description provided for @reachedStation.
  ///
  /// In en, this message translates to:
  /// **'You have reached {stationName}'**
  String reachedStation(Object stationName);

  /// No description provided for @nextStation.
  ///
  /// In en, this message translates to:
  /// **'Current station is {currentStationName} and next station is {nextStationName}'**
  String nextStation(Object currentStationName, Object nextStationName);

  /// No description provided for @changeLineAt.
  ///
  /// In en, this message translates to:
  /// **'Current station is {currentStationName} and next station is {nextStationName} you will change to  {lineName} direction {direction}'**
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName);

  /// No description provided for @finalStation.
  ///
  /// In en, this message translates to:
  /// **'Current station is {currentStationName} and next station is {nextStationName} it is your arrival station'**
  String finalStation(Object currentStationName, Object nextStationName);

  /// No description provided for @finalStationReached.
  ///
  /// In en, this message translates to:
  /// **'Reached arrival station, trip completed'**
  String get finalStationReached;

  /// No description provided for @exchangeStation.
  ///
  /// In en, this message translates to:
  /// **'Exchange Station'**
  String get exchangeStation;

  /// No description provided for @intermediateStationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Intermediate Stations'**
  String get intermediateStationsTitle;

  /// No description provided for @metroStationHELWAN.
  ///
  /// In en, this message translates to:
  /// **'HELWAN'**
  String get metroStationHELWAN;

  /// No description provided for @metroStationAIN_HELWAN.
  ///
  /// In en, this message translates to:
  /// **'AIN HELWAN'**
  String get metroStationAIN_HELWAN;

  /// No description provided for @metroStationHELWAN_UNIVERSITY.
  ///
  /// In en, this message translates to:
  /// **'HELWAN UNIVERSITY'**
  String get metroStationHELWAN_UNIVERSITY;

  /// No description provided for @metroStationWADI_HOF.
  ///
  /// In en, this message translates to:
  /// **'WADI HOF'**
  String get metroStationWADI_HOF;

  /// No description provided for @metroStationHADAYEK_HELWAN.
  ///
  /// In en, this message translates to:
  /// **'HADAYEK HELWAN'**
  String get metroStationHADAYEK_HELWAN;

  /// No description provided for @metroStationEL_MAASARA.
  ///
  /// In en, this message translates to:
  /// **'EL-MAASARA'**
  String get metroStationEL_MAASARA;

  /// No description provided for @metroStationTORA_EL_ASMANT.
  ///
  /// In en, this message translates to:
  /// **'TORA EL-ASMANT'**
  String get metroStationTORA_EL_ASMANT;

  /// No description provided for @metroStationKOZZIKA.
  ///
  /// In en, this message translates to:
  /// **'KOZZIKA'**
  String get metroStationKOZZIKA;

  /// No description provided for @metroStationTORA_EL_BALAD.
  ///
  /// In en, this message translates to:
  /// **'TORA EL-BALAD'**
  String get metroStationTORA_EL_BALAD;

  /// No description provided for @metroStationTHAKANAT_EL_MAADI.
  ///
  /// In en, this message translates to:
  /// **'THAKANAT EL-MAADI'**
  String get metroStationTHAKANAT_EL_MAADI;

  /// No description provided for @metroStationMAADI.
  ///
  /// In en, this message translates to:
  /// **'MAADI'**
  String get metroStationMAADI;

  /// No description provided for @metroStationHADAYEK_EL_MAADI.
  ///
  /// In en, this message translates to:
  /// **'HADAYEK EL-MAADI'**
  String get metroStationHADAYEK_EL_MAADI;

  /// No description provided for @metroStationDAR_EL_SALAM.
  ///
  /// In en, this message translates to:
  /// **'DAR EL-SALAM'**
  String get metroStationDAR_EL_SALAM;

  /// No description provided for @metroStationEL_ZAHRAA.
  ///
  /// In en, this message translates to:
  /// **'EL-ZAHRAA'**
  String get metroStationEL_ZAHRAA;

  /// No description provided for @metroStationMAR_GIRGIS.
  ///
  /// In en, this message translates to:
  /// **'MAR GIRGIS'**
  String get metroStationMAR_GIRGIS;

  /// No description provided for @metroStationEL_MALEK_EL_SALEH.
  ///
  /// In en, this message translates to:
  /// **'EL-MALEK EL-SALEH'**
  String get metroStationEL_MALEK_EL_SALEH;

  /// No description provided for @metroStationSAYEDA_ZEINAB.
  ///
  /// In en, this message translates to:
  /// **'SAYEDA ZEINAB'**
  String get metroStationSAYEDA_ZEINAB;

  /// No description provided for @metroStationSAAD_ZAGHLOUL.
  ///
  /// In en, this message translates to:
  /// **'SAAD ZAGHLOUL'**
  String get metroStationSAAD_ZAGHLOUL;

  /// No description provided for @metroStationSADAT.
  ///
  /// In en, this message translates to:
  /// **'SADAT'**
  String get metroStationSADAT;

  /// No description provided for @metroStationGAMAL_ABD_EL_NASSER.
  ///
  /// In en, this message translates to:
  /// **'GAMAL ABD EL-NASSER'**
  String get metroStationGAMAL_ABD_EL_NASSER;

  /// No description provided for @metroStationORABI.
  ///
  /// In en, this message translates to:
  /// **'ORABI'**
  String get metroStationORABI;

  /// No description provided for @metroStationEL_SHOHADAAH.
  ///
  /// In en, this message translates to:
  /// **'EL-SHOHADAAH'**
  String get metroStationEL_SHOHADAAH;

  /// No description provided for @metroStationGHAMRA.
  ///
  /// In en, this message translates to:
  /// **'GHAMRA'**
  String get metroStationGHAMRA;

  /// No description provided for @metroStationEL_DEMERDASH.
  ///
  /// In en, this message translates to:
  /// **'EL-DEMERDASH'**
  String get metroStationEL_DEMERDASH;

  /// No description provided for @metroStationMANSHIET_EL_SADR.
  ///
  /// In en, this message translates to:
  /// **'MANSHIET EL-SADR'**
  String get metroStationMANSHIET_EL_SADR;

  /// No description provided for @metroStationKOBRI_EL_QOBBA.
  ///
  /// In en, this message translates to:
  /// **'KOBRI EL-QOBBA'**
  String get metroStationKOBRI_EL_QOBBA;

  /// No description provided for @metroStationHAMMAMAT_EL_QOBBA.
  ///
  /// In en, this message translates to:
  /// **'HAMMAMAT EL-QOBBA'**
  String get metroStationHAMMAMAT_EL_QOBBA;

  /// No description provided for @metroStationSARAY_EL_QOBBA.
  ///
  /// In en, this message translates to:
  /// **'SARAY EL-QOBBA'**
  String get metroStationSARAY_EL_QOBBA;

  /// No description provided for @metroStationHADAYEK_EL_ZAITOUN.
  ///
  /// In en, this message translates to:
  /// **'HADAYEK EL-ZAITOUN'**
  String get metroStationHADAYEK_EL_ZAITOUN;

  /// No description provided for @metroStationHELMEYET_EL_ZAITOUN.
  ///
  /// In en, this message translates to:
  /// **'HELMEYET EL-ZAITOUN'**
  String get metroStationHELMEYET_EL_ZAITOUN;

  /// No description provided for @metroStationEL_MATARYA.
  ///
  /// In en, this message translates to:
  /// **'EL-MATARYA'**
  String get metroStationEL_MATARYA;

  /// No description provided for @metroStationAIN_SHAMS.
  ///
  /// In en, this message translates to:
  /// **'AIN SHAMS'**
  String get metroStationAIN_SHAMS;

  /// No description provided for @metroStationEZBET_EL_NAKHL.
  ///
  /// In en, this message translates to:
  /// **'EZBET EL-NAKHL'**
  String get metroStationEZBET_EL_NAKHL;

  /// No description provided for @metroStationEL_MARG.
  ///
  /// In en, this message translates to:
  /// **'EL-MARG'**
  String get metroStationEL_MARG;

  /// No description provided for @metroStationNEW_EL_MARG.
  ///
  /// In en, this message translates to:
  /// **'NEW EL-MARG'**
  String get metroStationNEW_EL_MARG;

  /// No description provided for @metroStationEL_MOUNIB.
  ///
  /// In en, this message translates to:
  /// **'EL-MOUNIB'**
  String get metroStationEL_MOUNIB;

  /// No description provided for @metroStationSAQYET_MAKKI.
  ///
  /// In en, this message translates to:
  /// **'SAQYET MAKKI'**
  String get metroStationSAQYET_MAKKI;

  /// No description provided for @metroStationOM_EL_MASRYEEN.
  ///
  /// In en, this message translates to:
  /// **'OM EL-MASRYEEN'**
  String get metroStationOM_EL_MASRYEEN;

  /// No description provided for @metroStationGIZA.
  ///
  /// In en, this message translates to:
  /// **'GIZA'**
  String get metroStationGIZA;

  /// No description provided for @metroStationFEISAL.
  ///
  /// In en, this message translates to:
  /// **'FEISAL'**
  String get metroStationFEISAL;

  /// No description provided for @metroStationCAIRO_UNIVERSITY.
  ///
  /// In en, this message translates to:
  /// **'CAIRO UNIVERSITY'**
  String get metroStationCAIRO_UNIVERSITY;

  /// No description provided for @metroStationEL_BEHOUS.
  ///
  /// In en, this message translates to:
  /// **'EL-BEHOUS'**
  String get metroStationEL_BEHOUS;

  /// No description provided for @metroStationEL_DOKKI.
  ///
  /// In en, this message translates to:
  /// **'EL-DOKKI'**
  String get metroStationEL_DOKKI;

  /// No description provided for @metroStationOPERA.
  ///
  /// In en, this message translates to:
  /// **'OPERA'**
  String get metroStationOPERA;

  /// No description provided for @metroStationMOHAMED_NAGUIB.
  ///
  /// In en, this message translates to:
  /// **'MOHAMED NAGUIB'**
  String get metroStationMOHAMED_NAGUIB;

  /// No description provided for @metroStationATABA.
  ///
  /// In en, this message translates to:
  /// **'ATABA'**
  String get metroStationATABA;

  /// No description provided for @metroStationMASARA.
  ///
  /// In en, this message translates to:
  /// **'MASARA'**
  String get metroStationMASARA;

  /// No description provided for @metroStationROUD_EL_FARAG.
  ///
  /// In en, this message translates to:
  /// **'ROUD EL-FARAG'**
  String get metroStationROUD_EL_FARAG;

  /// No description provided for @metroStationSAINT_TERESA.
  ///
  /// In en, this message translates to:
  /// **'SAINT TERESA'**
  String get metroStationSAINT_TERESA;

  /// No description provided for @metroStationKHALAFAWEY.
  ///
  /// In en, this message translates to:
  /// **'KHALAFAWEY'**
  String get metroStationKHALAFAWEY;

  /// No description provided for @metroStationMEZALLAT.
  ///
  /// In en, this message translates to:
  /// **'MEZALLAT'**
  String get metroStationMEZALLAT;

  /// No description provided for @metroStationKOLLEYET_EL_ZERA3A.
  ///
  /// In en, this message translates to:
  /// **'KOLLEYET EL-ZERA3A'**
  String get metroStationKOLLEYET_EL_ZERA3A;

  /// No description provided for @metroStationSHOUBRA_EL_KHEIMA.
  ///
  /// In en, this message translates to:
  /// **'SHOUBRA EL-KHEIMA'**
  String get metroStationSHOUBRA_EL_KHEIMA;

  /// No description provided for @metroStationADLY_MANSOUR.
  ///
  /// In en, this message translates to:
  /// **'ADLY MANSOUR'**
  String get metroStationADLY_MANSOUR;

  /// No description provided for @metroStationEL_HAYKSTEP.
  ///
  /// In en, this message translates to:
  /// **'EL-HAYKSTEP'**
  String get metroStationEL_HAYKSTEP;

  /// No description provided for @metroStationOMAR_IBN_EL_KHATTAB.
  ///
  /// In en, this message translates to:
  /// **'OMAR IBN EL-KHATTAB'**
  String get metroStationOMAR_IBN_EL_KHATTAB;

  /// No description provided for @metroStationQOBA.
  ///
  /// In en, this message translates to:
  /// **'QOBA'**
  String get metroStationQOBA;

  /// No description provided for @metroStationHESHAM_BARAKAT.
  ///
  /// In en, this message translates to:
  /// **'HESHAM BARAKAT'**
  String get metroStationHESHAM_BARAKAT;

  /// No description provided for @metroStationEL_NOZHA.
  ///
  /// In en, this message translates to:
  /// **'EL-NOZHA'**
  String get metroStationEL_NOZHA;

  /// No description provided for @metroStationNADI_EL_SHAMS.
  ///
  /// In en, this message translates to:
  /// **'NADI EL-SHAMS'**
  String get metroStationNADI_EL_SHAMS;

  /// No description provided for @metroStationALF_MASKAN.
  ///
  /// In en, this message translates to:
  /// **'ALF MASKAN'**
  String get metroStationALF_MASKAN;

  /// No description provided for @metroStationHELIOPOLIS.
  ///
  /// In en, this message translates to:
  /// **'HELIOPOLIS'**
  String get metroStationHELIOPOLIS;

  /// No description provided for @metroStationHAROUN.
  ///
  /// In en, this message translates to:
  /// **'HAROUN'**
  String get metroStationHAROUN;

  /// No description provided for @metroStationEL_AHRAM.
  ///
  /// In en, this message translates to:
  /// **'EL-AHRAM'**
  String get metroStationEL_AHRAM;

  /// No description provided for @metroStationKOLLEYET_EL_BANAT.
  ///
  /// In en, this message translates to:
  /// **'KOLLEYET EL-BANAT'**
  String get metroStationKOLLEYET_EL_BANAT;

  /// No description provided for @metroStationEL_ESTAD.
  ///
  /// In en, this message translates to:
  /// **'EL-ESTAD'**
  String get metroStationEL_ESTAD;

  /// No description provided for @metroStationARD_EL_MAARD.
  ///
  /// In en, this message translates to:
  /// **'ARD EL-MAARD'**
  String get metroStationARD_EL_MAARD;

  /// No description provided for @metroStationABASIA.
  ///
  /// In en, this message translates to:
  /// **'ABASIA'**
  String get metroStationABASIA;

  /// No description provided for @metroStationABDO_BASHA.
  ///
  /// In en, this message translates to:
  /// **'ABDO BASHA'**
  String get metroStationABDO_BASHA;

  /// No description provided for @metroStationEL_GEISH.
  ///
  /// In en, this message translates to:
  /// **'EL-GEISH'**
  String get metroStationEL_GEISH;

  /// No description provided for @metroStationBAB_EL_SHARIA.
  ///
  /// In en, this message translates to:
  /// **'BAB EL-SHARIA'**
  String get metroStationBAB_EL_SHARIA;

  /// No description provided for @metroStationMASPERO.
  ///
  /// In en, this message translates to:
  /// **'MASPERO'**
  String get metroStationMASPERO;

  /// No description provided for @metroStationSAFAA_HEGAZI.
  ///
  /// In en, this message translates to:
  /// **'SAFAA HEGAZI'**
  String get metroStationSAFAA_HEGAZI;

  /// No description provided for @metroStationKIT_KAT.
  ///
  /// In en, this message translates to:
  /// **'KIT KAT'**
  String get metroStationKIT_KAT;

  /// No description provided for @metroStationSUDAN.
  ///
  /// In en, this message translates to:
  /// **'SUDAN'**
  String get metroStationSUDAN;

  /// No description provided for @metroStationIMBABA.
  ///
  /// In en, this message translates to:
  /// **'IMBABA'**
  String get metroStationIMBABA;

  /// No description provided for @metroStationEL_BOHY.
  ///
  /// In en, this message translates to:
  /// **'EL-BOHY'**
  String get metroStationEL_BOHY;

  /// No description provided for @metroStationEL_QAWMEYA.
  ///
  /// In en, this message translates to:
  /// **'EL-QAWMEYA'**
  String get metroStationEL_QAWMEYA;

  /// No description provided for @metroStationEL_TARIQ_EL_DAIRY.
  ///
  /// In en, this message translates to:
  /// **'EL-TARIQ EL-DAIRY'**
  String get metroStationEL_TARIQ_EL_DAIRY;

  /// No description provided for @metroStationROD_EL_FARAG_AXIS.
  ///
  /// In en, this message translates to:
  /// **'ROD EL-FARAG AXIS'**
  String get metroStationROD_EL_FARAG_AXIS;

  /// No description provided for @metroStationEL_TOUFIQIA.
  ///
  /// In en, this message translates to:
  /// **'EL-TOUFIQIA'**
  String get metroStationEL_TOUFIQIA;

  /// No description provided for @metroStationWADI_EL_NIL.
  ///
  /// In en, this message translates to:
  /// **'WADI EL-NIL'**
  String get metroStationWADI_EL_NIL;

  /// No description provided for @metroStationGAMAET_EL_DOWL_EL_ARABIA.
  ///
  /// In en, this message translates to:
  /// **'GAMAET EL-DOWL EL-ARABIA'**
  String get metroStationGAMAET_EL_DOWL_EL_ARABIA;

  /// No description provided for @metroStationBOLAK_EL_DAKROUR.
  ///
  /// In en, this message translates to:
  /// **'BOLAK EL-DAKROUR'**
  String get metroStationBOLAK_EL_DAKROUR;

  /// No description provided for @en_metroStationADLY_MANSOUR.
  ///
  /// In en, this message translates to:
  /// **'ADLY MANSOUR'**
  String get en_metroStationADLY_MANSOUR;

  /// No description provided for @en_metroStationEL_HAYKSTEP.
  ///
  /// In en, this message translates to:
  /// **'EL-HAYKSTEP'**
  String get en_metroStationEL_HAYKSTEP;

  /// No description provided for @en_metroStationOMAR_IBN_EL_KHATTAB.
  ///
  /// In en, this message translates to:
  /// **'OMAR IBN EL-KHATTAB'**
  String get en_metroStationOMAR_IBN_EL_KHATTAB;

  /// No description provided for @en_metroStationQOBA.
  ///
  /// In en, this message translates to:
  /// **'QOBA'**
  String get en_metroStationQOBA;

  /// No description provided for @en_metroStationHESHAM_BARAKAT.
  ///
  /// In en, this message translates to:
  /// **'HESHAM BARAKAT'**
  String get en_metroStationHESHAM_BARAKAT;

  /// No description provided for @en_metroStationEL_NOZHA.
  ///
  /// In en, this message translates to:
  /// **'EL-NOZHA'**
  String get en_metroStationEL_NOZHA;

  /// No description provided for @en_metroStationNADI_EL_SHAMS.
  ///
  /// In en, this message translates to:
  /// **'NADI EL-SHAMS'**
  String get en_metroStationNADI_EL_SHAMS;

  /// No description provided for @en_metroStationALF_MASKAN.
  ///
  /// In en, this message translates to:
  /// **'ALF MASKAN'**
  String get en_metroStationALF_MASKAN;

  /// No description provided for @en_metroStationHELIOPOLIS.
  ///
  /// In en, this message translates to:
  /// **'HELIOPOLIS'**
  String get en_metroStationHELIOPOLIS;

  /// No description provided for @en_metroStationHAROUN.
  ///
  /// In en, this message translates to:
  /// **'HAROUN'**
  String get en_metroStationHAROUN;

  /// No description provided for @en_metroStationEL_AHRAM.
  ///
  /// In en, this message translates to:
  /// **'EL-AHRAM'**
  String get en_metroStationEL_AHRAM;

  /// No description provided for @en_metroStationKOLLEYET_EL_BANAT.
  ///
  /// In en, this message translates to:
  /// **'KOLLEYET EL-BANAT'**
  String get en_metroStationKOLLEYET_EL_BANAT;

  /// No description provided for @en_metroStationEL_ESTAD.
  ///
  /// In en, this message translates to:
  /// **'EL-ESTAD'**
  String get en_metroStationEL_ESTAD;

  /// No description provided for @en_metroStationARD_EL_MAARD.
  ///
  /// In en, this message translates to:
  /// **'ARD EL-MAARD'**
  String get en_metroStationARD_EL_MAARD;

  /// No description provided for @en_metroStationABASIA.
  ///
  /// In en, this message translates to:
  /// **'ABASIA'**
  String get en_metroStationABASIA;

  /// No description provided for @en_metroStationABDO_BASHA.
  ///
  /// In en, this message translates to:
  /// **'ABDO BASHA'**
  String get en_metroStationABDO_BASHA;

  /// No description provided for @en_metroStationEL_GEISH.
  ///
  /// In en, this message translates to:
  /// **'EL-GEISH'**
  String get en_metroStationEL_GEISH;

  /// No description provided for @en_metroStationBAB_EL_SHARIA.
  ///
  /// In en, this message translates to:
  /// **'BAB EL-SHARIA'**
  String get en_metroStationBAB_EL_SHARIA;

  /// No description provided for @en_metroStationATABA.
  ///
  /// In en, this message translates to:
  /// **'ATABA'**
  String get en_metroStationATABA;

  /// No description provided for @en_metroStationGAMAL_ABD_EL_NASSER.
  ///
  /// In en, this message translates to:
  /// **'GAMAL ABD EL-NASSER'**
  String get en_metroStationGAMAL_ABD_EL_NASSER;

  /// No description provided for @en_metroStationMASPERO.
  ///
  /// In en, this message translates to:
  /// **'MASPERO'**
  String get en_metroStationMASPERO;

  /// No description provided for @en_metroStationSAFAA_HEGAZI.
  ///
  /// In en, this message translates to:
  /// **'SAFAA HEGAZI'**
  String get en_metroStationSAFAA_HEGAZI;

  /// No description provided for @en_metroStationKIT_KAT.
  ///
  /// In en, this message translates to:
  /// **'KIT KAT'**
  String get en_metroStationKIT_KAT;

  /// No description provided for @en_metroStationSUDAN.
  ///
  /// In en, this message translates to:
  /// **'SUDAN'**
  String get en_metroStationSUDAN;

  /// No description provided for @en_metroStationIMBABA.
  ///
  /// In en, this message translates to:
  /// **'IMBABA'**
  String get en_metroStationIMBABA;

  /// No description provided for @en_metroStationEL_BOHY.
  ///
  /// In en, this message translates to:
  /// **'EL-BOHY'**
  String get en_metroStationEL_BOHY;

  /// No description provided for @en_metroStationEL_QAWMEYA.
  ///
  /// In en, this message translates to:
  /// **'EL-QAWMEYA'**
  String get en_metroStationEL_QAWMEYA;

  /// No description provided for @en_metroStationEL_TARIQ_EL_DAIRY.
  ///
  /// In en, this message translates to:
  /// **'EL-TARIQ EL-DAIRY'**
  String get en_metroStationEL_TARIQ_EL_DAIRY;

  /// No description provided for @en_metroStationROD_EL_FARAG_AXIS.
  ///
  /// In en, this message translates to:
  /// **'ROD EL-FARAG AXIS'**
  String get en_metroStationROD_EL_FARAG_AXIS;

  /// No description provided for @en_metroStationEL_TOUFIQIA.
  ///
  /// In en, this message translates to:
  /// **'EL-TOUFIQIA'**
  String get en_metroStationEL_TOUFIQIA;

  /// No description provided for @en_metroStationWADI_EL_NIL.
  ///
  /// In en, this message translates to:
  /// **'WADI EL-NIL'**
  String get en_metroStationWADI_EL_NIL;

  /// No description provided for @en_metroStationGAMAET_EL_DOWL_EL_ARABIA.
  ///
  /// In en, this message translates to:
  /// **'GAMAET EL-DOWL EL-ARABIA'**
  String get en_metroStationGAMAET_EL_DOWL_EL_ARABIA;

  /// No description provided for @en_metroStationBOLAK_EL_DAKROUR.
  ///
  /// In en, this message translates to:
  /// **'BOLAK EL-DAKROUR'**
  String get en_metroStationBOLAK_EL_DAKROUR;

  /// No description provided for @en_metroStationCAIRO_UNIVERSITY.
  ///
  /// In en, this message translates to:
  /// **'CAIRO UNIVERSITY'**
  String get en_metroStationCAIRO_UNIVERSITY;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Cairo Metro Guide'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Metro Journey'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the best routes, nearest stations, and metro information'**
  String get welcomeSubtitle;

  /// No description provided for @planYourRoute.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Route'**
  String get planYourRoute;

  /// No description provided for @findNearestStation.
  ///
  /// In en, this message translates to:
  /// **'Find Nearest Station'**
  String get findNearestStation;

  /// No description provided for @scheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleLabel;

  /// No description provided for @metroMapLabel.
  ///
  /// In en, this message translates to:
  /// **'Metro Map'**
  String get metroMapLabel;

  /// No description provided for @appInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'About Cairo Metro Guide'**
  String get appInfoTitle;

  /// No description provided for @appInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'The official guide for Cairo Metro system. Find routes, stations, schedules and more.'**
  String get appInfoDescription;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @languageSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get languageSwitchTitle;

  /// No description provided for @routeOptions.
  ///
  /// In en, this message translates to:
  /// **'Route Options'**
  String get routeOptions;

  /// No description provided for @fastestRoute.
  ///
  /// In en, this message translates to:
  /// **'Fastest Route'**
  String get fastestRoute;

  /// No description provided for @shortestRoute.
  ///
  /// In en, this message translates to:
  /// **'Shortest Route'**
  String get shortestRoute;

  /// No description provided for @fewestTransfers.
  ///
  /// In en, this message translates to:
  /// **'Fewest Transfers'**
  String get fewestTransfers;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated Time'**
  String get estimatedTime;

  /// No description provided for @estimatedFare.
  ///
  /// In en, this message translates to:
  /// **'Estimated Fare'**
  String get estimatedFare;

  /// No description provided for @stationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stations'**
  String stationsCount(Object count);

  /// No description provided for @minutesAbbr.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesAbbr;

  /// No description provided for @exitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave App?'**
  String get exitDialogTitle;

  /// No description provided for @exitDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit\nCairo Metro Navigator?'**
  String get exitDialogSubtitle;

  /// No description provided for @exitDialogStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get exitDialogStay;

  /// No description provided for @exitDialogExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitDialogExit;

  /// No description provided for @egpCurrency.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egpCurrency;

  /// No description provided for @departureTime.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departureTime;

  /// No description provided for @arrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrivalTime;

  /// No description provided for @transferStations.
  ///
  /// In en, this message translates to:
  /// **'Transfer at:'**
  String get transferStations;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'Some features may not be available offline'**
  String get noInternetMessage;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(Object date);

  /// No description provided for @searchHistory.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get searchHistory;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No search history yet'**
  String get noHistory;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @shareRoute.
  ///
  /// In en, this message translates to:
  /// **'Share Route'**
  String get shareRoute;

  /// No description provided for @amenitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Station Amenities'**
  String get amenitiesTitle;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @toilets.
  ///
  /// In en, this message translates to:
  /// **'Toilets'**
  String get toilets;

  /// No description provided for @atm.
  ///
  /// In en, this message translates to:
  /// **'ATM'**
  String get atm;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @allLines.
  ///
  /// In en, this message translates to:
  /// **'All Lines'**
  String get allLines;

  /// No description provided for @line1.
  ///
  /// In en, this message translates to:
  /// **'Line 1'**
  String get line1;

  /// No description provided for @line2.
  ///
  /// In en, this message translates to:
  /// **'Line 2'**
  String get line2;

  /// No description provided for @line3.
  ///
  /// In en, this message translates to:
  /// **'Line 3'**
  String get line3;

  /// No description provided for @line4.
  ///
  /// In en, this message translates to:
  /// **'Line 4'**
  String get line4;

  /// No description provided for @operatingHours.
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get operatingHours;

  /// No description provided for @firstTrain.
  ///
  /// In en, this message translates to:
  /// **'First Train'**
  String get firstTrain;

  /// No description provided for @lastTrain.
  ///
  /// In en, this message translates to:
  /// **'Last Train'**
  String get lastTrain;

  /// No description provided for @peakHours.
  ///
  /// In en, this message translates to:
  /// **'Peak Hours'**
  String get peakHours;

  /// No description provided for @offPeakHours.
  ///
  /// In en, this message translates to:
  /// **'Off-Peak Hours'**
  String get offPeakHours;

  /// No description provided for @weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// No description provided for @weekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get weekend;

  /// No description provided for @holidays.
  ///
  /// In en, this message translates to:
  /// **'Holidays'**
  String get holidays;

  /// No description provided for @specialSchedule.
  ///
  /// In en, this message translates to:
  /// **'Special Schedule'**
  String get specialSchedule;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Service Alerts'**
  String get alerts;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No current service alerts'**
  String get noAlerts;

  /// No description provided for @viewAllStations.
  ///
  /// In en, this message translates to:
  /// **'View All Stations'**
  String get viewAllStations;

  /// No description provided for @nearbyStations.
  ///
  /// In en, this message translates to:
  /// **'Nearby Stations'**
  String get nearbyStations;

  /// No description provided for @distanceAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String distanceAway(Object distance);

  /// No description provided for @walkingTime.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min walk'**
  String walkingTime(Object minutes);

  /// No description provided for @metroEtiquette.
  ///
  /// In en, this message translates to:
  /// **'Metro Etiquette'**
  String get metroEtiquette;

  /// No description provided for @safetyTips.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get safetyTips;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get feedback;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate This App'**
  String get rateApp;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @recentTripsLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent Trips'**
  String get recentTripsLabel;

  /// No description provided for @favoritesLabel.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesLabel;

  /// No description provided for @metroLinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Metro Lines'**
  String get metroLinesTitle;

  /// No description provided for @line1Name.
  ///
  /// In en, this message translates to:
  /// **'Line 1'**
  String get line1Name;

  /// No description provided for @line2Name.
  ///
  /// In en, this message translates to:
  /// **'Line 2'**
  String get line2Name;

  /// No description provided for @line3Name.
  ///
  /// In en, this message translates to:
  /// **'Line 3'**
  String get line3Name;

  /// No description provided for @line4Name.
  ///
  /// In en, this message translates to:
  /// **'Line 4'**
  String get line4Name;

  /// No description provided for @stationsLabel.
  ///
  /// In en, this message translates to:
  /// **'stations'**
  String get stationsLabel;

  /// No description provided for @comingSoonLabel.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoonLabel;

  /// No description provided for @viewFullMap.
  ///
  /// In en, this message translates to:
  /// **'View Full Map'**
  String get viewFullMap;

  /// No description provided for @nearestStationFound.
  ///
  /// In en, this message translates to:
  /// **'Nearest Station Found'**
  String get nearestStationFound;

  /// No description provided for @stationFound.
  ///
  /// In en, this message translates to:
  /// **'Station Found'**
  String get stationFound;

  /// No description provided for @accessibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibilityLabel;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @allMetroLines.
  ///
  /// In en, this message translates to:
  /// **'All Metro Lines'**
  String get allMetroLines;

  /// No description provided for @aroundStationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Around Stations'**
  String get aroundStationsTitle;

  /// No description provided for @station.
  ///
  /// In en, this message translates to:
  /// **'Station'**
  String get station;

  /// No description provided for @seeFacilities.
  ///
  /// In en, this message translates to:
  /// **'See Facilities'**
  String get seeFacilities;

  /// No description provided for @subscriptionInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Ticket & Subscription Info'**
  String get subscriptionInfoTitle;

  /// No description provided for @subscriptionInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn about fares, zones and where to buy'**
  String get subscriptionInfoSubtitle;

  /// No description provided for @facilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Station Facilities'**
  String get facilitiesTitle;

  /// No description provided for @parkingTitle.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parkingTitle;

  /// No description provided for @parkingDescription.
  ///
  /// In en, this message translates to:
  /// **'Availability of parking facilities'**
  String get parkingDescription;

  /// No description provided for @toiletsTitle.
  ///
  /// In en, this message translates to:
  /// **'Toilets'**
  String get toiletsTitle;

  /// No description provided for @toiletsDescription.
  ///
  /// In en, this message translates to:
  /// **'Public restroom availability'**
  String get toiletsDescription;

  /// No description provided for @elevatorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Elevators'**
  String get elevatorsTitle;

  /// No description provided for @elevatorsDescription.
  ///
  /// In en, this message translates to:
  /// **'Accessibility elevators'**
  String get elevatorsDescription;

  /// No description provided for @shopsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get shopsTitle;

  /// No description provided for @shopsDescription.
  ///
  /// In en, this message translates to:
  /// **'Convenience stores and kiosks'**
  String get shopsDescription;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @nearbyAttractions.
  ///
  /// In en, this message translates to:
  /// **'Nearby Attractions'**
  String get nearbyAttractions;

  /// No description provided for @attraction1.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Museum'**
  String get attraction1;

  /// No description provided for @attraction2.
  ///
  /// In en, this message translates to:
  /// **'Khan El Khalili'**
  String get attraction2;

  /// No description provided for @attraction3.
  ///
  /// In en, this message translates to:
  /// **'Tahrir Square'**
  String get attraction3;

  /// No description provided for @attractionDescription.
  ///
  /// In en, this message translates to:
  /// **'One of Cairo\'s most famous landmarks, easily accessible from this station'**
  String get attractionDescription;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @walkingDistance.
  ///
  /// In en, this message translates to:
  /// **'Walking distance'**
  String get walkingDistance;

  /// No description provided for @accessibilityInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Features'**
  String get accessibilityInfoTitle;

  /// No description provided for @wheelchairTitle.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair Access'**
  String get wheelchairTitle;

  /// No description provided for @wheelchairDescription.
  ///
  /// In en, this message translates to:
  /// **'All stations have wheelchair access points'**
  String get wheelchairDescription;

  /// No description provided for @hearingImpairmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Hearing Impairment'**
  String get hearingImpairmentTitle;

  /// No description provided for @hearingImpairmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Visual indicators available for hearing impaired'**
  String get hearingImpairmentDescription;

  /// No description provided for @subscriptionTypes.
  ///
  /// In en, this message translates to:
  /// **'Subscription Types'**
  String get subscriptionTypes;

  /// No description provided for @dailyPass.
  ///
  /// In en, this message translates to:
  /// **'Daily Pass'**
  String get dailyPass;

  /// No description provided for @dailyPassDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlimited travel for one day on all lines'**
  String get dailyPassDescription;

  /// No description provided for @weeklyPass.
  ///
  /// In en, this message translates to:
  /// **'Weekly Pass'**
  String get weeklyPass;

  /// No description provided for @weeklyPassDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlimited travel for 7 days on all lines'**
  String get weeklyPassDescription;

  /// No description provided for @monthlyPass.
  ///
  /// In en, this message translates to:
  /// **'Monthly Pass'**
  String get monthlyPass;

  /// No description provided for @monthlyPassDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlimited travel for 30 days on all lines'**
  String get monthlyPassDescription;

  /// No description provided for @purchaseNow.
  ///
  /// In en, this message translates to:
  /// **'Purchase Now'**
  String get purchaseNow;

  /// No description provided for @zonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fare Zones'**
  String get zonesTitle;

  /// No description provided for @zonesDescription.
  ///
  /// In en, this message translates to:
  /// **'Cairo Metro is divided into fare zones. The price depends on how many zones you travel through.'**
  String get zonesDescription;

  /// No description provided for @whereToBuyTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to Buy'**
  String get whereToBuyTitle;

  /// No description provided for @metroStations.
  ///
  /// In en, this message translates to:
  /// **'Metro Stations'**
  String get metroStations;

  /// No description provided for @metroStationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Available at ticket offices in all stations'**
  String get metroStationsDescription;

  /// No description provided for @authorizedVendors.
  ///
  /// In en, this message translates to:
  /// **'Authorized Vendors'**
  String get authorizedVendors;

  /// No description provided for @authorizedVendorsDescription.
  ///
  /// In en, this message translates to:
  /// **'Selected kiosks and shops near stations'**
  String get authorizedVendorsDescription;

  /// No description provided for @touristGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Tourist Guide'**
  String get touristGuideTitle;

  /// No description provided for @popularDestinations.
  ///
  /// In en, this message translates to:
  /// **'Popular Destinations'**
  String get popularDestinations;

  /// No description provided for @pyramidsTitle.
  ///
  /// In en, this message translates to:
  /// **'The Pyramids'**
  String get pyramidsTitle;

  /// No description provided for @pyramidsDescription.
  ///
  /// In en, this message translates to:
  /// **'The last remaining wonder of the ancient world'**
  String get pyramidsDescription;

  /// No description provided for @egyptianMuseumTitle.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Museum'**
  String get egyptianMuseumTitle;

  /// No description provided for @egyptianMuseumDescription.
  ///
  /// In en, this message translates to:
  /// **'Home to the world\'s largest collection of Pharaonic antiquities'**
  String get egyptianMuseumDescription;

  /// No description provided for @khanElKhaliliTitle.
  ///
  /// In en, this message translates to:
  /// **'Khan El Khalili'**
  String get khanElKhaliliTitle;

  /// No description provided for @khanElKhaliliDescription.
  ///
  /// In en, this message translates to:
  /// **'Historic market dating back to 1382'**
  String get khanElKhaliliDescription;

  /// No description provided for @essentialPhrases.
  ///
  /// In en, this message translates to:
  /// **'Essential Arabic Phrases'**
  String get essentialPhrases;

  /// No description provided for @phrase1.
  ///
  /// In en, this message translates to:
  /// **'How much is the ticket?'**
  String get phrase1;

  /// No description provided for @phrase1Translation.
  ///
  /// In en, this message translates to:
  /// **'بكام التذكرة؟ (Bikam el-tazkara?)'**
  String get phrase1Translation;

  /// No description provided for @phrase2.
  ///
  /// In en, this message translates to:
  /// **'Where is the metro station?'**
  String get phrase2;

  /// No description provided for @phrase2Translation.
  ///
  /// In en, this message translates to:
  /// **'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)'**
  String get phrase2Translation;

  /// No description provided for @phrase3.
  ///
  /// In en, this message translates to:
  /// **'Does this go to...?'**
  String get phrase3;

  /// No description provided for @phrase3Translation.
  ///
  /// In en, this message translates to:
  /// **'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)'**
  String get phrase3Translation;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Travel Tips'**
  String get tipsTitle;

  /// No description provided for @peakHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Peak Hours'**
  String get peakHoursTitle;

  /// No description provided for @peakHoursDescription.
  ///
  /// In en, this message translates to:
  /// **'Avoid 7-9am and 3-6pm for less crowded trains'**
  String get peakHoursDescription;

  /// No description provided for @safetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safetyTitle;

  /// No description provided for @safetyDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep valuables secure and be aware of your surroundings'**
  String get safetyDescription;

  /// No description provided for @ticketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get ticketsTitle;

  /// No description provided for @ticketsDescription.
  ///
  /// In en, this message translates to:
  /// **'Always keep your ticket until you exit the station'**
  String get ticketsDescription;

  /// No description provided for @lengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get lengthLabel;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @whereToBuyDescription.
  ///
  /// In en, this message translates to:
  /// **'Find where to buy tickets, recharge your wallet card or subscribe to monthly/quarterly/annual Seasonal cards'**
  String get whereToBuyDescription;

  /// No description provided for @ticketsBullet1.
  ///
  /// In en, this message translates to:
  /// **'Available at all ticket offices'**
  String get ticketsBullet1;

  /// No description provided for @ticketsBullet2.
  ///
  /// In en, this message translates to:
  /// **'Public tickets available at vending machines (Haroun to Adly Mansour stations)'**
  String get ticketsBullet2;

  /// No description provided for @ticketsBullet3.
  ///
  /// In en, this message translates to:
  /// **'Types: Public, Elderly, Special Needs'**
  String get ticketsBullet3;

  /// No description provided for @walletCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet Card'**
  String get walletCardTitle;

  /// No description provided for @walletBullet1.
  ///
  /// In en, this message translates to:
  /// **'Available at all ticket offices and vending machines (Haroun to Adly Mansour)'**
  String get walletBullet1;

  /// No description provided for @walletBullet2.
  ///
  /// In en, this message translates to:
  /// **'Card cost: 80 LE (minimum 40 LE top-up on first purchase)'**
  String get walletBullet2;

  /// No description provided for @walletBullet3.
  ///
  /// In en, this message translates to:
  /// **'Top-up range: 20 LE to 400 LE'**
  String get walletBullet3;

  /// No description provided for @walletBullet4.
  ///
  /// In en, this message translates to:
  /// **'Reusable and transferable'**
  String get walletBullet4;

  /// No description provided for @walletBullet5.
  ///
  /// In en, this message translates to:
  /// **'Saves time compared to single tickets'**
  String get walletBullet5;

  /// No description provided for @seasonalCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Card'**
  String get seasonalCardTitle;

  /// No description provided for @seasonalBullet1.
  ///
  /// In en, this message translates to:
  /// **'Available for: General Public, Students, Elderly (60+), Special Needs'**
  String get seasonalBullet1;

  /// No description provided for @requirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Requirements:'**
  String get requirementsTitle;

  /// No description provided for @seasonalBullet2.
  ///
  /// In en, this message translates to:
  /// **'Visit subscription offices at Attaba, Abbasia, Heliopolis or Adly Mansour'**
  String get seasonalBullet2;

  /// No description provided for @seasonalBullet3.
  ///
  /// In en, this message translates to:
  /// **'Provide 2 photographs (4x6 format)'**
  String get seasonalBullet3;

  /// No description provided for @additionalRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional requirements:'**
  String get additionalRequirementsTitle;

  /// No description provided for @studentReq.
  ///
  /// In en, this message translates to:
  /// **'Students: School-stamped form + ID/birth certificate + payment receipt'**
  String get studentReq;

  /// No description provided for @elderlyReq.
  ///
  /// In en, this message translates to:
  /// **'Elderly: Valid ID proving age'**
  String get elderlyReq;

  /// No description provided for @specialNeedsReq.
  ///
  /// In en, this message translates to:
  /// **'Special Needs: Government-issued ID proving status'**
  String get specialNeedsReq;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @stationDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Station Details'**
  String get stationDetailsTitle;

  /// No description provided for @stationMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Station Map'**
  String get stationMapTitle;

  /// No description provided for @allOperationalLabel.
  ///
  /// In en, this message translates to:
  /// **'All lines operational'**
  String get allOperationalLabel;

  /// No description provided for @statusLiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get statusLiveLabel;

  /// No description provided for @homepageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your smart guide for metro and LRT trips'**
  String get homepageSubtitle;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In en, this message translates to:
  /// **'Good night'**
  String get greetingNight;

  /// No description provided for @planYourRouteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the fastest route between stations'**
  String get planYourRouteSubtitle;

  /// No description provided for @recentSearchesLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearchesLabel;

  /// No description provided for @googleMapsLinkDetected.
  ///
  /// In en, this message translates to:
  /// **'Google Maps link detected'**
  String get googleMapsLinkDetected;

  /// No description provided for @pickFromMapLabel.
  ///
  /// In en, this message translates to:
  /// **'Pick from Map'**
  String get pickFromMapLabel;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActionsTitle;

  /// No description provided for @tapToLocateLabel.
  ///
  /// In en, this message translates to:
  /// **'Tap to locate nearest station'**
  String get tapToLocateLabel;

  /// No description provided for @touristHighlightsLabel.
  ///
  /// In en, this message translates to:
  /// **'tourist highlights'**
  String get touristHighlightsLabel;

  /// No description provided for @viewPlansLabel.
  ///
  /// In en, this message translates to:
  /// **'View subscription plans'**
  String get viewPlansLabel;

  /// No description provided for @lrtLineName.
  ///
  /// In en, this message translates to:
  /// **'LRT Line'**
  String get lrtLineName;

  /// No description provided for @exploreAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Area'**
  String get exploreAreaTitle;

  /// No description provided for @exploreAreaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover nearby places around metro stations'**
  String get exploreAreaSubtitle;

  /// No description provided for @tapToExploreLabel.
  ///
  /// In en, this message translates to:
  /// **'Tap station to explore'**
  String get tapToExploreLabel;

  /// No description provided for @promoMonthlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Pass'**
  String get promoMonthlyTitle;

  /// No description provided for @promoMonthlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited rides for 30 days'**
  String get promoMonthlySubtitle;

  /// No description provided for @promoMonthlyTag.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get promoMonthlyTag;

  /// No description provided for @promoStudentTitle.
  ///
  /// In en, this message translates to:
  /// **'Student Pass'**
  String get promoStudentTitle;

  /// No description provided for @promoStudentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'50% discount for students'**
  String get promoStudentSubtitle;

  /// No description provided for @promoStudentTag.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get promoStudentTag;

  /// No description provided for @promoFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Pass'**
  String get promoFamilyTitle;

  /// No description provided for @promoFamilySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Travel together, save more'**
  String get promoFamilySubtitle;

  /// No description provided for @promoFamilyTag.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get promoFamilyTag;

  /// No description provided for @buyNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNowLabel;

  /// No description provided for @locateMeLabel.
  ///
  /// In en, this message translates to:
  /// **'Locating'**
  String get locateMeLabel;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable them in Settings.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Please allow it in app settings.'**
  String get locationPermissionDenied;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location. Please try again.'**
  String get locationError;

  /// No description provided for @leaveNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Leave Now'**
  String get leaveNowLabel;

  /// No description provided for @cairoMetroNetworkLabel.
  ///
  /// In en, this message translates to:
  /// **'Cairo Metro Network'**
  String get cairoMetroNetworkLabel;

  /// No description provided for @resetViewLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset View'**
  String get resetViewLabel;

  /// No description provided for @mapLegendLabel.
  ///
  /// In en, this message translates to:
  /// **'Map Legend'**
  String get mapLegendLabel;

  /// No description provided for @searchStationsHint.
  ///
  /// In en, this message translates to:
  /// **'Search stations...'**
  String get searchStationsHint;

  /// No description provided for @noStationsFound.
  ///
  /// In en, this message translates to:
  /// **'No stations found'**
  String get noStationsFound;

  /// No description provided for @line1FullName.
  ///
  /// In en, this message translates to:
  /// **'Line 1 — Helwan / New El-Marg'**
  String get line1FullName;

  /// No description provided for @line2FullName.
  ///
  /// In en, this message translates to:
  /// **'Line 2 — Shubra El-Kheima / El-Mounib'**
  String get line2FullName;

  /// No description provided for @line3FullName.
  ///
  /// In en, this message translates to:
  /// **'Line 3 — Adly Mansour / Kit Kat'**
  String get line3FullName;

  /// No description provided for @line4FullName.
  ///
  /// In en, this message translates to:
  /// **'Line 4'**
  String get line4FullName;

  /// No description provided for @monorailEastName.
  ///
  /// In en, this message translates to:
  /// **'East Monorail'**
  String get monorailEastName;

  /// No description provided for @monorailWestName.
  ///
  /// In en, this message translates to:
  /// **'West Monorail'**
  String get monorailWestName;

  /// No description provided for @allLinesStationsLabel.
  ///
  /// In en, this message translates to:
  /// **'stations'**
  String get allLinesStationsLabel;

  /// No description provided for @underConstructionLabel.
  ///
  /// In en, this message translates to:
  /// **'Under Construction'**
  String get underConstructionLabel;

  /// No description provided for @plannedLabel.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get plannedLabel;

  /// No description provided for @transferLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferLabel;

  /// No description provided for @statusMaintenanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get statusMaintenanceLabel;

  /// No description provided for @statusDisruptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Disruption'**
  String get statusDisruptionLabel;

  /// No description provided for @crowdCalmLabel.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get crowdCalmLabel;

  /// No description provided for @crowdModerateLabel.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get crowdModerateLabel;

  /// No description provided for @crowdBusyLabel.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get crowdBusyLabel;

  /// No description provided for @locationDialogNoThanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get locationDialogNoThanks;

  /// No description provided for @locationDialogTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get locationDialogTurnOn;

  /// No description provided for @locationDialogOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get locationDialogOpenSettings;

  /// No description provided for @touristGuidePlacesCount.
  ///
  /// In en, this message translates to:
  /// **'places to explore'**
  String get touristGuidePlacesCount;

  /// No description provided for @touristGuideDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Times, distances, and details are approximate and may vary. Please verify officially before visiting.'**
  String get touristGuideDisclaimer;

  /// No description provided for @touristGuideSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search places or stations...'**
  String get touristGuideSearchHint;

  /// No description provided for @touristGuideCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get touristGuideCategoryAll;

  /// No description provided for @touristGuideNoPlaces.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get touristGuideNoPlaces;

  /// No description provided for @touristGuideNoPlacesSub.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or category'**
  String get touristGuideNoPlacesSub;

  /// No description provided for @photographyTitle.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get photographyTitle;

  /// No description provided for @photographyDescription.
  ///
  /// In en, this message translates to:
  /// **'Photography is not allowed inside metro stations. Some attractions may charge a camera fee.'**
  String get photographyDescription;

  /// No description provided for @bestTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Best Time to Visit'**
  String get bestTimeTitle;

  /// No description provided for @bestTimeDescription.
  ///
  /// In en, this message translates to:
  /// **'October to April offers the best weather. Visit outdoor sites early morning or late afternoon.'**
  String get bestTimeDescription;

  /// No description provided for @phrase4.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get phrase4;

  /// No description provided for @phrase4Translation.
  ///
  /// In en, this message translates to:
  /// **'شكراً (Shukran)'**
  String get phrase4Translation;

  /// No description provided for @phrase5.
  ///
  /// In en, this message translates to:
  /// **'How much?'**
  String get phrase5;

  /// No description provided for @phrase5Translation.
  ///
  /// In en, this message translates to:
  /// **'بكام؟ (Bikam?)'**
  String get phrase5Translation;

  /// No description provided for @phrase6.
  ///
  /// In en, this message translates to:
  /// **'Where is...?'**
  String get phrase6;

  /// No description provided for @phrase6Translation.
  ///
  /// In en, this message translates to:
  /// **'فين...؟ (Fein...?)'**
  String get phrase6Translation;

  /// No description provided for @phrase7.
  ///
  /// In en, this message translates to:
  /// **'I want to go to...'**
  String get phrase7;

  /// No description provided for @phrase7Translation.
  ///
  /// In en, this message translates to:
  /// **'أنا عايز أروح... (Ana aayez aroh...)'**
  String get phrase7Translation;

  /// No description provided for @phrase8.
  ///
  /// In en, this message translates to:
  /// **'Is it far?'**
  String get phrase8;

  /// No description provided for @phrase8Translation.
  ///
  /// In en, this message translates to:
  /// **'هو بعيد؟ (Howwa baeed?)'**
  String get phrase8Translation;

  /// No description provided for @planRoute.
  ///
  /// In en, this message translates to:
  /// **'Plan Route'**
  String get planRoute;

  /// No description provided for @lineLabel.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get lineLabel;

  /// No description provided for @categoryHistorical.
  ///
  /// In en, this message translates to:
  /// **'Historical'**
  String get categoryHistorical;

  /// No description provided for @categoryMuseum.
  ///
  /// In en, this message translates to:
  /// **'Museums'**
  String get categoryMuseum;

  /// No description provided for @categoryReligious.
  ///
  /// In en, this message translates to:
  /// **'Religious'**
  String get categoryReligious;

  /// No description provided for @categoryPark.
  ///
  /// In en, this message translates to:
  /// **'Parks'**
  String get categoryPark;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryCulture.
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get categoryCulture;

  /// No description provided for @categoryNile.
  ///
  /// In en, this message translates to:
  /// **'Nile'**
  String get categoryNile;

  /// No description provided for @categoryHiddenGem.
  ///
  /// In en, this message translates to:
  /// **'Hidden Gems'**
  String get categoryHiddenGem;

  /// No description provided for @facilityCommercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get facilityCommercial;

  /// No description provided for @facilityCultural.
  ///
  /// In en, this message translates to:
  /// **'Cultural'**
  String get facilityCultural;

  /// No description provided for @facilityEducational.
  ///
  /// In en, this message translates to:
  /// **'Educational'**
  String get facilityEducational;

  /// No description provided for @facilityLandmarks.
  ///
  /// In en, this message translates to:
  /// **'Landmarks'**
  String get facilityLandmarks;

  /// No description provided for @facilityMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get facilityMedical;

  /// No description provided for @facilityPublicInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Public Institutions'**
  String get facilityPublicInstitutions;

  /// No description provided for @facilityPublicSpaces.
  ///
  /// In en, this message translates to:
  /// **'Public Spaces'**
  String get facilityPublicSpaces;

  /// No description provided for @facilityReligious.
  ///
  /// In en, this message translates to:
  /// **'Religious'**
  String get facilityReligious;

  /// No description provided for @facilityServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get facilityServices;

  /// No description provided for @facilitySportFacilities.
  ///
  /// In en, this message translates to:
  /// **'Sport Facilities'**
  String get facilitySportFacilities;

  /// No description provided for @facilityStreets.
  ///
  /// In en, this message translates to:
  /// **'Streets'**
  String get facilityStreets;

  /// No description provided for @facilitySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search places...'**
  String get facilitySearchHint;

  /// No description provided for @facilityNoData.
  ///
  /// In en, this message translates to:
  /// **'No facility data available for this station yet'**
  String get facilityNoData;

  /// No description provided for @facilityDataSoon.
  ///
  /// In en, this message translates to:
  /// **'Data will be added soon'**
  String get facilityDataSoon;

  /// No description provided for @facilityClearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get facilityClearFilter;

  /// No description provided for @facilityPlacesCount.
  ///
  /// In en, this message translates to:
  /// **'places'**
  String get facilityPlacesCount;

  /// No description provided for @facilityZoomHint.
  ///
  /// In en, this message translates to:
  /// **'Pinch and drag to zoom'**
  String get facilityZoomHint;

  /// No description provided for @facilityCategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'categories'**
  String get facilityCategoriesLabel;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortStops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get sortStops;

  /// No description provided for @sortTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get sortTime;

  /// No description provided for @sortFare.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get sortFare;

  /// No description provided for @sortLines.
  ///
  /// In en, this message translates to:
  /// **'Lines'**
  String get sortLines;

  /// No description provided for @bestRoute.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get bestRoute;

  /// No description provided for @hideStops.
  ///
  /// In en, this message translates to:
  /// **'Hide stops'**
  String get hideStops;

  /// No description provided for @showLabel.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showLabel;

  /// No description provided for @stopsWord.
  ///
  /// In en, this message translates to:
  /// **'stops'**
  String get stopsWord;

  /// No description provided for @minuteShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minuteShort;

  /// No description provided for @detectingLocation.
  ///
  /// In en, this message translates to:
  /// **'Detecting your location...'**
  String get detectingLocation;

  /// No description provided for @tapToExplore.
  ///
  /// In en, this message translates to:
  /// **'Tap to explore'**
  String get tapToExplore;

  /// No description provided for @couldNotOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not open Google Maps'**
  String get couldNotOpenMaps;

  /// No description provided for @couldNotGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location. Check location permission.'**
  String get couldNotGetLocation;

  /// No description provided for @googleMapsLabel.
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get googleMapsLabel;

  /// No description provided for @couldNotFindNearestStation.
  ///
  /// In en, this message translates to:
  /// **'Could not find nearest station'**
  String get couldNotFindNearestStation;

  /// No description provided for @zoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoomLabel;

  /// No description provided for @transferAtStation.
  ///
  /// In en, this message translates to:
  /// **'Transfer at {station}'**
  String transferAtStation(Object station);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en', 'es', 'fr', 'it', 'ja', 'pt', 'ru', 'tr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'tr': return AppLocalizationsTr();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
