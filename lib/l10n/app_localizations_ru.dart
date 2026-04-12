// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get locale => 'ru';

  @override
  String get departureStationTitle => 'Станция отправления';

  @override
  String get arrivalStationTitle => 'Станция прибытия';

  @override
  String get departureStationHint => 'Выберите станцию отправления';

  @override
  String get arrivalStationHint => 'Выберите станцию прибытия';

  @override
  String get destinationFieldLabel => 'Введите пункт назначения';

  @override
  String get findButtonText => 'Найти';

  @override
  String get showRoutesButtonText => 'Показать маршруты';

  @override
  String get pleaseSelectDeparture => 'Пожалуйста, выберите станцию отправления.';

  @override
  String get pleaseSelectArrival => 'Пожалуйста, выберите станцию прибытия.';

  @override
  String get selectDifferentStations => 'Пожалуйста, выберите разные станции.';

  @override
  String get nearestStationLabel => 'Ближайшая станция';

  @override
  String get addressNotFound => 'Адрес не найден. Попробуйте с более подробными данными.';

  @override
  String get invalidDataFormat => 'Неверный формат данных';

  @override
  String get routeToNearest => 'Маршрут к ближайшей';

  @override
  String get routeToDestination => 'Маршрут к пункту назначения';

  @override
  String get pleaseClickOnMyLocation => 'Пожалуйста, сначала нажмите кнопку местоположения';

  @override
  String get mustTypeADestination => 'Сначала введите пункт назначения.';

  @override
  String get estimatedTravelTime => 'Расчётное время в пути';

  @override
  String get ticketPrice => 'Цена билета';

  @override
  String get noOfStations => 'Количество станций';

  @override
  String get changeAt => 'Пересадка на';

  @override
  String get totalTravelTime => 'Общее расчётное время в пути';

  @override
  String get changeTime => 'Расчётное время на пересадку';

  @override
  String get firstTake => 'Первый участок';

  @override
  String get firstDirection => 'Первое направление';

  @override
  String get firstDeparture => 'Первое отправление';

  @override
  String get firstArrival => 'Первое прибытие';

  @override
  String get firstIntermediateStations => 'Первые промежуточные станции';

  @override
  String get secondTake => 'Второй участок';

  @override
  String get secondDirection => 'Второе направление';

  @override
  String get secondDeparture => 'Второе отправление';

  @override
  String get secondArrival => 'Второе прибытие';

  @override
  String get secondIntermediateStations => 'Вторые промежуточные станции';

  @override
  String get thirdTake => 'Третий участок';

  @override
  String get thirdDirection => 'Третье направление';

  @override
  String get thirdDeparture => 'Третье отправление';

  @override
  String get thirdArrival => 'Третье прибытие';

  @override
  String get thirdIntermediateStations => 'Третьи промежуточные станции';

  @override
  String get error => 'Ошибка:';

  @override
  String get mustTypeDestination => 'Сначала введите пункт назначения.';

  @override
  String get noRoutesFound => 'Маршруты не найдены';

  @override
  String get routeDetails => 'Детали маршрута';

  @override
  String get departure => 'Отправление: ';

  @override
  String get arrival => 'Прибытие: ';

  @override
  String get take => 'Сесть на: ';

  @override
  String get direction => 'Направление: ';

  @override
  String get intermediateStations => 'Промежуточные станции:';

  @override
  String egp(Object price) {
    return '$price EGP';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => 'Показать станции';

  @override
  String get hideStations => 'Скрыть станции';

  @override
  String get showRoute => 'Показать маршрут';

  @override
  String get metro1 => 'Линия метро 1';

  @override
  String get metro2 => 'Линия метро 2';

  @override
  String get metro3branch1 => 'Линия метро 3 ветка ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => 'Линия метро 3 ветка CAIRO UNIVERSITY';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return 'Расстояние до $stationName составляет $distance метров';
  }

  @override
  String reachedStation(Object stationName) {
    return 'Вы прибыли на $stationName';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return 'Текущая станция $currentStationName, следующая станция $nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return 'Текущая станция $currentStationName, следующая $nextStationName, пересадка на $lineName направление $direction';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return 'Текущая станция $currentStationName, следующая $nextStationName — ваша станция прибытия';
  }

  @override
  String get finalStationReached => 'Достигнута конечная станция, поездка завершена';

  @override
  String get exchangeStation => 'Пересадочная станция';

  @override
  String get intermediateStationsTitle => 'Промежуточные станции';

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
  String get appTitle => 'Путеводитель по метро Каира';

  @override
  String get welcomeTitle => 'Спланируйте поездку в метро';

  @override
  String get welcomeSubtitle => 'Лучшие маршруты, ближайшие станции и информация о метро';

  @override
  String get planYourRoute => 'Спланировать маршрут';

  @override
  String get findNearestStation => 'Найти станцию по адресу';

  @override
  String get scheduleLabel => 'Расписание метро';

  @override
  String get metroMapLabel => 'Карта метро';

  @override
  String get appInfoTitle => 'О путеводителе по метро Каира';

  @override
  String get appInfoDescription => 'Официальный путеводитель по метро Каира. Маршруты, станции, расписания и многое другое.';

  @override
  String get close => 'Закрыть';

  @override
  String get languageSwitchTitle => 'Изменить язык';

  @override
  String get routeOptions => 'Параметры маршрута';

  @override
  String get fastestRoute => 'Самый быстрый маршрут';

  @override
  String get shortestRoute => 'Самый короткий маршрут';

  @override
  String get fewestTransfers => 'Меньше пересадок';

  @override
  String get estimatedTime => 'Расчётное время';

  @override
  String get estimatedFare => 'Расчётная стоимость';

  @override
  String stationsCount(Object count) {
    return '$count станций';
  }

  @override
  String get minutesAbbr => 'мин';

  @override
  String get exitDialogTitle => 'Выйти из приложения?';

  @override
  String get exitDialogSubtitle => 'Вы уверены, что хотите выйти из\nпутеводителя по метро Каира?';

  @override
  String get exitDialogStay => 'Остаться';

  @override
  String get exitDialogExit => 'Выйти';

  @override
  String get egpCurrency => 'EGP';

  @override
  String get departureTime => 'Отправление';

  @override
  String get arrivalTime => 'Прибытие';

  @override
  String get transferStations => 'Пересадка на:';

  @override
  String get noInternetTitle => 'Нет подключения к интернету';

  @override
  String get noInternetMessage => 'Некоторые функции могут быть недоступны в офлайн-режиме';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get offlineMode => 'Офлайн-режим';

  @override
  String lastUpdated(Object date) {
    return 'Последнее обновление: $date';
  }

  @override
  String get searchHistory => 'История поиска';

  @override
  String get clearHistory => 'Очистить историю';

  @override
  String get noHistory => 'История поиска пуста';

  @override
  String get favorites => 'Избранное';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get removeFromFavorites => 'Удалить из избранного';

  @override
  String get shareRoute => 'Поделиться маршрутом';

  @override
  String get amenitiesTitle => 'Удобства на станции';

  @override
  String get accessibility => 'Доступность';

  @override
  String get parking => 'Парковка';

  @override
  String get toilets => 'Туалеты';

  @override
  String get atm => 'Банкомат';

  @override
  String get refresh => 'Обновить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get errorOccurred => 'Произошла ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get noResults => 'Результаты не найдены';

  @override
  String get allLines => 'Все линии';

  @override
  String get line1 => 'Линия 1';

  @override
  String get line2 => 'Линия 2';

  @override
  String get line3 => 'Линия 3';

  @override
  String get line4 => 'Линия 4';

  @override
  String get operatingHours => 'Часы работы';

  @override
  String get firstTrain => 'Первый поезд';

  @override
  String get lastTrain => 'Последний поезд';

  @override
  String get peakHours => 'Час пик';

  @override
  String get offPeakHours => 'Вне часа пик';

  @override
  String get weekdays => 'Будние дни';

  @override
  String get weekend => 'Выходные';

  @override
  String get holidays => 'Праздники';

  @override
  String get specialSchedule => 'Специальное расписание';

  @override
  String get alerts => 'Оповещения о сервисе';

  @override
  String get noAlerts => 'Нет текущих оповещений';

  @override
  String get viewAllStations => 'Просмотреть все станции';

  @override
  String get nearbyStations => 'Ближайшие станции';

  @override
  String distanceAway(Object distance) {
    return '$distance км';
  }

  @override
  String walkingTime(Object minutes) {
    return '$minutes мин пешком';
  }

  @override
  String get metroEtiquette => 'Правила поведения в метро';

  @override
  String get safetyTips => 'Советы по безопасности';

  @override
  String get feedback => 'Отправить отзыв';

  @override
  String get rateApp => 'Оценить приложение';

  @override
  String get settings => 'Настройки';

  @override
  String get notifications => 'Уведомления';

  @override
  String get darkMode => 'Тёмный режим';

  @override
  String get language => 'Язык';

  @override
  String get recentTripsLabel => 'Недавние поездки';

  @override
  String get favoritesLabel => 'Избранное';

  @override
  String get metroLinesTitle => 'Линии метро';

  @override
  String get line1Name => 'Линия 1';

  @override
  String get line2Name => 'Линия 2';

  @override
  String get line3Name => 'Линия 3';

  @override
  String get line4Name => 'Линия 4';

  @override
  String get stationsLabel => 'станций';

  @override
  String get comingSoonLabel => 'Скоро';

  @override
  String get viewFullMap => 'Полная карта';

  @override
  String get routeAllStops => 'Все остановки';

  @override
  String get nearestStationFound => 'Ближайшая станция найдена';
  String nextTrainIn(int min) => 'Следующий поезд через ~{min} мин.'.replaceAll('{min}', '$min');
  String get outsideServiceHours => 'Вне часов работы';
  String get saveRouteLabel => 'Сохранить маршрут';
  String get routeSaved => 'Добавлено в избранное';
  String get routeUnsaved => 'Удалено из избранного';
  String get nearestStationTitle => 'Ближайшая к вам станция';
  String get nearestStationSubtitle => 'Определяется автоматически по GPS';
  String get nearestStationLocating => 'Поиск ближайшей станции…';
  String get nearestStationCaption => 'Ближайшая станция метро к вашему местоположению';
  String get getDirections => 'Получить маршрут';
  String get walkingDirections => 'Пешком';
  String get drivingDirections => 'На машине';
  String get currentLocation => 'Моё местоположение';
  String get useAsDeparture => 'Использовать как отправление';

  @override
  String get stationFound => 'Станция найдена';

  @override
  String get accessibilityLabel => 'Доступность';

  @override
  String get seeAll => 'Смотреть все';

  @override
  String get allMetroLines => 'Все линии метро';

  @override
  String get aroundStationsTitle => 'Вокруг станций';

  @override
  String get station => 'Станция';

  @override
  String get seeFacilities => 'Удобства';

  @override
  String get subscriptionInfoTitle => 'Абонемент метро';

  @override
  String get subscriptionInfoSubtitle => 'О тарифах, зонах и местах покупки';

  @override
  String get facilitiesTitle => 'Удобства на станции';

  @override
  String get parkingTitle => 'Парковка';

  @override
  String get parkingDescription => 'Наличие парковочных мест';

  @override
  String get toiletsTitle => 'Туалеты';

  @override
  String get toiletsDescription => 'Наличие общественных туалетов';

  @override
  String get elevatorsTitle => 'Лифты';

  @override
  String get elevatorsDescription => 'Лифты для людей с ограниченными возможностями';

  @override
  String get shopsTitle => 'Магазины';

  @override
  String get shopsDescription => 'Киоски и небольшие магазины';

  @override
  String get available => 'Доступно';

  @override
  String get notAvailable => 'Недоступно';

  @override
  String get nearbyAttractions => 'Достопримечательности рядом';

  @override
  String get attraction1 => 'Египетский музей';

  @override
  String get attraction2 => 'Хан-эль-Халили';

  @override
  String get attraction3 => 'Площадь Тахрир';

  @override
  String get attractionDescription => 'Одна из самых известных достопримечательностей Каира, легко доступная с этой станции';

  @override
  String get minutes => 'минут';

  @override
  String get walkingDistance => 'Пешеходное расстояние';

  @override
  String get accessibilityInfoTitle => 'Возможности для людей с ограниченными возможностями';

  @override
  String get wheelchairTitle => 'Доступ для инвалидных колясок';

  @override
  String get wheelchairDescription => 'Все станции имеют пандусы для инвалидных колясок';

  @override
  String get hearingImpairmentTitle => 'Для слабослышащих';

  @override
  String get hearingImpairmentDescription => 'Визуальные указатели для слабослышащих';

  @override
  String get subscriptionTypes => 'Типы абонементов';

  @override
  String get dailyPass => 'Дневной проездной';

  @override
  String get dailyPassDescription => 'Неограниченные поездки в течение одного дня по всем линиям';

  @override
  String get weeklyPass => 'Недельный проездной';

  @override
  String get weeklyPassDescription => 'Неограниченные поездки на 7 дней по всем линиям';

  @override
  String get monthlyPass => 'Месячный проездной';

  @override
  String get monthlyPassDescription => 'Неограниченные поездки на 30 дней по всем линиям';

  @override
  String get purchaseNow => 'Купить сейчас';

  @override
  String get zonesTitle => 'Тарифные зоны';

  @override
  String get zonesDescription => 'Метро Каира разделено на тарифные зоны. Цена зависит от количества пересечённых зон.';

  @override
  String get whereToBuyTitle => 'Где купить';

  @override
  String get metroStations => 'Станции метро';

  @override
  String get metroStationsDescription => 'Доступно в кассах всех станций';

  @override
  String get authorizedVendors => 'Авторизованные продавцы';

  @override
  String get authorizedVendorsDescription => 'Выбранные киоски и магазины рядом со станциями';

  @override
  String get touristGuideTitle => 'Путеводитель';

  @override
  String get popularDestinations => 'Популярные места';

  @override
  String get pyramidsTitle => 'Пирамиды';

  @override
  String get pyramidsDescription => 'Последнее сохранившееся чудо древнего мира';

  @override
  String get egyptianMuseumTitle => 'Египетский музей';

  @override
  String get egyptianMuseumDescription => 'Крупнейшая в мире коллекция фараонских артефактов';

  @override
  String get khanElKhaliliTitle => 'Хан-эль-Халили';

  @override
  String get khanElKhaliliDescription => 'Исторический рынок, основанный в 1382 году';

  @override
  String get essentialPhrases => 'Основные арабские фразы';

  @override
  String get phrase1 => 'Сколько стоит билет?';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => 'Где станция метро?';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => 'Это идёт до...?';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => 'Советы путешественнику';

  @override
  String get peakHoursTitle => 'Час пик';

  @override
  String get peakHoursDescription => 'Избегайте 7-9 утра и 15-18 вечера для менее переполненных поездов';

  @override
  String get safetyTitle => 'Безопасность';

  @override
  String get safetyDescription => 'Берегите ценности и следите за окружением';

  @override
  String get ticketsTitle => 'Билеты';

  @override
  String get ticketsDescription => 'Держите билет до выхода со станции';

  @override
  String get lengthLabel => 'Длина';

  @override
  String get viewDetails => 'Подробнее';

  @override
  String get whereToBuyDescription => 'Купить билеты, пополнить кошелёк или оформить абонемент';

  @override
  String get ticketsBullet1 => 'Доступны в кассах всех станций';

  @override
  String get ticketsBullet2 => 'Обычные билеты в автоматах (от Haroun до Adly Mansour)';

  @override
  String get ticketsBullet3 => 'Типы: обычный, пенсионный, для людей с ОВЗ';

  @override
  String get walletCardTitle => 'Карта-кошелёк';

  @override
  String get walletBullet1 => 'Доступна в кассах и автоматах (от Haroun до Adly Mansour)';

  @override
  String get walletBullet2 => 'Стоимость карты: 80 фунтов (минимальное пополнение 40 фунтов при первой покупке)';

  @override
  String get walletBullet3 => 'Диапазон пополнения: от 20 до 400 фунтов';

  @override
  String get walletBullet4 => 'Многоразовая и передаваемая';

  @override
  String get walletBullet5 => 'Экономит время по сравнению с разовыми билетами';

  @override
  String get seasonalCardTitle => 'Сезонная карта';

  @override
  String get seasonalBullet1 => 'Для: обычных граждан, студентов, пенсионеров (60+), людей с ОВЗ';

  @override
  String get requirementsTitle => 'Требования:';

  @override
  String get seasonalBullet2 => 'Посетить офисы подписки на Attaba, Abbasia, Heliopolis или Adly Mansour';

  @override
  String get seasonalBullet3 => 'Предоставить 2 фотографии (формат 4x6)';

  @override
  String get additionalRequirementsTitle => 'Дополнительные требования:';

  @override
  String get studentReq => 'Студенты: форма со штампом школы + удостоверение/свидетельство о рождении + квитанция';

  @override
  String get elderlyReq => 'Пенсионеры: действительное удостоверение с подтверждением возраста';

  @override
  String get specialNeedsReq => 'Люди с ОВЗ: государственное удостоверение';

  @override
  String get learnMore => 'Узнать больше';

  @override
  String get stationDetailsTitle => 'Информация о станции';

  @override
  String get stationMapTitle => 'Схема станции';

  @override
  String get allOperationalLabel => 'Все линии работают';

  @override
  String get statusLiveLabel => 'Онлайн';

  @override
  String get homepageSubtitle => 'Ваш умный путеводитель по метро и LRT';

  @override
  String get greetingMorning => 'Доброе утро';

  @override
  String get greetingAfternoon => 'Добрый день';

  @override
  String get greetingEvening => 'Добрый вечер';

  @override
  String get greetingNight => 'Доброй ночи';

  @override
  String get planYourRouteSubtitle => 'Найдите самый быстрый маршрут между станциями';

  @override
  String get recentSearchesLabel => 'Недавние поиски';

  @override
  String get googleMapsLinkDetected => 'Обнаружена ссылка Google Maps';

  @override
  String get pickFromMapLabel => 'Выбрать на карте';

  @override
  String get quickActionsTitle => 'Быстрые действия';

  @override
  String get tapToLocateLabel => 'Нажмите для поиска ближайшей станции';

  @override
  String get touristHighlightsLabel => 'Туристические достопримечательности';

  @override
  String get viewPlansLabel => 'Посмотреть планы подписки';

  @override
  String get lrtLineName => 'Линия LRT';

  @override
  String get exploreAreaTitle => 'Исследовать район';

  @override
  String get exploreAreaSubtitle => 'Откройте для себя интересные места рядом со станциями метро';

  @override
  String get tapToExploreLabel => 'Нажмите на станцию для изучения';

  @override
  String get promoMonthlyTitle => 'Месячный проездной';

  @override
  String get promoMonthlySubtitle => 'Неограниченные поездки на 30 дней';

  @override
  String get promoMonthlyTag => 'Лучшая цена';

  @override
  String get promoStudentTitle => 'Студенческий проездной';

  @override
  String get promoStudentSubtitle => 'Скидка 50% для студентов';

  @override
  String get promoStudentTag => 'Студент';

  @override
  String get promoFamilyTitle => 'Семейный проездной';

  @override
  String get promoFamilySubtitle => 'Путешествуйте вместе, экономьте больше';

  @override
  String get promoFamilyTag => 'Семья';

  @override
  String get buyNowLabel => 'Купить';

  @override
  String get locateMeLabel => 'Определение местоположения';

  @override
  String get locationServicesDisabled => 'Службы геолокации отключены. Включите их в настройках.';

  @override
  String get locationPermissionDenied => 'Доступ к геолокации запрещён. Разрешите в настройках приложения.';

  @override
  String get locationError => 'Не удалось определить местоположение. Попробуйте снова.';

  @override
  String get leaveNowLabel => 'Выехать сейчас';

  @override
  String get cairoMetroNetworkLabel => 'Сеть метро Каира';

  @override
  String get resetViewLabel => 'Сбросить вид';

  @override
  String get mapViewSchematic => 'Схема';

  @override
  String get mapViewGeographic => 'Карта';

  @override
  String get mapLegendLabel => 'Легенда карты';

  @override
  String get searchStationsHint => 'Поиск станций...';

  @override
  String get noStationsFound => 'Станции не найдены';

  @override
  String get line1FullName => 'Линия 1 — Helwan / New El-Marg';

  @override
  String get line2FullName => 'Линия 2 — Shubra El-Kheima / El-Mounib';

  @override
  String get line3FullName => 'Линия 3 — Adly Mansour / Kit Kat';

  @override
  String get line4FullName => 'Линия 4';

  @override
  String get monorailEastName => 'Восточный монорельс';

  @override
  String get monorailWestName => 'Западный монорельс';

  @override
  String get allLinesStationsLabel => 'станций';

  @override
  String get underConstructionLabel => 'Строится';

  @override
  String get plannedLabel => 'Запланировано';

  @override
  String get transferLabel => 'Пересадка';

  @override
  String get statusMaintenanceLabel => 'Техобслуживание';

  @override
  String get statusDisruptionLabel => 'Сбой';

  @override
  String get crowdCalmLabel => 'Спокойно';

  @override
  String get crowdModerateLabel => 'Умеренно';

  @override
  String get crowdBusyLabel => 'Многолюдно';

  @override
  String get locationDialogNoThanks => 'Нет, спасибо';

  @override
  String get locationDialogTurnOn => 'Включить';

  @override
  String get locationDialogOpenSettings => 'Открыть настройки';

  @override
  String get touristGuidePlacesCount => 'мест для исследования';

  @override
  String get touristGuideDisclaimer => 'Время, расстояния и детали приблизительны и могут варьироваться. Пожалуйста, проверьте официально перед посещением.';

  @override
  String get touristGuideSearchHint => 'Поиск мест или станций...';

  @override
  String get touristGuideCategoryAll => 'Все';

  @override
  String get touristGuideNoPlaces => 'Места не найдены';

  @override
  String get touristGuideNoPlacesSub => 'Попробуйте другой поиск или категорию';

  @override
  String get photographyTitle => 'Фотография';

  @override
  String get photographyDescription => 'Фотографирование внутри станций метро запрещено. Некоторые достопримечательности могут взимать плату за фотосъёмку.';

  @override
  String get bestTimeTitle => 'Лучшее время для посещения';

  @override
  String get bestTimeDescription => 'С октября по апрель — лучшая погода. Посещайте уличные объекты ранним утром или поздним вечером.';

  @override
  String get phrase4 => 'Спасибо';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => 'Сколько?';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => 'Где...?';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => 'Я хочу поехать в...';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => 'Это далеко?';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => 'Построить маршрут';

  @override
  String get lineLabel => 'Линия';

  @override
  String get categoryHistorical => 'Исторический';

  @override
  String get categoryMuseum => 'Музеи';

  @override
  String get categoryReligious => 'Религиозный';

  @override
  String get categoryPark => 'Парки';

  @override
  String get categoryShopping => 'Шопинг';

  @override
  String get categoryCulture => 'Культура';

  @override
  String get categoryNile => 'Нил';

  @override
  String get categoryHiddenGem => 'Скрытые жемчужины';

  @override
  String get facilityCommercial => 'Коммерческий';

  @override
  String get facilityCultural => 'Культурный';

  @override
  String get facilityEducational => 'Образовательный';

  @override
  String get facilityLandmarks => 'Достопримечательности';

  @override
  String get facilityMedical => 'Медицинский';

  @override
  String get facilityPublicInstitutions => 'Государственные учреждения';

  @override
  String get facilityPublicSpaces => 'Общественные пространства';

  @override
  String get facilityReligious => 'Религиозный';

  @override
  String get facilityServices => 'Сервисы';

  @override
  String get facilitySportFacilities => 'Спортивные объекты';

  @override
  String get facilityStreets => 'Улицы';

  @override
  String get facilitySearchHint => 'Поиск мест...';

  @override
  String get facilityNoData => 'Данные об объектах для этой станции пока недоступны';

  @override
  String get facilityDataSoon => 'Данные будут добавлены в ближайшее время';

  @override
  String get facilityClearFilter => 'Сбросить фильтр';

  @override
  String get facilityPlacesCount => 'мест';

  @override
  String get facilityZoomHint => 'Сведите и потяните для масштабирования';

  @override
  String get facilityCategoriesLabel => 'категории';

  @override
  String get sortBy => 'Сортировать по';

  @override
  String get sortStops => 'Остановки';

  @override
  String get sortTime => 'Время';

  @override
  String get sortFare => 'Тариф';

  @override
  String get sortLines => 'Линии';

  @override
  String get bestRoute => 'Лучший';

  @override
  String get accessibleRoute => 'Доступный маршрут';

  @override
  String get routeTypeFastest => 'Быстрейший';

  @override
  String get routeTypeAccessible => 'Доступный';

  @override
  String get routeTypeFewestTransfers => 'Меньше пересадок';

  @override
  String get routeTypeAlternative => 'Альтернативный маршрут';

  @override
  String get hideStops => 'Скрыть остановки';

  @override
  String get showLabel => 'Показать';

  @override
  String get stopsWord => 'остановок';

  @override
  String get minuteShort => 'мин';

  @override
  String get detectingLocation => 'Определение вашего местоположения...';

  @override
  String get tapToExplore => 'Нажмите для изучения';

  @override
  String get couldNotOpenMaps => 'Не удалось открыть Google Карты';

  @override
  String get couldNotGetLocation => 'Не удалось определить местоположение. Проверьте разрешение на геолокацию.';

  @override
  String get googleMapsLabel => 'Google Карты';

  @override
  String get couldNotFindNearestStation => 'Не удалось найти ближайшую станцию';

  @override
  String get zoomLabel => 'Увеличить';

  @override
  String transferAtStation(Object station) {
    return 'Пересадка на $station';
  }

  @override String get onboardingSkip => 'Пропустить';
  @override String get onboardingNext => 'Далее';
  @override String get onboardingGetStarted => 'Начать';
  @override String get onboardingTitle1 => 'Планируйте маршрут';
  @override String get onboardingSubtitle1 => 'Выберите станцию отправления и прибытия — мы найдём быстрейший путь с пересадками, временем и стоимостью за секунды.';
  @override String get onboardingTitle2 => 'Изучите линии';
  @override String get onboardingSubtitle2 => '3 цветные линии охватывают весь Каир. Круглые значки обозначают станции пересадки.';
  @override String get onboardingTitle3 => 'Всё в одном месте';
  @override String get onboardingSubtitle3 => 'Найдите ближайшую станцию, просматривайте живую карту и открывайте места рядом с каждой остановкой.';
  @override String get onboardingLanguagePrompt => 'Выберите язык';
  @override String get onboardingReplay => 'Повторить тур';
  @override String get onboardingLine1 => 'Линия 1 · Хелван → Нью-Эль-Мардж';
  @override String get onboardingLine2 => 'Линия 2 · Эль-Муниб → Шубра';
  @override String get onboardingLine3 => 'Линия 3 · Адли Мансур → ветки';
  @override String get onboardingTransfer => 'Пересадочная станция';

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

  @override String get searchingOnline => 'Поиск в интернете…';
  @override String get didYouMean => 'Возможно, вы имели в виду?';
  @override String get tapForTransferDetails => 'Нажмите для деталей пересадки';
}