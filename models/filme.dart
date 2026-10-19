
class Filme {
  final int? id;
  final String titulo;
  final bool assistido;

  Filme({
    this.id,
    required this.titulo,
    this.assistido = false,
  });

  // Converte os dados do SQLite em um objeto Filme.
  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      assistido: (map['assistido'] as int) == 1,
    );
  }

  // Converte o objeto Filme para o formato do SQLite.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'assistido': assistido ? 1 : 0,
    };
  }
}
