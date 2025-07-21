class ScholarshipFilter {
  final String? category;
  final double? minAmount;
  final double? maxAmount;
  final String? location;
  final String? state; // Added for location filtering
  final String? educationLevel;
  final String? fieldOfStudy;
  final bool? hasDeadlineSoon;
  final DateTime? deadlineAfter;
  final DateTime? deadlineBefore;
  final List<String>? keywords;
  final String? sortBy;
  final String? sortOrder;
  final bool? includeAuctions; // Added for auction filtering
  final bool? auctionsOnly;   // Added for auction filtering

  const ScholarshipFilter({
    this.category,
    this.minAmount,
    this.maxAmount,
    this.location,
    this.state,
    this.educationLevel,
    this.fieldOfStudy,
    this.hasDeadlineSoon,
    this.deadlineAfter,
    this.deadlineBefore,
    this.keywords,
    this.sortBy,
    this.sortOrder,
    this.includeAuctions,
    this.auctionsOnly,
  });

  ScholarshipFilter copyWith({
    String? category,
    double? minAmount,
    double? maxAmount,
    String? location,
    String? state,
    String? educationLevel,
    String? fieldOfStudy,
    bool? hasDeadlineSoon,
    DateTime? deadlineAfter,
    DateTime? deadlineBefore,
    List<String>? keywords,
    String? sortBy,
    String? sortOrder,
    bool? includeAuctions,
    bool? auctionsOnly,
  }) {
    return ScholarshipFilter(
      category: category ?? this.category,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      location: location ?? this.location,
      state: state ?? this.state,
      educationLevel: educationLevel ?? this.educationLevel,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      hasDeadlineSoon: hasDeadlineSoon ?? this.hasDeadlineSoon,
      deadlineAfter: deadlineAfter ?? this.deadlineAfter,
      deadlineBefore: deadlineBefore ?? this.deadlineBefore,
      keywords: keywords ?? this.keywords,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      includeAuctions: includeAuctions ?? this.includeAuctions,
      auctionsOnly: auctionsOnly ?? this.auctionsOnly,
    );
  }

  bool get hasFilters {
    return category != null ||
        minAmount != null ||
        maxAmount != null ||
        location != null ||
        educationLevel != null ||
        fieldOfStudy != null ||
        hasDeadlineSoon != null ||
        deadlineAfter != null ||
        deadlineBefore != null ||
        (keywords != null && keywords!.isNotEmpty);
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'location': location,
      'educationLevel': educationLevel,
      'fieldOfStudy': fieldOfStudy,
      'hasDeadlineSoon': hasDeadlineSoon,
      'deadlineAfter': deadlineAfter?.toIso8601String(),
      'deadlineBefore': deadlineBefore?.toIso8601String(),
      'keywords': keywords,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
  }

  factory ScholarshipFilter.fromMap(Map<String, dynamic> map) {
    return ScholarshipFilter(
      category: map['category'],
      minAmount: map['minAmount']?.toDouble(),
      maxAmount: map['maxAmount']?.toDouble(),
      location: map['location'],
      educationLevel: map['educationLevel'],
      fieldOfStudy: map['fieldOfStudy'],
      hasDeadlineSoon: map['hasDeadlineSoon'],
      deadlineAfter: map['deadlineAfter'] != null 
          ? DateTime.parse(map['deadlineAfter']) 
          : null,
      deadlineBefore: map['deadlineBefore'] != null 
          ? DateTime.parse(map['deadlineBefore']) 
          : null,
      keywords: map['keywords']?.cast<String>(),
      sortBy: map['sortBy'],
      sortOrder: map['sortOrder'],
    );
  }
}

enum ScholarshipSortBy {
  newest('createdAt', 'Newest First'), // Added newest as alias
  createdDate('createdAt', 'Date Created'),
  amount('amount', 'Amount'),
  deadline('deadline', 'Deadline'),
  title('title', 'Title'),
  category('category', 'Category'),
  popularity('viewCount', 'Popularity');

  const ScholarshipSortBy(this.field, this.displayName);
  final String field;
  final String displayName;
}

enum SortOrder {
  ascending('asc', 'Ascending'),
  descending('desc', 'Descending');

  const SortOrder(this.value, this.displayName);
  final String value;
  final String displayName;
}
