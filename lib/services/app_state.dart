import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isLoading = false;
  double _exchangeRate = 1750.0; // Default MWK per USDT
  
  bool get isLoading => _isLoading;
  double get exchangeRate => _exchangeRate;

  void updateExchangeRate(double newRate) {
    _exchangeRate = newRate;
    notifyListeners();
  }
}