SELECT 
    p.categoria,
    ROUND(SUM(v.quantidade * v.preco_unitario)::numeric, 2) AS receita_total
    FROM vendas v
    LEFT JOIN produtos p ON v.id_produto = p.id_produto
    GROUP BY p.categoria
    ORDER BY receita_total DESC;
