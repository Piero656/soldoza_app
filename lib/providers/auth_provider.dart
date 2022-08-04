import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:soldoza_app/global_variables.dart';

class AuthProvider extends ChangeNotifier {
  final String _endpoint = '/auth';

  bool isLoading = false;

  String token = '';

  Map<String, dynamic> userMap = {};

  Future login(String username, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      final String endpoint = '$_endpoint/login';

      final url = Global.urlAPI + endpoint;
      final response = await Dio()
          .post(url, data: {"email": username, "password": password});


      if (response.statusCode == 201) {
        Map<String, dynamic> resp = jsonDecode(response.toString());

        token = resp['token'];
        userMap = parseJwt(token);

        Global.userMap = userMap;

        print(userMap);

        notifyListeners();
        return resp['token'];
      }
    } catch (e) {
      token = '';
      isLoading = false;

      notifyListeners();

      return '';
    }
  }

  Future updateFirebaseToken(String token, String userId) async {
    isLoading = true;
    notifyListeners();

    String endpoint = '/users/$userId/update-device-token';

    final url = Global.urlAPI + endpoint;
    final response = await Dio().put(url, data: {"token": token});

    isLoading = false;
    notifyListeners();
    return response;
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
