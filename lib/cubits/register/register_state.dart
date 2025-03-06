 import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? errorMessage;
  final String? email;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.email,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    String? email,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, email];
}