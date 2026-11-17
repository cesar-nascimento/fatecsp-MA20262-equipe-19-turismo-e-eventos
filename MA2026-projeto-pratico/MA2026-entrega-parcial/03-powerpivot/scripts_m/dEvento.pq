// dEvento -- dimensão de eventos (tabela Eventos da aba Cadastros)
let
    Fonte = cad_Etapa1{[Item = "Eventos", Kind = "Table"]}[Data],
    NomeLimpo = Table.TransformColumns(Fonte, {{"nome_evento", each fnNomeProprio(fnLimparTexto(_)), type nullable text}}),
    // "MEGA", "Medio", "grande " -> grafia oficial; vazio continua vazio
    PorteOficial = Table.TransformColumns(NomeLimpo, {{"porte_evento", each fnValorOficial(_, lst_PorteEvento), type nullable text}}),
    Tipos = Table.TransformColumnTypes(PorteOficial, {{"evento_sk", Int64.Type}}),
    SemDuplicatas = Table.Distinct(Tipos, {"evento_sk"}),
    Ordenada = Table.Sort(SemDuplicatas, {{"evento_sk", Order.Ascending}})
in
    Ordenada