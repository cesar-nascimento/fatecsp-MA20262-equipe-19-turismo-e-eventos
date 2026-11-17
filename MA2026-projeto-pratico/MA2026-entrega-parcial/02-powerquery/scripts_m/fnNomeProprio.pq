// fnNomeProprio -- texto todo em MAIÚSCULAS ou minúsculas vira "Cada Palavra", com de/da/do/dos/das/e em minúsculas
(texto as nullable text) as nullable text =>
let
    Palavras = if texto = null then {} else Text.Split(Text.Proper(texto), " "),
    Conectivos = {"De", "Da", "Do", "Das", "Dos", "E"},
    Ajustadas = List.Transform(List.Positions(Palavras), each
        if _ > 0 and List.Contains(Conectivos, Palavras{_}) then Text.Lower(Palavras{_}) else Palavras{_})
in
    if texto = null then null
    else if texto = Text.Upper(texto) or texto = Text.Lower(texto) then Text.Combine(Ajustadas, " ")
    else texto
