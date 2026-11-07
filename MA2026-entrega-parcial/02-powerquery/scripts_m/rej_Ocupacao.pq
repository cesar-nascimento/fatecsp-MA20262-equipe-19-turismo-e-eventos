// rej_Ocupacao -- linhas de FatoHospedagem que não chegaram a fOcupacao, com o motivo
let
    Origem = stg_Ocupacao,
    // 1. linhas lidas que NÃO estão em fOcupacao (junção anti esquerda; aceitas em memória)
    Aceitas = Table.Buffer(Table.SelectColumns(fOcupacao, {"Linha_Origem"})),
    Mescla = Table.NestedJoin(Origem, {"Linha_Origem"}, Aceitas, {"Linha_Origem"}, "Aceita", JoinKind.LeftAnti),
    SoRejeitadas = Table.RemoveColumns(Mescla, {"Aceita"}),
    // 2. apoio ao diagnóstico
    Destinos = List.Buffer(dDestino[destino_sk]),
    Hospedagens = List.Buffer(dHospedagem[hospedagem_sk]),
    Vazio = (v) => v = null or (v is text and Text.Trim(v) = ""),
    ENumero = (v) => Vazio(v) or (try (Number.From(v, "pt-BR") is number) otherwise false),
    // 3. mesma ordem de regras de fOcupacao: o primeiro teste que falha é o motivo
    Diagnostico = (r as record) as text =>
        let
            Valores = List.RemoveMatchingItems(Record.FieldValues(Record.SelectFields(r, ColunasOcupacao)), {"", null}),
            Data = fnData(r[data]),
            Disp = r[quartos_disponiveis],
            Ocup = r[quartos_ocupados],
            Hosp = r[total_hospedes_checkin]
        in
            if List.IsEmpty(Valores) then "Linha em branco"
            else if r[id] = null or Text.Trim(Text.From(r[id])) = "" then "id vazio"
            else if Data = null then "Data inválida"
            else if Data < pDataInicio or Data > pDataFim then "Data fora do período"
            else if not (ENumero(r[id]) and ENumero(r[destino_sk]) and ENumero(r[hospedagem_sk])
                and ENumero(Disp) and ENumero(Ocup) and ENumero(Hosp)) then "Valor não numérico"
            else if Vazio(Disp) or Vazio(Ocup) then "Quartos vazios"
            else if Number.From(Disp, "pt-BR") <= 0 or Number.From(Ocup, "pt-BR") < 0
                or Number.From(Ocup, "pt-BR") > Number.From(Disp, "pt-BR") then "Quartos ocupados maior que disponíveis"
            else if not Vazio(Hosp) and Number.From(Hosp, "pt-BR") < 0 then "Hóspedes negativos"
            else if not List.Contains(Destinos, Number.From(r[destino_sk], "pt-BR")) then "Destino não cadastrado"
            else if not List.Contains(Hospedagens, Number.From(r[hospedagem_sk], "pt-BR")) then "Hospedagem não cadastrada"
            else "Linha duplicada",
    ComMotivo = Table.AddColumn(SoRejeitadas, "Motivo", each Diagnostico(_), type text),
    Padronizada = fnFormatoRejeitado(ComMotivo, "FatoHospedagem", ColunasOcupacao)
in
    Padronizada
