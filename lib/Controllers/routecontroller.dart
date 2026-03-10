import 'package:flutter/cupertino.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/Constants/metro_stations.dart';

String departureStation = "";
String arrivalStation = "";
int sortValue = 0;

List<String> metroLine1Stations = [];
List<String> metroLine2Stations = [];
List<String> metroLine3Branch1Stations = [];
List<String> metroLine3Branch2Stations = [];
List<String> lrtMainStations = [];
List<String> lrtNacBranchStations = [];
List<String> lrt10thBranchStations = [];

Map<List<int>, List<String>> commonStationsMap = {};
Map<String, List<String>> commonStationsStringMap = {};

late final convertedMap;
Future<Map<String, dynamic>> getRoutes(BuildContext context,
    String departureStation_, String arrivalStation_, int sortValue_) async {
  List<List<List<String>>> possibleRouteData = [];
  List<List<List<List<int>>>> routesCoordinates = [];

  List<int> departureStationLine = [];
  List<int> arrivalStationLine = [];
  List<int> departureStationIndexList = [];
  List<int> arrivalStationIndexList = [];

  departureStation = departureStation_;
  arrivalStation = arrivalStation_;
  sortValue = sortValue_;

  // Adding station info for departure and arrival stations
  metroLine1Stations = getMetroLine1Stations(context);
  metroLine2Stations = getMetroLine2Stations(
      context); // Assuming you have a similar function for Line 2
  metroLine3Branch1Stations =
      getMetroLine3Branch1Stations(context); // And for Branch 1
  metroLine3Branch2Stations =
      getMetroLine3Branch2Stations(context); // And for Branch 2
  lrtMainStations = getLrtMainStations(context);
  lrtNacBranchStations = getLrtNacBranchStations(context);
  lrt10thBranchStations = getLrt10thBranchStations(context);
  commonStationsMap = getCommonStationsMap(context);
  commonStationsStringMap = getCommonStationsStringMap(context);

  // Adding station info for departure and arrival stations
  addStationInfo(departureStation, metroLine1Stations, departureStationLine,
      departureStationIndexList, 1);
  addStationInfo(departureStation, metroLine2Stations, departureStationLine,
      departureStationIndexList, 2);
  addStationInfo(departureStation, metroLine3Branch1Stations,
      departureStationLine, departureStationIndexList, 3);
  addStationInfo(departureStation, metroLine3Branch2Stations,
      departureStationLine, departureStationIndexList, 4);
  addStationInfo(departureStation, lrtMainStations, departureStationLine,
      departureStationIndexList, 5);
  addStationInfo(departureStation, lrtNacBranchStations, departureStationLine,
      departureStationIndexList, 6);
  addStationInfo(departureStation, lrt10thBranchStations, departureStationLine,
      departureStationIndexList, 7);

  addStationInfo(arrivalStation, metroLine1Stations, arrivalStationLine,
      arrivalStationIndexList, 1);
  addStationInfo(arrivalStation, metroLine2Stations, arrivalStationLine,
      arrivalStationIndexList, 2);
  addStationInfo(arrivalStation, metroLine3Branch1Stations, arrivalStationLine,
      arrivalStationIndexList, 3);
  addStationInfo(arrivalStation, metroLine3Branch2Stations, arrivalStationLine,
      arrivalStationIndexList, 4);
  addStationInfo(arrivalStation, lrtMainStations, arrivalStationLine,
      arrivalStationIndexList, 5);
  addStationInfo(arrivalStation, lrtNacBranchStations, arrivalStationLine,
      arrivalStationIndexList, 6);
  addStationInfo(arrivalStation, lrt10thBranchStations, arrivalStationLine,
      arrivalStationIndexList, 7);

  // Check if both lists have common stations and update them
  updateCommonStations(
      departureStationLine,
      arrivalStationLine,
      departureStationIndexList,
      arrivalStationIndexList,
      departureStation,
      arrivalStation);

  // Handle cases where no valid station was found
  if (departureStationLine.isEmpty) {
    print("You entered a wrong departure station");
    return {
      'allRoutesDetails': [{}],
      // 'serializedData': [],
    };
  }
  if (arrivalStationLine.isEmpty) {
    print("You entered a wrong arrival station");
    return {
      'allRoutesDetails': [{}],
      // 'serializedData': [],
    };
  }

  for (int i = 0; i < departureStationLine.length; i++) {
    for (int j = 0; j < arrivalStationLine.length; j++) {
      possibleRoutes(
        context,
        possibleRouteData,
        metroLine1Stations,
        metroLine2Stations,
        metroLine3Branch1Stations,
        metroLine3Branch2Stations,
        departureStationLine[i],
        arrivalStationLine[j],
        departureStationIndexList[i],
        arrivalStationIndexList[j],
      );
    }
  }

  // Sort the routes based on sortValue
  if (sortValue_ == 0) {
    possibleRouteData.sort((a, b) =>
        extractNumberOfStations(a).compareTo(extractNumberOfStations(b)));
  } else if (sortValue_ == 1) {
    possibleRouteData.sort((a, b) {
      final stationComparison =
          extractNumberOfStations(a).compareTo(extractNumberOfStations(b));
      if (stationComparison != 0) return stationComparison;
      return extractNumberOfExchanges(a).compareTo(extractNumberOfExchanges(b));
    });
  }

  // Prepare route details for display
  final List<String> allRoutesDetails = [];
  int routeNo = 1;
  String ticketPrice = '';
  bool ticketPriceFound = false;
  String lineName = '';

  for (var route in possibleRouteData) {
    final routeDetails = StringBuffer("Route ($routeNo)\n");
    for (var segment in route) {
      for (var detail in segment) {
        if (detail.contains('take') || detail.contains('Take')) {
          lineName = detail.split(': ')[1];
        }
        if (detail.contains('→')) {
          extractStationsPixels(
              context, routesCoordinates, detail, lineName, routeNo);
        }
        if (!ticketPriceFound && detail.startsWith('Ticket')) {
          routeDetails.writeln(detail);
          ticketPrice = detail;
          ticketPriceFound = true;
        } else if (detail.startsWith('Ticket')) {
          routeDetails.writeln(ticketPrice);
        } else {
          routeDetails.writeln(detail);
        }
      }
    }
    routeNo++;
    routeDetails.writeln();
    allRoutesDetails.add(routeDetails.toString());
  }

  // Convert routesCoordinates to List<List<List<List<int>>>>
  final serializedData = routesCoordinates.map((route) {
    return route.map((segment) {
      return segment
          .map((coordinate) => List<int>.from(coordinate as Iterable))
          .toList();
    }).toList();
  }).toList();

  final convertedMap = convertRoutesToMap(possibleRouteData);

  return {
    'allRoutesDetails': convertedMap,
    'serializedData': serializedData,
  };
}

