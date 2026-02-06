package com.gabriel.cadastro_produtos_api.exception;

public class ProdutoNaoEncontradoException extends RuntimeException {

    public ProdutoNaoEncontradoException(Long id) {
        super("Produto com ID " + id + " não encontrado");
    }
}