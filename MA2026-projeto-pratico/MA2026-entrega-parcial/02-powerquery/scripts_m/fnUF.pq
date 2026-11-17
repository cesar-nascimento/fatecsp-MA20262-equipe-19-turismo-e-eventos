// fnUF -- devolve a sigla oficial da UF a partir da sigla ("ba") ou do nome ("Mato Grosso do Sul")
(valor as any) as nullable text =>
let
    Chave = fnChave(valor),
    Achados = Table.SelectRows(lst_UF, each fnChave([Sigla]) = Chave or fnChave([Nome]) = Chave)
in
    if Chave = null then null
    else if Table.IsEmpty(Achados) then fnLimparTexto(valor)
    else Achados{0}[Sigla]
