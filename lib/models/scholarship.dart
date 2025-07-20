import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';

class Scholarship {
  final String id;
  final String sellerId;
  final String title;
  final String description;
  final double price;
  final List<String> imageUrls;
  final List<String> documentUrls;
  final bool isAuction;
  final double? currentBid;
  final double? minimumBid;
  final DateTime? auctionEndTime;
  final String status;
  final String category;
  final String educationLevel;
  final String state;
  final List<String> eligibilityCriteria;
  final String applicationProcess;
  final DateTime applicationDeadline;
  final String? buyerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic> metadata;
  final int viewCount;
  final int bidCount;
  final double? averageRating;
  final int reviewCount;

  Scholarship({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrls = const [],
    this.documentUrls = const [],
    this.isAuction = false,
    this.currentBid,
    this.minimumBid,
    this.auctionEndTime,
    this.status = AppConstants.scholarshipPending,
    required this.category,
    required this.educationLevel,
    required this.state,
    this.eligibilityCriteria = const [],
    required this.applicationProcess,
    required this.applicationDeadline,
    this.buyerId,
    required this.createdAt,
    this.updatedAt,
    this.metadata = const {},
    this.viewCount = 0,
    this.bidCount = 0,
    this.averageRating,
    this.reviewCount = 0,
  });

