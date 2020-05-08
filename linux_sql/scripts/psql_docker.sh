#!/bin/bash
#Setup arguments

#Main code
#check if docker_deamon is running - otherwise start run
systemctl status docker || systemctl start docker

#check if user wants to create new psql table
if [ $1 == "create" ]; then
  #list all docker containers and filter for jrvs-psql and then counts words in name
  if  [ "$(docker ps -a -f name=jrvs-psql | wc -l)" == "2" ]; then
    echo "Error: Container already exists"
    exit 1

  elif [ "$#" != 4 ]; then
    echo "Error: database username or password not passed"
    exit 1

  else
    docker pull postgres
    docker volume create pgdata
    export db_user=$2
    export db_pass=$3
    docker run --name jrvs-psql -e POSTGRES_PASSWORD=$db_pass \
    -e POSTGRES_USER=$db_user -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
    exit $?
    fi

elif  [ "$(docker ps -a -f name=jrvs-psql | wc -l)" != "2" ]; then
    echo "Error: Container not created"
    exit 1

else
  if [ $1 == "start" ]; then
    docker container start jrvs-psql
    exit $?

  elif [ $1 == "stop" ]; then
    docker container start jrvs-psql
    docker container stop jrvs-psql
    exit $?

  else
    echo "Error: Invlaid argument"
    exit 1
    fi
fi