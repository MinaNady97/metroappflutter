import 'package:flutter/material.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionInfoPage extends StatelessWidget {
  // Use the same color palette as homepage and station facilities
  final Color primaryColor = Color(0xFF1A6F8F); // Deep Nile Blue
  final Color secondaryColor = Color(0xFF029692); // Teal
  final Color accentColor = Color(0xFFD4AF37); // Egyptian Gold
  final Color backgroundColor = Color(0xFFF5F5F5); // Light Sand
  final Color cardColor = Color(0xFFFFFFFF); // White
  final Color textColor = Color(0xFF333333); // Dark Gray

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(localization.subscriptionInfoTitle),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundColor, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Where to Buy Section
              _buildSectionHeader(
                context,
                icon: Icons.location_on,
                title: localization.whereToBuyTitle,
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  localization.whereToBuyDescription,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Tickets Section
              _buildExpandableCard(
                context,
                title: localization.ticketsTitle,
                icon: Icons.confirmation_number,
                bullets: [
                  localization.ticketsBullet1,
                  localization.ticketsBullet2,
                  localization.ticketsBullet3,
                ],
              ),
              SizedBox(height: 16),

              // Wallet Card Section
              _buildExpandableCard(
                context,
                title: localization.walletCardTitle,
                icon: Icons.credit_card,
                bullets: [
                  localization.walletBullet1,
                  localization.walletBullet2,
                  localization.walletBullet3,
                  localization.walletBullet4,
                  localization.walletBullet5,
                ],
              ),
              SizedBox(height: 16),

              // Seasonal Card Section
              _buildExpandableCard(
                context,
                title: localization.seasonalCardTitle,
                icon: Icons.card_membership,
                bullets: [
                  localization.seasonalBullet1,
                  "",
                  localization.requirementsTitle,
                  localization.seasonalBullet2,
                  localization.seasonalBullet3,
                  "",
                  localization.additionalRequirementsTitle,
                  localization.studentReq,
                  localization.elderlyReq,
                  localization.specialNeedsReq,
                ],
              ),

              // Fare Zones Image
              SizedBox(height: 24),
              _buildSectionHeader(
                context,
                icon: Icons.map,
                title: "Fare Zones",
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showFullScreenImage(context),
                child: Hero(
                  tag: 'fare-zones-image',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/subscriptionGuide.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.4),
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
                              "Fare Zones Guide",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Learn More Button
              SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _launchWebsite(context),
                  icon: Icon(Icons.language, color: Colors.white),
                  label: Text(
                    localization.learnMore,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context,
      {required IconData icon, required String title}) {
    return Padding(
      padding: EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<String> bullets,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primaryColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bullets.map((bullet) {
                if (bullet.isEmpty) return SizedBox(height: 12);
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: bullet.startsWith(AppLocalizations.of(context)!
                              .requirementsTitle) ||
                          bullet.startsWith(AppLocalizations.of(context)!
                              .additionalRequirementsTitle)
                      ? Text(
                          bullet,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 4, right: 8),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                bullet,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor.withOpacity(0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: Center(
            child: PhotoView(
              imageProvider: AssetImage('assets/images/subscriptionGuide.png'),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 3,
              heroAttributes: PhotoViewHeroAttributes(tag: 'fare-zones-image'),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchWebsite(BuildContext context) async {
    const url = 'https://www.mobilitycairo.com/en/tickets/choose-your-ticket';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch website'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
