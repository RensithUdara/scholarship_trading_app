import 'package:flutter/material.dart';
import '../models/scholarship_filter.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/ui_constants.dart';

class SortBottomSheet extends StatefulWidget {
  final ScholarshipSortBy? currentSortBy;
  final SortOrder? currentSortOrder;
  final Function(ScholarshipSortBy, SortOrder) onApplySort;

  const SortBottomSheet({
    Key? key,
    this.currentSortBy,
    this.currentSortOrder,
    required this.onApplySort,
  }) : super(key: key);

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  ScholarshipSortBy _selectedSortBy = ScholarshipSortBy.newest;
  SortOrder _selectedSortOrder = SortOrder.descending;

  final List<SortOption> _sortOptions = [
    SortOption(
      sortBy: ScholarshipSortBy.createdDate,
      title: 'Newest First',
      subtitle: 'Recently posted scholarships',
      icon: Icons.new_releases,
      defaultOrder: SortOrder.descending,
    ),
    SortOption(
      sortBy: ScholarshipSortBy.createdDate,
      title: 'Oldest First',
      subtitle: 'Older scholarships first',
      icon: Icons.history,
      defaultOrder: SortOrder.ascending,
    ),
    SortOption(
      sortBy: ScholarshipSortBy.amount,
      title: 'Price',
      subtitle: 'Sort by scholarship price',
      icon: Icons.attach_money,
      defaultOrder: SortOrder.descending,
    ),
    SortOption(
      sortBy: ScholarshipSortBy.deadline,
      title: 'Application Deadline',
      subtitle: 'Sort by application deadline',
      icon: Icons.schedule,
      defaultOrder: SortOrder.ascending,
    ),
    SortOption(
      sortBy: ScholarshipSortBy.title,
      title: 'Alphabetical',
      subtitle: 'Sort by scholarship title',
      icon: Icons.sort_by_alpha,
      defaultOrder: SortOrder.ascending,
    ),
    SortOption(
      sortBy: ScholarshipSortBy.popularity,
      title: 'Most Popular',
      subtitle: 'Sort by view count',
      icon: Icons.trending_up,
      defaultOrder: SortOrder.descending,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.currentSortBy ?? ScholarshipSortBy.createdDate;
    _selectedSortOrder = widget.currentSortOrder ?? SortOrder.descending;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UIConstants.radiusLg),
          topRight: Radius.circular(UIConstants.radiusLg),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(UIConstants.spacingMd),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.lightGray),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    'Sort Scholarships',
                    style: UIConstants.headingStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Balance the close button
              ],
            ),
          ),

          // Sort options
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(UIConstants.spacingMd),
              itemCount: _sortOptions.length,
              itemBuilder: (context, index) {
                final option = _sortOptions[index];
                final isSelected = _selectedSortBy == option.sortBy;
                
                return Card(
                  elevation: isSelected ? 2 : 0,
                  color: isSelected ? AppColors.teal.withOpacity(0.05) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(UIConstants.radiusMd),
                    side: BorderSide(
                      color: isSelected ? AppColors.teal : AppColors.lightGray,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    onTap: () => _selectSort(option),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.teal.withOpacity(0.1)
                            : AppColors.lightGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(UIConstants.radiusSm),
                      ),
                      child: Icon(
                        option.icon,
                        color: isSelected ? AppColors.teal : AppColors.darkGray,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      option.title,
                      style: UIConstants.bodyStyle.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.teal : AppColors.darkGray,
                      ),
                    ),
                    subtitle: Text(
                      option.subtitle,
                      style: UIConstants.captionStyle.copyWith(
                        color: isSelected ? AppColors.teal.withOpacity(0.7) : AppColors.darkGray,
                      ),
                    ),
                    trailing: isSelected
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Sort order toggle for applicable sorts
                              if (_canToggleSortOrder(option.sortBy)) ...[
                                ToggleButtons(
                                  constraints: const BoxConstraints(
                                    minHeight: 32,
                                    minWidth: 40,
                                  ),
                                  borderRadius: BorderRadius.circular(UIConstants.radiusSm),
                                  isSelected: [
                                    _selectedSortOrder == SortOrder.ascending,
                                    _selectedSortOrder == SortOrder.descending,
                                  ],
                                  onPressed: (index) {
                                    setState(() {
                                      _selectedSortOrder = index == 0 
                                          ? SortOrder.ascending 
                                          : SortOrder.descending;
                                    });
                                  },
                                  children: const [
                                    Icon(Icons.arrow_upward, size: 16),
                                    Icon(Icons.arrow_downward, size: 16),
                                  ],
                                ),
                                const SizedBox(width: UIConstants.spacingSm),
                              ],
                              Icon(
                                Icons.check_circle,
                                color: AppColors.teal,
                                size: 20,
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
          ),

          // Apply button
          Container(
            padding: const EdgeInsets.all(UIConstants.spacingMd),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.lightGray),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applySort,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  padding: const EdgeInsets.symmetric(vertical: UIConstants.spacingMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(UIConstants.radiusMd),
                  ),
                ),
                child: Text(
                  'Apply Sort',
                  style: UIConstants.buttonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectSort(SortOption option) {
    setState(() {
      _selectedSortBy = option.sortBy;
      // Set default sort order for the selected option
      if (!_canToggleSortOrder(option.sortBy)) {
        _selectedSortOrder = option.defaultOrder;
      }
    });
  }

  bool _canToggleSortOrder(ScholarshipSortBy sortBy) {
    // These sort types can be toggled between ascending and descending
    return [
      ScholarshipSortBy.amount,
      ScholarshipSortBy.deadline,
      ScholarshipSortBy.title,
      ScholarshipSortBy.popularity,
    ].contains(sortBy);
  }

  void _applySort() {
    widget.onApplySort(_selectedSortBy, _selectedSortOrder);
    Navigator.pop(context);
  }
}

class SortOption {
  final ScholarshipSortBy sortBy;
  final String title;
  final String subtitle;
  final IconData icon;
  final SortOrder defaultOrder;

  SortOption({
    required this.sortBy,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.defaultOrder,
  });
}
