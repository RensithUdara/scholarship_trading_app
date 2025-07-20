import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/scholarship_controller.dart';
import '../../controllers/report_controller.dart';
import '../../core/theme/app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reportController = Provider.of<ReportController>(context, listen: false);
      final scholarshipController = Provider.of<ScholarshipController>(context, listen: false);
      
      // Load initial data
      reportController.loadAllReports();
      scholarshipController.loadScholarships();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.gold,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Scholarships', icon: Icon(Icons.school)),
            Tab(text: 'Reports', icon: Icon(Icons.report)),
            Tab(text: 'Users', icon: Icon(Icons.people)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildScholarshipsTab(),
          _buildReportsTab(),
          _buildUsersTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer2<ReportController, ScholarshipController>(
      builder: (context, reportController, scholarshipController, child) {
        final reportStats = reportController.getReportStatistics();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Quick Stats Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    'Total Scholarships',
                    '${scholarshipController.scholarships.length}',
                    Icons.school,
                    AppColors.teal,
                  ),
                  _buildStatCard(
                    'Pending Approval',
                    '0', // Temporarily hardcoded until method is implemented
                    Icons.pending,
                    AppColors.gold,
                  ),
                  _buildStatCard(
                    'Open Reports',
                    '${reportStats['open'] ?? 0}',
                    Icons.report_problem,
                    AppColors.coral,
                  ),
                  _buildStatCard(
                    'Active Users',
                    '0',
                    Icons.people,
                    AppColors.teal,
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _tabController.animateTo(1),
                      icon: const Icon(Icons.approval),
                      label: const Text('Review Scholarships'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _tabController.animateTo(2),
                      icon: const Icon(Icons.report_problem),
                      label: const Text('Handle Reports'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScholarshipsTab() {
    return Consumer<ScholarshipController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final pendingScholarships = controller.scholarships.where((s) => s.status == 'pending').toList();

        if (pendingScholarships.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green),
                SizedBox(height: 16),
                Text('No pending scholarships'),
                Text('All scholarships have been reviewed'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pendingScholarships.length,
          itemBuilder: (context, index) {
            final scholarship = pendingScholarships[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.gold,
                  child: const Icon(Icons.school, color: Colors.white),
                ),
                title: Text(scholarship.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: \$${scholarship.price.toStringAsFixed(2)}'),
                    Text('Seller ID: ${scholarship.sellerId}'),
                    Text('Category: ${scholarship.category}'),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'approve',
                      child: const Text('Approve'),
                    ),
                    PopupMenuItem(
                      value: 'reject',
                      child: const Text('Reject'),
                    ),
                    PopupMenuItem(
                      value: 'details',
                      child: const Text('View Details'),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'approve':
                        _approveScholarship(scholarship.id);
                        break;
                      case 'reject':
                        _rejectScholarship(scholarship.id);
                        break;
                      case 'details':
                        // Navigate to details
                        break;
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReportsTab() {
    return Consumer<ReportController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final openReports = controller.pendingReports;

        if (openReports.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green),
                SizedBox(height: 16),
                Text('No open reports'),
                Text('All reports have been handled'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: openReports.length,
          itemBuilder: (context, index) {
            final report = openReports[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.coral,
                  child: Text(report.getTypeIcon()),
                ),
                title: Text(report.reportType),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reason: ${report.reason}'),
                    Text('Reporter: ${report.reporterName}'),
                    Text('Created: ${report.getTimeAgo()}'),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'investigate',
                      child: const Text('Start Investigation'),
                    ),
                    PopupMenuItem(
                      value: 'resolve',
                      child: const Text('Resolve'),
                    ),
                    PopupMenuItem(
                      value: 'details',
                      child: const Text('View Details'),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'investigate':
                        _startInvestigation(report.id);
                        break;
                      case 'resolve':
                        _resolveReport(report.id);
                        break;
                      case 'details':
                        // Navigate to details
                        break;
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUsersTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64),
          SizedBox(height: 16),
          Text('User Management'),
          Text('Coming soon...'),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _approveScholarship(String scholarshipId) async {
    // TODO: Implement scholarship approval
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scholarship approval feature coming soon')),
    );
  }

  void _rejectScholarship(String scholarshipId) async {
    // TODO: Implement scholarship rejection  
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scholarship rejection feature coming soon')),
    );
  }

  void _startInvestigation(String reportId) async {
    final controller = Provider.of<ReportController>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);
    
    final success = await controller.startInvestigation(
      reportId: reportId,
      adminId: authController.currentUser?.id ?? '',
    );
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Investigation started')),
      );
    }
  }

  void _resolveReport(String reportId) async {
    final controller = Provider.of<ReportController>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);
    
    final success = await controller.resolveReport(
      reportId: reportId,
      adminId: authController.currentUser?.id ?? '',
      resolution: 'Issue has been resolved',
    );
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report resolved successfully')),
      );
    }
  }
}
