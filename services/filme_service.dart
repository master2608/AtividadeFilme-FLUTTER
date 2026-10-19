
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/filme.dart';

class FilmeService {
  static Database? _database;

  // Abre o banco ou cria o arquivo e a tabela.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final caminho = join(
      await getDatabasesPath(),
      'filmes.db',
    );

    _database = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE filmes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            assistido INTEGER NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  // INSERT: cadastra um filme.
  Future<int> inserirFilme(Filme filme) async {
    final db = await database;

    return await db.insert(
      'filmes',
      filme.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // SELECT: busca todos os filmes salvos.
  Future<List<Filme>> listarFilmes() async {
    final db = await database;

    final List<Map<String, dynamic>> registros =
        await db.query(
      'filmes',
      orderBy: 'id ASC',
    );

    return registros.map((map) {
      return Filme.fromMap(map);
    }).toList();
  }

  // UPDATE: altera o status de um filme.
  Future<int> atualizarStatus(
    int id,
    bool assistido,
  ) async {
    final db = await database;

    return await db.update(
      'filmes',
      {'assistido': assistido ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
