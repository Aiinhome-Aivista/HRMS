import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Log custom event
  static Future<void> logEvent(String name, Map<String, Object>? params) async {
    await _analytics.logEvent(name: name, parameters: params);
  }

  // Track Screen view
  static Future<void> logScreen(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }

  // login event
  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }
}
