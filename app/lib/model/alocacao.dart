import 'package:fabrica_carros/model/automovel.dart';

class Alocacao {
  const Alocacao({
    required this.id,
    required this.area,
    required this.automovel,
    required this.concessionaria,
    required this.quantidade,
  });

  final String id;
  final int area;
  final Automovel automovel;
  final int concessionaria;
  final int quantidade;

  factory Alocacao.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'area': int area,
        'automovel': Automovel automovel,
        'concessionaria': int concessionaria,
        'quantidade': int quantidade,
      } =>
        Alocacao(
          id: id,
          area: area,
          automovel: automovel,
          concessionaria: concessionaria,
          quantidade: quantidade,
        ),
      _ => throw const FormatException('Could not get Alocacao.'),
    };
  }
}
