import 'package:flutter/material.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:metroappflutter/Constants/routecard.dart';

import '../Constants/metro_stations.dart';
import '../Constants/routecardthreemetro.dart';
import '../Constants/routecardtwometro.dart';
import '../Controllers/homepagecontroller.dart';
import '../Controllers/locationservice.dart';
import '../Controllers/routecontroller.dart';

class Routepage extends StatelessWidget {
  Routepage({super.key});
  final HomepageController homeController = Get.put(HomepageController());
  final LocationService locationService = Get.put(LocationService());

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = Get.arguments;
    String depStation = args["DepartureStation"] ?? "Unknown";
    String arrStation = args["ArrivalStation"] ?? "Unknown";
    int sortValue = int.tryParse(args["SortType"] ?? "0") ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: const Color(0xFF029692),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getRoutes(context, depStation, arrStation, sortValue),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    '${AppLocalizations.of(context)!.error} ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
                child: Text(AppLocalizations.of(context)!.noRoutesFound));
          } else {
            final allRoutesDetails = snapshot.data!['allRoutesDetails']
                as List<Map<String, dynamic>>?;
            final serializedData = snapshot.data!['serializedData']
                as List<List<List<List<int>>>>?;
            // Initialize notifications
            locationService.startLocationTracking(
                context, allRoutesDetails![0]);
            if (allRoutesDetails == null) {
              return Center(
                  child: Text(AppLocalizations.of(context)!.invalidDataFormat));
            }
            return Column(
              children: [
                Container(
                  height: homeController.screenHeight! * 0.783,
                  child: ListView.builder(
                    itemCount: allRoutesDetails.length < 1
                        ? allRoutesDetails.length
                        : 1,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: allRoutesDetails[index]["Route type"]
                                .toString()
                                .contains("1")
                            ? RouteCard(
                                numStations: allRoutesDetails[index][
                                    "No. of stations"], // Adjust based on your data
                                travelTime: allRoutesDetails[index][
                                    "Estimated travel time"], // Adjust based on your data
                                ticketPrice: allRoutesDetails[index][
                                    "Ticket Price"], // Adjust based on your data
                                metroName: allRoutesDetails[index]
                                    ["Take"], // Adjust based on your data
                                direction: allRoutesDetails[index]["Direction"],
                                departure: allRoutesDetails[index]["Departure"],
                                arrival: allRoutesDetails[index]["Arrival"],
                                intermediateStations: allRoutesDetails[index][
                                    "Intermediate Stations"], // Populate this based on your data
                                serializedData: serializedData![index],
                                isExpanded: false.obs,
                              )
                            : allRoutesDetails[index]["Route type"]
                                    .toString()
                                    .contains("2")
                                ? RouteCardTwoMetro(
                                    numStations: allRoutesDetails[index]
                                        ["No. of stations"],
                                    travelTime: allRoutesDetails[index]
                                        ["Estimated travel time"],
                                    ticketPrice: allRoutesDetails[index]
                                        ["Ticket Price"],
                                    changeAt: allRoutesDetails[index]
                                        ["You will change at"],
                                    totalTravelTime: allRoutesDetails[index]
                                        ["Estimated total travel time"],
                                    changeTime: allRoutesDetails[index][
                                        "Estimated travel time for changing lines"],
                                    firstMetro: allRoutesDetails[index]
                                        ["First take"],
                                    firstDirection: allRoutesDetails[index]
                                        ["First Direction"],
                                    firstDeparture: allRoutesDetails[index]
                                        ["First Departure"],
                                    firstArrival: allRoutesDetails[index]
                                        ["First Arrival"],
                                    firstIntermediateStations:
                                        allRoutesDetails[index]
                                            ["First Intermediate Stations"],
                                    secondMetro: allRoutesDetails[index]
                                        ["Second take"],
                                    secondDirection: allRoutesDetails[index]
                                        ["Second Direction"],
                                    secondDeparture: allRoutesDetails[index]
                                        ["Second Departure"],
                                    secondArrival: allRoutesDetails[index]
                                        ["Second Arrival"],
                                    secondIntermediateStations:
                                        allRoutesDetails[index]
                                            ["Second Intermediate Stations"],
                                    serializedData: serializedData![index],
                                    firstLineIsExpanded: false.obs,
                                    secondLineIsExpanded: false.obs,
                                  )
                                : allRoutesDetails[index]["Route type"]
                                        .toString()
                                        .contains("3")
                                    ? RouteCardThreeMetro(
                                        numStations: allRoutesDetails[index]
                                            ["No. of stations"],
                                        travelTime: allRoutesDetails[index]
                                            ["Estimated travel time"],
                                        changeTime: allRoutesDetails[index][
                                            "Estimated travel time for changing lines"],
                                        totalTravelTime: allRoutesDetails[index]
                                            ["Estimated total travel time"],
                                        ticketPrice: allRoutesDetails[index]
                                            ["Ticket Price"],

                                        // First metro line details
                                        firstMetro: allRoutesDetails[index]
                                            ["First take"],
                                        firstDirection: allRoutesDetails[index]
                                            ["First Direction"],
                                        firstDeparture: allRoutesDetails[index]
                                            ["First Departure"],
                                        firstArrival: allRoutesDetails[index]
                                            ["First Arrival"],
                                        firstIntermediateStations:
                                            allRoutesDetails[index]
                                                ["First Intermediate Stations"],

                                        // Second metro line details
                                        secondMetro: allRoutesDetails[index]
                                            ["Second take"],
                                        secondDirection: allRoutesDetails[index]
                                            ["Second Direction"],
                                        secondDeparture: allRoutesDetails[index]
                                            ["Second Departure"],
                                        secondArrival: allRoutesDetails[index]
                                            ["Second Arrival"],
                                        secondIntermediateStations:
                                            allRoutesDetails[index][
                                                "Second Intermediate Stations"],

                                        // Third metro line details
                                        thirdMetro: allRoutesDetails[index]
                                            ["Third take"],
                                        thirdDirection: allRoutesDetails[index]
                                            ["Third Direction"],
                                        thirdDeparture: allRoutesDetails[index]
                                            ["Third Departure"],
                                        thirdArrival: allRoutesDetails[index]
                                            ["Third Arrival"],
                                        thirdIntermediateStations:
                                            allRoutesDetails[index]
                                                ["Third Intermediate Stations"],

                                        serializedData: serializedData![index],

                                        firstLineIsExpanded: false.obs,
                                        secondLineIsExpanded: false.obs,
                                        thirdLineIsExpanded: false.obs,
                                      )
                                    : null,
                      );
                    },
                  ),
                ),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildIconButton(
                        icon: Icons.directions,
                        label: AppLocalizations.of(context)!.routeToNearest,
                        onPressed: () {
                          if (homeController.userLocation != null &&
                              homeController.departureLocation != null) {
                            homeController.launchUrl_(
                                homeController.userLocation,
                                homeController.departureLocation);
                          } else {
                            showCustomToast(AppLocalizations.of(context)!
                                .pleaseClickOnMyLocation);
                          }
                        },
                        enable: homeController.nearestRouteButtonFlag,
                        errorMSG: AppLocalizations.of(context)!
                            .pleaseClickOnMyLocation,
                      ),
                    ),
                    Expanded(
                      child: _buildIconButton(
                        icon: Icons.directions_car,
                        label: AppLocalizations.of(context)!.routeToDestination,
                        onPressed: () {
                          if (homeController.arrivalLocation != null &&
                              homeController.destinationLocation != null) {
                            homeController.launchUrl_(
                                homeController.arrivalLocation,
                                homeController.destinationLocation);
                          } else {
                            showCustomToast(AppLocalizations.of(context)!
                                .mustTypeDestination);
                          }
                        },
                        enable: homeController.destinationButtonFlag,
                        errorMSG: AppLocalizations.of(context)!.mustTypeDestination,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required RxBool enable,
    required String errorMSG,
    required VoidCallback onPressed,
  }) {
    return Obx(
      () => Column(
        children: [
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed:
                enable.value ? onPressed : () => showCustomToast(errorMSG),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor:
                  enable.value ? homeController.primaryColor : Colors.grey,
              padding: EdgeInsets.all(11),
              elevation: 5,
            ),
            child: Icon(icon,
                color: Colors.white,
                size: homeController.screenHeight! * 0.028),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
                fontSize: homeController.screenWidth! * 0.032,
                color: enable.value ? homeController.primaryColor : Colors.grey,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