List<Map<String, dynamic>> convertRoutesToMap(List<List<List<String>>> routes) {
  List<Map<String, dynamic>> convertedRoutes = [];

  for (var route in routes) {
    Map<String, dynamic> routeMap = {}; // Create a new map for each route

    for (var detail in route) {
      // Extract the key-value pair
      var detailKey = detail[0].split(': ')[0];
      var detailValue = detail[0].split(': ')[1];

      // Special handling for intermediate stations, changing lines, and times
      if (detailKey.contains('Intermediate Stations')) {
        // Split stations by the arrow and trim any whitespace
        routeMap[detailKey] =
            detailValue.split('→').map((station) => station.trim()).toList();
      } else {
        // Default case, leave the value as a string
        routeMap[detailKey] = detailValue;
      }
    }

    // Add the completed map for this route to the list
    convertedRoutes
        .add(Map<String, dynamic>.from(routeMap)); // Make a copy of the map
  }

  return convertedRoutes;
}

void addStationInfo(String station, List<String> metroLineStations,
    List<int> stationLine, List<int> stationIndexList, int lineNum) {
  int stationIndex = metroLineStations.indexOf(station);
  if (stationIndex != -1) {
    stationLine.add(lineNum);
    stationIndexList.add(stationIndex);
  }
}

