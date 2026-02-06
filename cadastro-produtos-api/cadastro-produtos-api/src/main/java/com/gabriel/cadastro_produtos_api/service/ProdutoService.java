package com.gabriel.cadastro_produtos_api.service;

import com.gabriel.cadastro_produtos_api.domain.Produto;
import com.gabriel.cadastro_produtos_api.repository.ProdutoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.gabriel.cadastro_produtos_api.exception.ProdutoNaoEncontradoException;
import java.util.List;

@Service
public class ProdutoService {

    @Autowired
    private ProdutoRepository repository;

    public Produto salvar(Produto produto) {
        return repository.save(produto);
    }

    public Produto buscarPorId(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ProdutoNaoEncontradoException(id));
    }

    public Produto atualizar(Long id, Produto produto) {
        Produto existente = buscarPorId(id);

        existente.setNome(produto.getNome());
        existente.setSku(produto.getSku());
        existente.setCategoria(produto.getCategoria());
        existente.setPreco(produto.getPreco());
        existente.setQuantidade(produto.getQuantidade());

        return repository.save(existente);
    }

    public void deletar(Long id) {
        Produto produto = buscarPorId(id);
        repository.delete(produto);
    }

    public List<Produto> listar() {
        return repository.findAll();
    }
}
