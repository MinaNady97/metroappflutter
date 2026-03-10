// metro_stations.dart
import 'package:flutter/material.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

Map<List<int>, List<String>> getCommonStationsMap(BuildContext context) {
  final isAr = AppLocalizations.of(context)!.locale == 'ar';
  return <List<int>, List<String>>{
    [1, 2]: [
      AppLocalizations.of(context)!.metroStationSADAT,
      AppLocalizations.of(context)!.metroStationEL_SHOHADAAH
    ],
    [1, 3]: [
      AppLocalizations.of(context)!.metroStationGAMAL_ABD_EL_NASSER,
    ],
    [1, 4]: [
      AppLocalizations.of(context)!.metroStationGAMAL_ABD_EL_NASSER,
    ],
    [2, 3]: [
      AppLocalizations.of(context)!.metroStationATABA,
    ],
    [2, 4]: [
      AppLocalizations.of(context)!.metroStationATABA,
      AppLocalizations.of(context)!.metroStationCAIRO_UNIVERSITY,
    ],
    [3, 4]: [
      AppLocalizations.of(context)!.metroStationKIT_KAT,
    ],
    [3, 5]: [
      AppLocalizations.of(context)!.metroStationADLY_MANSOUR,
    ],
    [4, 5]: [
      AppLocalizations.of(context)!.metroStationADLY_MANSOUR,
    ],
    [5, 6]: [
      isAr ? 'بدر' : 'Badr',
    ],
    [5, 7]: [
      isAr ? 'بدر' : 'Badr',
    ],
    [6, 7]: [
      isAr ? 'بدر' : 'Badr',
    ],
  };
}

Map<String, List<String>> getCommonStationsStringMap(BuildContext context) {
  final isAr = AppLocalizations.of(context)!.locale == 'ar';
  return <String, List<String>>{
    '1,2': [
      AppLocalizations.of(context)!.metroStationSADAT,
      AppLocalizations.of(context)!.metroStationEL_SHOHADAAH,
    ],
    '1,3': [
      AppLocalizations.of(context)!.metroStationGAMAL_ABD_EL_NASSER,
    ],
    '1,4': [
      AppLocalizations.of(context)!.metroStationGAMAL_ABD_EL_NASSER,
    ],
    '2,3': [
      AppLocalizations.of(context)!.metroStationATABA,
    ],
    '2,4': [
      AppLocalizations.of(context)!.metroStationATABA,
      AppLocalizations.of(context)!.metroStationCAIRO_UNIVERSITY,
    ],
    '3,4': [
      AppLocalizations.of(context)!.metroStationKIT_KAT,
    ],
    '3,5': [
      AppLocalizations.of(context)!.metroStationADLY_MANSOUR,
    ],
    '4,5': [
      AppLocalizations.of(context)!.metroStationADLY_MANSOUR,
    ],
    '5,6': [
      isAr ? 'بدر' : 'Badr',
    ],
    '5,7': [
      isAr ? 'بدر' : 'Badr',
    ],
    '6,7': [
      isAr ? 'بدر' : 'Badr',
    ],
  };
}

List<String> getMetroLine1Stations(BuildContext context) {
  return [
    AppLocalizations.of(context)!.metroStationHELWAN,
    AppLocalizations.of(context)!.metroStationAIN_HELWAN,
    AppLocalizations.of(context)!.metroStationHELWAN_UNIVERSITY,
    AppLocalizations.of(context)!.metroStationWADI_HOF,
    AppLocalizations.of(context)!.metroStationHADAYEK_HELWAN,
    AppLocalizations.of(context)!.metroStationEL_MAASARA,
    AppLocalizations.of(context)!.metroStationTORA_EL_ASMANT,
    AppLocalizations.of(context)!.metroStationKOZZIKA,
    AppLocalizations.of(context)!.metroStationTORA_EL_BALAD,
    AppLocalizations.of(context)!.metroStationTHAKANAT_EL_MAADI,
    AppLocalizations.of(context)!.metroStationMAADI,
    AppLocalizations.of(context)!.metroStationHADAYEK_EL_MAADI,
    AppLocalizations.of(context)!.metroStationDAR_EL_SALAM,
    AppLocalizations.of(context)!.metroStationEL_ZAHRAA,
    AppLocalizations.of(context)!.metroStationMAR_GIRGIS,
    AppLocalizations.of(context)!.metroStationEL_MALEK_EL_SALEH,
    AppLocalizations.of(context)!.metroStationSAYEDA_ZEINAB,
    AppLocalizations.of(context)!.metroStationSAAD_ZAGHLOUL,
    AppLocalizations.of(context)!.metroStationSADAT,
    AppLocalizations.of(context)!.metroStationGAMAL_ABD_EL_NASSER,
    AppLocalizations.of(context)!.metroStationORABI,
    AppLocalizations.of(context)!.metroStationEL_SHOHADAAH,
    AppLocalizations.of(context)!.metroStationGHAMRA,
    AppLocalizations.of(context)!.metroStationEL_DEMERDASH,
    AppLocalizations.of(context)!.metroStationMANSHIET_EL_SADR,
    AppLocalizations.of(context)!.metroStationKOBRI_EL_QOBBA,
    AppLocalizations.of(context)!.metroStationHAMMAMAT_EL_QOBBA,
    AppLocalizations.of(context)!.metroStationSARAY_EL_QOBBA,
    AppLocalizations.of(context)!.metroStationHADAYEK_EL_ZAITOUN,
    AppLocalizations.of(context)!.metroStationHELMEYET_EL_ZAITOUN,
    AppLocalizations.of(context)!.metroStationEL_MATARYA,
    AppLocalizations.of(context)!.metroStationAIN_SHAMS,
    AppLocalizations.of(context)!.metroStationEZBET_EL_NAKHL,
    AppLocalizations.of(context)!.metroStationEL_MARG,
    AppLocalizations.of(context)!.metroStationNEW_EL_MARG,
  ];
}

