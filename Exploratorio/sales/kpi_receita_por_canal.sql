SELECT 
    v.canal_venda,
    ROUND(SUM(v.quantidade * v.preco_unitario)::numeric, 2) AS receita_total
    FROM vendas v
    GROUP BY v.canal_venda
    ORDER BY receita_total DESC;
