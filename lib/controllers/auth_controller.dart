import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart' as app_user;
import '../services/firebase_service.dart';
import '../core/constants/app_constants.dart';

class AuthController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  app_user.User? _currentUser;
  firebase_auth.User? _firebaseUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  app_user.User? get currentUser => _currentUser;
  firebase_auth.User? get firebaseUser => _firebaseUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => _firebaseUser != null;
  bool get isBuyer => _currentUser?.isBuyer ?? false;
  bool get isSeller => _currentUser?.isSeller ?? false;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get canSell => _currentUser?.canSell ?? false;

  // Initialize and listen to auth state changes
  void initialize() {
    print('AuthController: Initializing...');
    _firebaseService.authStateChanges.listen(_onAuthStateChanged);
    print('AuthController: Initialized and listening to auth state changes');
  }

  // Handle auth state changes
  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    print('AuthController: Auth state changed - User: ${firebaseUser?.email ?? 'null'}');
    _firebaseUser = firebaseUser;
    
    if (firebaseUser != null) {
      print('AuthController: Loading user document for ${firebaseUser.uid}');
      // Load user document from Firestore
      await _loadUserDocument(firebaseUser.uid);
    } else {
      print('AuthController: User signed out');
      _currentUser = null;
    }
    
    print('AuthController: Notifying listeners');
    notifyListeners();
  }

  // Load user document from Firestore
  Future<void> _loadUserDocument(String userId) async {
    try {
      _currentUser = await _firebaseService.getUserDocument(userId);
    } catch (e) {
      _errorMessage = 'Failed to load user data: $e';
      print('Error loading user document: $e');
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _performAuthAction(() async {
      final user = await _firebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user != null;
    });
  }

  // Create account with email and password
  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) async {
    return _performAuthAction(() async {
      final user = await _firebaseService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );
      return user != null;
    });
  }

  // Sign in with Google
  Future<bool> signInWithGoogle({String role = AppConstants.buyerRole}) async {
    return _performAuthAction(() async {
      final user = await _firebaseService.signInWithGoogle(role: role);
      return user != null;
    });
  }

  // Sign out
  Future<bool> signOut() async {
    return _performAuthAction(() async {
      await _firebaseService.signOut();
      _currentUser = null;
      _firebaseUser = null;
      return true;
    });
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    return _performAuthAction(() async {
      await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    });
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? displayName,
    String? phoneNumber,
    Map<String, dynamic>? metadata,
  }) async {
    if (_currentUser == null) return false;

    return _performAuthAction(() async {
      final updates = <String, dynamic>{};
      
      if (displayName != null) {
        updates['displayName'] = displayName;
        // Also update Firebase Auth displayName
        await _firebaseUser?.updateDisplayName(displayName);
      }
      
      if (phoneNumber != null) {
        updates['phoneNumber'] = phoneNumber;
      }
      
      if (metadata != null) {
        updates['metadata'] = {..._currentUser!.metadata, ...metadata};
      }

      if (updates.isNotEmpty) {
        await _firebaseService.updateUserDocument(_currentUser!.id, updates);
        await _loadUserDocument(_currentUser!.id);
      }

      return true;
    });
  }

  // Update user role (admin only)
  Future<bool> updateUserRole(String userId, String role) async {
    if (!isAdmin) return false;

    return _performAuthAction(() async {
      await _firebaseService.updateUserDocument(userId, {'role': role});
      
      // If updating current user's role, reload user data
      if (userId == _currentUser?.id) {
        await _loadUserDocument(userId);
      }
      
      return true;
    });
  }

  // Activate seller account (admin only)
  Future<bool> activateSellerAccount(String userId) async {
    if (!isAdmin) return false;

    return _performAuthAction(() async {
      await _firebaseService.updateUserDocument(userId, {
        'isActive': true,
        'isVerified': true,
      });
      
      // If updating current user, reload user data
      if (userId == _currentUser?.id) {
        await _loadUserDocument(userId);
      }
      
      return true;
    });
  }

  // Deactivate seller account (admin only)
  Future<bool> deactivateSellerAccount(String userId) async {
    if (!isAdmin) return false;

    return _performAuthAction(() async {
      await _firebaseService.updateUserDocument(userId, {
        'isActive': false,
      });
      
      // If updating current user, reload user data
      if (userId == _currentUser?.id) {
        await _loadUserDocument(userId);
      }
      
      return true;
    });
  }

  // Update FCM token
  Future<void> updateFCMToken() async {
    if (_currentUser == null) return;

    try {
      final token = await _firebaseService.getFCMToken();
      if (token != null) {
        await _firebaseService.updateUserDocument(_currentUser!.id, {
          'fcmToken': token,
        });
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  // Subscribe to user role topics for notifications
  Future<void> subscribeToNotificationTopics() async {
    if (_currentUser == null) return;

    try {
      // Subscribe to general topics
      await _firebaseService.subscribeToTopic('all_users');
      
      // Subscribe to role-specific topics
      await _firebaseService.subscribeToTopic(_currentUser!.role);
      
      // If seller, subscribe to seller-specific topics
      if (_currentUser!.isSeller) {
        await _firebaseService.subscribeToTopic('sellers');
        if (_currentUser!.isActive) {
          await _firebaseService.subscribeToTopic('active_sellers');
        }
      }
      
      // If buyer, subscribe to buyer-specific topics
      if (_currentUser!.isBuyer) {
        await _firebaseService.subscribeToTopic('buyers');
      }
      
      // If admin, subscribe to admin-specific topics
      if (_currentUser!.isAdmin) {
        await _firebaseService.subscribeToTopic('admins');
      }
    } catch (e) {
      print('Error subscribing to notification topics: $e');
    }
  }

  // Get user initials for avatar
  String getUserInitials() {
    return _currentUser?.initials ?? _firebaseUser?.email?.substring(0, 1).toUpperCase() ?? '?';
  }

  // Get user display name
  String getUserDisplayName() {
    return _currentUser?.displayName ?? 
           _firebaseUser?.displayName ?? 
           _firebaseUser?.email?.split('@').first ?? 
           'User';
  }

  // Check if user has completed profile setup
  bool hasCompletedProfile() {
    if (_currentUser == null) return false;
    
    return _currentUser!.displayName != null && 
           _currentUser!.displayName!.isNotEmpty;
  }

  // Check if seller can list scholarships
  bool canListScholarships() {
    return _currentUser?.canSell ?? false;
  }

  // Get user verification status
  String getVerificationStatus() {
    if (_currentUser == null) return 'Not verified';
    
    if (_currentUser!.isSeller) {
      if (_currentUser!.isVerified && _currentUser!.isActive) {
        return 'Verified seller';
      } else if (_currentUser!.isVerified) {
        return 'Verified (pending activation)';
      } else {
        return 'Pending verification';
      }
    }
    
    return _currentUser!.isVerified ? 'Verified' : 'Not verified';
  }

  // Perform auth action with loading state and error handling
  Future<bool> _performAuthAction(Future<bool> Function() action) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await action();
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
