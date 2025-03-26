enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  final String? email;
  final String? nome;
  final String? id_usuario;

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.email,
    this.nome,
    this.id_usuario
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    String? email,
    String? nome,
    String? id_usuario,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      id_usuario: id_usuario ?? this.id_usuario,
    );
  }
} 