List<String> getMetroLine2Stations(BuildContext context) {
  return [
    AppLocalizations.of(context)!.metroStationEL_MOUNIB,
    AppLocalizations.of(context)!.metroStationSAQYET_MAKKI,
    AppLocalizations.of(context)!.metroStationOM_EL_MASRYEEN,
    AppLocalizations.of(context)!.metroStationGIZA,
    AppLocalizations.of(context)!.metroStationFEISAL,
    AppLocalizations.of(context)!.metroStationCAIRO_UNIVERSITY,
    AppLocalizations.of(context)!.metroStationEL_BEHOUS,
    AppLocalizations.of(context)!.metroStationEL_DOKKI,
    AppLocalizations.of(context)!.metroStationOPERA,
    AppLocalizations.of(context)!.metroStationSADAT,
    AppLocalizations.of(context)!.metroStationMOHAMED_NAGUIB,
    AppLocalizations.of(context)!.metroStationATABA,
    AppLocalizations.of(context)!.metroStationEL_SHOHADAAH,
    AppLocalizations.of(context)!.metroStationMASARA,
    AppLocalizations.of(context)!.metroStationROUD_EL_FARAG,
    AppLocalizations.of(context)!.metroStationSAINT_TERESA,
    AppLocalizations.of(context)!.metroStationKHALAFAWEY,
    AppLocalizations.of(context)!.metroStationMEZALLAT,
    AppLocalizations.of(context)!.metroStationKOLLEYET_EL_ZERA3A,
    AppLocalizations.of(context)!.metroStationSHOUBRA_EL_KHEIMA,
  ];
}

List<String> getMetroLine3Branch1Stations(BuildContext context) {
  return [
    AppLocalizations.of(context)!.metroStationADLY_MANSOUR,
    AppLocalizations.of(context)!.metroStationEL_HAYKSTEP,
    AppLocalizations.of(context)!.metroStationOMAR_IBN_EL_KHATTAB,
    AppLocalizations.of(context)!.metroStationQOBA,
    AppLocalizations.of(context)!.metroStationHESHAM_BARAKAT,
    AppLocalizations.of(context)!.metroStationEL_NOZHA,
    AppLocalizations.of(context)!.metroStationNADI_EL_SHAMS,
    AppLocalizations.of(context)!.metroStationALF_MASKAN,
    AppLocalizations.of(context)!.metroStationHELIOPOLIS,
    AppLocalizations.of(context)!.metroStationHAROUN,
    AppLocalizations.of(context)!.metroStationEL_AHRAM,
    AppLocalizations.of(context)!.metroStationKOLLEYET_EL_BANAT,
    AppLocalizations.of(context)!.metroStationEL_ESTAD,
    AppLocalizations.of(context)!.metroStationARD_EL_MAARD,
    AppLocalizations.of(context)!.metroStationABASIA,
    AppLocalizations.of(context)!.metroStationABDO_BASHA,
    AppLocalizations.of(context)!.metroStationEL_GEISH,
    AppLocalizations.of(context)!.metroStationBAB_EL_SHARIA,
    AppLocalizations.of(context)!.metroStationATABA,
    AppLocalizations.of(context)!.metroStationGAMAL_ABD_EL_NASSER,
    AppLocalizations.of(context)!.metroStationMASPERO,
    AppLocalizations.of(context)!.metroStationSAFAA_HEGAZI,
    AppLocalizations.of(context)!.metroStationKIT_KAT,
    AppLocalizations.of(context)!.metroStationSUDAN,
    AppLocalizations.of(context)!.metroStationIMBABA,
    AppLocalizations.of(context)!.metroStationEL_BOHY,
    AppLocalizations.of(context)!.metroStationEL_QAWMEYA,
    AppLocalizations.of(context)!.metroStationEL_TARIQ_EL_DAIRY,
    AppLocalizations.of(context)!.metroStationROD_EL_FARAG_AXIS,
  ];
}