void updateCommonStations(
  List<int> departureStationLine,
  List<int> arrivalStationLine,
  List<int> departureStationIndexList,
  List<int> arrivalStationIndexList,
  String departureStation,
  String arrivalStation,
) {
  bool departureStationFound = false;
  bool arrivalStationFound = false;
  List<String>? stations;

  // First loop to check if both departure and arrival stations are in any of the common stations
  for (var entry in commonStationsMap.entries) {
    stations = entry.value;
    if (stations.contains(departureStation)) departureStationFound = true;
    if (stations.contains(arrivalStation)) arrivalStationFound = true;
    if (departureStationFound && arrivalStationFound) return;
  }

  // Second loop to find and update common lines and stations
  for (var entry in commonStationsMap.entries) {
    stations = entry.value;

    // If departure station is in the common stations
    if (stations.contains(departureStation)) {
      for (var line in arrivalStationLine) {
        if (departureStationLine.contains(line)) {
          int depLineIndex = departureStationLine.indexOf(line);
          int arrLineIndex = arrivalStationLine.indexOf(line);
          int depStationIndex = departureStationIndexList[depLineIndex];
          int arrStationIndex = arrivalStationIndexList[arrLineIndex];

          departureStationIndexList.clear();
          arrivalStationIndexList.clear();
          departureStationIndexList.add(depStationIndex);
          arrivalStationIndexList.add(arrStationIndex);
          departureStationLine.clear();
          arrivalStationLine.clear();
          departureStationLine.add(line);
          arrivalStationLine.add(line);
          break;
        }
      }
    }

    // If arrival station is in the common stations
    if (stations.contains(arrivalStation)) {
      for (var line in departureStationLine) {
        if (arrivalStationLine.contains(line)) {
          int depLineIndex = departureStationLine.indexOf(line);
          int arrLineIndex = arrivalStationLine.indexOf(line);
          int depStationIndex = departureStationIndexList[depLineIndex];
          int arrStationIndex = arrivalStationIndexList[arrLineIndex];

          departureStationIndexList.clear();
          arrivalStationIndexList.clear();
          departureStationIndexList.add(depStationIndex);
          arrivalStationIndexList.add(arrStationIndex);
          departureStationLine.clear();
          arrivalStationLine.clear();
          departureStationLine.add(line);
          arrivalStationLine.add(line);
          break;
        }
      }
    }
  }
}

void possibleRoutes(
    BuildContext context,
    List<List<List<String>>> routeData,
    List<String> metroLine1Stations,
    List<String> metroLine2Stations,
    List<String> metroLine3Branch1Stations,
    List<String> metroLine3Branch2Stations,
    int departureStationLine,
    int arrivalStationLine,
    int departureStationIndex,
    int arrivalStationIndex) {
  if (departureStationLine == arrivalStationLine) {
    List<String> lineStations = getLineStations(departureStationLine);
    String lineStartDirection =
        getLineStartDirection(context, departureStationLine);
    String lineEndDirection =
        getLineEndDirection(context, departureStationLine);
    String lineName = getLineName(context, departureStationLine);

    routeData.add(findRoute1(
        lineStations,
        departureStationIndex,
        arrivalStationIndex,
        lineStartDirection,
        lineEndDirection,
        lineName,
        true));
  } else {
    List<String> commonStations =
        findCommonStation(departureStationLine, arrivalStationLine);

    if (commonStations.isNotEmpty) {
      for (String commonStation in commonStations) {
        routeData.add(findRoute2(
            context,
            departureStationLine,
            arrivalStationLine,
            departureStationIndex,
            arrivalStationIndex,
            metroLine1Stations,
            metroLine2Stations,
            metroLine3Branch1Stations,
            metroLine3Branch2Stations,
            commonStation));
      }
    }

    List<List<List<String>>> route3 = findRoute3(
        context,
        departureStationLine,
        arrivalStationLine,
        departureStationIndex,
        arrivalStationIndex,
        metroLine1Stations,
        metroLine2Stations,
        metroLine3Branch1Stations,
        metroLine3Branch2Stations,
        arrivalStation);
    for (List<List<String>> route in route3) {
      if (route != null) {
        routeData.add(route);
      }
    }
  }
}

List<String> findCommonStation(
    int departureStationLine, int arrivalStationLine) {
  // Convert the two station line numbers into a sorted list of strings
  List<String> key = [
    departureStationLine.toString(),
    arrivalStationLine.toString()
  ]..sort();
  String stringKey = key.join(',');

  // Check if the key exists in the map
  if (commonStationsStringMap.containsKey(stringKey)) {
    return commonStationsStringMap[stringKey] ?? [];
  }

  return [];
}

