// dDestino -- dimensão de destinos (tabela Localidades da aba Cadastros)
let
    Fonte = cad_Etapa1{[Item = "Localidades", Kind = "Table"]}[Data],
    TextosLimpos = Table.TransformColumns(Fonte, {{"bairro", fnLimparTexto, type nullable text},
        {"cidade", fnLimparTexto, type nullable text}}),
    // D4: "Belem", "BELÉM", "  Belém " -> uma só grafia por cidade e por bairro
    CidadeOficial = fnGrafiaOficial(TextosLimpos, "cidade"),
    BairroOficial = fnGrafiaOficial(CidadeOficial, "bairro"),
    // "ba", "Mato Grosso do Sul" -> sigla oficial
    EstadoOficial = Table.TransformColumns(BairroOficial, {{"estado", fnUF, type nullable text}}),
    RegiaoOficial = Table.TransformColumns(EstadoOficial, {{"regiao_geografica", each fnValorOficial(_, lst_Regiao), type nullable text}}),
    // D6: coordenadas sem vírgula, com ponto ou com hemisfério; fora do Brasil -> null
    Coordenadas = Table.TransformColumns(RegiaoOficial, {{"latitude", each fnCoordenada(_, -34, 6), type nullable number},
        {"longitude", each fnCoordenada(_, -74, -28), type nullable number}}),
    Tipos = Table.TransformColumnTypes(Coordenadas, {{"destino_sk", Int64.Type}}),
    // D8: destino_sk 246 aparece duas vezes no cadastro
    OrdemOriginal = Table.Buffer(Table.Sort(Tipos, {{"destino_sk", Order.Ascending}})),
    SemDuplicatas = Table.Distinct(OrdemOriginal, {"destino_sk"})
in
    SemDuplicatas