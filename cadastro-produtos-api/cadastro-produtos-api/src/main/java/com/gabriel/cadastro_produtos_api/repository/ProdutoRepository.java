package com.gabriel.cadastro_produtos_api.repository;

import com.gabriel.cadastro_produtos_api.domain.Produto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProdutoRepository extends JpaRepository<Produto, Long> {
}
