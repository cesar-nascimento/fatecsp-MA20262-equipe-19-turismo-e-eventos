# Etapa 2 – Power Query · Turismo e Eventos (equipe 19)

Arquivo de trabalho: `Turismo_02_PowerQuery.xlsx`. Origem única dos dados: `MA2026-entrega-parcial/01-excel/Turismo_Etapa1_01.xlsx` (somente leitura; o Power Query só lê).

Para atualizar: feche o arquivo da Etapa 1, abra `Turismo_02_PowerQuery.xlsx` e use **Dados → Atualizar Tudo**. A atualização completa é lenta (cerca de 15 a 20 minutos): o arquivo da Etapa 1 tem 13 MB e o Power Query precisa abri-lo em cada consulta carregada. Se o caminho da Etapa 1 mudar (outro computador), altere apenas o parâmetro `pArquivoEtapa1`.

Configuração da pasta (Seção 2.2 do guia): **Obter Dados → Opções de Consulta → Pasta de Trabalho Atual → Privacidade → Ignorar os Níveis de Privacidade** já está marcada neste arquivo. Sem ela, a atualização fica várias vezes mais lenta.

## Parâmetros (grupo 01_Parametros)

| Parâmetro | Valor | Uso |
|---|---|---|
| `pArquivoEtapa1` | `C:\Users\cesar\OneDrive\Documents\GitHub\fatecsp-MA20262-equipe-19-turismo-e-eventos\MA2026-entrega-parcial\01-excel\Turismo_Etapa1_01.xlsx` | arquivo da Etapa 1 (fatos brutos e cadastros) |
| `pDataInicio` | 01/01/2024 | início do período oficial |
| `pDataFim` | 31/12/2025 | fim do período oficial (mesmo intervalo do Calendario) |

## Consultas

| Grupo | Consulta | Carga | O que faz |
|---|---|---|---|
| 02_Funcoes | `fnData` | função | Converte datas (data, série do Excel, `20240315` gravado como número, texto d-m-aaaa / aaaa-m-d). Data inexistente → null. |
| 02_Funcoes | `fnLimparTexto` | função | Equivalente ao ARRUMAR (espaços nas pontas e repetidos). |
| 02_Funcoes | `fnSemAcento`, `fnChave` | função | Chave de comparação: maiúsculas, sem acento, só letras e dígitos. |
| 02_Funcoes | `fnValorOficial` | função | Traz um texto para a grafia de uma lista oficial (com apelidos de `DeParaValores`). |
| 02_Funcoes | `fnUF` | função | Sigla oficial da UF a partir da sigla ou do nome. |
| 02_Funcoes | `fnGrafiaOficial` | função | Unifica variações do mesmo nome numa coluna (cidade, bairro). |
| 02_Funcoes | `fnNomeProprio` | função | Texto todo em maiúsculas/minúsculas → "Cada Palavra" (de/da/do em minúsculas). |
| 02_Funcoes | `fnCoordenada` | função | Latitude/longitude em graus decimais; fora do Brasil, zero ou "N/D" → null. |
| 02_Funcoes | `fnInteiroPositivo` | função | Capacidade como inteiro positivo (`59.0`, `139 UHs`; `N/I`, 0, -1 → null). |
| 02_Funcoes | `fnLogico` | função | TRUE/FALSE, S/N, Não, 0/1 → verdadeiro/falso. |
| 02_Funcoes | `fnTextoOriginal`, `fnFormatoRejeitado` | função | Formato comum das linhas rejeitadas. |
| 03_Cadastros | `cad_Etapa1` | conexão | Abre o arquivo da Etapa 1 (abas, tabelas, nomes). |
| 03_Cadastros | `ColunasOcupacao`, `ColunasEventos`, `ColunasAvaliacoes` | conexão | Colunas-alvo de cada fato, na ordem do dicionário. |
| 03_Cadastros | `lst_TipoAcomodacao`, `lst_PorteEvento`, `lst_Regiao`, `lst_Estacao`, `lst_NomeMes`, `lst_NomeDiaSemana`, `lst_UF` | conexão | Valores oficiais. |
| 03_Cadastros | `DeParaValores` | conexão | Apelidos que a chave não resolve (`Pous.` → `Pousada`). |
| 04_Staging | `stg_Ocupacao`, `stg_Eventos`, `stg_Avaliacoes` | conexão | Fatos brutos da aba Bruto, sem tratamento, com `Linha_Origem`. |
| 04_Staging | `rej_Ocupacao`, `rej_Eventos`, `rej_Avaliacoes` | conexão | Anti-junção com o fato tratado + função `Diagnostico` (motivo). |
| 05_Saida | `fOcupacao` | planilha | Ocupação diária tratada + coluna `Taxa_Ocupacao` (ocupados ÷ disponíveis). |
| 05_Saida | `fEventos` | planilha | Público diário por evento, tratado. |
| 05_Saida | `fAvaliacoes` | planilha | Nota diária por hospedagem, tratada (escala 0 a 5). |
| 05_Saida | `dHospedagem`, `dEvento`, `dDestino`, `dCalendario` | planilha | Dimensões padronizadas a partir da aba Cadastros. |
| 05_Saida | `Rejeitados` | planilha | Toda linha lida que não chegou a um fato, com o motivo e os valores originais. |
| 06_Conferencia | `Conf_Reconciliacao`, `Conf_Motivos` | aba Conferencia | Prova de que nenhuma linha se perdeu e resumo por motivo. |

## Regras de rejeição (na ordem em que são aplicadas)

