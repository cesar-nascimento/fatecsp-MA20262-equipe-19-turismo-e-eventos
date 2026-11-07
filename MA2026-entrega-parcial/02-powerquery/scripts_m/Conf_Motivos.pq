// Conf_Motivos -- quantas linhas por tabela e motivo
let
    Agrupada = Table.Group(Rejeitados, {"Tabela_Origem", "Motivo"}, {{"Linhas", each Table.RowCount(_), Int64.Type}}),
    Ordenada = Table.Sort(Agrupada, {{"Tabela_Origem", Order.Ascending}, {"Linhas", Order.Descending}, {"Motivo", Order.Ascending}})
in
    Ordenada
