import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptex_malawi/services/app_state.dart';
import 'package:cryptex_malawi/theme/phoenix_theme.dart';
import 'package:cryptex_malawi/pages/trading/buy_usdt_page.dart';
import 'package:cryptex_malawi/pages/trading/sell_usdt_page.dart';
import 'package:cryptex_malawi/pages/wallet/deposit_page.dart';
import 'package:cryptex_malawi/pages/wallet/withdraw_page.dart';
import 'package:cryptex_malawi/pages/merchant/merchant_list_page.dart';
import 'package:cryptex_malawi/pages/admin/admin_panel.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    return Scaffold(
      backgroundColor: PhoenixTheme.blackPrimary,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.diamond, color: PhoenixTheme.goldPrimary),
            SizedBox(width: 8),
            Text('CRYPTEX MALAWI'),
          ],
        ),
        actions: [
          if (appState.isAdmin)
            IconButton(
              icon: Icon(Icons.admin_panel_settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AdminPanel()),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            _buildBalanceCard(appState),
            SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                color: PhoenixTheme.goldPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildQuickActions(context, appState),
            SizedBox(height: 24),
            
            // Market Info
            _buildMarketInfo(appState),
            SizedBox(height: 24),
            
            // Recent Transactions
            _buildRecentTransactions(appState),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: PhoenixTheme.blackSecondary,
        selectedItemColor: PhoenixTheme.goldPrimary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Trade'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
  
  Widget _buildBalanceCard(AppState appState) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [PhoenixTheme.goldPrimary, PhoenixTheme.goldSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: PhoenixTheme.goldPrimary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: PhoenixTheme.blackPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appState.usdtBalance.toStringAsFixed(2)} USDT',
                    style: TextStyle(
                      color: PhoenixTheme.blackPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'MWK ${(appState.usdtBalance * appState.globalRate).toStringAsFixed(0)}',
                    style: TextStyle(
                      color: PhoenixTheme.blackPrimary.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'MWK Balance',
                    style: TextStyle(
                      color: PhoenixTheme.blackPrimary.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'MWK ${appState.mwkBalance.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: PhoenixTheme.blackPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (appState.canApplyForMerchant) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => appState.applyForMerchant(),
              style: ElevatedButton.styleFrom(
                backgroundColor: PhoenixTheme.blackPrimary,
                foregroundColor: PhoenixTheme.goldPrimary,
              ),
              child: Text('Apply to Become Merchant'),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildQuickActions(BuildContext context, AppState appState) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _actionCard(
          context,
          'Buy USDT',
          Icons.add_circle,
          PhoenixTheme.success,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => BuyUSDTPage())),
        ),
        _actionCard(
          context,
          'Sell USDT',
          Icons.remove_circle,
          PhoenixTheme.error,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => SellUSDTPage())),
        ),
        _actionCard(
          context,
          'Deposit',
          Icons.account_balance_wallet,
          Colors.blue,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => DepositPage())),
        ),
        _actionCard(
          context,
          'Withdraw',
          Icons.money_off,
          Colors.orange,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => WithdrawPage())),
        ),
      ],
    );
  }
  
  Widget _actionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: PhoenixTheme.greyDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMarketInfo(AppState appState) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PhoenixTheme.greyDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PhoenixTheme.goldPrimary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market Information',
            style: TextStyle(
              color: PhoenixTheme.goldPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem('Current Rate', 'MWK ${appState.globalRate.toStringAsFixed(0)}/USDT'),
              _infoItem('Active Merchants', '${appState.merchants.length}'),
              _infoItem('Fee', '${appState.feePercentage}%'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecentTransactions(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: TextStyle(
            color: PhoenixTheme.goldPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        if (appState.transactions.isEmpty)
          Center(
            child: Text(
              'No transactions yet',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...appState.transactions.take(5).map((tx) => _transactionItem(tx)),
      ],
    );
  }
  
  Widget _transactionItem(Map<String, dynamic> tx) {
    final isBuy = tx['type'] == 'BUY';
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PhoenixTheme.greyDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isBuy ? Icons.arrow_downward : Icons.arrow_upward,
            color: isBuy ? PhoenixTheme.success : PhoenixTheme.error,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tx['type']} ${tx['usdtAmount']} USDT',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'MWK ${tx['mwkAmount']}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            tx['status'],
            style: TextStyle(
              color: tx['status'] == 'COMPLETED' ? PhoenixTheme.success : Colors.orange,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