List<String> getLineStations(int line) {
  switch (line) {
    case 1:
      return metroLine1Stations;
    case 2:
      return metroLine2Stations;
    case 3:
      return metroLine3Branch1Stations;
    case 4:
      return metroLine3Branch2Stations;
    case 5:
      return lrtMainStations;
    case 6:
      return lrtNacBranchStations;
    case 7:
      return lrt10thBranchStations;
    default:
      return [];
  }
}

List<List<int>> getLineCoordinates(int line) {
  switch (line) {
    case 1:
      return metroLine1Coordinates;
    case 2:
      return metroLine2Coordinates;
    case 3:
      return metroLine3Branch1Coordinates;
    case 4:
      return metroLine3Branch2Coordinates;
    case 5:
      return lrtMainCoordinates;
    case 6:
      return lrtNacBranchCoordinates;
    case 7:
      return lrt10thBranchCoordinates;
    default:
      return [];
  }
}

String getLineStartDirection(BuildContext context, int line) {
  switch (line) {
    case 1:
      return AppLocalizations.of(context)!.metroStationHELWAN;
    case 2:
      return AppLocalizations.of(context)!.metroStationEL_MOUNIB;
    case 3:
    case 4:
      return AppLocalizations.of(context)!.metroStationADLY_MANSOUR;
    case 5:
      return AppLocalizations.of(context)!.metroStationADLY_MANSOUR;
    case 6:
    case 7:
      return AppLocalizations.of(context)!.locale == 'ar' ? 'بدر' : 'Badr';
    default:
      return "";
  }
}

String getLineEndDirection(BuildContext context, int line) {
  switch (line) {
    case 1:
      return AppLocalizations.of(context)!.metroStationEL_MARG;
    case 2:
      return AppLocalizations.of(context)!.metroStationSHOUBRA_EL_KHEIMA;
    case 3:
      return AppLocalizations.of(context)!.metroStationROD_EL_FARAG_AXIS;
    case 4:
      return AppLocalizations.of(context)!.metroStationCAIRO_UNIVERSITY;
    case 5:
      return AppLocalizations.of(context)!.locale == 'ar' ? 'بدر' : 'Badr';
    case 6:
      return AppLocalizations.of(context)!.locale == 'ar'
          ? 'العاصمة المركزية'
          : 'Central Capital (NAC)';
    case 7:
      return AppLocalizations.of(context)!.locale == 'ar'
          ? 'مدينة المعرفة'
          : 'Knowledge City';
    default:
      return "";
  }
}

List<List<String>> findRoute1(
    List<String> stations,
    int departureStationIndex,
    int arrivalStationIndex,
    String lineStartDirection,
    String lineEndDirection,
    String metroName,
    bool onlyOneline) {
  List<List<String>> route = [];
  List<String> segment = [];

  int numStations = (arrivalStationIndex - departureStationIndex).abs();
  String direction = arrivalStationIndex > departureStationIndex
      ? lineEndDirection
      : lineStartDirection;

  for (int i = departureStationIndex < arrivalStationIndex
          ? departureStationIndex
          : arrivalStationIndex;
      i <=
          (departureStationIndex > arrivalStationIndex
              ? departureStationIndex
              : arrivalStationIndex);
      i++) {
    segment.add(stations[i]);
  }

  if (departureStationIndex > arrivalStationIndex) {
    segment = segment.reversed.toList();
  }

  if (onlyOneline) {
    route.add(['Route type: 1']);
    route.add(['No. of stations: $numStations']);
    int estimatedMinutes = numStations * 3;
    route.add([
      'Estimated travel time: ${convertMinutesToHoursAndMinutes(estimatedMinutes)}'
    ]);
    route.add(['Ticket Price: ${ticketPrice(numStations)}']);
    route.add(['Take: $metroName']);
    route.add(['Direction: $direction']);
    route.add(['Departure: ${stations[departureStationIndex]}']);
    route.add(['Arrival: ${stations[arrivalStationIndex]}']);
    route.add(['Intermediate Stations: ${segment.join(' → ')}']);
  } else {
    route.add([numStations.toString()]);
    route.add([metroName]);
    route.add([direction]);
    route.add([stations[departureStationIndex]]);
    route.add([stations[arrivalStationIndex]]);
    route.add([segment.join(' → ')]);
  }

  return route;
}

