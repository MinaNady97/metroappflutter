// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get locale => 'ar';

  @override
  String get departureStationTitle => 'محطة المغادرة';

  @override
  String get arrivalStationTitle => 'محطة الوصول';

  @override
  String get departureStationHint => 'اختر محطة المغادرة';

  @override
  String get arrivalStationHint => 'اختر محطة الوصول';

  @override
  String get destinationFieldLabel => 'أدخل عنوان الوجهة';

  @override
  String get findButtonText => 'بحث';

  @override
  String get showRoutesButtonText => 'عرض المسار';

  @override
  String get pleaseSelectDeparture => 'الرجاء اختيار محطة المغادرة';

  @override
  String get pleaseSelectArrival => 'الرجاء اختيار محطة الوصول';

  @override
  String get selectDifferentStations => 'الرجاء اختيار محطتين مختلفتين';

  @override
  String get nearestStationLabel => 'أقرب محطة';

  @override
  String get addressNotFound => 'العنوان غير موجود، يرجى المحاولة مرة أخرى';

  @override
  String get invalidDataFormat => 'تنسيق البيانات غير صالح';

  @override
  String get routeToNearest => 'الطريق لأقرب محطة';

  @override
  String get routeToDestination => 'الطريق للوجهة';

  @override
  String get pleaseClickOnMyLocation => 'يرجى النقر على زر موقعي أولاً';

  @override
  String get mustTypeADestination => 'يجب كتابة وجهة أولاً.';

  @override
  String get estimatedTravelTime => 'الوقت المقدر للسفر';

  @override
  String get ticketPrice => 'سعر التذكرة';

  @override
  String get noOfStations => 'عدد المحطات';

  @override
  String get changeAt => 'سوف تتغير في';

  @override
  String get totalTravelTime => 'الوقت المقدر الإجمالي للسفر';

  @override
  String get changeTime => 'الوقت المقدر للتغيير بين الخطوط';

  @override
  String get firstTake => 'الخط الأول';

  @override
  String get firstDirection => 'الاتجاه الأول';

  @override
  String get firstDeparture => 'المغادرة الأولى';

  @override
  String get firstArrival => 'الوصول الأول';

  @override
  String get firstIntermediateStations => 'المحطات الوسيطة الأولى';

  @override
  String get secondTake => 'الخط الثاني';

  @override
  String get secondDirection => 'الاتجاه الثاني';

  @override
  String get secondDeparture => 'المغادرة الثانية';

  @override
  String get secondArrival => 'الوصول الثاني';

  @override
  String get secondIntermediateStations => 'المحطات الوسيطة الثانية';

  @override
  String get thirdTake => 'الخط الثالث';

  @override
  String get thirdDirection => 'الاتجاه الثالث';

  @override
  String get thirdDeparture => 'المغادرة الثالثة';

  @override
  String get thirdArrival => 'الوصول الثالث';

  @override
  String get thirdIntermediateStations => 'المحطات الوسيطة الثالثة';

  @override
  String get error => 'خطأ:';

  @override
  String get mustTypeDestination => 'يجب كتابة وجهة اولا.ً';

  @override
  String get noRoutesFound => 'لا توجد طرق';

  @override
  String get routeDetails => 'تفاصيل الرحلة';

  @override
  String get departure => 'المغادرة: ';

  @override
  String get arrival => 'الوصول: ';

  @override
  String get take => 'ركوب: ';

  @override
  String get direction => 'الاتجاه: ';

  @override
  String get intermediateStations => 'المحطات الوسيطة:';

  @override
  String egp(Object price) {
    return '$price جنيه';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => 'عرض المحطات';

  @override
  String get hideStations => 'إخفاء المحطات';

  @override
  String get showRoute => 'عرض المسار';

  @override
  String get metro1 => 'الخط الأول';

  @override
  String get metro2 => 'الخط الثاني';

  @override
  String get metro3branch1 => 'الخط الثالث تفريعة محور روض الفرج';

  @override
  String get metro3branch2 => 'الخط الثالث تفريعة جامعة القاهرة';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return 'المسافة إلى $stationName هي $distance مترًا';
  }

  @override
  String reachedStation(Object stationName) {
    return 'لقد وصلت إلى $stationName';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return 'المحطة الحالية هي $currentStationName والمحطة التالية هي $nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return 'المحطة الحالية هي $currentStationName والمحطة التالية هي $nextStationName ستغير إلى $lineName اتجاه $direction';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return 'المحطة الحالية هي $currentStationName والمحطة التالية هي $nextStationName وهي محطتك النهائية';
  }

  @override
  String get finalStationReached => 'تم الوصول إلى محطة الوصول، الرحلة اكتملت';

  @override
  String get exchangeStation => 'محطة تبادلية';

  @override
  String get intermediateStationsTitle => 'المحطات الوسيطة';

  @override
  String get metroStationHELWAN => 'حلوان';

  @override
  String get metroStationAIN_HELWAN => 'عين حلوان';

  @override
  String get metroStationHELWAN_UNIVERSITY => 'جامعة حلوان';

  @override
  String get metroStationWADI_HOF => 'وادي حوف';

  @override
  String get metroStationHADAYEK_HELWAN => 'حدائق حلوان';

  @override
  String get metroStationEL_MAASARA => 'المعصرة';

  @override
  String get metroStationTORA_EL_ASMANT => 'طرة الأسمنت';

  @override
  String get metroStationKOZZIKA => 'كوتسيكا';

  @override
  String get metroStationTORA_EL_BALAD => 'طرة البلد';

  @override
  String get metroStationTHAKANAT_EL_MAADI => 'ثكنات المعادي';

  @override
  String get metroStationMAADI => 'المعادي';

  @override
  String get metroStationHADAYEK_EL_MAADI => 'حدائق المعادي';

  @override
  String get metroStationDAR_EL_SALAM => 'دار السلام';

  @override
  String get metroStationEL_ZAHRAA => 'الزهراء';

  @override
  String get metroStationMAR_GIRGIS => 'مار جرجس';

  @override
  String get metroStationEL_MALEK_EL_SALEH => 'الملك الصالح';

  @override
  String get metroStationSAYEDA_ZEINAB => 'السيدة زينب';

  @override
  String get metroStationSAAD_ZAGHLOUL => 'سعد زغلول';

  @override
  String get metroStationSADAT => 'السادات';

  @override
  String get metroStationGAMAL_ABD_EL_NASSER => 'جمال عبد الناصر';

  @override
  String get metroStationORABI => 'عرابي';

  @override
  String get metroStationEL_SHOHADAAH => 'الشهداء';

  @override
  String get metroStationGHAMRA => 'غمرة';

  @override
  String get metroStationEL_DEMERDASH => 'الدمرداش';

  @override
  String get metroStationMANSHIET_EL_SADR => 'منشية الصدر';

  @override
  String get metroStationKOBRI_EL_QOBBA => 'كوبري القبة';

  @override
  String get metroStationHAMMAMAT_EL_QOBBA => 'حمامات القبة';

  @override
  String get metroStationSARAY_EL_QOBBA => 'سراي القبة';

  @override
  String get metroStationHADAYEK_EL_ZAITOUN => 'حدائق الزيتون';

  @override
  String get metroStationHELMEYET_EL_ZAITOUN => 'حلمية الزيتون';

  @override
  String get metroStationEL_MATARYA => 'المطرية';

  @override
  String get metroStationAIN_SHAMS => 'عين شمس';

  @override
  String get metroStationEZBET_EL_NAKHL => 'عزبة النخل';

  @override
  String get metroStationEL_MARG => 'المرج';

  @override
  String get metroStationNEW_EL_MARG => 'المرج الجديدة';

  @override
  String get metroStationEL_MOUNIB => 'المنيب';

  @override
  String get metroStationSAQYET_MAKKI => 'ساقية مكي';

  @override
  String get metroStationOM_EL_MASRYEEN => 'أم المصريين';

  @override
  String get metroStationGIZA => 'جيزة';

  @override
  String get metroStationFEISAL => 'فيصل';

  @override
  String get metroStationCAIRO_UNIVERSITY => 'جامعة القاهرة';

  @override
  String get metroStationEL_BEHOUS => 'البحوث';

  @override
  String get metroStationEL_DOKKI => 'الدقي';

  @override
  String get metroStationOPERA => 'الأوبرا';

  @override
  String get metroStationMOHAMED_NAGUIB => 'محمد نجيب';

  @override
  String get metroStationATABA => 'عتبة';

  @override
  String get metroStationMASARA => 'مسرة';

  @override
  String get metroStationROUD_EL_FARAG => 'رود الفرج';

  @override
  String get metroStationSAINT_TERESA => 'سانت تيريزا';

  @override
  String get metroStationKHALAFAWEY => 'خلفاوي';

  @override
  String get metroStationMEZALLAT => 'مزلات';

  @override
  String get metroStationKOLLEYET_EL_ZERA3A => 'كلية الزراعة';

  @override
  String get metroStationSHOUBRA_EL_KHEIMA => 'شبرا الخيمة';

  @override
  String get metroStationADLY_MANSOUR => 'عدلي منصور';

  @override
  String get metroStationEL_HAYKSTEP => 'الهايكستب';

  @override
  String get metroStationOMAR_IBN_EL_KHATTAB => 'عمر بن الخطاب';

  @override
  String get metroStationQOBA => 'قوبا';

  @override
  String get metroStationHESHAM_BARAKAT => 'هشام بركات';

  @override
  String get metroStationEL_NOZHA => 'النزهة';

  @override
  String get metroStationNADI_EL_SHAMS => 'نادي الشمس';

  @override
  String get metroStationALF_MASKAN => 'ألف مسكن';

  @override
  String get metroStationHELIOPOLIS => 'هيليوبوليس';

  @override
  String get metroStationHAROUN => 'هارون';

  @override
  String get metroStationEL_AHRAM => 'الأهرام';

  @override
  String get metroStationKOLLEYET_EL_BANAT => 'كلية البنات';

  @override
  String get metroStationEL_ESTAD => 'الاستاد';

  @override
  String get metroStationARD_EL_MAARD => 'أرض المعارض';

  @override
  String get metroStationABASIA => 'عباسية';

  @override
  String get metroStationABDO_BASHA => 'عبد باشا';

  @override
  String get metroStationEL_GEISH => 'الجيش';

  @override
  String get metroStationBAB_EL_SHARIA => 'باب الشريعة';

  @override
  String get metroStationMASPERO => 'ماسبيرو';

  @override
  String get metroStationSAFAA_HEGAZI => 'صفاء هجازي';

  @override
  String get metroStationKIT_KAT => 'كتكات';

  @override
  String get metroStationSUDAN => 'السودان';

  @override
  String get metroStationIMBABA => 'إمبابة';

  @override
  String get metroStationEL_BOHY => 'البوهي';

  @override
  String get metroStationEL_QAWMEYA => 'القومية';

  @override
  String get metroStationEL_TARIQ_EL_DAIRY => 'الطريق الدائري';

  @override
  String get metroStationROD_EL_FARAG_AXIS => 'محور روض الفرج';

  @override
  String get metroStationEL_TOUFIQIA => 'التوفيقية';

  @override
  String get metroStationWADI_EL_NIL => 'وادي النيل';

  @override
  String get metroStationGAMAET_EL_DOWL_EL_ARABIA => 'جامعة الدول العربية';

  @override
  String get metroStationBOLAK_EL_DAKROUR => 'بولاق الدكرور';

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
  String get appTitle => 'دليل مترو القاهرة';

  @override
  String get welcomeTitle => 'خطط رحلتك بالمترو';

  @override
  String get welcomeSubtitle => 'ابحث عن أفضل المسارات، أقرب المحطات ومعلومات المترو';

  @override
  String get planYourRoute => 'تخطيط الرحلة';

  @override
  String get findNearestStation => 'البحث عن أقرب محطة';

  @override
  String get scheduleLabel => 'الجدول الزمني';

  @override
  String get metroMapLabel => 'خريطة المترو';

  @override
  String get appInfoTitle => 'حول دليل مترو القاهرة';

  @override
  String get appInfoDescription => 'الدليل الرسمي لشبكة مترو القاهرة. ابحث عن المسارات، المحطات، الجداول الزمنية والمزيد.';

  @override
  String get close => 'إغلاق';

  @override
  String get languageSwitchTitle => 'تغيير اللغة';

  @override
  String get routeOptions => 'خيارات المسار';

  @override
  String get fastestRoute => 'أسرع مسار';

  @override
  String get shortestRoute => 'أقصر مسار';

  @override
  String get fewestTransfers => 'أقل عدد من المحطات';

  @override
  String get estimatedTime => 'الوقت المتوقع';

  @override
  String get estimatedFare => 'السعر المتوقع';

  @override
  String stationsCount(Object count) {
    return '$count محطات';
  }

  @override
  String get minutesAbbr => 'دقيقة';

  @override
  String get exitDialogTitle => 'مغادرة التطبيق؟';

  @override
  String get exitDialogSubtitle => 'هل أنت متأكد من الخروج من\nمتنقل مترو القاهرة؟';

  @override
  String get exitDialogStay => 'البقاء';

  @override
  String get exitDialogExit => 'خروج';

  @override
  String get egpCurrency => 'جنيه';

  @override
  String get departureTime => 'مغادرة';

  @override
  String get arrivalTime => 'وصول';

  @override
  String get transferStations => 'التغيير في:';

  @override
  String get noInternetTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noInternetMessage => 'بعض الميزات قد لا تكون متوفرة دون اتصال';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get offlineMode => 'وضع عدم الاتصال';

  @override
  String lastUpdated(Object date) {
    return 'آخر تحديث: $date';
  }

  @override
  String get searchHistory => 'سجل البحث';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String get noHistory => 'لا يوجد سجل بحث حتى الآن';

  @override
  String get favorites => 'المفضلة';

  @override
  String get addToFavorites => 'إضافة إلى المفضلة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get shareRoute => 'مشاركة المسار';

  @override
  String get amenitiesTitle => 'مرافق المحطة';

  @override
  String get accessibility => 'إمكانية الوصول';

  @override
  String get parking => 'موقف سيارات';

  @override
  String get toilets => 'دورات مياه';

  @override
  String get atm => 'صراف آلي';

  @override
  String get refresh => 'تحديث';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get allLines => 'كل الخطوط';

  @override
  String get line1 => 'الخط الأول';

  @override
  String get line2 => 'الخط الثاني';

  @override
  String get line3 => 'الخط الثالث';

  @override
  String get line4 => 'الخط الرابع';

  @override
  String get operatingHours => 'ساعات التشغيل';

  @override
  String get firstTrain => 'أول قطار';

  @override
  String get lastTrain => 'آخر قطار';

  @override
  String get peakHours => 'ساعات الذروة';

  @override
  String get offPeakHours => 'خارج أوقات الذروة';

  @override
  String get weekdays => 'أيام الأسبوع';

  @override
  String get weekend => 'عطلة نهاية الأسبوع';

  @override
  String get holidays => 'العطلات الرسمية';

  @override
  String get specialSchedule => 'جدول خاص';

  @override
  String get alerts => 'تنبيهات الخدمة';

  @override
  String get noAlerts => 'لا توجد تنبيهات حالية';

  @override
  String get viewAllStations => 'عرض جميع المحطات';

  @override
  String get nearbyStations => 'المحطات القريبة';

  @override
  String distanceAway(Object distance) {
    return 'على بعد $distance كم';
  }

  @override
  String walkingTime(Object minutes) {
    return '$minutes دقيقة سيرًا';
  }

  @override
  String get metroEtiquette => 'آداب ركوب المترو';

  @override
  String get safetyTips => 'نصائح السلامة';

  @override
  String get feedback => 'إرسال ملاحظات';

  @override
  String get rateApp => 'قيم هذا التطبيق';

  @override
  String get settings => 'الإعدادات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get language => 'اللغة';

  @override
  String get recentTripsLabel => 'الرحلات الحديثة';

  @override
  String get favoritesLabel => 'المفضلة';

  @override
  String get metroLinesTitle => 'خطوط المترو';

  @override
  String get line1Name => 'الخط الأول';

  @override
  String get line2Name => 'الخط الثاني';

  @override
  String get line3Name => 'الخط الثالث';

  @override
  String get line4Name => 'الخط الرابع';

  @override
  String get stationsLabel => 'محطات';

  @override
  String get comingSoonLabel => 'قريباً';

  @override
  String get viewFullMap => 'عرض الخريطة كاملة';

  @override
  String get nearestStationFound => 'تم العثور على أقرب محطة';

  @override
  String get stationFound => 'تم العثور على المحطة';

  @override
  String get accessibilityLabel => 'إمكانية الوصول';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get allMetroLines => 'جميع خطوط المترو';

  @override
  String get aroundStationsTitle => 'حول المحطات';

  @override
  String get station => 'محطة';

  @override
  String get seeFacilities => 'عرض المرافق';

  @override
  String get subscriptionInfoTitle => 'معلومات التذاكر والاشتراكات';

  @override
  String get subscriptionInfoSubtitle => 'تعرف على الأسعار، المناطق وأماكن الشراء';

  @override
  String get facilitiesTitle => 'مرافق المحطة';

  @override
  String get parkingTitle => 'مواقف السيارات';

  @override
  String get parkingDescription => 'توفر مواقف السيارات';

  @override
  String get toiletsTitle => 'دورات المياه';

  @override
  String get toiletsDescription => 'توفر دورات المياه العامة';

  @override
  String get elevatorsTitle => 'المصاعد';

  @override
  String get elevatorsDescription => 'مصاعد لذوي الاحتياجات الخاصة';

  @override
  String get shopsTitle => 'المحلات';

  @override
  String get shopsDescription => 'متاجر صغيرة وأكشاك';

  @override
  String get available => 'متاح';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get nearbyAttractions => 'معالم قريبة';

  @override
  String get attraction1 => 'المتحف المصري';

  @override
  String get attraction2 => 'خان الخليلي';

  @override
  String get attraction3 => 'ميدان التحرير';

  @override
  String get attractionDescription => 'أحد أشهر معالم القاهرة، يمكن الوصول إليه بسهولة من هذه المحطة';

  @override
  String get minutes => 'دقائق';

  @override
  String get walkingDistance => 'مسافة المشي';

  @override
  String get accessibilityInfoTitle => 'ميزات إمكانية الوصول';

  @override
  String get wheelchairTitle => 'وصول الكراسي المتحركة';

  @override
  String get wheelchairDescription => 'جميع المحطات بها نقاط وصول لذوي الاحتياجات الخاصة';

  @override
  String get hearingImpairmentTitle => 'ضعاف السمع';

  @override
  String get hearingImpairmentDescription => 'تتوفر مؤشرات بصرية لضعاف السمع';

  @override
  String get subscriptionTypes => 'أنواع الاشتراكات';

  @override
  String get dailyPass => 'اشتراك يومي';

  @override
  String get dailyPassDescription => 'سفر غير محدود ليوم واحد على جميع الخطوط';

  @override
  String get weeklyPass => 'اشتراك أسبوعي';

  @override
  String get weeklyPassDescription => 'سفر غير محدود لمدة 7 أيام على جميع الخطوط';

  @override
  String get monthlyPass => 'اشتراك شهري';

  @override
  String get monthlyPassDescription => 'سفر غير محدود لمدة 30 يوماً على جميع الخطوط';

  @override
  String get purchaseNow => 'شراء الآن';

  @override
  String get zonesTitle => 'مناطق التعريفة';

  @override
  String get zonesDescription => 'ينقسم مترو القاهرة إلى مناطق تعريفة. السعر يعتمد على عدد المناطق التي تسافر عبرها.';

  @override
  String get whereToBuyTitle => 'أماكن الشراء';

  @override
  String get metroStations => 'محطات المترو';

  @override
  String get metroStationsDescription => 'متاح في مكاتب التذاكر في جميع المحطات';

  @override
  String get authorizedVendors => 'بائعون معتمدون';

  @override
  String get authorizedVendorsDescription => 'أكشاك ومتاجر مختارة بالقرب من المحطات';

  @override
  String get touristGuideTitle => 'دليل السائح';

  @override
  String get popularDestinations => 'الوجهات الشهيرة';

  @override
  String get pyramidsTitle => 'الأهرامات';

  @override
  String get pyramidsDescription => 'آخر عجائب الدنيا السبع الباقية';

  @override
  String get egyptianMuseumTitle => 'المتحف المصري';

  @override
  String get egyptianMuseumDescription => 'يضم أكبر مجموعة من الآثار الفرعونية في العالم';

  @override
  String get khanElKhaliliTitle => 'خان الخليلي';

  @override
  String get khanElKhaliliDescription => 'سوق تاريخي يعود إلى عام 1382';

  @override
  String get essentialPhrases => 'عبارات عربية أساسية';

  @override
  String get phrase1 => 'كم سعر التذكرة؟';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => 'أين محطة المترو؟';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => 'هل هذا يذهب إلى...؟';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => 'نصائح السفر';

  @override
  String get peakHoursTitle => 'ساعات الذروة';

  @override
  String get peakHoursDescription => 'تجنب الساعة 7-9 صباحاً و3-6 مساءً للابتعاد عن الازدحام';

  @override
  String get safetyTitle => 'السلامة';

  @override
  String get safetyDescription => 'احتفظ بأغراضك القيمة في مكان آمن وكن على دراية بمحيطك';

  @override
  String get ticketsTitle => 'التذاكر';

  @override
  String get ticketsDescription => 'احتفظ بتذكرتك حتى خروجك من المحطة';

  @override
  String get lengthLabel => 'الطول';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get whereToBuyDescription => 'ابحث عن أماكن شراء التذاكر، شحن بطاقة المحفظة أو الاشتراك في البطاقات الموسمية (شهرية/ربع سنوية/سنوية)';

  @override
  String get ticketsBullet1 => 'متاحة في جميع مكاتب التذاكر';

  @override
  String get ticketsBullet2 => 'التذاكر العامة متاحة في ماكينات البيع (محطات من هارون إلى عدلي منصور)';

  @override
  String get ticketsBullet3 => 'الأنواع: عامة، كبار السن، ذوي الاحتياجات الخاصة';

  @override
  String get walletCardTitle => 'بطاقة المحفظة';

  @override
  String get walletBullet1 => 'متاحة في جميع مكاتب التذاكر وماكينات البيع (من هارون إلى عدلي منصور)';

  @override
  String get walletBullet2 => 'سعر البطاقة: 80 جنيهاً (حد أدنى لشحن 40 جنيهاً عند الشراء الأول)';

  @override
  String get walletBullet3 => 'نطاق الشحن: من 20 جنيهاً إلى 400 جنيهاً';

  @override
  String get walletBullet4 => 'قابلة لإعادة الاستخدام والتحويل';

  @override
  String get walletBullet5 => 'توفّر الوقت مقارنة بالتذاكر الفردية';

  @override
  String get seasonalCardTitle => 'البطاقة الموسمية';

  @override
  String get seasonalBullet1 => 'متاحة لـ: العامة، الطلاب، كبار السن (60+)، ذوي الاحتياجات الخاصة';

  @override
  String get requirementsTitle => 'المتطلبات:';

  @override
  String get seasonalBullet2 => 'زيارة مكاتب الاشتراك في العتبة، العباسية، هليوبوليس أو عدلي منصور';

  @override
  String get seasonalBullet3 => 'تقديم صورتين شخصيتين (مقاس 4x6)';

  @override
  String get additionalRequirementsTitle => 'متطلبات إضافية:';

  @override
  String get studentReq => 'الطلاب: نموذج مختوم من المدرسة + صورة بطاقة/شهادة ميلاد + إيصال الدفع';

  @override
  String get elderlyReq => 'كبار السن: بطاقة هوية سارية تثبت العمر';

  @override
  String get specialNeedsReq => 'ذوي الاحتياجات الخاصة: بطاقة صادرة عن الحكومة تثبت الحالة';

  @override
  String get learnMore => 'المزيد من المعلومات';

  @override
  String get stationDetailsTitle => 'تفاصيل المحطة';

  @override
  String get stationMapTitle => 'خريطة المحطة';

  @override
  String get allOperationalLabel => 'جميع الخطوط تعمل';

  @override
  String get statusLiveLabel => 'مباشر';

  @override
  String get homepageSubtitle => 'دليلك الذكي لرحلات المترو والقطار الكهربائي';

  @override
  String get greetingMorning => 'صباح الخير';

  @override
  String get greetingAfternoon => 'مساء الخير';

  @override
  String get greetingEvening => 'مساء الخير';

  @override
  String get greetingNight => 'تصبح على خير';

  @override
  String get planYourRouteSubtitle => 'ابحث عن أسرع مسار بين المحطات';

  @override
  String get recentSearchesLabel => 'عمليات البحث الأخيرة';

  @override
  String get googleMapsLinkDetected => 'تم اكتشاف رابط خرائط جوجل';

  @override
  String get pickFromMapLabel => 'اختر من الخريطة';

  @override
  String get quickActionsTitle => 'إجراءات سريعة';

  @override
  String get tapToLocateLabel => 'اضغط للعثور على أقرب محطة';

  @override
  String get touristHighlightsLabel => 'معلم سياحي';

  @override
  String get viewPlansLabel => 'عرض خطط الاشتراك';

  @override
  String get lrtLineName => 'خط القطار الخفيف';

  @override
  String get exploreAreaTitle => 'استكشاف المنطقة';

  @override
  String get exploreAreaSubtitle => 'اكتشف الأماكن القريبة من محطات المترو';

  @override
  String get tapToExploreLabel => 'اضغط على المحطة للاستكشاف';

  @override
  String get promoMonthlyTitle => 'تذكرة شهرية';

  @override
  String get promoMonthlySubtitle => 'رحلات غير محدودة لمدة 30 يومًا';

  @override
  String get promoMonthlyTag => 'الأفضل قيمة';

  @override
  String get promoStudentTitle => 'تذكرة الطالب';

  @override
  String get promoStudentSubtitle => 'خصم 50٪ للطلاب';

  @override
  String get promoStudentTag => 'طالب';

  @override
  String get promoFamilyTitle => 'تذكرة العائلة';

  @override
  String get promoFamilySubtitle => 'سافروا معًا ووفّروا أكثر';

  @override
  String get promoFamilyTag => 'عائلة';

  @override
  String get buyNowLabel => 'اشترِ الآن';

  @override
  String get locateMeLabel => 'جارٍ تحديد الموقع';

  @override
  String get locationServicesDisabled => 'خدمات الموقع معطلة. يرجى تفعيلها من الإعدادات.';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الموقع. يرجى السماح به من إعدادات التطبيق.';

  @override
  String get locationError => 'تعذر تحديد موقعك. يرجى المحاولة مرة أخرى.';

  @override
  String get leaveNowLabel => 'اذهب الآن';

  @override
  String get cairoMetroNetworkLabel => 'شبكة مترو القاهرة';

  @override
  String get resetViewLabel => 'إعادة ضبط العرض';

  @override
  String get mapLegendLabel => 'مفتاح الخريطة';

  @override
  String get searchStationsHint => 'ابحث عن محطة...';

  @override
  String get noStationsFound => 'لا توجد محطات';

  @override
  String get line1FullName => 'الخط الأول — حلوان / الجزء الجديد';

  @override
  String get line2FullName => 'الخط الثاني — شبرا الخيمة / المنيب';

  @override
  String get line3FullName => 'الخط الثالث — عدلي منصور / كيت كات';

  @override
  String get line4FullName => 'الخط الرابع';

  @override
  String get monorailEastName => 'المونوريل الشرقي';

  @override
  String get monorailWestName => 'المونوريل الغربي';

  @override
  String get allLinesStationsLabel => 'محطة';

  @override
  String get underConstructionLabel => 'تحت الإنشاء';

  @override
  String get plannedLabel => 'مخطط';

  @override
  String get transferLabel => 'تحويل';

  @override
  String get statusMaintenanceLabel => 'صيانة';

  @override
  String get statusDisruptionLabel => 'توقف';

  @override
  String get crowdCalmLabel => 'هادئ';

  @override
  String get crowdModerateLabel => 'معتدل';

  @override
  String get crowdBusyLabel => 'مزدحم';

  @override
  String get locationDialogNoThanks => 'لا شكراً';

  @override
  String get locationDialogTurnOn => 'تشغيل';

  @override
  String get locationDialogOpenSettings => 'فتح الإعدادات';

  @override
  String get touristGuidePlacesCount => 'مكان للاستكشاف';

  @override
  String get touristGuideDisclaimer => 'الأوقات والمسافات والتفاصيل تقريبية وقد تختلف. يُرجى التحقق رسمياً قبل الزيارة.';

  @override
  String get touristGuideSearchHint => 'ابحث عن مكان أو محطة...';

  @override
  String get touristGuideCategoryAll => 'الكل';

  @override
  String get touristGuideNoPlaces => 'لا توجد نتائج';

  @override
  String get touristGuideNoPlacesSub => 'جرب بحثاً مختلفاً أو فئة أخرى';

  @override
  String get photographyTitle => 'التصوير';

  @override
  String get photographyDescription => 'التصوير غير مسموح داخل محطات المترو. بعض المعالم قد تفرض رسوم كاميرا.';

  @override
  String get bestTimeTitle => 'أفضل وقت للزيارة';

  @override
  String get bestTimeDescription => 'أكتوبر إلى أبريل يوفر أفضل طقس. زُر المواقع المفتوحة صباحاً باكراً أو عصراً.';

  @override
  String get phrase4 => 'شكراً';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => 'بكام؟';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => 'فين...؟';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => 'أنا عايز أروح...';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => 'هو بعيد؟';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => 'خطط الرحلة';

  @override
  String get lineLabel => 'خط';

  @override
  String get categoryHistorical => 'تاريخي';

  @override
  String get categoryMuseum => 'متاحف';

  @override
  String get categoryReligious => 'ديني';

  @override
  String get categoryPark => 'حدائق';

  @override
  String get categoryShopping => 'تسوق';

  @override
  String get categoryCulture => 'ثقافي';

  @override
  String get categoryNile => 'النيل';

  @override
  String get categoryHiddenGem => 'جواهر خفية';

  @override
  String get facilityCommercial => 'تجاري';

  @override
  String get facilityCultural => 'ثقافي';

  @override
  String get facilityEducational => 'تعليمي';

  @override
  String get facilityLandmarks => 'معالم';

  @override
  String get facilityMedical => 'طبي';

  @override
  String get facilityPublicInstitutions => 'مؤسسات عامة';

  @override
  String get facilityPublicSpaces => 'مساحات عامة';

  @override
  String get facilityReligious => 'ديني';

  @override
  String get facilityServices => 'خدمات';

  @override
  String get facilitySportFacilities => 'مرافق رياضية';

  @override
  String get facilityStreets => 'شوارع';

  @override
  String get facilitySearchHint => 'ابحث عن مكان...';

  @override
  String get facilityNoData => 'لا تتوفر بيانات لهذه المحطة حتى الآن';

  @override
  String get facilityDataSoon => 'سيتم إضافة البيانات قريباً';

  @override
  String get facilityClearFilter => 'مسح الفلتر';

  @override
  String get facilityPlacesCount => 'مكان';

  @override
  String get facilityZoomHint => 'قرّب واسحب لاستكشاف الصورة';

  @override
  String get facilityCategoriesLabel => 'فئة';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get sortStops => 'المحطات';

  @override
  String get sortTime => 'الوقت';

  @override
  String get sortFare => 'السعر';

  @override
  String get sortLines => 'الخطوط';

  @override
  String get bestRoute => 'الأفضل';

  @override
  String get hideStops => 'إخفاء المحطات';

  @override
  String get showLabel => 'عرض';

  @override
  String get stopsWord => 'محطات';

  @override
  String get minuteShort => 'د';

  @override
  String get detectingLocation => 'جاري تحديد موقعك...';

  @override
  String get tapToExplore => 'اضغط للاستكشاف';

  @override
  String get couldNotOpenMaps => 'لم نتمكن من فتح خرائط جوجل';

  @override
  String get couldNotGetLocation => 'لم نتمكن من تحديد موقعك. تحقق من إذن الموقع.';

  @override
  String get googleMapsLabel => 'خرائط جوجل';

  @override
  String get couldNotFindNearestStation => 'لم نتمكن من تحديد أقرب محطة';

  @override
  String get zoomLabel => 'تكبير';

  @override
  String transferAtStation(Object station) {
    return 'تحويل في $station';
  }
}
