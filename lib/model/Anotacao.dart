import 'package:appminhasanotacoes/helper/AnotacaoHelper.dart';

class Anotacao {
  int? id;
  String? titulo;
  String? descricao;
  String? dataCriacao;

  Anotacao.fromMap(Map map) {
    this.id = map[AnotacaoHelper.idColuna];
    this.titulo = map[AnotacaoHelper.tituloColuna];
    this.descricao = map[AnotacaoHelper.descricaoColuna];
    this.dataCriacao = map[AnotacaoHelper.dataColuna];
  }
  Anotacao(this.titulo, this.descricao, this.dataCriacao);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "titulo": this.titulo,
      "descricao": this.descricao,
      "data": this.dataCriacao,
    };

    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }
}
