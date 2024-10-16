import 'package:fabrica_carros/model/automovel.dart';
import 'package:fabrica_carros/services/cliente_service.dart';
import 'package:fabrica_carros/services/concessionario_service.dart';
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

  @override
  void initState() {
    super.initState();
    _futureVendas = _getVendas();
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
      body: FutureBuilder(
        future: _futureVendas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final List clientes = data['clientes'];
            final List concessionarias = data['concessionarias'];

            String dropDownValueClientes = clientes.first.nome;
            String dropDownValueConcessionarias = concessionarias.first.nome;

            return Form(
              child: Column(
                children: [
                  DropdownButtonFormField(
                    validator: (value) => null,
                    value: dropDownValueClientes,
                    items: clientes.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(value: e.nome, child: Text(e.nome));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        dropDownValueClientes = value!;
                      });
                    },
                  ),
                  DropdownButtonFormField(
                    validator: (value) => null,
                    value: dropDownValueConcessionarias,
                    items: concessionarias.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(value: e.nome, child: Text(e.nome));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        dropDownValueConcessionarias = value!;
                      });
                    },
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
    );
  }
}
