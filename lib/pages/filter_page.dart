
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task.dart';

class FilterPage extends StatefulWidget{
  static const ROUTE_NAME = '/filtro';
  static const CHAVE_CAMPO_ORDENACAO = 'campoOrdenacao';
  static const USAR_ORDEM_DECRESCENTE = 'usarOrdemDecrescente';
  static const CHAVE_FILTRO_DESCRICAO = 'filtroDescricao';

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage>{

  final _camposParaOrdenacao = {
    Task.ID: 'Código',
    Task.DESCRIPTION: 'Descrição',
    Task.DELIVERY_AT: 'Prazo'
  };

  final descricaoController = TextEditingController();
  String campoOrdenacao = Task.ID;
  bool usarOrdemDecrescente = false;
  bool alterouValores = false;

  late final SharedPreferences prefs;

  @override
  void initState(){
    super.initState();
    _carregarSharedPreferences();
  }

  void _carregarSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      campoOrdenacao = prefs.getString(FilterPage.CHAVE_CAMPO_ORDENACAO) ??
          Task.ID;
      usarOrdemDecrescente = prefs.getBool(FilterPage.USAR_ORDEM_DECRESCENTE) ??
          false;
      descricaoController.text = prefs.getString(FilterPage.CHAVE_FILTRO_DESCRICAO) ??
          '';
    });
  }

  @override
  Widget build ( BuildContext context){
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text('Filtro e Ordenação'),),
        body: _criarBody(),
      ),
      onWillPop: onVoltarClick,
    );
  }

  Widget _criarBody(){
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Campos para ordenação'),
        ),
        for (final campo in _camposParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: campoOrdenacao,
                onChanged: _onCampoOrdenacaoChanged,
              ),
              Text(_camposParaOrdenacao[campo] ?? ''),
            ],
          ),
        const Divider(),
        Row(
          children: [
            Checkbox(
              value: usarOrdemDecrescente,
              onChanged: _onDecrescenteChanged,
            ),
            const Text('Usar ordem decrescente')
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: const InputDecoration(labelText: 'Descrição começa com:'),
            controller: descricaoController,
            onChanged: _onFiltroDescricaoChanged,
          ),
        )
      ],
    );
  }

  Future<bool> onVoltarClick() async {
    Navigator.of(context).pop(alterouValores);
    return true;
  }

  void _onCampoOrdenacaoChanged (String? valor){
    prefs.setString(FilterPage.CHAVE_CAMPO_ORDENACAO, valor ?? '');
    alterouValores = true;
    setState(() {
      campoOrdenacao = valor ?? '';
    });
  }

  void _onDecrescenteChanged(bool? valor){
    prefs.setBool(FilterPage.USAR_ORDEM_DECRESCENTE, valor == true);
    alterouValores = true;
    setState(() {
      usarOrdemDecrescente = valor == true;
    });
  }

  void _onFiltroDescricaoChanged(String? valor){
    prefs.setString(FilterPage.CHAVE_FILTRO_DESCRICAO, valor ?? '');
    alterouValores = true;
  }
}