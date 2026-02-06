import '../services/produto_service.dart';

class CadastroProdutoController {
  final ProdutoService service = ProdutoService();

  Future<bool> cadastrarProduto({
    required String nome,
    required String sku,
    required String categoria,
    required String preco,
    required String quantidade,
  }) {
    return service.cadastrarProduto({
      "nome": nome,
      "sku": sku,
      "categoria": categoria,
      "preco": double.parse(preco.replaceAll(',', '.')),
      "quantidade": int.parse(quantidade),
    });
  }
}