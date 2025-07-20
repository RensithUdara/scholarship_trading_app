import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String reporterId;
  final String reporterName;
  final String reportType;
  final String reason;
  final String description;
  final String? scholarshipId;
  final String? reportedUserId;
  final String? transactionId;
  final String status;
  final String? adminId;
  final String? adminNotes;
  final String? resolution;
  final String? actionTaken;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;

  const Report({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.reportType,
    required this.reason,
    required this.description,
    this.scholarshipId,
    this.reportedUserId,
    this.transactionId,
    required this.status,
    this.adminId,
    this.adminNotes,
    this.resolution,
    this.actionTaken,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
  });

  // Create Report from Firestore document
  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] ?? '',
      reporterId: map['reporterId'] ?? '',
      reporterName: map['reporterName'] ?? '',
      reportType: map['reportType'] ?? '',
      reason: map['reason'] ?? '',
      description: map['description'] ?? '',
      scholarshipId: map['scholarshipId'],
      reportedUserId: map['reportedUserId'],
      transactionId: map['transactionId'],
      status: map['status'] ?? 'open',
      adminId: map['adminId'],
      adminNotes: map['adminNotes'],
      resolution: map['resolution'],
      actionTaken: map['actionTaken'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      resolvedAt: (map['resolvedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert Report to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'reporterId': reporterId,
      'reporterName': reporterName,
      'reportType': reportType,
      'reason': reason,
      'description': description,
      'scholarshipId': scholarshipId,
      'reportedUserId': reportedUserId,
      'transactionId': transactionId,
      'status': status,
      'adminId': adminId,
      'adminNotes': adminNotes,
      'resolution': resolution,
      'actionTaken': actionTaken,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
    };
  }

  // Create a copy with updated fields
  Report copyWith({
    String? id,
    String? reporterId,
    String? reporterName,
    String? reportType,
    String? reason,
    String? description,
    String? scholarshipId,
    String? reportedUserId,
    String? transactionId,
    String? status,
    String? adminId,
    String? adminNotes,
    String? resolution,
    String? actionTaken,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  }) {
    return Report(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      reportType: reportType ?? this.reportType,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      reportedUserId: reportedUserId ?? this.reportedUserId,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      adminId: adminId ?? this.adminId,
      adminNotes: adminNotes ?? this.adminNotes,
      resolution: resolution ?? this.resolution,
      actionTaken: actionTaken ?? this.actionTaken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  @override
  String toString() {
    return 'Report(id: $id, reportType: $reportType, reason: $reason, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Report &&
        other.id == id &&
        other.reporterId == reporterId &&
        other.reporterName == reporterName &&
        other.reportType == reportType &&
        other.reason == reason &&
        other.description == description &&
        other.scholarshipId == scholarshipId &&
        other.reportedUserId == reportedUserId &&
        other.transactionId == transactionId &&
        other.status == status &&
        other.adminId == adminId &&
        other.adminNotes == adminNotes &&
        other.resolution == resolution &&
        other.actionTaken == actionTaken &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.resolvedAt == resolvedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        reporterId.hashCode ^
        reporterName.hashCode ^
        reportType.hashCode ^
        reason.hashCode ^
        description.hashCode ^
        (scholarshipId?.hashCode ?? 0) ^
        (reportedUserId?.hashCode ?? 0) ^
        (transactionId?.hashCode ?? 0) ^
        status.hashCode ^
        (adminId?.hashCode ?? 0) ^
        (adminNotes?.hashCode ?? 0) ^
        (resolution?.hashCode ?? 0) ^
        (actionTaken?.hashCode ?? 0) ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        (resolvedAt?.hashCode ?? 0);
  }

  // Get status color for UI
  String getStatusColor() {
    switch (status) {
      case 'open':
        return '#FF6B6B'; // Red
      case 'investigating':
        return '#FFD166'; // Yellow
      case 'resolved':
        return '#00A896'; // Teal
      case 'closed':
        return '#6C757D'; // Gray
      default:
        return '#6C757D';
    }
  }

  // Get report type icon
  String getTypeIcon() {
    switch (reportType.toLowerCase()) {
      case 'spam':
        return '🚫';
      case 'inappropriate content':
        return '⚠️';
      case 'fraud':
        return '🚨';
      case 'harassment':
        return '😠';
      case 'false information':
        return '❌';
      case 'payment issue':
        return '💳';
      case 'other':
        return '📝';
      default:
        return '📝';
    }
  }

  // Check if report is recent (within 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  // Check if report is urgent (multiple reports on same target)
  bool get isUrgent => false; // This would need to be calculated from the controller

  // Get formatted time ago
  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Get target name for display
  String getTargetDisplay() {
    if (scholarshipId != null) {
      return 'Scholarship';
    } else if (reportedUserId != null) {
      return 'User';
    } else if (transactionId != null) {
      return 'Transaction';
    } else {
      return 'General';
    }
  }
}

// Report types enum for validation
enum ReportType {
  spam('Spam'),
  inappropriateContent('Inappropriate Content'),
  fraud('Fraud'),
  harassment('Harassment'),
  falseInformation('False Information'),
  paymentIssue('Payment Issue'),
  other('Other');

  const ReportType(this.displayName);
  final String displayName;

  static List<String> get allTypes => ReportType.values.map((e) => e.displayName).toList();
}

// Report reasons enum for predefined options
enum ReportReason {
  // Spam reasons
  unwantedAdvertising('Unwanted advertising'),
  repetitiveContent('Repetitive content'),
  
  // Inappropriate content reasons
  offensiveLanguage('Offensive language'),
  adultContent('Adult content'),
  violence('Violence or threats'),
  
  // Fraud reasons
  scam('Scam or fraudulent activity'),
  fakeScholarship('Fake scholarship'),
  identityTheft('Identity theft'),
  
  // Harassment reasons
  bullying('Bullying or harassment'),
  personalAttacks('Personal attacks'),
  discrimination('Discrimination'),
  
  // False information reasons
  misleadingDetails('Misleading scholarship details'),
  fakeReviews('Fake reviews'),
  incorrectPricing('Incorrect pricing'),
  
  // Payment issues
  paymentNotReceived('Payment not received'),
  unauthorizedCharge('Unauthorized charge'),
  refundIssue('Refund issue'),
  
  // Other
  privacyViolation('Privacy violation'),
  copyrightInfringement('Copyright infringement'),
  technicalIssue('Technical issue'),
  other('Other (please specify)');

  const ReportReason(this.displayName);
  final String displayName;

  static List<String> get allReasons => ReportReason.values.map((e) => e.displayName).toList();
  
  static List<String> getReasonsByType(String reportType) {
    switch (reportType.toLowerCase()) {
      case 'spam':
        return [
          ReportReason.unwantedAdvertising.displayName,
          ReportReason.repetitiveContent.displayName,
        ];
      case 'inappropriate content':
        return [
          ReportReason.offensiveLanguage.displayName,
          ReportReason.adultContent.displayName,
          ReportReason.violence.displayName,
        ];
      case 'fraud':
        return [
          ReportReason.scam.displayName,
          ReportReason.fakeScholarship.displayName,
          ReportReason.identityTheft.displayName,
        ];
      case 'harassment':
        return [
          ReportReason.bullying.displayName,
          ReportReason.personalAttacks.displayName,
          ReportReason.discrimination.displayName,
        ];
      case 'false information':
        return [
          ReportReason.misleadingDetails.displayName,
          ReportReason.fakeReviews.displayName,
          ReportReason.incorrectPricing.displayName,
        ];
      case 'payment issue':
        return [
          ReportReason.paymentNotReceived.displayName,
          ReportReason.unauthorizedCharge.displayName,
          ReportReason.refundIssue.displayName,
        ];
      default:
        return [
          ReportReason.privacyViolation.displayName,
          ReportReason.copyrightInfringement.displayName,
          ReportReason.technicalIssue.displayName,
          ReportReason.other.displayName,
        ];
    }
  }
}
