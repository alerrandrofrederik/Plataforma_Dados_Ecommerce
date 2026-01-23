# %%
import io
import pandas as pd
import boto3
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os


load_dotenv()

# ============================================
# PASSO 1: Conectar com DataLake e Ler Parquet
# ============================================

# Instalar boto3: pip install boto3
# Configurações do DataLake

# def get_datalake_config():
#     S3_ENDPOINT_URL = os.getenv("S3_ENDPOINT_URL")
#     AWS_REGION = os.getenv("AWS_REGION")
#     AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
#     AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
#     BUCKET_NAME = os.getenv("BUCKET_NAME")

S3_ENDPOINT_URL = os.getenv("S3_ENDPOINT_URL")
AWS_REGION = os.getenv("AWS_REGION")
AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
BUCKET_NAME = os.getenv("BUCKET_NAME")

# Criar cliente S3
s3 = boto3.client(
    "s3",
    region_name=AWS_REGION,
    endpoint_url=S3_ENDPOINT_URL,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
)


# Listar arquivos no bucket
response = s3.list_objects(Bucket=BUCKET_NAME)
arquivos = [obj["Key"] for obj in response["Contents"]]
# print("Arquivos no bucket:", arquivos)

# Baixar arquivo Parquet
FILE_KEY = "preco_competidores.parquet"
response = s3.get_object(Bucket=BUCKET_NAME, Key=FILE_KEY)
parquet_bytes = response["Body"].read()

# %%
# Converter Parquet para DataFrame
df_precos = pd.read_parquet(io.BytesIO(parquet_bytes))

# %%
# ============================================
# PASSO 2: Salvar no PostgreSQL (sem processamento)
# ============================================

# Instalar: pip install sqlalchemy psycopg2-binary
# Configurações do PostgreSQL (Supabase)
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")

# Criar conexão SQLAlchemy
DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(DATABASE_URL)

# %%
# Salvar DataFrame exatamente como vem do Parquet
df_precos.to_sql(
    "preco_competidores",  # Nome da tabela
    engine,  # Engine de conexão
    schema="public",  # Esquema
    if_exists="replace",  # Substituir se existir
    index=False  # Não salvar índice
)

# %%
# Verificar dados salvos
df_verificacao = pd.read_sql_query("SELECT * FROM preco_competidores LIMIT 5", engine)
df_verificacao

# %%
# Fechar conexão
engine.dispose()

