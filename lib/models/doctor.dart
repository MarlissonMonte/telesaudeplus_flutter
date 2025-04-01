class Doctor {
  final int id;
  final int idUsuario;
  final String nome;
  final String especializacao;
  final String? imagem; // Agora pode ser null
  final String? imageUrl;
  final String? crm;
  final double rating;

  Doctor({
    required this.id,
    required this.idUsuario,
    required this.nome,
    required this.especializacao,
    this.imagem, // Permitindo null
    this.imageUrl,
    this.crm,
    this.rating = 0.0, // Valor padrão
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int,
      idUsuario: json['id_usuario'] as int,
      nome: json['nome'] as String,
      especializacao: json['especializacao'] as String,
      imagem: json['imagem'] as String?, // Agora aceita null sem erro
      imageUrl: json['imageUrl'] as String?,
      crm: json['crm'] as String?,
      rating: 0.0, // Valor padrão para evitar erros
    );
  }
}