List<String> getMetroLine3Branch2Stations(BuildContext context) {
  return [
    AppLocalizations.of(context)!.metroStationADLY_MANSOUR,
    AppLocalizations.of(context)!.metroStationEL_HAYKSTEP,
    AppLocalizations.of(context)!.metroStationOMAR_IBN_EL_KHATTAB,
    AppLocalizations.of(context)!.metroStationQOBA,
    AppLocalizations.of(context)!.metroStationHESHAM_BARAKAT,
    AppLocalizations.of(context)!.metroStationEL_NOZHA,
    AppLocalizations.of(context)!.metroStationNADI_EL_SHAMS,
    AppLocalizations.of(context)!.metroStationALF_MASKAN,
    AppLocalizations.of(context)!.metroStationHELIOPOLIS,
    AppLocalizations.of(context)!.metroStationHAROUN,
    AppLocalizations.of(context)!.metroStationEL_AHRAM,
    AppLocalizations.of(context)!.metroStationKOLLEYET_EL_BANAT,
    AppLocalizations.of(context)!.metroStationEL_ESTAD,
    AppLocalizations.of(context)!.metroStationARD_EL_MAARD,
    AppLocalizations.of(context)!.metroStationABASIA,
    AppLocalizations.of(context)!.metroStationABDO_BASHA,
    AppLocalizations.of(context)!.metroStationEL_GEISH,
    AppLocalizations.of(context)!.metroStationBAB_EL_SHARIA,
    AppLocalizations.of(context)!.metroStationATABA,
    AppLocalizations.of(context)!.metroStationGAMAL_ABD_EL_NASSER,
    AppLocalizations.of(context)!.metroStationMASPERO,
    AppLocalizations.of(context)!.metroStationSAFAA_HEGAZI,
    AppLocalizations.of(context)!.metroStationKIT_KAT,
    AppLocalizations.of(context)!.metroStationEL_TOUFIQIA,
    AppLocalizations.of(context)!.metroStationWADI_EL_NIL,
    AppLocalizations.of(context)!.metroStationGAMAET_EL_DOWL_EL_ARABIA,
    AppLocalizations.of(context)!.metroStationBOLAK_EL_DAKROUR,
    AppLocalizations.of(context)!.metroStationCAIRO_UNIVERSITY,
    AppLocalizations.of(context)!.metroStationSUDAN,
    AppLocalizations.of(context)!.metroStationIMBABA,
    AppLocalizations.of(context)!.metroStationEL_BOHY,
    AppLocalizations.of(context)!.metroStationEL_QAWMEYA,
    AppLocalizations.of(context)!.metroStationEL_TARIQ_EL_DAIRY,
    AppLocalizations.of(context)!.metroStationROD_EL_FARAG_AXIS,
  ];
}

List<String> getLrtMainStations(BuildContext context) {
  final isAr = AppLocalizations.of(context)!.locale == 'ar';
  return [
    AppLocalizations.of(context)!.metroStationADLY_MANSOUR,
    isAr ? 'العبور' : 'El-Obour',
    isAr ? 'المستقبل' : 'Future',
    isAr ? 'الشروق' : 'El Shorouk',
    isAr ? 'هليوبوليس الجديدة' : 'New Heliopolis',
    isAr ? 'بدر' : 'Badr',
  ];
}

List<String> getLrtNacBranchStations(BuildContext context) {
  final isAr = AppLocalizations.of(context)!.locale == 'ar';
  return [
    isAr ? 'بدر' : 'Badr',
    isAr ? 'الروبيكي' : 'El Robaikey',
    isAr ? 'حدائق العاصمة' : 'Hadayek Al Assema',
    isAr ? 'مطار العاصمة' : 'Capital Airport',
    isAr ? 'مدينة الفنون والثقافة' : 'Arts and Culture City',
    isAr ? 'العاصمة المركزية' : 'Central Capital (NAC)',
  ];
}

List<String> getLrt10thBranchStations(BuildContext context) {
  final isAr = AppLocalizations.of(context)!.locale == 'ar';
  return [
    isAr ? 'بدر' : 'Badr',
    isAr ? 'المنطقة الصناعية' : 'Industrial Park',
    isAr ? 'مدينة المعرفة' : 'Knowledge City',
  ];
}

List<String> getMetroLine3StationsEN(BuildContext context) {
  return [
    AppLocalizations.of(context)!.en_metroStationADLY_MANSOUR,
    AppLocalizations.of(context)!.en_metroStationEL_HAYKSTEP,
    AppLocalizations.of(context)!.en_metroStationOMAR_IBN_EL_KHATTAB,
    AppLocalizations.of(context)!.en_metroStationQOBA,
    AppLocalizations.of(context)!.en_metroStationHESHAM_BARAKAT,
    AppLocalizations.of(context)!.en_metroStationEL_NOZHA,
    AppLocalizations.of(context)!.en_metroStationNADI_EL_SHAMS,
    AppLocalizations.of(context)!.en_metroStationALF_MASKAN,
    AppLocalizations.of(context)!.en_metroStationHELIOPOLIS,
    AppLocalizations.of(context)!.en_metroStationHAROUN,
    AppLocalizations.of(context)!.en_metroStationEL_AHRAM,
    AppLocalizations.of(context)!.en_metroStationKOLLEYET_EL_BANAT,
    AppLocalizations.of(context)!.en_metroStationEL_ESTAD,
    AppLocalizations.of(context)!.en_metroStationARD_EL_MAARD,
    AppLocalizations.of(context)!.en_metroStationABASIA,
    AppLocalizations.of(context)!.en_metroStationABDO_BASHA,
    AppLocalizations.of(context)!.en_metroStationEL_GEISH,
    AppLocalizations.of(context)!.en_metroStationBAB_EL_SHARIA,
    AppLocalizations.of(context)!.en_metroStationATABA,
    AppLocalizations.of(context)!.en_metroStationGAMAL_ABD_EL_NASSER,
    AppLocalizations.of(context)!.en_metroStationMASPERO,
    AppLocalizations.of(context)!.en_metroStationSAFAA_HEGAZI,
    AppLocalizations.of(context)!.en_metroStationKIT_KAT,
    AppLocalizations.of(context)!.en_metroStationEL_TOUFIQIA,
    AppLocalizations.of(context)!.en_metroStationWADI_EL_NIL,
    AppLocalizations.of(context)!.en_metroStationGAMAET_EL_DOWL_EL_ARABIA,
    AppLocalizations.of(context)!.en_metroStationBOLAK_EL_DAKROUR,
    AppLocalizations.of(context)!.en_metroStationCAIRO_UNIVERSITY,
  ];
}

