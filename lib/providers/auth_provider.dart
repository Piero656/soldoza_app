import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:soldoza_app/global_variables.dart';

class AuthProvider extends ChangeNotifier {
  final String _endpoint = 'v1/auth';

  bool isLoading = false;

  String token = '';

  Map<String, dynamic> userMap = {};

  Future login(String username, String password) async {
    isLoading = true;
    notifyListeners();
    final String endpoint = '$_endpoint/login';

    final url = Uri.http(Global.urlAPI, endpoint);
    final response =
        await http.post(url, body: {"email": username, "password": password});

    isLoading = false;
    if (response.statusCode == 201) {
      Map<String, dynamic> resp = jsonDecode(response.body);

      token = resp['token'];
      userMap = parseJwt(token);

      print(userMap);

      notifyListeners();
      return resp['token'];
    } else {
      token = '';
      notifyListeners();

      return '';
    }
  }

  Future updateFirebaseToken(String token, String userId) async {
    isLoading = true;
    notifyListeners();

    String endpoint = 'v1/users/$userId/update-device-token';

    final url = Uri.http(Global.urlAPI, endpoint);
    final response = await http.put(url, body: {"token": token});

    print(response.body);

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
