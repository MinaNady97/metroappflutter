// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get locale => 'pt';

  @override
  String get departureStationTitle => 'Estação de partida';

  @override
  String get arrivalStationTitle => 'Estação de chegada';

  @override
  String get departureStationHint => 'Selecione a estação de partida';

  @override
  String get arrivalStationHint => 'Selecione a estação de chegada';

  @override
  String get destinationFieldLabel => 'Insira o destino';

  @override
  String get findButtonText => 'Buscar';

  @override
  String get showRoutesButtonText => 'Mostrar rotas';

  @override
  String get pleaseSelectDeparture => 'Selecione a estação de partida.';

  @override
  String get pleaseSelectArrival => 'Selecione a estação de chegada.';

  @override
  String get selectDifferentStations => 'Selecione estações diferentes.';

  @override
  String get nearestStationLabel => 'Estação mais próxima';

  @override
  String get addressNotFound => 'Endereço não encontrado. Tente com mais detalhes.';

  @override
  String get invalidDataFormat => 'Formato de dados inválido';

  @override
  String get routeToNearest => 'Rota para a mais próxima';

  @override
  String get routeToDestination => 'Rota para o destino';

  @override
  String get pleaseClickOnMyLocation => 'Clique primeiro no botão de localização';

  @override
  String get mustTypeADestination => 'Digite um destino primeiro.';

  @override
  String get estimatedTravelTime => 'Tempo estimado de viagem';

  @override
  String get ticketPrice => 'Preço do bilhete';

  @override
  String get noOfStations => 'Número de estações';

  @override
  String get changeAt => 'Você vai trocar em';

  @override
  String get totalTravelTime => 'Tempo total estimado de viagem';

  @override
  String get changeTime => 'Tempo estimado para troca de linha';

  @override
  String get firstTake => 'Primeiro trecho';

  @override
  String get firstDirection => 'Primeira direção';

  @override
  String get firstDeparture => 'Primeira partida';

  @override
  String get firstArrival => 'Primeira chegada';

  @override
  String get firstIntermediateStations => 'Primeiras estações intermediárias';

  @override
  String get secondTake => 'Segundo trecho';

  @override
  String get secondDirection => 'Segunda direção';

  @override
  String get secondDeparture => 'Segunda partida';

  @override
  String get secondArrival => 'Segunda chegada';

  @override
  String get secondIntermediateStations => 'Segundas estações intermediárias';

  @override
  String get thirdTake => 'Terceiro trecho';

  @override
  String get thirdDirection => 'Terceira direção';

  @override
  String get thirdDeparture => 'Terceira partida';

  @override
  String get thirdArrival => 'Terceira chegada';

  @override
  String get thirdIntermediateStations => 'Terceiras estações intermediárias';

  @override
  String get error => 'Erro:';

  @override
  String get mustTypeDestination => 'Digite um destino primeiro.';

  @override
  String get noRoutesFound => 'Nenhuma rota encontrada';

  @override
  String get routeDetails => 'Detalhes da rota';

  @override
  String get departure => 'Partida: ';

  @override
  String get arrival => 'Chegada: ';

  @override
  String get take => 'Pegar: ';

  @override
  String get direction => 'Direção: ';

  @override
  String get intermediateStations => 'Estações intermediárias:';

  @override
  String egp(Object price) {
    return '$price EGP';
  }

  @override
  String travelTime(Object time) {
    return '$time';
  }

  @override
  String get showStations => 'Mostrar estações';

  @override
  String get hideStations => 'Ocultar estações';

  @override
  String get showRoute => 'Mostrar rota';

  @override
  String get metro1 => 'Linha de Metro 1';

  @override
  String get metro2 => 'Linha de Metro 2';

  @override
  String get metro3branch1 => 'Linha de Metro 3 Ramal ROD EL FARAG AXIS';

  @override
  String get metro3branch2 => 'Linha de Metro 3 Ramal CAIRO UNIVERSITY';

  @override
  String distanceToStation(Object distance, Object stationName) {
    return 'A distância até $stationName é $distance metros';
  }

  @override
  String reachedStation(Object stationName) {
    return 'Você chegou a $stationName';
  }

  @override
  String nextStation(Object currentStationName, Object nextStationName) {
    return 'Estação atual $currentStationName, próxima estação $nextStationName';
  }

  @override
  String changeLineAt(Object currentStationName, Object direction, Object lineName, Object nextStationName) {
    return 'Estação atual $currentStationName, próxima $nextStationName, você vai trocar para $lineName direção $direction';
  }

  @override
  String finalStation(Object currentStationName, Object nextStationName) {
    return 'Estação atual $currentStationName, próxima $nextStationName é sua estação de chegada';
  }

  @override
  String get finalStationReached => 'Chegou à estação de destino, viagem concluída';

  @override
  String get exchangeStation => 'Estação de troca';

  @override
  String get intermediateStationsTitle => 'Estações intermediárias';

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
  String get appTitle => 'Guia Metro do Cairo';

  @override
  String get welcomeTitle => 'Planeje sua viagem de metro';

  @override
  String get welcomeSubtitle => 'As melhores rotas, estações mais próximas e informações sobre o metro';

  @override
  String get planYourRoute => 'Planejar rota';

  @override
  String get findNearestStation => 'Encontrar estação por endereço';

  @override
  String get scheduleLabel => 'Horários do metro';

  @override
  String get metroMapLabel => 'Mapa do metro';

  @override
  String get appInfoTitle => 'Sobre o Guia Metro do Cairo';

  @override
  String get appInfoDescription => 'O guia oficial do sistema de metro do Cairo. Rotas, estações, horários e muito mais.';

  @override
  String get close => 'Fechar';

  @override
  String get languageSwitchTitle => 'Mudar idioma';

  @override
  String get routeOptions => 'Opções de rota';

  @override
  String get fastestRoute => 'Rota mais rápida';

  @override
  String get shortestRoute => 'Rota mais curta';

  @override
  String get fewestTransfers => 'Menos trocas';

  @override
  String get estimatedTime => 'Tempo estimado';

  @override
  String get estimatedFare => 'Tarifa estimada';

  @override
  String stationsCount(Object count) {
    return '$count estações';
  }

  @override
  String get minutesAbbr => 'min';

  @override
  String get exitDialogTitle => 'Sair do app?';

  @override
  String get exitDialogSubtitle => 'Tem certeza que quer sair do\nCairo Metro Navigator?';

  @override
  String get exitDialogStay => 'Ficar';

  @override
  String get exitDialogExit => 'Sair';

  @override
  String get egpCurrency => 'EGP';

  @override
  String get departureTime => 'Partida';

  @override
  String get arrivalTime => 'Chegada';

  @override
  String get transferStations => 'Troca em:';

  @override
  String get noInternetTitle => 'Sem conexão com a internet';

  @override
  String get noInternetMessage => 'Algumas funcionalidades podem não estar disponíveis offline';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get offlineMode => 'Modo offline';

  @override
  String lastUpdated(Object date) {
    return 'Última atualização: $date';
  }

  @override
  String get searchHistory => 'Histórico de busca';

  @override
  String get clearHistory => 'Limpar histórico';

  @override
  String get noHistory => 'Sem histórico de busca';

  @override
  String get favorites => 'Favoritos';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String get shareRoute => 'Compartilhar rota';

  @override
  String get amenitiesTitle => 'Serviços da estação';

  @override
  String get accessibility => 'Acessibilidade';

  @override
  String get parking => 'Estacionamento';

  @override
  String get toilets => 'Banheiros';

  @override
  String get atm => 'Caixa eletrônico';

  @override
  String get refresh => 'Atualizar';

  @override
  String get loading => 'Carregando...';

  @override
  String get errorOccurred => 'Ocorreu um erro';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get noResults => 'Nenhum resultado encontrado';

  @override
  String get allLines => 'Todas as linhas';

  @override
  String get line1 => 'Linha 1';

  @override
  String get line2 => 'Linha 2';

  @override
  String get line3 => 'Linha 3';

  @override
  String get line4 => 'Linha 4';

  @override
  String get operatingHours => 'Horário de funcionamento';

  @override
  String get firstTrain => 'Primeiro trem';

  @override
  String get lastTrain => 'Último trem';

  @override
  String get peakHours => 'Horário de pico';

  @override
  String get offPeakHours => 'Fora do horário de pico';

  @override
  String get weekdays => 'Dias úteis';

  @override
  String get weekend => 'Fim de semana';

  @override
  String get holidays => 'Feriados';

  @override
  String get specialSchedule => 'Horário especial';

  @override
  String get alerts => 'Alertas de serviço';

  @override
  String get noAlerts => 'Nenhum alerta atual';

  @override
  String get viewAllStations => 'Ver todas as estações';

  @override
  String get nearbyStations => 'Estações próximas';

  @override
  String distanceAway(Object distance) {
    return '$distance km de distância';
  }

  @override
  String walkingTime(Object minutes) {
    return '$minutes min a pé';
  }

  @override
  String get metroEtiquette => 'Etiqueta no metro';

  @override
  String get safetyTips => 'Dicas de segurança';

  @override
  String get feedback => 'Enviar feedback';

  @override
  String get rateApp => 'Avaliar o app';

  @override
  String get settings => 'Configurações';

  @override
  String get notifications => 'Notificações';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get language => 'Idioma';

  @override
  String get recentTripsLabel => 'Viagens recentes';

  @override
  String get favoritesLabel => 'Favoritos';

  @override
  String get metroLinesTitle => 'Linhas de metro';

  @override
  String get line1Name => 'Linha 1';

  @override
  String get line2Name => 'Linha 2';

  @override
  String get line3Name => 'Linha 3';

  @override
  String get line4Name => 'Linha 4';

  @override
  String get stationsLabel => 'estações';

  @override
  String get comingSoonLabel => 'Em breve';

  @override
  String get viewFullMap => 'Ver mapa completo';

  @override
  String get routeAllStops => 'Todas as paradas';

  @override
  String get nearestStationFound => 'Estação mais próxima encontrada';
  String nextTrainIn(int min) => 'Próx. trem em ~{min} min'.replaceAll('{min}', '$min');
  String get outsideServiceHours => 'Fora do horário de serviço';
  String get saveRouteLabel => 'Salvar rota';
  String get routeSaved => 'Salvo nos favoritos';
  String get routeUnsaved => 'Removido dos favoritos';
  String get nearestStationTitle => 'Sua estação mais próxima';
  String get nearestStationSubtitle => 'Detectada automaticamente por GPS';
  String get nearestStationLocating => 'Procurando a estação mais próxima…';
  String get nearestStationCaption => 'Estação de metrô mais próxima da sua localização';
  String get getDirections => 'Obter rotas';
  String get walkingDirections => 'A pé';
  String get drivingDirections => 'De carro';
  String get currentLocation => 'Minha Localização';
  String get useAsDeparture => 'Definir como partida';

  @override
  String get stationFound => 'Estação encontrada';

  @override
  String get accessibilityLabel => 'Acessibilidade';

  @override
  String get seeAll => 'Ver tudo';

  @override
  String get allMetroLines => 'Todas as linhas de metro';

  @override
  String get aroundStationsTitle => 'Ao redor das estações';

  @override
  String get station => 'Estação';

  @override
  String get seeFacilities => 'Ver serviços';

  @override
  String get subscriptionInfoTitle => 'Assinatura do metro';

  @override
  String get subscriptionInfoSubtitle => 'Tarifas, zonas e onde comprar';

  @override
  String get facilitiesTitle => 'Serviços da estação';

  @override
  String get parkingTitle => 'Estacionamento';

  @override
  String get parkingDescription => 'Disponibilidade de estacionamento';

  @override
  String get toiletsTitle => 'Banheiros';

  @override
  String get toiletsDescription => 'Disponibilidade de banheiros públicos';

  @override
  String get elevatorsTitle => 'Elevadores';

  @override
  String get elevatorsDescription => 'Elevadores de acessibilidade';

  @override
  String get shopsTitle => 'Lojas';

  @override
  String get shopsDescription => 'Lojas de conveniência e quiosques';

  @override
  String get available => 'Disponível';

  @override
  String get notAvailable => 'Indisponível';

  @override
  String get nearbyAttractions => 'Atrações próximas';

  @override
  String get attraction1 => 'Museu Egípcio';

  @override
  String get attraction2 => 'Khan El Khalili';

  @override
  String get attraction3 => 'Praça Tahrir';

  @override
  String get attractionDescription => 'Um dos pontos turísticos mais famosos do Cairo, facilmente acessível desta estação';

  @override
  String get minutes => 'minutos';

  @override
  String get walkingDistance => 'Distância a pé';

  @override
  String get accessibilityInfoTitle => 'Recursos de acessibilidade';

  @override
  String get wheelchairTitle => 'Acesso para cadeirantes';

  @override
  String get wheelchairDescription => 'Todas as estações têm rampas de acesso para cadeiras de rodas';

  @override
  String get hearingImpairmentTitle => 'Deficiência auditiva';

  @override
  String get hearingImpairmentDescription => 'Indicadores visuais disponíveis para deficientes auditivos';

  @override
  String get subscriptionTypes => 'Tipos de assinatura';

  @override
  String get dailyPass => 'Passe diário';

  @override
  String get dailyPassDescription => 'Viagens ilimitadas por um dia em todas as linhas';

  @override
  String get weeklyPass => 'Passe semanal';

  @override
  String get weeklyPassDescription => 'Viagens ilimitadas por 7 dias em todas as linhas';

  @override
  String get monthlyPass => 'Passe mensal';

  @override
  String get monthlyPassDescription => 'Viagens ilimitadas por 30 dias em todas as linhas';

  @override
  String get purchaseNow => 'Comprar agora';

  @override
  String get zonesTitle => 'Zonas tarifárias';

  @override
  String get zonesDescription => 'O metro do Cairo é dividido em zonas tarifárias. O preço depende de quantas zonas você percorre.';

  @override
  String get whereToBuyTitle => 'Onde comprar';

  @override
  String get metroStations => 'Estações de metro';

  @override
  String get metroStationsDescription => 'Disponível nas bilheterias de todas as estações';

  @override
  String get authorizedVendors => 'Vendedores autorizados';

  @override
  String get authorizedVendorsDescription => 'Quiosques e lojas selecionados perto das estações';

  @override
  String get touristGuideTitle => 'Guia turístico';

  @override
  String get popularDestinations => 'Destinos populares';

  @override
  String get pyramidsTitle => 'As Pirâmides';

  @override
  String get pyramidsDescription => 'A última maravilha do mundo antigo';

  @override
  String get egyptianMuseumTitle => 'Museu Egípcio';

  @override
  String get egyptianMuseumDescription => 'Possui a maior coleção mundial de antiguidades faraônicas';

  @override
  String get khanElKhaliliTitle => 'Khan El Khalili';

  @override
  String get khanElKhaliliDescription => 'Mercado histórico que remonta a 1382';

  @override
  String get essentialPhrases => 'Frases essenciais em árabe';

  @override
  String get phrase1 => 'Quanto custa o bilhete?';

  @override
  String get phrase1Translation => 'بكام التذكرة؟ (Bikam el-tazkara?)';

  @override
  String get phrase2 => 'Onde fica a estação de metro?';

  @override
  String get phrase2Translation => 'فين محطة المترو؟ (Fein maḥaṭṭat el-metro?)';

  @override
  String get phrase3 => 'Isto vai para...?';

  @override
  String get phrase3Translation => 'هل هذا يذهب إلى...؟ (Hal haza yathhab ila...?)';

  @override
  String get tipsTitle => 'Dicas de viagem';

  @override
  String get peakHoursTitle => 'Horário de pico';

  @override
  String get peakHoursDescription => 'Evite das 7-9h e 15-18h para trens menos lotados';

  @override
  String get safetyTitle => 'Segurança';

  @override
  String get safetyDescription => 'Guarde seus objetos de valor e fique atento ao ambiente';

  @override
  String get ticketsTitle => 'Bilhetes';

  @override
  String get ticketsDescription => 'Sempre guarde o bilhete até sair da estação';

  @override
  String get lengthLabel => 'Comprimento';

  @override
  String get viewDetails => 'Ver detalhes';

  @override
  String get whereToBuyDescription => 'Compre bilhetes, recarregue seu cartão ou assine cartões sazonais';

  @override
  String get ticketsBullet1 => 'Disponíveis em todas as bilheterias';

  @override
  String get ticketsBullet2 => 'Bilhetes públicos em máquinas (de Haroun a Adly Mansour)';

  @override
  String get ticketsBullet3 => 'Tipos: público, idosos, necessidades especiais';

  @override
  String get walletCardTitle => 'Cartão wallet';

  @override
  String get walletBullet1 => 'Disponível em bilheterias e máquinas (de Haroun a Adly Mansour)';

  @override
  String get walletBullet2 => 'Custo do cartão: 80 LE (recarga mínima de 40 LE na primeira compra)';

  @override
  String get walletBullet3 => 'Faixa de recarga: 20 a 400 LE';

  @override
  String get walletBullet4 => 'Reutilizável e transferível';

  @override
  String get walletBullet5 => 'Economiza tempo em relação a bilhetes avulsos';

  @override
  String get seasonalCardTitle => 'Cartão sazonal';

  @override
  String get seasonalBullet1 => 'Para: público geral, estudantes, idosos (60+), necessidades especiais';

  @override
  String get requirementsTitle => 'Requisitos:';

  @override
  String get seasonalBullet2 => 'Visite os escritórios de assinatura em Attaba, Abbasia, Heliopolis ou Adly Mansour';

  @override
  String get seasonalBullet3 => 'Forneça 2 fotografias (formato 4x6)';

  @override
  String get additionalRequirementsTitle => 'Requisitos adicionais:';

  @override
  String get studentReq => 'Estudantes: formulário com carimbo da escola + documento/certidão + recibo';

  @override
  String get elderlyReq => 'Idosos: documento válido comprovando idade';

  @override
  String get specialNeedsReq => 'Necessidades especiais: documento governativo comprovando o status';

  @override
  String get learnMore => 'Saiba mais';

  @override
  String get stationDetailsTitle => 'Detalhes da estação';

  @override
  String get stationMapTitle => 'Mapa da estação';

  @override
  String get allOperationalLabel => 'Todas as linhas operacionais';

  @override
  String get statusLiveLabel => 'Ao vivo';

  @override
  String get homepageSubtitle => 'Seu guia inteligente para metro e LRT';

  @override
  String get greetingMorning => 'Bom dia';

  @override
  String get greetingAfternoon => 'Boa tarde';

  @override
  String get greetingEvening => 'Boa noite';

  @override
  String get greetingNight => 'Boa madrugada';

  @override
  String get planYourRouteSubtitle => 'Encontre a rota mais rápida entre estações';

  @override
  String get recentSearchesLabel => 'Buscas recentes';

  @override
  String get googleMapsLinkDetected => 'Link do Google Maps detectado';

  @override
  String get pickFromMapLabel => 'Escolher no mapa';

  @override
  String get quickActionsTitle => 'Ações rápidas';

  @override
  String get tapToLocateLabel => 'Toque para encontrar a estação mais próxima';

  @override
  String get touristHighlightsLabel => 'Destaques turísticos';

  @override
  String get viewPlansLabel => 'Ver planos de assinatura';

  @override
  String get lrtLineName => 'Linha LRT';

  @override
  String get exploreAreaTitle => 'Explorar a área';

  @override
  String get exploreAreaSubtitle => 'Descubra lugares próximos às estações de metro';

  @override
  String get tapToExploreLabel => 'Toque na estação para explorar';

  @override
  String get promoMonthlyTitle => 'Mensal';

  @override
  String get promoMonthlySubtitle => 'Viagens ilimitadas por 30 dias';

  @override
  String get promoMonthlyTag => 'Melhor valor';

  @override
  String get promoStudentTitle => 'Estudante';

  @override
  String get promoStudentSubtitle => '50% de desconto para estudantes';

  @override
  String get promoStudentTag => 'Estudante';

  @override
  String get promoFamilyTitle => 'Família';

  @override
  String get promoFamilySubtitle => 'Viaje junto, economize mais';

  @override
  String get promoFamilyTag => 'Família';

  @override
  String get buyNowLabel => 'Comprar';

  @override
  String get locateMeLabel => 'Localizando';

  @override
  String get locationServicesDisabled => 'Serviços de localização desativados. Ative nas configurações.';

  @override
  String get locationPermissionDenied => 'Permissão de localização negada. Permita nas configurações do app.';

  @override
  String get locationError => 'Não foi possível obter sua localização. Tente novamente.';

  @override
  String get leaveNowLabel => 'Sair agora';

  @override
  String get cairoMetroNetworkLabel => 'Rede de Metro do Cairo';

  @override
  String get resetViewLabel => 'Redefinir visualização';

  @override
  String get mapViewSchematic => 'Esquemático';

  @override
  String get mapViewGeographic => 'Mapa';

  @override
  String get mapLegendLabel => 'Legenda do mapa';

  @override
  String get searchStationsHint => 'Buscar estações...';

  @override
  String get noStationsFound => 'Nenhuma estação encontrada';

  @override
  String get line1FullName => 'Linha 1 — Helwan / New El-Marg';

  @override
  String get line2FullName => 'Linha 2 — Shubra El-Kheima / El-Mounib';

  @override
  String get line3FullName => 'Linha 3 — Adly Mansour / Kit Kat';

  @override
  String get line4FullName => 'Linha 4';

  @override
  String get monorailEastName => 'Monotrilho Leste';

  @override
  String get monorailWestName => 'Monotrilho Oeste';

  @override
  String get allLinesStationsLabel => 'estações';

  @override
  String get underConstructionLabel => 'Em construção';

  @override
  String get plannedLabel => 'Planejado';

  @override
  String get transferLabel => 'Troca';

  @override
  String get statusMaintenanceLabel => 'Manutenção';

  @override
  String get statusDisruptionLabel => 'Interrupção';

  @override
  String get crowdCalmLabel => 'Calmo';

  @override
  String get crowdModerateLabel => 'Moderado';

  @override
  String get crowdBusyLabel => 'Lotado';

  @override
  String get locationDialogNoThanks => 'Não, obrigado';

  @override
  String get locationDialogTurnOn => 'Ativar';

  @override
  String get locationDialogOpenSettings => 'Abrir configurações';

  @override
  String get touristGuidePlacesCount => 'lugares para explorar';

  @override
  String get touristGuideDisclaimer => 'Horários, distâncias e detalhes são aproximados e podem variar. Por favor, verifique oficialmente antes de visitar.';

  @override
  String get touristGuideSearchHint => 'Pesquisar lugares ou estações...';

  @override
  String get touristGuideCategoryAll => 'Tudo';

  @override
  String get touristGuideNoPlaces => 'Nenhum lugar encontrado';

  @override
  String get touristGuideNoPlacesSub => 'Tente uma pesquisa ou categoria diferente';

  @override
  String get photographyTitle => 'Fotografia';

  @override
  String get photographyDescription => 'A fotografia não é permitida dentro das estações de metrô. Algumas atrações podem cobrar uma taxa de câmera.';

  @override
  String get bestTimeTitle => 'Melhor época para visitar';

  @override
  String get bestTimeDescription => 'De outubro a abril oferece o melhor clima. Visite locais ao ar livre de manhã cedo ou no final da tarde.';

  @override
  String get phrase4 => 'Obrigado';

  @override
  String get phrase4Translation => 'شكراً (Shukran)';

  @override
  String get phrase5 => 'Quanto?';

  @override
  String get phrase5Translation => 'بكام؟ (Bikam?)';

  @override
  String get phrase6 => 'Onde fica...?';

  @override
  String get phrase6Translation => 'فين...؟ (Fein...?)';

  @override
  String get phrase7 => 'Quero ir para...';

  @override
  String get phrase7Translation => 'أنا عايز أروح... (Ana aayez aroh...)';

  @override
  String get phrase8 => 'É longe?';

  @override
  String get phrase8Translation => 'هو بعيد؟ (Howwa baeed?)';

  @override
  String get planRoute => 'Planejar rota';

  @override
  String get lineLabel => 'Linha';

  @override
  String get categoryHistorical => 'Histórico';

  @override
  String get categoryMuseum => 'Museus';

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
  String get categoryHiddenGem => 'Joias escondidas';

  @override
  String get facilityCommercial => 'Comercial';

  @override
  String get facilityCultural => 'Cultural';

  @override
  String get facilityEducational => 'Educacional';

  @override
  String get facilityLandmarks => 'Pontos turísticos';

  @override
  String get facilityMedical => 'Médico';

  @override
  String get facilityPublicInstitutions => 'Instituições públicas';

  @override
  String get facilityPublicSpaces => 'Espaços públicos';

  @override
  String get facilityReligious => 'Religioso';

  @override
  String get facilityServices => 'Serviços';

  @override
  String get facilitySportFacilities => 'Instalações esportivas';

  @override
  String get facilityStreets => 'Ruas';

  @override
  String get facilitySearchHint => 'Pesquisar lugares...';

  @override
  String get facilityNoData => 'Nenhum dado de instalações disponível para esta estação ainda';

  @override
  String get facilityDataSoon => 'Os dados serão adicionados em breve';

  @override
  String get facilityClearFilter => 'Limpar filtro';

  @override
  String get facilityPlacesCount => 'lugares';

  @override
  String get facilityZoomHint => 'Beliscar e arrastar para ampliar';

  @override
  String get facilityCategoriesLabel => 'categorias';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortStops => 'Paradas';

  @override
  String get sortTime => 'Tempo';

  @override
  String get sortFare => 'Tarifa';

  @override
  String get sortLines => 'Linhas';

  @override
  String get bestRoute => 'Melhor';

  @override
  String get accessibleRoute => 'Rota Acessível';

  @override
  String get routeTypeFastest => 'Mais Rápida';

  @override
  String get routeTypeAccessible => 'Acessível';

  @override
  String get routeTypeFewestTransfers => 'Menos Transferências';

  @override
  String get routeTypeAlternative => 'Rota Alternativa';

  @override
  String get hideStops => 'Ocultar paradas';

  @override
  String get showLabel => 'Mostrar';

  @override
  String get stopsWord => 'paradas';

  @override
  String get minuteShort => 'min';

  @override
  String get detectingLocation => 'Detectando sua localização...';

  @override
  String get tapToExplore => 'Toque para explorar';

  @override
  String get couldNotOpenMaps => 'Não foi possível abrir o Google Maps';

  @override
  String get couldNotGetLocation => 'Não foi possível obter sua localização. Verifique a permissão de localização.';

  @override
  String get googleMapsLabel => 'Google Maps';

  @override
  String get couldNotFindNearestStation => 'Não foi possível encontrar a estação mais próxima';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String transferAtStation(Object station) {
    return 'Transferência em $station';
  }

  @override String get onboardingSkip => 'Pular';
  @override String get onboardingNext => 'Próximo';
  @override String get onboardingGetStarted => 'Começar';
  @override String get onboardingTitle1 => 'Planeje sua rota';
  @override String get onboardingSubtitle1 => 'Escolha estação de partida e chegada — encontramos o caminho mais rápido com conexões, tempo e tarifa em segundos.';
  @override String get onboardingTitle2 => 'Conheça as linhas';
  @override String get onboardingSubtitle2 => '3 linhas coloridas cobrem todo o Cairo. Ícones circulares indicam estações de conexão.';
  @override String get onboardingTitle3 => 'Tudo em um lugar';
  @override String get onboardingSubtitle3 => 'Encontre a estação mais próxima, explore o mapa ao vivo e descubra lugares perto de cada parada.';
  @override String get onboardingLanguagePrompt => 'Escolher idioma';
  @override String get onboardingReplay => 'Repetir tour';
  @override String get onboardingLine1 => 'Linha 1 · Helwan → New El-Marg';
  @override String get onboardingLine2 => 'Linha 2 · El-Mounib → Shubra';
  @override String get onboardingLine3 => 'Linha 3 · Adly Mansour → ramais';
  @override String get onboardingTransfer => 'Estação de conexão';

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

  @override String get searchingOnline => 'Pesquisando online…';
  @override String get didYouMean => 'Você quis dizer?';
  @override String get tapForTransferDetails => 'Toque para detalhes da transferência';
}