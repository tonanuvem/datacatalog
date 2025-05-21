# Rodar em cluster nao estava funcionando, vamos rodar local.

curl -sL -o docker-compose-metadata.yml https://github.com/open-metadata/OpenMetadata/releases/download/1.7.0-release/docker-compose.yml

docker-compose -f docker-compose-metadata.yml up -d

AIRFLOW_msglog="INFO - Starting the scheduler"
OPENMETADATA_msglog="Started application"

echo ""
echo "Aguardando a configuração do OPEN METADATA."
while [ "$(docker logs openmetadata_ingestion 2>&1 | grep "$AIRFLOW_msglog" | wc -l)" != "1" ]; do
  printf "."
  sleep 1
done
while [ "$(docker logs openmetadata_server 2>&1 | grep "$OPENMETADATA_msglog" | wc -l)" != "1" ]; do
  printf "."
  sleep 1
done
