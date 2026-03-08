import 'package:flutter/material.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

class TouristGuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.touristGuideTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(localization.popularDestinations),
            SizedBox(height: 16),
            _buildAttractionCard(
              context: context,
              name: localization.pyramidsTitle,
              image: 'assets/images/pyramids.jpg',
              description: localization.pyramidsDescription,
              station: 'Giza Station',
            ),
            SizedBox(height: 16),
            _buildAttractionCard(
              context: context,
              name: localization.egyptianMuseumTitle,
              image: 'assets/images/museum.jpg',
              description: localization.egyptianMuseumDescription,
              station: 'Sadat Station',
            ),
            SizedBox(height: 16),
            _buildAttractionCard(
              context: context,
              name: localization.khanElKhaliliTitle,
              image: 'assets/images/khan.jpg',
              description: localization.khanElKhaliliDescription,
              station: 'Ataba Station',
            ),
            SizedBox(height: 24),
            _buildSectionHeader(localization.essentialPhrases),
            SizedBox(height: 16),
            _buildPhraseCard(
              context: context,
              phrase: localization.phrase1,
              translation: localization.phrase1Translation,
            ),
            SizedBox(height: 8),
            _buildPhraseCard(
              context: context,
              phrase: localization.phrase2,
              translation: localization.phrase2Translation,
            ),
            SizedBox(height: 8),
            _buildPhraseCard(
              context: context,
              phrase: localization.phrase3,
              translation: localization.phrase3Translation,
            ),
            SizedBox(height: 24),
            _buildSectionHeader(localization.tipsTitle),
            SizedBox(height: 16),
            _buildTipCard(
              context: context,
              icon: Icons.schedule,
              title: localization.peakHoursTitle,
              description: localization.peakHoursDescription,
            ),
            SizedBox(height: 16),
            _buildTipCard(
              context: context,
              icon: Icons.security,
              title: localization.safetyTitle,
              description: localization.safetyDescription,
            ),
            SizedBox(height: 16),
            _buildTipCard(
              context: context,
              icon: Icons.attach_money,
              title: localization.ticketsTitle,
              description: localization.ticketsDescription,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAttractionCard({
    required BuildContext context,
    required String name,
    required String image,
    required String description,
    required String station,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(description),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.train, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text(
                      '${AppLocalizations.of(context)!.nearestStationLabel}: $station',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildPhraseCard({
    required BuildContext context,
    required String phrase,
    required String translation,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phrase,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              translation,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            SizedBox(width: 16),
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
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}