import pandas as pd
import sqlalchemy
import pymysql
import os

enade = pd.read_csv(
    "/raw-data/microdados_enade_2019.txt",
    sep = ';',
    decimal = ',',
    low_memory=False
)

MYSQL_CONN_STRING = os.getenv('MYSQL_CONN_STRING')

# TP_SEXO = sexo
# NU_IDADE = idade
# QE_I02 = raça
# QE_I08 = renda familiar
# QE_I17 = tipo de escola que cursou EM

enade = enade[['TP_SEXO', 'NU_IDADE', 'QE_I02', 'QE_I08', 'QE_I17']]


enade["SEXO"] = enade.TP_SEXO.replace({
    "M": "Masculino",
    "F": "Feminino"
})

enade["RENDA_FAMILIAR"] = enade.QE_I08.replace({
    "A": "Até 1,5 salarios",
    "B": "De 1,5 a 3 salarios",
    "C": "De 3 a 4,5 salarios",
    "D": "De 4,5 a 6 salarios",
    "E": "De 6 a 10 salarios",
    "F": "De 10 a 30 salarios",
    "G": "Acima de 30 salarios"
})

enade["COR"] = enade.QE_I02.replace({
    "A": "Branca",
    "B": "Preta",
    "C": "Amarela",
    "D": "Parda",
    "E": "Indígena",
    "F": pd.NA,
    " ": pd.NA
})

enade["TP_ESCOLA"] = enade.QE_I17.replace({
    "A": "Todo em escola publica.",
    "B": "Todo em escola privada (particular).",
    "C": "Todo no exterior.",
    "D": "A maior parte em escola publica.",
    "E": "A maior parte em escola privada (particular).",
    "F": "Parte no Brasil e parte no exterior.",
})


enade = enade.drop(columns=['TP_SEXO','QE_I02', 'QE_I08', 'QE_I17'])


SQLALCHEMY_DATABASE_URI = MYSQL_CONN_STRING
engine = sqlalchemy.create_engine(
    SQLALCHEMY_DATABASE_URI
)

enade.to_sql("enade_tratado", con=engine, index=False, if_exists='append', chunksize=1000)

# print(enade.head)
# print(enade.values)
print(dict(enade.dtypes))