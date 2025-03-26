import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/medico_service.dart';
import '../cubits/login/login_state.dart';

class HorariosDisponiveisScreen extends StatefulWidget {
  final String medicoId;
  final String medicoNome;

  const HorariosDisponiveisScreen({
    Key? key,
    required this.medicoId,
    required this.medicoNome,
  }) : super(key: key);

  @override
  State<HorariosDisponiveisScreen> createState() => _HorariosDisponiveisScreenState();
}

class _HorariosDisponiveisScreenState extends State<HorariosDisponiveisScreen> {
  final MedicoService _medicoService = MedicoService();
  final LoginState _loginState = LoginState();
  DateTime _dataSelecionada = DateTime.now();
  List<DateTime> _horariosDisponiveis = [];
  bool _isLoading = false;

  @override
  void initState() {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar horários: $e')),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horários - ${widget.medicoNome}'),
      ),
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
            const Center(
              child: Text('Nenhum horário disponível nesta data'),
            )
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
                      onTap: () {
                        // TODO: Implementar a seleção do horário
                        _medicoService.agendarConsulta(
                          _loginState.id_usuario!,
                          widget.medicoId,
                          horario,
                          horario.add(const Duration(minutes: 30)),
                        );
                      },
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