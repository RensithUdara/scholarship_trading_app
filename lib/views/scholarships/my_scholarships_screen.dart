import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MyScholarshipsScreen extends StatelessWidget {
  const MyScholarshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Scholarships'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory,
              size: 64,
              color: AppColors.mediumGray,
            ),
            SizedBox(height: 16),
            Text(
              'My Scholarships',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Manage your scholarship listings here',
              style: TextStyle(
                color: AppColors.mediumGray,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create scholarship screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
