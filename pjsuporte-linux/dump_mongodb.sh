#!/usr/bin/env bash
#
# Script que realizar um dump da base de dados do Mongo DB rodando em container
# no diretório corrente, após isso o arquivo .dump é enviado para o bucket no S3
# Author: Engels Souza - engels.franca@gmail.com
# Version: 2.1.0 -> 2.2.0 (05/06/2024) 
# Data: 11/06/2023
#

DATA=$(date +%d-%m-%Y)
ARQ_LOG="/var/log/dump-mongodb-logs.log"
LINHA="------------------------------------------------------------------"
CONTAINER_ID=$(docker container ls | grep -w "mongo" | grep -v "mongo-express" | cut -f1 -d' ')
VERIFICA_CONTAINERS=$(docker container ls | wc -l)

if [ $VERIFICA_CONTAINERS -eq 1 ]; then
       echo "Não existem containers em execução, saindo..."
       exit 1
fi
echo "Existem containers em execucao, verificando..."
sleep 1
echo $LINHA >> $ARQ_LOG

if [[ -n "$(find . -maxdepth 1 -name "*.dump" -print -quit)" ]]; then #Verifica se existem arquivos .dump anteriores e os remove
	echo "Arquivos .dump encontrados, removendo..."
	rm *.dump
fi

echo "Realizando dump do banco logSIGP em $DATA" >> $ARQ_LOG

docker exec $CONTAINER_ID sh -c \
	"mongodump --authenticationDatabase admin -u infopublicpb  -p Eredopor5318* --db logSIGP --archive" > logSIGP-$DATA.dump 2>&1

echo "Dump realizado..." >> $ARQ_LOG
echo "enviando arquivo de dump para o S3" >> $ARQ_LOG

aws s3 cp logSIGP-$DATA.dump s3://mongodb-notas/ >> $ARQ_LOG

echo "Arquivo enviado, backup concluído" >> $ARQ_LOG

