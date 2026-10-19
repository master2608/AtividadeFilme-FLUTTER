
import 'package:flutter/foundation.dart';

import '../models/filme.dart';
import '../services/filme_service.dart';

class FilmeViewModel extends ChangeNotifier {
  final FilmeService _service;

  FilmeViewModel(this._service);

  List<Filme> _filmes = [];
  bool _carregando = false;
  String? _erro;

  List<Filme> get filmes => List.unmodifiable(_filmes);
  bool get carregando => _carregando;
  String? get erro => _erro;

  // Carrega os filmes salvos no SQLite.
  Future<void> carregarFilmes() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _filmes = await _service.listarFilmes();
    } catch (e) {
      _erro = 'Não foi possível carregar os filmes.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Adiciona um novo filme.
  Future<bool> adicionarFilme(String titulo) async {
    final nome = titulo.trim();

    if (nome.isEmpty) {
      _erro = 'Digite o nome de um filme.';
      notifyListeners();
      return false;
    }

    try {
      _erro = null;

      await _service.inserirFilme(
        Filme(titulo: nome),
      );

      await carregarFilmes();
      return true;
    } catch (e) {
      _erro = 'Não foi possível cadastrar o filme.';
      notifyListeners();
      return false;
    }
  }

  // Marca ou desmarca um filme como assistido.
  Future<void> alterarStatus(
    Filme filme,
    bool assistido,
  ) async {
    if (filme.id == null) return;

    try {
      _erro = null;

      await _service.atualizarStatus(
        filme.id!,
        assistido,
      );

      await carregarFilmes();
    } catch (e) {
      _erro = 'Não foi possível atualizar o filme.';
      notifyListeners();
    }
  }
}
