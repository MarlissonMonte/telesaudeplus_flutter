import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../services/firebase_messaging_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final FirebaseMessagingService _firebaseMessaging;

  LoginCubit({
    required AuthRepository authRepository,
    required FirebaseMessagingService firebaseMessaging,
  }) : _authRepository = authRepository,
       _firebaseMessaging = firebaseMessaging,
       super(const LoginState());

  Future<void> login({required String email, required String senha}) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final response = await _authRepository.login(email: email, senha: senha);

      if (response['success'] == true) {
        final nome = response['data']['nome'] as String? ?? 'Usuário';
        final userId = response['data']['id_usuario'].toString();
        final token = response['data']['token'] as String?;

        // Se o backend ainda não tem token salvo para o user
        if (token == null || token.isEmpty) {
          final newTokenUser = await _firebaseMessaging.getToken();
          if (newTokenUser != null && newTokenUser.isNotEmpty) {
            await _authRepository.registerFCMToken(
              userId: userId,
              fcmToken: newTokenUser,
            );
          }
        }

        emit(
          state.copyWith(status: LoginStatus.success, email: email, nome: nome,id_usuario: userId),
        );
      } else {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: response['message'] ?? 'Erro ao fazer login',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}

