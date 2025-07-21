import 'package:flutter/material.dart';
import '../models/scholarship_filter.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/ui_constants.dart';
import '../core/constants/app_constants.dart';

class FilterBottomSheet extends StatefulWidget {
  final ScholarshipFilter? currentFilter;
  final Function(ScholarshipFilter) onApplyFilter;

  const FilterBottomSheet({
    Key? key,
    this.currentFilter,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late ScholarshipFilter _filter;
  late RangeValues _priceRange;
  
  // Filter options
  final List<String> categories = [
    'Academic Merit',
    'Need-Based',
    'Athletic',
    'Creative Arts',
    'STEM',
    'Community Service',
    'Minority Groups',
    'International Students',
  ];

  final List<String> educationLevels = [
    'High School',
    'Undergraduate',
    'Graduate',
    'Postgraduate',
    'Doctoral',
  ];

  final List<String> states = [
    'New South Wales',
    'Victoria',
    'Queensland',
    'Western Australia',
    'South Australia',
    'Tasmania',
    'Australian Capital Territory',
    'Northern Territory',
  ];

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter ?? ScholarshipFilter();
    _priceRange = RangeValues(
      _filter.minAmount?.toDouble() ?? 0.0,
      _filter.maxAmount?.toDouble() ?? 50000.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                    'Filter Scholarships',
                    style: UIConstants.headingStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category filter
                  _buildSectionHeader('Category'),
                  _buildCategoryFilter(),
                  const SizedBox(height: UIConstants.spacingLg),
                  
                  // Education Level filter
                  _buildSectionHeader('Education Level'),
                  _buildEducationLevelFilter(),
                  const SizedBox(height: UIConstants.spacingLg),
                  
                  // State filter
                  _buildSectionHeader('State'),
                  _buildStateFilter(),
                  const SizedBox(height: UIConstants.spacingLg),
                  
                  // Price range
                  _buildSectionHeader('Price Range'),
                  _buildPriceRangeFilter(),
                  const SizedBox(height: UIConstants.spacingLg),
                  
                  // Deadline options
                  _buildSectionHeader('Deadline'),
                  _buildDeadlineFilter(),
                  const SizedBox(height: UIConstants.spacingLg),
                  
                  // Auction options
                  _buildSectionHeader('Auction Type'),
                  _buildAuctionFilter(),
                  const SizedBox(height: UIConstants.spacingXl),
                ],
              ),
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
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  padding: const EdgeInsets.symmetric(vertical: UIConstants.spacingMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(UIConstants.radiusMd),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: UIConstants.buttonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.spacingSm),
      child: Text(
        title,
        style: UIConstants.headingStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      children: categories.map((category) {
        return CheckboxListTile(
          title: Text(category, style: UIConstants.bodyStyle),
          value: _filter.category == category,
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(
                category: value == true ? category : null,
              );
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        );
      }).toList(),
    );
  }

  Widget _buildEducationLevelFilter() {
    return Column(
      children: educationLevels.map((level) {
        return RadioListTile<String>(
          title: Text(level, style: UIConstants.bodyStyle),
          value: level,
          groupValue: _filter.educationLevel,
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(educationLevel: value);
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        );
      }).toList(),
    );
  }

  Widget _buildStateFilter() {
    return DropdownButtonFormField<String>(
      value: _filter.state,
      decoration: InputDecoration(
        hintText: 'Select a state',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusMd),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UIConstants.spacingMd,
          vertical: UIConstants.spacingSm,
        ),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All states'),
        ),
        ...states.map((state) {
          return DropdownMenuItem<String>(
            value: state,
            child: Text(state),
          );
        }),
      ],
      onChanged: (value) {
        setState(() {
          _filter = _filter.copyWith(state: value);
        });
      },
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 50000,
          divisions: 100,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _priceRange.start.round().toString(),
                decoration: const InputDecoration(
                  labelText: 'Min Price',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final price = double.tryParse(value);
                  if (price != null && price >= 0 && price <= _priceRange.end) {
                    setState(() {
                      _priceRange = RangeValues(price, _priceRange.end);
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: UIConstants.spacingMd),
            Expanded(
              child: TextFormField(
                initialValue: _priceRange.end.round().toString(),
                decoration: const InputDecoration(
                  labelText: 'Max Price',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final price = double.tryParse(value);
                  if (price != null && price >= _priceRange.start && price <= 50000) {
                    setState(() {
                      _priceRange = RangeValues(_priceRange.start, price);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeadlineFilter() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Deadline within 7 days'),
          value: _filter.hasDeadlineSoon ?? false,
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(hasDeadlineSoon: value);
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        // Custom deadline range could be added here
      ],
    );
  }

  Widget _buildAuctionFilter() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('All scholarships'),
          value: 'all',
          groupValue: _getAuctionFilterValue(),
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(
                includeAuctions: true,
                auctionsOnly: false,
              );
            });
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('Auctions only'),
          value: 'auctions_only',
          groupValue: _getAuctionFilterValue(),
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(
                includeAuctions: true,
                auctionsOnly: true,
              );
            });
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('Fixed price only'),
          value: 'fixed_only',
          groupValue: _getAuctionFilterValue(),
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(
                includeAuctions: false,
                auctionsOnly: false,
              );
            });
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
      ],
    );
  }

  String _getAuctionFilterValue() {
    if (_filter.auctionsOnly == true) return 'auctions_only';
    if (_filter.includeAuctions == false) return 'fixed_only';
    return 'all';
  }

  void _resetFilters() {
    setState(() {
      _filter = ScholarshipFilter();
      _priceRange = const RangeValues(0.0, 50000.0);
    });
  }

  void _applyFilters() {
    final updatedFilter = _filter.copyWith(
      minAmount: _priceRange.start.round().toDouble(),
      maxAmount: _priceRange.end.round().toDouble(),
    );
    widget.onApplyFilter(updatedFilter);
    Navigator.pop(context);
  }
}
