import 'dart:convert';

import 'package:fabrica_carros/constants.dart';
import 'package:fabrica_carros/model/concessionaria.dart';
import 'package:http/http.dart' as http;

class ConcessionarioService {
  static Future<List<Concessionaria>> getConcessionariasByAreaAndAutomovel(
    int area,
    int automovel,
  ) async {
    final response = await http
        .get(Uri.parse('$apiUrl/alocacao?area=$area&automovel=$automovel'));

    if (response.statusCode == 200) {
      final List body = jsonDecode(response.body);

      for (Map alocacao in body) {
        final response = await http.get(
          Uri.parse('$apiUrl/concessionaria/${alocacao['concessionaria']}'),
        );

        if (response.statusCode != 200) {
          throw Exception('Could not fetch concessionarias.');
        }

        alocacao['concessionaria'] = jsonDecode(response.body);
      }

      return body.map((e) => Concessionaria.fromJson(e['concessionaria'])).toList();
    } else {
      throw Exception('Could not fetch concessionarias.');
    }
  }
}
