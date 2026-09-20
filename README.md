# 🏖️ Turismo e Eventos: Ocupação, Sazonalidade e Avaliações

![Status](https://img.shields.io/badge/Status-Em%20Desenvolvimento-blue)
![Instituição](https://img.shields.io/badge/Institui%C3%A7%C3%A3o-FATEC%20SP-red)
![Disciplina](https://img.shields.io/badge/Disciplina-Microinform%C3%A1tica%20Aplicada-orange)

Este repositório contém o **Projeto Evolutivo de Microinformática Aplicada (ILP590)**, desenvolvido para analisar dados relacionados ao turismo, eventos e ocupação. O objetivo central é compreender como a sazonalidade, a realização de eventos e as avaliações dos visitantes influenciam a movimentação turística e a ocupação dos destinos.

---

## 🏛️ Contexto Acadêmico
- **Centro Paula Souza - FATEC SP**
- **Curso:** Tecnologia em Análise e Desenvolvimento de Sistemas (ADS)
- **Disciplina:** Microinformática Aplicada (ILP590)
- **Docente:** Prof. Veríssimo
- **Semestre:** 2º/2026

## 👥 Equipe 19

| RA | Nome Completo | Papel / Função Principal |
| :--- | :--- | :--- |
| 0020482521048 | Vicente O. Fresillo | Engenharia de Dados / Excel |
| 22106311 | Victoria Oliveira de Souza | Modelagem Power Query / DAX |
| 22106759 | Amanda Pires Cardoso | Automação VBA & APIs |
| 0020482421030 | MARINA G F B BUENO | Banco de Dados SQL / Power BI |
| 0020482313040 | César Rocha Nascimento | Programador API |
| 0020482313026 | RENAN SILVA DE MELO | Gerente do Projeto |
| 0020482313097 | PEDRO HENRIQUE OLIVEIRA DE FARIAS | QA |

---

## 🎯 Problema de Negócio e Objetivo

A ausência de uma visão consolidada sobre os dados de turismo dificulta a identificação dos fatores que influenciam a movimentação turística. 

**Pergunta Central:** *Como a sazonalidade, os eventos e as avaliações influenciam o turismo e a ocupação dos destinos?*

**Solução Proposta:** Uma plataforma de inteligência de dados que integra informações brutas, trata, padroniza e relaciona tudo em um dashboard interativo no Power BI para apoiar a tomada de decisão no setor de turismo e eventos.

---

## 🚀 Tecnologias e Ferramentas Utilizadas

O pipeline de dados do projeto segue o fluxo de evolução técnica exigido pela disciplina:

1. 📗 **Excel Avançado:** Estruturação, padronização e auditoria da base bruta.
2. ⚙️ **Power Query (Linguagem M):** ETL (Extração, Transformação e Carga) para limpeza e consolidação de dados.
3. 🧮 **Power Pivot & DAX:** Modelagem dimensional (Star Schema) e criação de KPIs analíticos.
4. 🤖 **VBA:** Automação de rotinas operacionais através de macros personalizadas.
5. 🗄️ **Banco de Dados Relacional (SQL):** DDL e DML para persistência e consultas analíticas avançadas.
6. 🌐 **APIs REST Externas:** Enriquecimento da base com dados públicos.
7. 📊 **Power BI:** Criação do Dashboard final com navegação interativa e filtros dinâmicos.

---

## 🔌 Integração com APIs

Para enriquecer as análises e relacionar fatores externos aos nossos KPIs, consumimos as seguintes APIs:
* **[Open-Meteo](https://open-meteo.com/):** Extração de dados climáticos (temperatura, precipitação) para correlacionar o clima com as taxas de ocupação.
* **[API IBGE](https://servicodados.ibge.gov.br/api/docs):** Padronização e identificação das características geográficas dos municípios analisados.

---

## 🗂️ Modelagem de Dados (Star Schema)

A arquitetura do banco de dados analítico foi desenhada no modelo estrela (Star Schema):

* **Tabela Fato:** `Fato_Turismo` (Volume de visitantes, hospedagens, taxa de ocupação, avaliações, etc.)
* **Tabelas Dimensão:** 
  * `Dim_Calendario`
  * `Dim_Localidade`
  * `Dim_Evento`
  * `Dim_Avaliacao`

---

    ├── 01-vba/               # Módulos exportados (.bas) e planilhas com macro
    ├── 02-bancodedados-sql/  # Scripts DDL (Criação) e DML (Consultas)
    ├── 03-api-web/           # Documentação e scripts de extração JSON
    └── 04-powerbi-dashboard/ # Arquivo final .pbix
```
