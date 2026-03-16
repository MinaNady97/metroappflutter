// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get locale => 'zh';

  @override
  String get departureStationTitle => '出发站';

  @override
  String get arrivalStationTitle => '到达站';

  @override
  String get departureStationHint => '选择出发站';

  @override
  String get arrivalStationHint => '选择到达站';

  @override
  String get destinationFieldLabel => '输入目的地';

  @override
  String get findButtonText => '查找';

  @override
  String get showRoutesButtonText => '显示路线';

  @override
  String get pleaseSelectDeparture => '请选择出发站。';

  @override
  String get pleaseSelectArrival => '请选择到达站。';

  @override
  String get selectDifferentStations => '请选择不同的站点。';

  @override
  String get nearestStationLabel => '最近站点';

  @override
  String get addressNotFound => '未找到地址，请尝试更详细的信息。';

  @override
  String get invalidDataFormat => '数据格式无效';

  @override
  String get routeToNearest => '前往最近站点的路线';

  @override
  String get routeToDestination => '前往目的地的路线';

  @override
  String get pleaseClickOnMyLocation => '请先点击定位按钮';

  @override
  String get mustTypeADestination => '请先输入目的地。';

  @override
  String get estimatedTravelTime => '预计行程时间';

  @override
  String get ticketPrice => '票价';

  @override
  String get noOfStations => '站数';

  @override
  String get changeAt => '在此换乘';

  @override
  String get totalTravelTime => '预计总行程时间';

  @override
  String get changeTime => '换乘预计时间';

  @override
  String get firstTake => '第一段';

  @override
  String get firstDirection => '第一方向';

  @override
  String get firstDeparture => '第一出发';

  @override
  String get firstArrival => '第一到达';

  @override
  String get firstIntermediateStations => '第一中间站';

  @override
  String get secondTake => '第二段';

  @override
  String get secondDirection => '第二方向';

  @override
  String get secondDeparture => '第二出发';

  @override
  String get secondArrival => '第二到达';

  @override
  String get secondIntermediateStations => '第二中间站';

  @override
  String get thirdTake => '第三段';

  @override
  String get thirdDirection => '第三方向';

  @override
  String get thirdDeparture => '第三出发';

  @override
  String get thirdArrival => '第三到达';

  @override
  String get thirdIntermediateStations => '第三中间站';

  @override
  String get error => '错误：';

  @override
  String get mustTypeDestination => '请先输入目的地。';

  @override
  String get noRoutesFound => '未找到路线';

  @override
  String get routeDetails => '路线详情';

  @override
  String get departure => '出发：';

  @override
  String get arrival => '到达：';

  @override
  String get take => '乘坐：';

  @override
  String get direction => '方向：';

  @override
  String get intermediateStations => '中间站：';

  @override
  String egp(Object price) {
    return '$price EGP';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => '显示站点';

  @override
  String get hideStations => '隐藏站点';

  @override
  String get showRoute => '显示路线';

  @override
  String get metro1 => '地铁1号线';

  @override
  String get metro2 => '地铁2号线';

  @override
  String get metro3branch1 => '地铁3号线支线 ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => '地铁3号线支线 CAIRO UNIVERSITY';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return '距$stationName的距离为$distance米';
  }

  @override
  String reachedStation(Object stationName) {
    return '您已到达$stationName';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return '当前站$currentStationName，下一站$nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return '当前站$currentStationName，下一站$nextStationName，换乘$lineName方向$direction';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return '当前站$currentStationName，下一站$nextStationName即为您的到达站';
  }

  @override
  String get finalStationReached => '已到达终点站，行程结束';

  @override
  String get exchangeStation => '换乘站';

  @override
  String get intermediateStationsTitle => '中间站';

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
  String get appTitle => '开罗地铁指南';

  @override
  String get welcomeTitle => '规划您的地铁之旅';

  @override
  String get welcomeSubtitle => '最佳路线、最近站点及地铁信息';

  @override
  String get planYourRoute => '规划路线';

  @override
  String get findNearestStation => '查找最近站点';

  @override
  String get scheduleLabel => '地铁时刻表';

  @override
  String get metroMapLabel => '地铁地图';

  @override
  String get appInfoTitle => '关于开罗地铁指南';

  @override
  String get appInfoDescription => '开罗地铁系统官方指南。路线、站点、时刻表等更多信息。';

  @override
  String get close => '关闭';

  @override
  String get languageSwitchTitle => '切换语言';

  @override
  String get routeOptions => '路线选项';

  @override
  String get fastestRoute => '最快路线';

  @override
  String get shortestRoute => '最短路线';

  @override
  String get fewestTransfers => '换乘最少';

  @override
  String get estimatedTime => '预计时间';

  @override
  String get estimatedFare => '预计票价';

  @override
  String stationsCount(Object count) {
    return '$count站';
  }

  @override
  String get minutesAbbr => '分';

  @override
  String get exitDialogTitle => '退出应用？';

  @override
  String get exitDialogSubtitle => '确定要退出\n开罗地铁导航吗？';

  @override
  String get exitDialogStay => '留下';

  @override
  String get exitDialogExit => '退出';

  @override
  String get egpCurrency => 'EGP';

  @override
  String get departureTime => '出发';

  @override
  String get arrivalTime => '到达';

  @override
  String get transferStations => '换乘：';

  @override
  String get noInternetTitle => '无网络连接';

  @override
  String get noInternetMessage => '离线时某些功能可能不可用';

  @override
  String get tryAgain => '重试';

  @override
  String get offlineMode => '离线模式';

  @override
  String lastUpdated(Object date) {
    return '最后更新：$date';
  }

  @override
  String get searchHistory => '搜索历史';

  @override
  String get clearHistory => '清除历史';

  @override
  String get noHistory => '暂无搜索历史';

  @override
  String get favorites => '收藏';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get shareRoute => '分享路线';

  @override
  String get amenitiesTitle => '站点设施';

  @override
  String get accessibility => '无障碍设施';

  @override
  String get parking => '停车场';

  @override
  String get toilets => '卫生间';

  @override
  String get atm => '自动取款机';

  @override
  String get refresh => '刷新';

  @override
  String get loading => '加载中...';

  @override
  String get errorOccurred => '发生错误';

  @override
  String get retry => '重试';

  @override
  String get noResults => '未找到结果';

  @override
  String get allLines => '所有线路';

  @override
  String get line1 => '1号线';

  @override
  String get line2 => '2号线';

  @override
  String get line3 => '3号线';

  @override
  String get line4 => '4号线';

  @override
  String get operatingHours => '运营时间';

  @override
  String get firstTrain => '首班车';

  @override
  String get lastTrain => '末班车';

  @override
  String get peakHours => '高峰时段';

  @override
  String get offPeakHours => '非高峰时段';

  @override
  String get weekdays => '工作日';

  @override
  String get weekend => '周末';

  @override
  String get holidays => '节假日';

  @override
  String get specialSchedule => '特别时刻表';

  @override
  String get alerts => '服务提醒';

  @override
  String get noAlerts => '暂无服务提醒';

  @override
  String get viewAllStations => '查看所有站点';

  @override
  String get nearbyStations => '附近站点';

  @override
  String distanceAway(Object distance) {
    return '$distance千米外';
  }

  @override
  String walkingTime(Object minutes) {
    return '步行$minutes分钟';
  }

  @override
  String get metroEtiquette => '乘车礼仪';

  @override
  String get safetyTips => '安全提示';

  @override
  String get feedback => '发送反馈';

  @override
  String get rateApp => '评价应用';

  @override
  String get settings => '设置';

  @override
  String get notifications => '通知';

  @override
  String get darkMode => '深色模式';

  @override
  String get language => '语言';

  @override
  String get recentTripsLabel => '最近行程';

  @override
  String get favoritesLabel => '收藏';

  @override
  String get metroLinesTitle => '地铁线路';

  @override
  String get line1Name => '1号线';

  @override
  String get line2Name => '2号线';

  @override
  String get line3Name => '3号线';

  @override
  String get line4Name => '4号线';

  @override
  String get stationsLabel => '站';

  @override
  String get comingSoonLabel => '即将开通';

  @override
  String get viewFullMap => '查看完整地图';

  @override
  String get nearestStationFound => '已找到最近站点';

  @override
  String get stationFound => '已找到站点';

  @override
  String get accessibilityLabel => '无障碍';

  @override
  String get seeAll => '查看全部';

  @override
  String get allMetroLines => '所有地铁线路';

  @override
  String get aroundStationsTitle => '站点周边';

  @override
  String get station => '站';

  @override
  String get seeFacilities => '查看设施';

  @override
  String get subscriptionInfoTitle => '地铁套票';

  @override
  String get subscriptionInfoSubtitle => '了解票价、区域和购买地点';

  @override
  String get facilitiesTitle => '站点设施';

  @override
  String get parkingTitle => '停车场';

  @override
  String get parkingDescription => '停车设施情况';

  @override
  String get toiletsTitle => '卫生间';

  @override
  String get toiletsDescription => '公共厕所情况';

  @override
  String get elevatorsTitle => '电梯';

  @override
  String get elevatorsDescription => '无障碍电梯';

  @override
  String get shopsTitle => '商店';

  @override
  String get shopsDescription => '便利店和小摊';

  @override
  String get available => '可用';

  @override
  String get notAvailable => '不可用';

  @override
  String get nearbyAttractions => '附近景点';

  @override
  String get attraction1 => '埃及博物馆';

  @override
  String get attraction2 => '汗哈利利市场';

  @override
  String get attraction3 => '解放广场';

  @override
  String get attractionDescription => '开罗最著名的地标之一，从本站可轻松到达';

  @override
  String get minutes => '分钟';

  @override
  String get walkingDistance => '步行距离';

  @override
  String get accessibilityInfoTitle => '无障碍功能';

  @override
  String get wheelchairTitle => '轮椅通道';

  @override
  String get wheelchairDescription => '所有站点均设有轮椅通道';

  @override
  String get hearingImpairmentTitle => '听力障碍';

  @override
  String get hearingImpairmentDescription => '为听力障碍人士提供视觉指示';

  @override
  String get subscriptionTypes => '套票类型';

  @override
  String get dailyPass => '日票';

  @override
  String get dailyPassDescription => '当日所有线路无限次乘坐';

  @override
  String get weeklyPass => '周票';

  @override
  String get weeklyPassDescription => '7天内所有线路无限次乘坐';

  @override
  String get monthlyPass => '月票';

  @override
  String get monthlyPassDescription => '30天内所有线路无限次乘坐';

  @override
  String get purchaseNow => '立即购买';

  @override
  String get zonesTitle => '票价区域';

  @override
  String get zonesDescription => '开罗地铁按区域收费，票价取决于经过的区域数量。';

  @override
  String get whereToBuyTitle => '购票地点';

  @override
  String get metroStations => '地铁站';

  @override
  String get metroStationsDescription => '所有站点售票处均有售';

  @override
  String get authorizedVendors => '授权销售商';

  @override
  String get authorizedVendorsDescription => '站点附近选定的售货亭和商店';

  @override
  String get touristGuideTitle => '旅游指南';

  @override
  String get popularDestinations => '热门目的地';

  @override
  String get pyramidsTitle => '金字塔';

  @override
  String get pyramidsDescription => '古代世界最后保存的奇迹';

  @override
  String get egyptianMuseumTitle => '埃及博物馆';

  @override
  String get egyptianMuseumDescription => '收藏世界上最大的法老文物';

  @override
  String get khanElKhaliliTitle => '汗哈利利市场';

  @override
  String get khanElKhaliliDescription => '追溯至1382年的历史市场';

  @override
  String get essentialPhrases => '基本阿拉伯语短语';

  @override
  String get phrase1 => '票价是多少？';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => '地铁站在哪里？';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => '这去...吗？';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => '旅行贴士';

  @override
  String get peakHoursTitle => '高峰时段';

  @override
  String get peakHoursDescription => '避开早7-9点和下午3-6点，列车不那么拥挤';

  @override
  String get safetyTitle => '安全';

  @override
  String get safetyDescription => '妥善保管贵重物品，注意周围环境';

  @override
  String get ticketsTitle => '车票';

  @override
  String get ticketsDescription => '离站前请保留您的车票';

  @override
  String get lengthLabel => '长度';

  @override
  String get viewDetails => '查看详情';

  @override
  String get whereToBuyDescription => '购买车票、充值钱包卡或订阅季票';

  @override
  String get ticketsBullet1 => '所有售票处均有售';

  @override
  String get ticketsBullet2 => '自动售票机（Haroun至Adly Mansour站）';

  @override
  String get ticketsBullet3 => '类型：普通、老年、特殊需求';

  @override
  String get walletCardTitle => '钱包卡';

  @override
  String get walletBullet1 => '售票处和自动售票机均有售（Haroun至Adly Mansour）';

  @override
  String get walletBullet2 => '办卡费：80埃磅（首次最低充值40埃磅）';

  @override
  String get walletBullet3 => '充值范围：20至400埃磅';

  @override
  String get walletBullet4 => '可重复使用和转让';

  @override
  String get walletBullet5 => '比单程票更节省时间';

  @override
  String get seasonalCardTitle => '季票';

  @override
  String get seasonalBullet1 => '适用人群：普通市民、学生、老年人（60岁以上）、特殊需求人士';

  @override
  String get requirementsTitle => '所需材料：';

  @override
  String get seasonalBullet2 => '前往Attaba、Abbasia、Heliopolis或Adly Mansour的订阅办公室';

  @override
  String get seasonalBullet3 => '提供2张照片（4x6格式）';

  @override
  String get additionalRequirementsTitle => '额外要求：';

  @override
  String get studentReq => '学生：学校盖章表格 + 证件/出生证明 + 付款收据';

  @override
  String get elderlyReq => '老年人：证明年龄的有效证件';

  @override
  String get specialNeedsReq => '特殊需求：政府颁发的证明文件';

  @override
  String get learnMore => '了解更多';

  @override
  String get stationDetailsTitle => '站点详情';

  @override
  String get stationMapTitle => '站点地图';

  @override
  String get allOperationalLabel => '所有线路正常运营';

  @override
  String get statusLiveLabel => '实时';

  @override
  String get homepageSubtitle => '您的地铁和轻轨智能向导';

  @override
  String get greetingMorning => '早上好';

  @override
  String get greetingAfternoon => '下午好';

  @override
  String get greetingEvening => '晚上好';

  @override
  String get greetingNight => '晚安';

  @override
  String get planYourRouteSubtitle => '查找站点间最快路线';

  @override
  String get recentSearchesLabel => '最近搜索';

  @override
  String get googleMapsLinkDetected => '检测到Google地图链接';

  @override
  String get pickFromMapLabel => '从地图选择';

  @override
  String get quickActionsTitle => '快捷操作';

  @override
  String get tapToLocateLabel => '点击查找最近站点';

  @override
  String get touristHighlightsLabel => '旅游景点';

  @override
  String get viewPlansLabel => '查看订阅方案';

  @override
  String get lrtLineName => '轻轨线路';

  @override
  String get exploreAreaTitle => '探索周边';

  @override
  String get exploreAreaSubtitle => '发现地铁站附近的有趣地方';

  @override
  String get tapToExploreLabel => '点击站点探索';

  @override
  String get promoMonthlyTitle => '月票';

  @override
  String get promoMonthlySubtitle => '30天无限次乘坐';

  @override
  String get promoMonthlyTag => '最超值';

  @override
  String get promoStudentTitle => '学生票';

  @override
  String get promoStudentSubtitle => '学生享5折优惠';

  @override
  String get promoStudentTag => '学生';

  @override
  String get promoFamilyTitle => '家庭票';

  @override
  String get promoFamilySubtitle => '一家出行，省更多';

  @override
  String get promoFamilyTag => '家庭';

  @override
  String get buyNowLabel => '立即购买';

  @override
  String get locateMeLabel => '定位中';

  @override
  String get locationServicesDisabled => '位置服务已关闭，请在设置中开启。';

  @override
  String get locationPermissionDenied => '位置权限被拒绝，请在应用设置中允许。';

  @override
  String get locationError => '无法获取您的位置，请重试。';

  @override
  String get leaveNowLabel => '现在出发';

  @override
  String get cairoMetroNetworkLabel => '开罗地铁网络';

  @override
  String get resetViewLabel => '重置视图';

  @override
  String get mapLegendLabel => '地图图例';

  @override
  String get searchStationsHint => '搜索站点...';

  @override
  String get noStationsFound => '未找到站点';

  @override
  String get line1FullName => '1号线 — Helwan / New El-Marg';

  @override
  String get line2FullName => '2号线 — Shubra El-Kheima / El-Mounib';

  @override
  String get line3FullName => '3号线 — Adly Mansour / Kit Kat';

  @override
  String get line4FullName => '4号线';

  @override
  String get monorailEastName => '东部单轨';

  @override
  String get monorailWestName => '西部单轨';

  @override
  String get allLinesStationsLabel => '站';

  @override
  String get underConstructionLabel => '建设中';

  @override
  String get plannedLabel => '规划中';

  @override
  String get transferLabel => '换乘';

  @override
  String get statusMaintenanceLabel => '维护中';

  @override
  String get statusDisruptionLabel => '中断';

  @override
  String get crowdCalmLabel => '空闲';

  @override
  String get crowdModerateLabel => '适中';

  @override
  String get crowdBusyLabel => '拥挤';

  @override
  String get locationDialogNoThanks => '不了';

  @override
  String get locationDialogTurnOn => '开启';

  @override
  String get locationDialogOpenSettings => '打开设置';

  @override
  String get touristGuidePlacesCount => '个值得探索的地方';

  @override
  String get touristGuideDisclaimer => '时间、距离和详情均为近似值，可能有所不同。请在访问前正式核实。';

  @override
  String get touristGuideSearchHint => '搜索景点或车站...';

  @override
  String get touristGuideCategoryAll => '全部';

  @override
  String get touristGuideNoPlaces => '未找到地点';

  @override
  String get touristGuideNoPlacesSub => '尝试不同的搜索或类别';

  @override
  String get photographyTitle => '摄影';

  @override
  String get photographyDescription => '地铁站内禁止拍照。部分景点可能收取相机费用。';

  @override
  String get bestTimeTitle => '最佳游览时间';

  @override
  String get bestTimeDescription => '十月至四月天气最佳。清晨或傍晚游览户外景点效果更好。';

  @override
  String get phrase4 => '谢谢';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => '多少钱？';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => '...在哪里？';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => '我想去...';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => '远吗？';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => '规划路线';

  @override
  String get lineLabel => '线路';

  @override
  String get categoryHistorical => '历史';

  @override
  String get categoryMuseum => '博物馆';

  @override
  String get categoryReligious => '宗教';

  @override
  String get categoryPark => '公园';

  @override
  String get categoryShopping => '购物';

  @override
  String get categoryCulture => '文化';

  @override
  String get categoryNile => '尼罗河';

  @override
  String get categoryHiddenGem => '隐藏宝藏';

  @override
  String get facilityCommercial => '商业';

  @override
  String get facilityCultural => '文化';

  @override
  String get facilityEducational => '教育';

  @override
  String get facilityLandmarks => '地标';

  @override
  String get facilityMedical => '医疗';

  @override
  String get facilityPublicInstitutions => '公共机构';

  @override
  String get facilityPublicSpaces => '公共空间';

  @override
  String get facilityReligious => '宗教';

  @override
  String get facilityServices => '服务';

  @override
  String get facilitySportFacilities => '体育设施';

  @override
  String get facilityStreets => '街道';

  @override
  String get facilitySearchHint => '搜索地点...';

  @override
  String get facilityNoData => '此站暂无设施数据';

  @override
  String get facilityDataSoon => '数据将很快添加';

  @override
  String get facilityClearFilter => '清除筛选';

  @override
  String get facilityPlacesCount => '个地点';

  @override
  String get facilityZoomHint => '捏合并拖动以缩放';

  @override
  String get facilityCategoriesLabel => '类别';

  @override
  String get sortBy => '排序方式';

  @override
  String get sortStops => '站数';

  @override
  String get sortTime => '时间';

  @override
  String get sortFare => '票价';

  @override
  String get sortLines => '线路';

  @override
  String get bestRoute => '最佳';

  @override
  String get hideStops => '隐藏站点';

  @override
  String get showLabel => '显示';

  @override
  String get stopsWord => '站';

  @override
  String get minuteShort => '分钟';

  @override
  String get detectingLocation => '正在检测您的位置...';

  @override
  String get tapToExplore => '点击探索';

  @override
  String get couldNotOpenMaps => '无法打开谷歌地图';

  @override
  String get couldNotGetLocation => '无法获取您的位置。请检查位置权限。';

  @override
  String get googleMapsLabel => '谷歌地图';

  @override
  String get couldNotFindNearestStation => '无法找到最近的车站';

  @override
  String get zoomLabel => '缩放';

  @override
  String transferAtStation(Object station) {
    return '在$station换乘';
  }
}
