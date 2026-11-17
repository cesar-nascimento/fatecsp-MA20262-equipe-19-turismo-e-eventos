// cad_Etapa1 -- lista tudo o que existe no arquivo da Etapa 1 (abas, tabelas, nomes)
let
    Fonte = Excel.Workbook(File.Contents(pArquivoEtapa1), null, true)
in
    Fonte
