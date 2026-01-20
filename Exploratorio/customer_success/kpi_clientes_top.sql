SELECT 
    c.nome_cliente,
    SUM(v.quantidade * v.preco_unitario) AS receita_total
    FROM vendas v
    LEFT JOIN clientes c ON v.id_cliente = c.id_cliente
    GROUP BY c.nome_cliente
    ORDER BY receita_total DESC
    LIMIT 10;