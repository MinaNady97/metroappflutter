import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

class StationFacilitiesPage extends StatefulWidget {
  final String stationNameEN;
  final String stationNameLang;

  const StationFacilitiesPage({
    Key? key,
    required this.stationNameEN,
    required this.stationNameLang,
  }) : super(key: key);

  @override
  State<StationFacilitiesPage> createState() => _StationFacilitiesPageState();
}

class _StationFacilitiesPageState extends State<StationFacilitiesPage> {
  final Color primaryColor = Color(0xFF1A6F8F);
  final Color secondaryColor = Color(0xFF029692);
  final Color accentColor = Color(0xFFD4AF37);
  final Color backgroundColor = Color(0xFFF5F5F5);
  final Color cardColor = Color(0xFFFFFFFF);
  final Color textColor = Color(0xFF333333);

  Map<String, dynamic>? stationData;
  final Map<String, bool> _sectionExpansionState = {};
  final Map<String, IconData> _categoryIcons = {
    'Religious': Icons.account_balance,
    'Medical': Icons.local_hospital,
    'Cultural': Icons.theater_comedy,
    'Commercial': Icons.shopping_cart,
    'Public Spaces': Icons.park,
    'Sport Facilities': Icons.sports_soccer,
    'Educational': Icons.school,
    'Services': Icons.design_services,
    'Landmarks': Icons.landscape,
    'Public Institutions': Icons.account_balance_outlined,
    'Streets': Icons.directions,
  };

  @override
  void initState() {
    super.initState();
    _loadStationData();
  }

  Future<void> _loadStationData() async {
    final jsonStr = await rootBundle
        .loadString('assets/data/full_cairo_metro_template2.json');
    final Map<String, dynamic> data = json.decode(jsonStr);
    final locale = AppLocalizations.of(context)!.locale;

    final key = '${locale}_metroStation${widget.stationNameEN}';
    print(key);

    setState(() {
      stationData = data[key];
      // Initialize all sections as collapsed
      _categoryIcons.keys.forEach((key) {
        _sectionExpansionState[key] = false;
      });
    });
  }

  // Helper method to get all items by category
  Map<String, dynamic> _getItemsByCategory(String category) {
    final items = <String, dynamic>{};
    if (stationData != null) {
      stationData!.forEach((key, value) {
        if (value['category'] == category) {
          items[key] = value;
        }
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title:
            Text('${widget.stationNameLang} ${localization.facilitiesTitle}'),
        backgroundColor: primaryColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: stationData == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundColor, Colors.white],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Interactive Station Map
                          GestureDetector(
                            onTap: () => _showFullScreenMap(context),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 4),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: 'map-${widget.stationNameEN}',
                                      child: Image.asset(
                                        _getStationImagePath(
                                            widget.stationNameEN),
                                        fit: BoxFit.cover,
                                        height: 180,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              primaryColor.withOpacity(0.6),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      left: 16,
                                      child: Text(
                                        localization.stationMapTitle,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.fullscreen,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          // Station Info Card
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: primaryColor),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Explore ${widget.stationNameLang} station facilities and nearby points of interest',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Dynamic Category Sections
                  ..._categoryIcons.keys
                      .where((category) =>
                          _getItemsByCategory(category).isNotEmpty)
                      .map((category) {
                    final items = _getItemsByCategory(category);
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return _buildSectionHeader(category);
                          }
                          if (!_sectionExpansionState[category]!) {
                            return SizedBox.shrink();
                          }
                          final itemKey = items.keys.elementAt(index - 1);
                          return _buildListItem(
                            itemKey,
                            items[itemKey],
                            category,
                          );
                        },
                        childCount: items.length + 1,
                      ),
                    );
                  }).toList(),
                  SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String category) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _sectionExpansionState[category] =
                !_sectionExpansionState[category]!;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                primaryColor.withOpacity(0.1),
                cardColor,
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _categoryIcons[category]!,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              Icon(
                _sectionExpansionState[category]!
                    ? Icons.expand_less
                    : Icons.expand_more,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String name, dynamic data, String category) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showPlaceDetails(context, name, data, category),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      if (data['description'] != null)
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            data['description'] is String
                                ? data['description']
                                : data['description'].toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreenMap(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Hero(
                tag: 'map-${widget.stationNameEN}',
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.asset(
                    _getStationImagePath(widget.stationNameEN),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void _showPlaceDetails(
      BuildContext context, String name, dynamic data, String category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Draggable handle
              Padding(
                padding: EdgeInsets.only(top: 12, bottom: 4),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _categoryIcons[category]!,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        // Image placeholder with shimmer effect
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade100,
                                Colors.grey.shade200,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.location_on,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        if (data['description'] != null) ...[
                          Text(
                            'About this place',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            data['description'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                        if (data['directions'] != null) ...[
                          Row(
                            children: [
                              Icon(Icons.directions, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  data['directions'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                        ],
                        if (data['map_hint'] != null) ...[
                          Row(
                            children: [
                              Icon(Icons.map, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  data['map_hint'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                        ],
                        if (data['lat'] != null && data['lng'] != null) ...[
                          Row(
                            children: [
                              Icon(Icons.location_pin, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Location: ${data['lat']}, ${data['lng']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                        ],
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              // Fixed bottom action buttons
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.directions),
                        label: Text('Directions'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.map),
                        label: Text('View on Map'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getStationImagePath(String stationNameEN) {
    final fileName = stationNameEN; //.toLowerCase().replaceAll(' ', '_');
    return 'assets/stations/line3/$fileName.jpg';
  }
}
