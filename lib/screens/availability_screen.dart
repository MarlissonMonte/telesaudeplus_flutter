import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment_time.dart';

class AvailabilityScreen extends StatefulWidget {
  final Doctor doctor;

  const AvailabilityScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  DateTime selectedDate = DateTime.now();
  List<AppointmentTime> horarios = [];

  @override
  void initState() {
    super.initState();
    _atualizarHorarios();
  }

  void _atualizarHorarios() {
    // Simulando horários disponíveis
    horarios = [
      AppointmentTime(hora: '09:10', medico: widget.doctor.nome, disponivel: true),
      AppointmentTime(hora: '09:40', medico: widget.doctor.nome, disponivel: true),
      AppointmentTime(hora: '11:50', medico: widget.doctor.nome, disponivel: true),
    ];
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.lightBlue[100]!,
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _atualizarHorarios();
      });
    }
  }

  void _mostrarConfirmacao(BuildContext context, String horario) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Consulta agendada com sucesso para $horario',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Especialidade: ${widget.doctor.especialidade}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Text(
              'Unidade: UBS Luzia - Dr Barbosa II',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        setState(() {
                          selectedDate = selectedDate.subtract(const Duration(days: 1));
                          _atualizarHorarios();
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () => _selecionarData(context),
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        setState(() {
                          selectedDate = selectedDate.add(const Duration(days: 1));
                          _atualizarHorarios();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: horarios.length,
                itemBuilder: (context, index) {
                  final horario = horarios[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${horario.hora} - ${horario.medico}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => _mostrarConfirmacao(context, horario.hora),
                            child: const Text(
                              'AGENDAR',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 