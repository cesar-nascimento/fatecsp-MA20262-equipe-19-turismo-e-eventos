# Modelo relacional - Turismo_03_PowerPivot.xlsx

## Origem
Arquivo fornecido: `Turismo_03_PowerPivot.xlsx`. O arquivo contém as tabelas de fatos, dimensões, rejeitados e conferência já carregadas em planilhas. Período da dimensão calendário: 01/01/2024 a 31/12/2025 (731 dias).

## Tabelas e granularidade

| Tabela | Tipo | Grão (uma linha representa) | Chave |
|---|---|---|---|
| fOcupacao | Fato | registro diário de ocupação de uma hospedagem em um destino | id |
| fEventos | Fato | registro de evento em uma data e destino | id |
| fAvaliacoes | Fato | avaliação de uma hospedagem em um destino e data | id |
| dHospedagem | Dimensão | estabelecimento de hospedagem | hospedagem_sk |
| dEvento | Dimensão | evento cadastrado | evento_sk |
| dDestino | Dimensão | destino/bairro | destino_sk |
| dCalendario | Dimensão | dia do calendário | data |
| Rejeitados | Auditoria | registro descartado na etapa de tratamento | sem chave analítica |

## Relacionamentos propostos

Todos devem ser ativos, N:1 do fato para a dimensão, com filtro em direção única (dimensão -> fato).

| # | Lado N (FK) | Lado 1 (PK) |
|---|---|---|
| R1 | fOcupacao[hospedagem_sk] | dHospedagem[hospedagem_sk] |
| R2 | fOcupacao[destino_sk] | dDestino[destino_sk] |
| R3 | fOcupacao[data] | dCalendario[data] |
| R4 | fEventos[evento_sk] | dEvento[evento_sk] |
| R5 | fEventos[destino_sk] | dDestino[destino_sk] |
| R6 | fEventos[data] | dCalendario[data] |
| R7 | fAvaliacoes[hospedagem_sk] | dHospedagem[hospedagem_sk] |
| R8 | fAvaliacoes[destino_sk] | dDestino[destino_sk] |
| R9 | fAvaliacoes[data] | dCalendario[data] |

## Observações importantes
- O modelo possui três tabelas fato que compartilham dimensões conformadas (`dDestino` e `dCalendario`).
- `dHospedagem` filtra `fOcupacao` e `fAvaliacoes`; `dEvento` filtra `fEventos`.
- Não criar relacionamento direto entre tabelas fato.
- `dCalendario[data]` deve ser marcada como Tabela de Datas.
- A coluna `Taxa_Ocupacao` já existe em `fOcupacao`. Para o indicador consolidado, prefira a medida `Taxa de Ocupação % = DIVIDE([Quartos Ocupados],[Quartos Disponíveis])`, evitando média simples de percentuais.
- Conferir os tipos de dados: datas como Data; chaves como número inteiro (ou tipo consistente entre FK e PK); notas e taxas como decimal; contagens como número inteiro.

## Contagens observadas no arquivo

| Tabela | Linhas de dados |
|---|---:|
| fOcupacao | 64.162 |
| fEventos | 546 |
| fAvaliacoes | 10.205 |
| dHospedagem | 440 |
| dEvento | 55 |
| dDestino | 250 |
| dCalendario | 731 |
| Rejeitados | 440 |

## Conferência herdada da etapa anterior
A aba `Conferencia` registra:
- Ocupação: 64.407 lidas, 64.162 aceitas, 245 rejeitadas.
- Eventos: 572 lidas, 546 aceitas, 26 rejeitadas.
- Avaliações: 10.374 lidas, 10.205 aceitas, 169 rejeitadas.
- Total: 75.353 lidas, 74.913 aceitas, 440 rejeitadas.
- Diferença registrada: zero em todas as três origens e no total.

A tabela `Rejeitados` tem 440 linhas e a conferência fecha: 245 + 26 + 169 = 440.

## Medidas
As medidas propostas estão em `dax/medidas_turismo.dax`. Elas cobrem ocupação, eventos, avaliações, capacidade hoteleira, análise temporal e integridade. Antes de marcar como concluído, criar as medidas no Power Pivot e validar o resultado no arquivo.
