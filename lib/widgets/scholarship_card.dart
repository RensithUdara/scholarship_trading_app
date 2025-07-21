import 'package:flutter/material.dart';
import '../models/scholarship.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/ui_constants.dart';
import '../utils/date_formatter.dart';
import '../utils/currency_formatter.dart';

class ScholarshipCard extends StatelessWidget {
  final Scholarship scholarship;
  final VoidCallback? onTap;
  final bool showSellerInfo;

  const ScholarshipCard({
    Key? key,
    required this.scholarship,
    this.onTap,
    this.showSellerInfo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: UIConstants.cardElevation,
      margin: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingMd,
        vertical: UIConstants.spacingSm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UIConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      scholarship.title,
                      style: UIConstants.headingStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: UIConstants.spacingSm),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: UIConstants.spacingSm),
              
              // Description
              Text(
                scholarship.description,
                style: UIConstants.bodyStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: UIConstants.spacingMd),
              
              // Image gallery if available
              if (scholarship.imageUrls.isNotEmpty) ...[
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: scholarship.imageUrls.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: UIConstants.spacingSm),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(UIConstants.radiusSm),
                          child: Image.network(
                            scholarship.imageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.lightGray,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: AppColors.darkGray,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: UIConstants.spacingMd),
              ],
              
              // Details row
              Row(
                children: [
                  // Price/Amount
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.spacingSm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: scholarship.isAuction ? AppColors.warning.withOpacity(0.1) : AppColors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(UIConstants.radiusSm),
                    ),
                    child: Text(
                      scholarship.isAuction 
                        ? 'Current Bid: ${CurrencyFormatter.format(scholarship.currentBid ?? scholarship.minimumBid ?? scholarship.price)}'
                        : 'Price: ${CurrencyFormatter.format(scholarship.price)}',
                      style: UIConstants.captionStyle.copyWith(
                        color: scholarship.isAuction ? AppColors.warning : AppColors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  // View count
                  if (scholarship.viewCount > 0) ...[
                    Icon(Icons.visibility, size: 16, color: AppColors.darkGray),
                    const SizedBox(width: 4),
                    Text(
                      '${scholarship.viewCount}',
                      style: UIConstants.captionStyle.copyWith(color: AppColors.darkGray),
                    ),
                    const SizedBox(width: UIConstants.spacingSm),
                  ],
                ],
              ),
              const SizedBox(height: UIConstants.spacingSm),
              
              // Category, Education Level, and State
              Wrap(
                spacing: UIConstants.spacingSm,
                runSpacing: 4,
                children: [
                  _buildInfoChip(scholarship.category, Icons.category),
                  _buildInfoChip(scholarship.educationLevel, Icons.school),
                  _buildInfoChip(scholarship.state, Icons.location_on),
                ],
              ),
              const SizedBox(height: UIConstants.spacingSm),
              
              // Application deadline
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: _getDeadlineColor(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Deadline: ${DateFormatter.formatDate(scholarship.applicationDeadline)}',
                    style: UIConstants.captionStyle.copyWith(
                      color: _getDeadlineColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  
                  // Auction countdown if applicable
                  if (scholarship.isAuction && scholarship.auctionEndTime != null) ...[
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Ends: ${DateFormatter.formatDate(scholarship.auctionEndTime!)}',
                      style: UIConstants.captionStyle.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    IconData chipIcon;
    
    switch (scholarship.status.toLowerCase()) {
      case 'approved':
        chipColor = AppColors.success;
        chipIcon = Icons.check_circle;
        break;
      case 'pending':
        chipColor = AppColors.warning;
        chipIcon = Icons.schedule;
        break;
      case 'sold':
        chipColor = AppColors.info;
        chipIcon = Icons.sell;
        break;
      default:
        chipColor = AppColors.darkGray;
        chipIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(UIConstants.radiusSm),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(chipIcon, size: 12, color: chipColor),
          const SizedBox(width: 4),
          Text(
            scholarship.status.toUpperCase(),
            style: UIConstants.captionStyle.copyWith(
              color: chipColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(UIConstants.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.darkGray),
          const SizedBox(width: 4),
          Text(
            label,
            style: UIConstants.captionStyle.copyWith(
              color: AppColors.darkGray,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDeadlineColor() {
    final now = DateTime.now();
    final daysUntilDeadline = scholarship.applicationDeadline.difference(now).inDays;
    
    if (daysUntilDeadline < 0) {
      return AppColors.error; // Past deadline
    } else if (daysUntilDeadline <= 7) {
      return AppColors.warning; // Less than a week
    } else if (daysUntilDeadline <= 30) {
      return AppColors.info; // Less than a month
    } else {
      return AppColors.success; // More than a month
    }
  }
}
