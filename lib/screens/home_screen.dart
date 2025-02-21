import 'package:flutter/material.dart';
import 'doctor_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final String nomeClient;

  const HomeScreen({
    super.key,
    required this.nomeClient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
          title: const Text('TeleSaude Plus+'),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              '$nomeClient,\ncomo posso te ajudar hoje?',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            _buildOptionCard(
              icon: Icons.calendar_today,
              title: 'Agendar uma consulta',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorListScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              icon: Icons.video_camera_front,
              title: 'Entrar na consulta',
              onTap: () {
                // Implementar navegação para tela de consultas
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 25,
          ),
          child: Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 