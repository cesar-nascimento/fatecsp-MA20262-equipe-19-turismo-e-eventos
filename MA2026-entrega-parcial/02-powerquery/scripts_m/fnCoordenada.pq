// fnCoordenada -- latitude/longitude em graus decimais.
// Corrige números sem a vírgula (-9974700 -> -9,9747), texto com ponto ("0.034900"),
// texto com hemisfério ("S 3.145213°") e devolve null para "N/D", zero ou fora do Brasil.
(valor as any, minimo as number, maximo as number) as nullable number =>
let
    Bruto =
        if valor = null then null
        else if valor is number then valor
        else
            let
                Texto = Text.Upper(Text.Trim(Text.From(valor))),
                Negativo = Text.StartsWith(Texto, "S") or Text.StartsWith(Texto, "W") or Text.StartsWith(Texto, "O"),
                Numero = Number.FromText(Text.Select(Texto, {"0".."9", ".", "-"}), "en-US")
            in
                if Negativo then -Number.Abs(Numero) else Numero,
    Escala = if Bruto = null then null else if Number.Abs(Bruto) > 180 then Bruto / 1000000 else Bruto,
    Resultado = if Escala = null or Escala = 0 or Escala < minimo or Escala > maximo then null else Number.Round(Escala, 6)
in
    try Resultado otherwise null
