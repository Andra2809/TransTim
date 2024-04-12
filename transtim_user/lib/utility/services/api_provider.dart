import 'dart:convert';

import 'package:get/get.dart';

import '../helper/common_helper.dart';
import '../helper/snack_bar_utils.dart';

class ApiProvider extends GetConnect {
  static Future<Map<String, String>> _getHeaders() async {
    return {'Accept': 'application/json'};
  }

  static Future<dynamic> getMethod({
    required String url,
    bool? isAuthenticationRequired,
  }) async {
    CommonHelper.printDebug("Get Called on url : $url");
    List<dynamic> jsonResponse = [];
    GetConnect getConnect = GetConnect();
    getConnect.timeout = const Duration(seconds: 30);
    Response response;
    response = isAuthenticationRequired == true
        ? await getConnect.get(url, headers: await _getHeaders())
        : await getConnect.get(url);
    jsonResponse = [];
    CommonHelper.printDebug(url);
    CommonHelper.printDebug(response.bodyString);
    if (response.status.connectionError) {
      SnackBarUtils.errorSnackBar(
        title: 'Connection Timeout',
        message: 'Check your internet connection',
      );
      throw Exception('Handled');
    } else if (response.unauthorized) {
      _navigateToLogin();
    } else if (!response.status.hasError) {
      // Map data = response.body;
      String? sanitizedJson =
          response.bodyString?.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> data = json.decode(sanitizedJson.toString());
      String? status = data["status"]?.toString();
      if (status != null) {
        Map<String, dynamic> statusMap = {"api_status": status};
        if (data["Data"] != null) {
          for (int i = 0; i < data["Data"].length; i++) {
            Map<String, dynamic> maps = data["Data"][i];
            maps.update("api_status", (existingValue) => status, ifAbsent: () {
              maps.addIf(!maps.containsKey("api_status"), "api_status", status);
            });
            maps.update("api_status", (value) => status);
            jsonResponse.add(maps);
          }
        } else {
          jsonResponse.add(statusMap);
        }
      } else {
        jsonResponse.add(data);
      }
      return jsonResponse;
    } else {
      Map data = response.body;
      CommonHelper.printDebug(data);
      jsonResponse.add(data);
    }
    return jsonResponse;
  }

  static Future<dynamic> postMethod({
    required String url,
    bool? isAuthenticationRequired,
    Map<String, dynamic>? obj,
    bool? hideSnackBars,
  }) async {
    List<dynamic> jsonResponse = [];
    GetConnect getConnect = GetConnect();
    getConnect.timeout = const Duration(seconds: 30);
    final response = isAuthenticationRequired == true
        ? await getConnect.post(url, obj, headers: await _getHeaders())
        : await getConnect.post(url, obj);
    CommonHelper.printDebug("$url\n${obj.toString()}");
    CommonHelper.printDebug("$url\n${response.bodyString}");
    jsonResponse = [];
    if (response.status.connectionError) {
      if (hideSnackBars != true) {
        SnackBarUtils.errorSnackBar(
          title: 'Connection Timeout',
          message: 'Check your internet connection',
        );
      }
    } else if (response.unauthorized) {
      _navigateToLogin();
    } else if (!response.status.hasError) {
      Map data = response.body;
      String? status = data["status"];
      if (status != null) {
        Map<String, dynamic> statusMap = {"api_status": status};
        if (data["Data"] != null) {
          for (int i = 0; i < data["Data"].length; i++) {
            Map<String, dynamic> maps = data["Data"][i];
            maps.update("api_status", (existingValue) => status, ifAbsent: () {
              maps.addIf(!maps.containsKey("api_status"), "api_status", status);
            });
            maps.update("api_status", (value) => status);
            jsonResponse.add(maps);
          }
        } else {
          jsonResponse.add(statusMap);
        }
      } else {
        jsonResponse.add(data);
      }
      return jsonResponse;
    }
  }

  static Future<dynamic> putMethod({
    required String url,
    required bool isAuthenticationRequired,
    Map<String, dynamic>? obj,
    bool? hideSnackBars,
  }) async {
    List<dynamic> jsonResponse = [];
    GetConnect getConnect = GetConnect();
    getConnect.timeout = const Duration(seconds: 30);
    final response = isAuthenticationRequired == true
        ? await getConnect.put(url, obj, headers: await _getHeaders())
        : await getConnect.put(url, obj);
    CommonHelper.printDebug("$url\n${obj.toString()}");
    CommonHelper.printDebug("$url\n${response.bodyString}");
    jsonResponse = [];
    if (response.status.connectionError) {
      if (hideSnackBars != true) {
        SnackBarUtils.errorSnackBar(
          title: 'Connection Timeout',
          message: 'Check your internet connection',
        );
      }
    } else if (response.unauthorized) {
      _navigateToLogin();
    } else if (!response.status.hasError) {
      Map data = response.body;
      String? status = data["status"];
      if (status != null) {
        Map<String, dynamic> statusMap = {"api_status": status};
        if (data["Data"] != null) {
          for (int i = 0; i < data["Data"].length; i++) {
            Map<String, dynamic> maps = data["Data"][i];
            maps.update("api_status", (existingValue) => status, ifAbsent: () {
              maps.addIf(!maps.containsKey("api_status"), "api_status", status);
            });
            maps.update("api_status", (value) => status);
            jsonResponse.add(maps);
          }
        } else {
          jsonResponse.add(statusMap);
        }
      } else {
        jsonResponse.add(data);
      }
      return jsonResponse;
    }
  }

  static void _navigateToLogin() {}
}
