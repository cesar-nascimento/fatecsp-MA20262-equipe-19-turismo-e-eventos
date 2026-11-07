// rej_Avaliacoes -- linhas de FatoAvaliacoes que não chegaram a fAvaliacoes, com o motivo
let
    Origem = stg_Avaliacoes,
    Aceitas = Table.Buffer(Table.SelectColumns(fAvaliacoes, {"Linha_Origem"})),
    Mescla = Table.NestedJoin(Origem, {"Linha_Origem"}, Aceitas, {"Linha_Origem"}, "Aceita", JoinKind.LeftAnti),
    SoRejeitadas = Table.RemoveColumns(Mescla, {"Aceita"}),
    Destinos = List.Buffer(dDestino[destino_sk]),
    Hospedagens = List.Buffer(dHospedagem[hospedagem_sk]),
    Vazio = (v) => v = null or (v is text and Text.Trim(v) = ""),
    ENumero = (v) => Vazio(v) or (try (Number.From(v, "pt-BR") is number) otherwise false),
    // a nota usa ponto decimal: testa com en-US, como em fAvaliacoes
    ENota = (v) => Vazio(v) or (try (Number.From(v, "en-US") is number) otherwise false),
    Diagnostico = (r as record) as text =>
        let
            Valores = List.RemoveMatchingItems(Record.FieldValues(Record.SelectFields(r, ColunasAvaliacoes)), {"", null}),
            Data = fnData(r[data]),
            Nota = r[nota_geral]
        in
            if List.IsEmpty(Valores) then "Linha em branco"
            else if r[id] = null or Text.Trim(Text.From(r[id])) = "" then "id vazio"
            else if Data = null then "Data inválida"
            else if Data < pDataInicio or Data > pDataFim then "Data fora do período"
            else if not (ENumero(r[id]) and ENumero(r[destino_sk]) and ENumero(r[hospedagem_sk])
                and ENota(Nota)) then "Nota não numérica"
            else if Vazio(Nota) then "Nota vazia"
            else if Number.From(Nota, "en-US") < 0 or Number.From(Nota, "en-US") > 5 then "Nota fora da escala (0 a 5)"
            else if not List.Contains(Destinos, Number.From(r[destino_sk], "pt-BR")) then "Destino não cadastrado"
            else if not List.Contains(Hospedagens, Number.From(r[hospedagem_sk], "pt-BR")) then "Hospedagem não cadastrada"
            else "Linha duplicada",
    ComMotivo = Table.AddColumn(SoRejeitadas, "Motivo", each Diagnostico(_), type text),
    Padronizada = fnFormatoRejeitado(ComMotivo, "FatoAvaliacoes", ColunasAvaliacoes)
in
    Padronizada
