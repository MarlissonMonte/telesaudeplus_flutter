import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/consulta_agendada.dart';

class ConsultaService {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<ConsultaAgendada>> getConsultasAgendadas(String idUsuario) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/consultas-agendadas/usuario/$idUsuario'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ConsultaAgendada.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar consultas');
      }
    } catch (e) {
      throw Exception('Erro ao buscar consultas: $e');
    }
  }
}