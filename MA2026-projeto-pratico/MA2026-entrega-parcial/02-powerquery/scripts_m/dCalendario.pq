// dCalendario -- dimensão de datas (tabela Calendario da aba Cadastros).
// Os atributos que dependem só da data são recalculados a partir dela (não se confia no texto digitado).
let
    Fonte = cad_Etapa1{[Item = "Calendario", Kind = "Table"]}[Data],
    DataTratada = Table.TransformColumns(Fonte, {{"data", fnData, type nullable date}}),
    SemDataInvalida = Table.SelectRows(DataTratada, each [data] <> null),
    Recalculada = Table.FromRecords(Table.TransformRows(SemDataInvalida, (r) =>
        let
            d = r[data],
            DiaSemana = Date.DayOfWeek(d, Day.Sunday) + 1
        in
            [data = d,
             ano = Date.Year(d),
             trimestre = Date.QuarterOfYear(d),
             mes = Date.Month(d),
             nome_mes = lst_NomeMes{Date.Month(d) - 1},
             dia = Date.Day(d),
             dia_semana = DiaSemana,
             nome_dia_semana = lst_NomeDiaSemana{DiaSemana - 1},
             flag_fim_de_semana = (DiaSemana = 1 or DiaSemana = 7),
             flag_feriado = fnLogico(r[flag_feriado]),
             estacao_ano = fnValorOficial(r[estacao_ano], lst_Estacao)]),
        type table [data = date, ano = Int64.Type, trimestre = Int64.Type, mes = Int64.Type, nome_mes = text,
                    dia = Int64.Type, dia_semana = Int64.Type, nome_dia_semana = text,
                    flag_fim_de_semana = logical, flag_feriado = nullable logical, estacao_ano = nullable text]),
    SemDuplicatas = Table.Distinct(Recalculada, {"data"}),
    Ordenada = Table.Sort(SemDuplicatas, {{"data", Order.Ascending}})
in
    Ordenada
