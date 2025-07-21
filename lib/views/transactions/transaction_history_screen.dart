import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/ui_constants.dart';
import '../../utils/date_formatter.dart';
import '../../utils/currency_formatter.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    setState(() {
      _transactions = [
        Transaction(
          id: '1',
          type: TransactionType.purchase,
          scholarshipTitle: 'MIT Engineering Scholarship',
          amount: 15000.0,
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: '2',
          type: TransactionType.sale,
          scholarshipTitle: 'Harvard Business Scholarship',
          amount: 25000.0,
          date: DateTime.now().subtract(const Duration(days: 5)),
          status: TransactionStatus.pending,
        ),
        Transaction(
          id: '3',
          type: TransactionType.refund,
          scholarshipTitle: 'Stanford CS Scholarship',
          amount: 20000.0,
          date: DateTime.now().subtract(const Duration(days: 10)),
          status: TransactionStatus.completed,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.softWhite,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Purchases'),
            Tab(text: 'Sales'),
          ],
          indicatorColor: AppColors.softWhite,
          labelColor: AppColors.softWhite,
          unselectedLabelColor: AppColors.lightGray,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(_transactions),
                _buildTransactionList(_transactions.where((t) => 
                    t.type == TransactionType.purchase).toList()),
                _buildTransactionList(_transactions.where((t) => 
                    t.type == TransactionType.sale).toList()),
              ],
            ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.lightGray,
            ),
            const SizedBox(height: UIConstants.paddingMD),
            Text(
              'No transactions found',
              style: UIConstants.headingStyle.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
            const SizedBox(height: UIConstants.paddingSM),
            Text(
              'Your transaction history will appear here',
              style: UIConstants.bodyStyle.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(UIConstants.paddingMD),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: UIConstants.paddingMD),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMD),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(UIConstants.paddingSM),
                  decoration: BoxDecoration(
                    color: _getTransactionTypeColor(transaction.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(UIConstants.radiusSM),
                  ),
                  child: Icon(
                    _getTransactionTypeIcon(transaction.type),
                    color: _getTransactionTypeColor(transaction.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: UIConstants.paddingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.scholarshipTitle,
                        style: UIConstants.headingStyle.copyWith(
                          fontSize: 16,
                          color: AppColors.darkGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getTransactionTypeText(transaction.type),
                        style: UIConstants.bodyStyle.copyWith(
                          color: _getTransactionTypeColor(transaction.type),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.format(transaction.amount),
                      style: UIConstants.headingStyle.copyWith(
                        fontSize: 16,
                        color: _getAmountColor(transaction.type),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UIConstants.paddingSM,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(transaction.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(UIConstants.radiusXS),
                      ),
                      child: Text(
                        _getStatusText(transaction.status),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(transaction.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: UIConstants.paddingMD),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.mediumGray,
                ),
                const SizedBox(width: UIConstants.paddingSM),
                Text(
                  DateFormatter.formatDateTime(transaction.date),
                  style: UIConstants.captionStyle.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: ${transaction.id}',
                  style: UIConstants.captionStyle.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTransactionTypeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return Icons.shopping_cart_outlined;
      case TransactionType.sale:
        return Icons.sell_outlined;
      case TransactionType.refund:
        return Icons.refresh_outlined;
    }
  }

  Color _getTransactionTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return AppColors.info;
      case TransactionType.sale:
        return AppColors.success;
      case TransactionType.refund:
        return AppColors.warning;
    }
  }

  String _getTransactionTypeText(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return 'Purchase';
      case TransactionType.sale:
        return 'Sale';
      case TransactionType.refund:
        return 'Refund';
    }
  }

  Color _getAmountColor(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
      case TransactionType.refund:
        return AppColors.error;
      case TransactionType.sale:
        return AppColors.success;
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return AppColors.warning;
      case TransactionStatus.completed:
        return AppColors.success;
      case TransactionStatus.failed:
        return AppColors.error;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }
}

// Models
class Transaction {
  final String id;
  final TransactionType type;
  final String scholarshipTitle;
  final double amount;
  final DateTime date;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.type,
    required this.scholarshipTitle,
    required this.amount,
    required this.date,
    required this.status,
  });
}

enum TransactionType {
  purchase,
  sale,
  refund,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
}
