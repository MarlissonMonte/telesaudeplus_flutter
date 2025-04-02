import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/consulta_agendada.dart';
import '../services/consulta_service.dart';
import '../routes/app_routes.dart';

class ConsultasAgendadasScreen extends StatefulWidget {
  final String idUsuario;

  const ConsultasAgendadasScreen({
    Key? key,
    required this.idUsuario,
  }) : super(key: key);

  @override
  State<ConsultasAgendadasScreen> createState() => _ConsultasAgendadasScreenState();
}

class _ConsultasAgendadasScreenState extends State<ConsultasAgendadasScreen> {
  final ConsultaService _consultaService = ConsultaService();
  List<ConsultaAgendada> _consultas = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _carregarConsultas();
  }

  Future<void> _carregarConsultas() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final consultas = await _consultaService.getConsultasAgendadas(widget.idUsuario);
      setState(() {
        _consultas = consultas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _mostrarDialogoConsultaIndisponivel() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Consulta não disponível'),
          content: const Text('Ainda não é possível entrar nesta consulta. A sala será liberada próximo ao horário agendado.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: const Text('Minhas Consultas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarConsultas,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Erro ao carregar consultas:\n$_error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _carregarConsultas,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : _consultas.isEmpty
                  ? const Center(
                      child: Text('Nenhuma consulta agendada'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _consultas.length,
                      itemBuilder: (context, index) {
                        final consulta = _consultas[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr(a). ${consulta.nomeMedico}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Data: ${DateFormat('dd/MM/yyyy').format(consulta.horarioInicio)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Horário: ${DateFormat('HH:mm').format(consulta.horarioInicio)} - ${DateFormat('HH:mm').format(consulta.horarioFim)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: consulta.rtcToken != null
                                          ? Colors.green
                                          : Colors.grey,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    onPressed: () {
                                      if (consulta.rtcToken != null) {
                                        Get.toNamed(
                                          AppRoutes.videoCall,
                                          arguments: {
                                            'consulta': consulta,
                                          },
                                        );
                                      } else {
                                        _mostrarDialogoConsultaIndisponivel();
                                      }
                                    },
                                    child: const Text(
                                      'Entrar na Consulta',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}