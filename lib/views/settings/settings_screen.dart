import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/routing/app_navigator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'CAD', 'AUD'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.softWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccountSection(context),
            const SizedBox(height: UIConstants.paddingLG),
            _buildNotificationSection(),
            const SizedBox(height: UIConstants.paddingLG),
            _buildAppearanceSection(),
            const SizedBox(height: UIConstants.paddingLG),
            _buildSecuritySection(),
            const SizedBox(height: UIConstants.paddingLG),
            _buildPreferencesSection(),
            const SizedBox(height: UIConstants.paddingLG),
            _buildSupportSection(context),
            const SizedBox(height: UIConstants.paddingLG),
            _buildDangerZone(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSection(
      title: 'Account',
      children: [
        _buildSettingsTile(
          icon: Icons.person_outline,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          onTap: () => AppNavigator.goToEditProfile(context),
        ),
        _buildSettingsTile(
          icon: Icons.history,
          title: 'Transaction History',
          subtitle: 'View your trading history',
          onTap: () => AppNavigator.goToTransactionHistory(context),
        ),
        _buildSettingsTile(
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          subtitle: 'Manage your payment options',
          onTap: () => _showComingSoonDialog(context, 'Payment Methods'),
        ),
        _buildSettingsTile(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Wallet',
          subtitle: 'View balance and transactions',
          onTap: () => _showComingSoonDialog(context, 'Wallet'),
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return _buildSection(
      title: 'Notifications',
      children: [
        _buildSwitchTile(
          icon: Icons.notifications_outlined,
          title: 'All Notifications',
          subtitle: 'Enable or disable all notifications',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
              if (!value) {
                _emailNotifications = false;
                _pushNotifications = false;
              }
            });
          },
        ),
        _buildSwitchTile(
          icon: Icons.email_outlined,
          title: 'Email Notifications',
          subtitle: 'Receive updates via email',
          value: _emailNotifications,
          enabled: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _emailNotifications = value;
            });
          },
        ),
        _buildSwitchTile(
          icon: Icons.push_pin_outlined,
          title: 'Push Notifications',
          subtitle: 'Receive push notifications',
          value: _pushNotifications,
          enabled: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _pushNotifications = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSection(
      title: 'Appearance',
      children: [
        _buildSwitchTile(
          icon: Icons.dark_mode_outlined,
          title: 'Dark Mode',
          subtitle: 'Switch to dark theme',
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
            _showComingSoonDialog(context, 'Dark Mode');
          },
        ),
        _buildDropdownTile(
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: 'Select app language',
          value: _selectedLanguage,
          items: _languages,
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value!;
            });
            _showComingSoonDialog(context, 'Language Change');
          },
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildSection(
      title: 'Security & Privacy',
      children: [
        _buildSwitchTile(
          icon: Icons.fingerprint_outlined,
          title: 'Biometric Authentication',
          subtitle: 'Use fingerprint or face ID',
          value: _biometricEnabled,
          onChanged: (value) {
            setState(() {
              _biometricEnabled = value;
            });
            _showComingSoonDialog(context, 'Biometric Authentication');
          },
        ),
        _buildSettingsTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: () => _showComingSoonDialog(context, 'Change Password'),
        ),
        _buildSettingsTile(
          icon: Icons.security_outlined,
          title: 'Two-Factor Authentication',
          subtitle: 'Add an extra layer of security',
          onTap: () => _showComingSoonDialog(context, 'Two-Factor Authentication'),
        ),
        _buildSettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Settings',
          subtitle: 'Control your privacy preferences',
          onTap: () => _showComingSoonDialog(context, 'Privacy Settings'),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: 'Preferences',
      children: [
        _buildDropdownTile(
          icon: Icons.attach_money_outlined,
          title: 'Currency',
          subtitle: 'Select preferred currency',
          value: _selectedCurrency,
          items: _currencies,
          onChanged: (value) {
            setState(() {
              _selectedCurrency = value!;
            });
          },
        ),
        _buildSettingsTile(
          icon: Icons.location_on_outlined,
          title: 'Location Services',
          subtitle: 'Manage location preferences',
          onTap: () => _showComingSoonDialog(context, 'Location Services'),
        ),
        _buildSettingsTile(
          icon: Icons.backup_outlined,
          title: 'Data Backup',
          subtitle: 'Backup your data to cloud',
          onTap: () => _showComingSoonDialog(context, 'Data Backup'),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSection(
      title: 'Support & Information',
      children: [
        _buildSettingsTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () => AppNavigator.goToHelp(context),
        ),
        _buildSettingsTile(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'App version and information',
          onTap: () => AppNavigator.goToAbout(context),
        ),
        _buildSettingsTile(
          icon: Icons.feedback_outlined,
          title: 'Send Feedback',
          subtitle: 'Share your thoughts with us',
          onTap: () => _showComingSoonDialog(context, 'Send Feedback'),
        ),
        _buildSettingsTile(
          icon: Icons.star_outline,
          title: 'Rate App',
          subtitle: 'Rate us on the app store',
          onTap: () => _showRatingDialog(context),
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return _buildSection(
      title: 'Danger Zone',
      children: [
        _buildSettingsTile(
          icon: Icons.logout,
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          textColor: AppColors.error,
          onTap: () => _showSignOutDialog(context),
        ),
        _buildSettingsTile(
          icon: Icons.delete_forever_outlined,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          textColor: AppColors.error,
          onTap: () => _showDeleteAccountDialog(context),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: UIConstants.paddingSM),
          child: Text(
            title,
            style: UIConstants.headingStyle.copyWith(
              fontSize: 18,
              color: AppColors.teal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: UIConstants.paddingSM),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(UIConstants.paddingSM),
        decoration: BoxDecoration(
          color: (textColor ?? AppColors.teal).withOpacity(0.1),
          borderRadius: BorderRadius.circular(UIConstants.radiusSM),
        ),
        child: Icon(
          icon,
          color: textColor ?? AppColors.teal,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: UIConstants.headingStyle.copyWith(
          fontSize: 16,
          color: textColor ?? AppColors.darkGray,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: UIConstants.bodyStyle.copyWith(
          color: AppColors.mediumGray,
          fontSize: 13,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.mediumGray,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(UIConstants.paddingSM),
        decoration: BoxDecoration(
          color: AppColors.teal.withOpacity(enabled ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(UIConstants.radiusSM),
        ),
        child: Icon(
          icon,
          color: AppColors.teal.withOpacity(enabled ? 1.0 : 0.5),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: UIConstants.headingStyle.copyWith(
          fontSize: 16,
          color: AppColors.darkGray.withOpacity(enabled ? 1.0 : 0.5),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: UIConstants.bodyStyle.copyWith(
          color: AppColors.mediumGray.withOpacity(enabled ? 1.0 : 0.5),
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: AppColors.teal,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(UIConstants.paddingSM),
        decoration: BoxDecoration(
          color: AppColors.teal.withOpacity(0.1),
          borderRadius: BorderRadius.circular(UIConstants.radiusSM),
        ),
        child: Icon(
          icon,
          color: AppColors.teal,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: UIConstants.headingStyle.copyWith(
          fontSize: 16,
          color: AppColors.darkGray,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: UIConstants.bodyStyle.copyWith(
              color: AppColors.mediumGray,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.paddingSM,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(UIConstants.radiusSM),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isDense: true,
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: UIConstants.bodyStyle.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Our App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How would you rate your experience?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thanks for rating us ${index + 1} star${index == 0 ? '' : 's'}!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.star,
                    color: AppColors.gold,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              AppNavigator.goToAuth(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Signed out successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: AppColors.error),
        ),
        content: const Text(
          'This action is permanent and cannot be undone. All your data will be permanently deleted.\n\nAre you sure you want to delete your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Account deletion requested. This feature will be implemented soon.'),
                  backgroundColor: AppColors.warning,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
