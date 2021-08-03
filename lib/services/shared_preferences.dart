import 'dart:async';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumberPreferences {
  static late SharedPreferences _preferences;

  static const _keyNumberPhone = 'numberPhone';
  static const _keyaddress = 'address';
  static const _keyLatTarget = 'latTarget';
  static const _keyLonTarget = 'lonTarget';
  static const _keyStringSMS  = 'gpsDataList';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();
  
  static deleteData() async => await _preferences.clear();

  static Future setNumberPhone(String numberPhone) async =>
    await _preferences.setString(_keyNumberPhone, numberPhone);
  static String? getNumberPhone() => _preferences.getString(_keyNumberPhone);

  static Future setaddress(String address) async =>
    await _preferences.setString(_keyaddress, address);
  static String? getaddress() => _preferences.getString(_keyaddress);

  static Future setLatTarget(double latTarget) async =>
    await _preferences.setDouble(_keyLatTarget, latTarget);
  static double? getLatTarget() => _preferences.getDouble(_keyLatTarget);

  static Future setLonTarget(double lonTarget) async =>
    await _preferences.setDouble(_keyLonTarget, lonTarget);
  static double? getLonTarget() => _preferences.getDouble(_keyLonTarget);

  static Future setGpsDataList(List<String> gpsDataList) async =>
    await _preferences.setStringList(_keyStringSMS, gpsDataList);

  static List<String>? getGpsDataList() => _preferences.getStringList(_keyStringSMS);
}
