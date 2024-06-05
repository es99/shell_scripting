#!/usr/bin/env bash
#
# Script que realizar um dump da base de dados do Mongo DB rodando em container
# no diretório corrente.
# Author: Engels Souza - engels.franca@gmail.com
# Version: 1.0
# Data: 11/06/2023
#

USER=$1
PASSWORD=$2
CONTAINER_NAME=$3
DB_NAME=$4
DATA=$(date +%d-%m-%Y)
DUMP_NAME=$5

if [[ $# -ne 5 ]]; then
	echo "Uso => $0 <user_admin> <password_admin> <nome_do_container> <nome_da_database> <nome_do_dump>"
	exit 1
fi

docker exec $CONTAINER_NAME sh -c \
	"mongorestore --authenticationDatabase admin -u '$USER'  -p '$PASSWORD' --db $DB_NAME --archive" < $DUMP_NAME

echo "Banco $DB_NAME restaurado com sucesso!"
