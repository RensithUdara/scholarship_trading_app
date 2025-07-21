import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.softWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(),
            
            // Content Sections
            Padding(
              padding: const EdgeInsets.all(UIConstants.paddingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppInfoSection(),
                  const SizedBox(height: UIConstants.paddingLG),
                  _buildMissionSection(),
                  const SizedBox(height: UIConstants.paddingLG),
                  _buildFeaturesSection(),
                  const SizedBox(height: UIConstants.paddingLG),
                  _buildTeamSection(),
                  const SizedBox(height: UIConstants.paddingLG),
                  _buildVersionInfoSection(),
                  const SizedBox(height: UIConstants.paddingLG),
                  _buildLegalSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UIConstants.paddingXL),
      decoration: BoxDecoration(
        gradient: AppColors.tealGradient,
      ),
      child: Column(
        children: [
          // App Logo/Icon
          Container(
            padding: const EdgeInsets.all(UIConstants.paddingLG),
            decoration: BoxDecoration(
              color: AppColors.softWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(UIConstants.radiusLG),
            ),
            child: Icon(
              Icons.school_outlined,
              size: 64,
              color: AppColors.softWhite,
            ),
          ),
          const SizedBox(height: UIConstants.paddingLG),
          
          Text(
            'Scholarship Trading',
            style: UIConstants.headingStyle.copyWith(
              fontSize: 28,
              color: AppColors.softWhite,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.paddingSM),
          
          Text(
            'Connecting Students with Educational Opportunities',
            style: UIConstants.bodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.softWhite.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return _buildSection(
      title: 'About Our App',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scholarship Trading is a revolutionary platform that bridges the gap between students who need financial aid and those who have unused scholarships. Our mission is to make higher education more accessible by creating a secure marketplace for scholarship opportunities.',
            style: UIConstants.bodyStyle.copyWith(
              height: 1.6,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: UIConstants.paddingMD),
          _buildStatCard('Active Users', '10,000+'),
          const SizedBox(height: UIConstants.paddingSM),
          _buildStatCard('Scholarships Traded', '2,500+'),
          const SizedBox(height: UIConstants.paddingSM),
          _buildStatCard('Total Value Traded', '\$5.2M+'),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    return _buildSection(
      title: 'Our Mission',
      content: Container(
        padding: const EdgeInsets.all(UIConstants.paddingLG),
        decoration: BoxDecoration(
          color: AppColors.teal.withOpacity(0.05),
          borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          border: Border.all(
            color: AppColors.teal.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: AppColors.teal,
              size: 48,
            ),
            const SizedBox(height: UIConstants.paddingMD),
            Text(
              'To democratize access to higher education by creating a transparent, secure, and efficient marketplace where unused scholarships can find deserving students.',
              style: UIConstants.bodyStyle.copyWith(
                fontSize: 16,
                height: 1.6,
                color: AppColors.darkGray,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      FeatureItem(
        icon: Icons.security,
        title: 'Secure Trading',
        description: 'Bank-level security with encrypted transactions',
      ),
      FeatureItem(
        icon: Icons.search,
        title: 'Smart Search',
        description: 'Advanced filters to find perfect scholarships',
      ),
      FeatureItem(
        icon: Icons.verified_user,
        title: 'Verified Listings',
        description: 'All scholarships are verified for authenticity',
      ),
      FeatureItem(
        icon: Icons.support_agent,
        title: '24/7 Support',
        description: 'Round-the-clock customer support',
      ),
    ];

    return _buildSection(
      title: 'Key Features',
      content: Column(
        children: features.map((feature) => _buildFeatureCard(feature)).toList(),
      ),
    );
  }

  Widget _buildTeamSection() {
    final teamMembers = [
      TeamMember(
        name: 'Sarah Johnson',
        role: 'CEO & Founder',
        description: 'Former scholarship recipient passionate about education access',
      ),
      TeamMember(
        name: 'Mike Chen',
        role: 'CTO',
        description: 'Tech veteran with 15+ years in fintech and edtech',
      ),
      TeamMember(
        name: 'Dr. Emily Rodriguez',
        role: 'Head of Student Success',
        description: 'Education expert ensuring positive student outcomes',
      ),
    ];

    return _buildSection(
      title: 'Our Team',
      content: Column(
        children: teamMembers.map((member) => _buildTeamMemberCard(member)).toList(),
      ),
    );
  }

  Widget _buildVersionInfoSection() {
    return _buildSection(
      title: 'Version Information',
      content: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusMD),
        ),
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.paddingLG),
          child: Column(
            children: [
              _buildInfoRow('App Version', '1.0.0'),
              const Divider(),
              _buildInfoRow('Build Number', '1'),
              const Divider(),
              _buildInfoRow('Last Updated', 'December 2024'),
              const Divider(),
              _buildInfoRow('Platform', 'Android & iOS'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return _buildSection(
      title: 'Legal & Privacy',
      content: Column(
        children: [
          _buildLegalCard(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            description: 'How we protect and use your data',
            onTap: () => _showLegalDocument(context, 'Privacy Policy'),
          ),
          const SizedBox(height: UIConstants.paddingSM),
          _buildLegalCard(
            context,
            icon: Icons.gavel_outlined,
            title: 'Terms of Service',
            description: 'Rules and guidelines for using our platform',
            onTap: () => _showLegalDocument(context, 'Terms of Service'),
          ),
          const SizedBox(height: UIConstants.paddingSM),
          _buildLegalCard(
            context,
            icon: Icons.policy_outlined,
            title: 'User Agreement',
            description: 'Your rights and responsibilities',
            onTap: () => _showLegalDocument(context, 'User Agreement'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: UIConstants.headingStyle.copyWith(
            fontSize: 20,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: UIConstants.paddingMD),
        content,
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.paddingMD,
        vertical: UIConstants.paddingSM,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(UIConstants.radiusSM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: UIConstants.bodyStyle.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
          Text(
            value,
            style: UIConstants.headingStyle.copyWith(
              fontSize: 16,
              color: AppColors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(FeatureItem feature) {
    return Card(
      margin: const EdgeInsets.only(bottom: UIConstants.paddingSM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMD),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(UIConstants.paddingSM),
          decoration: BoxDecoration(
            color: AppColors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(UIConstants.radiusSM),
          ),
          child: Icon(
            feature.icon,
            color: AppColors.teal,
          ),
        ),
        title: Text(
          feature.title,
          style: UIConstants.headingStyle.copyWith(
            fontSize: 16,
            color: AppColors.darkGray,
          ),
        ),
        subtitle: Text(
          feature.description,
          style: UIConstants.bodyStyle.copyWith(
            color: AppColors.mediumGray,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Card(
      margin: const EdgeInsets.only(bottom: UIConstants.paddingSM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMD),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.paddingMD),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.teal.withOpacity(0.1),
              child: Text(
                member.name.split(' ').map((n) => n[0]).join(),
                style: UIConstants.headingStyle.copyWith(
                  color: AppColors.teal,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: UIConstants.paddingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: UIConstants.headingStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Text(
                    member.role,
                    style: UIConstants.bodyStyle.copyWith(
                      color: AppColors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.description,
                    style: UIConstants.bodyStyle.copyWith(
                      color: AppColors.mediumGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: UIConstants.bodyStyle.copyWith(
            color: AppColors.mediumGray,
          ),
        ),
        Text(
          value,
          style: UIConstants.bodyStyle.copyWith(
            color: AppColors.darkGray,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLegalCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMD),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(UIConstants.paddingSM),
          decoration: BoxDecoration(
            color: AppColors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(UIConstants.radiusSM),
          ),
          child: Icon(
            icon,
            color: AppColors.teal,
          ),
        ),
        title: Text(
          title,
          style: UIConstants.headingStyle.copyWith(
            fontSize: 16,
            color: AppColors.darkGray,
          ),
        ),
        subtitle: Text(
          description,
          style: UIConstants.bodyStyle.copyWith(
            color: AppColors.mediumGray,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.mediumGray,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLegalDocument(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            'This is a placeholder for the $title document.\n\n'
            'In a real app, this would contain the complete legal document with all terms, conditions, and policies relevant to the $title.\n\n'
            'The document would be regularly updated to comply with current laws and regulations.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class TeamMember {
  final String name;
  final String role;
  final String description;

  TeamMember({
    required this.name,
    required this.role,
    required this.description,
  });
}
