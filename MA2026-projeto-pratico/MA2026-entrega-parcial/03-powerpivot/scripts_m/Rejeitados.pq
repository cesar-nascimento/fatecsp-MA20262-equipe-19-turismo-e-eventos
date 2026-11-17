// Rejeitados -- todas as linhas lidas que não chegaram aos fatos, com o motivo (equivale à Tab_Auditoria)
let
    Anexada = Table.Combine({rej_Ocupacao, rej_Eventos, rej_Avaliacoes}),
    Ordenada = Table.Sort(Anexada, {{"Tabela_Origem", Order.Ascending}, {"Linha_Origem", Order.Ascending}})
in
    Ordenada