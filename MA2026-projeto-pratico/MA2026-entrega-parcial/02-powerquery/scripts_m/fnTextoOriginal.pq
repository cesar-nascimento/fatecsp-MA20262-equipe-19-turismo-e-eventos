// fnTextoOriginal -- mostra o valor bruto como texto em Rejeitados (sem tratar)
(valor as any) as text =>
    if valor = null then "(vazio)"
    else if valor is datetime then DateTime.ToText(valor, "dd/MM/yyyy")
    else if valor is date then Date.ToText(valor, "dd/MM/yyyy")
    else Text.From(valor, "pt-BR")
