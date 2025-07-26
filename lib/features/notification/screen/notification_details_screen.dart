import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final String notificationType;
  final String notificationDetail;
  final String createdAt;

  const NotificationDetailsScreen({
    super.key,
    required this.notificationType,
    required this.notificationDetail,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set background to transparent
        elevation: 0, // Remove default shadow
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification Details',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                Colors.blueGrey[900]!,
              ], // Using a darker shade for gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Details Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ), // Adjusted overall padding
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(
                    20,
                  ), // Increased border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.08,
                      ), // Adjusted shadow opacity
                      blurRadius: 30, // Increased blur radius
                      offset: Offset(0, 15), // Increased vertical offset
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(
                  24.0,
                ), // Increased internal padding
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        createdAt,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 24), // Increased spacing
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.notifications,
                            color: AppColors.primary,
                            size: 24,
                          ), // Icon size
                          SizedBox(width: 16), // Spacing between icon and text
                          Expanded(
                            child: Text(
                              notificationType,
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20), // Adjusted spacing
                      Text(
                        notificationDetail,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textTitle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
