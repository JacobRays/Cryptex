import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptex_malawi/services/app_state.dart';
import 'package:cryptex_malawi/theme/phoenix_theme.dart';

class BuyUSDTPage extends StatefulWidget {
  @override
  _BuyUSDTPageState createState() => _BuyUSDTPageState();
}

class _BuyUSDTPageState extends State<BuyUSDTPage> {
  final _amountController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    return Scaffold(  // ADDED SCAFFOLD
      backgroundColor: PhoenixTheme.blackPrimary,
      appBar: AppBar(
        title: Text('Buy USDT'),
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
                    'Current Rate',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    'MWK ${appState.globalRate.toStringAsFixed(0)} = 1 USDT',
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
              'Enter Amount (USDT)',
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
                        Text('Total:', style: TextStyle(color: PhoenixTheme.goldPrimary)),
                        Text(
                          'MWK ${(((double.tryParse(_amountController.text) ?? 0) * appState.globalRate) + appState.calculateFee((double.tryParse(_amountController.text) ?? 0) * appState.globalRate)).toStringAsFixed(2)}',
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
                    if (amount != null && amount > 0) {
                      // For now, just show success
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Processing purchase of $amount USDT'),
                          backgroundColor: PhoenixTheme.success,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('BUY USDT'),
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
