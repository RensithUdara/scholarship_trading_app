import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/auth/auth_wrapper.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/signup_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/search/scholarship_search_screen.dart';
import '../../views/scholarships/scholarship_detail_screen.dart';
import '../../views/settings/settings_screen.dart';
import '../../views/help/help_screen.dart';
import '../../views/about/about_screen.dart';
import '../../views/profile/edit_profile_screen.dart';
import '../../views/transactions/transaction_history_screen.dart';
import '../../models/scholarship_filter.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      redirect: (BuildContext context, GoRouterState state) {
        final authController = Provider.of<AuthController>(context, listen: false);
        final isLoggedIn = authController.isSignedIn;
        final isLoading = authController.isLoading;

        // Show splash while loading
        if (isLoading) {
          return '/';
        }

        // Redirect to auth if not logged in and trying to access protected routes
        if (!isLoggedIn && !_isPublicRoute(state.matchedLocation)) {
          return '/auth';
        }

        // Redirect to home if logged in and trying to access auth routes
        if (isLoggedIn && _isAuthRoute(state.matchedLocation)) {
          return '/home';
        }

        return null; // No redirect needed
      },
      routes: [
        // Splash Screen
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Authentication Routes
        GoRoute(
          path: '/auth',
          name: 'auth',
          builder: (context, state) => const AuthWrapper(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),

        // Main App Routes
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),

        // Search Routes
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) {
            final query = state.uri.queryParameters['q'];
            final categoryFilter = state.uri.queryParameters['category'];
            
            ScholarshipFilter? filter;
            if (categoryFilter != null) {
              filter = ScholarshipFilter(category: categoryFilter);
            }

            return ScholarshipSearchScreen(
              initialQuery: query,
              initialFilter: filter,
            );
          },
        ),

        // Scholarship Detail Routes
        GoRoute(
          path: '/scholarship/:id',
          name: 'scholarshipDetail',
          builder: (context, state) {
            final scholarshipId = state.pathParameters['id']!;
            return ScholarshipDetailScreen(
              scholarshipId: scholarshipId,
            );
          },
        ),

        // Profile & Settings Routes
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/transactions',
          name: 'transactions',
          builder: (context, state) => const _PlaceholderScreen(title: 'Transaction History'),
        ),
        GoRoute(
          path: '/transaction-history',
          name: 'transactionHistory',
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          path: '/edit-profile',
          name: 'editProfile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/help',
          name: 'help',
          builder: (context, state) => const HelpScreen(),
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          builder: (context, state) => const AboutScreen(),
        ),

        // Seller Routes (placeholder for future implementation)
        GoRoute(
          path: '/sell',
          name: 'sell',
          builder: (context, state) => const _PlaceholderScreen(title: 'Sell Scholarship'),
        ),
        GoRoute(
          path: '/my-scholarships',
          name: 'myScholarships',
          builder: (context, state) => const _PlaceholderScreen(title: 'My Scholarships'),
        ),

        // Chat Routes (placeholder for future implementation)
        GoRoute(
          path: '/chat',
          name: 'chat',
          builder: (context, state) => const _PlaceholderScreen(title: 'Chat'),
        ),
        GoRoute(
          path: '/chat/:id',
          name: 'chatDetail',
          builder: (context, state) {
            final chatId = state.pathParameters['id']!;
            return _PlaceholderScreen(title: 'Chat: $chatId');
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Page Not Found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.matchedLocation}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _isPublicRoute(String location) {
    const publicRoutes = ['/', '/auth', '/login', '/signup'];
    return publicRoutes.contains(location);
  }

  static bool _isAuthRoute(String location) {
    const authRoutes = ['/auth', '/login', '/signup'];
    return authRoutes.contains(location);
  }
}

// Placeholder screen for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'This feature is coming soon!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
