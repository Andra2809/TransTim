import 'dart:convert';

import 'package:get/get.dart';

import '../helper/common_helper.dart';
import '../helper/snack_bar_utils.dart';

class ApiProvider extends GetConnect {
  static const _defaultTimeout = Duration(seconds: 30);

  static Future<Map<String, String>> _getHeaders() async {
    return {'Accept': 'application/json'};
  }

  // Method to handle GET requests
  static Future<dynamic> getMethod({
    required String url,
    bool isAuthenticationRequired = false,
  }) async {
    return _handleRequest(
      method: 'GET',
      url: url,
      isAuthenticationRequired: isAuthenticationRequired,
    );
  }

  // Method to handle POST requests
  static Future<dynamic> postMethod({
    required String url,
    bool isAuthenticationRequired = false,
    Map<String, dynamic>? obj,
    bool hideSnackBars = false,
  }) async {
    return _handleRequest(
      method: 'POST',
      url: url,
      isAuthenticationRequired: isAuthenticationRequired,
      body: obj,
      hideSnackBars: hideSnackBars,
    );
  }

  // Method to handle PUT requests
  static Future<dynamic> putMethod({
    required String url,
    bool isAuthenticationRequired = true,
    Map<String, dynamic>? obj,
    bool hideSnackBars = false,
  }) async {
    return _handleRequest(
      method: 'PUT',
      url: url,
      isAuthenticationRequired: isAuthenticationRequired,
      body: obj,
      hideSnackBars: hideSnackBars,
    );
  }

  //Method to handle DELETE requests
  static Future<dynamic> deleteMethod({
    required String url,
    bool isAuthenticationRequired = false,
    bool hideSnackBars = false,
  }) async {
    return _handleRequest(
      method: 'DELETE',
      url: url,
      isAuthenticationRequired: isAuthenticationRequired,
      hideSnackBars: hideSnackBars,
    );
  }

  // Unified request handler for different HTTP methods
  static Future<dynamic> _handleRequest({
    required String method,
    required String url,
    bool isAuthenticationRequired = false,
    Map<String, dynamic>? body,
    bool hideSnackBars = false,
  }) async {
    GetConnect getConnect = GetConnect();
    getConnect.timeout = _defaultTimeout;

    Response response;
    switch (method) {
      case 'GET':
        response = isAuthenticationRequired
            ? await getConnect.get(url, headers: await _getHeaders())
            : await getConnect.get(url);
        break;
      case 'POST':
        response = isAuthenticationRequired
            ? await getConnect.post(url, body, headers: await _getHeaders())
            : await getConnect.post(url, body);
        break;
      case 'PUT':
        response = isAuthenticationRequired
            ? await getConnect.put(url, body, headers: await _getHeaders())
            : await getConnect.put(url, body);
        break;
      case 'DELETE':
        response = isAuthenticationRequired
            ? await getConnect.delete(url, headers: await _getHeaders())
            : await getConnect.delete(url);
        break;
      default:
        throw Exception('Unsupported HTTP method');
    }

    return _processResponse(response, hideSnackBars: hideSnackBars);
  }

  // Response processing logic extracted for reuse
  static Future<dynamic> _processResponse(Response response, {bool hideSnackBars = false}) async {
    List<dynamic> jsonResponse = [];
    if (response.status.connectionError) {
      if (!hideSnackBars) {
        SnackBarUtils.errorSnackBar(
          title: 'Connection Timeout',
          message: 'Check your internet connection',
        );
      }
      throw Exception('Connection error handled');
    } else if (response.unauthorized) {
      _navigateToLogin();
    } else if (!response.status.hasError) {
      jsonResponse.add(_sanitizeAndDecode(response.bodyString));
    } else {
      jsonResponse.add(response.body);
    }
    return jsonResponse;
  }

  // Utility function to sanitize and decode JSON response
  static dynamic _sanitizeAndDecode(String? jsonStr) {
    if (jsonStr == null) return {};
    String sanitizedJson = jsonStr.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    return json.decode(sanitizedJson);
  }

static Future<List<dynamic>> updateResource({
  required String url,
  required bool isAuthenticationRequired,
  Map<String, dynamic>? requestBody,
  bool? hideSnackBars,
}) async {
  List<dynamic> responsePayload = [];
  GetConnect connector = GetConnect();
  connector.timeout = const Duration(seconds: 30);

  final response = await connector.put(
    url,
    requestBody,
    headers: isAuthenticationRequired ? await _getHeaders() : null,
  );

  // Debugging information
  CommonHelper.printDebug("URL: $url\nRequest Body: ${requestBody.toString()}");
  CommonHelper.printDebug("Response Body: ${response.bodyString}");

  if (response.status.connectionError) {
    if (hideSnackBars != true) {
      SnackBarUtils.errorSnackBar(
        title: 'Connection Error',
        message: 'Please check your internet connection and try again.',
      );
    }
  } else if (response.unauthorized) {
    _navigateToLogin();
  } else if (!response.status.hasError) {
    dynamic responseData = response.body;
    String? apiStatus = responseData["status"];

    if (apiStatus != null) {
      var statusMap = {"api_status": apiStatus};
      if (responseData["Data"] != null) {
        responsePayload = responseData["Data"].map((item) {
          return item..putIfAbsent("api_status", () => apiStatus);
        }).toList();
      } else {
        responsePayload.add(statusMap);
      }
    } else {
      responsePayload.add(responseData);
    }
  }

  return responsePayload;
}


  static void _navigateToLogin() {}
}
