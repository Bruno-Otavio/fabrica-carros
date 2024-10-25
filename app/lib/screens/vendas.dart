import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fabrica_carros/model/automovel.dart';
import 'package:fabrica_carros/services/cliente_service.dart';
import 'package:fabrica_carros/services/concessionario_service.dart';
import 'package:fabrica_carros/widget/button.dart';
import 'package:flutter/material.dart';

class VendasScreen extends StatefulWidget {
  const VendasScreen({
    super.key,
    required this.area,
    required this.automovel,
  });

  final int area;
  final Automovel automovel;

  @override
  State<VendasScreen> createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  late Future _futureVendas;

  final _formKey = GlobalKey<FormState>();

  Future _getVendas() async {
    return <String, dynamic>{
      'clientes': await ClienteService.getClientes(),
      'concessionarias':
          await ConcessionarioService.getConcessionariasByAreaAndAutomovel(
        widget.area,
        widget.automovel.id,
      ),
    };
  }

  late StreamSubscription connectionSub;
  void checkConnection(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          title: Text('No internet'),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _futureVendas = _getVendas();
    connectionSub = Connectivity().onConnectivityChanged.listen(checkConnection);
  }

  @override
  void dispose() {
    super.dispose();
    connectionSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.automovel.modelo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: _futureVendas,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              final List clientes = data['clientes'];
              final List concessionarias = data['concessionarias'];

              final itemsClientes = clientes.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem(value: e.nome, child: Text(e.nome));
              }).toList();
              itemsClientes.insert(
                0,
                const DropdownMenuItem(
                  value: 'Selecionar',
                  child: Text('Selecionar'),
                ),
              );

              final itemsConcessionaria =
                  concessionarias.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem(value: e.nome, child: Text(e.nome));
              }).toList();
              itemsConcessionaria.insert(
                0,
                const DropdownMenuItem(
                  value: 'Selecionar',
                  child: Text('Selecionar'),
                ),
              );

              String dropDownValueClientes = itemsClientes.first.value!;
              String dropDownValueConcessionarias =
                  itemsConcessionaria.first.value!;

              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 3),
                            child: Text(
                              'Cliente',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value == 'Selecionar') {
                                return 'Por favor, selecione um Cliente.';
                              }
                              return null;
                            },
                            value: dropDownValueClientes,
                            items: itemsClientes,
                            onChanged: (String? value) {
                              setState(() {
                                dropDownValueClientes = value!;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 3),
                            child: Text(
                              'Concessionária',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value == 'Selecionar') {
                                return 'Por favor, selecione uma Concessionária.';
                              }
                              return null;
                            },
                            value: dropDownValueConcessionarias,
                            items: itemsConcessionaria,
                            onChanged: (String? value) {
                              setState(() {
                                dropDownValueConcessionarias = value!;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: Button(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                            }
                          },
                          text: 'Confirmar',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