List<List<String>> findRoute2(
    BuildContext context,
    int departureStationLine,
    int arrivalStationLine,
    int departureStationIndex,
    int arrivalStationIndex,
    List<String> metroLine1Stations,
    List<String> metroLine2Stations,
    List<String> metroLine3Branch1Stations,
    List<String> metroLine3Branch2Stations,
    String commonStation) {
  List<List<String>> route = [];
  List<String> segment1 = [];
  List<String> segment2 = [];

  List<String> departureLineStations = getLineStations(departureStationLine);
  List<String> arrivalLineStations = getLineStations(arrivalStationLine);

  int departureToCommonIndex = departureLineStations.indexOf(commonStation);
  int arrivalFromCommonIndex = arrivalLineStations.indexOf(commonStation);

  int numStations1 = (departureStationIndex - departureToCommonIndex).abs();
  int numStations2 = (arrivalStationIndex - arrivalFromCommonIndex).abs();

  for (int i = departureStationIndex < departureToCommonIndex
          ? departureStationIndex
          : departureToCommonIndex;
      i <=
          (departureStationIndex > departureToCommonIndex
              ? departureStationIndex
              : departureToCommonIndex);
      i++) {
    segment1.add(departureLineStations[i]);
  }

  for (int i = arrivalStationIndex < arrivalFromCommonIndex
          ? arrivalStationIndex
          : arrivalFromCommonIndex;
      i <=
          (arrivalStationIndex > arrivalFromCommonIndex
              ? arrivalStationIndex
              : arrivalFromCommonIndex);
      i++) {
    segment2.add(arrivalLineStations[i]);
  }

  if (departureStationIndex > departureToCommonIndex) {
    segment1 = segment1.reversed.toList();
  }
  if (arrivalStationIndex < arrivalFromCommonIndex) {
    segment2 = segment2.reversed.toList();
  }
  if ((departureStationLine == 3 &&
          arrivalStationLine == 4 &&
          arrivalStationIndex < arrivalFromCommonIndex) ||
      (departureStationLine == 4 &&
          arrivalStationLine == 3 &&
          departureStationIndex < departureToCommonIndex) ||
      numStations1 < 1 ||
      numStations2 < 1) {
    return [];
  }

  route.add(['Route type: 2']);
  route.add(['No. of stations: ${numStations1 + numStations2}']);
  int estimatedMinutes = (numStations1 + numStations2) * 3;
  route.add([
    'Estimated travel time: ${convertMinutesToHoursAndMinutes(estimatedMinutes)}'
  ]);
  route.add(['Estimated travel time for changing lines: 5 minutes']);
  route.add([
    'Estimated total travel time: ${convertMinutesToHoursAndMinutes(estimatedMinutes + 5)}'
  ]);
  route.add(['Ticket Price: ${ticketPrice(numStations1 + numStations2)}']);
  route.add(['You will change at: $commonStation']);
  route.add(['First take: ${getLineName(context, departureStationLine)}']);
  route.add([
    'First Direction: ${departureStationIndex > departureToCommonIndex ? getLineStartDirection(context, departureStationLine) : getLineEndDirection(context, departureStationLine)}'
  ]);
  route.add(
      ['First Departure: ${departureLineStations[departureStationIndex]}']);
  route.add(['First Arrival: $commonStation']);
  route.add(['First Intermediate Stations: ${segment1.join(' → ')}']);

  route.add(['Second take: ${getLineName(context, arrivalStationLine)}']);
  route.add([
    'Second Direction: ${arrivalStationIndex < arrivalFromCommonIndex ? getLineStartDirection(context, arrivalStationLine) : getLineEndDirection(context, arrivalStationLine)}'
  ]);
  route.add(['Second Departure: $commonStation']);
  route.add(['Second Arrival: ${arrivalLineStations[arrivalStationIndex]}']);
  route.add(['Second Intermediate Stations: ${segment2.join(' → ')}']);

  return route;
}

