import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ProdutoService {
  final String baseUrl = 'http://localhost:8080/produtos';

  Future<bool> cadastrarProduto(Map<String, dynamic> produto) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(produto),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletarProduto(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/$id'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  Future<List<Produto>> listarProdutos() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List lista = jsonDecode(response.body);
        return lista.map((e) => Produto.fromJson(e)).toList();
      } else {
        throw Exception('Erro ao buscar produtos');
      }
    } on SocketException {
      throw Exception('Servidor offline');
    } on TimeoutException {
      throw Exception('Servidor não respondeu');
    } catch (e) {
      throw Exception('Erro inesperado');
    }
  }

  Future<bool> atualizarProduto(int id, Map<String, dynamic> produto) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(produto),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
