import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:metroappflutter/Controllers/routecontroller.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/widgets/route_timeline.dart';
import 'package:metroappflutter/widgets/skeleton_loader.dart';

class Routepage extends StatelessWidget {
  Routepage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = Get.arguments;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSand,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => HapticFeedback.selectionClick(),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getRoutes(
          context,
          args['DepartureStation'] ?? '',
          args['ArrivalStation'] ?? '',
          int.tryParse(args['SortType'] ?? '0') ?? 0,
        ),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const RouteSkeletonLoader();
          }
          if (snapshot.hasError) {
            return Center(child: Text('${l10n.error} ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text(l10n.noRoutesFound));
          }

          final routeDetails = snapshot.data!['allRoutesDetails'] as List<Map<String, dynamic>>?;
          final serializedData = snapshot.data!['serializedData'] as List<List<List<List<int>>>>?;
          if (routeDetails == null || serializedData == null || routeDetails.isEmpty) {
            return Center(child: Text(l10n.noRoutesFound));
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Text(
                  '${args['DepartureStation']} → ${args['ArrivalStation']}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: routeDetails.length,
                  itemBuilder: (_, index) => RouteTimeline(
                    routeData: routeDetails[index],
                    serializedData: serializedData[index],
                    isFirst: index == 0,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
