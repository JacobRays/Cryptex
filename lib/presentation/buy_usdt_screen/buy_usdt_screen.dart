import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amount_input_widget.dart';
import './widgets/merchant_card_widget.dart';
import './widgets/payment_method_selector.dart';
import './widgets/transaction_preview_sheet.dart';
import './widgets/transaction_progress_widget.dart';

class BuyUsdtScreen extends StatefulWidget {
  const BuyUsdtScreen({Key? key}) : super(key: key);

  @override
  State<BuyUsdtScreen> createState() => _BuyUsdtScreenState();
}

class _BuyUsdtScreenState extends State<BuyUsdtScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _usdtController = TextEditingController();
  final TextEditingController _kwachaController = TextEditingController();

  String? _selectedMerchant;
  String? _selectedPaymentMethod;
  String _transactionStatus =
      'idle'; // idle, preview, payment, progress, complete
  bool _isLoading = false;

  // Mock data
  final Map<String, dynamic> _userWallet = {
    'kwachaBalance': 25000.0,
    'usdtBalance': 150.25,
  };

  final List<Map<String, dynamic>> _merchants = [
    {
      'id': 'merchant_1',
      'name': 'CryptoTrader MW',
      'status': 'online',
      'exchangeRate': 1650.0,
      'rating': 4.8,
      'completedTrades': 1247,
      'responseTime': '2 mins',
      'fee': 25.0,
    },
    {
      'id': 'merchant_2',
      'name': 'Digital Exchange Pro',
      'status': 'online',
      'exchangeRate': 1645.0,
      'rating': 4.9,
      'completedTrades': 892,
      'responseTime': '1 min',
      'fee': 30.0,
    },
    {
      'id': 'merchant_3',
      'name': 'Malawi Crypto Hub',
      'status': 'busy',
      'exchangeRate': 1655.0,
      'rating': 4.7,
      'completedTrades': 2156,
      'responseTime': '5 mins',
      'fee': 20.0,
    },
    {
      'id': 'merchant_4',
      'name': 'Swift USDT Exchange',
      'status': 'online',
      'exchangeRate': 1640.0,
      'rating': 4.6,
      'completedTrades': 567,
      'responseTime': '3 mins',
      'fee': 35.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    _usdtController.dispose();
    _kwachaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _transactionStatus == 'progress'
                    ? _buildProgressView()
                    : _buildMainContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buy USDT',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Purchase cryptocurrency with mobile money',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (_transactionStatus == 'progress')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.getWarningColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.getWarningColor().withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'In Progress',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.getWarningColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWalletBalance(),
          _buildAmountInputs(),
          _buildMerchantSelection(),
          if (_selectedMerchant != null) _buildActionButton(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildProgressView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          TransactionProgressWidget(
            currentStatus: 'payment_pending',
            onCancel: _cancelTransaction,
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildWalletBalance() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Wallet Balance',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Available funds for trading',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'MWK Balance',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'MWK ${_userWallet['kwachaBalance'].toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'USDT Balance',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${_userWallet['usdtBalance'].toStringAsFixed(2)} USDT',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.getSuccessColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInputs() {
    return Column(
      children: [
        AmountInputWidget(
          controller: _usdtController,
          label: 'Amount to Buy',
          currency: 'USDT',
          onChanged: _onUsdtAmountChanged,
        ),
        SizedBox(height: 2.h),
        AmountInputWidget(
          controller: _kwachaController,
          label: 'You Will Pay',
          currency: 'MWK',
          isReadOnly: true,
        ),
        if (_selectedMerchant != null) _buildCalculationDetails(),
      ],
    );
  }

  Widget _buildCalculationDetails() {
    final merchant = _merchants.firstWhere((m) => m['id'] == _selectedMerchant);
    final usdtAmount = double.tryParse(_usdtController.text) ?? 0.0;
    final exchangeRate = merchant['exchangeRate'] as double;
    final fee = merchant['fee'] as double;
    final subtotal = usdtAmount * exchangeRate;
    final total = subtotal + fee;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calculate',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Calculation Breakdown',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildCalculationRow(
              'USDT Amount', '${usdtAmount.toStringAsFixed(2)} USDT'),
          _buildCalculationRow(
              'Exchange Rate', 'MWK ${exchangeRate.toStringAsFixed(2)}'),
          _buildCalculationRow(
              'Subtotal', 'MWK ${subtotal.toStringAsFixed(2)}'),
          _buildCalculationRow(
              'Transaction Fee', 'MWK ${fee.toStringAsFixed(2)}'),
          Divider(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.2)),
          _buildCalculationRow(
              'Total Amount', 'MWK ${total.toStringAsFixed(2)}',
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: isTotal
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantSelection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Merchant',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _merchants.length,
            itemBuilder: (context, index) {
              final merchant = _merchants[index];
              return MerchantCardWidget(
                merchant: merchant,
                isSelected: _selectedMerchant == merchant['id'],
                onTap: () => _selectMerchant(merchant['id']),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final usdtAmount = double.tryParse(_usdtController.text) ?? 0.0;
    final bool canProceed = usdtAmount > 0 && _selectedMerchant != null;

    return Container(
      margin: EdgeInsets.all(4.w),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canProceed && !_isLoading ? _showTransactionPreview : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          backgroundColor: AppTheme.lightTheme.primaryColor,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Preview Purchase',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _onUsdtAmountChanged(String value) {
    final usdtAmount = double.tryParse(value) ?? 0.0;
    if (_selectedMerchant != null) {
      final merchant =
          _merchants.firstWhere((m) => m['id'] == _selectedMerchant);
      final exchangeRate = merchant['exchangeRate'] as double;
      final fee = merchant['fee'] as double;
      final total = (usdtAmount * exchangeRate) + fee;
      _kwachaController.text = total.toStringAsFixed(2);
    }
  }

  void _selectMerchant(String merchantId) {
    setState(() {
      _selectedMerchant = merchantId;
    });
    HapticFeedback.lightImpact();
    _onUsdtAmountChanged(_usdtController.text);
  }

  void _showTransactionPreview() {
    final merchant = _merchants.firstWhere((m) => m['id'] == _selectedMerchant);
    final usdtAmount = double.tryParse(_usdtController.text) ?? 0.0;
    final exchangeRate = merchant['exchangeRate'] as double;
    final fee = merchant['fee'] as double;
    final total = (usdtAmount * exchangeRate) + fee;

    final transactionData = {
      'usdtAmount': usdtAmount.toStringAsFixed(2),
      'totalAmount': total.toStringAsFixed(2),
      'exchangeRate': exchangeRate.toStringAsFixed(2),
      'fee': fee.toStringAsFixed(2),
      'estimatedTime': merchant['responseTime'],
      'merchantName': merchant['name'],
      'merchantRating': merchant['rating'],
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionPreviewSheet(
        transactionData: transactionData,
        onConfirm: _confirmTransaction,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _confirmTransaction() {
    Navigator.pop(context); // Close preview sheet
    _showPaymentMethodSelection();
  }

  void _showPaymentMethodSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            PaymentMethodSelector(
              selectedMethod: _selectedPaymentMethod,
              onMethodSelected: (method) {
                setState(() {
                  _selectedPaymentMethod = method;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _selectedPaymentMethod != null ? _processPayment : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                  child: Text(
                    'Proceed to Payment',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _processPayment() {
    Navigator.pop(context); // Close payment method sheet
    setState(() {
      _transactionStatus = 'progress';
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      // This would normally integrate with actual mobile money APIs
      _showPaymentSuccess();
    });
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor().withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.getSuccessColor().withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.getSuccessColor(),
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Transaction Successful!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.getSuccessColor(),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Your USDT purchase has been completed successfully. The funds will be available in your wallet shortly.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to previous screen
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
                child: Text(
                  'Back to Dashboard',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelTransaction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        title: Text(
          'Cancel Transaction',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this transaction? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep Transaction',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              setState(() {
                _transactionStatus = 'idle';
                _selectedMerchant = null;
                _selectedPaymentMethod = null;
                _usdtController.clear();
                _kwachaController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getErrorColor(),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Cancel Transaction',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
