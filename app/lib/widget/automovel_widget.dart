import 'package:fabrica_carros/model/automovel.dart';
import 'package:fabrica_carros/screens/vendas.dart';
import 'package:fabrica_carros/widget/button.dart';
import 'package:flutter/material.dart';

class AutomovelWidget extends StatelessWidget {
  const AutomovelWidget({
    super.key,
    required this.area,
    required this.automovel,
  });

  final int area;
  final Automovel automovel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                automovel.modelo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('R\$ ${automovel.preco}'),
            ],
          ),
          Button(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VendasScreen(
                    automovel: automovel,
                    area: area,
                  ),
                ),
              );
            },
            text: 'Vender',
          ),
        ],
      ),
    );
  }
}
