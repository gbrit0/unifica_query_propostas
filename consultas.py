from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv
from config import config

def main():
    for db_name, db_config in config.items():
        url = db_config["database_url"]
        
        engine = create_engine(url)
        
        with engine.connect() as conexao:
            for query in db_config["consultas"]:
                resultado = conexao.execute(text(open(query).read()))
                
                # Processar o resultado conforme necessário.
                
                
if __name__ == '__main__': 
    main()