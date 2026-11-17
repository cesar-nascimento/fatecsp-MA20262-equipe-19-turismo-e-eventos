// stg_Avaliacoes -- FatoAvaliacoes da aba Bruto, sem tratamento, com o número da linha original
let
    Fonte = cad_Etapa1{[Item = "FatoAvaliacoes", Kind = "Table"]}[Data],
    NoFormato = Table.SelectColumns(Fonte, ColunasAvaliacoes, MissingField.UseNull),
    ComLinha = Table.AddIndexColumn(NoFormato, "Linha_Origem", 2, 1, Int64.Type)
in
    ComLinha