List<String> getMetroLine3StationsAR(BuildContext context) {
  return [
    AppLocalizations.of(context)!.metroStationADLY_MANSOUR,
    AppLocalizations.of(context)!.metroStationEL_HAYKSTEP,
    AppLocalizations.of(context)!.metroStationOMAR_IBN_EL_KHATTAB,
    AppLocalizations.of(context)!.metroStationQOBA,
    AppLocalizations.of(context)!.metroStationHESHAM_BARAKAT,
    AppLocalizations.of(context)!.metroStationEL_NOZHA,
    AppLocalizations.of(context)!.metroStationNADI_EL_SHAMS,
    AppLocalizations.of(context)!.metroStationALF_MASKAN,
    AppLocalizations.of(context)!.metroStationHELIOPOLIS,
    AppLocalizations.of(context)!.metroStationHAROUN,
    AppLocalizations.of(context)!.metroStationEL_AHRAM,
    AppLocalizations.of(context)!.metroStationKOLLEYET_EL_BANAT,
    AppLocalizations.of(context)!.metroStationEL_ESTAD,
    AppLocalizations.of(context)!.metroStationARD_EL_MAARD,
    AppLocalizations.of(context)!.metroStationABASIA,
    AppLocalizations.of(context)!.metroStationABDO_BASHA,
    AppLocalizations.of(context)!.metroStationEL_GEISH,
    AppLocalizations.of(context)!.metroStationBAB_EL_SHARIA,
    AppLocalizations.of(context)!.metroStationATABA,
    AppLocalizations.of(context)!.metroStationGAMAL_ABD_EL_NASSER,
    AppLocalizations.of(context)!.metroStationMASPERO,
    AppLocalizations.of(context)!.metroStationSAFAA_HEGAZI,
    AppLocalizations.of(context)!.metroStationKIT_KAT,
    AppLocalizations.of(context)!.metroStationEL_TOUFIQIA,
    AppLocalizations.of(context)!.metroStationWADI_EL_NIL,
    AppLocalizations.of(context)!.metroStationGAMAET_EL_DOWL_EL_ARABIA,
    AppLocalizations.of(context)!.metroStationBOLAK_EL_DAKROUR,
    AppLocalizations.of(context)!.metroStationCAIRO_UNIVERSITY,
  ];
}

