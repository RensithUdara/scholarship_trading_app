import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report.dart';
import '../services/firebase_service.dart';
import '../services/notification_service.dart';
import '../core/constants/app_constants.dart';

class ReportController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final NotificationService _notificationService = NotificationService();

  List<Report> _reports = [];
  bool _isLoading = false;
  String? _error;
  Report? _selectedReport;

  // Getters
  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Report? get selectedReport => _selectedReport;
  List<Report> get pendingReports => _reports.where((r) => r.status == AppConstants.reportOpen).toList();
  List<Report> get investigatingReports => _reports.where((r) => r.status == AppConstants.reportInvestigating).toList();
  List<Report> get resolvedReports => _reports.where((r) => r.status == AppConstants.reportResolved).toList();

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Submit a new report
  Future<bool> submitReport({
    required String reporterId,
    required String reporterName,
    required String reportType,
    required String reason,
    required String description,
    String? scholarshipId,
    String? reportedUserId,
    String? transactionId,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      // Create report object
      final report = Report(
        id: '', // Will be set by Firestore
        reporterId: reporterId,
        reporterName: reporterName,
        reportType: reportType,
        reason: reason,
        description: description,
        scholarshipId: scholarshipId,
        reportedUserId: reportedUserId,
        transactionId: transactionId,
        status: AppConstants.reportOpen,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add to Firestore
      final docRef = await _firebaseService.firestore
          .collection(AppConstants.reportsCollection)
          .add(report.toMap());

      // Update report with generated ID
      final updatedReport = report.copyWith(id: docRef.id);
      
      // Update local list
      _reports.insert(0, updatedReport);

      // Send notification to admins
      await _notificationService.notifyNewReport(
        scholarshipTitle: await _getScholarshipTitle(scholarshipId),
        reporterName: reporterName,
        reportId: docRef.id,
      );

      _setLoading(false);
      return true;

    } catch (e) {
      _setError('Failed to submit report: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Load all reports (admin only)
  Future<void> loadAllReports() async {
    try {
      _setLoading(true);
      _setError(null);

      final snapshot = await _firebaseService.firestore
          .collection(AppConstants.reportsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      _reports = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Report.fromMap(data);
      }).toList();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load reports: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Load reports by user (for users to see their own reports)
  Future<void> loadUserReports(String userId) async {
    try {
      _setLoading(true);
      _setError(null);

      final snapshot = await _firebaseService.firestore
          .collection(AppConstants.reportsCollection)
          .where('reporterId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _reports = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Report.fromMap(data);
      }).toList();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load user reports: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Listen to reports stream (admin real-time updates)
  void listenToReports() {
    _firebaseService.firestore
        .collection(AppConstants.reportsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _reports = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Report.fromMap(data);
        }).toList();
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to listen to reports: ${error.toString()}');
      },
    );
  }

  // Update report status (admin only)
  Future<bool> updateReportStatus({
    required String reportId,
    required String newStatus,
    String? adminNotes,
    String? adminId,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final updateData = <String, dynamic>{
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (adminNotes != null) {
        updateData['adminNotes'] = adminNotes;
      }
      
      if (adminId != null) {
        updateData['adminId'] = adminId;
      }

      await _firebaseService.firestore
          .collection(AppConstants.reportsCollection)
          .doc(reportId)
          .update(updateData);

      // Update local list
      final reportIndex = _reports.indexWhere((r) => r.id == reportId);
      if (reportIndex != -1) {
        _reports[reportIndex] = _reports[reportIndex].copyWith(
          status: newStatus,
          adminNotes: adminNotes,
          adminId: adminId,
          updatedAt: DateTime.now(),
        );
      }

      _setLoading(false);
      return true;

    } catch (e) {
      _setError('Failed to update report status: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Start investigation (admin only)
  Future<bool> startInvestigation({
    required String reportId,
    required String adminId,
    String? investigationNotes,
  }) async {
    return await updateReportStatus(
      reportId: reportId,
      newStatus: AppConstants.reportInvestigating,
      adminNotes: investigationNotes ?? 'Investigation started',
      adminId: adminId,
    );
  }

  // Resolve report (admin only)
  Future<bool> resolveReport({
    required String reportId,
    required String adminId,
    required String resolution,
    String? actionTaken,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      await _firebaseService.firestore
          .collection(AppConstants.reportsCollection)
          .doc(reportId)
          .update({
        'status': AppConstants.reportResolved,
        'adminId': adminId,
        'resolution': resolution,
        'actionTaken': actionTaken,
        'resolvedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local list
      final reportIndex = _reports.indexWhere((r) => r.id == reportId);
      if (reportIndex != -1) {
        _reports[reportIndex] = _reports[reportIndex].copyWith(
          status: AppConstants.reportResolved,
          adminId: adminId,
          resolution: resolution,
          actionTaken: actionTaken,
          updatedAt: DateTime.now(),
        );
      }

      _setLoading(false);
      return true;

    } catch (e) {
      _setError('Failed to resolve report: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Close report (admin only)
  Future<bool> closeReport({
    required String reportId,
    required String adminId,
    String? closureNotes,
  }) async {
    return await updateReportStatus(
      reportId: reportId,
      newStatus: AppConstants.reportClosed,
      adminNotes: closureNotes ?? 'Report closed',
      adminId: adminId,
    );
  }

  // Get reports by scholarship
  Future<List<Report>> getReportsByScholarship(String scholarshipId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(AppConstants.reportsCollection)
          .where('scholarshipId', isEqualTo: scholarshipId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Report.fromMap(data);
      }).toList();

    } catch (e) {
      if (kDebugMode) {
        print('Error getting reports by scholarship: $e');
      }
      return [];
    }
  }

  // Get reports by user
  Future<List<Report>> getReportsByUser(String userId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(AppConstants.reportsCollection)
          .where('reportedUserId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Report.fromMap(data);
      }).toList();

    } catch (e) {
      if (kDebugMode) {
        print('Error getting reports by user: $e');
      }
      return [];
    }
  }

  // Get report by ID
  Future<Report?> getReportById(String reportId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection(AppConstants.reportsCollection)
          .doc(reportId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Report.fromMap(data);
      }
      return null;

    } catch (e) {
      if (kDebugMode) {
        print('Error getting report by ID: $e');
      }
      return null;
    }
  }

  // Select a report for detailed view
  void selectReport(Report? report) {
    _selectedReport = report;
    notifyListeners();
  }

  // Search reports
  List<Report> searchReports(String query) {
    if (query.isEmpty) return _reports;

    return _reports.where((report) {
      return report.reason.toLowerCase().contains(query.toLowerCase()) ||
             report.description.toLowerCase().contains(query.toLowerCase()) ||
             report.reporterName.toLowerCase().contains(query.toLowerCase()) ||
             report.reportType.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter reports by status
  List<Report> filterReportsByStatus(String status) {
    return _reports.where((report) => report.status == status).toList();
  }

  // Filter reports by type
  List<Report> filterReportsByType(String type) {
    return _reports.where((report) => report.reportType == type).toList();
  }

  // Get report statistics for admin dashboard
  Map<String, int> getReportStatistics() {
    final stats = <String, int>{
      'total': _reports.length,
      'open': _reports.where((r) => r.status == AppConstants.reportOpen).length,
      'investigating': _reports.where((r) => r.status == AppConstants.reportInvestigating).length,
      'resolved': _reports.where((r) => r.status == AppConstants.reportResolved).length,
      'closed': _reports.where((r) => r.status == AppConstants.reportClosed).length,
    };

    return stats;
  }

  // Check if user can report (prevent spam)
  Future<bool> canUserReport(String userId, String targetType, String targetId) async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // Check if user has already reported this target in the last 24 hours
      final recentReports = await _firebaseService.firestore
          .collection(AppConstants.reportsCollection)
          .where('reporterId', isEqualTo: userId)
          .where('createdAt', isGreaterThan: Timestamp.fromDate(yesterday))
          .get();

      // Check if target already reported
      final hasReportedTarget = recentReports.docs.any((doc) {
        final data = doc.data();
        switch (targetType) {
          case 'scholarship':
            return data['scholarshipId'] == targetId;
          case 'user':
            return data['reportedUserId'] == targetId;
          case 'transaction':
            return data['transactionId'] == targetId;
          default:
            return false;
        }
      });

      return !hasReportedTarget;

    } catch (e) {
      if (kDebugMode) {
        print('Error checking user report eligibility: $e');
      }
      return true; // Default to allowing reports if check fails
    }
  }

  // Helper method to get scholarship title
  Future<String> _getScholarshipTitle(String? scholarshipId) async {
    if (scholarshipId == null) return 'Unknown Scholarship';
    
    try {
      final doc = await _firebaseService.firestore
          .collection(AppConstants.scholarshipsCollection)
          .doc(scholarshipId)
          .get();

      return doc.data()?['title'] ?? 'Unknown Scholarship';
    } catch (e) {
      return 'Unknown Scholarship';
    }
  }

  // Clear reports list
  void clearReports() {
    _reports.clear();
    _selectedReport = null;
    _error = null;
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    super.dispose();
  }
}
