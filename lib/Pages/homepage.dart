import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:metroappflutter/Pages/routepage.dart';
import 'package:metroappflutter/Pages/station_facilities.dart';
import 'package:metroappflutter/Pages/subscription_info.dart';
import 'package:metroappflutter/Pages/tourist_guide.dart';
import '../Constants/metro_stations.dart';
import '../Controllers/homepagecontroller.dart';
import '../Controllers/languagecontroller.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Homepage extends StatelessWidget {
  // Modern Egyptian-inspired color palette
  final Color primaryColor = Color(0xFF1A6F8F); // Deep Nile Blue
  final Color secondaryColor = Color(0xFF029692); // Teal
  final Color accentColor = Color(0xFFD4AF37); // Egyptian Gold
  final Color backgroundColor = Color(0xFFF5F5F5); // Light Sand
  final Color cardColor = Color(0xFFFFFFFF); // White
  final Color textColor = Color(0xFF333333); // Dark Gray

  // Controllers and observables
  final TextEditingController destinationController = TextEditingController();
  final FocusNode destinationFocusNode = FocusNode();
  final RxString depStation = ''.obs;
  final RxString arrStation = ''.obs;
  final RxString depStationSelection = ''.obs;
  final RxString arrStationSelection = ''.obs;

  final HomepageController controller = Get.put(HomepageController());
  final LanguageController langController = Get.put(LanguageController());

  // New features data
  final List<Map<String, dynamic>> quickActions = [
    {
      'icon': Icons.history,
      'label': 'recentTripsLabel',
      'color': Color(0xFF4CAF50)
    },
    {
      'icon': Icons.schedule,
      'label': 'scheduleLabel',
      'color': Color(0xFFE30613)
    },
    {'icon': Icons.star, 'label': 'favoritesLabel', 'color': Color(0xFFFFD700)},
    {
      'icon': Icons.accessible,
      'label': 'accessibilityLabel',
      'color': Color(0xFF9C27B0)
    },
  ];

  final List<Map<String, dynamic>> metroLines = [
    {
      'number': '1',
      'name': 'line1Name',
      'color': Color(0xFFE30613),
      'stations': 35,
      'length': '44.3 km'
    },
    {
      'number': '2',
      'name': 'line2Name',
      'color': Color(0xFFFFD700),
      'stations': 20,
      'length': '21.5 km'
    },
    {
      'number': '3',
      'name': 'line3Name',
      'color': Color(0xFF4CAF50),
      'stations': 29,
      'length': '41.2 km'
    },
    {
      'number': '4',
      'name': 'line4Name',
      'color': Color(0xFF1A6F8F),
      'stations': 42,
      'length': '42 km',
      'comingSoon': true
    },
  ];

  @override
  Widget build(BuildContext context) {
    controller.screenWidth = MediaQuery.of(context).size.width;
    controller.screenHeight = MediaQuery.of(context).size.height;
    controller.allMetroStations = getAllMetroStations(context);
    controller.getMetroStationsLists(context);

    final localization = AppLocalizations.of(context);
    if (localization == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                localization.appTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/metroBG1.jpg'),
                    opacity: 0.1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.white),
                onPressed: () => _showAppInfo(context),
              ),
              _buildLanguageSwitcher(),
            ],
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  _buildWelcomeHeader(context),
                  SizedBox(height: 24),
                  _buildRoutePlanningCard(context),
                  SizedBox(height: 16),
                  _buildAddressSearchCard(context),
                  SizedBox(height: 24),
                  _buildQuickActionsRow(context),
                  SizedBox(height: 24),
                  _buildMetroLinesPreview(context),
                  SizedBox(height: 16),
                  _buildAroundStationsCarousel(context),
                  SizedBox(height: 16),
                  _buildMetroMapPreview(context),
                  SizedBox(height: 16),
                  _buildSubscriptionInfoCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.userLocation = await controller.getUserLocation();
          Map<String, dynamic>? nearestStationList = await controller
              .findNearestStation(controller.userLocation, context);
          String nearestStation = nearestStationList["Station"].toString();
          controller.departureLocation =
              nearestStationList["DepartureLocation"];
          depStationSelection.value = nearestStation ?? "";
          controller.nearestRouteButtonFlag.value = nearestStation != null;
          depStation.value = depStationSelection.value;

          _showNearestStationSnackbar(context, nearestStation);
        },
        backgroundColor: accentColor,
        child: Icon(Icons.gps_fixed, color: Colors.white),
        elevation: 4,
      ),
    );
  }

  // ============== New Widgets ==============

  Widget _buildAroundStationsCarousel(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final stationsEN = getMetroLine3StationsEN(context);
    final stationsAR = getMetroLine3StationsAR(context);
    final isArabic = AppLocalizations.of(context)!.locale == 'ar';
    print(isArabic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "${localization.aroundStationsTitle} - ${localization.line3Name}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.85,
          ),
          items: stationsEN.asMap().entries.map((entry) {
            final index = entry.key;
            final stationNameEN = entry.value;
            final stationNameDisplay = stationsAR[index];
            final imagePath =
                'assets/stations/line3/${_getStationImageName(stationNameEN)}.jpg';
            print(stationNameDisplay);

            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => _showStationFacilities(context, stationNameEN, stationsAR[index]),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Station Image with error fallback
                          _buildStationImage(imagePath),
                          // Gradient overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Station Info
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stationNameDisplay,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  localization.seeFacilities,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStationImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: double.infinity,
      fit: BoxFit.cover,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/playstore.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  String _getStationImageName(String stationName) {
    // Convert station name to lowercase and replace spaces/special characters
    return stationName;
    // .toLowerCase()
    // .replaceAll(' ', '_')
    // .replaceAll('-', '_')
    // .replaceAll('(', '')
    // .replaceAll(')', '')
    // .replaceAll(' ', '');
  }

  Widget _buildSubscriptionInfoCard(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SubscriptionInfoPage()),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.credit_card, color: Colors.white),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.subscriptionInfoTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    localization.subscriptionInfoSubtitle,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: primaryColor),
          ],
        ),
      ),
    );
  }

  // ============== Updated Widgets ==============

  Widget _buildQuickActionsRow(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: quickActions.map((action) {
        return _buildQuickActionButton(
          icon: action['icon'],
          label: action['label'],
          onPressed: () {
            if (action['label'] == 'accessibilityLabel') {
              _showAccessibilityInfo(context);
            } else {
              // Handle other actions
            }
          },
          color: action['color'],
        );
      }).toList(),
    );
  }

  Widget _buildMetroLinesPreview(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.metroLinesTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              TextButton(
                onPressed: () => _showAllLines(context),
                child: Text(localization.seeAll),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: metroLines.length,
            itemBuilder: (context, index) {
              final line = metroLines[index];
              return _buildMetroLineCard(
                context: context,
                lineNumber: line['number'],
                lineName: line['name'],
                color: line['color'],
                stations: line['stations'].toString(),
                length: line['length'],
                comingSoon: line['comingSoon'] ?? false,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMetroLineCard({
    required BuildContext context,
    required String lineNumber,
    required String lineName,
    required Color color,
    required String stations,
    String? length,
    bool comingSoon = false,
  }) {
    return GestureDetector(
      onTap: () => _showLineDetails(context, lineNumber),
      child: Container(
        width: 180,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        lineNumber,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lineName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.train, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 6),
                  Text(
                    '$stations ${AppLocalizations.of(context)!.stationsLabel}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (length != null) ...[
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.linear_scale, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 6),
                    Text(
                      length,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
              if (comingSoon) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.comingSoonLabel,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============== New Helper Methods ==============

  Future<void> _showStationFacilities(
      BuildContext context, String stationNameEN, String stationsLan) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationFacilitiesPage(stationNameEN: stationNameEN, stationNameLang: stationsLan),
      ),
    );
  }

  void _showAccessibilityInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.accessibilityInfoTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAccessibilityFeature(
              icon: Icons.elevator,
              title: AppLocalizations.of(context)!.elevatorsTitle,
              description: AppLocalizations.of(context)!.elevatorsDescription,
            ),
            Divider(),
            _buildAccessibilityFeature(
              icon: Icons.accessible,
              title: AppLocalizations.of(context)!.wheelchairTitle,
              description: AppLocalizations.of(context)!.wheelchairDescription,
            ),
            Divider(),
            _buildAccessibilityFeature(
              icon: Icons.hearing,
              title: AppLocalizations.of(context)!.hearingImpairmentTitle,
              description:
                  AppLocalizations.of(context)!.hearingImpairmentDescription,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: primaryColor),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAllLines(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.allMetroLines,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: metroLines.length,
                    itemBuilder: (context, index) {
                      final line = metroLines[index];
                      return _buildExpandedLineCard(
                        context: context,
                        lineNumber: line['number'],
                        lineName: line['name'],
                        color: line['color'],
                        stations: line['stations'].toString(),
                        length: line['length'],
                        comingSoon: line['comingSoon'] ?? false,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpandedLineCard({
    required BuildContext context,
    required String lineNumber,
    required String lineName,
    required Color color,
    required String stations,
    String? length,
    bool comingSoon = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      lineNumber,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lineName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (comingSoon)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.comingSoonLabel,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.stationsLabel,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        stations,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (length != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.lengthLabel,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          length,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLineDetails(context, lineNumber),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.withOpacity(0.1),
                  foregroundColor: color,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.viewDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Add these inside your Homepage class (before the build method)

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.appInfoTitle),
        content: Text(AppLocalizations.of(context)!.appInfoDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSwitcher() {
    return IconButton(
      icon: Icon(Icons.language, color: Colors.white),
      onPressed: () {
        showModalBottomSheet(
          context: Get.context!,
          builder: (context) => Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select Language',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                ListTile(
                  title: Text('English'),
                  onTap: () {
                    langController.switchLanguage('en');
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('العربية'),
                  onTap: () {
                    langController.switchLanguage('ar');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1.3,
            ),
            children: [
              TextSpan(text: AppLocalizations.of(context)!.welcomeTitle + '\n'),
              TextSpan(
                text: AppLocalizations.of(context)!.welcomeSubtitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showNearestStationSnackbar(BuildContext context, String station) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${AppLocalizations.of(context)!.nearestStationFound}: $station',
                ),
              ),
            ],
          ),
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cardColor,
          foregroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showLineDetails(BuildContext context, String lineNumber) {
    // Implement your line details dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Line $lineNumber Details'),
        content: Text('Details for Metro Line $lineNumber'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutePlanningCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSectionTitle(AppLocalizations.of(context)!.planYourRoute,
                    Icons.directions_subway),
                SizedBox(height: 20),
                _buildStationDropdown(
                  context: context,
                  title: AppLocalizations.of(context)!.departureStationTitle,
                  hint: AppLocalizations.of(context)!.departureStationHint,
                  observable: depStation,
                  observableSelection: depStationSelection,
                  icon: Icons.train,
                ),
                SizedBox(height: 16),
                _buildStationDropdown(
                  context: context,
                  title: AppLocalizations.of(context)!.arrivalStationTitle,
                  hint: AppLocalizations.of(context)!.arrivalStationHint,
                  observable: arrStation,
                  observableSelection: arrStationSelection,
                  icon: Icons.location_on,
                ),
                SizedBox(height: 20),
                _buildShowRouteButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSearchCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSectionTitle(
                    AppLocalizations.of(context)!.findNearestStation,
                    Icons.search),
                SizedBox(height: 20),
                TextField(
                  controller: destinationController,
                  focusNode: destinationFocusNode,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.destinationFieldLabel,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    prefixIcon: Container(
                      margin: EdgeInsets.only(left: 12, right: 8),
                      child: Icon(Icons.location_on, color: primaryColor),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      try {
                        List<Location> locations = await locationFromAddress(
                          destinationController.text,
                        ).timeout(Duration(seconds: 10));

                        if (locations.isNotEmpty) {
                          controller.destinationLocation =
                              controller.locationToPosition(locations.first);

                          Map<String, dynamic>? nearestStationList =
                              await controller.findNearestStation(
                                  controller.destinationLocation, context);

                          String nearestStation =
                              nearestStationList?["Station"].toString() ?? "";
                          controller.arrivalLocation =
                              nearestStationList?["DepartureLocation"];
                          arrStationSelection.value =
                              nearestStation.isNotEmpty ? nearestStation : "";
                          arrStation.value = arrStationSelection.value;

                          controller.destinationButtonFlag.value =
                              locations.isNotEmpty;

                          _showFoundStationSnackbar(context, nearestStation);
                        }
                      } catch (e) {
                        _showErrorSnackbar(
                            context, AppLocalizations.of(context)!.addressNotFound);
                      }
                    },
                    icon: Icon(Icons.search, size: 20),
                    label: Text(AppLocalizations.of(context)!.findButtonText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      shadowColor: accentColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetroMapPreview(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullMetroMap(context),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Metro map image with gradient overlay
              Positioned.fill(
                child: Image.asset(
                  'assets/images/CairoMetroMap.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Interactive elements
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.metroMapLabel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.fullscreen,
                                  size: 16, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                AppLocalizations.of(context)!.viewFullMap,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStationDropdown({
    required BuildContext context,
    required String title,
    required String hint,
    required RxString observable,
    required RxString observableSelection,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 8),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 12, right: 8),
                  child: Icon(icon, color: primaryColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              value: observableSelection.value.isEmpty
                  ? null
                  : observableSelection.value,
              items: controller.allMetroStations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 16)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                observable.value = newValue ?? "";
                observableSelection.value = newValue ?? "";
              },
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: primaryColor),
              dropdownColor: Colors.white,
              style: TextStyle(color: textColor),
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShowRouteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (depStation.value.isEmpty) {
            _showErrorSnackbar(
                context, AppLocalizations.of(context)!.pleaseSelectDeparture);
          } else if (arrStation.value.isEmpty) {
            _showErrorSnackbar(
                context, AppLocalizations.of(context)!.pleaseSelectArrival);
          } else if (depStation.value == arrStation.value) {
            _showErrorSnackbar(
                context, AppLocalizations.of(context)!.selectDifferentStations);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Routepage(),
                settings: RouteSettings(arguments: {
                  "DepartureStation": depStation.value,
                  "ArrivalStation": arrStation.value,
                  "SortType": "0"
                }),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions, size: 24),
            SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.showRoutesButtonText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullMetroMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.metroMapLabel),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(20),
            minScale: 0.5, // Can zoom out to half size
            maxScale: 4.0, // Can zoom in 4x
            panEnabled: true,
            scaleEnabled: true,
            child: Center(
              child: Image.asset(
                'assets/images/CairoMetroMap.jpg',
                filterQuality: FilterQuality.high,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => Navigator.pop(context),
          //   child: Icon(Icons.close),
          //   tooltip: AppLocalizations.of(context)!.close,
          // ),
        ),
      ),
    );
  }

  void _showFoundStationSnackbar(BuildContext context, String station) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${AppLocalizations.of(context)!.stationFound}: $station',
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4CAF50),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red[400],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
