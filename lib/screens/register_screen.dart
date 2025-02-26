import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_validation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _cpfValido = false;
  bool _cpfVerificado = false;
  bool _senhaValida = false;
  bool _senhasIguais = false;
  bool _mostrarValidacaoSenha = false;
  bool _nomeValido = false;
  bool _emailValido = false;

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

  // Função para validar senhas
  void _validarSenhas() {
    final senha = _senhaController.text;
    final confirmarSenha = _confirmarSenhaController.text;

    setState(() {
      _senhaValida = senha.length >= 6;
      _senhasIguais = senha == confirmarSenha && senha.isNotEmpty;
      _mostrarValidacaoSenha = confirmarSenha.isNotEmpty;
    });
  }

  void _validarNome(String value) {
    setState(() {
      _nomeValido = value.trim().length >= 4;
    });
  }

  void _validarEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _emailValido = emailRegex.hasMatch(value);
    });
  }

  Future<void> _cadastrarUsuario() async {
    // Por enquanto, vamos navegar diretamente para a tela de token
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TokenValidationScreen(
          email: _emailController.text,
        ),
      ),
    );

    // Código da API comentado por enquanto
    /*
    try {
      final usuario = User(
        cpf: _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
      );

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/cadastro'),
        body: jsonEncode(usuario.toJson()),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cadastro realizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TokenValidationScreen(
                email: _emailController.text,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro no cadastro: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao conectar com o servidor: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    */
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(title: const Text('Cadastrar')),
      body: SingleChildScrollView(
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
            const SizedBox(height: 12),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'Nome',
                border: OutlineInputBorder(),
                helperText: 'Mínimo de 4 caracteres',
                suffixIcon: _nomeController.text.isNotEmpty
                    ? Icon(
                        _nomeValido ? Icons.check_circle : Icons.error,
                        color: _nomeValido ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              onChanged: _validarNome,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'Email',
                border: OutlineInputBorder(),
                suffixIcon: _emailController.text.isNotEmpty
                    ? Icon(
                        _emailValido ? Icons.check_circle : Icons.error,
                        color: _emailValido ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              onChanged: _validarEmail,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'Senha',
                border: OutlineInputBorder(),
                helperText: 'Mínimo de 6 caracteres',
                suffixIcon: _senhaController.text.isNotEmpty
                    ? Icon(
                        _senhaValida ? Icons.check_circle : Icons.error,
                        color: _senhaValida ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              obscureText: true,
              onChanged: (value) {
                _validarSenhas();
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmarSenhaController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'Confirmar senha',
                border: OutlineInputBorder(),
                suffixIcon: _mostrarValidacaoSenha
                    ? Icon(
                        _senhasIguais ? Icons.check_circle : Icons.error,
                        color: _senhasIguais ? Colors.green : Colors.red,
                      )
                    : null,
                errorText: _mostrarValidacaoSenha && !_senhasIguais
                    ? 'As senhas não coincidem'
                    : null,
              ),
              obscureText: true,
              onChanged: (value) {
                _validarSenhas();
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: (_cpfValido && _nomeValido && _emailValido && 
                         _senhaValida && _senhasIguais)
                  ? _cadastrarUsuario
                  : null,
              child: const Text('Cadastrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
} 