import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const Duration timeout = Duration(seconds: 10);

  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Operação realizada com sucesso',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Erro na operação',
        };
      }
    } on http.ClientException {
      return {
        'success': false,
        'message': 'Erro de conexão com o servidor',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro inesperado: $e',
      };
    }
  }
}