List<String> getAllMetroStations(BuildContext context) {
  final lrtMain = getLrtMainStations(context);
  final lrtNac = getLrtNacBranchStations(context);
  final lrt10th = getLrt10thBranchStations(context);
  return [
    AppLocalizations.of(context)!.metroStationHELWAN,
    AppLocalizations.of(context)!.metroStationAIN_HELWAN,
    AppLocalizations.of(context)!.metroStationHELWAN_UNIVERSITY,
    AppLocalizations.of(context)!.metroStationWADI_HOF,
    AppLocalizations.of(context)!.metroStationHADAYEK_HELWAN,
    AppLocalizations.of(context)!.metroStationEL_MAASARA,
    AppLocalizations.of(context)!.metroStationTORA_EL_ASMANT,
    AppLocalizations.of(context)!.metroStationKOZZIKA,
    AppLocalizations.of(context)!.metroStationTORA_EL_BALAD,
    AppLocalizations.of(context)!.metroStationTHAKANAT_EL_MAADI,
    AppLocalizations.of(context)!.metroStationMAADI,
    AppLocalizations.of(context)!.metroStationHADAYEK_EL_MAADI,
    AppLocalizations.of(context)!.metroStationDAR_EL_SALAM,
    AppLocalizations.of(context)!.metroStationEL_ZAHRAA,
    AppLocalizations.of(context)!.metroStationMAR_GIRGIS,
    AppLocalizations.of(context)!.metroStationEL_MALEK_EL_SALEH,
    AppLocalizations.of(context)!.metroStationSAYEDA_ZEINAB,
    AppLocalizations.of(context)!.metroStationSAAD_ZAGHLOUL,
    AppLocalizations.of(context)!.metroStationSADAT,
    AppLocalizations.of(context)!.metroStationGAMAL_ABD_EL_NASSER,
    AppLocalizations.of(context)!.metroStationORABI,
    AppLocalizations.of(context)!.metroStationEL_SHOHADAAH,
    AppLocalizations.of(context)!.metroStationGHAMRA,
    AppLocalizations.of(context)!.metroStationEL_DEMERDASH,
    AppLocalizations.of(context)!.metroStationMANSHIET_EL_SADR,
    AppLocalizations.of(context)!.metroStationKOBRI_EL_QOBBA,
    AppLocalizations.of(context)!.metroStationHAMMAMAT_EL_QOBBA,
    AppLocalizations.of(context)!.metroStationSARAY_EL_QOBBA,
    AppLocalizations.of(context)!.metroStationHADAYEK_EL_ZAITOUN,
    AppLocalizations.of(context)!.metroStationHELMEYET_EL_ZAITOUN,
    AppLocalizations.of(context)!.metroStationEL_MATARYA,
    AppLocalizations.of(context)!.metroStationAIN_SHAMS,
    AppLocalizations.of(context)!.metroStationEZBET_EL_NAKHL,
    AppLocalizations.of(context)!.metroStationEL_MARG,
    AppLocalizations.of(context)!.metroStationNEW_EL_MARG,
    AppLocalizations.of(context)!.metroStationEL_MOUNIB,
    AppLocalizations.of(context)!.metroStationSAQYET_MAKKI,
    AppLocalizations.of(context)!.metroStationOM_EL_MASRYEEN,
    AppLocalizations.of(context)!.metroStationGIZA,
    AppLocalizations.of(context)!.metroStationFEISAL,
    AppLocalizations.of(context)!.metroStationCAIRO_UNIVERSITY,
    AppLocalizations.of(context)!.metroStationEL_BEHOUS,
    AppLocalizations.of(context)!.metroStationEL_DOKKI,
    AppLocalizations.of(context)!.metroStationOPERA,
    AppLocalizations.of(context)!.metroStationMOHAMED_NAGUIB,
    AppLocalizations.of(context)!.metroStationATABA,
    AppLocalizations.of(context)!.metroStationMASARA,
    AppLocalizations.of(context)!.metroStationROUD_EL_FARAG,
    AppLocalizations.of(context)!.metroStationSAINT_TERESA,
    AppLocalizations.of(context)!.metroStationKHALAFAWEY,
    AppLocalizations.of(context)!.metroStationMEZALLAT,
    AppLocalizations.of(context)!.metroStationKOLLEYET_EL_ZERA3A,
    AppLocalizations.of(context)!.metroStationSHOUBRA_EL_KHEIMA,
    AppLocalizations.of(context)!.metroStationADLY_MANSOUR,
    AppLocalizations.of(context)!.metroStationEL_HAYKSTEP,
    AppLocalizations.of(context)!.metroStationOMAR_IBN_EL_KHATTAB,
    AppLocalizations.of(context)!.metroStationQOBA,
    AppLocalizations.of(context)!.metroStationHESHAM_BARAKAT,
    AppLocalizations.of(context)!.metroStationEL_NOZHA,
    AppLocalizations.of(context)!.metroStationNADI_EL_SHAMS,
    AppLocalizations.of(context)!.metroStationALF_MASKAN,
    AppLocalizations.of(context)!.metroStationHELIOPOLIS,
    AppLocalizations.of(context)!.metroStationHAROUN,
    AppLocalizations.of(context)!.metroStationEL_AHRAM,
    AppLocalizations.of(context)!.metroStationKOLLEYET_EL_BANAT,
    AppLocalizations.of(context)!.metroStationEL_ESTAD,
    AppLocalizations.of(context)!.metroStationARD_EL_MAARD,
    AppLocalizations.of(context)!.metroStationABASIA,
    AppLocalizations.of(context)!.metroStationABDO_BASHA,
    AppLocalizations.of(context)!.metroStationEL_GEISH,
    AppLocalizations.of(context)!.metroStationBAB_EL_SHARIA,
    AppLocalizations.of(context)!.metroStationMASPERO,
    AppLocalizations.of(context)!.metroStationSAFAA_HEGAZI,
    AppLocalizations.of(context)!.metroStationKIT_KAT,
    AppLocalizations.of(context)!.metroStationSUDAN,
    AppLocalizations.of(context)!.metroStationIMBABA,
    AppLocalizations.of(context)!.metroStationEL_BOHY,
    AppLocalizations.of(context)!.metroStationEL_QAWMEYA,
    AppLocalizations.of(context)!.metroStationEL_TARIQ_EL_DAIRY,
    AppLocalizations.of(context)!.metroStationROD_EL_FARAG_AXIS,
    AppLocalizations.of(context)!.metroStationEL_TOUFIQIA,
    AppLocalizations.of(context)!.metroStationWADI_EL_NIL,
    AppLocalizations.of(context)!.metroStationGAMAET_EL_DOWL_EL_ARABIA,
    AppLocalizations.of(context)!.metroStationBOLAK_EL_DAKROUR,
    ...lrtMain.where((s) => s != AppLocalizations.of(context)!.metroStationADLY_MANSOUR),
    ...lrtNac.where((s) => !lrtMain.contains(s)),
    ...lrt10th.where((s) => !lrtMain.contains(s) && !lrtNac.contains(s)),
  ];
}

