// fOcupacao -- ocupação diária por hospedagem, tratada (origem: FatoHospedagem)
let
    Origem = stg_Ocupacao,
    // ---------- linhas em branco e chave vazia ----------
    SemLinhasEmBranco = Table.SelectRows(Origem, each not List.IsEmpty(
        List.RemoveMatchingItems(Record.FieldValues(Record.SelectFields(_, ColunasOcupacao)), {"", null}))),
    SemIdVazio = Table.SelectRows(SemLinhasEmBranco, each [id] <> null and Text.Trim(Text.From([id])) <> ""),
    // ---------- D1: datas (aaaammdd como número) e período ----------
    DataTratada = Table.TransformColumns(SemIdVazio, {{"data", fnData, type nullable date}}),
    SemDataInvalida = Table.SelectRows(DataTratada, each [data] <> null),
    NoPeriodo = Table.SelectRows(SemDataInvalida, each [data] >= pDataInicio and [data] <= pDataFim),
    // texto em branco ("" ou espaços) vira null antes da conversão de tipo
    BrancosNulos = Table.TransformColumns(NoPeriodo, List.Transform({"quartos_disponiveis", "quartos_ocupados",
        "total_hospedes_checkin"}, (c) => {c, each if _ is text and Text.Trim(_) = "" then null else _})),
    // ---------- D6: tipos com localidade pt-BR ----------
    TiposPtBR = Table.TransformColumnTypes(BrancosNulos, {{"id", Int64.Type}, {"destino_sk", Int64.Type},
        {"hospedagem_sk", Int64.Type}, {"quartos_disponiveis", Int64.Type}, {"quartos_ocupados", Int64.Type},
        {"total_hospedes_checkin", Int64.Type}}, "pt-BR"),
    SemErrosDeTipo = Table.RemoveRowsWithErrors(TiposPtBR, {"id", "destino_sk", "hospedagem_sk",
        "quartos_disponiveis", "quartos_ocupados", "total_hospedes_checkin"}),
    // ---------- D5: quartos são críticos (sem eles não há taxa de ocupação) ----------
    SemQuartosVazios = Table.SelectRows(SemErrosDeTipo, each [quartos_disponiveis] <> null and [quartos_ocupados] <> null),
    QuartosCoerentes = Table.SelectRows(SemQuartosVazios, each [quartos_disponiveis] > 0
        and [quartos_ocupados] >= 0 and [quartos_ocupados] <= [quartos_disponiveis]),
    // hóspedes vazio é aceito (não crítico); negativo é rejeitado
    HospedesValidos = Table.SelectRows(QuartosCoerentes, each [total_hospedes_checkin] = null or [total_hospedes_checkin] >= 0),
    // ---------- D7: mesclagem interna com as chaves dos cadastros ----------
    // as chaves ficam em memória (Table.Buffer) para a mesclagem não recalcular o cadastro a cada linha
    ChavesDestino = Table.Buffer(Table.Distinct(Table.SelectColumns(dDestino, {"destino_sk"}))),
    ChavesHospedagem = Table.Buffer(Table.Distinct(Table.SelectColumns(dHospedagem, {"hospedagem_sk"}))),
    MesclaDestino = Table.NestedJoin(HospedesValidos, {"destino_sk"}, ChavesDestino, {"destino_sk"}, "Destino", JoinKind.Inner),
    MesclaHospedagem = Table.NestedJoin(MesclaDestino, {"hospedagem_sk"}, ChavesHospedagem, {"hospedagem_sk"}, "Hospedagem", JoinKind.Inner),
    SemColunasMescla = Table.RemoveColumns(MesclaHospedagem, {"Destino", "Hospedagem"}),
    // ---------- D8: duplicidade pelo id (fica a 1ª ocorrência) ----------
    OrdemOriginal = Table.Buffer(Table.Sort(SemColunasMescla, {{"Linha_Origem", Order.Ascending}})),
    SemDuplicatas = Table.Distinct(OrdemOriginal, {"id"}),
    // ---------- coluna personalizada ----------
    TaxaOcupacao = Table.AddColumn(SemDuplicatas, "Taxa_Ocupacao",
        each Number.Round([quartos_ocupados] / [quartos_disponiveis], 4), type number),
    FormatoFinal = Table.SelectColumns(TaxaOcupacao, {"id", "data", "destino_sk", "hospedagem_sk",
        "quartos_disponiveis", "quartos_ocupados", "total_hospedes_checkin", "Taxa_Ocupacao", "Linha_Origem"})
in
    FormatoFinal