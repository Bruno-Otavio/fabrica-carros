import 'dart:convert';

import 'package:fabrica_carros/constants.dart';
import 'package:fabrica_carros/model/automovel.dart';
import 'package:http/http.dart' as http;

class AutomovelService {
  static Future<List<Automovel>> getAutomoveis() async {
    final response = await http.get(Uri.parse('$apiUrl/automoveis'));

    if (response.statusCode == 200) {
      final List body = jsonDecode(response.body);
      return body.map((e) => Automovel.fromJson(e)).toList();
    } else {
      throw Exception('Could not fetch automoveis.');
    }
  }
}