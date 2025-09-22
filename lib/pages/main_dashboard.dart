import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptex_malawi/services/app_state.dart';
import 'package:cryptex_malawi/theme/phoenix_theme.dart';
// Use your existing pages
import 'package:cryptex_malawi/pages/wallet/buy_usdt.dart';
import 'package:cryptex_malawi/pages/wallet/sell_usdt.dart';
import 'package:cryptex_malawi/pages/wallet/recharge_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/withdraw_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/wallet_page.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_history_page.dart';

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
          IconButton(
            icon: Icon(Icons.logout, color: PhoenixTheme.goldPrimary),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home Tab
          _buildHomeTab(appState),
          
          // Trade Tab
          _buildTradeTab(appState),
          
          // Wallet Tab
          _buildWalletTab(appState),
          
          // Profile Tab
          _buildProfileTab(appState),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: PhoenixTheme.blackSecondary,
        selectedItemColor: PhoenixTheme.goldPrimary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Trade'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
  
  // HOME TAB
  Widget _buildHomeTab(AppState appState) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceCard(appState),
          SizedBox(height: 24),
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
          _buildMarketInfo(appState),
          SizedBox(height: 24),
          _buildRecentTransactions(appState),
        ],
      ),
    );
  }
  
  // TRADE TAB
  Widget _buildTradeTab(AppState appState) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: PhoenixTheme.greyDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: PhoenixTheme.goldPrimary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'Live Rate',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  'MWK ${appState.globalRate.toStringAsFixed(0)}/USDT',
                  style: TextStyle(
                    color: PhoenixTheme.goldPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BuyUSDTPage()),
              ),
              icon: Icon(Icons.add_circle),
              label: Text('BUY USDT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PhoenixTheme.success,
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SellUSDTPage()),
              ),
              icon: Icon(Icons.remove_circle),
              label: Text('SELL USDT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PhoenixTheme.error,
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Active Merchants',
            style: TextStyle(
              color: PhoenixTheme.goldPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...List.generate(3, (index) => _merchantCard(index)),
        ],
      ),
    );
  }
  
  // WALLET TAB
  Widget _buildWalletTab(AppState appState) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBalanceCard(appState),
          SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.history, color: PhoenixTheme.goldPrimary),
            title: Text('Transaction History', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TransactionHistoryPage()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add_circle, color: Colors.green),
            title: Text('Recharge MWK', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RechargePage()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.remove_circle, color: Colors.orange),
            title: Text('Withdraw MWK', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WithdrawPage()),
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: PhoenixTheme.greyDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Transactions', style: TextStyle(color: Colors.grey)),
                    Text('${appState.transactions.length}', style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Volume', style: TextStyle(color: Colors.grey)),
                    Text('MWK 0', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // PROFILE TAB
  Widget _buildProfileTab(AppState appState) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: PhoenixTheme.goldPrimary,
            child: Icon(Icons.person, size: 50, color: PhoenixTheme.blackPrimary),
          ),
          SizedBox(height: 16),
          Text(
            'Demo User',
            style: TextStyle(
              color: PhoenixTheme.goldPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'demo@cryptex.mw',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),
          if (appState.canApplyForMerchant)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PhoenixTheme.goldPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PhoenixTheme.goldPrimary),
              ),
              child: Column(
                children: [
                  Text(
                    'Become a Merchant',
                    style: TextStyle(
                      color: PhoenixTheme.goldPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You qualify! Your balance is over \$100',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => appState.applyForMerchant(),
                    child: Text('Apply Now'),
                  ),
                ],
              ),
            ),
          SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.verified_user, color: PhoenixTheme.goldPrimary),
            title: Text('KYC Verification', style: TextStyle(color: Colors.white)),
            subtitle: Text('Not Verified', style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
          ListTile(
            leading: Icon(Icons.security, color: PhoenixTheme.goldPrimary),
            title: Text('Security Settings', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
          ListTile(
            leading: Icon(Icons.support, color: PhoenixTheme.goldPrimary),
            title: Text('Support', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
          ListTile(
            leading: Icon(Icons.info, color: PhoenixTheme.goldPrimary),
            title: Text('About', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
        ],
      ),
    );
  }
  
  Widget _merchantCard(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PhoenixTheme.greyDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PhoenixTheme.goldPrimary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: PhoenixTheme.goldPrimary,
            child: Text('M${index + 1}', style: TextStyle(color: PhoenixTheme.blackPrimary)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Merchant ${index + 1}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Rate: MWK 1820/USDT', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Min: \$10 - Max: \$1000', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: PhoenixTheme.success.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('ONLINE', style: TextStyle(color: PhoenixTheme.success, fontSize: 10)),
          ),
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
          'Recharge',
          Icons.account_balance_wallet,
          Colors.blue,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => RechargePage())),
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
