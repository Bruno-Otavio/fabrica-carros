class Cliente {
  const Cliente({
    required this.id,
    required this.nome
  });

  final int id;
  final String nome;

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'Id': int id,
        'Nome': String nome,
      } =>  
        Cliente(id: id, nome: nome),
      _ => throw const FormatException('Could not get Cliente.'),
    };
  }
}