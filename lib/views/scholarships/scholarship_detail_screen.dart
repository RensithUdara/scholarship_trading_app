import 'package:flutter/material.dart';
import '../../models/scholarship.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';

class ScholarshipDetailScreen extends StatelessWidget {
  final String scholarshipId;
  final Scholarship? scholarship;

  const ScholarshipDetailScreen({
    Key? key,
    required this.scholarshipId,
    this.scholarship,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Details'),
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 64,
              color: AppColors.mediumGray,
            ),
            SizedBox(height: UIConstants.paddingMD),
            Text(
              'Scholarship Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: UIConstants.paddingSM),
            Text(
              'This screen will be implemented soon.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
