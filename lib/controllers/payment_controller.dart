import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../models/transaction.dart';
import '../services/firebase_service.dart';
import '../core/constants/app_constants.dart';

class PaymentController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Transaction> _transactions = [];
  
  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Transaction> get transactions => _transactions;

  // Initialize Stripe
  static void initialize({required String publishableKey}) {
    Stripe.publishableKey = publishableKey;
  }

  // Process scholarship purchase
  Future<bool> purchaseScholarship({
    required String scholarshipId,
    required String buyerId,
    required String sellerId,
    required double amount,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Create transaction record
      final transaction = Transaction.fromScholarship(
        scholarshipId: scholarshipId,
        buyerId: buyerId,
        sellerId: sellerId,
        amount: amount,
      );

      // Create payment intent (this would typically call your backend)
      final paymentIntent = await _createPaymentIntent(
        amount: (amount * 100).round(), // Convert to cents
        currency: AppConstants.currency.toLowerCase(),
        scholarshipId: scholarshipId,
        buyerId: buyerId,
        sellerId: sellerId,
      );

      if (paymentIntent != null) {
        // Initialize payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent['client_secret'],
            merchantDisplayName: AppConstants.appName,
            style: ThemeMode.system,
          ),
        );

        // Present payment sheet
        await Stripe.instance.presentPaymentSheet();

        // If payment successful, save transaction
        final updatedTransaction = transaction.copyWith(
          stripePaymentIntentId: paymentIntent['id'],
          status: AppConstants.transactionConfirmed,
        );

        await _saveTransaction(updatedTransaction);

        // Update scholarship status
        await _firebaseService.collection(AppConstants.scholarshipsCollection)
            .doc(scholarshipId)
            .update({
          'status': AppConstants.scholarshipSold,
          'buyerId': buyerId,
          'updatedAt': DateTime.now(),
        });

        return true;
      }

      return false;
    } on StripeException catch (e) {
      _errorMessage = e.error.localizedMessage ?? 'Payment failed';
      return false;
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Create payment intent (would call your backend/cloud function)
  Future<Map<String, dynamic>?> _createPaymentIntent({
    required int amount,
    required String currency,
    required String scholarshipId,
    required String buyerId,
    required String sellerId,
  }) async {
    try {
      // In a real app, this would call your backend API or Cloud Function
      // For now, we'll return a mock structure
      // Your backend should create a Stripe Payment Intent with application fees
      
      // This is a placeholder - implement actual API call
      return {
        'id': 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
        'client_secret': 'pi_mock_${DateTime.now().millisecondsSinceEpoch}_secret',
        'amount': amount,
        'currency': currency,
      };
    } catch (e) {
      print('Error creating payment intent: $e');
      return null;
    }
  }

  // Save transaction to Firestore
  Future<void> _saveTransaction(Transaction transaction) async {
    await _firebaseService.collection(AppConstants.transactionsCollection)
        .add(transaction.toFirestore());
  }

  // Load user transactions
  Future<void> loadUserTransactions(String userId, {bool isSeller = false}) async {
    _setLoading(true);
    _clearError();

    try {
      final field = isSeller ? 'sellerId' : 'buyerId';
      final snapshot = await _firebaseService.collection(AppConstants.transactionsCollection)
          .where(field, isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _transactions = snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to load transactions: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load all transactions (admin only)
  Future<void> loadAllTransactions() async {
    _setLoading(true);
    _clearError();

    try {
      final snapshot = await _firebaseService.collection(AppConstants.transactionsCollection)
          .orderBy('createdAt', descending: true)
          .limit(100) // Limit for performance
          .get();

      _transactions = snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to load transactions: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Calculate monthly earnings for seller
  Future<Map<String, double>> calculateMonthlyEarnings(String sellerId, DateTime month) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final snapshot = await _firebaseService.collection(AppConstants.transactionsCollection)
          .where('sellerId', isEqualTo: sellerId)
          .where('status', isEqualTo: AppConstants.transactionCompleted)
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
          .get();

      double totalSales = 0;
      double totalCommission = 0;
      double netEarnings = 0;

      for (var doc in snapshot.docs) {
        final transaction = Transaction.fromFirestore(doc);
        totalSales += transaction.amount;
        totalCommission += transaction.commission;
        netEarnings += transaction.sellerAmount;
      }

      return {
        'totalSales': totalSales,
        'totalCommission': totalCommission,
        'netEarnings': netEarnings,
        'transactionCount': snapshot.docs.length.toDouble(),
      };
    } catch (e) {
      print('Error calculating monthly earnings: $e');
      return {
        'totalSales': 0,
        'totalCommission': 0,
        'netEarnings': 0,
        'transactionCount': 0,
      };
    }
  }

  // Calculate platform revenue (admin)
  Future<Map<String, double>> calculatePlatformRevenue(DateTime month) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final snapshot = await _firebaseService.collection(AppConstants.transactionsCollection)
          .where('status', isEqualTo: AppConstants.transactionCompleted)
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
          .get();

      double totalRevenue = 0;
      double totalCommission = 0;

      for (var doc in snapshot.docs) {
        final transaction = Transaction.fromFirestore(doc);
        totalRevenue += transaction.amount;
        totalCommission += transaction.commission;
      }

      return {
        'totalRevenue': totalRevenue,
        'totalCommission': totalCommission,
        'transactionCount': snapshot.docs.length.toDouble(),
      };
    } catch (e) {
      print('Error calculating platform revenue: $e');
      return {
        'totalRevenue': 0,
        'totalCommission': 0,
        'transactionCount': 0,
      };
    }
  }

  // Refund transaction (admin only)
  Future<bool> refundTransaction(String transactionId) async {
    _setLoading(true);
    _clearError();

    try {
      // Update transaction status
      await _firebaseService.collection(AppConstants.transactionsCollection)
          .doc(transactionId)
          .update({
        'status': AppConstants.transactionRefunded,
        'updatedAt': DateTime.now(),
      });

      // Reload transactions
      await loadAllTransactions();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to refund transaction: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get transaction by ID
  Future<Transaction?> getTransactionById(String transactionId) async {
    try {
      final doc = await _firebaseService.collection(AppConstants.transactionsCollection)
          .doc(transactionId)
          .get();

      if (doc.exists) {
        return Transaction.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      _errorMessage = 'Failed to get transaction: $e';
      return null;
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
