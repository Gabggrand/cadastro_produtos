import 'package:flutter/material.dart';
import '../widgets/input_padrao.dart';
import '../widgets/section_title.dart';
import '../controllers/cadastro_produto_controller.dart';

class CadastrarProdutoPage extends StatefulWidget {
  const CadastrarProdutoPage({super.key});

  @override
  State<CadastrarProdutoPage> createState() => _CadastrarProdutoPageState();
}

class _CadastrarProdutoPageState extends State<CadastrarProdutoPage> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final skuController = TextEditingController();
  final categoriaController = TextEditingController();
  final precoController = TextEditingController();
  final quantidadeController = TextEditingController();

  final cadastroController = CadastroProdutoController();

  bool isLoading = false;

  void salvarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final sucesso = await cadastroController.cadastrarProduto(
      nome: nomeController.text,
      sku: skuController.text,
      categoria: categoriaController.text,
      preco: precoController.text,
      quantidade: quantidadeController.text,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Produto cadastrado com sucesso"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao cadastrar produto"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    skuController.dispose();
    categoriaController.dispose();
    precoController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Produto"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ETAPA
              Row(
                children: const [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blue,
                    child: Text(
                      "1",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Detalhes",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // INFORMAÇÕES BÁSICAS
              const SectionTitle(title: "Informações Básicas"),
              const SizedBox(height: 12),

              InputPadrao(
                label: "Nome do Produto",
                controller: nomeController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe o nome do produto'
                    : null,
              ),
              const SizedBox(height: 16),

              InputPadrao(
                label: "Código SKU",
                controller: skuController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o SKU' : null,
              ),
              const SizedBox(height: 16),

              InputPadrao(
                label: "Categoria",
                controller: categoriaController,
                isDropdown: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a categoria'
                    : null,
              ),

              const SizedBox(height: 24),

              // PREÇO E ESTOQUE
              const SectionTitle(title: "Preço e Estoque"),
              const SizedBox(height: 12),

              InputPadrao(
                label: "Preço de Venda (R\$)",
                controller: precoController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o preço';
                  }
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              InputPadrao(
                label: "Quantidade em Estoque",
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quantidade';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Quantidade inválida';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // BOTÃO SALVAR
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : salvarProduto,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Salvar Produto"),
                ),
              ),

              const SizedBox(height: 12),

              // CANCELAR
              Center(
                child: TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    nomeController.clear();
                    skuController.clear();
                    categoriaController.clear();
                    precoController.clear();
                    quantidadeController.clear();
                  },
                  child: const Text("Cancelar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
