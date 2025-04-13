import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  NetworkService._privateConstructor();
  static final NetworkService _instance = NetworkService._privateConstructor();
  factory NetworkService() => _instance;

  final _baseUrl = 'https://api.chayil.com/v1';

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final response =
        await http.delete(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
}
