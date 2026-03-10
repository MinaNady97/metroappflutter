import 'package:flutter/material.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../Controllers/homepagecontroller.dart';
import '../Pages/stationspage.dart';

class RouteCard extends StatelessWidget {
  final HomepageController homeController = Get.find<HomepageController>();
  final String numStations;
  final String travelTime;
  final String ticketPrice;
  final String metroName;
  final String direction;
  final String departure;
  final String arrival;
  final List<String> intermediateStations;
  final List<List<List<int>>> serializedData;
  var isExpanded; // Observable boolean for expanded state

  RouteCard({
    Key? key,
    required this.numStations,
    required this.travelTime,
    required this.ticketPrice,
    required this.metroName,
    required this.direction,
    required this.departure,
    required this.arrival,
    required this.intermediateStations,
    required this.serializedData,
    required this.isExpanded,
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
              const SizedBox(height: 2),
              Divider(color: Colors.grey[400]),
              const SizedBox(height: 10),
              _buildInfoRow(
                  Icons.location_on, localizations.departure, departure),
              _buildInfoRow(Icons.flag, localizations.arrival, arrival),
              _buildInfoRow(Icons.directions, localizations.take, metroName),
              _buildInfoRow(
                  Icons.navigation, localizations.direction, direction),
              const SizedBox(height: 15),
              Text(
                localizations.intermediateStations,
                style: const TextStyle(
                  color: Color(0xFF01C5C4),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildStationRow(
                  intermediateStations.first, true), // First station
              Obx(() => _buildIntermediateStations(
                  intermediateStations.sublist(0, intermediateStations.length),
                  isExpanded,
                  localizations)), // Collapsible section
              _buildStationRow(intermediateStations.last, true), // Last station
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
                    localizations.showRoute, // Localized "Show Route"
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF016B68),
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

  Widget _buildIntermediateStations(List<String> stations, RxBool isExpanded,
      AppLocalizations localizations) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            isExpanded.value = !isExpanded.value; // Toggle the expanded state
          },
          child: Row(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.more_vert,
                    color: homeController.firstLineColor,
                    size: 24,
                  ),
                  if (!isExpanded.value)
                    Container(
                      width: 2,
                      height: 30,
                      color: homeController.firstLineColor,
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Text(
                isExpanded.value
                    ? localizations.hideStations
                    : localizations.showStations, // Localized text
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        if (isExpanded.value)
          for (int i = 1; i < stations.length - 1; i++)
            _buildStationRow(stations[i], false),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF01C5C4), size: 20),
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
              style: const TextStyle(fontSize: 16),
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
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            stationName,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
