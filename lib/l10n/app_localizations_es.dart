// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get locale => 'es';

  @override
  String get departureStationTitle => 'Estación de salida';

  @override
  String get arrivalStationTitle => 'Estación de llegada';

  @override
  String get departureStationHint => 'Seleccione la estación de salida';

  @override
  String get arrivalStationHint => 'Seleccione la estación de llegada';

  @override
  String get destinationFieldLabel => 'Ingrese su destino';

  @override
  String get findButtonText => 'Buscar';

  @override
  String get showRoutesButtonText => 'Mostrar ruta';

  @override
  String get pleaseSelectDeparture => 'Por favor seleccione la estación de salida.';

  @override
  String get pleaseSelectArrival => 'Por favor seleccione la estación de llegada.';

  @override
  String get selectDifferentStations => 'Por favor seleccione estaciones diferentes.';

  @override
  String get nearestStationLabel => 'Estación más cercana';

  @override
  String get addressNotFound => 'Dirección no encontrada. Por favor intente con más detalles.';

  @override
  String get invalidDataFormat => 'Formato de datos no válido';

  @override
  String get routeToNearest => 'Ruta a la más cercana';

  @override
  String get routeToDestination => 'Ruta al destino';

  @override
  String get pleaseClickOnMyLocation => 'Por favor primero haga clic en el botón de ubicación';

  @override
  String get mustTypeADestination => 'Debe escribir un destino primero.';

  @override
  String get estimatedTravelTime => 'Tiempo de viaje estimado';

  @override
  String get ticketPrice => 'Precio del billete';

  @override
  String get noOfStations => 'Número de estaciones';

  @override
  String get changeAt => 'Cambiará en';

  @override
  String get totalTravelTime => 'Tiempo total de viaje estimado';

  @override
  String get changeTime => 'Tiempo de viaje para cambiar de línea';

  @override
  String get firstTake => 'Primer tramo';

  @override
  String get firstDirection => 'Primera dirección';

  @override
  String get firstDeparture => 'Primera salida';

  @override
  String get firstArrival => 'Primera llegada';

  @override
  String get firstIntermediateStations => 'Primeras estaciones intermedias';

  @override
  String get secondTake => 'Segundo tramo';

  @override
  String get secondDirection => 'Segunda dirección';

  @override
  String get secondDeparture => 'Segunda salida';

  @override
  String get secondArrival => 'Segunda llegada';

  @override
  String get secondIntermediateStations => 'Segundas estaciones intermedias';

  @override
  String get thirdTake => 'Tercer tramo';

  @override
  String get thirdDirection => 'Tercera dirección';

  @override
  String get thirdDeparture => 'Tercera salida';

  @override
  String get thirdArrival => 'Tercera llegada';

  @override
  String get thirdIntermediateStations => 'Terceras estaciones intermedias';

  @override
  String get error => 'Error:';

  @override
  String get mustTypeDestination => 'Debe escribir un destino primero.';

  @override
  String get noRoutesFound => 'No se encontraron rutas';

  @override
  String get routeDetails => 'Detalles de la ruta';

  @override
  String get departure => 'Salida: ';

  @override
  String get arrival => 'Llegada: ';

  @override
  String get take => 'Tomar: ';

  @override
  String get direction => 'Dirección: ';

  @override
  String get intermediateStations => 'Estaciones intermedias:';

  @override
  String egp(Object price) {
    return '$price LE';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => 'Mostrar estaciones';

  @override
  String get hideStations => 'Ocultar estaciones';

  @override
  String get showRoute => 'Mostrar ruta';

  @override
  String get metro1 => 'Línea de Metro 1';

  @override
  String get metro2 => 'Línea de Metro 2';

  @override
  String get metro3branch1 => 'Línea de Metro 3 Ramal ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => 'Línea de Metro 3 Ramal CAIRO UNIVERSITY';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return 'La distancia a $stationName es de $distance metros';
  }

  @override
  String reachedStation(Object stationName) {
    return 'Ha llegado a $stationName';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return 'Estación actual: $currentStationName, próxima estación: $nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return 'Estación actual: $currentStationName, próxima estación: $nextStationName, cambie a $lineName dirección $direction';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return 'Estación actual: $currentStationName, próxima estación: $nextStationName, es su estación de llegada';
  }

  @override
  String get finalStationReached => 'Estación de llegada alcanzada, viaje completado';

  @override
  String get exchangeStation => 'Estación de correspondencia';

  @override
  String get intermediateStationsTitle => 'Estaciones intermedias';

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
  String get appTitle => 'Guía del Metro de El Cairo';

  @override
  String get welcomeTitle => 'Planifica tu viaje en metro';

  @override
  String get welcomeSubtitle => 'Encuentra las mejores rutas, estaciones cercanas e información del metro';

  @override
  String get planYourRoute => 'Planifica tu ruta';

  @override
  String get findNearestStation => 'Encontrar estación más cercana';

  @override
  String get scheduleLabel => 'Horario del metro';

  @override
  String get metroMapLabel => 'Mapa del metro';

  @override
  String get appInfoTitle => 'Acerca de la Guía del Metro de El Cairo';

  @override
  String get appInfoDescription => 'La guía oficial del sistema de metro de El Cairo. Encuentre rutas, estaciones, horarios y más.';

  @override
  String get close => 'Cerrar';

  @override
  String get languageSwitchTitle => 'Cambiar idioma';

  @override
  String get routeOptions => 'Opciones de ruta';

  @override
  String get fastestRoute => 'Ruta más rápida';

  @override
  String get shortestRoute => 'Ruta más corta';

  @override
  String get fewestTransfers => 'Menos transbordos';

  @override
  String get estimatedTime => 'Tiempo estimado';

  @override
  String get estimatedFare => 'Tarifa estimada';

  @override
  String stationsCount(Object count) {
    return '$count estaciones';
  }

  @override
  String get minutesAbbr => 'min';

  @override
  String get exitDialogTitle => '¿Salir de la aplicación?';

  @override
  String get exitDialogSubtitle => '¿Está seguro de que desea salir de\nla Guía del Metro de El Cairo?';

  @override
  String get exitDialogStay => 'Quedarse';

  @override
  String get exitDialogExit => 'Salir';

  @override
  String get egpCurrency => 'LE';

  @override
  String get departureTime => 'Salida';

  @override
  String get arrivalTime => 'Llegada';

  @override
  String get transferStations => 'Transbordo en:';

  @override
  String get noInternetTitle => 'Sin conexión a Internet';

  @override
  String get noInternetMessage => 'Algunas funciones pueden no estar disponibles sin conexión';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get offlineMode => 'Modo sin conexión';

  @override
  String lastUpdated(Object date) {
    return 'Última actualización: $date';
  }

  @override
  String get searchHistory => 'Historial de búsqueda';

  @override
  String get clearHistory => 'Borrar historial';

  @override
  String get noHistory => 'Sin historial de búsqueda';

  @override
  String get favorites => 'Favoritos';

  @override
  String get addToFavorites => 'Añadir a favoritos';

  @override
  String get removeFromFavorites => 'Eliminar de favoritos';

  @override
  String get shareRoute => 'Compartir ruta';

  @override
  String get amenitiesTitle => 'Servicios de la estación';

  @override
  String get accessibility => 'Accesibilidad';

  @override
  String get parking => 'Aparcamiento';

  @override
  String get toilets => 'Aseos';

  @override
  String get atm => 'Cajero automático';

  @override
  String get refresh => 'Actualizar';

  @override
  String get loading => 'Cargando...';

  @override
  String get errorOccurred => 'Se ha producido un error';

  @override
  String get retry => 'Reintentar';

  @override
  String get noResults => 'No se encontraron resultados';

  @override
  String get allLines => 'Todas las líneas';

  @override
  String get line1 => 'Línea 1';

  @override
  String get line2 => 'Línea 2';

  @override
  String get line3 => 'Línea 3';

  @override
  String get line4 => 'Línea 4';

  @override
  String get operatingHours => 'Horario de funcionamiento';

  @override
  String get firstTrain => 'Primer tren';

  @override
  String get lastTrain => 'Último tren';

  @override
  String get peakHours => 'Horas punta';

  @override
  String get offPeakHours => 'Horas valle';

  @override
  String get weekdays => 'Días laborables';

  @override
  String get weekend => 'Fin de semana';

  @override
  String get holidays => 'Festivos';

  @override
  String get specialSchedule => 'Horario especial';

  @override
  String get alerts => 'Alertas de servicio';

  @override
  String get noAlerts => 'Sin alertas de servicio actuales';

  @override
  String get viewAllStations => 'Ver todas las estaciones';

  @override
  String get nearbyStations => 'Estaciones cercanas';

  @override
  String distanceAway(Object distance) {
    return '$distance km';
  }

  @override
  String walkingTime(Object minutes) {
    return '$minutes min a pie';
  }

  @override
  String get metroEtiquette => 'Normas del metro';

  @override
  String get safetyTips => 'Consejos de seguridad';

  @override
  String get feedback => 'Enviar comentarios';

  @override
  String get rateApp => 'Valorar esta aplicación';

  @override
  String get settings => 'Ajustes';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get recentTripsLabel => 'Viajes recientes';

  @override
  String get favoritesLabel => 'Favoritos';

  @override
  String get metroLinesTitle => 'Líneas de metro';

  @override
  String get line1Name => 'Línea 1';

  @override
  String get line2Name => 'Línea 2';

  @override
  String get line3Name => 'Línea 3';

  @override
  String get line4Name => 'Línea 4';

  @override
  String get stationsLabel => 'estaciones';

  @override
  String get comingSoonLabel => 'Próximamente';

  @override
  String get viewFullMap => 'Ver mapa completo';

  @override
  String get nearestStationFound => 'Estación más cercana encontrada';

  @override
  String get stationFound => 'Estación encontrada';

  @override
  String get accessibilityLabel => 'Accesibilidad';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get allMetroLines => 'Todas las líneas de metro';

  @override
  String get aroundStationsTitle => 'Alrededor de las estaciones';

  @override
  String get station => 'Estación';

  @override
  String get seeFacilities => 'Ver servicios';

  @override
  String get subscriptionInfoTitle => 'Billetes y abonos';

  @override
  String get subscriptionInfoSubtitle => 'Tarifas, zonas y dónde comprar';

  @override
  String get facilitiesTitle => 'Servicios de la estación';

  @override
  String get parkingTitle => 'Aparcamiento';

  @override
  String get parkingDescription => 'Disponibilidad de aparcamiento';

  @override
  String get toiletsTitle => 'Aseos';

  @override
  String get toiletsDescription => 'Disponibilidad de aseos públicos';

  @override
  String get elevatorsTitle => 'Ascensores';

  @override
  String get elevatorsDescription => 'Ascensores de accesibilidad';

  @override
  String get shopsTitle => 'Tiendas';

  @override
  String get shopsDescription => 'Tiendas de conveniencia y quioscos';

  @override
  String get available => 'Disponible';

  @override
  String get notAvailable => 'No disponible';

  @override
  String get nearbyAttractions => 'Atracciones cercanas';

  @override
  String get attraction1 => 'Museo Egipcio';

  @override
  String get attraction2 => 'Khan El Khalili';

  @override
  String get attraction3 => 'Plaza Tahrir';

  @override
  String get attractionDescription => 'Uno de los monumentos más famosos de El Cairo, fácilmente accesible desde esta estación';

  @override
  String get minutes => 'minutos';

  @override
  String get walkingDistance => 'A pie';

  @override
  String get accessibilityInfoTitle => 'Funciones de accesibilidad';

  @override
  String get wheelchairTitle => 'Acceso para silla de ruedas';

  @override
  String get wheelchairDescription => 'Todas las estaciones tienen acceso para silla de ruedas';

  @override
  String get hearingImpairmentTitle => 'Discapacidad auditiva';

  @override
  String get hearingImpairmentDescription => 'Indicadores visuales disponibles para personas con discapacidad auditiva';

  @override
  String get subscriptionTypes => 'Tipos de abono';

  @override
  String get dailyPass => 'Pase diario';

  @override
  String get dailyPassDescription => 'Viajes ilimitados durante un día en todas las líneas';

  @override
  String get weeklyPass => 'Pase semanal';

  @override
  String get weeklyPassDescription => 'Viajes ilimitados durante 7 días en todas las líneas';

  @override
  String get monthlyPass => 'Pase mensual';

  @override
  String get monthlyPassDescription => 'Viajes ilimitados durante 30 días en todas las líneas';

  @override
  String get purchaseNow => 'Comprar ahora';

  @override
  String get zonesTitle => 'Zonas tarifarias';

  @override
  String get zonesDescription => 'El metro de El Cairo está dividido en zonas tarifarias. El precio depende del número de zonas recorridas.';

  @override
  String get whereToBuyTitle => 'Dónde comprar';

  @override
  String get metroStations => 'Estaciones de metro';

  @override
  String get metroStationsDescription => 'Disponible en las taquillas de todas las estaciones';

  @override
  String get authorizedVendors => 'Vendedores autorizados';

  @override
  String get authorizedVendorsDescription => 'Quioscos y tiendas seleccionados cerca de las estaciones';

  @override
  String get touristGuideTitle => 'Guía turística';

  @override
  String get popularDestinations => 'Destinos populares';

  @override
  String get pyramidsTitle => 'Las Pirámides';

  @override
  String get pyramidsDescription => 'La última maravilla del mundo antiguo';

  @override
  String get egyptianMuseumTitle => 'Museo Egipcio';

  @override
  String get egyptianMuseumDescription => 'Alberga la mayor colección de antigüedades faraónicas del mundo';

  @override
  String get khanElKhaliliTitle => 'Khan El Khalili';

  @override
  String get khanElKhaliliDescription => 'Mercado histórico que data de 1382';

  @override
  String get essentialPhrases => 'Frases árabes esenciales';

  @override
  String get phrase1 => '¿Cuánto cuesta el billete?';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => '¿Dónde está la estación de metro?';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => '¿Va esto a...?';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => 'Consejos de viaje';

  @override
  String get peakHoursTitle => 'Horas punta';

  @override
  String get peakHoursDescription => 'Evite las 7-9h y las 15-18h para trenes menos concurridos';

  @override
  String get safetyTitle => 'Seguridad';

  @override
  String get safetyDescription => 'Guarde sus objetos de valor de forma segura y sea consciente de su entorno';

  @override
  String get ticketsTitle => 'Billetes';

  @override
  String get ticketsDescription => 'Conserve siempre su billete hasta que salga de la estación';

  @override
  String get lengthLabel => 'Longitud';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get whereToBuyDescription => 'Encuentre dónde comprar billetes, recargar su tarjeta o suscribirse';

  @override
  String get ticketsBullet1 => 'Disponible en todas las taquillas';

  @override
  String get ticketsBullet2 => 'Billetes públicos disponibles en máquinas expendedoras (estaciones Haroun a Adly Mansour)';

  @override
  String get ticketsBullet3 => 'Tipos: Público, Personas mayores, Necesidades especiales';

  @override
  String get walletCardTitle => 'Tarjeta monedero';

  @override
  String get walletBullet1 => 'Disponible en todas las taquillas y máquinas (Haroun a Adly Mansour)';

  @override
  String get walletBullet2 => 'Coste de la tarjeta: 80 LE (recarga mínima de 40 LE en la primera compra)';

  @override
  String get walletBullet3 => 'Rango de recarga: 20 LE a 400 LE';

  @override
  String get walletBullet4 => 'Reutilizable y transferible';

  @override
  String get walletBullet5 => 'Ahorra tiempo en comparación con billetes individuales';

  @override
  String get seasonalCardTitle => 'Tarjeta de temporada';

  @override
  String get seasonalBullet1 => 'Disponible para: Público general, Estudiantes, Personas mayores (60+), Necesidades especiales';

  @override
  String get requirementsTitle => 'Requisitos:';

  @override
  String get seasonalBullet2 => 'Visite las oficinas de abono en Attaba, Abbasia, Heliopolis o Adly Mansour';

  @override
  String get seasonalBullet3 => 'Proporcionar 2 fotografías (formato 4x6)';

  @override
  String get additionalRequirementsTitle => 'Requisitos adicionales:';

  @override
  String get studentReq => 'Estudiantes: Formulario sellado por la escuela + DNI/certificado de nacimiento + recibo de pago';

  @override
  String get elderlyReq => 'Personas mayores: Documento de identidad válido que acredite la edad';

  @override
  String get specialNeedsReq => 'Necesidades especiales: Documento de identidad gubernamental que acredite el estado';

  @override
  String get learnMore => 'Saber más';

  @override
  String get stationDetailsTitle => 'Detalles de la estación';

  @override
  String get stationMapTitle => 'Mapa de la estación';

  @override
  String get allOperationalLabel => 'Todas las líneas operativas';

  @override
  String get statusLiveLabel => 'En directo';

  @override
  String get homepageSubtitle => 'Tu guía inteligente para viajes en metro y LRT';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas tardes';

  @override
  String get greetingNight => 'Buenas noches';

  @override
  String get planYourRouteSubtitle => 'Encuentra la ruta más rápida entre estaciones';

  @override
  String get recentSearchesLabel => 'Búsquedas recientes';

  @override
  String get googleMapsLinkDetected => 'Enlace de Google Maps detectado';

  @override
  String get pickFromMapLabel => 'Elegir del mapa';

  @override
  String get quickActionsTitle => 'Acciones rápidas';

  @override
  String get tapToLocateLabel => 'Toque para localizar la estación más cercana';

  @override
  String get touristHighlightsLabel => 'lugares de interés turístico';

  @override
  String get viewPlansLabel => 'Ver planes de abono';

  @override
  String get lrtLineName => 'Línea LRT';

  @override
  String get exploreAreaTitle => 'Explorar la zona';

  @override
  String get exploreAreaSubtitle => 'Descubre lugares cercanos a las estaciones de metro';

  @override
  String get tapToExploreLabel => 'Toque una estación para explorar';

  @override
  String get promoMonthlyTitle => 'Pase mensual';

  @override
  String get promoMonthlySubtitle => 'Viajes ilimitados durante 30 días';

  @override
  String get promoMonthlyTag => 'Mejor valor';

  @override
  String get promoStudentTitle => 'Pase estudiante';

  @override
  String get promoStudentSubtitle => '50% de descuento para estudiantes';

  @override
  String get promoStudentTag => 'Estudiante';

  @override
  String get promoFamilyTitle => 'Pase familiar';

  @override
  String get promoFamilySubtitle => 'Viaja juntos, ahorra más';

  @override
  String get promoFamilyTag => 'Familia';

  @override
  String get buyNowLabel => 'Comprar ahora';

  @override
  String get locateMeLabel => 'Localizando';

  @override
  String get locationServicesDisabled => 'Los servicios de ubicación están desactivados. Por favor actívelos en Ajustes.';

  @override
  String get locationPermissionDenied => 'Permiso de ubicación denegado. Por favor permítalo en los ajustes de la aplicación.';

  @override
  String get locationError => 'No se pudo obtener su ubicación. Por favor inténtelo de nuevo.';

  @override
  String get leaveNowLabel => 'Salir ahora';

  @override
  String get cairoMetroNetworkLabel => 'Red del Metro de El Cairo';

  @override
  String get resetViewLabel => 'Restablecer vista';

  @override
  String get mapLegendLabel => 'Leyenda del mapa';

  @override
  String get searchStationsHint => 'Buscar estaciones...';

  @override
  String get noStationsFound => 'No se encontraron estaciones';

  @override
  String get line1FullName => 'Línea 1 — Helwan / New El-Marg';

  @override
  String get line2FullName => 'Línea 2 — Shubra El-Kheima / El-Mounib';

  @override
  String get line3FullName => 'Línea 3 — Adly Mansour / Kit Kat';

  @override
  String get line4FullName => 'Línea 4';

  @override
  String get monorailEastName => 'Monorraíl Este';

  @override
  String get monorailWestName => 'Monorraíl Oeste';

  @override
  String get allLinesStationsLabel => 'estaciones';

  @override
  String get underConstructionLabel => 'En construcción';

  @override
  String get plannedLabel => 'Planificado';

  @override
  String get transferLabel => 'Transbordo';

  @override
  String get statusMaintenanceLabel => 'Mantenimiento';

  @override
  String get statusDisruptionLabel => 'Interrupción';

  @override
  String get crowdCalmLabel => 'Tranquilo';

  @override
  String get crowdModerateLabel => 'Moderado';

  @override
  String get crowdBusyLabel => 'Concurrido';

  @override
  String get locationDialogNoThanks => 'No gracias';

  @override
  String get locationDialogTurnOn => 'Activar';

  @override
  String get locationDialogOpenSettings => 'Abrir ajustes';

  @override
  String get touristGuidePlacesCount => 'lugares para explorar';

  @override
  String get touristGuideDisclaimer => 'Los tiempos, distancias y detalles son aproximados y pueden variar. Por favor verifique oficialmente antes de visitar.';

  @override
  String get touristGuideSearchHint => 'Buscar lugares o estaciones...';

  @override
  String get touristGuideCategoryAll => 'Todo';

  @override
  String get touristGuideNoPlaces => 'No se encontraron lugares';

  @override
  String get touristGuideNoPlacesSub => 'Intente una búsqueda o categoría diferente';

  @override
  String get photographyTitle => 'Fotografía';

  @override
  String get photographyDescription => 'No está permitido fotografiar dentro de las estaciones de metro. Algunas atracciones pueden cobrar una tarifa por cámara.';

  @override
  String get bestTimeTitle => 'Mejor época para visitar';

  @override
  String get bestTimeDescription => 'De octubre a abril ofrece el mejor clima. Visita los sitios al aire libre temprano en la mañana o a última hora de la tarde.';

  @override
  String get phrase4 => 'Gracias';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => '¿Cuánto?';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => '¿Dónde está...?';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => 'Quiero ir a...';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => '¿Está lejos?';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => 'Planificar ruta';

  @override
  String get lineLabel => 'Línea';

  @override
  String get categoryHistorical => 'Histórico';

  @override
  String get categoryMuseum => 'Museos';

  @override
  String get categoryReligious => 'Religioso';

  @override
  String get categoryPark => 'Parques';

  @override
  String get categoryShopping => 'Compras';

  @override
  String get categoryCulture => 'Cultura';

  @override
  String get categoryNile => 'Nilo';

  @override
  String get categoryHiddenGem => 'Joyas ocultas';

  @override
  String get facilityCommercial => 'Comercial';

  @override
  String get facilityCultural => 'Cultural';

  @override
  String get facilityEducational => 'Educativo';

  @override
  String get facilityLandmarks => 'Monumentos';

  @override
  String get facilityMedical => 'Médico';

  @override
  String get facilityPublicInstitutions => 'Instituciones públicas';

  @override
  String get facilityPublicSpaces => 'Espacios públicos';

  @override
  String get facilityReligious => 'Religioso';

  @override
  String get facilityServices => 'Servicios';

  @override
  String get facilitySportFacilities => 'Instalaciones deportivas';

  @override
  String get facilityStreets => 'Calles';

  @override
  String get facilitySearchHint => 'Buscar lugares...';

  @override
  String get facilityNoData => 'No hay datos de instalaciones disponibles para esta estación todavía';

  @override
  String get facilityDataSoon => 'Los datos se añadirán pronto';

  @override
  String get facilityClearFilter => 'Borrar filtro';

  @override
  String get facilityPlacesCount => 'lugares';

  @override
  String get facilityZoomHint => 'Pellizcar y arrastrar para hacer zoom';

  @override
  String get facilityCategoriesLabel => 'categorías';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortStops => 'Paradas';

  @override
  String get sortTime => 'Tiempo';

  @override
  String get sortFare => 'Tarifa';

  @override
  String get sortLines => 'Líneas';

  @override
  String get bestRoute => 'Mejor';

  @override
  String get hideStops => 'Ocultar paradas';

  @override
  String get showLabel => 'Mostrar';

  @override
  String get stopsWord => 'paradas';

  @override
  String get minuteShort => 'min';

  @override
  String get detectingLocation => 'Detectando tu ubicación...';

  @override
  String get tapToExplore => 'Toca para explorar';

  @override
  String get couldNotOpenMaps => 'No se pudo abrir Google Maps';

  @override
  String get couldNotGetLocation => 'No se pudo obtener tu ubicación. Verifica el permiso de ubicación.';

  @override
  String get googleMapsLabel => 'Google Maps';

  @override
  String get couldNotFindNearestStation => 'No se pudo encontrar la estación más cercana';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String transferAtStation(Object station) {
    return 'Transferencia en $station';
  }

  @override String get onboardingSkip => 'Omitir';
  @override String get onboardingNext => 'Siguiente';
  @override String get onboardingGetStarted => 'Empezar';
  @override String get onboardingTitle1 => 'Planifica tu ruta';
  @override String get onboardingSubtitle1 => 'Elige estación de salida y llegada — encontramos el camino más rápido con transbordos, tiempo y tarifa en segundos.';
  @override String get onboardingTitle2 => 'Conoce las líneas';
  @override String get onboardingSubtitle2 => '3 líneas con colores distintos cubren todo El Cairo. Los íconos circulares indican estaciones de transbordo.';
  @override String get onboardingTitle3 => 'Todo en un lugar';
  @override String get onboardingSubtitle3 => 'Encuentra la estación más cercana, explora el mapa en vivo y descubre lugares cerca de cada parada.';
  @override String get onboardingLanguagePrompt => 'Elegir idioma';
  @override String get onboardingReplay => 'Repetir tour';
  @override String get onboardingLine1 => 'Línea 1 · Helwan → New El-Marg';
  @override String get onboardingLine2 => 'Línea 2 · El-Mounib → Shubra';
  @override String get onboardingLine3 => 'Línea 3 · Adly Mansour → ramales';
  @override String get onboardingTransfer => 'Estación de transbordo';
}
