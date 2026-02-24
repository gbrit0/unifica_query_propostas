import os
from dotenv import load_dotenv

load_dotenv(override=True)

POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_HOST = os.getenv("POSTGRES_HOST")
POSTGRES_PORT = os.getenv("POSTGRES_PORT")
POSTGRES_DB = os.getenv("POSTGRES_DB")

MYSQL_USER = os.getenv("MYSQL_USER")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD")
MYSQL_HOST = os.getenv('MYSQL_HOST')
MYSQL_PORT = os.getenv('MYSQL_PORT')
MYSQL_DB = os.getenv('MYSQL_DB')

MSSQL_USER = os.getenv("MSSQL_USER")
MSSQL_PASSWORD = os.getenv("MSSQL_PASSWORD")
MSSQL_HOST = os.getenv("MSSQL_HOST")
MSSQL_PORT = os.getenv("MSSQL_PORT")
MSSQL_DB = os.getenv("MSSQL_DB")

if not all([POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_HOST, POSTGRES_PORT, POSTGRES_DB]):
    raise ValueError("Variáveis de ambiente para PostgreSQL não estão completamente definidas. Verifique o arquivo .env.")

if not all([MYSQL_USER, MYSQL_PASSWORD, MYSQL_HOST, MYSQL_PORT, MYSQL_DB]):
    raise ValueError("Variáveis de ambiente para MySQL não estão completamente definidas. Verifique o arquivo .env.")

if not all([MSSQL_USER, MSSQL_PASSWORD, MSSQL_HOST, MSSQL_PORT, MSSQL_DB]):
    raise ValueError("Variáveis de ambiente para SQLServer não estão completamente definidas. Verifique o arquivo .env.")
    
config = {
    # comentado pois atualmente não há consultas para postgres
    # "postgres": {
    #     "database_url": f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}",
    #     "consultas": [
    #         "risco.sql",
    #     ]
        
    # },
    # comentado pois atualmente não há consultas para mysql
    # "mysql": { 
    #     "database_url": f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DB}",
    #     "consultas": [
    #         "risco.sql",
            
    #     ],
    # },
    "mssql": {
        "database_url": f"mssql+pyodbc://{MSSQL_USER}:{MSSQL_PASSWORD}@{MSSQL_HOST},{MSSQL_PORT}/{MSSQL_DB}?driver=ODBC+Driver+17+for+SQL+Server",
        "consultas": [
            "clientes.sql",
            "pedidosDeVenda.sql",
            "statusOps.sql",
        ],
    },
}