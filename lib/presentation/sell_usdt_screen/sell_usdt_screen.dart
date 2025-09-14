import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/kwacha_calculation_widget.dart';
import './widgets/merchant_card_widget.dart';
import './widgets/rate_lock_timer_widget.dart';
import './widgets/transaction_preview_modal.dart';
import './widgets/transaction_progress_widget.dart';
import './widgets/usdt_balance_widget.dart';

class SellUsdtScreen extends StatefulWidget {
  const SellUsdtScreen({Key? key}) : super(key: key);

  @override
  State<SellUsdtScreen> createState() => _SellUsdtScreenState();
}

class _SellUsdtScreenState extends State<SellUsdtScreen>
    with TickerProviderStateMixin {
  final TextEditingController _sellAmountController = TextEditingController();
  final PageController _pageController = PageController();

  // Mock user data
  double _usdtBalance = 1250.75;
  double _sellAmount = 0.0;
  double _exchangeRate = 1650.0; // MWK per USDT
  double _merchantFee = 25.0; // MWK
  double _networkFee = 15.0; // MWK

  // State management
  int _currentPage = 0;
  Map<String, dynamic>? _selectedMerchant;
  String _selectedPaymentMethod = 'Airtel Money';
  bool _isRateLocked = false;
  int _rateLockTimer = 60;
  String _transactionStep = 'secured';

  // Mock merchants data
  final List<Map<String, dynamic>> _merchants = [
    {
      "id": 1,
      "name": "CryptoTrader MW",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "buyRate": 1650.0,
      "processingTime": 5,
      "reliabilityScore": 4.8,
      "status": "online",
    },
    {
      "id": 2,
      "name": "Digital Exchange",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "buyRate": 1645.0,
      "processingTime": 8,
      "reliabilityScore": 4.6,
      "status": "online",
    },
    {
      "id": 3,
      "name": "FastCash Malawi",
      "avatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "buyRate": 1655.0,
      "processingTime": 3,
      "reliabilityScore": 4.9,
      "status": "busy",
    },
    {
      "id": 4,
      "name": "Secure Crypto",
      "avatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
      "buyRate": 1640.0,
      "processingTime": 10,
      "reliabilityScore": 4.4,
      "status": "offline",
    },
  ];

  @override
  void initState() {
    super.initState();
    _sellAmountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _sellAmountController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    final String text = _sellAmountController.text;
    final double amount = double.tryParse(text) ?? 0.0;

    if (amount != _sellAmount) {
      setState(() {
        _sellAmount = amount;
        if (_isRateLocked && amount == 0) {
          _isRateLocked = false;
        }
      });
    }
  }

  void _handleAmountChanged(String value) {
    final double amount = double.tryParse(value) ?? 0.0;
    setState(() {
      _sellAmount = amount;
    });
  }

  void _selectMerchant(Map<String, dynamic> merchant) {
    if ((merchant['status'] as String).toLowerCase() != 'online') return;

    setState(() {
      _selectedMerchant = merchant;
      _exchangeRate = merchant['buyRate'] as double;
      _isRateLocked = true;
      _rateLockTimer = 60;
    });

    _startRateLockTimer();
  }

  void _startRateLockTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isRateLocked && _rateLockTimer > 0) {
        setState(() {
          _rateLockTimer--;
        });
        _startRateLockTimer();
      } else if (mounted && _rateLockTimer <= 0) {
        setState(() {
          _isRateLocked = false;
          _selectedMerchant = null;
        });
      }
    });
  }

  void _showTransactionPreview() {
    if (_selectedMerchant == null || _sellAmount <= 0) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionPreviewModal(
        usdtAmount: _sellAmount,
        kwachaAmount: _sellAmount * _exchangeRate,
        merchantFee: _merchantFee,
        networkFee: _networkFee,
        selectedMerchant: _selectedMerchant!,
        selectedPaymentMethod: _selectedPaymentMethod,
        onConfirm: _confirmTransaction,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _confirmTransaction() {
    Navigator.pop(context); // Close modal
    setState(() {
      _currentPage = 1;
      _transactionStep = 'secured';
    });
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _simulateTransactionProgress();
  }

  void _simulateTransactionProgress() {
    // Simulate transaction steps
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _transactionStep = 'processing';
        });
      }
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _transactionStep = 'initiated';
        });
      }
    });

    Future.delayed(const Duration(seconds: 12), () {
      if (mounted) {
        setState(() {
          _transactionStep = 'completed';
          _usdtBalance -= _sellAmount; // Update balance
        });
      }
    });
  }

  void _cancelTransaction() {
    setState(() {
      _currentPage = 0;
      _transactionStep = 'secured';
      _isRateLocked = false;
      _selectedMerchant = null;
    });
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goBackToSelling() {
    setState(() {
      _currentPage = 0;
      _transactionStep = 'secured';
      _sellAmount = 0.0;
      _sellAmountController.clear();
      _isRateLocked = false;
      _selectedMerchant = null;
    });
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _currentPage == 0 ? 'Sell USDT' : 'Transaction Status',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () {
            if (_currentPage == 1) {
              _goBackToSelling();
            } else {
              Navigator.pop(context);
            }
          },
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (_currentPage == 0)
            IconButton(
              onPressed: () {
                // Navigate to transaction history or help
              },
              icon: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildSellPage(),
          _buildTransactionProgressPage(),
        ],
      ),
    );
  }

  Widget _buildSellPage() {
    final List<Map<String, dynamic>> onlineMerchants = _merchants
        .where((merchant) =>
            (merchant['status'] as String).toLowerCase() == 'online')
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // USDT Balance and Amount Input
          UsdtBalanceWidget(
            usdtBalance: _usdtBalance,
            sellAmountController: _sellAmountController,
            onAmountChanged: _handleAmountChanged,
          ),

          // Kwacha Calculation
          if (_sellAmount > 0)
            KwachaCalculationWidget(
              sellAmount: _sellAmount,
              exchangeRate: _exchangeRate,
              merchantFee: _merchantFee,
              networkFee: _networkFee,
            ),

          // Rate Lock Timer
          if (_isRateLocked && _selectedMerchant != null)
            RateLockTimerWidget(
              remainingSeconds: _rateLockTimer,
              onTimerExpired: () {
                setState(() {
                  _isRateLocked = false;
                  _selectedMerchant = null;
                });
              },
            ),

          // Available Merchants Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Merchants',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${onlineMerchants.length} Online',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getSuccessColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Merchants List
          if (_merchants.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'person_off',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No merchants available',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Please try again later or check your connection',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Column(
              children: _merchants.map((merchant) {
                final bool isSelected = _selectedMerchant != null &&
                    _selectedMerchant!['id'] == merchant['id'];

                return MerchantCardWidget(
                  merchant: merchant,
                  isSelected: isSelected,
                  onTap: () => _selectMerchant(merchant),
                );
              }).toList(),
            ),

          SizedBox(height: 4.h),

          // Payment Method Selection
          if (_sellAmount > 0 && _selectedMerchant != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Payment Method',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  _buildPaymentMethodTile('Airtel Money', 'phone_android'),
                  Divider(
                    height: 1,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                  _buildPaymentMethodTile('Mpamba', 'account_balance_wallet'),
                ],
              ),
            ),
            SizedBox(height: 4.h),
          ],

          // Confirm Button
          if (_sellAmount > 0 && _selectedMerchant != null && _isRateLocked)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ElevatedButton(
                onPressed: _showTransactionPreview,
                style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
                child: Text('Preview Transaction'),
              ),
            ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String method, String iconName) {
    final bool isSelected = _selectedPaymentMethod == method;

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
      title: Text(
        method,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: Radio<String>(
        value: method,
        groupValue: _selectedPaymentMethod,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedPaymentMethod = value;
            });
          }
        },
      ),
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
    );
  }

  Widget _buildTransactionProgressPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TransactionProgressWidget(
            currentStep: _transactionStep,
            onCancel: _cancelTransaction,
          ),
          if (_transactionStep == 'completed') ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.getSuccessColor().withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.getSuccessColor(),
                    size: 64,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Transaction Successful!',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.getSuccessColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'You have successfully sold ${_sellAmount.toStringAsFixed(2)} USDT',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Rate merchant functionality
                          },
                          child: Text('Rate Merchant'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _goBackToSelling,
                          child: Text('Sell More'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
