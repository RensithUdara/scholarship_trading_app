import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/scholarship_controller.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/routing/app_navigator.dart';
import '../../core/theme/app_colors.dart';
import '../../models/scholarship_filter.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/scholarship_card.dart';
import '../../widgets/sort_bottom_sheet.dart';

class ScholarshipSearchScreen extends StatefulWidget {
  final String? initialQuery;
  final ScholarshipFilter? initialFilter;

  const ScholarshipSearchScreen({
    super.key,
    this.initialQuery,
    this.initialFilter,
  });

  @override
  State<ScholarshipSearchScreen> createState() =>
      _ScholarshipSearchScreenState();
}

class _ScholarshipSearchScreenState extends State<ScholarshipSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  ScholarshipFilter _currentFilter = const ScholarshipFilter();
  String _searchQuery = '';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
    _searchQuery = widget.initialQuery ?? '';
    _currentFilter = widget.initialFilter ?? const ScholarshipFilter();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _performSearch() {
    final controller =
        Provider.of<ScholarshipController>(context, listen: false);
    controller.searchScholarships(
      query: _searchQuery,
      filter: _currentFilter,
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });

    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchQuery == value && value.isNotEmpty) {
        _performSearch();
      }
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet<ScholarshipFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilter: _currentFilter,
        onApplyFilter: (filter) {
          setState(() {
            _currentFilter = filter;
          });
          _performSearch();
        },
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet<ScholarshipFilter>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheet(
        currentSortBy: _parseSortBy(_currentFilter.sortBy),
        currentSortOrder: _parseSortOrder(_currentFilter.sortOrder),
        onApplySort: (sortBy, sortOrder) {
          setState(() {
            _currentFilter = _currentFilter.copyWith(
              sortBy: _sortByToString(sortBy),
              sortOrder: _sortOrderToString(sortOrder),
            );
          });
          _performSearch();
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _currentFilter = const ScholarshipFilter();
      _searchQuery = '';
      _searchController.clear();
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchHeader(),
          _buildFilterChips(),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Search Scholarships',
        style: UIConstants.headingSmall.copyWith(
          color: AppColors.darkGray,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isGridView ? Icons.list : Icons.grid_view,
            color: AppColors.teal,
          ),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
        const SizedBox(width: UIConstants.paddingSM),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingMD),
      child: Column(
        children: [
          // Search field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(UIConstants.radiusLG),
              boxShadow: UIConstants.shadowLight,
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search scholarships...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.mediumGray,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.mediumGray,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.paddingMD,
                  vertical: UIConstants.paddingSM,
                ),
              ),
            ),
          ),

          const SizedBox(height: UIConstants.paddingMD),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showFilterSheet,
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.paddingMD,
                      vertical: UIConstants.paddingSM,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: UIConstants.paddingSM),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showSortSheet,
                  icon: const Icon(Icons.sort),
                  label: const Text('Sort'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.paddingMD,
                      vertical: UIConstants.paddingSM,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    if (!_currentFilter.hasFilters && _searchQuery.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.paddingMD),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (_searchQuery.isNotEmpty)
                  _buildFilterChip(
                    'Search: $_searchQuery',
                    onRemove: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
                if (_currentFilter.category != null)
                  _buildFilterChip(
                    'Category: ${_currentFilter.category}',
                    onRemove: () {
                      setState(() {
                        _currentFilter =
                            _currentFilter.copyWith(category: null);
                      });
                      _performSearch();
                    },
                  ),
                if (_currentFilter.minAmount != null ||
                    _currentFilter.maxAmount != null)
                  _buildFilterChip(
                    'Amount: \$${_currentFilter.minAmount ?? 0} - \$${_currentFilter.maxAmount ?? '∞'}',
                    onRemove: () {
                      setState(() {
                        _currentFilter = _currentFilter.copyWith(
                          minAmount: null,
                          maxAmount: null,
                        );
                      });
                      _performSearch();
                    },
                  ),
                if (_currentFilter.location != null)
                  _buildFilterChip(
                    'Location: ${_currentFilter.location}',
                    onRemove: () {
                      setState(() {
                        _currentFilter =
                            _currentFilter.copyWith(location: null);
                      });
                      _performSearch();
                    },
                  ),
              ],
            ),
          ),
          if (_currentFilter.hasFilters || _searchQuery.isNotEmpty)
            TextButton(
              onPressed: _clearFilters,
              child: const Text('Clear All'),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {VoidCallback? onRemove}) {
    return Container(
      margin: const EdgeInsets.only(right: UIConstants.paddingSM),
      child: Chip(
        label: Text(
          label,
          style: UIConstants.bodySmall,
        ),
        onDeleted: onRemove,
        deleteIcon: const Icon(
          Icons.close,
          size: UIConstants.iconSM,
        ),
        backgroundColor: AppColors.teal.withOpacity(0.1),
        labelStyle: const TextStyle(color: AppColors.teal),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<ScholarshipController>(
      builder: (context, controller, child) {
        if (controller.isLoading && controller.scholarships.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.scholarships.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            _performSearch();
          },
          child: _isGridView
              ? _buildGridView(controller)
              : _buildListView(controller),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.mediumGray.withOpacity(0.5),
            ),
            const SizedBox(height: UIConstants.paddingMD),
            Text(
              'No scholarships found',
              style: UIConstants.headingSmall.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
            const SizedBox(height: UIConstants.paddingSM),
            Text(
              'Try adjusting your search criteria or filters',
              style: UIConstants.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UIConstants.paddingLG),
            OutlinedButton(
              onPressed: _clearFilters,
              child: const Text('Clear Filters'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.paddingMD,
                  vertical: UIConstants.paddingSM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(ScholarshipController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(UIConstants.paddingMD),
      itemCount: controller.scholarships.length,
      itemBuilder: (context, index) {
        final scholarship = controller.scholarships[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: UIConstants.paddingMD),
          child: ScholarshipCard(
            scholarship: scholarship,
            onTap: () {
              AppNavigator.pushToScholarshipDetail(context, scholarship.id);
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView(ScholarshipController controller) {
    return GridView.builder(
      padding: const EdgeInsets.all(UIConstants.paddingMD),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: UIConstants.paddingMD,
        mainAxisSpacing: UIConstants.paddingMD,
      ),
      itemCount: controller.scholarships.length,
      itemBuilder: (context, index) {
        final scholarship = controller.scholarships[index];
        return ScholarshipCard(
          scholarship: scholarship,
          onTap: () {
            AppNavigator.pushToScholarshipDetail(context, scholarship.id);
          },
        );
      },
    );
  }

  // Helper methods for sort enum conversions
  ScholarshipSortBy? _parseSortBy(String? sortBy) {
    if (sortBy == null) return null;
    switch (sortBy) {
      case 'amount':
      case 'price':
        return ScholarshipSortBy.amount;
      case 'deadline':
      case 'applicationDeadline':
        return ScholarshipSortBy.deadline;
      case 'title':
        return ScholarshipSortBy.title;
      case 'viewCount':
        return ScholarshipSortBy.popularity;
      case 'category':
        return ScholarshipSortBy.category;
      case 'createdAt':
      default:
        return ScholarshipSortBy.createdDate;
    }
  }

  SortOrder? _parseSortOrder(String? sortOrder) {
    if (sortOrder == null) return null;
    return sortOrder == 'desc' ? SortOrder.descending : SortOrder.ascending;
  }

  String _sortByToString(ScholarshipSortBy sortBy) {
    switch (sortBy) {
      case ScholarshipSortBy.newest:
        return 'createdAt';
      case ScholarshipSortBy.amount:
        return 'amount';
      case ScholarshipSortBy.deadline:
        return 'deadline';
      case ScholarshipSortBy.title:
        return 'title';
      case ScholarshipSortBy.popularity:
        return 'viewCount';
      case ScholarshipSortBy.category:
        return 'category';
      case ScholarshipSortBy.createdDate:
        return 'createdAt';
    }
  }

  String _sortOrderToString(SortOrder sortOrder) {
    return sortOrder == SortOrder.descending ? 'desc' : 'asc';
  }
}
