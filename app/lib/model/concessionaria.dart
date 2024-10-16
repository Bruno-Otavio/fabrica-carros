class Concessionaria {
  const Concessionaria({
    required this.id,
    required this.nome,
  });

  final int id;
  final String nome;

  factory Concessionaria.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'concessionaria': String nome,
      } =>
        Concessionaria(id: id, nome: nome),
      _ => throw const FormatException('Could not get concessionaria.'),
    };
  }
}
