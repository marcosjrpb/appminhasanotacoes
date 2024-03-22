import 'package:appminhasanotacoes/helper/AnotacaoHelper.dart';
class Anotacao {
  int? id;
  String? titulo;
  String? descricao;
  String? dataC;
  String? dataA;

  Anotacao.fromMap(Map map) {
    this.id = map[AnotacaoHelper.idColuna];
    this.titulo = map[AnotacaoHelper.tituloColuna];
    this.descricao = map[AnotacaoHelper.descricaoColuna];
    this.dataC = map[AnotacaoHelper.dataCColuna];
    this.dataA = map[AnotacaoHelper.dataAColuna];
  }

  Anotacao(this.titulo, this.descricao, this.dataC, {this.dataA});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      AnotacaoHelper.tituloColuna: this.titulo,
      AnotacaoHelper.descricaoColuna: this.descricao,
      AnotacaoHelper.dataCColuna: this.dataC,

    };

    if (this.id != null) {
      map[AnotacaoHelper.dataAColuna] = this.dataA;
      map[AnotacaoHelper.idColuna] = this.id;
    }

    return map;
  }
}
