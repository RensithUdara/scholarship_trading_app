import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/scholarship_controller.dart';
import '../../core/theme/app_colors.dart';

class BrowseScholarshipsScreen extends StatefulWidget {
  const BrowseScholarshipsScreen({super.key});

  @override
  State<BrowseScholarshipsScreen> createState() => _BrowseScholarshipsScreenState();
}

class _BrowseScholarshipsScreenState extends State<BrowseScholarshipsScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Scholarships'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ScholarshipController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.scholarships.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school,
                    size: 64,
                    color: AppColors.mediumGray,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No scholarships available',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.mediumGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to list a scholarship!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.scholarships.length,
            itemBuilder: (context, index) {
              final scholarship = controller.scholarships[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.teal,
                    child: Icon(
                      scholarship.isAuction ? Icons.gavel : Icons.sell,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    scholarship.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scholarship.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scholarship.formattedPrice,
                        style: const TextStyle(
                          color: AppColors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (scholarship.isAuction) ...[
                        const Icon(Icons.timer, color: AppColors.coral),
                        const Text('Auction', style: TextStyle(fontSize: 12)),
                      ] else ...[
                        const Icon(Icons.monetization_on, color: AppColors.gold),
                        const Text('Buy Now', style: TextStyle(fontSize: 12)),
                      ],
                    ],
                  ),
                  onTap: () {
                    // Navigate to scholarship details
                    controller.selectScholarship(scholarship.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