  // Create Scholarship from Firestore Document
  factory Scholarship.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Scholarship(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      documentUrls: List<String>.from(data['documentUrls'] ?? []),
      isAuction: data['isAuction'] ?? false,
      currentBid: data['currentBid']?.toDouble(),
      minimumBid: data['minimumBid']?.toDouble(),
      auctionEndTime: (data['auctionEndTime'] as Timestamp?)?.toDate(),
      status: data['status'] ?? AppConstants.scholarshipPending,
      category: data['category'] ?? '',
      educationLevel: data['educationLevel'] ?? '',
      state: data['state'] ?? '',
      eligibilityCriteria: List<String>.from(data['eligibilityCriteria'] ?? []),
      applicationProcess: data['applicationProcess'] ?? '',
      applicationDeadline: (data['applicationDeadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      buyerId: data['buyerId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      metadata: data['metadata'] ?? {},
      viewCount: data['viewCount'] ?? 0,
      bidCount: data['bidCount'] ?? 0,
      averageRating: data['averageRating']?.toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
    );
  }

  // Create Scholarship from JSON
  factory Scholarship.fromJson(Map<String, dynamic> json) {
    return Scholarship(
      id: json['id'] ?? '',
      sellerId: json['sellerId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      documentUrls: List<String>.from(json['documentUrls'] ?? []),
      isAuction: json['isAuction'] ?? false,
      currentBid: json['currentBid']?.toDouble(),
      minimumBid: json['minimumBid']?.toDouble(),
      auctionEndTime: json['auctionEndTime'] != null 
          ? DateTime.parse(json['auctionEndTime'])
          : null,
      status: json['status'] ?? AppConstants.scholarshipPending,
      category: json['category'] ?? '',
      educationLevel: json['educationLevel'] ?? '',
      state: json['state'] ?? '',
      eligibilityCriteria: List<String>.from(json['eligibilityCriteria'] ?? []),
      applicationProcess: json['applicationProcess'] ?? '',
      applicationDeadline: json['applicationDeadline'] != null 
          ? DateTime.parse(json['applicationDeadline'])
          : DateTime.now(),
      buyerId: json['buyerId'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : null,
      metadata: json['metadata'] ?? {},
      viewCount: json['viewCount'] ?? 0,
      bidCount: json['bidCount'] ?? 0,
      averageRating: json['averageRating']?.toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
    );
  }

  // Convert to Firestore Document
  Map<String, dynamic> toFirestore() {
    return {
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'documentUrls': documentUrls,
      'isAuction': isAuction,
      'currentBid': currentBid,
      'minimumBid': minimumBid,
      'auctionEndTime': auctionEndTime != null 
          ? Timestamp.fromDate(auctionEndTime!)
          : null,
      'status': status,
      'category': category,
      'educationLevel': educationLevel,
      'state': state,
      'eligibilityCriteria': eligibilityCriteria,
      'applicationProcess': applicationProcess,
      'applicationDeadline': Timestamp.fromDate(applicationDeadline),
      'buyerId': buyerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'metadata': metadata,
      'viewCount': viewCount,
      'bidCount': bidCount,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'documentUrls': documentUrls,
      'isAuction': isAuction,
      'currentBid': currentBid,
      'minimumBid': minimumBid,
      'auctionEndTime': auctionEndTime?.toIso8601String(),
      'status': status,
      'category': category,
      'educationLevel': educationLevel,
      'state': state,
      'eligibilityCriteria': eligibilityCriteria,
      'applicationProcess': applicationProcess,
      'applicationDeadline': applicationDeadline.toIso8601String(),
      'buyerId': buyerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata,
      'viewCount': viewCount,
      'bidCount': bidCount,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }

  // Copy with new values
  Scholarship copyWith({
    String? id,
    String? sellerId,
    String? title,
    String? description,
    double? price,
    List<String>? imageUrls,
    List<String>? documentUrls,
    bool? isAuction,
    double? currentBid,
    double? minimumBid,
    DateTime? auctionEndTime,
    String? status,
    String? category,
    String? educationLevel,
    String? state,
    List<String>? eligibilityCriteria,
    String? applicationProcess,
    DateTime? applicationDeadline,
    String? buyerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    int? viewCount,
    int? bidCount,
    double? averageRating,
    int? reviewCount,
  }) {
    return Scholarship(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      documentUrls: documentUrls ?? this.documentUrls,
      isAuction: isAuction ?? this.isAuction,
      currentBid: currentBid ?? this.currentBid,
      minimumBid: minimumBid ?? this.minimumBid,
      auctionEndTime: auctionEndTime ?? this.auctionEndTime,
      status: status ?? this.status,
      category: category ?? this.category,
      educationLevel: educationLevel ?? this.educationLevel,
      state: state ?? this.state,
      eligibilityCriteria: eligibilityCriteria ?? this.eligibilityCriteria,
      applicationProcess: applicationProcess ?? this.applicationProcess,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      buyerId: buyerId ?? this.buyerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
      viewCount: viewCount ?? this.viewCount,
      bidCount: bidCount ?? this.bidCount,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  // Helper methods
  bool get isPending => status == AppConstants.scholarshipPending;
  bool get isApproved => status == AppConstants.scholarshipApproved;
  bool get isRejected => status == AppConstants.scholarshipRejected;
  bool get isSold => status == AppConstants.scholarshipSold;
  bool get isExpired => status == AppConstants.scholarshipExpired;
  bool get isAvailable => isApproved && !isSold && !isExpired;
  
  bool get isAuctionActive {
    if (!isAuction || auctionEndTime == null) return false;
    return DateTime.now().isBefore(auctionEndTime!) && isAvailable;
  }
  
  bool get isAuctionEnded {
    if (!isAuction || auctionEndTime == null) return false;
    return DateTime.now().isAfter(auctionEndTime!);
  }
  
  Duration? get timeRemaining {
    if (!isAuction || auctionEndTime == null) return null;
    final now = DateTime.now();
    if (now.isAfter(auctionEndTime!)) return Duration.zero;
    return auctionEndTime!.difference(now);
  }
  
  double get currentPrice => isAuction ? (currentBid ?? minimumBid ?? price) : price;
  
  String get formattedPrice => '${AppConstants.currencySymbol}${currentPrice.toStringAsFixed(2)}';
  
  bool get hasImages => imageUrls.isNotEmpty;
  bool get hasDocuments => documentUrls.isNotEmpty;
  
  String get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  @override
  String toString() {
    return 'Scholarship(id: $id, title: $title, price: $price, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Scholarship &&
      other.id == id &&
      other.title == title &&
      other.sellerId == sellerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ sellerId.hashCode;
  }
}
