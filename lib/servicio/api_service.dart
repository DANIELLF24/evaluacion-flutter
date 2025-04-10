import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://67f7d1812466325443eadd17.mockapi.io/carros';

  static Future<List<dynamic>> getCarros() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener los carros');
    }
  }

  static Future<dynamic> getCarroPorId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Carro no encontrado');
    }
  }
}