Toda linha lida termina em um fato ou em `Rejeitados`. A ordem das regras em cada fato é a mesma da função `Diagnostico` da consulta `rej_...` correspondente; ao mudar uma regra, mude as duas.

| Fato | Regra | Motivo em Rejeitados |
|---|---|---|
| todos | todas as colunas vazias | Linha em branco |
| todos | `id` vazio | id vazio |
| todos | data inexistente | Data inválida |
| todos | data fora de 01/01/2024–31/12/2025 | Data fora do período |
| fOcupacao | quartos ou hóspedes em texto (`N/A`) | Valor não numérico |
| fOcupacao | quartos disponíveis ou ocupados vazios | Quartos vazios |
| fOcupacao | disponíveis ≤ 0, ocupados < 0 ou ocupados > disponíveis | Quartos ocupados maior que disponíveis |
| fOcupacao | hóspedes negativos (vazio é aceito) | Hóspedes negativos |
| fEventos | público em texto (`aprox. 89 mil`) | Público não numérico |
| fEventos | público vazio / negativo | Público vazio / Público negativo |
| fAvaliacoes | nota em palavra (`Bom`, `Ruim`, `N/A`…) | Nota não numérica |
| fAvaliacoes | nota vazia | Nota vazia |
| fAvaliacoes | nota < 0 ou > 5 | Nota fora da escala (0 a 5) |
| todos | `destino_sk` fora de dDestino (`9999`) | Destino não cadastrado |
| fOcupacao, fAvaliacoes | `hospedagem_sk` fora de dHospedagem | Hospedagem não cadastrada |
| fEventos | `evento_sk` fora de dEvento | Evento não cadastrado |
| todos | mesmo `id` repetido (fica a 1ª ocorrência) | Linha duplicada |

A nota vem como texto com **ponto** decimal (`"4.18"`). Ela é convertida com a localidade `en-US`; as demais colunas usam `pt-BR`. Em pt-BR, `"4.18"` seria lido como 418.

## Resultado (aba Conferencia)

| Tabela | Lidas | Aceitas | Rejeitadas | Diferença |
|---|---|---|---|---|
| FatoHospedagem → fOcupacao | 64.407 | 64.162 | 245 | 0 |
| FatoEventos → fEventos | 572 | 546 | 26 | 0 |
| FatoAvaliacoes → fAvaliacoes | 10.374 | 10.205 | 169 | 0 |
| **Total** | **75.353** | **74.913** | **440** | **0** |

Dimensões: dHospedagem 440, dEvento 55, dDestino 250 (o `destino_sk` 246 vinha repetido), dCalendario 731.

| Tabela | Motivo | Linhas |
|---|---|---|
| FatoAvaliacoes | Nota fora da escala (0 a 5) | 69 |
| FatoAvaliacoes | Nota vazia | 40 |
| FatoAvaliacoes | Linha duplicada | 30 |
| FatoAvaliacoes | Nota não numérica | 20 |
| FatoAvaliacoes | Hospedagem não cadastrada | 10 |
| FatoEventos | Público não numérico | 8 |
| FatoEventos | Público vazio | 6 |
| FatoEventos | Linha duplicada | 5 |
| FatoEventos | Público negativo | 4 |
| FatoEventos | Destino não cadastrado | 3 |
| FatoHospedagem | Quartos ocupados maior que disponíveis | 60 |
| FatoHospedagem | Linha duplicada | 50 |
| FatoHospedagem | Quartos vazios | 50 |
| FatoHospedagem | Valor não numérico (ex.: `quartos_ocupados = N/A`) | 30 |
| FatoHospedagem | Data fora do período | 15 |
| FatoHospedagem | Destino não cadastrado | 15 |
| FatoHospedagem | Hóspedes negativos | 15 |
| FatoHospedagem | Hospedagem não cadastrada | 10 |

## Decisões pendentes de esclarecimento

- **Notas acima de 5** (`8.28`, `10.00` e números como `45513`, que parecem datas): rejeitadas até se confirmar a escala.
- **Público aproximado** (`aprox. 89 mil`): rejeitado; não se inventa o número.
- **Códigos 9999** em destino e hospedagem: rejeitados; voltam sozinhos se forem incluídos nos cadastros da Etapa 1.
- **Hóspedes vazios** (50 linhas): aceitos em fOcupacao, pois a taxa de ocupação continua mensurável.
- **Hóspedes muito acima dos quartos ocupados** (10 linhas, ex.: 13.600 hóspedes em 182 quartos): aceitos, como o preço fora da referência no guia; continuam pendentes na auditoria.
- **Coordenadas inválidas** (zero, "N/D" ou fora do Brasil): ficam vazias em dDestino (9 latitudes e 8 longitudes).
- **Capacidade** `N/I`, 0 ou negativa: fica vazia em dHospedagem.
- **Porte do evento** vazio (eventos 10 e 38): mantido vazio.
- **dCalendario**: ano, trimestre, mês, nomes de mês e dia da semana e fim de semana são recalculados a partir da data; feriado e estação são padronizados a partir do valor digitado.

## Pastas

- `scripts_m/` – código M de cada consulta (`<consulta>.pq`, UTF-8).
- `dados_limpos/` – `fOcupacao.csv`, `fEventos.csv`, `fAvaliacoes.csv`, exportados das tabelas carregadas no Excel (UTF-8, vírgula como separador, ponto decimal, datas aaaa-mm-dd).
- `evidencias/` – capturas do painel de consultas, das Etapas Aplicadas e da aba Conferencia.
