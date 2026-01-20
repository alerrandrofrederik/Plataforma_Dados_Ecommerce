-- ============================================
-- CAMADA GOLD: KPI - Segmentação de Clientes
-- ============================================
-- Conceito: Terceira camada da arquitetura Medalhão
-- Objetivo: Criar segmentação de clientes baseada em receita
-- 
-- Segmentação:
-- - VIP: Receita >= R$ 10.000
-- - TOP_TIER: Receita >= R$ 5.000 e < R$ 10.000
-- - REGULAR: Receita < R$ 5.000


WITH receitas_clientes AS (
SELECT 
    c.id_cliente,
    c.nome_cliente,
    c.estado,
    SUM(v.quantidade * v.preco_unitario) AS receita_total,
    COUNT(DISTINCT v.id_venda) AS total_compras,
    ROUND(AVG(v.quantidade * v.preco_unitario)::NUMERIC, 2) AS ticket_medio,
    MIN(v.data_venda :: DATE) AS data_primeira_compra,
    MAX(v.data_venda :: DATE) AS data_ultima_compra
    FROM vendas v
    LEFT JOIN clientes c ON v.id_cliente = c.id_cliente
    GROUP BY c.id_cliente, c.nome_cliente, c.estado
)
SELECT 
    rc.id_cliente,
    rc.nome_cliente,
    rc.estado,
    rc.receita_total,
    rc.total_compras,
    rc.ticket_medio,
    rc.data_primeira_compra,
    rc.data_ultima_compra,
-- Segmentação usando CASE WHEN
    CASE 
        WHEN rc.receita_total >= 10000 THEN 'VIP'
        WHEN rc.receita_total >= 5000 THEN 'TOP_TIER'
        ELSE 'REGULAR'
    END AS segmento_cliente,
-- Ranking
    ROW_NUMBER() OVER (ORDER BY receita_total DESC) AS ranking_receitaz
FROM receitas_clientes rc
ORDER BY rc.receita_total DESC; 