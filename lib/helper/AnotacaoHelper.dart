import 'dart:async';

import 'package:appminhasanotacoes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {
  static final String idColuna = "id";
  static final String tituloColuna = "titulo";
  static final String descricaoColuna = "descricao";
  static final String dataCColuna = "dataC";
  static final String dataAColuna = "dataA";
  static final String nomeTabela = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database? _db;

  // Construtor privado para implementar o padrão Singleton
  AnotacaoHelper._internal();

  // Factory method para retornar a instância única da classe
  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  // Método para obter o banco de dados
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await _inicializarDb();
      return _db;
    }
  }


  Future<Database> _inicializarDb() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_minhas_anotacoes.db");
    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }
  recuperarAnotacaes()async{
  var bancoDados = await db;
  String sql = "SELECT * FROM $nomeTabela ";
  List anotacoes = await bancoDados!.rawQuery(sql);
  return anotacoes;

  }
  Future<int?> atualizarAnotacao(Anotacao? anotacao) async{
    var bancoDados = await db;
      return await bancoDados?.update(nomeTabela,
        anotacao!.toMap(),
        where: "id= ?",
        whereArgs: [anotacao.id]);
  }


  Future<int?> savarAnotacao(Anotacao anotacao) async {
    try {
      var bancoDados = await db;
      if (bancoDados == null) {
        throw Exception("O banco de dados não foi inicializado corretamente.");
      }
      int? id = await bancoDados.insert(nomeTabela, anotacao.toMap());
      return id;
    } catch (e) {
      print("Erro ao salvar anotação: $e");
      return null;
    }
  }


  // Método para criar a tabela de anotações
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $nomeTabela (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descricao TEXT,
        dataC DATETIME,
        dataA DATETIME
      )    ''');
  }

}
