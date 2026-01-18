# Plataforma de Dados Ecommerce - Projeto de Engenharia de Dados

## 🎯 O Projeto

Uma empresa de e-commerce está abrindo sua operação digital e precisa usar dados para tomar decisões melhores. Você vai construir um sistema completo de dados que:

- ✅ Analisa vendas, Produtos e clientes
- ✅ Compara preços com o mercado
- ✅ Gera insights inteligentes via Telegran
- ✅ Ajuda o negócio a decisões baseadas em dados

---

## Sobre o Projeto

Este é o **projeto prático de Projeto de Engenharia de Dados**, uma experiência completa onde iremos construir um projeto real de dados, do zero à decisão com IA.

**Stacks utilizadas:**
- **Exploração dos dados:** SQL
- **Ingestão de Dados:** Python & Postgres
- **Arquitetura Medalão & Transformações** SQL & DBT
- **Inteligência Artificial:** N8N, LLM - GPT & Telegran

---

Download dos arquivos das aulas: [Drive](https://drive.google.com/drive/folders/1ov9F7bYVJyDDBy2Xn4HDYSycTuZAfpWu?usp=sharing)
---

## Desafios do Projeto

### SQL & Analytics
**Objetivo:** Entender o negócio com SQL

- Descobrir os produtos mais vendidos
- Identificar os principais clientes
- Comparar preços com o mercado
- Criar segmentações de clientes

**Skils Utilizadas:** Pensar como analista de dados usando SQL.

### Python & Ingestão de Dados
**Objetivo:** Dados não nascem prontos

- Ler dados de CSVs e combinar múltiplos arquivos
- Consumir APIs REST para buscar dados externos
- Fazer web scraping para coletar dados de sites
- Conectar com bancos de dados (PostgreSQL)
- Tratar e limpar dados inconsistentes
- Exportar dados para diferentes formatos

**Skils Utilizadas:** Trabalhar como engenheiro de dados usando Python para integrar diferentes fontes de dados.

### Engenharia de Dados
**Objetivo:** Transformar scripts em produto

- Arquitetura de dados
- Modelagem analítica
- Pipelines e orquestração

**Skils Utilizadas:** Modelagem e Transformação do DBT

### Inteligência Artificial
**Objetivo:** Dados tomando decisões

- IA interpretando dados
- Comparação automática de preços
- Alertas inteligentes

**Exemplo:** "Esse produto está mais caro que o mercado."

---

## 🎲 Os 4 Datasets do Projeto

Este projeto usa **4 datasets sintéticos** gerados com Faker para simular dados reais de e-commerce:

- **`produtos.csv`** - 200 produtos do catálogo
- **`clientes.csv`** - 50 clientes cadastrados
- **`vendas.csv`** - ~3.000 vendas (últimos 30 dias)
- **`preco_competidores.csv`** - ~680 preços de concorrentes

**Características:**
- Dados realistas (não aleatórios)
- Distribuições não-normais (como dados reais)
- Relacionamentos entre tabelas
- Problemas de integridade para prática (produtos não vendidos, vendas não cadastradas)

---

## Gerar KPIs Negócio:
- sales - Vendas & ReceitA:
- [ ] kpi_produtos_top_receita.sql;
- [ ] kpi_produtos_top_quantidade.sql;
- [ ] Kpi_receita_por_categoria.sql;
- [ ] kpi_receita_por_canal.sql;
- [ ] kpi_receita_por_marca.sql;
- [ ] kpi_vendas_temporais.sql
- customer_success -  # 👥 Data Mart: Customer Success:
- [ ] kpi_clientes_segmentacao.sql;
- [ ] kpi_clientes_top.sql
- pricing - 💰 Data Mart: Pricing & Competitividade
- [ ] kpi_precos_competitividade.sql;
- [ ] kpi_produtos_criticos_preco.sql

---