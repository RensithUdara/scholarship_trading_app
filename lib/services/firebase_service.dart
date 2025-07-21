import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart' as app_user;
import '../core/constants/app_constants.dart';
import '../firebase_options.dart';

class FirebaseService {
  static FirebaseService? _instance;
  FirebaseService._internal();
  
  factory FirebaseService() {
    _instance ??= FirebaseService._internal();
    return _instance!;
  }

  // Firebase instances
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Getters
  firebase_auth.FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseMessaging get messaging => _messaging;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Configure Firestore settings for better performance
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    
    // In debug mode, disable App Check to avoid token warnings
    if (kDebugMode) {
      // Note: In production, you should configure proper App Check
      print('Debug mode: App Check warnings are normal in development');
    }
    
    // Configure Firebase Messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    // Request permission for notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  // Authentication Methods
  
  // Sign in with email and password
  Future<firebase_auth.User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Create account with email and password
  Future<firebase_auth.User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(displayName);
        
        // Create user document in Firestore
        await createUserDocument(
          user: credential.user!,
          displayName: displayName,
          role: role,
        );
      }
      
      return credential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google - Temporarily disabled
  Future<firebase_auth.User?> signInWithGoogle({String role = AppConstants.buyerRole}) async {
    throw UnimplementedError('Google Sign In temporarily disabled');
    /*
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        // Check if user document exists, if not create it
        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userCredential.user!.uid)
            .get();
            
        if (!userDoc.exists) {
          await createUserDocument(
            user: userCredential.user!,
            displayName: userCredential.user!.displayName ?? '',
            role: role,
          );
        }
      }

      return userCredential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
    */
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    // await _googleSignIn.signOut(); // Temporarily disabled
  }

  // Create user document in Firestore
  Future<void> createUserDocument({
    required firebase_auth.User user,
    required String displayName,
    required String role,
  }) async {
    final appUser = app_user.User.fromAuth(
      uid: user.uid,
      email: user.email!,
      displayName: displayName,
      photoURL: user.photoURL,
      role: role,
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(appUser.toFirestore());
  }

  // Get user document
  Future<app_user.User?> getUserDocument(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return app_user.User.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user document: $e');
      return null;
    }
  }

  // Update user document
  Future<void> updateUserDocument(String userId, Map<String, dynamic> data) async {
    data['updatedAt'] = Timestamp.now();
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update(data);
  }

  // Storage Methods
  
  // Upload file to Firebase Storage
  Future<String> uploadFile({
    required String path,
    required List<int> fileBytes,
    required String fileName,
  }) async {
    try {
      final ref = _storage.ref().child(path).child(fileName);
      final uploadTask = ref.putData(fileBytes as Uint8List);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Delete file from Firebase Storage
  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  // Messaging Methods
  
  // Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  // Firestore Helper Methods
  
  // Get collection reference
  CollectionReference collection(String path) {
    return _firestore.collection(path);
  }

  // Get document reference
  DocumentReference doc(String path) {
    return _firestore.doc(path);
  }

  // Batch write
  WriteBatch batch() {
    return _firestore.batch();
  }

  // Handle Authentication Exceptions
  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }

  // Current user stream
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();
  
  // Current user
  firebase_auth.User? get currentUser => _auth.currentUser;
  
  // Is user signed in
  bool get isSignedIn => currentUser != null;
}
