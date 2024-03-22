import 'package:flutter/material.dart';
import 'package:appminhasanotacoes/model/Anotacao.dart';
import 'package:appminhasanotacoes/helper/AnotacaoHelper.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  _exibirTelacadastro({Anotacao? anotacao}) {
    String textoSalvarAtualizar = " ";
    if (anotacao == null) {
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    } else {
      _tituloController.text = anotacao.titulo ?? '';
      _descricaoController.text = anotacao.descricao ?? '';
      textoSalvarAtualizar = "Atualizar";
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$textoSalvarAtualizar Anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Titulo",
                  hintText: "Digite o título...",
                ),
              ),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  hintText: "Digite o descrição...",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _savarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                Navigator.pop(context);
              },
              child: Text(textoSalvarAtualizar),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minhas Anotações",
          style: TextStyle(color: Color(0xFF0A350D)),
        ),
        backgroundColor: Colors.lime,
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: _anotacoes.length,
            itemBuilder: (context, index) {
              final anotacao = _anotacoes[index];
              return Card(
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16.0, // Tamanho da fonte padrão
                        color: Color(0xFF212121),
                      ),
                      children: <TextSpan>[
                        // Verifica se dataA não é nulo
                        if (anotacao.dataA != null)
                          TextSpan(
                            text:
                                "Inicial:     ${anotacao.dataC}\nRecente: ${anotacao.dataA}\n",
                          ),
                        if (anotacao.dataA == null)
                          TextSpan(
                            text: "${anotacao.dataC}\n",
                          ),
                        TextSpan(
                          text: "${anotacao.titulo}",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold, // Torna o título em negrito
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text("${anotacao.descricao}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _exibirTelacadastro(anotacao: anotacao);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Column(
                                  children: [
                                    Text("Confirme para apagar!",style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 10),
                                    Text("Você está apagando o Item Nº ${anotacao.id.toString()}",style: TextStyle(fontSize: 16)),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Fecha o diálogo sem apagar
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _removerAnotacao(anotacao.id);
                                        Navigator.of(context).pop(); // Fecha o diálogo sem apagar
                                      },
                                      child: Text('Confirmar'),
                                    ),

                                  ],

                                ),
                              );
                            },
                          );


                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: _exibirTelacadastro,
      ),
    );
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacaes();
    List<Anotacao> listaTemporaria = [];

    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }
    setState(() {
      _anotacoes = listaTemporaria;
    });
  }

  void _savarAtualizarAnotacao({Anotacao? anotacaoSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    String data = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    Anotacao anotacao = Anotacao(titulo, descricao, data);

    if (anotacaoSelecionada == null) {
      int? id = await _db.savarAnotacao(anotacao);
    } else {
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;

      // Mantenha a dataC como está, não atualize
      // anotacaoSelecionada.dataC = anotacao.dataC;

      // Atualize apenas a dataA
      anotacaoSelecionada.dataA =
          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      int? resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _tituloController.clear();
    _descricaoController.clear();

    // Atualize a lista de anotações após salvar ou atualizar a anotação
    _recuperarAnotacoes();
  }
  _removerAnotacao(int? id)async{

    if(id != null){
      await _db.removerAnotacap(id!);
      _recuperarAnotacoes();
    }
  }
}
