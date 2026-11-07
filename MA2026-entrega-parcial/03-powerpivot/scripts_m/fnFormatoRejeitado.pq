// fnFormatoRejeitado -- deixa as linhas rejeitadas de qualquer fato no mesmo formato, para anexar
(tabela as table, nomeTabela as text, colunas as list) as table =>
let
    ComTabela = Table.AddColumn(tabela, "Tabela_Origem", each nomeTabela, type text),
    ComId = Table.AddColumn(ComTabela, "ID_Registro", each fnTextoOriginal([id]), type text),
    ComData = Table.AddColumn(ComId, "Data_Original", each fnTextoOriginal([data]), type text),
    ComValores = Table.AddColumn(ComData, "Valores_Originais", each
        Text.Combine(List.Transform(colunas, (c) => c & "=" & fnTextoOriginal(Record.Field(_, c))), " | "), type text),
    Selecionadas = Table.SelectColumns(ComValores,
        {"Tabela_Origem", "Linha_Origem", "ID_Registro", "Data_Original", "Motivo", "Valores_Originais"})
in
    Selecionadas
