// lst_UF -- siglas e nomes das 27 unidades da federação
let
    Tabela = #table(type table [Sigla = text, Nome = text], {
        {"AC", "Acre"}, {"AL", "Alagoas"}, {"AP", "Amapá"}, {"AM", "Amazonas"}, {"BA", "Bahia"},
        {"CE", "Ceará"}, {"DF", "Distrito Federal"}, {"ES", "Espírito Santo"}, {"GO", "Goiás"},
        {"MA", "Maranhão"}, {"MT", "Mato Grosso"}, {"MS", "Mato Grosso do Sul"}, {"MG", "Minas Gerais"},
        {"PA", "Pará"}, {"PB", "Paraíba"}, {"PR", "Paraná"}, {"PE", "Pernambuco"}, {"PI", "Piauí"},
        {"RJ", "Rio de Janeiro"}, {"RN", "Rio Grande do Norte"}, {"RS", "Rio Grande do Sul"},
        {"RO", "Rondônia"}, {"RR", "Roraima"}, {"SC", "Santa Catarina"}, {"SP", "São Paulo"},
        {"SE", "Sergipe"}, {"TO", "Tocantins"}
    })
in
    Tabela