List<List<List<String>>> findRoute3(
    BuildContext context,
    int departureStationLine,
    int arrivalStationLine,
    int departureStationIndex,
    int arrivalStationIndex,
    List<String> metroLine1Stations,
    List<String> metroLine2Stations,
    List<String> metroLine3Branch1Stations,
    List<String> metroLine3Branch2Stations,
    String arrivalStation) {
  List<List<List<String>>> allRoutes = [];

  List<String> departureLineStations = getLineStations(departureStationLine);
  List<String> arrivalLineStations = getLineStations(arrivalStationLine);

  for (int i = 0; i < 7; i++) {
    List<String> midLine = getLineStations((i + 1));
    int midLineIndex = (i + 1);
    if (!(departureLineStations == midLine || arrivalLineStations == midLine)) {
      List<String> commonStationsDepMed =
          findCommonStation(departureStationLine, midLineIndex);
      List<String> commonStationsMedArr =
          findCommonStation(midLineIndex, arrivalStationLine);
      if (commonStationsDepMed.isNotEmpty) {
        for (String commonStation1 in commonStationsDepMed) {
          for (String commonStation2 in commonStationsMedArr) {
            List<List<String>> route1;
            List<List<String>> route2;
            List<List<String>> route3;
            List<List<String>> tempRoute = [];

            if ((departureStationLine == arrivalStationLine &&
                    (departureLineStations.indexOf(commonStation1) >=
                            arrivalStationIndex ||
                        departureLineStations.indexOf(commonStation1) <=
                            departureStationIndex)) ||
                ((arrivalStationLine == 3 || arrivalStationLine == 4) &&
                    arrivalLineStations.indexOf(commonStation2) >
                        arrivalStationIndex &&
                    commonStation2.toLowerCase() == "kit kat")) {
              continue;
            }

            String lineStartDirection =
                getLineStartDirection(context, departureStationLine);
            String lineEndDirection =
                getLineEndDirection(context, departureStationLine);
            String lineName = getLineName(context, departureStationLine);
            route1 = findRoute1(
                departureLineStations,
                departureStationIndex,
                departureLineStations.indexOf(commonStation1),
                lineStartDirection,
                lineEndDirection,
                lineName,
                false);

            lineStartDirection = getLineStartDirection(context, midLineIndex);
            lineEndDirection = getLineEndDirection(context, midLineIndex);
            lineName = getLineName(context, midLineIndex);
            route2 = findRoute1(
                midLine,
                midLine.indexOf(commonStation1),
                midLine.indexOf(commonStation2),
                lineStartDirection,
                lineEndDirection,
                lineName,
                false);

            lineStartDirection =
                getLineStartDirection(context, arrivalStationLine);
            lineEndDirection = getLineEndDirection(context, arrivalStationLine);
            lineName = getLineName(context, arrivalStationLine);
            route3 = findRoute1(
                arrivalLineStations,
                arrivalLineStations.indexOf(commonStation2),
                arrivalStationIndex,
                lineStartDirection,
                lineEndDirection,
                lineName,
                false);

            int numStations1 = int.parse(route1[0][0]);
            int numStations2 = int.parse(route2[0][0]);
            int numStations3 = int.parse(route3[0][0]);

            if (numStations1 < 1 ||
                numStations2 < 1 ||
                numStations3 < 1 ||
                route2[5][0].contains(arrivalStation)) {
              allRoutes.add([]);
            } else {
              tempRoute.add(['Route type: 3']);
              tempRoute.add([
                'No. of stations: ${numStations1 + numStations2 + numStations3}'
              ]);
              int estimatedMinutes =
                  (numStations1 + numStations2 + numStations3) * 3;
              tempRoute.add([
                'Estimated travel time: ${convertMinutesToHoursAndMinutes(estimatedMinutes)}'
              ]);
              tempRoute
                  .add(['Estimated travel time for changing lines: 5 minutes']);
              tempRoute.add([
                'Estimated total travel time: ${convertMinutesToHoursAndMinutes(estimatedMinutes + 5)}'
              ]);
              tempRoute.add([
                'Ticket Price: ${ticketPrice(numStations1 + numStations2 + numStations3)}'
              ]);

              tempRoute.add(["First take: " + route1[1][0]]);
              tempRoute.add(["First Direction: " + route1[2][0]]);
              tempRoute.add(["First Departure: " + route1[3][0]]);
              tempRoute.add(["First Arrival: " + route1[4][0]]);
              tempRoute.add(["First Intermediate Stations: " + route1[5][0]]);

              tempRoute.add(["Second take: " + route2[1][0]]);
              tempRoute.add(["Second Direction: " + route2[2][0]]);
              tempRoute.add(["Second Departure: " + route2[3][0]]);
              tempRoute.add(["Second Arrival: " + route2[4][0]]);
              tempRoute.add(["Second Intermediate Stations: " + route2[5][0]]);

              tempRoute.add(["Third take: " + route3[1][0]]);
              tempRoute.add(["Third Direction: " + route3[2][0]]);
              tempRoute.add(["Third Departure: " + route3[3][0]]);
              tempRoute.add(["Third Arrival: " + route3[4][0]]);
              tempRoute.add(["Third Intermediate Stations: " + route3[5][0]]);

              allRoutes.add(tempRoute);
            }
          }
        }
      }
    }
  }
  return allRoutes;
}

