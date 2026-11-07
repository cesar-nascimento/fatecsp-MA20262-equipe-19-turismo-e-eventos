// stg_Eventos -- FatoEventos da aba Bruto, sem tratamento, com o número da linha original
let
    Fonte = cad_Etapa1{[Item = "FatoEventos", Kind = "Table"]}[Data],
    NoFormato = Table.SelectColumns(Fonte, ColunasEventos, MissingField.UseNull),
    ComLinha = Table.AddIndexColumn(NoFormato, "Linha_Origem", 2, 1, Int64.Type)
in
    ComLinha
