import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptex_malawi/services/app_state.dart';
import 'package:cryptex_malawi/theme/phoenix_theme.dart';

class SellUSDTPage extends StatefulWidget {
  @override
  _SellUSDTPageState createState() => _SellUSDTPageState();
}

class _SellUSDTPageState extends State<SellUSDTPage> {
  final _amountController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    return Scaffold(  // ADDED SCAFFOLD
      backgroundColor: PhoenixTheme.blackPrimary,
      appBar: AppBar(
        title: Text('Sell USDT'),
        backgroundColor: PhoenixTheme.blackSecondary,
      ),
      body: SingleChildScrollView(  // ADDED TO FIX OVERFLOW
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PhoenixTheme.greyDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PhoenixTheme.goldPrimary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Balance',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    '${appState.usdtBalance.toStringAsFixed(2)} USDT',
                    style: TextStyle(
                      color: PhoenixTheme.goldPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Enter Amount to Sell (USDT)',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '0.00',
                prefixIcon: Icon(Icons.currency_bitcoin, color: PhoenixTheme.goldPrimary),
                filled: true,
                fillColor: PhoenixTheme.greyDark,
              ),
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 16),
            if (_amountController.text.isNotEmpty) ...[
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
                        Text('USDT Amount:', style: TextStyle(color: Colors.grey)),
                        Text(
                          '${_amountController.text} USDT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('MWK Amount:', style: TextStyle(color: Colors.grey)),
                        Text(
                          'MWK ${((double.tryParse(_amountController.text) ?? 0) * appState.globalRate).toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Fee:', style: TextStyle(color: Colors.grey)),
                        Text(
                          'MWK ${appState.calculateFee((double.tryParse(_amountController.text) ?? 0) * appState.globalRate).toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Divider(color: PhoenixTheme.goldPrimary.withOpacity(0.3)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('You Receive:', style: TextStyle(color: PhoenixTheme.goldPrimary)),
                        Text(
                          'MWK ${(((double.tryParse(_amountController.text) ?? 0) * appState.globalRate) - appState.calculateFee((double.tryParse(_amountController.text) ?? 0) * appState.globalRate)).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: PhoenixTheme.goldPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final amount = double.tryParse(_amountController.text);
                    if (amount != null && amount > 0 && amount <= appState.usdtBalance) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Processing sale of $amount USDT'),
                          backgroundColor: PhoenixTheme.success,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Insufficient balance or invalid amount'),
                          backgroundColor: PhoenixTheme.error,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PhoenixTheme.error,
                  ),
                  child: Text('SELL USDT'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
