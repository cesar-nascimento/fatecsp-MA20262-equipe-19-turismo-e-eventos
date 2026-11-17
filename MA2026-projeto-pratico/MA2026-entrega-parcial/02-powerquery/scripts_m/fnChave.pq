// fnChave -- chave de comparação: MAIÚSCULAS, sem acento, só letras e dígitos
// ("Apart Hotel", "apart-hotel " e "Apart-hotel" viram APARTHOTEL)
(texto as any) as nullable text =>
let
    Limpo = fnLimparTexto(texto)
in
    if Limpo = null then null
    else Text.Select(Text.Upper(fnSemAcento(Limpo)), {"A".."Z", "0".."9"})
