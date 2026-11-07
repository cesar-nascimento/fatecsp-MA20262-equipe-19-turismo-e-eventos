// fnGrafiaOficial -- unifica variações de um mesmo nome dentro de uma coluna (cidade, bairro).
// Variações com a mesma chave ("Belem", "Belém", "  BELÉM ") recebem uma só grafia:
// a que tem acento, mistura maiúsculas e minúsculas e é mais frequente, nessa ordem de preferência
// (se só existir em MAIÚSCULAS ou minúsculas, vira "Cada Palavra").
(tabela as table, coluna as text) as table =>
let
    ComChave = Table.AddColumn(tabela, "__Chave", each fnChave(Record.Field(_, coluna)), type nullable text),
    Grafias = Table.Group(ComChave, {"__Chave", coluna}, {{"__Qtd", each Table.RowCount(_), Int64.Type}}),
    ComCaixa = Table.AddColumn(Grafias, "__CaixaUnica", each
        let v = Record.Field(_, coluna) in
            if v = null or v = Text.Upper(v) or v = Text.Lower(v) then 1 else 0, Int64.Type),
    ComAcento = Table.AddColumn(ComCaixa, "__SemAcento", each
        let v = Record.Field(_, coluna) in if v <> null and v <> fnSemAcento(v) then 0 else 1, Int64.Type),
    Oficiais = Table.Group(ComAcento, {"__Chave"}, {{"__Oficial", each
        let
            Escolhida = Record.Field(Table.First(Table.Sort(_, {{"__SemAcento", Order.Ascending},
                {"__CaixaUnica", Order.Ascending}, {"__Qtd", Order.Descending}, {coluna, Order.Ascending}})), coluna)
        in
            fnNomeProprio(Escolhida),
        type nullable text}}),
    Mescla = Table.NestedJoin(ComChave, {"__Chave"}, Table.Buffer(Oficiais), {"__Chave"}, "__Mescla", JoinKind.LeftOuter),
    Expandida = Table.ExpandTableColumn(Mescla, "__Mescla", {"__Oficial"}),
    SemOriginal = Table.RemoveColumns(Expandida, {coluna, "__Chave"}),
    Renomeada = Table.RenameColumns(SemOriginal, {{"__Oficial", coluna}}),
    Reordenada = Table.ReorderColumns(Renomeada, Table.ColumnNames(tabela))
in
    Reordenada
