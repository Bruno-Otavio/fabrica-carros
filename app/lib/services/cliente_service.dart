import 'dart:convert';

import 'package:fabrica_carros/constants.dart';
import 'package:fabrica_carros/model/cliente.dart';
import 'package:http/http.dart' as http;

class ClienteService {
  static Future<List<Cliente>> getClientes() async {
    final response = await http.get(Uri.parse('$apiUrl/clientes'));

    if (response.statusCode == 200) {
      final List body = jsonDecode(response.body);
      return body.map((e) => Cliente.fromJson(e)).toList();
    } else {
      throw Exception('Could not fetch Clientes.');
    }
  }
}