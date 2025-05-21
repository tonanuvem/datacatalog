# TRABALHO CONTEMPLA AS SEGUINTES FERRAMENTAS:

docker network create app_net


## MYSQL e KAFKA 

echo ""
echo "Executando os componentes da solução:"
echo ""
docker-compose -f docker-compose-curso.yml up -d
echo ""



### JUPYTER NOTEBOOK PARA REALIZAR OS TESTES:

docker-compose -f docker-compose-jupyter.yml up -d


### OPEN METADATA PARA DEMONSTRAR GOVERNANÇA DE DADOS, ESPECIALMENTE DATA DISCOVERY E DATA QUALITY

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

echo ""
echo "Configurando o CDC"
echo ""
sh config_cdc.sh

### URLs DO PROJETO:

IP=$(curl -s checkip.amazonaws.com)
echo "Aguardando TOKEN (geralmente 1 min)"
while [ "$(docker logs datacatalog-automl-1 2>&1 | grep token | grep 127. | grep NotebookApp | wc -l)" != "1" ]; do
  printf "."
  sleep 1
done
echo "Token Pronto."
TOKEN=$(docker logs datacatalog-automl-1 2>&1 | grep token | grep 127. | grep NotebookApp | sed -n 's/.*?token=\([a-f0-9]*\).*/\1/p')
echo ""
echo "Aguardando MySQL."
while [ "$(docker logs datacatalog-cursomysql-1 2>&1 | grep "port: 3306  MySQL Community Server" | wc -l)" != "1" ]; do
  printf "."
  sleep 1
done

echo ""
echo ""
echo "Config OK"
echo ""
echo ""
echo "URLs do projeto:"
echo ""
echo " - PHPMYADMIN MYSQL UI  : http://$IP:8082"
echo ""
echo " - KAFKA UI             : http://$IP:8070"
echo ""
echo " - JUPYTER AUTO ML      : http://$IP:8789/?token=$TOKEN"
echo ""
echo " - OPEN METADATA        : http://$IP:8585   (login = admin@open-metadata.org, password = admin)"
echo ""