String convertMinutesToHoursAndMinutes(int minutes) {
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;
  return '${hours}h ${remainingMinutes}m';
}

int ticketPrice(int numStations) {
  return numStations < 10
      ? 8
      : numStations < 17
          ? 10
          : numStations < 24
              ? 15
              : 20; // Adjust pricing logic as needed
}

String getLineName(BuildContext context, int line) {
  switch (line) {
    case 1:
      return AppLocalizations.of(context)!.metro1;
    case 2:
      return AppLocalizations.of(context)!.metro2;
    case 3:
      return AppLocalizations.of(context)!.metro3branch1;
    case 4:
      return AppLocalizations.of(context)!.metro3branch2;
    case 5:
      return AppLocalizations.of(context)!.locale == 'ar'
          ? 'القطار الكهربائي الخفيف - المسار الرئيسي'
          : 'LRT Main Trunk';
    case 6:
      return AppLocalizations.of(context)!.locale == 'ar'
          ? 'القطار الكهربائي الخفيف - فرع العاصمة'
          : 'LRT New Capital Branch';
    case 7:
      return AppLocalizations.of(context)!.locale == 'ar'
          ? 'القطار الكهربائي الخفيف - فرع العاشر'
          : 'LRT 10th of Ramadan Branch';
    default:
      return '';
  }
}

int getLineNumber(BuildContext context, String lineName) {
  if (lineName == AppLocalizations.of(context)!.metro1) {
    return 1;
  } else if (lineName == AppLocalizations.of(context)!.metro2) {
    return 2;
  } else if (lineName == AppLocalizations.of(context)!.metro3branch1) {
    return 3;
  } else if (lineName == AppLocalizations.of(context)!.metro3branch2) {
    return 4;
  } else if (lineName == 'LRT Main Trunk' ||
      lineName == 'القطار الكهربائي الخفيف - المسار الرئيسي') {
    return 5;
  } else if (lineName == 'LRT New Capital Branch' ||
      lineName == 'القطار الكهربائي الخفيف - فرع العاصمة') {
    return 6;
  } else if (lineName == 'LRT 10th of Ramadan Branch' ||
      lineName == 'القطار الكهربائي الخفيف - فرع العاشر') {
    return 7;
  } else {
    return 0;
  }
}

List<List<List<String>>> removeRepeatedRoutes(
    List<List<List<String>>> routeData) {
  final noDuplicate = <List<List<String>>>{};
  for (var route in routeData) {
    noDuplicate.add(route);
  }
  return noDuplicate.toList();
}

