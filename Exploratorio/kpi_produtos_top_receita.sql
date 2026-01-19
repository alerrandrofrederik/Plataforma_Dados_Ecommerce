SELECT 
    p.nome_produto,
    SUM(v.quantidade * v.preco_unitario) AS receita_total
    FROM vendas v
    LEFT JOIN produtos p ON v.id_produto = p.id_produto
    GROUP BY p.nome_produto
    ORDER BY receita_total DESC
    LIMIT 10;