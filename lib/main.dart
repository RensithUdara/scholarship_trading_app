import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Core imports
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';

// Controllers
import 'controllers/auth_controller.dart';
import 'controllers/scholarship_controller.dart';
import 'controllers/payment_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/report_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize FirebaseService
  await FirebaseService.initialize();
  
  // Initialize notification service
  await NotificationService().initialize();
  
  runApp(const ScholarshipMarketplaceApp());
}

class ScholarshipMarketplaceApp extends StatelessWidget {
  const ScholarshipMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final authController = AuthController();
            authController.initialize(); // Initialize the auth controller
            return authController;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => ScholarshipController(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportController(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.createRouter();
          return MaterialApp.router(
            title: 'Scholarship Marketplace',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
