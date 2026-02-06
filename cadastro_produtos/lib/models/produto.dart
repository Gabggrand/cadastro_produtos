class Produto {
  final int id;
  final String nome;
  final String sku;
  final String categoria;
  final double preco;
  final int quantidade;

  Produto({
    required this.id,
    required this.nome,
    required this.sku,
    required this.categoria,
    required this.preco,
    required this.quantidade,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      sku: json['sku'],
      categoria: json['categoria'],
      preco: (json['preco'] as num).toDouble(),
      quantidade: json['quantidade'],
    );
  }
}