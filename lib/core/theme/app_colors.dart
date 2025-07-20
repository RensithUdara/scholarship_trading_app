import 'package:flutter/material.dart';

/// Modern Coastal Academic Color Theme
/// Inspired by Australia's coastal vibrancy and academic professionalism
class AppColors {
  // Primary Colors
  static const Color teal = Color(0xFF00A896);
  static const Color coral = Color(0xFFFF6B6B);
  
  // Accent Color
  static const Color gold = Color(0xFFFFD166);
  
  // Neutral Colors
  static const Color softWhite = Color(0xFFF8FAFC);
  static const Color darkGray = Color(0xFF2D3748);
  static const Color lightGray = Color(0xFFE2E8F0);
  static const Color mediumGray = Color(0xFF718096);
  
  // Error/Warning Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Gradient Colors
  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF00A896), Color(0xFF02C39A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient coralGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD166), Color(0xFFFFF3C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  
  // Overlay Colors
  static const Color overlayLight = Color(0x0F000000);
  static const Color overlayMedium = Color(0x29000000);
  static const Color overlayDark = Color(0x52000000);
  
  // Status Colors
  static const Color pending = Color(0xFFF59E0B);
  static const Color approved = Color(0xFF10B981);
  static const Color rejected = Color(0xFFEF4444);
  static const Color completed = Color(0xFF059669);
  
  // User Role Colors
  static const Color buyerRole = Color(0xFF3B82F6);
  static const Color sellerRole = Color(0xFF8B5CF6);
  static const Color adminRole = Color(0xFFDC2626);
  
  // Auction Colors
  static const Color bidWinning = Color(0xFF10B981);
  static const Color bidLosing = Color(0xFFEF4444);
  static const Color auctionActive = Color(0xFFFF6B6B);
  static const Color auctionEnded = Color(0xFF6B7280);
}
