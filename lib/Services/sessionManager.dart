import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // Save user
  static Future<void> saveUser({
    required String name,
    required String email,
    required String empId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('SaveUserName', name);
    await prefs.setString('SaveUserEmail', email);
    await prefs.setString('employeeId', empId);
  }

  // Get user
  static Future<String?> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('employeeId');
  }

  // Check login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('employeeId') != null;
  }

  // Logout (SAFE 🔥)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // ❌ remove only auth data
    await prefs.remove('SaveUserName');
    await prefs.remove('SaveUserEmail');
    await prefs.remove('employeeId');

    // ✅ reminder stays untouched
  }
}