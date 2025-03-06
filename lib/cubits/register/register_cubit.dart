 import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../models/user.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const RegisterState());

  Future<void> register({
    required String cpf,
    required String nome,
    required String email,
    required String senha,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      final user = User(
        cpf: cpf,
        nome: nome,
        email: email,
        senha: senha,
      );

      final response = await _authRepository.register(user);

      if (response['success'] == true) {
        emit(state.copyWith(
          status: RegisterStatus.success,
          email: email,
        ));
      } else {
        emit(state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: response['message'] ?? 'Erro ao cadastrar usuário',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Erro inesperado: $e',
      ));
    }
  }
}