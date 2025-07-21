import 'dart:developer';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Temporarily disabled
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin(); // Temporarily disabled

  // Initialize notification service
  Future<void> initialize() async {
    try {
      // Initialize local notifications - temporarily disabled
      // const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      // const iosSettings = DarwinInitializationSettings(
      //   requestAlertPermission: true,
      //   requestBadgePermission: true,
      //   requestSoundPermission: true,
      // );
      
      // const initSettings = InitializationSettings(
      //   android: androidSettings,
      //   iOS: iosSettings,
      // );
      
      // await _localNotifications.initialize(
      //   initSettings,
      //   onDidReceiveNotificationResponse: _onNotificationTapped,
      // );
      
      // Set up Firebase messaging handlers
      _setupFirebaseMessaging();
      
      log('NotificationService initialized successfully (local notifications temporarily disabled)');
    } catch (e) {
      log('Error initializing NotificationService: $e');
    }
  }

  // Set up Firebase messaging handlers
  void _setupFirebaseMessaging() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTapped(message);
    });

    // Handle initial message if app was closed
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTapped(message);
      }
    });
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      log('Received foreground message: ${message.notification!.title} - ${message.notification!.body}');
      // showNotification method temporarily disabled - just log for now
      // showNotification(
      //   id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      //   title: message.notification!.title ?? 'Notification',
      //   body: message.notification!.body ?? '',
      //   payload: message.data.cast<String, String>(),
      // );
    }
  }

  // Handle notification tapped
  void _handleNotificationTapped(RemoteMessage message) {
    log('Notification tapped with data: ${message.data}');
    // Handle navigation based on notification data
  }

  // Handle local notification tapped
  void _onNotificationTapped(dynamic response) {
    log('Local notification tapped: ${response.toString()}');
  }

  // Show push notification (temporarily disabled)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    try {
      log('Notification (local notifications disabled): $title - $body');
      // Local notification functionality temporarily disabled
      // const androidDetails = AndroidNotificationDetails(
      //   'scholarship_channel',
      //   'Scholarship Notifications',
      //   channelDescription: 'Notifications for scholarship updates',
      //   importance: Importance.high,
      //   priority: Priority.high,
      // );
      
      // const iosDetails = DarwinNotificationDetails();
      
      // const notificationDetails = NotificationDetails(
      //   android: androidDetails,
      //   iOS: iosDetails,
      // );
      
      // await _localNotifications.show(
      //   id,
      //   title,
      //   body,
      //   notificationDetails,
      //   payload: payload?.toString(),
      // );
      
      // log('Notification shown: $title');
    } catch (e) {
      log('Error showing notification: $e');
    }
  }

  // Handle notification permission request (temporarily disabled)
  Future<bool> requestPermissions() async {
    try {
      log('Notification permissions (local notifications disabled): granted');
      // Local notification permission request temporarily disabled
      // final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      // final granted = await androidPlugin?.requestPermission();
      
      // log('Notification permissions granted: $granted');
      // return granted ?? false;
      return true;
    } catch (e) {
      log('Error requesting permissions: $e');
      return false;
    }
  }

  // Set notification handlers
  void setNotificationHandlers() {
    log('Notification handlers set up successfully');
  }

  // Helper method for scholarship notifications
  Future<void> showScholarshipNotification(String message) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Scholarship Update',
      body: message,
    );
  }

  // Helper method for chat notifications
  Future<void> showChatNotification(String senderName, String message) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'New Message from $senderName',
      body: message,
    );
  }

  // Helper method for report notifications
  Future<void> notifyNewReport({
    required String scholarshipTitle,
    required String reporterName,
    required String reportId,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'New Report',
      body: '$reporterName reported $scholarshipTitle',
      payload: {'reportId': reportId, 'type': 'report'},
    );
  }
}
