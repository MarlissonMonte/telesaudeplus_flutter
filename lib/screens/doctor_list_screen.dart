import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/doctor.dart';
import '../screens/availability_screen.dart';
import '../routes/app_routes.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Doctor> _doctorList = [];
  List<Doctor> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    // Dados de exemplo
    _doctorList = [
      Doctor(
        nome: 'Dr. Kim Garam',
        especialidade: 'Nutrologia',
        imageUrl: 'assets/doctor1.jpg',
      ),
      Doctor(
        nome: 'Dr. Jorge Silva',
        especialidade: 'Neurologista',
        imageUrl: 'assets/doctor2.jpg',
      ),
      Doctor(
        nome: 'Dra. Heloisa Barreto',
        especialidade: 'Oftalmologista',
        imageUrl: 'assets/doctor3.jpg',
      ),
      Doctor(
        nome: 'Dr. Carlos Mendes',
        especialidade: 'Cardiologista',
        imageUrl: 'assets/doctor4.jpg',
      ),
      Doctor(
        nome: 'Dra. Ana Paula Costa',
        especialidade: 'Dermatologista',
        imageUrl: 'assets/doctor5.jpg',
      ),
    ];
    _filteredDoctors = List.from(_doctorList);
  }

  void _filterDoctors(String query) {
    setState(() {
      _filteredDoctors = _doctorList
          .where((doctor) =>
              doctor.nome.toLowerCase().contains(query.toLowerCase()) ||
              doctor.especialidade.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
        title: const Text('Agendar Consulta'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onChanged: _filterDoctors,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _filteredDoctors[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(doctor.imageUrl),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.nome,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                doctor.especialidade,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(color: Colors.blue),
                                  ),
                                ),
                                onPressed: () {
                                  Get.toNamed(
                                    AppRoutes.availability,
                                    arguments: {'doctor': doctor},
                                  );
                                },
                                child: const Text(
                                  'Ver disponibilidade',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 