// fnLimparTexto -- equivalente ao ARRUMAR: tira espaços das pontas e espaços repetidos no meio
(texto as any) as nullable text =>
let
    Limpo =
        if texto = null then null
        else Text.Combine(List.Select(Text.Split(Text.Trim(Text.From(texto)), " "), each _ <> ""), " ")
in
    if Limpo = "" then null else Limpo
