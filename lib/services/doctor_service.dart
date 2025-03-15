import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor.dart';

class DoctorService {
  // Substitua pela URL base da sua API
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Doctor>> getDoctors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/medicos'));
      print("Código da resposta: ${response.statusCode}");
      print("Recebido da API: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Doctor.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar médicos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }
} 