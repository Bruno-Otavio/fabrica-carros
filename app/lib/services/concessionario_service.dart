import 'dart:convert';

import 'package:fabrica_carros/constants.dart';
import 'package:fabrica_carros/model/concessionaria.dart';
import 'package:http/http.dart' as http;

class ConcessionarioService {
  static Future<List<Concessionaria>> getConcessionariasByAreaAndAutomovel(
    int area,
    String automovel,
  ) async {
    final response = await http
        .get(Uri.parse('$apiUrl/alocacao?area=$area&automovel=$automovel'));

    if (response.statusCode == 200) {
      final List body = jsonDecode(response.body);

      final List concessionarias = [];
      for (Map alocacao in body) {
        final response = await http.get(
          Uri.parse('$apiUrl/concessionarias/${alocacao['concessionaria']}'),
        );

        if (response.statusCode != 200) {
          throw Exception('Could not fetch concessionarias.');
        }

        final bodyConcessionaria = jsonDecode(response.body);

        if (concessionarias
            .where((e) => e['id'] == bodyConcessionaria['id'])
            .isEmpty) {
          concessionarias.add(bodyConcessionaria);
        }
      }

      return concessionarias
          .map((e) => Concessionaria.fromJson(e))
          .toList();
    } else {
      throw Exception('Could not fetch concessionarias.');
    }
  }
}
