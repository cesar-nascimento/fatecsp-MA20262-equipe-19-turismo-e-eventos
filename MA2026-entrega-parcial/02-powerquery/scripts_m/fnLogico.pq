// fnLogico -- TRUE/FALSE, S/N, Sim/Não, 1/0 -> true/false
(valor as any) as nullable logical =>
let
    Chave = fnChave(valor)
in
    if Chave = null then null
    else if List.Contains({"TRUE", "VERDADEIRO", "SIM", "S", "1"}, Chave) then true
    else if List.Contains({"FALSE", "FALSO", "NAO", "N", "0"}, Chave) then false
    else null
