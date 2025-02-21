class User {
  final String cpf;
  final String nome;
  final String email;
  final String senha;

  User({
    required this.cpf,
    required this.nome,
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
} 