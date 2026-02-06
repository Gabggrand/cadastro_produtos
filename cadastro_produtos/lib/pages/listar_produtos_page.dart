import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';
import 'editar_produto_page.dart';
import 'cadastrar_produto_page.dart';

class ListarProdutosPage extends StatefulWidget {
  const ListarProdutosPage({super.key});

  @override
  State<ListarProdutosPage> createState() => _ListarProdutosPageState();
}

class _ListarProdutosPageState extends State<ListarProdutosPage> {
  final ProdutoService service = ProdutoService();
  late Future<List<Produto>> futureProdutos;

  @override
  void initState() {
    super.initState();
    futureProdutos = service.listarProdutos();
  }

  void recarregarLista() {
    setState(() {
      futureProdutos = service.listarProdutos();
    });
  }

  void confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir produto'),
        content: const Text('Tem certeza que deseja excluir este produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              final sucesso = await service.deletarProduto(id);

              if (sucesso) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produto excluído com sucesso')),
                );
                recarregarLista();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao excluir produto')),
                );
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final cadastrado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastrarProdutoPage()),
          );

          if (cadastrado == true) {
            recarregarLista();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Produto>>(
        future: futureProdutos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (_, __) => const ListTile(
                leading: CircleAvatar(backgroundColor: Colors.grey),
                title: SizedBox(
                  height: 14,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
                subtitle: SizedBox(
                  height: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar produtos'));
          }

          final produtos = snapshot.data ?? [];

          if (produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado'));
          }

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(produto.nome),
                  subtitle: Text(
                    'SKU: ${produto.sku}\nCategoria: ${produto.categoria}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Text(
                            'R\$ ${produto.preco.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Qtd: ${produto.quantidade}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),

                      const SizedBox(width: 8), 
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final atualizado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditarProdutoPage(produto: produto),
                            ),
                          );
                          if (atualizado == true) recarregarLista();
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmarExclusao(produto.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
