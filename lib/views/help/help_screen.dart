import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.softWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Support Card
            _buildContactSupportCard(context),
            const SizedBox(height: UIConstants.paddingLG),
            
            // FAQ Section
            Text(
              'Frequently Asked Questions',
              style: UIConstants.headingStyle.copyWith(
                fontSize: 20,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: UIConstants.paddingMD),
            
            _buildFAQSection(),
            const SizedBox(height: UIConstants.paddingLG),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: UIConstants.headingStyle.copyWith(
                fontSize: 20,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: UIConstants.paddingMD),
            
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupportCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMD),
      ),
      child: Container(
        padding: const EdgeInsets.all(UIConstants.paddingLG),
        decoration: BoxDecoration(
          gradient: AppColors.tealGradient,
          borderRadius: BorderRadius.circular(UIConstants.radiusMD),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(UIConstants.paddingMD),
                  decoration: BoxDecoration(
                    color: AppColors.softWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(UIConstants.radiusMD),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    color: AppColors.softWhite,
                    size: 32,
                  ),
                ),
                const SizedBox(width: UIConstants.paddingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need Help?',
                        style: UIConstants.headingStyle.copyWith(
                          color: AppColors.softWhite,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Our support team is here 24/7',
                        style: UIConstants.bodyStyle.copyWith(
                          color: AppColors.softWhite.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: UIConstants.paddingLG),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showContactDialog(context, 'Live Chat'),
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('Live Chat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softWhite,
                      foregroundColor: AppColors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: UIConstants.paddingMD),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showContactDialog(context, 'Email Support'),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Email'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.softWhite,
                      side: BorderSide(color: AppColors.softWhite),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      FAQItem(
        question: 'How do I buy a scholarship?',
        answer: 'To buy a scholarship, browse through available scholarships, select one that matches your criteria, and complete the purchase process through our secure payment system.',
      ),
      FAQItem(
        question: 'How can I sell my scholarship?',
        answer: 'You can list your scholarship for sale by going to the "Sell" section, providing all required details, and setting your asking price. Once approved, it will be visible to potential buyers.',
      ),
      FAQItem(
        question: 'What payment methods are accepted?',
        answer: 'We accept major credit cards, bank transfers, and digital payment platforms. All transactions are processed securely through our payment partners.',
      ),
      FAQItem(
        question: 'How long does the transfer process take?',
        answer: 'Scholarship transfers typically take 3-5 business days once all documentation is verified and payment is confirmed.',
      ),
      FAQItem(
        question: 'Can I get a refund?',
        answer: 'Refunds are available within 7 days of purchase if the scholarship transfer has not been completed. Please refer to our refund policy for more details.',
      ),
      FAQItem(
        question: 'Is my personal information secure?',
        answer: 'Yes, we use industry-standard encryption and security measures to protect your personal and financial information.',
      ),
    ];

    return Column(
      children: faqs.map((faq) => _buildFAQCard(faq)).toList(),
    );
  }

  Widget _buildFAQCard(FAQItem faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: UIConstants.paddingMD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMD),
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: UIConstants.headingStyle.copyWith(
            fontSize: 16,
            color: AppColors.darkGray,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(UIConstants.paddingMD),
            child: Text(
              faq.answer,
              style: UIConstants.bodyStyle.copyWith(
                color: AppColors.mediumGray,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        _buildActionCard(
          context,
          icon: Icons.report_problem_outlined,
          title: 'Report an Issue',
          description: 'Report problems or technical issues',
          onTap: () => _showContactDialog(context, 'Report Issue'),
        ),
        const SizedBox(height: UIConstants.paddingMD),
        _buildActionCard(
          context,
          icon: Icons.feedback_outlined,
          title: 'Send Feedback',
          description: 'Share your suggestions and feedback',
          onTap: () => _showContactDialog(context, 'Send Feedback'),
        ),
        const SizedBox(height: UIConstants.paddingMD),
        _buildActionCard(
          context,
          icon: Icons.description_outlined,
          title: 'Terms & Conditions',
          description: 'Read our terms and privacy policy',
          onTap: () => _showTermsDialog(context),
        ),
        const SizedBox(height: UIConstants.paddingMD),
        _buildActionCard(
          context,
          icon: Icons.star_outline,
          title: 'Rate Our App',
          description: 'Help us improve with your rating',
          onTap: () => _showRatingDialog(context),
        ),
      ],
    );
  }

  Widget _buildActionCard(
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

  void _showContactDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(type),
        content: Text('This will open the $type feature. This is a placeholder for the actual implementation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'This is a placeholder for the Terms & Conditions.\n\n'
            'In a real app, this would contain:\n'
            '• Terms of Service\n'
            '• Privacy Policy\n'
            '• User Agreement\n'
            '• Refund Policy\n'
            '• And other legal documents',
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
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