const List<List<double>> metroLine1StationsCoordinates = [
  [29.848982, 31.334231], // Helwan
  [29.8626524, 31.3250527], // Ain Helwan
  [29.8694514, 31.3200669], // Helwan University
  [29.879444, 31.313333], // Wadi Hof
  [29.897136, 31.3039662], // Hadayek Helwan
  [29.9060784, 31.2995158], // El-Maasara
  [29.9259651, 31.2875444], // Tora El-Asmant
  [29.936259, 31.2818206], // Kozzika
  [29.9467633, 31.27298], // Tora El-Balad
  [29.9533009, 31.262956], // Sakanat El-Maadi
  [29.9603028, 31.2576431], // Maadi
  [29.9701432, 31.2506075], // Hadayek El-Maadi
  [29.982076, 31.242211], // Dar El-Salam
  [29.995487, 31.231220], // El-Zahraa'
  [30.006096, 31.229654], // Mar Girgis
  [30.017714, 31.231231], // El-Malek El-Saleh
  [30.029196, 31.235429], // Al-Sayeda Zeinab
  [30.037016, 31.238415], // Saad Zaghloul
  [30.044141, 31.234446], // Sadat
  [30.053501, 31.238834], // Nasser
  [30.056663, 31.242250], // Orabi
  [31.264689, 31.246157], // Al-Shohadaa
  [30.068949, 31.264689], // Ghamra
  [30.077285, 31.277826], // El-Demerdash
  [30.082262, 31.287938], // Manshiet El-Sadr
  [30.087199, 31.294120], // Kobri El-Qobba
  [30.091140, 31.299031], // Hammamat El-Qobba
  [30.097636, 31.304601], // Saray El-Qobba
  [30.105890, 31.310517], // Hadayeq El-Zaitoun
  [30.113270, 31.314008], // Helmeyet El-Zaitoun
  [30.121317, 31.313771], // El-Matareyya
  [30.131047, 31.319123], // Ain Shams
  [30.139334, 31.324501], // Ezbet El-Nakhl
  [30.152079, 31.335691], // El-Marg
  [30.163648, 31.338369] // New El-Marg
];

const List<List<double>> metroLine2StationsCoordinates = [
  [29.98139, 31.21194], // El-Mounib
  [29.99556, 31.20861], // Sakiat Mekky
  [30.00528, 31.20806], // Omm El-Masryeen
  [30.01056, 31.20694], // EL-Giza
  [30.01722, 31.20389], // Faisal
  [30.02611, 31.20111], // Cairo University
  [30.03583, 31.20028], // EL-Bohoth
  [30.03833, 31.21194], // Dokki
  [30.04167, 31.22528], // Opera
  [30.04444, 31.23556], // Sadat
  [30.04528, 31.24417], // Mohamed Naguib
  [30.0525, 31.24694], // Attaba
  [30.0625, 31.24611], // Al-Shohadaa
  [30.07111, 31.245], // Masarra
  [30.08056, 31.24556], // Road El-Farag
  [30.08833, 31.24556], // St. Teresa
  [30.09806, 31.24528], // Khalafawy
  [30.105, 31.24667], // Mezallat
  [30.11389, 31.24861], // Kolleyyet El-Zeraa
  [30.1225, 31.24472] // Shubra El-Kheima
];

//check
const List<List<double>> metroLine3Branch1StationsCoordinates = [
  [30.14694, 31.42139], // Adly Mansour
  [30.14389, 31.40472], // EL-Haykestep
  [30.14056, 31.39417], // Omar Ibn El-Khattab
  [30.13472, 31.38389], // Qobaa
  [30.13111, 31.37278], // Hesham Barakat
  [30.12833, 31.36], // El-Nozha
  [30.12222, 31.34472], // Nadi El-Shams
  [30.11806, 31.33972], // Alf Maskan
  [30.10806, 31.33806], // Heliopolis Square
  [30.10111, 31.33278], // Haroun
  [30.09139, 31.32639], // Al-Ahram
  [30.08361, 31.32833], // Koleyet El-Banat
  [30.07306, 31.3175], // Stadium
  [30.07333, 31.30111], // Fair Zone
  [30.06972, 31.28083], // Abbassia
  [30.06472, 31.27472], // Abdou Pasha
  [30.06194, 31.26694], // EL-Geish
  [30.05389, 31.25611], // Bab EL-Shaaria
  [30.0525, 31.24694], // Attaba
  [30.05361, 31.23889], // Nasser
  [30.05556, 31.23222], // Maspero
  [30.0625, 31.2225], // Safaa Hegazy
  [30.06667, 31.21306], // Kit Kat
  [30.06972, 31.20528], // Sudan Street
  [30.07583, 31.2075], // Imbaba
  [30.08222, 31.21056], // El-Bohy
  [30.09333, 31.20944], // Al-Qawmeya Al-Arabiya
  [30.09639, 31.19972], // Ring Road
  [30.10194, 31.18417] // Rod al-Farag Axis
];

