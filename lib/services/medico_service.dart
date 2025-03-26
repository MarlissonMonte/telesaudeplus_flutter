import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicoService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<DateTime>> getHorariosDisponiveis(
    String medicoId,
    DateTime data,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/medicos/horarios/$medicoId?data_inicial=${DateFormat('yyyy-MM-dd').format(data)}',
        ),
      );

      print(response.statusCode);
      print(medicoId);
      if (response.statusCode == 200) {
        print(response.body);
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is List) {
          final List<dynamic> horarios = decodedResponse;
          print(horarios);
          return horarios.map((horario) => DateTime.parse(horario)).toList();
        } else if (decodedResponse is Map &&
            decodedResponse.containsKey('message')) {
          print(decodedResponse['message']);
          throw Exception(decodedResponse['message']);
        } else {
          throw Exception('Resposta inesperada do servidor');
        }
      }
      throw Exception('Erro ao buscar horários disponíveis');
    } catch (e) {
      throw Exception('Erro ao buscar horários disponíveis: $e');
    }
  }

  Future<void> agendarConsulta(
    String usuarioId,
    String medicoId,
    DateTime horarioInicio,
    DateTime horarioFim,
  ) async {
    try {
      print("usuarioId:$usuarioId");
      final response = await http.post(
        Uri.parse('$baseUrl/consultas-agendadas'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id_usuario': usuarioId,
          'id_medico': medicoId,
          'horario_inicio': DateFormat('yyyy-MM-dd HH:mm:ss').format(horarioInicio),
          'horario_fim': DateFormat('yyyy-MM-dd HH:mm:ss').format(horarioFim.add(Duration(minutes: 30))),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao agendar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao agendar consulta: $e');
    }
  }
}
