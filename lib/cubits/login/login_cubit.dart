import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const LoginState());

  Future<void> login({
    required String email,
    required String senha,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final response = await _authRepository.login(
        email: email,
        senha: senha,
      );

      if (response['success'] == true) {
        final nome = response['data']['nome'] as String? ?? 'Usuário';
        
        emit(state.copyWith(
          status: LoginStatus.success,
          email: email,
          nome: nome,
        ));
      } else {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: response['message'] ?? 'Erro ao fazer login',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Erro inesperado: $e',
      ));
    }
  }
} 