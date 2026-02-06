import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

class EditarProdutoPage extends StatefulWidget {
  final Produto produto;

  const EditarProdutoPage({super.key, required this.produto});

  @override
  State<EditarProdutoPage> createState() => _EditarProdutoPageState();
}

class _EditarProdutoPageState extends State<EditarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final service = ProdutoService();

  late TextEditingController nomeController;
  late TextEditingController skuController;
  late TextEditingController categoriaController;
  late TextEditingController precoController;
  late TextEditingController quantidadeController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.produto.nome);
    skuController = TextEditingController(text: widget.produto.sku);
    categoriaController = TextEditingController(text: widget.produto.categoria);
    precoController = TextEditingController(
      text: widget.produto.preco.toString(),
    );
    quantidadeController = TextEditingController(
      text: widget.produto.quantidade.toString(),
    );
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final sucesso = await service.atualizarProduto(widget.produto.id, {
      'nome': nomeController.text,
      'sku': skuController.text,
      'categoria': categoriaController.text,
      'preco': double.parse(precoController.text),
      'quantidade': int.parse(quantidadeController.text),
    });

    setState(() => isLoading = false);

    if (sucesso) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar produto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: skuController,
                decoration: const InputDecoration(
                  labelText: 'SKU',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: precoController,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: quantidadeController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : salvar,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Salvar alterações',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
