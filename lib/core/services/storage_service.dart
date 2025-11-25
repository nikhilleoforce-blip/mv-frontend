import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // String operations
  static Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }
  
  static String? getString(String key) {
    return _prefs!.getString(key);
  }
  
  // Integer operations
  static Future<bool> setInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }
  
  static int? getInt(String key) {
    return _prefs!.getInt(key);
  }
  
  // Boolean operations
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }
  
  static bool? getBool(String key) {
    return _prefs!.getBool(key);
  }
  
  // Object operations (JSON)
  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    return await _prefs!.setString(key, jsonEncode(value));
  }
  
  static Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefs!.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }
  
  // Remove operations
  static Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }
  
  static Future<bool> clear() async {
    return await _prefs!.clear();
  }
  
  static bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }
}
