-- ============================================
-- CAMADA GOLD: KPI - Produtos Críticos (Preço)
-- ============================================
-- Conceito: Terceira camada da arquitetura Medalhão
-- Objetivo: Identificar produtos que precisam de ajuste de preço urgente
-- 
-- Produtos críticos:
-- - Top sellers que estão mais caros que o mercado
-- - Produtos com maior diferença de preço vs concorrente mais barato

WITH produtos_top_sellers AS (
    SELECT
        v.id_produto,
        SUM(v.quantidade * v.preco_unitario) AS receita_total,
        SUM(v.quantidade) AS quantidade_total
    FROM vendas v
    GROUP BY v.id_produto
    ORDER BY receita_total DESC
    LIMIT 10
),


precos_por_produto AS (
    SELECT
        p.id_produto,
        p.nome_produto,
        p.categoria,
        p.marca,
        p.preco_atual AS nosso_preco,
        AVG(pc.preco_concorrente) AS preco_medio_concorrentes,
        MIN(pc.preco_concorrente) AS preco_minimo_concorrentes,
        MAX(pc.preco_concorrente) AS preco_maximo_concorrentes,
        COUNT(DISTINCT pc.nome_concorrente) AS total_concorrentes
    FROM produtos p
    LEFT JOIN preco_competidores pc
        ON p.id_produto = pc.id_produto
    WHERE pc.preco_concorrente IS NOT NULL
    GROUP BY 1, 2, 3, 4, 5
),

vendas_por_produto AS (
    SELECT
        id_produto,
        ROUND(SUM(quantidade * preco_unitario)::numeric, 2) AS receita_total,
        SUM(quantidade) AS quantidade_total   FROM vendas
    GROUP BY 1
),

kpi_precos_competitividade AS (
    SELECT
        pp.id_produto AS id_produto,
        pp.nome_produto,
        pp.categoria,
        pp.marca,
        pp.nosso_preco,
        pp.preco_medio_concorrentes,
        pp.preco_minimo_concorrentes,
        pp.preco_maximo_concorrentes,
        pp.total_concorrentes,
        -- Diferença percentual
        CASE 
            WHEN pp.preco_medio_concorrentes > 0 THEN
                ROUND((((pp.nosso_preco - pp.preco_medio_concorrentes) / pp.preco_medio_concorrentes) * 100) ::numeric, 2)
            ELSE NULL
        END AS diferenca_percentual_vs_media,
        CASE 
            WHEN pp.preco_minimo_concorrentes > 0 THEN
                ROUND((((pp.nosso_preco - pp.preco_minimo_concorrentes) / pp.preco_minimo_concorrentes) * 100) ::numeric, 2)
            ELSE NULL
        END AS diferenca_percentual_vs_minimo,
        -- Classificação
        CASE 
            WHEN pp.nosso_preco > pp.preco_maximo_concorrentes THEN 'MAIS_CARO_QUE_TODOS'
            WHEN pp.nosso_preco < pp.preco_minimo_concorrentes THEN 'MAIS_BARATO_QUE_TODOS'
            WHEN pp.nosso_preco > pp.preco_medio_concorrentes THEN 'ACIMA_DA_MEDIA'
            WHEN pp.nosso_preco < pp.preco_medio_concorrentes THEN 'ABAIXO_DA_MEDIA'
            ELSE 'NA_MEDIA'
        END AS classificacao_preco,
        -- Dados de vendas
        COALESCE(vp.receita_total, 0) AS receita_total,
        COALESCE(vp.quantidade_total, 0) AS quantidade_total
    FROM precos_por_produto pp
    LEFT JOIN vendas_por_produto vp
        ON pp.id_produto = vp.id_produto
    WHERE pp.preco_medio_concorrentes IS NOT NULL
    ORDER BY diferenca_percentual_vs_media DESC
)

SELECT
    pc.id_produto,
    pc.nome_produto,
    pc.categoria,
    pc.marca,
    pc.nosso_preco,
    pc.preco_minimo_concorrentes,
    pc.diferenca_percentual_vs_minimo,
    pc.classificacao_preco,
    pts.receita_total,
    pts.quantidade_total,
    -- Flag de criticidade
    CASE 
        WHEN pc.classificacao_preco IN ('MAIS_CARO_QUE_TODOS', 'ACIMA_DA_MEDIA')
             AND pts.receita_total > 0 THEN TRUE
        ELSE FALSE
    END AS flag_produto_critico
FROM kpi_precos_competitividade pc
INNER JOIN produtos_top_sellers pts
    ON pc.id_produto = pts.id_produto
WHERE pc.classificacao_preco IN ('MAIS_CARO_QUE_TODOS', 'ACIMA_DA_MEDIA')
ORDER BY pc.diferenca_percentual_vs_minimo DESC