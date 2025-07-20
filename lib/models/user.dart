import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';

class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String role;
  final bool isActive;
  final bool isVerified;
  final String? phoneNumber;
  final String? stripeAccountId;
  final String? stripeCustomerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic> metadata;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.role,
    this.isActive = false,
    this.isVerified = false,
    this.phoneNumber,
    this.stripeAccountId,
    this.stripeCustomerId,
    required this.createdAt,
    this.updatedAt,
    this.metadata = const {},
  });

  // Create User from Firebase Auth
  factory User.fromAuth({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    String role = AppConstants.buyerRole,
  }) {
    return User(
      id: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      role: role,
      createdAt: DateTime.now(),
    );
  }

  // Create User from Firestore Document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      role: data['role'] ?? AppConstants.buyerRole,
      isActive: data['isActive'] ?? false,
      isVerified: data['isVerified'] ?? false,
      phoneNumber: data['phoneNumber'],
      stripeAccountId: data['stripeAccountId'],
      stripeCustomerId: data['stripeCustomerId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      metadata: data['metadata'] ?? {},
    );
  }

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      role: json['role'] ?? AppConstants.buyerRole,
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
      phoneNumber: json['phoneNumber'],
      stripeAccountId: json['stripeAccountId'],
      stripeCustomerId: json['stripeCustomerId'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : null,
      metadata: json['metadata'] ?? {},
    );
  }

  // Convert to Firestore Document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role,
      'isActive': isActive,
      'isVerified': isVerified,
      'phoneNumber': phoneNumber,
      'stripeAccountId': stripeAccountId,
      'stripeCustomerId': stripeCustomerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'metadata': metadata,
    };
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role,
      'isActive': isActive,
      'isVerified': isVerified,
      'phoneNumber': phoneNumber,
      'stripeAccountId': stripeAccountId,
      'stripeCustomerId': stripeCustomerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  // Copy with new values
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? role,
    bool? isActive,
    bool? isVerified,
    String? phoneNumber,
    String? stripeAccountId,
    String? stripeCustomerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper methods
  bool get isBuyer => role == AppConstants.buyerRole;
  bool get isSeller => role == AppConstants.sellerRole;
  bool get isAdmin => role == AppConstants.adminRole;
  bool get canSell => isSeller && isActive && isVerified;
  bool get canBuy => isBuyer || isAdmin;
  bool get hasStripeAccount => stripeAccountId != null;
  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final names = displayName!.split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, role: $role, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is User &&
      other.id == id &&
      other.email == email &&
      other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ role.hashCode;
  }
}
