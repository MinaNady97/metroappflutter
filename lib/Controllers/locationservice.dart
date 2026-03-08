import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Constants/metro_stations.dart';
import 'homepagecontroller.dart';
import 'package:flutter/material.dart';

final HomepageController homeController = Get.put(HomepageController());

class LocationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    // Check if notification permissionanted
    PermissionStatus status = await Permission.notification.status;

    if (!status.isGranted) {
      // Request permission if not granted
      status = await Permission.notification.request();
    }

    // Proceed with initialization if permission is granted
    if (status.isGranted) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      bool? initialized = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
          // Handle when the notification is clicked
          print(
              "Notification clicked with payload: ${notificationResponse.payload}");
        },
      );

      if (initialized == null || !initialized) {
        print('Notification initialization failed');
      } else {
        print('Notification initialized');
      }
    } else {
      print('Notification permission denied');
    }
  }

  // Method to request and handle location permissions
  Future<bool> handleLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await handleLocationPermissions();
    if (!hasPermission) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> sendNotification(String title, String body) async {
    try {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your_channel_id', 'your_channel_name',
              importance: Importance.max,
              priority: Priority.high,
              styleInformation: BigTextStyleInformation(body));
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
      );
      print('Notification sent : $title');
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  void startLocationTracking(
      BuildContext context, Map<String, dynamic> route) async {
    await initializeNotifications(); // Ensure notifications are initialized

    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Settings for location updates
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20, // Update after moving 50 meters
    );

    Duration updateInterval = Duration(seconds: 5);
    StreamSubscription<Position>? positionStream;

    bool startTrip = false;
    bool nextStationFlag = true;
    int stationIndex = 0;
    double previosDistance = 0;
    String nextStation = "";
    String currentStation = "";

    // List of simulated positions (latitude, longitude)
    List<LatLng> simulatedPositions = [
      LatLng(29.952885, 31.025356),
      LatLng(29.952885, 31.025357),
      LatLng(30.02, 31.238415),
      LatLng(30.037016, 31.238415), // Saad Zaghloul
      LatLng(30.044141, 31.234446), // Sadat
      LatLng(30.04167, 31.22528), // Opera
      LatLng(30.03833, 31.21194), // Dokki
      LatLng(30.03583, 31.20028), // EL-Bohoth
    ];

    int simulatedPositionsIndex = 0;
    int counter = 0;

    Map<String, List<String>> initializeRouteMap = initializeRoute(route);

    print(route);
    print(initializeRouteMap);

    void startListening() async {
      permission = await Geolocator.checkPermission();
      print('Permission status: $permission');

      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission denied forever');
        return Future.error('Location permissions are permanently denied.');
      }

      print('Location permission granted');

      positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position position) async {
        if (counter % 2 == 0) {
          simulatedPositionsIndex++;
        }
        counter++;
        print("Counter: ");
        print(counter);
        print("simulatedPositionsIndex: ");
        print(simulatedPositionsIndex);

        if (startTrip) {
          // Logic for when the trip starts
          currentStation = stationIndex == 0
              ? initializeRouteMap["Departure Station"]![0]
              : currentStation =
                  initializeRouteMap["Stations"]![stationIndex - 1];
          nextStation = stationIndex < initializeRouteMap["Stations"]!.length
              ? initializeRouteMap["Stations"]![stationIndex]
              : "";

          print(currentStation);
          print(nextStation);
          if (nextStationFlag) {
            if (initializeRouteMap["Exchange Station"]!.contains(nextStation)) {
              // Get localized message for distance to the next station
              String exchangeMessage =
                  AppLocalizations.of(context)!.changeLineAt(
                currentStation,
                initializeRouteMap["Directions"]![
                    initializeRouteMap["Exchange Station"]!
                        .indexOf(nextStation)],
                initializeRouteMap["Lines"]![
                    initializeRouteMap["Exchange Station"]!
                        .indexOf(nextStation)],
                nextStation,
              );

              // Send notification about the distance to the next station
              await sendNotification(
                AppLocalizations.of(context)!.exchangeStation,
                exchangeMessage,
              );
            } else if (initializeRouteMap["Arrival Station"]!
                .contains(nextStation)) {
              // Get localized message for distance to the next station
              String arrivalMessage = AppLocalizations.of(context)!
                  .finalStation(currentStation, nextStation);

              // Send notification about the distance to the next station
              await sendNotification(
                AppLocalizations.of(context)!.arrivalStationTitle,
                arrivalMessage,
              );
            } else if (!initializeRouteMap["Arrival Station"]!
                .contains(currentStation)) {
              // Get localized message for distance to the next station
              String intermediateMessage = AppLocalizations.of(context)!
                  .nextStation(currentStation, nextStation);

              // Send notification about the distance to the next station
              await sendNotification(
                AppLocalizations.of(context)!.intermediateStationsTitle,
                intermediateMessage,
              );
            }
          }

          nextStationFlag = false;

          if (stationIndex < initializeRouteMap["Stations"]!.length) {
            Map<String, dynamic> StationPosition =
                await findNextStationPosition(nextStation);

            double distanceToNextStation = Geolocator.distanceBetween(
              simulatedPositions[simulatedPositionsIndex].latitude,
              simulatedPositions[simulatedPositionsIndex].longitude,
              StationPosition["latitude"],
              StationPosition["longitude"],
            );

            print("distanceToNextStation");
            print(distanceToNextStation);
            // Add a threshold to prevent sending notifications for very small changes
            double distanceThreshold = 30; // Notify only if change > 100 meters

            if ((distanceToNextStation).abs() < distanceThreshold) {
              stationIndex++;
              nextStationFlag = true;
            }
          } else {
            // Stop the location updates by cancelling the position stream subscription
            positionStream?.cancel();

            // Optionally, send a final notification that the trip has ended
            await sendNotification(
              AppLocalizations.of(context)!.arrivalStationTitle,
              AppLocalizations.of(context)!.finalStationReached,
            );
          }
        } else {
          Map<String, dynamic> StationPosition = await findNextStationPosition(
              initializeRouteMap["Departure Station"]![0]);

          double distanceToNextStation = Geolocator.distanceBetween(
            simulatedPositions[simulatedPositionsIndex].latitude,
            simulatedPositions[simulatedPositionsIndex].longitude,
            StationPosition["latitude"],
            StationPosition["longitude"],
          );

          if (distanceToNextStation < 30) {
            startTrip = true;
          }

          // Add a threshold to prevent sending notifications for very small changes
          double distanceThreshold = 100; // Notify only if change > 100 meters

          print(
              "Current distance to next station: $distanceToNextStation meters");
          print(
              "Difference from previous distance: ${(previosDistance - distanceToNextStation).abs()} meters");

          if ((previosDistance - distanceToNextStation).abs() >
                  distanceThreshold &&
              !startTrip) {
            print("Significant movement detected. Sending notification...");

            // Get localized message for distance to the next station
            String distanceMessage =
                AppLocalizations.of(context)!.distanceToStation(
              distanceToNextStation.toStringAsFixed(0),
              initializeRouteMap["Departure Station"]![0],
            );

            // Send notification about the distance to the next station
            await sendNotification(
              AppLocalizations.of(context)!.departureStationTitle,
              distanceMessage,
            );

            // Update previous distance to the new one
            previosDistance = distanceToNextStation;
          } else {
            print("Movement too small, not sending notification.");
          }
        }

        // Restart location updates after a delay
        positionStream?.cancel();
        Future.delayed(updateInterval, startListening);
      });
    }

    startListening(); // Start tracking location
  }

  // Method to find the next station based on the current position and route
  Future<Map<String, dynamic>> findNextStation(
      Position currentPosition, Map<String, dynamic> route) async {
    List<dynamic> intermediateStations = route['Intermediate Stations'];
    Map<String, dynamic> nextStation = {};

    // Assuming you have a method to get station coordinates
    for (String station in intermediateStations) {
      // Fetch the station coordinates based on the station name
      Map<String, double> stationCoordinates =
          await getStationCoordinates(station);

      // Calculate the distance from the current position to the station
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        stationCoordinates['latitude']!,
        stationCoordinates['longitude']!,
      );

      // You can set a threshold distance to consider a station as the next station
      if (nextStation.isEmpty || distance < nextStation['distance']) {
        nextStation = {
          'name': station,
          'latitude': stationCoordinates['latitude'],
          'longitude': stationCoordinates['longitude'],
          'distance': distance,
        };
      }
    }

    return nextStation;
  }

  // Method to find the next station based on the current position and route
  Future<Map<String, dynamic>> findNextStationPosition(String station) async {
    Map<String, double> stationCoordinates =
        await getStationCoordinates(station);

    return {
      'name': station,
      'latitude': stationCoordinates['latitude'],
      'longitude': stationCoordinates['longitude'],
      // 'distance': distance,
    };
  }

  // Method to get the next station name based on the current route
  static Future<String> getNextStationName(Map<String, dynamic> route) async {
    // Determine the next station name based on the route type
    switch (route['Route type']) {
      case 1:
        return route['Intermediate Stations']
            [0]; // Return the first intermediate station name
      case 2:
        return route['First Intermediate Stations']
            [0]; // Return the first intermediate station name
      case 3:
        return route['First Intermediate Stations']
            [0]; // Return the first intermediate station name
      default:
        return 'No station available';
    }
  }

  static Map<String, double> getStationCoordinates(String station) {
    int index = homeController.allMetroStations.indexOf(station);
    return {
      "latitude": allMetroStationsCoordinates[index][0],
      "longitude": allMetroStationsCoordinates[index][1]
    };
  }

  Map<String, List<String>> initializeRoute(Map<String, dynamic> route) {
    Map<String, List<String>> initializeRouteMap = {};

    switch (int.parse(route['Route type'])) {
      case 1:
        {
          initializeRouteMap["Departure Station"] = [
            route["Departure"].toString()
          ];
          initializeRouteMap["Arrival Station"] = [route["Arrival"].toString()];
          initializeRouteMap["Stations"] =
              (route["Intermediate Stations"] as List<dynamic>)
                  .sublist(1, route["Intermediate Stations"].length)
                  .map((station) => station.toString())
                  .toList();
          initializeRouteMap["Exchange Station"] = [];
          initializeRouteMap["Lines"] = [];
          initializeRouteMap["Directions"] = [];
        }
        break;

      case 2:
        {
          initializeRouteMap["Departure Station"] = [
            route["First Departure"].toString()
          ];
          initializeRouteMap["Arrival Station"] = [
            route["Second Arrival"].toString()
          ];
          initializeRouteMap["Stations"] =
              (route["First Intermediate Stations"] as List<dynamic>)
                      .sublist(1)
                      .map((station) => station.toString())
                      .toList() +
                  (route["Second Intermediate Stations"] as List<dynamic>)
                      .sublist(1, route["Second Intermediate Stations"].length)
                      .map((station) => station.toString())
                      .toList();
          initializeRouteMap["Exchange Station"] = [
            route["You will change at"].toString()
          ];
          initializeRouteMap["Lines"] = [route["Second take"].toString()];
          initializeRouteMap["Directions"] = [
            route["Second Direction"].toString()
          ];
        }
        break;

      case 3:
        {
          initializeRouteMap["Departure Station"] = [
            route["First Departure"].toString()
          ];
          initializeRouteMap["Arrival Station"] = [
            route["Third Arrival"].toString()
          ];
          initializeRouteMap["Stations"] =
              (route["First Intermediate Stations"] as List<dynamic>)
                      .sublist(1)
                      .map((station) => station.toString())
                      .toList() +
                  (route["Second Intermediate Stations"] as List<dynamic>)
                      .sublist(1)
                      .map((station) => station.toString())
                      .toList() +
                  (route["Third Intermediate Stations"] as List<dynamic>)
                      .sublist(1, route["Third Intermediate Stations"].length)
                      .map((station) => station.toString())
                      .toList();
          initializeRouteMap["Exchange Station"] = [
            route["First Arrival"].toString(),
            route["Second Arrival"].toString()
          ];
          initializeRouteMap["Lines"] = [
            route["Second take"].toString(),
            route["Third take"].toString()
          ];
          initializeRouteMap["Directions"] = [
            route["Second Direction"].toString(),
            route["Third Direction"].toString()
          ];
        }
        break;

      default:
        {
          initializeRouteMap["Departure Station"] = [];
          initializeRouteMap["Arrival Station"] = [];
          initializeRouteMap["Stations"] = [];
        }
        break;
    }

    return initializeRouteMap;
  }
}
