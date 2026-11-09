// fAvaliacoes -- nota diária por hospedagem, tratada (origem: FatoAvaliacoes)
let
    Origem = stg_Avaliacoes,
    SemLinhasEmBranco = Table.SelectRows(Origem, each not List.IsEmpty(
        List.RemoveMatchingItems(Record.FieldValues(Record.SelectFields(_, ColunasAvaliacoes)), {"", null}))),
    SemIdVazio = Table.SelectRows(SemLinhasEmBranco, each [id] <> null and Text.Trim(Text.From([id])) <> ""),
    DataTratada = Table.TransformColumns(SemIdVazio, {{"data", fnData, type nullable date}}),
    SemDataInvalida = Table.SelectRows(DataTratada, each [data] <> null),
    NoPeriodo = Table.SelectRows(SemDataInvalida, each [data] >= pDataInicio and [data] <= pDataFim),
    BrancosNulos = Table.TransformColumns(NoPeriodo, {{"nota_geral",
        each if _ is text and Text.Trim(_) = "" then null else _}}),
    TiposPtBR = Table.TransformColumnTypes(BrancosNulos, {{"id", Int64.Type}, {"destino_sk", Int64.Type},
        {"hospedagem_sk", Int64.Type}}, "pt-BR"),
    // D6 invertido: a nota vem como texto com PONTO decimal ("4.18"). Em pt-BR o ponto é milhar
    // e "4.18" viraria 418; por isso só esta coluna é convertida com a localidade en-US.
    NotaEnUS = Table.TransformColumnTypes(TiposPtBR, {{"nota_geral", type number}}, "en-US"),
    // "Bom", "Ruim", "excelente" não são número: viram Erro e a linha sai aqui
    SemErrosDeTipo = Table.RemoveRowsWithErrors(NotaEnUS, {"id", "destino_sk", "hospedagem_sk", "nota_geral"}),
    SemNotaVazia = Table.SelectRows(SemErrosDeTipo, each [nota_geral] <> null),
    // escala oficial de 0 a 5; "8.28", "10.00" e números do tipo 45513 ficam fora
    NotaNaEscala = Table.SelectRows(SemNotaVazia, each [nota_geral] >= 0 and [nota_geral] <= 5),
    // D7: mesclagem interna com as chaves dos cadastros (em memória)
    ChavesDestino = Table.Buffer(Table.Distinct(Table.SelectColumns(dDestino, {"destino_sk"}))),
    ChavesHospedagem = Table.Buffer(Table.Distinct(Table.SelectColumns(dHospedagem, {"hospedagem_sk"}))),
    MesclaDestino = Table.NestedJoin(NotaNaEscala, {"destino_sk"}, ChavesDestino, {"destino_sk"}, "Destino", JoinKind.Inner),
    MesclaHospedagem = Table.NestedJoin(MesclaDestino, {"hospedagem_sk"}, ChavesHospedagem, {"hospedagem_sk"}, "Hospedagem", JoinKind.Inner),
    SemColunasMescla = Table.RemoveColumns(MesclaHospedagem, {"Destino", "Hospedagem"}),
    OrdemOriginal = Table.Buffer(Table.Sort(SemColunasMescla, {{"Linha_Origem", Order.Ascending}})),
    SemDuplicatas = Table.Distinct(OrdemOriginal, {"id"}),
    NotaArredondada = Table.TransformColumns(SemDuplicatas, {{"nota_geral", each Number.Round(_, 2), type number}}),
    FormatoFinal = Table.SelectColumns(NotaArredondada, {"id", "data", "destino_sk", "hospedagem_sk",
        "nota_geral", "Linha_Origem"})
in
    FormatoFinal