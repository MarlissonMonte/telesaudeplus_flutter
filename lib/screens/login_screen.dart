import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cpfController = TextEditingController();
  bool _cpfValido = false;
  bool _cpfVerificado = false;

  // Função para validar CPF
  bool _validarCPF(String cpf) {
    // Remove caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    // Calcula primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int digito1 = 11 - (soma % 11);
    if (digito1 > 9) digito1 = 0;

    // Calcula segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int digito2 = 11 - (soma % 11);
    if (digito2 > 9) digito2 = 0;

    return (digito1 == int.parse(cpf[9]) && digito2 == int.parse(cpf[10]));
  }

  // Função para formatar CPF
  void _formatarCPF(String value) {
    var cpf = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cpf.length >= 3) {
      cpf = cpf.substring(0, 3) + '.' + cpf.substring(3);
    }
    if (cpf.length >= 7) {
      cpf = cpf.substring(0, 7) + '.' + cpf.substring(7);
    }
    if (cpf.length >= 11) {
      cpf = cpf.substring(0, 11) + '-' + cpf.substring(11);
    }
    
    if (cpf != value) {
      _cpfController.value = TextEditingValue(
        text: cpf,
        selection: TextSelection.collapsed(offset: cpf.length),
      );
    }

    if (cpf.length == 14) {
      setState(() {
        _cpfVerificado = true;
        _cpfValido = _validarCPF(cpf);
      });
    } else {
      setState(() {
        _cpfVerificado = false;
        _cpfValido = false;
      });
    }
  }

  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'CPF',
                border: OutlineInputBorder(),
                suffixIcon: _cpfVerificado
                    ? Icon(
                        _cpfValido ? Icons.check_circle : Icons.error,
                        color: _cpfValido ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(14),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]|-')),
              ],
              onChanged: _formatarCPF,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _cpfValido ? () {
                // Aqui você deve implementar a validação real da senha
                // Por enquanto, vamos apenas navegar para a HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(
                      nomeClient: "Maria Aparecida", // Isso deve vir do backend
                    ),
                  ),
                );
              } : null,
              child: const Text('Entrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
} 