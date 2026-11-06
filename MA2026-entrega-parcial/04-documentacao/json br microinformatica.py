import pandas as pd
import random
from datetime import datetime, timedelta
import os

# Destinos turísticos brasileiros e suas capacidades hoteleiras
localidades = [
    {"cidade": "Rio de Janeiro", "estado": "RJ", "regiao": "Sudeste", "capacidade": 50000},
    {"cidade": "Gramado", "estado": "RS", "regiao": "Sul", "capacidade": 15000},
    {"cidade": "Porto Seguro", "estado": "BA", "regiao": "Nordeste", "capacidade": 20000},
    {"cidade": "Campos do Jordão", "estado": "SP", "regiao": "Sudeste", "capacidade": 12000},
    {"cidade": "Foz do Iguaçu", "estado": "PR", "regiao": "Sul", "capacidade": 18000},
    {"cidade": "Bonito", "estado": "MS", "regiao": "Centro-Oeste", "capacidade": 8000}
]

dados = []
data_inicio = datetime(2023, 1, 1)

# Gerando 1.000 registros (dias analisados)
for i in range(1, 1001):
    loc = random.choice(localidades)
    data_atual = data_inicio + timedelta(days=random.randint(0, 730)) # Datas entre 2023 e 2024
    mes = data_atual.month
    
    sazonalidade = "Baixa Temporada"
    evento = "Sem Evento"
    tipo_evento = "N/A"
    fator_ocupacao = random.uniform(0.3, 0.6) # Ocupação normal: 30% a 60%
    
    # Lógica de Negócio: Feriados e Alta Temporada aumentam a ocupação e geram eventos
    if mes in [12, 1]:
        sazonalidade = "Alta Temporada"
        evento = "Festas de Fim de Ano"
        tipo_evento = "Comemoração"
        fator_ocupacao = random.uniform(0.7, 0.98)
    elif mes == 2:
        sazonalidade = "Carnaval"
        evento = "Carnaval"
        tipo_evento = "Festa Popular"
        fator_ocupacao = random.uniform(0.85, 1.0)
    elif mes == 7:
        sazonalidade = "Férias de Julho"
        if loc['cidade'] in ["Gramado", "Campos do Jordão"]:
            evento = "Festival de Inverno"
            tipo_evento = "Cultura"
            fator_ocupacao = random.uniform(0.85, 1.0)
        else:
            fator_ocupacao = random.uniform(0.6, 0.85)
            
    # Eventos aleatórios fora de época
    if evento == "Sem Evento" and random.random() < 0.15:
        evento = random.choice(["Congresso Nacional", "Festival de Música", "Evento Esportivo", "Feira Gastronômica"])
        tipo_evento = "Corporativo/Lazer"
        fator_ocupacao += random.uniform(0.2, 0.4)
        
    fator_ocupacao = min(1.0, fator_ocupacao) # Limita a ocupação a 100%
    
    # Cálculos das métricas
    hospedagens_ocupadas = int(loc['capacidade'] * fator_ocupacao)
    taxa_ocupacao = round((hospedagens_ocupadas / loc['capacidade']) * 100, 2)
    visitantes = int(hospedagens_ocupadas * random.uniform(1.2, 2.5))
    
    # Lógica de Avaliação: Lugares lotados (filas, etc.) podem gerar avaliações ligeiramente mais baixas
    avaliacao = round(random.uniform(3.8, 5.0) if fator_ocupacao < 0.8 else random.uniform(3.0, 4.5), 1)

    registro = {
        "ID_Registro": i,
        "Data": data_atual.strftime("%Y-%m-%d"),
        "Localidade": loc["cidade"],
        "Estado": loc["estado"],
        "Regiao": loc["regiao"],
        "Sazonalidade": sazonalidade,
        "Nome_Evento": evento,
        "Tipo_Evento": tipo_evento,
        "Hospedagens_Disponiveis": loc["capacidade"],
        "Hospedagens_Ocupadas": hospedagens_ocupadas,
        "Taxa_Ocupacao_Perc": taxa_ocupacao,
        "Visitantes_Estimados": visitantes,
        "Avaliacao_Media_Dia": avaliacao
    }
    dados.append(registro)

# Criando a tabela e ordenando por data
df = pd.DataFrame(dados)
df = df.sort_values(by="Data")

# Salvando os arquivos
df.to_json("Base_Turismo_Brasil.json", orient="records", force_ascii=False, indent=4)
df.to_csv("Base_Turismo_Brasil.csv", index=False, encoding="utf-8-sig")

print(f"✅ Arquivos gerados com sucesso e salvos na pasta:\n{os.getcwd()}")