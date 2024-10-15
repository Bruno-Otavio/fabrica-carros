import 'dart:convert';

import 'package:fabrica_carros/constants.dart';
import 'package:http/http.dart' as http;

class AlocacaoService {
  static Future<List> getAreas() async {
    final response = await http.get(Uri.parse('$apiUrl/alocacao'));

    if (response.statusCode == 200) {
      final List alocacoes = jsonDecode(response.body);
      final List areas = [];
      
      for (Map alocacao in alocacoes) {
        for (int area in areas) {
          if (area != alocacao['area']) {
            areas.add(alocacao['areas']);
            continue;
          }
        }
      }

      return areas;
    } else {
      throw Exception('Could not fetch areas.');
    }
  }
}