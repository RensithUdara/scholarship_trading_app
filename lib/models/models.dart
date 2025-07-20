import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';

class Bid {
  final String id;
  final String scholarshipId;
  final String bidderId;
  final double amount;
  final DateTime timestamp;
  final bool isWinning;
  final bool isActive;
  final Map<String, dynamic> metadata;

  Bid({
    required this.id,
    required this.scholarshipId,
    required this.bidderId,
    required this.amount,
    required this.timestamp,
    this.isWinning = false,
    this.isActive = true,
    this.metadata = const {},
  });

  // Create Bid from Firestore Document
  factory Bid.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Bid(
      id: doc.id,
      scholarshipId: data['scholarshipId'] ?? '',
      bidderId: data['bidderId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isWinning: data['isWinning'] ?? false,
      isActive: data['isActive'] ?? true,
      metadata: data['metadata'] ?? {},
    );
  }

  // Convert to Firestore Document
  Map<String, dynamic> toFirestore() {
    return {
      'scholarshipId': scholarshipId,
      'bidderId': bidderId,
      'amount': amount,
      'timestamp': Timestamp.fromDate(timestamp),
      'isWinning': isWinning,
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  // Copy with new values
  Bid copyWith({
    String? id,
    String? scholarshipId,
    String? bidderId,
    double? amount,
    DateTime? timestamp,
    bool? isWinning,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return Bid(
      id: id ?? this.id,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      bidderId: bidderId ?? this.bidderId,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      isWinning: isWinning ?? this.isWinning,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedAmount => '${AppConstants.currencySymbol}${amount.toStringAsFixed(2)}';
  Duration get age => DateTime.now().difference(timestamp);

  @override
  String toString() {
    return 'Bid(id: $id, amount: $amount, bidderId: $bidderId)';
  }
}

class Review {
  final String id;
  final String scholarshipId;
  final String buyerId;
  final String sellerId;
  final int rating;
  final String? comment;
  final DateTime timestamp;
  final bool isPublic;
  final Map<String, dynamic> metadata;

  Review({
    required this.id,
    required this.scholarshipId,
    required this.buyerId,
    required this.sellerId,
    required this.rating,
    this.comment,
    required this.timestamp,
    this.isPublic = true,
    this.metadata = const {},
  });

  // Create Review from Firestore Document
  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Review(
      id: doc.id,
      scholarshipId: data['scholarshipId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      rating: data['rating'] ?? 1,
      comment: data['comment'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPublic: data['isPublic'] ?? true,
      metadata: data['metadata'] ?? {},
    );
  }

  // Convert to Firestore Document
  Map<String, dynamic> toFirestore() {
    return {
      'scholarshipId': scholarshipId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'rating': rating,
      'comment': comment,
      'timestamp': Timestamp.fromDate(timestamp),
      'isPublic': isPublic,
      'metadata': metadata,
    };
  }

  // Copy with new values
  Review copyWith({
    String? id,
    String? scholarshipId,
    String? buyerId,
    String? sellerId,
    int? rating,
    String? comment,
    DateTime? timestamp,
    bool? isPublic,
    Map<String, dynamic>? metadata,
  }) {
    return Review(
      id: id ?? this.id,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
      isPublic: isPublic ?? this.isPublic,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get hasComment => comment != null && comment!.isNotEmpty;
  Duration get age => DateTime.now().difference(timestamp);

  @override
  String toString() {
    return 'Review(id: $id, rating: $rating, scholarshipId: $scholarshipId)';
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final Map<String, dynamic> metadata;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.metadata = const {},
  });

  // Create ChatMessage from Firestore Document
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      imageUrl: data['imageUrl'],
      metadata: data['metadata'] ?? {},
    );
  }

  // Create from Map (for subcollection)
  factory ChatMessage.fromMap(String id, Map<String, dynamic> data) {
    return ChatMessage(
      id: id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      imageUrl: data['imageUrl'],
      metadata: data['metadata'] ?? {},
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? text,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  Duration get age => DateTime.now().difference(timestamp);

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, text: ${text.substring(0, text.length > 20 ? 20 : text.length)})';
  }
}

class Chat {
  final String id;
  final String scholarshipId;
  final String buyerId;
  final String sellerId;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final Map<String, dynamic> metadata;

  Chat({
    required this.id,
    required this.scholarshipId,
    required this.buyerId,
    required this.sellerId,
    this.messages = const [],
    required this.createdAt,
    this.updatedAt,
    this.lastMessage,
    this.unreadCount = 0,
    this.metadata = const {},
  });

  // Create Chat from Firestore Document
  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Chat(
      id: doc.id,
      scholarshipId: data['scholarshipId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      lastMessage: data['lastMessage'] != null
          ? ChatMessage.fromMap('lastMessage', data['lastMessage'])
          : null,
      unreadCount: data['unreadCount'] ?? 0,
      metadata: data['metadata'] ?? {},
    );
  }

  // Convert to Firestore Document
  Map<String, dynamic> toFirestore() {
    return {
      'scholarshipId': scholarshipId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'lastMessage': lastMessage?.toMap(),
      'unreadCount': unreadCount,
      'metadata': metadata,
    };
  }

  Chat copyWith({
    String? id,
    String? scholarshipId,
    String? buyerId,
    String? sellerId,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    ChatMessage? lastMessage,
    int? unreadCount,
    Map<String, dynamic>? metadata,
  }) {
    return Chat(
      id: id ?? this.id,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get hasMessages => messages.isNotEmpty;
  bool get hasUnreadMessages => unreadCount > 0;

  @override
  String toString() {
    return 'Chat(id: $id, scholarshipId: $scholarshipId, messageCount: ${messages.length})';
  }
}

class Report {
  final String id;
  final String scholarshipId;
  final String buyerId;
  final String sellerId;
  final String description;
  final String status;
  final DateTime timestamp;
  final DateTime? resolvedAt;
  final String? adminResponse;
  final Map<String, dynamic> metadata;

  Report({
    required this.id,
    required this.scholarshipId,
    required this.buyerId,
    required this.sellerId,
    required this.description,
    this.status = AppConstants.reportOpen,
    required this.timestamp,
    this.resolvedAt,
    this.adminResponse,
    this.metadata = const {},
  });

  // Create Report from Firestore Document
  factory Report.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Report(
      id: doc.id,
      scholarshipId: data['scholarshipId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? AppConstants.reportOpen,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
      adminResponse: data['adminResponse'],
      metadata: data['metadata'] ?? {},
    );
  }

  // Convert to Firestore Document
  Map<String, dynamic> toFirestore() {
    return {
      'scholarshipId': scholarshipId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'description': description,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'adminResponse': adminResponse,
      'metadata': metadata,
    };
  }

  Report copyWith({
    String? id,
    String? scholarshipId,
    String? buyerId,
    String? sellerId,
    String? description,
    String? status,
    DateTime? timestamp,
    DateTime? resolvedAt,
    String? adminResponse,
    Map<String, dynamic>? metadata,
  }) {
    return Report(
      id: id ?? this.id,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      description: description ?? this.description,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      adminResponse: adminResponse ?? this.adminResponse,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isOpen => status == AppConstants.reportOpen;
  bool get isInvestigating => status == AppConstants.reportInvestigating;
  bool get isResolved => status == AppConstants.reportResolved;
  bool get isClosed => status == AppConstants.reportClosed;
  bool get hasAdminResponse => adminResponse != null && adminResponse!.isNotEmpty;
  Duration get age => DateTime.now().difference(timestamp);

  @override
  String toString() {
    return 'Report(id: $id, status: $status, scholarshipId: $scholarshipId)';
  }
}
