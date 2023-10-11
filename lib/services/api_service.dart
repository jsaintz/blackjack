import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "https://deckofcardsapi.com/api";

  Uri _buildUri(String path, Map<String, dynamic> params) {
    final queryString = _buildQueryString(params);
    final url = Uri.parse('$baseUrl/$path?$queryString');
    return url;
  }

  String _buildQueryString(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) {
      return '';
    }

    final queryParameters = params.entries.map((entry) {
      final key = entry.key;
      final value = entry.value.toString();
      return '$key=$value';
    }).join('&');

    return queryParameters.isEmpty ? '' : '?$queryParameters';
  }

  Future<Map<String, dynamic>?> httpGet(String path, {Map<String, dynamic> params = const {}}) async {
    try {
      final Uri url = _buildUri(path, params);
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        throw Exception('Falha na solicitação: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro na solicitação: $e');
      }
      return null;
    }
  }
}
