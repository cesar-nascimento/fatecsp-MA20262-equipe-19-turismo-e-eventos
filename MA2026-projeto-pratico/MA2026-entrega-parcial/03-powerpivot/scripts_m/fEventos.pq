// fEventos -- público diário por evento, tratado (origem: FatoEventos)
let
    Origem = stg_Eventos,
    SemLinhasEmBranco = Table.SelectRows(Origem, each not List.IsEmpty(
        List.RemoveMatchingItems(Record.FieldValues(Record.SelectFields(_, ColunasEventos)), {"", null}))),
    SemIdVazio = Table.SelectRows(SemLinhasEmBranco, each [id] <> null and Text.Trim(Text.From([id])) <> ""),
    DataTratada = Table.TransformColumns(SemIdVazio, {{"data", fnData, type nullable date}}),
    SemDataInvalida = Table.SelectRows(DataTratada, each [data] <> null),
    NoPeriodo = Table.SelectRows(SemDataInvalida, each [data] >= pDataInicio and [data] <= pDataFim),
    BrancosNulos = Table.TransformColumns(NoPeriodo, {{"publico_real_confirmado",
        each if _ is text and Text.Trim(_) = "" then null else _}}),
    // "aprox. 89 mil" não é número: vira Erro na conversão e a linha sai aqui
    TiposPtBR = Table.TransformColumnTypes(BrancosNulos, {{"id", Int64.Type}, {"destino_sk", Int64.Type},
        {"evento_sk", Int64.Type}, {"publico_real_confirmado", Int64.Type}}, "pt-BR"),
    SemErrosDeTipo = Table.RemoveRowsWithErrors(TiposPtBR, {"id", "destino_sk", "evento_sk", "publico_real_confirmado"}),
    // público é crítico: vazio ou negativo não se corrige aqui
    SemPublicoVazio = Table.SelectRows(SemErrosDeTipo, each [publico_real_confirmado] <> null),
    PublicoValido = Table.SelectRows(SemPublicoVazio, each [publico_real_confirmado] >= 0),
    // D7: mesclagem interna com as chaves dos cadastros (em memória)
    ChavesDestino = Table.Buffer(Table.Distinct(Table.SelectColumns(dDestino, {"destino_sk"}))),
    ChavesEvento = Table.Buffer(Table.Distinct(Table.SelectColumns(dEvento, {"evento_sk"}))),
    MesclaDestino = Table.NestedJoin(PublicoValido, {"destino_sk"}, ChavesDestino, {"destino_sk"}, "Destino", JoinKind.Inner),
    MesclaEvento = Table.NestedJoin(MesclaDestino, {"evento_sk"}, ChavesEvento, {"evento_sk"}, "Evento", JoinKind.Inner),
    SemColunasMescla = Table.RemoveColumns(MesclaEvento, {"Destino", "Evento"}),
    OrdemOriginal = Table.Buffer(Table.Sort(SemColunasMescla, {{"Linha_Origem", Order.Ascending}})),
    SemDuplicatas = Table.Distinct(OrdemOriginal, {"id"}),
    FormatoFinal = Table.SelectColumns(SemDuplicatas, {"id", "data", "destino_sk", "evento_sk",
        "publico_real_confirmado", "Linha_Origem"})
in
    FormatoFinal