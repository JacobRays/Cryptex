import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/neon.dart';
import '../../widgets/app_scaffold.dart';
import 'wallet_overview.dart';
import 'buy_usdt.dart';
import 'sell_usdt.dart';
import 'transaction_history.dart';
import 'recharge.dart';
import 'withdraw.dart';
import 'manual_bank_withdrawal.dart';
import 'transaction_preview_page.dart';

class WalletPage extends StatefulWidget {
  WalletPage({Key? key}) : super(key: key);
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "My Wallet",
      body: Navigator(
        initialRoute: '/wallet/overview',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/wallet/overview':
            default:
              builder = (BuildContext _) => const WalletOverview();
              break;
            case '/wallet/buy':
              builder = (BuildContext _) => const BuyUSDTPage();
              break;
            case '/wallet/sell':
              builder = (BuildContext _) => const SellUSDTPage();
              break;
            case '/wallet/history':
              builder = (BuildContext _) => const TransactionHistoryPage();
              break;
            case '/wallet/recharge':
              builder = (BuildContext _) => const RechargePage();
              break;
            case '/wallet/withdraw':
              builder = (BuildContext _) => const WithdrawPage();
              break;
            case '/wallet/manual-bank':
              builder = (BuildContext _) => const ManualBankWithdrawalPage();
              break;
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}
