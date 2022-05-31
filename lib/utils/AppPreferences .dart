// ignore_for_file: non_constant_identifier_names, file_names

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _singleton = AppPreferences._internal();

  factory AppPreferences() {
    return _singleton;
  }
  AppPreferences._internal();

  static SharedPreferences _preferences =
      SharedPreferences.getInstance() as SharedPreferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    print("INITIALISATION DES PREFERENCES TERMINE.");
  }

  // Affiche toutes les clés existantes dans le stockage local.
  static void getAllKeysDebugConsole() {
    _preferences.getKeys().map((key) => print(key)).toString();
  }

// ----------------------------------------------------------------------
// Getter and Setter for local stored variables
// ----------------------------------------------------------------------

// Get/Set userRole
  String get userRole => _preferences.getString("userRole") ?? "";

  set userRole(String value) {
    _preferences.setString("userRole", value);
  }

  // Get/Set login_access_token
  String get login_access_token =>
      _preferences.getString("login_access_token") ?? "";

  set login_access_token(String value) {
    _preferences.setString("login_access_token", value);
  }

  // Get/Set login_refresh_token
  String get login_refresh_token =>
      _preferences.getString("login_refresh_token") ?? "";

  set login_refresh_token(String value) {
    _preferences.setString("login_refresh_token", value);
  }

  // Get/Set userEmail
  String get userEmail => _preferences.getString("userEmail") ?? "";

  set userEmail(String value) {
    _preferences.setString("userEmail", value);
  }

  // Get/Set userPasswordHash
  String get userPasswordHash =>
      _preferences.getString("userPasswordHash") ?? "";

  set userPasswordHash(String value) {
    _preferences.setString("userPasswordHash", value);
  }

  // Get/Set introductionScreensDisplayed
  String get introductionScreensDisplayed =>
      _preferences.getString("introductionScreensDisplayed") ?? "";

  set introductionScreensDisplayed(String value) {
    _preferences.setString("introductionScreensDisplayed", value);
  }

  // Get/Set lowDataConsumption
  String get lowDataConsumption =>
      _preferences.getString("lowDataConsumption") ?? "non";

  set lowDataConsumption(String value) {
    _preferences.setString("lowDataConsumption", value);
  }
}
