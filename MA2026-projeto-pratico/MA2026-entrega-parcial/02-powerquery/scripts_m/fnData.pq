// fnData -- aceita data, data/hora, número de série do Excel, número aaaammdd (20240315)
// ou texto d-m-aaaa / aaaa-m-d / aaaammdd. Data inexistente vira null (sem erro).
(valor as any) as nullable date =>
let
    Resultado =
        if valor = null then null
        else if valor is date then valor
        else if valor is datetime then Date.From(valor)
        else if valor is number then
            // 20240315 = aaaammdd gravado como número (defeito da base); senão é série do Excel
            (if valor >= 19000101 and valor <= 29991231 and Number.Mod(valor, 1) = 0
             then #date(Number.IntegerDivide(valor, 10000),
                        Number.Mod(Number.IntegerDivide(valor, 100), 100),
                        Number.Mod(valor, 100))
             else Date.From(valor))
        else
            let
                Texto = Text.Replace(Text.Trim(Text.From(valor)), "/", "-"),
                SoDigitos = Text.Length(Texto) = 8 and Text.Select(Texto, {"0".."9"}) = Texto,
                Partes = Text.Split(Texto, "-"),
                Data =
                    if SoDigitos then #date(Number.From(Text.Start(Texto, 4)),
                                            Number.From(Text.Middle(Texto, 4, 2)),
                                            Number.From(Text.End(Texto, 2)))
                    // se a 1ª parte tem 4 dígitos, é ano-mês-dia; senão, dia-mês-ano
                    else if Text.Length(Partes{0}) = 4
                        then #date(Number.From(Partes{0}), Number.From(Partes{1}), Number.From(Partes{2}))
                        else #date(Number.From(Partes{2}), Number.From(Partes{1}), Number.From(Partes{0}))
            in
                Data
in
    // #date(2024, 2, 31) gera erro: try...otherwise transforma em null
    try Resultado otherwise null