const List<List<double>> metroLine3Branch2StationsCoordinates = [
  [30.14694, 31.42139], // Adly Mansour
  [30.14389, 31.40472], // EL-Haykestep
  [30.14056, 31.39417], // Omar Ibn El-Khattab
  [30.13472, 31.38389], // Qobaa
  [30.13111, 31.37278], // Hesham Barakat
  [30.12833, 31.36], // El-Nozha
  [30.12222, 31.34472], // Nadi El-Shams
  [30.11806, 31.33972], // Alf Maskan
  [30.10806, 31.33806], // Heliopolis Square
  [30.10111, 31.33278], // Haroun
  [30.09139, 31.32639], // Al-Ahram
  [30.08361, 31.32833], // Koleyet El-Banat
  [30.07306, 31.3175], // Stadium
  [30.07333, 31.30111], // Fair Zone
  [30.06972, 31.28083], // Abbassia
  [30.06472, 31.27472], // Abdou Pasha
  [30.06194, 31.26694], // EL-Geish
  [30.05389, 31.25611], // Bab EL-Shaaria
  [30.0525, 31.24694], // Attaba
  [30.05361, 31.23889], // Nasser
  [30.05556, 31.23222], // Maspero
  [30.0625, 31.2225], // Safaa Hegazy
  [30.06667, 31.21306], // Kit Kat
  [30.06528, 31.2025], // El-Tawfikeya
  [30.05833, 31.20111], // Wadi El-Nil
  [30.05083, 31.19972], // Gamaat EL-Dowal Al-Arabiya
  [30.03611, 31.19639], // Bulaq El-Dakroor
  [30.02611, 31.20111] // Cairo University
];

const List<List<double>> lrtMainStationsCoordinates = [
  [30.14661096, 31.42124641], // Adly Mansour
  [30.16329751, 31.48149008], // El-Obour
  [30.17310314, 31.55416228], // Future
  [30.17932584, 31.60585802], // El Shorouk
  [30.18405322, 31.65273091], // New Heliopolis
  [30.17527303, 31.7160199], // Badr
];

const List<List<double>> lrtNacBranchStationsCoordinates = [
  [30.17527303, 31.7160199], // Badr
  [30.16658308, 31.75241221], // El Robaikey
  [30.1369591, 31.80688173], // Hadayek Al Assema
  [30.0767382, 31.78305736], // Capital Airport
  [30.01433519, 31.72513259], // Arts and Culture City
  [30.0050, 31.7850], // Central Capital (NAC)
];

const List<List<double>> lrt10thBranchStationsCoordinates = [
  [30.17527303, 31.7160199], // Badr
  [30.20461601, 31.7154668], // Industrial Park
  [30.2308951, 31.69166131], // Knowledge City
];

const List<List<double>> allMetroStationsCoordinates = [
  [29.848982, 31.334231], // Helwan
  [29.8626524, 31.3250527], // Ain Helwan
  [29.8694514, 31.3200669], // Helwan University
  [29.879444, 31.313333], // Wadi Hof
  [29.897136, 31.3039662], // Hadayek Helwan
  [29.9060784, 31.2995158], // El-Maasara
  [29.9259651, 31.2875444], // Tora El-Asmant
  [29.936259, 31.2818206], // Kozzika
  [29.9467633, 31.27298], // Tora El-Balad
  [29.9533009, 31.262956], // Sakanat El-Maadi
  [29.9603028, 31.2576431], // Maadi
  [29.9701432, 31.2506075], // Hadayek El-Maadi
  [29.982076, 31.242211], // Dar El-Salam
  [29.995487, 31.231220], // El-Zahraa'
  [30.006096, 31.229654], // Mar Girgis
  [30.017714, 31.231231], // El-Malek El-Saleh
  [30.029196, 31.235429], // Al-Sayeda Zeinab
  [30.037016, 31.238415], // Saad Zaghloul
  [30.044141, 31.234446], // Sadat
  [30.053501, 31.238834], // Nasser
  [30.056663, 31.242250], // Orabi
  [31.264689, 31.246157], // Al-Shohadaa
  [30.068949, 31.264689], // Ghamra
  [30.077285, 31.277826], // El-Demerdash
  [30.082262, 31.287938], // Manshiet El-Sadr
  [30.087199, 31.294120], // Kobri El-Qobba
  [30.091140, 31.299031], // Hammamat El-Qobba
  [30.097636, 31.304601], // Saray El-Qobba
  [30.105890, 31.310517], // Hadayeq El-Zaitoun
  [30.113270, 31.314008], // Helmeyet El-Zaitoun
  [30.121317, 31.313771], // El-Matareyya
  [30.131047, 31.319123], // Ain Shams
  [30.139334, 31.324501], // Ezbet El-Nakhl
  [30.152079, 31.335691], // El-Marg
  [30.163648, 31.338369], // New El-Marg
  [29.98139, 31.21194], // El-Mounib
  [29.99556, 31.20861], // Sakiat Mekky
  [30.00528, 31.20806], // Omm El-Masryeen
  [30.01056, 31.20694], // EL-Giza
  [30.01722, 31.20389], // Faisal
  [30.02611, 31.20111], // Cairo University
  [30.03583, 31.20028], // EL-Bohoth
  [30.03833, 31.21194], // Dokki
  [30.04167, 31.22528], // Opera
  [30.04528, 31.24417], // Mohamed Naguib
  [30.0525, 31.24694], // Attaba
  [30.07111, 31.245], // Masarra
  [30.08056, 31.24556], // Road El-Farag
  [30.08833, 31.24556], // St. Teresa
  [30.09806, 31.24528], // Khalafawy
  [30.105, 31.24667], // Mezallat
  [30.11389, 31.24861], // Kolleyyet El-Zeraa
  [30.1225, 31.24472], // Shubra El-Kheima
  [30.14694, 31.42139], // Adly Mansour
  [30.14389, 31.40472], // EL-Haykestep
  [30.14056, 31.39417], // Omar Ibn El-Khattab
  [30.13472, 31.38389], // Qobaa
  [30.13111, 31.37278], // Hesham Barakat
  [30.12833, 31.36], // El-Nozha
  [30.12222, 31.34472], // Nadi El-Shams
  [30.11806, 31.33972], // Alf Maskan
  [30.10806, 31.33806], // Heliopolis Square
  [30.10111, 31.33278], // Haroun
  [30.09139, 31.32639], // Al-Ahram
  [30.08361, 31.32833], // Koleyet El-Banat
  [30.07306, 31.3175], // Stadium
  [30.07333, 31.30111], // Fair Zone
  [30.06972, 31.28083], // Abbassia
  [30.06472, 31.27472], // Abdou Pasha
  [30.06194, 31.26694], // EL-Geish
  [30.05389, 31.25611], // Bab EL-Shaaria
  [30.05556, 31.23222], // Maspero
  [30.0625, 31.2225], // Safaa Hegazy
  [30.06667, 31.21306], // Kit Kat
  [30.06972, 31.20528], // Sudan Street
  [30.07583, 31.2075], // Imbaba
  [30.08222, 31.21056], // El-Bohy
  [30.09333, 31.20944], // Al-Qawmeya Al-Arabiya
  [30.09639, 31.19972], // Ring Road
  [30.10194, 31.18417], // Rod al-Farag Axis
  [30.06528, 31.2025], // El-Tawfikeya
  [30.05833, 31.20111], // Wadi El-Nil
  [30.05083, 31.19972], // Gamaat EL-Dowal Al-Arabiya
  [30.03611, 31.19639], // Bulaq El-Dakroor
];

