// Conf_Reconciliacao -- lidas - aceitas - rejeitadas tem de dar zero em cada fato
let
    Linha = (nome as text, lidas as table, aceitas as table, rejeitadas as table) as list =>
        let
            L = Table.RowCount(lidas),
            A = Table.RowCount(aceitas),
            R = Table.RowCount(rejeitadas)
        in
            {nome, L, A, R, L - A - R},
    Linhas = {
        Linha("FatoHospedagem -> fOcupacao", stg_Ocupacao, fOcupacao, rej_Ocupacao),
        Linha("FatoEventos -> fEventos", stg_Eventos, fEventos, rej_Eventos),
        Linha("FatoAvaliacoes -> fAvaliacoes", stg_Avaliacoes, fAvaliacoes, rej_Avaliacoes)},
    Total = {"Total", List.Sum(List.Transform(Linhas, each _{1})), List.Sum(List.Transform(Linhas, each _{2})),
        List.Sum(List.Transform(Linhas, each _{3})), List.Sum(List.Transform(Linhas, each _{4}))},
    Resultado = #table(type table [Tabela = text, Lidas = Int64.Type, Aceitas = Int64.Type,
        Rejeitadas = Int64.Type, #"Diferença (deve ser 0)" = Int64.Type], Linhas & {Total})
in
    Resultado
