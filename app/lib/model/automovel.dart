class Automovel {
  const Automovel({
    required this.id,
    required this.modelo,
    required this.preco,
  });

  final String id;
  final String modelo;
  final int preco;

  factory Automovel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'modelo': String modelo,
        'preco': int preco,
      } =>
        Automovel(
          id: id,
          modelo: modelo,
          preco: preco,
        ),
      _ => throw const FormatException('Could not get Automovel.'),
    };
  }
}
