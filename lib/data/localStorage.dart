import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

List<String> localStorageKey = [];

void setData(String key, dynamic data) async {
  String jsonString;
  if (data is bool) {
    jsonString = jsonEncode(data);
  } else {
    jsonString = jsonEncode(data);
  }
  await secureStorage.write(key: key, value: jsonString);
}

Future<void> setSessionExpired(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('session_expired', value);
}

bool matchLocalStorageKey(String value) {
  return localStorageKey.contains(value);
}

Future<dynamic> getData(String value) async {
  dynamic extractData;
  String? jsonString = await secureStorage.read(key: value);
  if (jsonString != null && jsonString.isNotEmpty) {
    extractData = jsonDecode(jsonString);
  } else {
    //print("data not available");
    extractData = [];
  }
  return extractData;
}

Future<bool> getBoolData(String value) async {
  dynamic extractData;
  String? jsonString = await secureStorage.read(key: value);
  if (jsonString != null && jsonString.isNotEmpty) {
    if (jsonString == 'true') {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
  return extractData;
}

void cleareData(String key) async {
  await secureStorage.delete(key: key);
}

void cleareAllData() async {
  await secureStorage.deleteAll();
}

void deleteAllDataOnUninstall() async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('first_run') ?? true) {
    await secureStorage.deleteAll();

    prefs.setBool('first_run', false);
  }
}

void allStorageValue() async {
  // Read all key-value pairs
  Map<String, String> allData = await secureStorage.readAll();

  // Print all key-value pairs
  allData.forEach((key, value) {
    print('======localStorage========$key: $value');
  });
}

//set string data to secure storage
void setStringData(String key, String data) async {
  await secureStorage.write(key: key, value: data);
}

//get string data from secure stroge
Future<String?> getStringData(String value) async {
  String? jsonString = await secureStorage.read(key: value);

  return jsonString;
}
