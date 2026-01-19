SELECT 
    p.nome_produto,
    SUM(v.quantidade) AS Qtd_Vendido
    FROM vendas v
    LEFT JOIN produtos p ON v.id_produto = p.id_produto
    GROUP BY p.nome_produto
    ORDER BY Qtd_Vendido DESC
    LIMIT 10;