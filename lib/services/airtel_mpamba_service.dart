import 'dart:convert';
import 'package:http/http.dart' as http;

class AirtelMpambaService {
  static const _airtelBase = "https://api.airtel.africa";
  static const _mpambaBase = "https://api.mpamba.mw";

  static Future<bool> airtelCollect({
    required String phone,
    required double amountMWK,
  }) async {
    final res = await http.post(
      Uri.parse("$_airtelBase/collect"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone": phone,
        "amount": amountMWK,
      }),
    );
    return res.statusCode == 200;
  }

  static Future<bool> mpambaCollect({
    required String phone,
    required double amountMWK,
  }) async {
    final res = await http.post(
      Uri.parse("$_mpambaBase/collect"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone": phone,
        "amount": amountMWK,
      }),
    );
    return res.statusCode == 200;
  }

  static Future<bool> airtelPayout({
    required String phone,
    required double amountMWK,
  }) async {
    return true; // TODO
  }

  static Future<bool> mpambaPayout({
    required String phone,
    required double amountMWK,
  }) async {
    return true; // TODO
  }
}
