enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  final String? email;
  final String? nome;

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.email,
    this.nome,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    String? email,
    String? nome,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      nome: nome ?? this.nome,
    );
  }
} 