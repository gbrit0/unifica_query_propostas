# Unificação das query

Conforme solicitado no projeto 'Sistema de Proposta BRG para o comercial' foi desenvolvido script que é capaz de unificar querys para execução.

O programa consiste de dois arquivos python: [consultas.py](consultas.py) e [config.py](config.py).

### config.py

Este é o arquivo de configuração do script. Nele são declaradas as variáveis de ambiente principais, relacionadas aos bancos de dados, tornando-as disponíveis na variável 'config'. O código define um json que contém, para cada banco de dados, a url de conexão e as consultas correspondentes. Os bancos de dados declarados são o postgres, mysql e sqlserver (mssql). É possível replicar os objetos declarados no json para incluir instancias de bancos de dados diferentes declarando novas variáveis e modificando a url de conexão (database_url). As consultas devem estar presentes no mesmo diretório do arquivo de configuração e são declaradas na lista `consultas` dentro do objeto correspondente de cada banco. 

Para futura expansão das consultas basta incluir o arquivo sql no mesmo diretório e referenciá-lo na lista de consultas do banco correspondente.

Para que o arquivo funcione corretamente é necessário que as variáveis de ambiente sejam declaradas no .env de acordo com .env.example. 

### consultas.py

Esse arquivo é quem realiza as consultas importando a variável 'config' do arquivo [config.py](config.py) e percorrendo o json em busca dos bancos de dados registrados e suas respectivas urls de conexão e consultas. Se conecta a cada banco por meio da biblioteca sqlalchemy e busca o resultado de cada consulta. A partir deste ponto deve-se incluir a lógica de processamento dos dados conforme necessário.

## Instalação

1. Criar um ambiente virtual e ativá-lo:

```bash
python -m venv .venv
source .venv/bin/activate
```

2. Instalar dependências:

```bash
pip install -r requirements.txt
```

3. Fornecer variáveis de ambiente:

O script usa `python-dotenv` para carregar as variáveis do arquivo `.env`. O arquivo deve replicar `.env.example`

```bash
cp .env.example .env
```

Modifique os valores para credenciais reais de acesso bem como host, porta e nome do banco de dados.

## Uso

O ponto de entrada é o arquivo `consultas.py`. Por padrão a função `main()` lê o json de configuração criado em `config.py` e itera sobre os valores declarados. Para cada banco realiza a conexão via `sqlalchemy` usando `database_url` e executa cada consulta disponível na lista `consultas` disponibilizando o resultado na variável `resultado`. O processamento do resultado deve ser incluído dentro do loop após retorno do resultado.