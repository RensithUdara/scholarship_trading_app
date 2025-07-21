import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

/// Navigation utility class for easier route management
class AppNavigator {
  // Authentication routes
  static void goToAuth(BuildContext context) {
    context.go('/auth');
  }

  static void goToLogin(BuildContext context) {
    context.go('/login');
  }

  static void goToSignup(BuildContext context) {
    context.go('/signup');
  }

  // Main app routes
  static void goToHome(BuildContext context) {
    context.go('/home');
  }

  static void goToSearch(BuildContext context, {String? query, String? category}) {
    final uri = Uri(
      path: '/search',
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );
    context.go(uri.toString());
  }

  static void pushToSearch(BuildContext context, {String? query, String? category}) {
    final uri = Uri(
      path: '/search',
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );
    context.push(uri.toString());
  }

  // Scholarship routes
  static void goToScholarshipDetail(BuildContext context, String scholarshipId) {
    context.go('/scholarship/$scholarshipId');
  }

  static void pushToScholarshipDetail(BuildContext context, String scholarshipId) {
    context.push('/scholarship/$scholarshipId');
  }

  // Profile & Settings routes
  static void goToProfile(BuildContext context) {
    context.go('/profile');
  }

  static void goToSettings(BuildContext context) {
    context.go('/settings');
  }

  static void goToTransactions(BuildContext context) {
    context.go('/transactions');
  }

  static void goToHelp(BuildContext context) {
    context.go('/help');
  }

  static void goToAbout(BuildContext context) {
    context.go('/about');
  }

  static void goToEditProfile(BuildContext context) {
    context.go('/edit-profile');
  }

  static void goToTransactionHistory(BuildContext context) {
    context.go('/transaction-history');
  }

  // Seller routes
  static void goToSell(BuildContext context) {
    context.go('/sell');
  }

  static void goToMyScholarships(BuildContext context) {
    context.go('/my-scholarships');
  }

  // Chat routes
  static void goToChat(BuildContext context) {
    context.go('/chat');
  }

  static void goToChatDetail(BuildContext context, String chatId) {
    context.go('/chat/$chatId');
  }

  static void pushToChatDetail(BuildContext context, String chatId) {
    context.push('/chat/$chatId');
  }

  // Utility methods
  static void goBack(BuildContext context) {
    context.pop();
  }

  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }

  static void goBackToRoot(BuildContext context) {
    context.go('/home');
  }
}

/// Extension methods for easier navigation
extension NavigationExtension on BuildContext {
  // Quick access to common navigation actions
  void navigateToHome() => AppNavigator.goToHome(this);
  void navigateToSearch({String? query, String? category}) => 
      AppNavigator.goToSearch(this, query: query, category: category);
  void navigateToScholarship(String id) => 
      AppNavigator.pushToScholarshipDetail(this, id);
  void navigateToProfile() => AppNavigator.goToProfile(this);
  void navigateBack() => AppNavigator.goBack(this);
}
