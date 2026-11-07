// fnValorOficial -- devolve a grafia da lista oficial, ignorando caixa, acentos, espaços e hífens.
// Antes procura apelidos em DeParaValores ("Pous." -> "Pousada"). Sem correspondência: mantém o texto limpo.
(valor as any, lista as list) as nullable text =>
let
    Limpo = fnLimparTexto(valor),
    Chave = fnChave(Limpo),
    Apelido = List.First(Table.SelectRows(DeParaValores, each fnChave([Variante]) = Chave)[Oficial], null),
    Encontrados = List.Select(lista, each fnChave(_) = Chave)
in
    if Limpo = null then null
    else if Apelido <> null then Apelido
    else if not List.IsEmpty(Encontrados) then Encontrados{0}
    else Limpo