final metroLine1Coordinates = <List<int>>[
  [632, 903],
  [613, 873],
  [596, 848],
  [584, 823],
  [566, 798],
  [554, 774],
  [538, 749],
  [523, 724],
  [509, 699],
  [493, 674],
  [481, 650],
  [468, 624],
  [467, 599],
  [467, 576],
  [467, 551],
  [467, 526],
  [467, 501],
  [467, 476],
  [467, 448],
  [467, 359],
  [482, 337],
  [498, 316],
  [520, 289],
  [535, 269],
  [551, 249],
  [565, 228],
  [580, 210],
  [596, 190],
  [612, 169],
  [627, 151],
  [640, 130],
  [655, 110],
  [671, 91],
  [685, 71],
  [705, 48]
];

final metroLine2Coordinates = <List<int>>[
  [309, 649],
  [309, 613],
  [311, 585],
  [311, 557],
  [311, 529],
  [309, 501],
  [337, 450],
  [375, 450],
  [412, 450],
  [467, 448],
  [524, 420],
  [537, 358],
  [498, 316],
  [496, 275],
  [498, 252],
  [498, 228],
  [498, 204],
  [496, 180],
  [487, 154],
  [470, 121]
];

final metroLine3Branch1Coordinates = <List<int>>[
  [873, 288],
  [872, 246],
  [873, 211],
  [853, 172],
  [830, 172],
  [809, 175],
  [789, 188],
  [769, 202],
  [750, 214],
  [730, 228],
  [711, 241],
  [691, 253],
  [672, 267],
  [652, 280],
  [632, 294],
  [613, 306],
  [594, 319],
  [574, 333],
  [537, 358],
  [467, 359],
  [404, 330],
  [364, 313],
  [334, 297],
  [325, 261],
  [325, 225],
  [325, 188],
  [325, 152],
  [325, 121],
  [327, 77]
];

final metroLine3Branch2Coordinates = <List<int>>[
  [873, 288],
  [872, 246],
  [873, 211],
  [853, 172],
  [830, 172],
  [809, 175],
  [789, 188],
  [769, 202],
  [750, 214],
  [730, 228],
  [711, 241],
  [691, 253],
  [672, 267],
  [652, 280],
  [632, 294],
  [613, 306],
  [594, 319],
  [574, 333],
  [537, 358],
  [467, 359],
  [404, 330],
  [364, 313],
  [334, 297],
  [280, 341],
  [272, 370],
  [275, 428],
  [286, 464],
  [311, 501]
];

final lrtMainCoordinates = <List<int>>[
  [873, 288],
  [920, 270],
  [970, 250],
  [1020, 235],
  [1065, 220],
  [1110, 205],
];

final lrtNacBranchCoordinates = <List<int>>[
  [1110, 205],
  [1140, 228],
  [1170, 255],
  [1200, 290],
  [1230, 325],
  [1260, 360],
];

final lrt10thBranchCoordinates = <List<int>>[
  [1110, 205],
  [1135, 180],
  [1160, 150],
];

void showCustomToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: const Color(
        0xFF029692), // Updated background color to match the page theme
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
