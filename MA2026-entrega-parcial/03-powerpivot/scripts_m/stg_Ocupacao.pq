// stg_Ocupacao -- FatoHospedagem da aba Bruto, sem tratamento, com o número da linha original
let
    Fonte = cad_Etapa1{[Item = "FatoHospedagem", Kind = "Table"]}[Data],
    // formato-alvo; coluna ausente vira coluna de nulos, coluna extra é descartada
    NoFormato = Table.SelectColumns(Fonte, ColunasOcupacao, MissingField.UseNull),
    // Linha_Origem = linha na aba Bruto (1ª linha de dados = 2)
    ComLinha = Table.AddIndexColumn(NoFormato, "Linha_Origem", 2, 1, Int64.Type)
in
    ComLinha
