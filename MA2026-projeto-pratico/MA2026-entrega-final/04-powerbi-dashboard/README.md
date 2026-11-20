# 04-powerbi-dashboard — Turismo e Eventos (Equipe 19)

Rascunho do Power BI feito por Vicente (Vince) em 20/11/2026, commitado para o grupo revisar e corrigir.

## Arquivos
- `Turismo_Dashboard.pbix` — modelo + 3 páginas: Visão Executiva, Eventos, Sazonalidade e avaliações.
- `Turismo_Modelo_PowerBI.xlsx` — fonte das 7 tabelas (dCalendario, dDestino, dEvento, dHospedagem, fOcupacao, fEventos, fAvaliacoes).
- `medidas_powerbi.dax.txt` — DAX das medidas.
- `Dashboard_Turismo_Equipe19_capturas.pdf` — PDF das 3 páginas (feito de capturas de tela, texto não copiável).

## O que foi feito
Modelo estrela (3 fatos, 4 dimensões, relações N:1), 8 medidas DAX pedidas + `Taxa Ocupação %` (SUM ocupados / SUM disponíveis). Conferência: ocupação geral 59,09%, com evento 82,9%, sem evento 59,0%.

## Para os colegas corrigirem (pendências conhecidas)
1. Conferir as 9 relações N:1 em Gerenciar relações (não revisei uma a uma).
2. `Taxa Ocupação %` é medida extra; manter ou ajustar.
3. Exportar PDF copiável (Arquivo > Exportar > PDF); o atual é de capturas.
4. Colunas calculadas de dHospedagem (Nota Média Hospedagem, Faixa de Nota) e gráfico por Faixa de Nota: conferir.
5. Nomes das tabelas diferem da proposta (Fato_Turismo etc.); explicar no relatório.
6. Falta Relatório Final (16 seções), slides e Tabela de Responsabilidades.
Para corrigir: abrir o .pbix, ajustar e sobrescrever (arquivo binário, não faz merge; avisem no grupo antes de editar).
