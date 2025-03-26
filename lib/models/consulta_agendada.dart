class ConsultaAgendada {
  final int id;
  final int idMedico;
  final int idUsuario;
  final DateTime horarioInicio;
  final DateTime horarioFim;
  final String? rtcToken;
  final String? rtmToken;
  final bool notificado;
  final String nomeMedico;

  ConsultaAgendada({
    required this.id,
    required this.idMedico,
    required this.idUsuario,
    required this.horarioInicio,
    required this.horarioFim,
    this.rtcToken,
    this.rtmToken,
    required this.notificado,
    required this.nomeMedico,
  });

  factory ConsultaAgendada.fromJson(Map<String, dynamic> json) {
    return ConsultaAgendada(
      id: json['id'],
      idMedico: json['id_medico'],
      idUsuario: json['id_usuario'],
      horarioInicio: DateTime.parse(json['horario_inicio']),
      horarioFim: DateTime.parse(json['horario_fim']),
      rtcToken: json['rtc_token'],
      rtmToken: json['rtm_token'],
      notificado: json['notificado'],
      nomeMedico: json['nome'],
    );
  }
}