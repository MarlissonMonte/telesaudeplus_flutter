import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../cubits/login/login_cubit.dart';
import '../cubits/login/login_state.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _emailValido = false;

  // Função para validar e-mail
  bool _validarEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  Future<void> _realizarLogin() async {
    if (!_emailValido) return;
    
    final cubit = context.read<LoginCubit>();
    await cubit.login(
      email: _emailController.text,
      senha: _senhaController.text,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Get.offNamed(
            AppRoutes.home,
            arguments: {'nomeClient': state.nome ?? 'Usuário',
                        'id_usuario': state.id_usuario ?? '0'},
          );
        } else if (state.status == LoginStatus.failure) {
          Get.snackbar(
            'Erro',
            state.errorMessage ?? 'Erro ao fazer login',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.lightBlue[100],
            appBar: AppBar(title: const Text('Entrar')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'E-mail',
                      border: const OutlineInputBorder(),
                      suffixIcon: _emailValido
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _emailValido = _validarEmail(value);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'Senha',
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: state.status == LoginStatus.loading
                        ? null
                        : _realizarLogin,
                    child: state.status == LoginStatus.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Entrar', style: TextStyle(color: Colors.white)),
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
