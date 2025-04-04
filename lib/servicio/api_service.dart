import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://carros-electricos.wiremockapi.cloud';

  static Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getCars(String token) async {
    final url = Uri.parse('$baseUrl/carros');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    }
    throw Exception('Error al obtener los carros');
  }
}
