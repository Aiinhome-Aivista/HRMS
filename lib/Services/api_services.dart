import 'dart:convert';
import 'dart:io';
import 'package:hrms/connection/api_connection.dart';

class ApiService {
  final PostApiConnection _apiConnection = PostApiConnection();
}

class POST_API {
  final ApiService _apiService = ApiService();

  // Login API
  Future<Map<String, dynamic>> login(String email, String password) async {
    final String url = _apiService._apiConnection.loginapi;

    try {
      // Create an HttpClient instance
      HttpClient httpClient = HttpClient();

      // Create a POST request
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");

      // Add body parameters
      final Map<String, String> body = {
        'customer_email': email,
        'customer_password': password,
      };
      request.write(Uri(queryParameters: body).query);

      // Send the request
      HttpClientResponse response = await request.close();

      // Check the response status
      if (response.statusCode == 200) {
        // Read and decode the response
        final String responseBody =
            await response.transform(utf8.decoder).join();
        return json.decode(responseBody);
      } else {
        return {
          'status': false,
          'message': 'Failed with status code ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Error: $e',
      };
    }
  }
}

class GET_API {
  final ApiService _apiService = ApiService();
}
