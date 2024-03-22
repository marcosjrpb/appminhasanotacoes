import 'package:flutter/material.dart';
import 'package:appminhasanotacoes/model/Anotacao.dart';
import 'package:appminhasanotacoes/helper/AnotacaoHelper.dart';

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
      _tituloController.text = anotacao.titulo.toString();
      _descricaoController.text = anotacao.descricao.toString();
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
                _savarAtualizarAnotacao(anotacaoSelecionada: anotacao!);
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
                        color: Colors.black, // Cor padrão do texto
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "${anotacao.dataCriacao}\n", // Parte do texto antes do título
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
                          //todo falta
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
          // Coluna para posicionar o botão flutuante no final
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.add),
                  onPressed: _exibirTelacadastro,
                ),
              ],
            ),
          ),
        ],
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
    print("Lista de anotações:");

    for (var anotacao in _anotacoes) {
      print("Título: ${anotacao.titulo},"
          " Descrição: ${anotacao.descricao},"
          " Data: ${anotacao.dataCriacao}");
    }
  }

  void _savarAtualizarAnotacao({Anotacao? anotacaoSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    String dataAtualizada = _descricaoController.text;


    // Método alternativo para formatar a data
    String data = '${DateTime.now().day}'
        '/${DateTime.now().month.toString().padLeft(2, '0')}'
        '/${DateTime.now().year.toString().padLeft(2, '0')}'
        '  Horas: ${DateTime.now().hour.toString().padLeft(2, '0')}'
        ':${DateTime.now().minute.toString().padLeft(2, '0')}';


    if(anotacaoSelecionada == null){
      Anotacao anotacao = Anotacao( titulo, descricao, data,);
      int? resultado = await _db.savarAnotacao(anotacao);
    }else{//atualizar
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.dataCriacao = dataAtualizada;
    }


    _tituloController.clear();
    _descricaoController.clear();

    // Após salvar a anotação, atualize a lista de anotações
    _recuperarAnotacoes();
  }
}
