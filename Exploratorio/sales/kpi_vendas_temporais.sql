WITH tb_vendas AS (
    SELECT 
    v.id_venda,
    v.id_cliente,
    v.quantidade,
    v.data_venda,
    ROUND(v.quantidade * v.preco_unitario ::numeric, 2) AS receita_total,
    ----datas temporais
    EXTRACT(YEAR FROM v.data_venda) AS ano_venda,
    EXTRACT(MONTH FROM v.data_venda) AS mes_venda,
    EXTRACT(DAY FROM v.data_venda) AS dia_venda,
    CASE EXTRACT(DOW FROM v.data_venda)
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
    END AS dia_da_semana,
    EXTRACT(HOUR FROM v.data_venda) AS hora_venda

    FROM vendas v
)

SELECT
    v.data_venda,
    v.ano_venda,
    v.mes_venda,
    v.dia_venda,
    v.dia_da_semana,
    v.hora_venda,
    SUM(v.receita_total) AS receita_total,
    sum(v.quantidade) AS quantidade_total,
    COUNT(v.id_venda) AS total_vendas,
    COUNT(DISTINCT v.id_cliente) AS total_clientes_unicos,
    ROUND(AVG(v.receita_total) ::numeric, 2) AS ticket_medio
    FROM tb_vendas v
    GROUP BY 1,2,3,4,5,6
    ORDER BY v.data_venda DESC, hora_venda;
