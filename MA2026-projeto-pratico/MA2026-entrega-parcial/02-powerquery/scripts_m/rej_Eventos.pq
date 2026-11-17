// rej_Eventos -- linhas de FatoEventos que não chegaram a fEventos, com o motivo
let
    Origem = stg_Eventos,
    Aceitas = Table.Buffer(Table.SelectColumns(fEventos, {"Linha_Origem"})),
    Mescla = Table.NestedJoin(Origem, {"Linha_Origem"}, Aceitas, {"Linha_Origem"}, "Aceita", JoinKind.LeftAnti),
    SoRejeitadas = Table.RemoveColumns(Mescla, {"Aceita"}),
    Destinos = List.Buffer(dDestino[destino_sk]),
    Eventos = List.Buffer(dEvento[evento_sk]),
    Vazio = (v) => v = null or (v is text and Text.Trim(v) = ""),
    ENumero = (v) => Vazio(v) or (try (Number.From(v, "pt-BR") is number) otherwise false),
    Diagnostico = (r as record) as text =>
        let
            Valores = List.RemoveMatchingItems(Record.FieldValues(Record.SelectFields(r, ColunasEventos)), {"", null}),
            Data = fnData(r[data]),
            Publico = r[publico_real_confirmado]
        in
            if List.IsEmpty(Valores) then "Linha em branco"
            else if r[id] = null or Text.Trim(Text.From(r[id])) = "" then "id vazio"
            else if Data = null then "Data inválida"
            else if Data < pDataInicio or Data > pDataFim then "Data fora do período"
            else if not (ENumero(r[id]) and ENumero(r[destino_sk]) and ENumero(r[evento_sk])
                and ENumero(Publico)) then "Público não numérico"
            else if Vazio(Publico) then "Público vazio"
            else if Number.From(Publico, "pt-BR") < 0 then "Público negativo"
            else if not List.Contains(Destinos, Number.From(r[destino_sk], "pt-BR")) then "Destino não cadastrado"
            else if not List.Contains(Eventos, Number.From(r[evento_sk], "pt-BR")) then "Evento não cadastrado"
            else "Linha duplicada",
    ComMotivo = Table.AddColumn(SoRejeitadas, "Motivo", each Diagnostico(_), type text),
    Padronizada = fnFormatoRejeitado(ComMotivo, "FatoEventos", ColunasEventos)
in
    Padronizada
