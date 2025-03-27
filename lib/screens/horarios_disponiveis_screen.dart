import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/medico_service.dart';
import '../cubits/login/login_state.dart';
import '../cubits/login/login_cubit.dart';

class HorariosDisponiveisScreen extends StatefulWidget {
  final String medicoId;
  final String medicoNome;
  final String id_usuario;

  const HorariosDisponiveisScreen({
    Key? key,
    required this.medicoId,
    required this.medicoNome,
    required this.id_usuario,
  }) : super(key: key);

  @override
  State<HorariosDisponiveisScreen> createState() =>
      _HorariosDisponiveisScreenState();
}

class _HorariosDisponiveisScreenState extends State<HorariosDisponiveisScreen> {
  final MedicoService _medicoService = MedicoService();
  DateTime _dataSelecionada = DateTime.now().subtract(Duration(hours:3));
  
  List<DateTime> _horariosDisponiveis = [];
  bool _isLoading = false;

  @override
  void initState() {
    print("Recebido id_usuario: ${widget.id_usuario}");

    super.initState();
    _buscarHorarios();
  }

  Future<void> _buscarHorarios() async {
    setState(() => _isLoading = true);
    try {
      final horarios = await _medicoService.getHorariosDisponiveis(
        widget.medicoId,
        _dataSelecionada,
      );
      setState(() => _horariosDisponiveis = horarios);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao buscar horários: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (data != null) {
      setState(() => _dataSelecionada = data);
      _buscarHorarios();
    }
  }

  Future<void> _mostrarDialogoConfirmacao(DateTime horario) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Agendamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Médico: ${widget.medicoNome}'),
              Text('Data: ${DateFormat('dd/MM/yyyy').format(horario)}'),
              Text('Horário: ${DateFormat('HH:mm').format(horario)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  print("id_usuario: $widget.id_usuario");
                  await _medicoService.agendarConsulta(
                    widget.id_usuario,
                    widget.medicoId,
                    horario,
                    horario.add(const Duration(minutes: 30)),
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Consulta agendada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    _buscarHorarios(); // Atualiza a lista de horários
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao agendar consulta: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Horários - ${widget.medicoNome}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}',
                  style: const TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: _selecionarData,
                  child: const Text('Alterar Data'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_horariosDisponiveis.isEmpty)
            const Center(child: Text('Nenhum horário disponível nesta data'))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _horariosDisponiveis.length,
                itemBuilder: (context, index) {
                  final horario = _horariosDisponiveis[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        DateFormat('HH:mm').format(horario),
                        style: const TextStyle(fontSize: 18),
                      ),
                      onTap: () => _mostrarDialogoConfirmacao(horario),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
