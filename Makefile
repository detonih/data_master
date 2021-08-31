build:
	docker build -t hadoop-cluster .

run:
	docker run -itd --name hadoop-env --hostname localhost -v /home/detonih/Documents/data_master/project/data_master/raw-data:/raw-data -v /home/detonih/Documents/data_master/project/data_master/scripts:/scripts -p 8888:8888 -p 8998:8998 -p 4040:4040 -p 50070:50070 -p 50075:50075 -p 8088:8088 -p 8042:8042 hadoop-cluster:latest

up:
	docker-compose up

bash:
	docker exec -it hadoop-env /bin/bash

mysql:
	docker exec -it data_master_db /bin/bash

mongo:
	docker exec -it data_master_mongo_db /bin/bash


prune:
	docker stop hadoop-env 
	docker stop data_master_db
	docker stop data_master_mongo_db
	docker container prune

ddl:
	docker exec -i data_master_db mysql -u root -p${MYSQL_ROOT_PASSWORD} < ./scripts/sql/enade_ddl.sql