void printRoutes(List<List<List<String>>> routes) {
  String possibleRoutes = '';

  // Remove null routes
  routes.removeWhere((route) => route == null);

  if (sortValue == 0) {
    // Sort routes based on the number of stations
    routes.sort((a, b) =>
        extractNumberOfStations(a).compareTo(extractNumberOfStations(b)));
  } else if (sortValue == 1) {
    // Sort routes based on the number of stations and exchanges
    routes.sort((a, b) {
      final stationComparison =
          extractNumberOfStations(a).compareTo(extractNumberOfStations(b));
      if (stationComparison != 0) return stationComparison;
      return extractNumberOfExchanges(a).compareTo(extractNumberOfExchanges(b));
    });
  }

  possibleRoutes += "No. of possible routes: ${routes.length}\n\n";

  final List<List<List<int>>> routesCoordinates = [];
  final List<String> allRoutesDetails = [];
  int routeNo = 1;
  String ticketPrice = '';
  bool ticketPriceFound = false;
  String lineName = '';

  for (var route in routes) {
    final routeDetails = StringBuffer("Route ($routeNo)\n");
    for (var segment in route) {
      for (var detail in segment) {
        if (detail.contains('take') || detail.contains('Take')) {
          lineName = detail.split(': ')[1];
        }
        if (detail.contains('→')) {
          //extractStationsPixels(routesCoordinates, detail, lineName, routeNo);
        }
        if (!ticketPriceFound && detail.startsWith('Ticket')) {
          routeDetails.writeln(detail);
          ticketPrice = detail;
          ticketPriceFound = true;
        } else if (detail.startsWith('Ticket')) {
          routeDetails.writeln(ticketPrice);
        } else {
          routeDetails.writeln(detail);
        }
      }
    }
    routeNo++;
    routeDetails.writeln();

    allRoutesDetails.add(routeDetails.toString());
  }

  // Convert routesCoordinates to List<List<List<List<int>>>>
  final serializedData = routesCoordinates.map((route) {
    return route.map((segment) {
      return segment
          .map((coordinate) => List<int>.from(coordinate as Iterable))
          .toList();
    }).toList();
  }).toList();

  // for (int i = 0; i < allRoutesDetails.length; i++) {
  //   // Add Text widget for route details
  //   addTextWidget(allRoutesDetails[i]);
  //
  //   // Add Button for each route
  //   addButton(context, "Show Route ${i + 1}", serializedData[i]);
  // }
}

int extractNumberOfStations(List<List<String>> route) {
  for (var segment in route) {
    for (var detail in segment) {
      if (detail.startsWith('No. of stations:')) {
        final parts = detail.split(': ');
        return int.tryParse(parts[1].trim()) ?? 0;
      }
    }
  }
  return 2147483647; // Return a large number if not found
}

int extractNumberOfExchanges(List<List<String>> route) {
  int exchangeLines = 0;
  for (var segment in route) {
    for (var detail in segment) {
      if (detail.contains('take') || detail.contains('Take')) {
        exchangeLines++;
      }
    }
  }
  return exchangeLines;
}

void extractStationsPixels(
    BuildContext context,
    List<List<List<List<int>>>> routesCoordinates,
    String detail,
    String lineName,
    int routeNo) {
  final temp = detail.split(':')[1];
  final stationList = temp.split('→').map((s) => s.trim()).toList();

  final lineNo = getLineNumber(context, lineName);
  final metroStations = getLineStations(lineNo);
  final metroCoordinates = getLineCoordinates(lineNo);

  final lineCoordinates = <List<int>>[];

  // Check if the route already exists, if not initialize a new list
  List<List<List<int>>> routeLineCoordinates;
  if (routesCoordinates.length >= routeNo) {
    routeLineCoordinates = routesCoordinates[routeNo - 1];
  } else {
    routeLineCoordinates = [];
  }

  // Extract coordinates for each station
  for (var station in stationList) {
    final index = metroStations.indexOf(station);
    if (index != -1) {
      final coordinateCopy = List<int>.from(metroCoordinates[index]);
      lineCoordinates.add(coordinateCopy);
    }
  }

  // Add the line coordinates as a new list to the current route
  routeLineCoordinates.add(List<List<int>>.from(lineCoordinates));

  // Either replace or add new route coordinates
  if (routesCoordinates.length > routeNo - 1) {
    routesCoordinates[routeNo - 1] =
        List<List<List<int>>>.from(routeLineCoordinates);
  } else {
    routesCoordinates.add(List<List<List<int>>>.from(routeLineCoordinates));
  }
}

// void addTextWidget(String text) {
//   final textWidget = Text(
//     text,
//     style: TextStyle(fontSize: 16),
//     textAlign: TextAlign.left,
//   );
//   // Add textWidget to the widget tree (e.g., using a Column or ListView)
// }

// void addButton(BuildContext context, String buttonText, List<List<List<int>>> serializedData) {
//   final button = ElevatedButton(
//     onPressed: () {
//       // Handle button press
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Stationspage(serializedData: serializedData),
//         ),
//       );
//     },
//     child: Text(buttonText),
//   );
//   // Add button to the widget tree (e.g., using a Column or ListView)
// }
