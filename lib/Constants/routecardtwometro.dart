import 'package:flutter/material.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../Controllers/homepagecontroller.dart';
import '../Pages/stationspage.dart';

class RouteCardTwoMetro extends StatelessWidget {
  final HomepageController homeController = Get.put(HomepageController());
  final String numStations;
  final String travelTime;
  final String changeTime;
  final String totalTravelTime;
  final String ticketPrice;
  final String changeAt;
  final String firstMetro;
  final String firstDirection;
  final String firstDeparture;
  final String firstArrival;
  final List<String> firstIntermediateStations;
  final String secondMetro;
  final String secondDirection;
  final String secondDeparture;
  final String secondArrival;
  final List<String> secondIntermediateStations;
  final List<List<List<int>>> serializedData;
  var firstLineIsExpanded;
  var secondLineIsExpanded;

  RouteCardTwoMetro({
    Key? key,
    required this.numStations,
    required this.travelTime,
    required this.changeTime,
    required this.totalTravelTime,
    required this.ticketPrice,
    required this.changeAt,
    required this.firstMetro,
    required this.firstDirection,
    required this.firstDeparture,
    required this.firstArrival,
    required this.firstIntermediateStations,
    required this.secondMetro,
    required this.secondDirection,
    required this.secondDeparture,
    required this.secondArrival,
    required this.secondIntermediateStations,
    required this.serializedData,
    required this.firstLineIsExpanded,
    required this.secondLineIsExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Access localizations

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRouteInfoRow(
                context,
                localizations.egp(ticketPrice), // Localized price
                localizations.travelTime(travelTime), // Localized time
                numStations,
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[400]),
              const SizedBox(height: 10),

              // First Metro Line section
              Obx(() => _buildMetroSection(
                    context,
                    firstMetro,
                    firstDirection,
                    firstDeparture,
                    firstArrival,
                    firstIntermediateStations,
                    Color(0xFF029692),
                    changeAt,
                    "Metro 1",
                    firstLineIsExpanded.value,
                    () {
                      firstLineIsExpanded.value = !firstLineIsExpanded.value;
                    },
                  )),

              const SizedBox(height: 20),
              Divider(color: Colors.grey[400]),
              const SizedBox(height: 10),

              // Second Metro Line section
              Obx(() => _buildMetroSection(
                    context,
                    secondMetro,
                    secondDirection,
                    secondDeparture,
                    secondArrival,
                    secondIntermediateStations,
                    Colors.blue,
                    changeAt,
                    "Metro 2",
                    secondLineIsExpanded.value,
                    () {
                      secondLineIsExpanded.value = !secondLineIsExpanded.value;
                    },
                  )),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Stationspage(
                          serializedData: serializedData,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.showRoute,
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF016B68),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteInfoRow(BuildContext context, String price,
      String travelTime, String numStations) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: homeController.screenWidth! * 0.33,
            child: Text(
              AppLocalizations.of(context)!
                  .routeDetails, // Localized "Route Details"
              style: TextStyle(
                color: const Color(0xFF029692),
                fontSize: homeController.screenWidth! * 0.053,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: homeController.screenWidth! * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.monetization_on,
                        color: const Color(0xFF01C5C4), size: 20),
                    const SizedBox(width: 5),
                    Text(
                      price,
                      style: TextStyle(
                          fontSize: homeController.screenWidth! * 0.034),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.access_time,
                        color: const Color(0xFF01C5C4), size: 20),
                    const SizedBox(width: 5),
                    Text(
                      travelTime.contains("0h")
                          ? travelTime.replaceAll("0h ", "")
                          : travelTime,
                      style: TextStyle(
                          fontSize: homeController.screenWidth! * 0.034),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.stairs,
                        color: const Color(0xFF01C5C4), size: 20),
                    const SizedBox(width: 5),
                    Text(
                      "${AppLocalizations.of(context)!.noOfStations} $numStations", // Localized stations
                      style: TextStyle(
                          fontSize: homeController.screenWidth! * 0.034),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetroSection(
    BuildContext context,
    String metro,
    String direction,
    String departure,
    String arrival,
    List<String> intermediateStations,
    Color color,
    String changeAt,
    String line,
    bool isExpanded,
    VoidCallback onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context)!.take} $metro",
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        _buildInfoRow(Icons.navigation, AppLocalizations.of(context)!.direction,
            direction),
        _buildInfoRow(Icons.location_on,
            AppLocalizations.of(context)!.departure, departure),
        _buildInfoRow(
            Icons.flag, AppLocalizations.of(context)!.arrival, arrival),
        const SizedBox(height: 15),
        _buildStationRow(intermediateStations.first, true),
        _buildIntermediateStations(
          context,
          intermediateStations.sublist(1, intermediateStations.length - 1),
          isExpanded,
          onToggle,
        ),
        _buildStationRow(intermediateStations.last, true),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF01C5C4), size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationRow(String stationName, bool isMajor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: isMajor ? homeController.firstLineColor : Colors.grey,
            size: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              stationName,
              style: TextStyle(
                fontWeight: isMajor ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntermediateStations(
    BuildContext context,
    List<String> stations,
    bool isExpanded,
    VoidCallback onToggle,
  ) {
    return Column(
      children: [
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Column(
            children: stations
                .map((station) => _buildStationRow(station, false))
                .toList(),
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        GestureDetector(
          onTap: onToggle,
          child: Row(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.more_vert,
                    color: homeController.firstLineColor,
                    size: 24,
                  ),
                  if (!isExpanded)
                    Container(
                      width: 2,
                      height: 30,
                      color: homeController.firstLineColor,
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Text(
                isExpanded
                    ? AppLocalizations.of(context)!.hideStations
                    : AppLocalizations.of(context)!.showStations,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
