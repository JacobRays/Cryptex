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
              builder = (_) => WalletOverview();
              break;
            case '/wallet/buy':
              builder = (_) => BuyUSDTPage();
              break;
            case '/wallet/sell':
              builder = (_) => SellUSDTPage();
              break;
            case '/wallet/preview':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              builder = (_) => TransactionPreview(
                    party: args['party'] ?? 'MerchantX',
                    amountUsdt: args['amountUsdt'] ?? 100,
                    amountMwk: args['amountMwk'] ?? 182000,
                    baseRate: args['baseRate'] ?? 1800,
                    merchantRate: args['merchantRate'] ?? 1820,
                    fees: args['fees'] ?? 1500,
                  );
              break;
            case '/wallet/history':
              builder = (_) => TransactionHistoryPage();
              break;
            case '/wallet/recharge':
              builder = (_) => RechargePage();
              break;
            case '/wallet/withdraw':
              builder = (_) => WithdrawPage();
              break;
            case '/wallet/manual-bank':
              builder = (_) => ManualBankWithdrawalPage();
              break;
            default:
              builder = (_) => WalletOverview(); // Default fallback
          }

          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}
