// fnSemAcento -- troca letras acentuadas pela letra sem acento (usada só nas chaves de comparação)
(texto as nullable text) as nullable text =>
let
    Pares = {{"á","a"},{"à","a"},{"â","a"},{"ã","a"},{"ä","a"},{"é","e"},{"è","e"},{"ê","e"},{"ë","e"},
             {"í","i"},{"ì","i"},{"î","i"},{"ï","i"},{"ó","o"},{"ò","o"},{"ô","o"},{"õ","o"},{"ö","o"},
             {"ú","u"},{"ù","u"},{"û","u"},{"ü","u"},{"ç","c"},{"ñ","n"},
             {"Á","A"},{"À","A"},{"Â","A"},{"Ã","A"},{"Ä","A"},{"É","E"},{"È","E"},{"Ê","E"},{"Ë","E"},
             {"Í","I"},{"Ì","I"},{"Î","I"},{"Ï","I"},{"Ó","O"},{"Ò","O"},{"Ô","O"},{"Õ","O"},{"Ö","O"},
             {"Ú","U"},{"Ù","U"},{"Û","U"},{"Ü","U"},{"Ç","C"},{"Ñ","N"}}
in
    if texto = null then null
    else List.Accumulate(Pares, texto, (acumulado, par) => Text.Replace(acumulado, par{0}, par{1}))
