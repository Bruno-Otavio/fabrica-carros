import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fabrica_carros/model/alocacao.dart';
import 'package:fabrica_carros/model/automovel.dart';
import 'package:fabrica_carros/services/alocacao_service.dart';
import 'package:fabrica_carros/widget/automovel_widget.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.area,
  });

  final int area;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future _futureAlocacao;

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
    connectionSub = Connectivity().onConnectivityChanged.listen(checkConnection);
  }

  @override
  void dispose() {
    super.dispose();
    connectionSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _futureAlocacao = AlocacaoService.getAlocacaoByArea(widget.area);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Área ${widget.area}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: _futureAlocacao,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final Alocacao alocacao = data[index];
                  final Automovel automovel = alocacao.automovel;

                  return AutomovelWidget(automovel: automovel, area: widget.area,);
                },
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
