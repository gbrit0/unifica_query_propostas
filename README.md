# Unificação de consultas SQL

Este repositório contém um script para unificar e executar consultas SQL em múltiplos bancos (Postgres, MySQL, SQL Server). Ele foi desenvolvido como parte do projeto "Sistema de Proposta BRG" para facilitar a execução centralizada de consultas distribuídas por diferentes bancos.

Arquivos principais
- `consultas.py`: executa as consultas declaradas no arquivo de configuração e entrega os resultados para posterior processamento.
- `config.py`: contém a configuração (variáveis e lista de consultas) utilizada por `consultas.py`.

Visão geral
O `config.py` expõe uma estrutura (JSON/Python) chamada `config` com as entradas para cada banco suportado. Cada entrada contém a `database_url` (usada pelo SQLAlchemy) e uma lista `consultas` com caminhos relativos para arquivos `.sql` que serão executados.

Principais pontos:
- Os arquivos `.sql` devem ficar no mesmo diretório referenciado em `config.py` (ou usar caminhos relativos corretos).
- Para cada banco listado no `config` o `consultas.py` cria uma conexão via SQLAlchemy e executa as consultas da lista.
- O processamento dos resultados (agregação, escrita em arquivo, etc.) deve ser implementado onde indicado em `consultas.py`.

Requisitos
- Python (recomenda-se 3.8+)
- Dependências estão listadas em `requirements.txt` (ex.: SQLAlchemy, python-dotenv, drivers de BD).

Instalação
1. Crie e ative um ambiente virtual:

```bash
python -m venv .venv
source .venv/bin/activate
```

2. Instale as dependências:

```bash
pip install -r requirements.txt
```

Configuração de variáveis de ambiente
O projeto usa `python-dotenv` para carregar variáveis do arquivo `.env`. Copie o exemplo e ajuste as credenciais/URLs:

```bash
cp .env.example .env
# edite .env com host, porta, usuário, senha e database_url adequados
```

Uso
Execute o script `consultas.py` como ponto de entrada. Por exemplo:

```bash
python consultas.py
```

Comportamento padrão:
- O `main()` em `consultas.py` lê a variável `config` de `config.py`.
- Para cada instância declarada em `config` o script cria uma conexão usando `database_url` e executa cada arquivo de consulta listado em `consultas`.
- O resultado de cada consulta fica disponível na variável `resultado` dentro do loop — é aí que você deve adicionar a lógica de processamento (salvar em arquivo, consolidar, etc.).

Como estender
- Para adicionar novas consultas: coloque o arquivo `.sql` no diretório apropriado e adicione seu caminho à lista `consultas` dentro do objeto correspondente no `config`.
- Para adicionar um novo banco: duplique a estrutura do objeto do banco no `config` e aponte uma nova `database_url`.

Dependências de drivers
- Para Postgres: `psycopg2-binary`
- Para MySQL: `PyMySQL`
- Para SQL Server: `pyodbc` (verifique o driver ODBC do SO)

Notas finais
- Este repositório oferece a execução e unificação das consultas; a lógica de transformação/armazenamento dos resultados fica a cargo do integrador.