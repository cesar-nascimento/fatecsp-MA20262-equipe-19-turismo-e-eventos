// fnInteiroPositivo -- capacidade em número inteiro: "59.0" -> 59, "139 UHs" -> 139; "N/I", 0 ou negativo -> null
(valor as any) as nullable number =>
let
    Numero =
        if valor = null then null
        else if valor is number then valor
        else Number.From(Text.Select(Text.BeforeDelimiter(Text.Trim(Text.From(valor)), "."), {"0".."9"})),
    Resultado = if Numero = null or Numero <= 0 then null else Number.Round(Numero, 0)
in
    try Resultado otherwise null
