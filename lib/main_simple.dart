import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'controllers/auth_controller.dart';
import 'controllers/scholarship_controller.dart';
import 'controllers/payment_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/report_controller.dart';
import 'core/theme/app_colors.dart';
import 'views/auth/auth_screen.dart';
import 'views/home/home_screen.dart';
import 'utils/debug_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  DebugHelper.logDebug('Main', 'Firebase initialized, starting app...');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(),
        ),
        ChangeNotifierProxyProvider<AuthController, ScholarshipController>(
          create: (context) => ScholarshipController(
            authController: Provider.of<AuthController>(context, listen: false),
          ),
          update: (context, authController, previousController) =>
              previousController ?? ScholarshipController(authController: authController),
        ),
        ChangeNotifierProxyProvider<AuthController, PaymentController>(
          create: (context) => PaymentController(
            authController: Provider.of<AuthController>(context, listen: false),
          ),
          update: (context, authController, previousController) =>
              previousController ?? PaymentController(authController: authController),
        ),
        ChangeNotifierProxyProvider<AuthController, ChatController>(
          create: (context) => ChatController(
            authController: Provider.of<AuthController>(context, listen: false),
          ),
          update: (context, authController, previousController) =>
              previousController ?? ChatController(authController: authController),
        ),
        ChangeNotifierProxyProvider<AuthController, ReportController>(
          create: (context) => ReportController(
            authController: Provider.of<AuthController>(context, listen: false),
          ),
          update: (context, authController, previousController) =>
              previousController ?? ReportController(authController: authController),
        ),
      ],
      child: MaterialApp(
        title: 'Scholarship Trading App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        DebugHelper.logDebug('AuthWrapper', 'Building with auth state: isSignedIn=${authController.isSignedIn}');
        
        if (authController.isSignedIn) {
          DebugHelper.logDebug('AuthWrapper', 'User signed in, showing HomeScreen');
          return const HomeScreen();
        } else {
          DebugHelper.logDebug('AuthWrapper', 'User not signed in, showing AuthScreen');
          return const AuthScreen();
        }
      },
    );
  }
}
