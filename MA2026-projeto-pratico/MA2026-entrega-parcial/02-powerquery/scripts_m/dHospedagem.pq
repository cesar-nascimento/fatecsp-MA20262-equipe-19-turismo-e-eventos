// dHospedagem -- dimensão de hospedagens (tabela Hospedagem da aba Cadastros)
let
    Fonte = cad_Etapa1{[Item = "Hospedagem", Kind = "Table"]}[Data],
    // D3: espaços extras; nome todo em maiúsculas vira "Cada Palavra"
    NomeLimpo = Table.TransformColumns(Fonte, {{"nome_estabelecimento", each fnNomeProprio(fnLimparTexto(_)), type nullable text}}),
    // D2: "hotel", "Pous.", "Apart Hotel", "Chale" -> grafia oficial
    TipoOficial = Table.TransformColumns(NomeLimpo, {{"tipo_acomodacao", each fnValorOficial(_, lst_TipoAcomodacao), type nullable text}}),
    // D6: "59.0", "139 UHs", "N/I", 0 e -1 -> inteiro positivo ou null
    Capacidades = Table.TransformColumns(TipoOficial, {{"capacidade_total_uhs", fnInteiroPositivo, Int64.Type},
        {"capacidade_total_leitos", fnInteiroPositivo, Int64.Type}}),
    Tipos = Table.TransformColumnTypes(Capacidades, {{"hospedagem_sk", Int64.Type}}),
    SemDuplicatas = Table.Distinct(Tipos, {"hospedagem_sk"}),
    Ordenada = Table.Sort(SemDuplicatas, {{"hospedagem_sk", Order.Ascending}})
in
    Ordenada
