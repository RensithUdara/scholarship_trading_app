import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';

class Transaction {
  final String id;
  final String scholarshipId;
  final String buyerId;
  final String sellerId;
  final double amount;
  final double commission;
  final double sellerAmount;
  final String currency;
  final String status;
  final String? stripePaymentIntentId;
  final String? stripeTransferId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final Map<String, dynamic> metadata;

  Transaction({
    required this.id,
    required this.scholarshipId,
    required this.buyerId,
    required this.sellerId,
    required this.amount,
    required this.commission,
    required this.sellerAmount,
    this.currency = AppConstants.currency,
    this.status = AppConstants.transactionPending,
    this.stripePaymentIntentId,
    this.stripeTransferId,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.metadata = const {},
  });

  // Create Transaction from scholarship purchase
  factory Transaction.fromScholarship({
    required String scholarshipId,
    required String buyerId,
    required String sellerId,
    required double amount,
    String? stripePaymentIntentId,
  }) {
    final commission = amount * AppConstants.adminCommissionRate;
    final sellerAmount = amount * AppConstants.sellerCommissionRate;
    
    return Transaction(
      id: '', // Will be set by Firestore
      scholarshipId: scholarshipId,
      buyerId: buyerId,
      sellerId: sellerId,
      amount: amount,
      commission: commission,
      sellerAmount: sellerAmount,
      stripePaymentIntentId: stripePaymentIntentId,
      createdAt: DateTime.now(),
    );
  }

  // Create Transaction from Firestore Document
  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Transaction(
      id: doc.id,
      scholarshipId: data['scholarshipId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      commission: (data['commission'] ?? 0.0).toDouble(),
      sellerAmount: (data['sellerAmount'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? AppConstants.currency,
      status: data['status'] ?? AppConstants.transactionPending,
      stripePaymentIntentId: data['stripePaymentIntentId'],
      stripeTransferId: data['stripeTransferId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      metadata: data['metadata'] ?? {},
    );
  }

  // Create Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      scholarshipId: json['scholarshipId'] ?? '',
      buyerId: json['buyerId'] ?? '',
      sellerId: json['sellerId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      commission: (json['commission'] ?? 0.0).toDouble(),
      sellerAmount: (json['sellerAmount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? AppConstants.currency,
      status: json['status'] ?? AppConstants.transactionPending,
      stripePaymentIntentId: json['stripePaymentIntentId'],
      stripeTransferId: json['stripeTransferId'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'])
          : null,
      metadata: json['metadata'] ?? {},
    );
  }

  // Convert to Firestore Document
  Map<String, dynamic> toFirestore() {
    return {
      'scholarshipId': scholarshipId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'amount': amount,
      'commission': commission,
      'sellerAmount': sellerAmount,
      'currency': currency,
      'status': status,
      'stripePaymentIntentId': stripePaymentIntentId,
      'stripeTransferId': stripeTransferId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'metadata': metadata,
    };
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scholarshipId': scholarshipId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'amount': amount,
      'commission': commission,
      'sellerAmount': sellerAmount,
      'currency': currency,
      'status': status,
      'stripePaymentIntentId': stripePaymentIntentId,
      'stripeTransferId': stripeTransferId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  // Copy with new values
  Transaction copyWith({
    String? id,
    String? scholarshipId,
    String? buyerId,
    String? sellerId,
    double? amount,
    double? commission,
    double? sellerAmount,
    String? currency,
    String? status,
    String? stripePaymentIntentId,
    String? stripeTransferId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: id ?? this.id,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      amount: amount ?? this.amount,
      commission: commission ?? this.commission,
      sellerAmount: sellerAmount ?? this.sellerAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      stripePaymentIntentId: stripePaymentIntentId ?? this.stripePaymentIntentId,
      stripeTransferId: stripeTransferId ?? this.stripeTransferId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper methods
  bool get isPending => status == AppConstants.transactionPending;
  bool get isConfirmed => status == AppConstants.transactionConfirmed;
  bool get isCompleted => status == AppConstants.transactionCompleted;
  bool get isFailed => status == AppConstants.transactionFailed;
  bool get isRefunded => status == AppConstants.transactionRefunded;
  
  String get formattedAmount => '${AppConstants.currencySymbol}${amount.toStringAsFixed(2)}';
  String get formattedCommission => '${AppConstants.currencySymbol}${commission.toStringAsFixed(2)}';
  String get formattedSellerAmount => '${AppConstants.currencySymbol}${sellerAmount.toStringAsFixed(2)}';
  
  Duration get age => DateTime.now().difference(createdAt);
  Duration? get processingTime => completedAt?.difference(createdAt);

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Transaction &&
      other.id == id &&
      other.scholarshipId == scholarshipId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ scholarshipId.hashCode;
  }
}
