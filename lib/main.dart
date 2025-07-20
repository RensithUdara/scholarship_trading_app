import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Core imports
import 'core/theme/app_theme.dart';
// import 'services/firebase_service.dart';
// import 'services/notification_service.dart';

// Controllers
import 'controllers/auth_controller.dart';
import 'controllers/scholarship_controller.dart';
import 'controllers/payment_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/report_controller.dart';

// Views
import 'views/splash/splash_screen.dart';
import 'views/auth/auth_wrapper.dart';
import 'views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Initialize Firebase when configuration files are added
  // await FirebaseService.initialize();
  
  // TODO: Initialize notification service when Firebase is configured
  // await NotificationService().initialize();
  
  runApp(const ScholarshipMarketplaceApp());
}

class ScholarshipMarketplaceApp extends StatelessWidget {
  const ScholarshipMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController(),
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
      child: MaterialApp(
        title: 'Scholarship Marketplace',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/auth': (context) => const AuthWrapper(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
