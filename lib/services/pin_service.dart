import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  static final PinService _instance = PinService._internal();
  factory PinService() => _instance;
  PinService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _pinHashKey = 'crypt_pin_hash';

  Future<void> setPin(String pin) async {
    final hash = _hash(pin);
    await _storage.write(key: _pinHashKey, value: hash);
  }

  Future<bool> hasPin() async {
    final v = await _storage.read(key: _pinHashKey);
    return v != null;
  }

  Future<bool> verifyPin(String pin) async {
    final stored = await _storage.read(key: _pinHashKey);
    if (stored == null) return false;
    final hash = _hash(pin);
    return stored == hash;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _pinHashKey);
  }

  String _hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
