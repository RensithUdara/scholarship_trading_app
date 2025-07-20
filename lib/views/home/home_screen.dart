import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/scholarship_controller.dart';
import '../../core/theme/app_colors.dart';
import '../scholarships/browse_scholarships_screen.dart';
import '../scholarships/my_scholarships_screen.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    final scholarshipController = Provider.of<ScholarshipController>(context, listen: false);
    await scholarshipController.loadScholarships();
  }

  List<Widget> _getScreens() {
    final authController = Provider.of<AuthController>(context);
    
    if (authController.isAdmin) {
      return [
        const BrowseScholarshipsScreen(),
        const AdminDashboardScreen(),
        const ProfileScreen(),
      ];
    } else if (authController.isSeller) {
      return [
        const BrowseScholarshipsScreen(),
        const MyScholarshipsScreen(),
        const ProfileScreen(),
      ];
    } else {
      // Buyer
      return [
        const BrowseScholarshipsScreen(),
        const ProfileScreen(),
      ];
    }
  }

  List<BottomNavigationBarItem> _getBottomNavItems() {
    final authController = Provider.of<AuthController>(context);
    
    if (authController.isAdmin) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else if (authController.isSeller) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'My Listings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else {
      // Buyer
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final screens = _getScreens();
    final navItems = _getBottomNavItems();
    
    // Adjust current index if needed for buyer (only 2 tabs)
    if (!authController.isSeller && !authController.isAdmin && _currentIndex > 1) {
      _currentIndex = 1;
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: navItems,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.teal,
        unselectedItemColor: AppColors.mediumGray,
        backgroundColor: AppColors.softWhite,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
