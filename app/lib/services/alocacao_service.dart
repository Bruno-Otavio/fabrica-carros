import 'dart:convert';

import 'package:fabrica_carros/constants.dart';
import 'package:fabrica_carros/model/alocacao.dart';
import 'package:fabrica_carros/model/automovel.dart';
import 'package:fabrica_carros/services/automovel_service.dart';
import 'package:http/http.dart' as http;

class AlocacaoService {
  static Future<List> getAreas() async {
    final response = await http.get(Uri.parse('$apiUrl/alocacao'));

    if (response.statusCode == 200) {
      final List alocacoes = jsonDecode(response.body);
      final List areas = [];
      
      for (Map alocacao in alocacoes) {
        if (areas.contains(alocacao['area'])) {
          continue;
        }
        areas.add(alocacao['area']);
      }

      return areas;
    } else {
      throw Exception('Could not fetch areas.');
    }
  }

  static Future<List<Alocacao>> getAlocacaoByArea(int area) async {
    final response = await http.get(Uri.parse('$apiUrl/alocacao?area=$area'));

    if (response.statusCode == 200) {
      final List body = jsonDecode(response.body);
      final List<Automovel> automoveis = await AutomovelService.getAutomoveis();

      for (Map alocacao in body) {
        int automoveId = alocacao['automovel'];
        alocacao['automovel'] = automoveis.where((e) => e.id == automoveId.toString()).first;
      }

      return body.map((e) => Alocacao.fromJson(e)).toList();
    } else {
      throw Exception('Could not fetch Alocacoes.');
    }
  }
}