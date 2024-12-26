import 'dart:convert';
import 'dart:io';
import 'package:hrms/connection/api_connection.dart';

class ApiService {
  final PostApiConnection _postApiConnection = PostApiConnection();
  final GetApiConnection _getApiConnection = GetApiConnection();
}

class POST_API {
  final ApiService _apiService = ApiService();

  // Login API
  Future<Map<String, dynamic>> login(String email, String password) async {
    final String url = _apiService._postApiConnection.loginapi;

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

  // location API
  Future<Map<String, dynamic>> location(String employee_id, String pincode,
      String city, String state, String latitude, String longitude) async {
    final String url = _apiService._postApiConnection.locationApi;

    try {
// Create an HttpClient instance
      HttpClient httpClient = HttpClient();

      // Create a POST request
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");

      // Add body parameters
      final Map<String, String> body = {
        'Employee_Id': employee_id,
        'PinCode': pincode,
        'City': city,
        'State': state,
        'Latitude': latitude,
        'Longitude': longitude,
      };
      print("Encoded body : ${Uri(queryParameters: body).query}");
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
        print(
            "location api call failed with status code ${response.statusCode}");
        return {
          'status': false,
          'message': 'Failed with status code ${response.statusCode}',
        };
      }
    } catch (e, stackTrace) {
      print("Error during location API call: $e");
      print("Stack Trace: $stackTrace");
      return {
        'status': false,
        'message': 'Error: $e',
      };
    }
  }
}

class GET_API {
  final ApiService _apiService = ApiService();

  // Fetch attendance data
  Future<Map<String, dynamic>> getAttendance(String employeeId) async {
    final String url =
        '${_apiService._getApiConnection.attandenceGetApi}?employee_id=$employeeId';

    try {
      // Create an HttpClient instance
      HttpClient httpClient = HttpClient();

      // Create a GET request
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

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
